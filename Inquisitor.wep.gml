#define init
global.sprInquisitor  = sprite_add_weapon("sprites/Inquisitor.png", 7, 4);
global.stripes 				= sprite_add("defpack tools/BIGstripes.png",1,1,1)
global.SnakeIndikator = sprite_add("sprites/projectiles/Inquisitor Danger.png",0,3,11)
#define weapon_name
return "INQUISITOR"

#define weapon_sprt
return global.sprInquisitor;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 43;

#define weapon_cost
return 12;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 15;

#define weapon_text
return "DEVASTATION++";

#define weapon_fire
sound_play_pitch(sndSewerPipeBreak,.2)
sound_play_pitch(sndUltraLaser,.7)
sound_play_pitch(sndHyperLauncher,.4)
sound_play_pitch(sndPlasmaBig,.6)
sound_play_pitch(sndPlasmaReload,1.4)
sound_play_pitch(sndPlasmaBigUpg,.8)
if skill_get(17)=1{sound_play_pitch(sndLaserCannon,.4)}
sound_play_pitch(sndLaserCannonUpg,1.6)
motion_add(gunangle,-9)
weapon_post(18,12,400)
with instance_create(x,y,CustomProjectile)
{
	move_contact_solid(other.gunangle,12)
	accuracy = other.accuracy
	sprite_index = sprPlasmaBallBig
	mask_index = mskPlasma
	image_speed = 0.0002
	ammo = 4
	typ = 1
	damage = 7
	team = other.team
	friction = 1.2
	image_xscale = .3 + ammo/3
	image_yscale = .3 + ammo/3
	motion_add(other.gunangle,ammo * 6)
	image_angle = direction
	on_hit 		 = mitosis_hit
	on_step    = mitosis_step
	on_draw		 = mitosis_draw
	on_destroy = mitosis_destroy
}

#define mitosis_hit
if projectile_canhit_melee(other)
{
	projectile_hit(other,damage,ammo * 2,direction)
	if other.my_health >= damage{instance_destroy()}
}

#define mitosis_step
if image_speed > 0 {image_speed -= 0.0001*current_time_scale}else{image_speed = 0}
image_index = 0
if irandom(ammo)*current_time_scale != 0{instance_create(x+random_range(-sprite_get_width(sprite_index)/2,sprite_get_width(sprite_index)/2),y+random_range(-sprite_get_width(sprite_index)/2,sprite_get_width(sprite_index)/2),PlasmaTrail)}
if speed < friction{instance_destroy()}

#define mitosis_destroy
if ammo > 1
{
	if skill_get(17) = false sound_play_pitch(sndPlasmaBigExplode,ammo/2) else sound_play_pitch(sndPlasmaBigExplodeUpg,ammo/2)
	var i = direction + 90;
	var j = random(360);
	repeat(ammo)
	{
		with instance_create(x,y,CustomProjectile)
		{
			accuracy = other.accuracy
			sprite_index = sprPlasmaBallBig
			mask_index = mskPlasma
			image_speed = 0.0002
			typ = 1
			ammo = other.ammo - 1
			damage = 7
			team = other.team
			friction = random_range(.6,1)
			image_xscale = .3 + ammo/3
			image_yscale = .3 + ammo/3
			motion_add(other.direction+i+j+ random_range(-8,8)*accuracy,9+ammo)
			image_angle = direction
			on_hit 		 = mitosis_hit
			on_step    = mitosis_step
			on_draw		 = mitosis_draw
			on_destroy = mitosis_destroy
		}
		i += 360/ammo
	}
}
else
{
	sound_play_pitch(sndPlasmaHit,random_range(.8,1.2))
	with instance_create(x,y,PlasmaImpact)
	{
		team = other.team
	}
}

#define mitosis_draw
if image_speed > 0 {var k = 2}else{var k = 1}
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale+sin(current_frame)/clamp(speed,.5,50)*k, image_yscale+sin(current_frame)/clamp(speed,.5,50)*k, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale+sin(current_frame)/clamp(speed,.5,50)*k, 2*image_yscale+sin(current_frame)/clamp(speed,.5,50)*k, image_angle, image_blend, 0.1+skill_get(17)*.1+(k-1)*.3);
draw_set_blend_mode(bm_normal);

/*
var _strtsize = 44;
var _endsize  = 16;
with mod_script_call("mod","defpack tools","create_abris",self,44,16,argument0)
{
	creator = other
	accspeed = 1.03
	payload = script_ref_create(pop)
	lasercolour1 = $00FF00
	lasercolour = lasercolour1
	lasercolour2 = $00AF00
	offset = random(360)
	offset2 = random(360)
	circlemass = 16
	snakemass = 3
	on_draw = abris_draw_inquisitor
}
sound_play_pitch(sndSniperTarget,exp((room_speed/current_time_scale/accuracy*(.0003))))

#define Plasmasnake_step
repeat(4)with instance_create(x+random_range(-17,17),y+random_range(-17,17),PlasmaTrail){image_speed = irandom_range(4,5)/10}
if instance_exists(enemy){
	var closeboy = instance_nearest(x,y,enemy)
	if collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0 && distance_to_object(closeboy) < 200+skill_get(17*80){
		motion_add(point_direction(x,y,closeboy.x,closeboy.y),.94*(1+skill_get(17)))
		motion_add(direction,-.07)
		image_angle = direction
	}
}
if place_meeting(x + hspeed,y,Wall){
	hspeed *= -1
}
if place_meeting(x,y +vspeed,Wall){
	vspeed *= -1
}
timer -= 1
if timer = 0
{
	timer = 1
	repeat(snakemass - 2 + skill_get(17)*4)
	{
		with instance_create(x+random_range(-(ammo_origin-ammo)/5,(ammo_origin-ammo)/5),y+random_range(-(ammo_origin-ammo)/5,(ammo_origin-ammo)/5),CustomProjectile)
		{
			image_xscale = (random_range(0.5,0.75)-0.2) * other.ammo/other.ammo_origin +0.2*skill_get(17)/1.3
			image_yscale = image_xscale
			mask_index = mskPlasmaImpact
			sprite_index = sprPlasmaImpact
			image_speed = 0.4
			team = 2
			on_step = pi_step
			on_hit = pi_hit
			//on_draw = script_bind_draw(pi_draw,depth)
		}
	}
	with instance_create(x,y,CustomProjectile)
	{
		if skill_get(17){if irandom(4) = 0 {sound_play_pitch(sndPlasmaBigExplodeUpg,random_range(0.9,1.1)/(other.ammo/other.ammo_origin)*.2)}}
		else{if irandom(5) = 0 {sound_play_pitch(sndPlasmaBigExplode,random_range(0.9,1.1)/(other.ammo/other.ammo_origin)*.2)}}
		image_index = 1
		image_xscale = 0.7 * other.ammo/other.ammo_origin
		image_yscale = image_xscale
		mask_index = mskPlasmaImpact
		sprite_index = sprPlasmaImpact
		image_speed = 0.4
		team = 2
		on_step = pi_step
		on_hit = pi_hit
		//on_draw = script_bind_draw(pi_draw,depth)
	}
	ammo -= 1
}
if ammo = 0
{
	instance_destroy()
}

#define pop
sleep(500+skill_get(17)*300)
sound_play_pitch(sndSewerPipeBreak,.2)
sound_play_pitch(sndUltraLaser,.7)
sound_play_pitch(sndHyperLauncher,.4)
sound_play_pitch(sndPlasmaBig,.6)
sound_play_pitch(sndPlasmaReload,1.4)
sound_play_pitch(sndPlasmaBigUpg,.8)
if skill_get(17)=1{sound_play_pitch(sndLaserCannon,.4)}
sound_play_pitch(sndLaserCannonUpg,1.6)

with creator{motion_add(gunangle,-9);weapon_post(18,12,3000)}
repeat(12)instance_create(creator.x+lengthdir_x(random_range(-24,12),creator.gunangle),creator.y+lengthdir_y(random_range(-24,12),creator.gunangle),Dust)
//instance_destroy();exit
repeat(snakemass)
{
	with instance_create(mouse_x[index],mouse_y[index],CustomObject)
	{
		if !skill_get(17){with instance_create(mouse_x[other.index],mouse_y[other.index],CustomProjectile)
			{
				mask_index = mskPlasmaImpact
				sprite_index = sprPlasmaImpact
				image_speed = 0.4
				team = 2
				on_step = pi_step
				on_hit = pi_hit
				//on_draw = script_bind_draw(pi_draw,depth)
			}
		}
		else
		{
			with instance_create(mouse_x[other.index],mouse_y[other.index],CustomProjectile)
			{
				image_xscale = 1.5
				image_yscale = 1.5
				mask_index = mskPlasmaImpact
				sprite_index = sprPlasmaImpact
				image_speed = 0.4
				team = 2
				on_step = pi_step
				on_hit = pi_hit;
				//on_draw = script_bind_draw(pi_draw,depth)
				}
			}
		snakemass = other.snakemass
		ammo_origin = 85
		if skill_get(17){ammo_origin += 35}
		ammo = ammo_origin
		speed = 12
		if skill_get(17){speed += 3}
		creator = other.creator
		sprite_index = sprGrenade
		image_alpha = 0
		direction = other.offset
		timer = 1
		on_step = Plasmasnake_step
	}
	offset += 360/snakemass
}
repeat(circlemass)
{
	with instance_create(mouse_x[index]+lengthdir_x(acc+16,offset2),mouse_y[index]+lengthdir_y(acc+16,offset2),CustomProjectile)
	{
		image_xscale = .5
		image_yscale = .5
		image_speed = random_range(.3,.7)
		if !place_meeting(x,y,Floor){instance_destroy()}
	}
	offset2 += 360/circlemass
}

#define abris_draw_inquisitor
if instance_exists(creator) && check{
	x = creator.x
	y = creator.y
	if button_check(creator.index, (check = 1? "fire":"spec")){
		if !collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0){
			var radi = acc+accmin;
			mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, radi, 45, mouse_x[index]+1, mouse_y[index]+1, global.stripes, lasercolour1, 0.1+(accbase-acc)/(accbase*5),(current_frame mod 16)*.004);
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,radi,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,1*(accbase-acc))
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16, accmin,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,.2)
			if skill_get(17){mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,(acc+18)*1.5,2,acc+image_angle*-1,mouse_x[index],mouse_y[index],lasercolour1,1*(accbase-acc))}
			mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, (acc+16+skill_get(17)*2)*(1+skill_get(17)/2), 48, mouse_x[index]+1, mouse_y[index]+1,global.stripes, lasercolour, 0.1+(accbase-acc)/(accbase*6));
			draw_sprite_ext(global.SnakeIndikator,0,mouse_x[index]+lengthdir_x(acc+16,offset),mouse_y[index]+lengthdir_y(acc+16,offset),1-acc/accbase,1-(acc/accbase)/3,offset-90,c_white,1*(accbase-acc))
			draw_sprite_ext(global.SnakeIndikator,0,mouse_x[index]+lengthdir_x(acc+16,offset+120),mouse_y[index]+lengthdir_y(acc+16,offset+120),1-acc/accbase,1-(acc/accbase)/3,offset+120-90,c_white,1*(accbase-acc))
			draw_sprite_ext(global.SnakeIndikator,0,mouse_x[index]+lengthdir_x(acc+16,offset+120+120),mouse_y[index]+lengthdir_y(acc+16,offset+120+120),1-acc/accbase,1-(acc/accbase)/3,offset+120+120-90,c_white,1*(accbase-acc))
			draw_line_width_colour(x,y,mouse_x[index],mouse_y[index],1,lasercolour1,lasercolour1);
		}
		else{
			var q = instance_create(x,y,CustomObject);
			with q{
				mask_index = sprBulletShell
				image_angle = other.creator.gunangle
				move_contact_solid(image_angle,game_width)
			}
			draw_line_width_colour(x,y,q.x,q.y,1,lasercolour2,lasercolour2)
			with q instance_destroy()
		}
		var comp = (check = 1 ? creator.wep : creator.bwep);
		if popped {comp = wep}
		if wep != comp {instance_destroy()}
	}
}

#define pi_step
if image_index >= 6{instance_destroy()}

#define pi_hit
if projectile_canhit_melee(other)=true{projectile_hit(other,2,point_direction(other.x,other.y,x,y),-2)}

#define pi_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
/*draw_set_blend_mode(bm_one);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.2*(skill_get(17)*0.1));
draw_set_blend_mode(bm_normal);

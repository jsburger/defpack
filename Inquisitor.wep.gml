#define init
global.sprInquisitor = sprite_add_weapon("sprites/Inquisitor.png", 7, 4);
global.stripes = sprite_add("defpack tools/BIGstripes.png",1,1,1)
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
return 67;

#define weapon_cost
return 12;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 13;

#define weapon_text
return "DEVASTATION++";

#define weapon_fire
sound_play_pitch(sndSniperTarget,.3)
with mod_script_call("mod","defpack tools","create_abris",self,44,16,argument0)
{
	accspeed = [1.03,1.2]
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

#define Plasmasnake_step
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
		with instance_create(x+random_range(-(ammo_origin-ammo)/5,(ammo_origin-ammo)/5),y+random_range(-(ammo_origin-ammo)/5,(ammo_origin-ammo)/5),PlasmaImpact)
		{
			image_xscale = (random_range(0.5,0.75)-0.2) * other.ammo/other.ammo_origin +0.2*skill_get(17)/1.3
			image_yscale = image_xscale
			with Smoke if place_meeting(x,y,other) instance_destroy()
		}
	}
	with instance_create(x,y,PlasmaImpact)
	{
		if skill_get(17){if irandom(5) = 0 {sound_play(sndPlasmaMinigunUpg)}}
		else{if irandom(5) = 0 {sound_play(sndPlasmaMinigun)}}
		image_index = 1
		image_xscale = 0.7 * other.ammo/other.ammo_origin
		image_yscale = image_xscale
		with Smoke if place_meeting(x,y,other) instance_destroy()
	}
	ammo -= 1
}
if ammo = 0
{
	instance_destroy()
}

#define pop
sound_play(sndGrenadeRifle)
sound_play(sndExplosionS)
creator.wkick = 10
repeat(snakemass)
{
	with instance_create(mouse_x[index],mouse_y[index],CustomObject)
	{
		if !skill_get(17){instance_create(mouse_x[other.index],mouse_y[other.index],PlasmaImpact)}
		else						{with instance_create(mouse_x[other.index],mouse_y[other.index],PlasmaImpact){image_xscale = 1.5;image_yscale = 1.5}}
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
	with instance_create(mouse_x[index]+lengthdir_x(acc+16,offset2),mouse_y[index]+lengthdir_y(acc+16,offset2),PlasmaImpact)
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
/*#define weapon_fire
//if (place_meeting(mouse_x[index],mouse_y[index],Floor) && collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) < 0) || instance_exists(Nothing2)
//{
	with instance_create(x,y,CustomObject)
	{
		creator = other
		offset = random(360)
		offset2 = random(360)
		circlemass = 16
		snakemass = 3
		index = creator.index
		accbase = 44*creator.accuracy
		acc = accbase
		on_step = Inquisitor_step
		on_draw = Inquisitor_draw
		lasercolour1 = $00FF00
		lasercolour = lasercolour1
		lasercolour2 = $00AF00
	}

	#define Inquisitor_step
	if instance_exists(creator)
	{
		offset += 7
		image_angle += 7
		creator.reload = weapon_get_load(creator.wep)
		if skill_get(19) = false{acc /= 1.03}
		else{acc /= 1.2}
		x = creator.x
		y = creator.y
		if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) >= 0
		{
			if acc < accbase{acc += abs(creator.accuracy*3)}else{acc = accbase}
		}
		if !button_check(index, "fire")
		{
			if creator.ammo[5] >= 12
			{
				if creator.infammo <= 0{creator.ammo[5] -= 12}
				if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) < 0
				{
					sound_play(sndGrenadeRifle)
					sound_play(sndExplosionS)
					creator.wkick = 8
					repeat(snakemass)
					{
						with instance_create(mouse_x[index],mouse_y[index],CustomObject)
						{
							if !skill_get(17){instance_create(mouse_x[other.index],mouse_y[other.index],PlasmaImpact)}
							else						{with instance_create(mouse_x[other.index],mouse_y[other.index],PlasmaImpact){image_xscale = 1.5;image_yscale = 1.5}}
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
						with instance_create(mouse_x[index]+lengthdir_x(acc+16,offset2),mouse_y[index]+lengthdir_y(acc+16,offset2),PlasmaImpact)
						{
							image_xscale = .5
							image_yscale = .5
							image_speed = random_range(.3,.7)
							if !place_meeting(x,y,Floor){instance_destroy()}
						}
						offset2 += 360/circlemass
					}
				}
				else
				{
					if creator.infammo <= 0{creator.ammo[5] += 12}
				}
			}
		instance_destroy()
		}
	}
	else{instance_destroy()}

#define Inquisitor_draw
if creator.ammo[5] < 12{instance_destroy()}
else
if instance_exists(creator)
{
	if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) < 0
	{
		lasercolour = merge_colour(lasercolour1,lasercolour,.11)
		draw_line_width_colour(x,y,mouse_x[index],mouse_y[index],1,lasercolour,lasercolour);
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,acc+16,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,(1-skill_get(17)*.7)*(accbase-acc))
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,16,1,acc+(image_angle*-1),mouse_x[index],mouse_y[index],lasercolour1,.35)
		if skill_get(17){mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,(acc+18)*1.5,2,acc+image_angle*-1,mouse_x[index],mouse_y[index],lasercolour1,1*(accbase-acc))}
		mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, (acc+16+skill_get(17)*2)*(1+skill_get(17)/2), 48, mouse_x[index]+1, mouse_y[index]+1,global.stripes, lasercolour, 0.1+(accbase-acc)/(accbase*6));
		draw_sprite_ext(global.SnakeIndikator,0,mouse_x[index]+lengthdir_x(acc+16,offset),mouse_y[index]+lengthdir_y(acc+16,offset),1-acc/accbase,1-(acc/accbase)/3,offset-90,c_white,1*(accbase-acc))
		draw_sprite_ext(global.SnakeIndikator,0,mouse_x[index]+lengthdir_x(acc+16,offset+120),mouse_y[index]+lengthdir_y(acc+16,offset+120),1-acc/accbase,1-(acc/accbase)/3,offset+120-90,c_white,1*(accbase-acc))
		draw_sprite_ext(global.SnakeIndikator,0,mouse_x[index]+lengthdir_x(acc+16,offset+120+120),mouse_y[index]+lengthdir_y(acc+16,offset+120+120),1-acc/accbase,1-(acc/accbase)/3,offset+120+120-90,c_white,1*(accbase-acc))
	}
	else
	{
		var hitwall = collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0)//there is currently a bug where this chooses the furthest wall if you aim through multiple walls pls fix
	}
	lasercolour = merge_colour(lasercolour,lasercolour2,.11)
	draw_line_width_colour(x,y,x+lengthdir_x(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),y+lengthdir_y(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),1,lasercolour,lasercolour)
	if weapon_get_name(creator.wep) != "INQUISITOR"{instance_destroy()}
}

#define Plasmasnake_step
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
		with instance_create(x+random_range(-(ammo_origin-ammo)/5,(ammo_origin-ammo)/5),y+random_range(-(ammo_origin-ammo)/5,(ammo_origin-ammo)/5),PlasmaImpact)
		{
			image_xscale = (random_range(0.5,0.75)-0.2) * other.ammo/other.ammo_origin +0.2*skill_get(17)/1.3
			image_yscale = image_xscale
			with Smoke if place_meeting(x,y,other) instance_destroy()
		}
	}
	with instance_create(x,y,PlasmaImpact)
	{
		if skill_get(17){if irandom(5) = 0 {sound_play(sndPlasmaMinigunUpg)}}
		else{if irandom(5) = 0 {sound_play(sndPlasmaMinigun)}}
		image_index = 1
		image_xscale = 0.7 * other.ammo/other.ammo_origin
		image_yscale = image_xscale
		with Smoke if place_meeting(x,y,other) instance_destroy()
	}
	ammo -= 1
}
if ammo = 0
{
	instance_destroy()
}

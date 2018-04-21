#define init
global.sprThundercrash = sprite_add_weapon("sprites/sprThundercrash.png", 10, 5);
global.sprUmbrella  = sprite_add("sprites/projectiles/sprRainDisk.png",0,14,5);

#define weapon_name
return "THUNDERCRASH"

#define weapon_sprt
return global.sprThundercrash;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 40;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 14;

#define weapon_text
return choose("WHAT A BRIS","A STORM IS COMING");

#define weapon_fire
sound_play_pitch(sndDevastatorUpg,1.4)
if skill_get(17)=true{sound_play_pitch(sndLightningPistolUpg,.8)}else{sound_play_pitch(sndLightningPistol,.8)}
weapon_post(16,0,85)
sleep(15)
motion_add(gunangle-180,5+abs(speed))
with instance_create(x,y,LightningSpawn){move_contact_solid(other.gunangle,20);image_speed = .45}
with instance_create(x,y,LightningHit){move_contact_solid(other.gunangle,14);image_speed = .45}
with instance_create(x,y,CustomProjectile)
{
	creator = other
	team = other.team
	typ  = 1
	name = "lightning cluster grenade"
	motion_add(other.gunangle+random_range(-7,7)*other.accuracy,26)
	sprite_index = global.sprUmbrella
	image_speed = .45
	image_angle = direction
	damage  = 20
	friction = 0
	on_draw 	 = bloom_draw
	on_destroy = lightningcluster_destroy
}
/*with instance_create(x,y,CustomObject)
{
	timer  = room_speed*current_time_scale
	timer2 = room_speed*current_time_scale*7
	with instances_matching(CustomObject,"name","RainMakerRain"){other.timer=0;other.timer2+=timer2;instance_destroy()}
	spr_shadow = shd24
	name = "RainMakerRain"
	on_step = rain_step
}*/

#define fric_step
if name = "lightning grenade"
{
	var _scale = random_range(.4,.6);image_xscale = orscale*_scale;image_yscale = orscale*_scale
	direction += random_range(-25,25)
}
if speed <= 0{instance_destroy()}

#define bounce_wall
move_bounce_solid(false)

#define lightningcluster_destroy
sound_play_pitch(sndExplosion,2)
sound_play_pitch(sndExplosionS,.7)
sound_play_pitchvol(sndExplosionL,.5,.6)
sound_set_track_position(sndExplosionL,.3)
sound_play_pitch(sndSuperBazooka,.5)
if skill_get(17)=true
{
	sound_play_pitchvol(sndLightningCannonEnd,.8,.7)
	sound_play_pitchvol(sndLightningRifleUpg,.7,.6)
}
else
{
	sound_play_pitchvol(sndLightningRifle,.7,.6)
}
mod_script_call("mod","defpack tools","create_lightning",x+lengthdir_x(sprite_width,direction),y+lengthdir_y(sprite_width,direction))
var i = 0;
repeat(3)
{
	with instance_create(x+lengthdir_x(sprite_width,direction),y+lengthdir_y(sprite_width,direction),CustomProjectile)
	{
		creator = other.creator
		team = other.team
		name = "lightning grenade"
		orscale = random_range(.8,1.2)
		damage = 8
		friction = .025
		sprite_index = sprPopoPlasma
		image_speed = 0
		mask_index = mskDebris
		motion_add(random(360),1+i/6)
		image_angle = direction
		on_step  	 = fric_step
		on_wall 	 = bounce_wall
		on_draw 	 = bloom_draw
		on_destroy = lightningnade_destroy
	}
	i++
}

#define lightningnade_destroy
mod_script_call("mod","defpack tools","create_lightning",x,y)
sound_play_pitch(sndExplosion,2)
sound_play_pitch(sndExplosionS,.7)
sound_play_pitchvol(sndExplosionL,.5,.6)
sound_set_track_position(sndExplosionL,.3)
sound_play_pitch(sndSuperBazooka,.5)
if skill_get(17)=true
{
	sound_play_pitchvol(sndLightningCannonEnd,.8,.7)
	sound_play_pitchvol(sndLightningRifleUpg,.7,.6)
}
else
{
	sound_play_pitchvol(sndLightningRifle,.7,.6)
}

#define bloom_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.2);
draw_set_blend_mode(bm_normal);
/*
#define pop
with creator{weapon_post(9,0,159)}
sleep(300)
with instance_create(mouse_x[index],mouse_y[index],CustomObject)
{
	acc = other.acc
	m = 0
	timer = irandom_range(1,4)
	on_step = lit_step
}

#define abris_draw_lightning
if instance_exists(creator) && check{
	x = creator.x
	y = creator.y
	if button_check(creator.index, (check = 1? "fire":"spec")){
		if !collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0){
			var radi = acc+accmin;
			mod_script_call("mod", "defpack tools","draw_polygon_striped", 4, radi, acc+image_angle, mouse_x[index]+1, mouse_y[index]+1, global.stripes, lasercolour1, 0.1+(accbase-acc)/(accbase*5),(current_frame mod 16)*.004);
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",4,radi,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,1*(accbase-acc))
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",4, accmin,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,.2)
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

#define rain_step
sound_pitch(sndSewerDrip,random_range(1.2,1.4))
if timer > 0{timer--}
else
{
	if timer2 > 0{
		timer2--
		if timer2 > room_speed*current_time_scale*3{var _rainfac = 42}else{var _rainfac = 17}
		if timer2 < room_speed*current_time_scale{var _rainfac = 42}
		with Floor
		{
			if irandom(_rainfac) = 0
			{
				instance_create(x+random_range(-16,16),y+random_range(-16,16),RainDrop)
			}
		}
	}
	else{instance_destroy()}//sndHorrorLoop is good sound but unusable since horror exists
}

#define lit_step
if timer>0{timer-=current_time_scale}
else
{
	sound_play_pitch(sndGrenadeRifle,.3)
	sound_play_pitch(sndExplosion,2)
	sound_play_pitch(sndExplosionS,.7)
	sound_play_pitchvol(sndExplosionL,.5,.6)
	sound_set_track_position(sndExplosionL,.3)
	sound_play_pitch(sndSuperBazooka,.5)
	if skill_get(17)=true
	{
		sound_play_pitchvol(sndLightningCannonEnd,.8,.7)
		sound_play_pitchvol(sndLightningRifleUpg,.7,.6)
	}
	else
	{
		sound_play_pitchvol(sndLightningRifle,.7,.6)
	}
	timer = 13
	m++
	if instance_exists(enemy)
	{
		var closeboy = instance_nearest(x,y,enemy)
		if distance_to_object(closeboy)<acc{mod_script_call("mod","defpack tools","create_lightning",closeboy.x,closeboy.y)}
		else{mod_script_call("mod","defpack tools","create_lightning",x+lengthdir_x(acc,random(360)),y+lengthdir_y(acc,random(360)))}
	}
	else{mod_script_call("mod","defpack tools","create_lightning",x+lengthdir_x(acc,random(360)),y+lengthdir_y(acc,random(360)))}
}
if m > 3{instance_destroy()}

#define draw_shadows
with CustomObject
{
	trace("c")
	if("name" in self && name = "RainMakerRain")
	{
			trace("g")
			draw_sprite_ext(shd96, 0, x, y, 10000, 10000, 0, c_black,1)
	}
}
/*#define weapon_fire
with instance_create(x,y,CustomObject)
{
	creator = other
	team = other.team
	index = creator.index
	accbase = 110*creator.accuracy
	acc = accbase
	on_step = GoldenAbrisPistol_step
	on_draw = GoldenAbrisPistol_draw
	lasercolour1 = c_blue
	lasercolour = lasercolour1
	lasercolour2 = c_navy
	offset = 0
}

#define GoldenAbrisPistol_step
if instance_exists(creator)
{
	image_angle += 4
	creator.reload = weapon_get_load(creator.wep)
	if skill_get(19) = false{acc /= 1.06}
	else{acc /= 2.3}
	x = creator.x
	y = creator.y
	if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) >= 0
	{
		if acc < accbase{acc += abs(creator.accuracy*3)}else{acc = accbase}
	}
	if button_released(creator.index, "fire")
	{
		if creator.ammo[5] >= 18
		{
			if creator.infammo = 0{creator.ammo[5] -= 18}
			if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) < 0
			{
				sound_play(sndGrenadeRifle)
				sound_play(sndExplosionS)
				creator.wkick = 9
				with instance_create(mouse_x[index],mouse_y[index],LightningBall){team = other.team}
				repeat(4)
				{
					with instance_create(mouse_x[index]+lengthdir_x(acc+10,offset+image_angle),mouse_y[index]+lengthdir_y(acc+10,offset+image_angle),LightningBall){team = other.team}
					offset += 90
				}
			}
			else
			{
				if creator.infammo = 0{creator.ammo[5] += 18}
			}
		}
		instance_destroy()
	}
}
else{instance_destroy()}t

#define GoldenAbrisPistol_draw
if creator.ammo[5] < 18{instance_destroy()}
else
if instance_exists(creator)
{
	if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) < 0
	{
		lasercolour = merge_colour(lasercolour1,lasercolour,.11)
		draw_line_width_colour(x,y,mouse_x[index],mouse_y[index],1,lasercolour,lasercolour);
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",4,acc+26,1,acc-image_angle,mouse_x[index],mouse_y[index],lasercolour1,1)
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",4,26,2,acc-image_angle,mouse_x[index],mouse_y[index],lasercolour1,.2)
		mod_script_call("mod", "defpack tools","draw_polygon_striped", 4, acc+26,acc-image_angle, mouse_x[index]+1, mouse_y[index]+1, global.stripes, lasercolour, 0.1+(accbase-acc)/(accbase*6));
	}
	else
	{
		var hitwall = collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0)//there is currently a bug where this chooses the furthest wall if you aim through multiple walls pls fix
	}
	lasercolour = merge_colour(lasercolour,lasercolour2,.33)
	draw_line_width_colour(x,y,x+lengthdir_x(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),y+lengthdir_y(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),1,lasercolour,lasercolour)
	if weapon_get_name(creator.wep) != "LIGHTNING ABRIS LAUNCHER"{instance_destroy()}
}

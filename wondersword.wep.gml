#define init
global.sprWonderSword  = sprite_add_weapon("sprites/sprWonderSword.png", -2, 6);
global.sprGoldSlashBig = sprite_add("sprites/projectiles/sprGoldSlashBig.png",3,0,36)
global.sprGoldSlash    = sprite_add("sprites/projectiles/Gunhammer Slash.png",3,0,24)
//global.sprFlarefire   = sprite_add("Flarefire.png",5,10,10)

#define weapon_chrg
return 1;

#define weapon_name
return "WONDERSWORD";

#define weapon_sprt
return global.sprWonderSword;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 1;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
if GameCont.hard = 0 return 14
return -1;

#define weapon_text
return "@yWonder @swhat @yis @sthis sword";

#define weapon_gold
return 1;

#define weapon_reloaded
return -1;

#define weapon_fire


#define step(w)
if "wondershit" not in self{
	wondershit = [0,0]
	bwondershit = [0,0]
	//charge,tier
}
if "_reload" not in self{_reload = 0}
if w {
	if _reload > 0{_reload -= current_time_scale;reload = _reload;exit}
	if button_check(index,"fire") && wondershit[1]<5{
		view_shake_max_at(x,y,wondershit[1]*2)
		if wondershit[1] = 0{wondershit[0] = 60}
		wondershit[0]+= current_time_scale*2.6
		if wondershit[1] < 4{wepangle += .75*sign(wepangle)}
		if wondershit[1] = 4{if current_frame % 4 = 0{gunshine = 5};if wondershit[0] > 40{wondershit[0] = 40}}
		if (wondershit[0] >= 45)
		{
			wondershit[0] = 0
			wondershit[1]++
				if wondershit[1] > 4{wondershit[1] = 4}
			if wondershit[1] > 1
			{
				gunshine = 7
				sound_play_pitch(sndSwapGold,.6+wondershit[1]*.1)
				sound_play_pitchvol(sndGoldPickup,.6+wondershit[1]*.1,.2)
				with instance_create(x,y-3-sprite_get_height(sprite_index),CustomObject)
				{
					image_alpha = 0
					num = other.wondershit[1] -1
					sprite_index = sprGroundFlameBigDisappear
					motion_add(90,2)
					friction = .2
					bimage_index = image_index
					image_speed = .45-.05*other.wondershit[1]
					depth = -8
					on_step = flarefire_step
					on_draw = flarefire_draw
				}
			}
		}
	}
	else if wondershit[1] >= 1
	{
		weapon_post(12,0,12)
		sleep(4)
		sound_play_gun(sndBlackSword,.5,0)
		sound_play_gun(sndGoldWrench,.6,0)
		sound_play_pitch(sndGoldScrewdriver,.6)
		_reload += 12
		var tier = wondershit[1]
		var _x = x+lengthdir_x(20*skill_get(13),gunangle);
		var _y = y+lengthdir_y(20*skill_get(13),gunangle);
		var spd = 2+3*skill_get(13);
		if tier = 1
		{
			with instance_create(_x,_y,Slash)
			{
				damage = 20
				sprite_index = global.sprGoldSlash
				mask_index 	 = mskSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
			}
		}
		else if tier = 2
		{
			weapon_post(12,0,21)
			sleep(10)
			sound_play_gun(sndBlackSword,.5,0)
			sound_play_pitchvol(sndGoldDiscgun,.8,.4)
			sound_play_gun(sndGoldWrench,.6,0)
			sound_play_pitch(sndGoldScrewdriver,.6)
			sound_play_pitch(sndEnemySlash,1.4)
			_reload += 26
			with instance_create(_x,_y,Slash){
				damage = 28
				sprite_index = global.sprGoldSlashBig
				mask_index 	 = mskMegaSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
			}
		}
		else if tier = 3
		{
			weapon_post(12,0,40)
			sleep(20)
			sound_play_gun(sndBlackSword,.5,0)
			sound_play_pitchvol(sndGoldDiscgun,.8,.4)
			sound_play_gun(sndGoldWrench,.6,0)
			sound_play_pitch(sndGoldScrewdriver,.6)
			sound_play_pitch(sndEnemySlash,1.4)
			sound_play_pitch(sndIncinerator,.8)
			_reload += 12
			with instance_create(_x,_y,Slash){
				damage = 34
				sprite_index = global.sprGoldSlashBig
				mask_index 	 = mskMegaSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
					repeat(7) with instance_create(x,y,Flame)
					{
						team = other.team
						move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction-20),other.y+lengthdir_y(60,other.direction-20)),60)
						motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
					}
					repeat(7) with instance_create(x,y,Flame)
					{
						move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(65,other.direction),other.y+lengthdir_y(65,other.direction)),65)
						team = other.team
						motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
					}
					repeat(7) with instance_create(x,y,Flame)
					{
							move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction+20),other.y+lengthdir_y(60,other.direction+20)),60)
						team = other.team
						motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
					}
			}
		}
		else if tier = 4
		{
			weapon_post(12,0,74)
			sound_play_gun(sndBlackSword,.5,0)
			sound_play_pitchvol(sndGoldDiscgun,.8,.4)
			sound_play_gun(sndGoldWrench,.6,0)
			sound_play_pitch(sndGoldScrewdriver,.6)
			sound_play_pitch(sndEnemySlash,1.4)
			sound_play_pitch(sndIncinerator,.8)
			sound_play_pitch(sndFireShotgun,random_range(.6,.8))
			sleep(70)
			sound_play_pitchvol(sndFlameCannonEnd,.7,.5)
			_reload += 32
			with instance_create(_x,_y,Slash){
				damage = 40
				sprite_index = global.sprGoldSlashBig
				mask_index 	 = mskMegaSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
				repeat(7) with instance_create(x,y,Flame)
				{
					team = other.team
					move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction-20),other.y+lengthdir_y(60,other.direction-20)),60)
					motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
				}
				repeat(7) with instance_create(x,y,Flame)
				{
					move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(65,other.direction),other.y+lengthdir_y(65,other.direction)),65)
					team = other.team
					motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
				}
				repeat(7) with instance_create(x,y,Flame)
				{
						move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction+20),other.y+lengthdir_y(60,other.direction+20)),60)
					team = other.team
					motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
				}
			}
		}
		/*if tier = 5
		{
				repeat(3){with instance_create(x,y,CustomObject){team = other.team;on_step = flare_step}}
		}*/
		wondershit = [0,0]
		wepangle = -90 * sign(wepangle)
		wkick = 9
		motion_add(gunangle,4)
	}
	else
	{
		wondershit = [0,0]
		wepangle = 90 * sign(wepangle)
	}
}



//fuck steroids
if race = "steroids" && !w{
if "_breload" not in self{_breload = 0}
	if _breload > 0{_breload -= current_time_scale;breload = _breload;exit}
	if button_check(index,"spec") && bwondershit[1]<5{
		view_shake_max_at(x,y,bwondershit[1]*2)
		if bwondershit[1] = 0{bwondershit[0] = 43}
		bwondershit[0]+= current_time_scale*2.6
		if bwondershit[1] < 4{bwepangle += .75*sign(bwepangle)}
		if bwondershit[1] = 4{if current_frame % 4 = 0{gunshine = 5};if bwondershit[0] > 40{bwondershit[0] = 40}}
		if (bwondershit[0] >= 45)
		{
			bwondershit[0] = 0
			bwondershit[1]++
				if bwondershit[1] > 4{bwondershit[1] = 4}
			if bwondershit[1] > 1
			{
				gunshine = 7
				sound_play_pitch(sndSwapGold,.6+bwondershit[1]*.1)
				sound_play_pitchvol(sndGoldPickup,.6+bwondershit[1]*.1,.2)
				with instance_create(x,y-3-sprite_get_height(sprite_index),CustomObject)
				{
					image_alpha = 0
					num = other.bwondershit[1] -1
					sprite_index = sprGroundFlameBigDisappear
					motion_add(90,2)
					friction = .2
					bimage_index = image_index
					image_speed = .45-.05*other.bwondershit[1]
					depth = -8
					on_step = flarefire_step
					on_draw = flarefire_draw
				}
			}
		}
	}
	else if bwondershit[1] >= 1
	{
		weapon_post(12,0,12)
		sleep(4)
		sound_play_gun(sndBlackSword,.5,0)
		sound_play_gun(sndGoldWrench,.6,0)
		sound_play_pitch(sndGoldScrewdriver,.6)
		_breload += 12
		var tier = bwondershit[1]
		var _x = x+lengthdir_x(20*skill_get(13),gunangle);
		var _y = y+lengthdir_y(20*skill_get(13),gunangle);
		var spd = 2+3*skill_get(13);
		if tier = 1
		{
			with instance_create(_x,_y,Slash)
			{
				damage = 20
				sprite_index = global.sprGoldSlash
				mask_index 	 = mskSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
			}
		}
		else if tier = 2
		{
			weapon_post(12,0,21)
			sleep(10)
			sound_play_gun(sndBlackSword,.5,0)
			sound_play_pitchvol(sndGoldDiscgun,.8,.4)
			sound_play_gun(sndGoldWrench,.6,0)
			sound_play_pitch(sndGoldScrewdriver,.6)
			sound_play_pitch(sndEnemySlash,1.4)
			_breload += 26
			with instance_create(_x,_y,Slash){
				damage = 28
				sprite_index = global.sprGoldSlashBig
				mask_index 	 = mskMegaSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
			}
		}
		else if tier = 3
		{
			weapon_post(12,0,40)
			sleep(20)
			sound_play_gun(sndBlackSword,.5,0)
			sound_play_pitchvol(sndGoldDiscgun,.8,.4)
			sound_play_gun(sndGoldWrench,.6,0)
			sound_play_pitch(sndGoldScrewdriver,.6)
			sound_play_pitch(sndEnemySlash,1.4)
			sound_play_pitch(sndIncinerator,.8)
			_breload += 12
			with instance_create(_x,_y,Slash){
				damage = 34
				sprite_index = global.sprGoldSlashBig
				mask_index 	 = mskMegaSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
					repeat(7) with instance_create(x,y,Flame)
					{
						team = other.team
						move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction-20),other.y+lengthdir_y(60,other.direction-20)),60)
						motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
					}
					repeat(7) with instance_create(x,y,Flame)
					{
						move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(65,other.direction),other.y+lengthdir_y(65,other.direction)),65)
						team = other.team
						motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
					}
					repeat(7) with instance_create(x,y,Flame)
					{
							move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction+20),other.y+lengthdir_y(60,other.direction+20)),60)
						team = other.team
						motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
					}
			}
		}
		else if tier = 4
		{
			weapon_post(12,0,74)
			sound_play_gun(sndBlackSword,.5,0)
			sound_play_pitchvol(sndGoldDiscgun,.8,.4)
			sound_play_gun(sndGoldWrench,.6,0)
			sound_play_pitch(sndGoldScrewdriver,.6)
			sound_play_pitch(sndEnemySlash,1.4)
			sound_play_pitch(sndIncinerator,.8)
			sound_play_pitch(sndFireShotgun,random_range(.6,.8))
			sleep(70)
			sound_play_pitchvol(sndFlameCannonEnd,.7,.5)
			_breload += 32
			with instance_create(_x,_y,Slash){
				damage = 40
				sprite_index = global.sprGoldSlashBig
				mask_index 	 = mskMegaSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
				repeat(7) with instance_create(x,y,Flame)
				{
					team = other.team
					move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction-20),other.y+lengthdir_y(60,other.direction-20)),60)
					motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
				}
				repeat(7) with instance_create(x,y,Flame)
				{
					move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(65,other.direction),other.y+lengthdir_y(65,other.direction)),65)
					team = other.team
					motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
				}
				repeat(7) with instance_create(x,y,Flame)
				{
						move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction+20),other.y+lengthdir_y(60,other.direction+20)),60)
					team = other.team
					motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
				}
			}
		}
		/*if tier = 5
		{
				repeat(3){with instance_create(x,y,CustomObject){team = other.team;on_step = flare_step}}
		}*/
		bwondershit = [0,0]
		bwepangle = -90 * sign(bwepangle)
		bwkick = 9
		motion_add(gunangle,4)
	}
	else
	{
		bwondershit = [0,0]
		bwepangle = 90 * sign(bwepangle)
	}
}


#define flarefire_step
if image_index < bimage_index{instance_destroy();exit}
bimage_index = image_index

#define flarefire_draw
var i = 0;
var j = num/3;
repeat(num)
{
	var _rndm = random_range(-num/6,num/6)
	i++;
	draw_sprite_ext(sprite_index, image_index, x-sprite_get_width(sprite_index)*(j+1)+sprite_get_width(sprite_index)*(i), y, 1.5*image_xscale+_rndm, 1.5*image_yscale+_rndm, image_angle, image_blend, 0.3);
	draw_sprite_ext(sprite_index, image_index, x-sprite_get_width(sprite_index)*(j+1)+sprite_get_width(sprite_index)*(i), y, .8*image_xscale, .8*image_yscale, image_angle, image_blend, 1.0);
	draw_set_blend_mode(bm_add);
	draw_set_blend_mode(bm_normal);
	j -= 1/3
}
/*
sound_play(sndScrewdriver)
wkick = 9
wepangle = -wepangle
motion_add(gunangle, 4)
with instance_create(x+lengthdir_x(12,gunangle),y+lengthdir_y(12,direction),CustomProjectile)
{
	damage = 50
	force = 30
	name = "Sweetspot"
	parent = noone
	creator = other
	sprite_index = global.mskGuardSlash
	mask_index = global.mskGuardSlash
	image_alpha = 0
	depth -= 1
	direction = other.gunangle
	image_angle = direction
	team = other.team
	on_step = sweetspot_step
	on_wall = actually_nothing
	on_hit = sweetspot_hit
	on_draw = sweetspot_draw
}
wait(1)
with instance_create(x+lengthdir_x(6,gunangle),y+lengthdir_y(6,gunangle),Slash)
{
	with CustomProjectile
	{
		if ("name" in self && name = "Sweetspot")
		if parent = noone{parent = other}
	}
	damage = 30
	image_xscale = .88
	image_yscale = .88
	creator = other
	sprite_index = global.sprWonderSlash
	mask_index = mskMegaSlash
	motion_add(other.gunangle, 6 + (skill_get(13) * 3))
	image_angle = direction
	team = other.team
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
}

#define sweetspot_step
if instance_exists(parent)
{
	if  parent != noone
	{
		x = parent.x+lengthdir_x(12,direction)
		y = parent.y+lengthdir_y(12,direction)
		direction = parent.direction
		iamge_angle = direction
	}
}
else{instance_destroy();exit}
speed = 0

#define sweetspot_hit
if other.sprite_index != other.spr_hurt{projectile_hit(other, damage, force, direction)};
//instance_create(other.x,other.y,SmallExplosion)
repeat(5)with instance_create(x+random_range(-14,14),y+random_range(-14,14),FireFly){image_blend = c_red}

#define sweetspot_draw
draw_self()
draw_sprite_ext(global.sprWonderSlash,image_index,x,y,1,1,image_angle,c_white,1)


#define actually_nothing

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

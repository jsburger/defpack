#define init
global.sprSmarterGun = sprite_add_weapon("sprites/sprSmarterGun.png",9,7)
#define weapon_name
return "SMARTER GUN"
#define weapon_type
return 1
#define weapon_cost
return 1
#define weapon_area
return 12
#define weapon_load
return 22
#define weapon_swap
return sndSwapMachinegun
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire

var ang = gunangle;
weapon_post(2,0,12)
sound_play_gun(sndSmartgun,.1,.7)
if wep ="smarter gun"
{
	var _truex = x+sprite_get_width(sprite_index)/2-wkick*wepflip
	var _truey = y-8+sin(current_frame*current_time_scale/+10)*5
	if instance_exists(enemy){
		var target = instance_nearest(mouse_x[index],mouse_y[index],enemy);
		if !collision_line(_truex,_truey,target.x,target.y,Wall,0,0){ang = point_direction(_truex,_truey,target.x+target.hspeed_raw,target.y+target.vspeed_raw)}
	}
		with instance_create(_truex,_truey,Bullet1){
			sprite_index = sprIDPDBullet
			creator = other
			team = other.team
			motion_set(ang,16)
			image_angle = direction
		}
}
if bwep ="smarter gun"
{
	var _btruex = x-sprite_get_width(sprite_index)/2-wkick*bwepflip
	var _btruey = y-8+sin(current_frame*current_time_scale/-10)*5
	if instance_exists(enemy){
		var target = instance_nearest(mouse_x[index],mouse_y[index],enemy);
		if !collision_line(_btruex,_btruey,target.x,target.y,Wall,0,0){ang = point_direction(_btruex,_btruey,target.x+target.hspeed_raw,target.y+target.vspeed_raw)}
	}
		with instance_create(_btruex,_btruey,Bullet1){
			sprite_index = sprIDPDBullet
			creator = other
			team = other.team
			motion_set(ang,16)
			image_angle = direction
		}
}

#define step(w)
if wep = "smarter gun"
{
	if reload <= 0 && ammo[1]
	{
		if instance_exists(enemy)
		{
			var _truex = x+sprite_get_width(sprite_index)/2-wkick*wepflip
			var _truey = y-8+sin(current_frame*current_time_scale/-10)*5
			var target = instance_nearest(_truex,_truey,enemy);
			if !collision_line(_truex,_truey,target.x,target.y,Wall,0,0)
			{
				var ang = point_direction(_truex,_truey,target.x+target.hspeed_raw,target.y+target.vspeed_raw);
				sound_play_gun(sndSmartgun,.1,.7)
				wkick += 2
				with instance_create(_truex,_truey,Bullet1)
				{
					sprite_index = sprIDPDBullet
					creator = other
					team = other.team
					motion_set(ang,16)
					image_angle = direction
				}
				if infammo = 0 ammo[1]--
				reload = weapon_load()
			}
		}
	}
	if reload > 0
	{
		reload--
		if skill_get(mut_stress) reload -= 1 - my_health/maxhealth
		if race = "venuz"
		{
			reload -= .2
			if ultra_get(race,1) reload -= .4
		}
	}
}
if bwep = "smarter gun"
{
	if bwkick > 0{bwkick-=.6}else{bwkick=0}
	if breload <= 0 && ammo[1]
	{
		if instance_exists(enemy)
		{
			var _btruex = x-sprite_get_width(sprite_index)/2-wkick*bwepflip
			var _btruey = y-8+sin(current_frame*current_time_scale/-10)*5,bwepflip
			var target = instance_nearest(_btruex,_btruey,enemy);
			if !collision_line(_btruex,_btruey,target.x,target.y,Wall,0,0)
			{
				var bang = point_direction(_btruex,_btruey,target.x+target.hspeed_raw,target.y+target.vspeed_raw);
				sound_play_gun(sndSmartgun,.1,.7)
				bwkick += 2
				with instance_create(_btruex,_btruey,Bullet1)
				{
					sprite_index = sprIDPDBullet
					creator = other
					team = other.team
					motion_set(bang,16)
					image_angle = direction
				}
				if infammo = 0 ammo[1]--
				breload = weapon_load()
			}
		}
	}
	if breload > 0
	{
		breload--
		if skill_get(mut_stress) breload -= 1 - my_health/maxhealth
		if race = "venuz"
		{
			breload -= .2
			if ultra_get(race,1) breload -= .4
		}
	}
}

#define weapon_sprt
if "my_health" in self
{
	if wep = "smarter gun"{
		if "closeboy" in self{if closeboy.x > x{wepflip = 1}else{wepflip = -1}}else{wepflip = right}
		draw_sprite_ext(global.sprSmarterGun,0,x+sprite_get_width(sprite_index)/2-wkick*wepflip,y-8+sin(current_frame*current_time_scale/10)*5,wepflip,1,0,c_white,1)
	}
	if bwep = "smarter gun"
	{
		if "closeboy" in self{if closeboy.x > x{bwepflip = 1}else{bwepflip = -1}}else{bwepflip = right}
		draw_sprite_ext(global.sprSmarterGun,0,x-sprite_get_width(sprite_index)/2-bwkick*bwepflip,y-8+sin(current_frame*current_time_scale/-10)*5,bwepflip,1,0,c_white,1)
	}
	return mskNothing
}
else{return global.sprSmarterGun}


#define weapon_text
return "massive brain"

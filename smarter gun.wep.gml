#define init
global.sprSmarterGun 	  = sprite_add_weapon("sprites/sprSmarterGun.png",9,7)
global.sprSmarterGunHUD = sprite_add_weapon("sprites/sprSmarterGun.png",1,4)
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
if reload > 0{exit}

#define step(w)
if wep = "smarter gun"
{
	if "_reload" not in self _reload = 22
	if _reload <= 0 && ammo[1]
	{
		var _canshoot = true;
		if instance_exists(enemy)
		{
			var _truex = x+sprite_get_width(sprite_index)/2-wkick*wepflip
			var _truey = y-8+sin(current_frame*current_time_scale/10)*5
			var target = instance_nearest(_truex,_truey,enemy);
			if !collision_line(_truex,_truey,target.x,target.y,Wall,0,0)
			{
				_reload = 22
				reload = _reload
				_canshoot = false
				var ang = point_direction(_truex,_truey,target.x+target.hspeed_raw,target.y+target.vspeed_raw);
				sound_play_gun(sndSmartgun,.1,.7)
				sound_play_gun(sndHitMetal,1.7,.1)
				sound_play_pitch(sndGruntFire,random_range(1.2,1.4))
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
			}
		}
		if _canshoot = true
		{
			if button_check(index,"fire")
			{
				weapon_post(2,0,12)
				sound_play_gun(sndSmartgun,.1,.1)
				sound_play_gun(sndHitMetal,1.7,.1)
				sound_play_pitch(sndGruntFire,random_range(1.2,1.4))
				_reload = 22
				reload = _reload
			  var _truex = x+sprite_get_width(sprite_index)/2-wkick*wepflip
			  var _truey = y-8+sin(current_frame*current_time_scale/10)*5
				if instance_exists(enemy)
				{
					var target = instance_nearest(mouse_x[index],mouse_y[index],enemy);
					if !collision_line(_truex,_truey,target.x,target.y,Wall,0,0){ang = point_direction(_truex,_truey,target.x+target.hspeed_raw,target.y+target.vspeed_raw)}else{ang = gunangle}
				}
				else{ang = gunangle}
				with instance_create(_truex,_truey,Bullet1)
				{
					sprite_index = sprIDPDBullet
					creator = other
					team = other.team
					motion_set(ang,16)
					image_angle = direction
				}
			}
		}
	}
	if _reload > 0
	{
		_reload--
		if skill_get(mut_stress) _reload -= 1 - my_health/maxhealth
		if race = "venuz"
		{
			_reload -= .2
			if ultra_get(race,1) _reload -= .4
		}
	}
}

//hatred of roids
if bwep = "smarter gun"
{
	if bwkick-- > 0 && race != "steroids"{bwkick-= current_time_scale/10}else{bwkick = 0}
	if "_breload" not in self _breload = 22
	if _breload <= 0 && ammo[1]
	{
		var _canbshoot = true;
		if instance_exists(enemy)
		{
			var _truebx = x-sprite_get_width(sprite_index)/2-wkick*wepflip
			var _trueby = y+8+sin(current_frame*current_time_scale/10)*5
			var target = instance_nearest(_truebx,_trueby,enemy);
			if !collision_line(_truebx,_trueby,target.x,target.y,Wall,0,0)
			{
				_breload = 22
				breload = _breload
				_canbshoot = false
				var bang = point_direction(_truebx,_trueby,target.x+target.hspeed_raw,target.y+target.vspeed_raw);
				sound_play_gun(sndSmartgun,.1,.7)
				sound_play_gun(sndHitMetal,1.7,.1)
				sound_play_pitch(sndGruntFire,random_range(1.5,1.8))
				bwkick += 2
				with instance_create(_truebx,_trueby,Bullet1)
				{
					sprite_index = sprIDPDBullet
					creator = other
					team = other.team
					motion_set(bang,16)
					image_angle = direction
				}
				if infammo = 0 ammo[1]--
			}
		}
		if _canbshoot = true
		{
			if race = "steroids" && button_check(index,"spec")
			{
				weapon_post(0,0,9)
				bwkick += 2
				sound_play_gun(sndSmartgun,.1,.7)
				sound_play_gun(sndHitMetal,1.7,.1)
				sound_play_pitch(sndGruntFire,random_range(1.5,1.8))
				_breload = 22
				breload = _breload
			  var _truebx = x-sprite_get_width(sprite_index)/2-bwkick*wepflip
			  var _trueby = y-8+sin(current_frame*current_time_scale/-10)*5
				if instance_exists(enemy)
				{
					var target = instance_nearest(mouse_x[index],mouse_y[index],enemy);
					if !collision_line(_truebx,_trueby,target.x,target.y,Wall,0,0){ang = point_direction(_truebx,_trueby,target.x+target.hspeed_raw,target.y+target.vspeed_raw)}else{ang = gunangle}
				}
				else{ang = gunangle}
				with instance_create(_truebx,_trueby,Bullet1)
				{
					sprite_index = sprIDPDBullet
					creator = other
					team = other.team
					motion_set(ang,16)
					image_angle = direction
				}
			}
		}
	}
	if _breload > 0
	{
		_breload--
		if skill_get(mut_stress) _breload -= 1 - my_health/maxhealth
		if race = "venuz"
		{
			_breload -= .2
			if ultra_get(race,1) _breload -= .4
		}
	}
}


#define weapon_sprt_hud
return global.sprSmarterGunHUD

#define weapon_sprt
if "my_health" in self
{
	if wep = "smarter gun"{
		if "target" in self{if target.x > x{wepflip = -1}else{wepflip = 1}}else{wepflip = right}
		draw_sprite_ext(global.sprSmarterGun,0,x+sprite_get_width(sprite_index)/2-wkick*wepflip,y-8+sin(current_frame*current_time_scale/10)*5,wepflip,1,0,c_white,1)
	}
	if bwep = "smarter gun"
	{
		if "target" in self{if target.x > x{bwepflip = -1}else{bwepflip = 1}}else{bwepflip = right}
		draw_sprite_ext(global.sprSmarterGun,0,x-sprite_get_width(sprite_index)/2-bwkick*bwepflip,y-8+sin(current_frame*current_time_scale/-10)*5,bwepflip,1,0,c_white,1)
	}
	return mskNothing
}
else{return global.sprSmarterGun}


#define weapon_text
return "massive brain"

#define init
global.sprSonicLauncher = sprite_add_weapon("sprites/weapons/sprSonicShotgun.png", 2, 2);

#define weapon_name
return "SONIC SHOTGUN"

#define weapon_sprt
return global.sprSonicLauncher;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 32;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 3;

#define weapon_text
return "FAST TRAVEL";

#define weapon_fire
	with mod_script_call("mod","defpack tools","create_sonic_explosion",x + lengthdir_x(18, gunangle),y + lengthdir_y(18, gunangle)){
		image_xscale = 2
		image_yscale = 2
		image_speed = 0.6
		superfriction = .35
		sprite_index = mskExploder;
		image_index = 2;
		image_speed = 2;
		mask_index = mskExploder
		//superdirection = other.gunangle
		team = other.team
		creator = other
	}
	if "extraspeed" not in self{extraspeed = 16 + gunangle / 10000}else{extraspeed += 16 + gunangle / 10000}

#define step
	if "extraspeed" in self
	{
		if extraspeed > 32{extraspeed = 32} //cap speed for safety reasons
		if extraspeed > 0
		{
			sleep(1)
			//sound_play_gun(sndFootOrgSand4,999999999999999999999999999999999999999999999999,.00001)//mute action
			instance_create(x + random_range(-4, 4),y + random_range(-4, 4), Dust);
			canaim = false;
			with instance_create(x-lengthdir_x(extraspeed * 3+frac(extraspeed),frac(extraspeed)*10000),y-lengthdir_y(extraspeed * 3+frac(extraspeed),frac(extraspeed)*10000),Shank)
			{
				team = other.team;
				creator = other;
				damage = 20;
				sprite_index = mskNone;
				mask_index = sprFlakBullet;
				image_xscale = 2;
				image_yscale = 2;
				image_angle = other.gunangle;
				if place_meeting(x, y, enemy){
					var _e = instance_nearest(x, y, enemy)
					sleep(15 + 12 * _e.size)
					view_shake_at(x, y, round(6 + 3 * (1 + .25 + _e.size)))
				}
			}
			var _esd = frac(extraspeed)*10000;
			motion_add(_esd-180,extraspeed-frac(extraspeed));
			extraspeed -= current_time_scale * .5;
			if place_meeting(x + lengthdir_x(extraspeed, _esd), y + lengthdir_y(extraspeed, _esd), Wall){
				move_bounce_solid(false)
			}
		}
		else{extraspeed = 0;canaim = true}
	}

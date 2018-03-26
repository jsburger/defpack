#define init
global.sprAutoBulletFlakCannon = sprite_add_weapon("Auto Bullet Flak Cannon.png", 3, 3);

#define weapon_name
return "AUTO BULLAK CANNON"

#define weapon_sprt
return global.sprAutoBulletFlakCannon;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 9;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 10;

#define weapon_text
return "WHOOP/WHOOP";

#define weapon_fire
sound_play_pitch(sndPistol,random_range(0.5,0.8))
sound_play_pitch(sndGrenadeRifle,random_range(.9,1.3))
sound_play_pitch(sndFlakCannon,random_range(.9,1.3))
weapon_post(4,-4,7)
repeat(4)
{
	with instance_create(x,y,Shell)
	{
		motion_add(point_direction(x,y,mouse_x,mouse_y)+other.right*100+random(30)-15,2+random(5))
	}
}
mod_script_call("mod", "defpack tools 2","create_flak",0,42,13,0,Bullet1,irandom_range(4,5),id)

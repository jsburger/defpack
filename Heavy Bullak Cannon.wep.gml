#define init
global.sprHeavyBulletFlakCannon = sprite_add_weapon("Heavy Bullet Flak Cannon.png", 2, 3);

#define weapon_name
return "HEAVY BULLAK CANNON"

#define weapon_sprt
return global.sprHeavyBulletFlakCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 90;

#define weapon_cost
return 40;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 8;

#define weapon_text
return "100/100";

#define weapon_fire

repeat(24)
{
	with instance_create(x,y,Shell)
	{
		sprite_index = sprHeavyShell
		motion_add(other.gunangle+other.right*100+random(50)-25,2+random(5))
	}
}
sound_play_pitch(sndGrenade,random_range(1,1.1))
sound_play_pitch(sndSuperFlakCannon,random_range(1.2,1.4))
weapon_post(8,7,12)
mod_script_call("mod", "defpack tools 2","create_flak",0,20,13,0,HeavyBullet,24,id)

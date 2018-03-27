#define init
global.sprBoltGun = sprite_add_weapon("sprites/Bolt Gun.png", 4, 3);

#define weapon_name
return "BOLT GUN"

#define weapon_sprt
return global.sprBoltGun;

#define weapon_type
return 3;

#define weapon_auto
return false;

#define weapon_load
return 28;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 10;

#define weapon_text
return "HEAR THE NEEDLE DROP";

#define weapon_fire

sound_play(sndGrenadeRifle)
weapon_post(9,-14,6)
with instance_create(x,y,Bolt)
{
	team = other.team
	motion_add(other.gunangle+random_range(-2,2)*other.accuracy,24)
	image_angle = direction
	creator = other
}
with instance_create(x,y,HeavyBolt)
{
	team = other.team
	motion_add(other.gunangle+random_range(-5,5)*other.accuracy,16)
	image_angle = direction
	creator = other
}
repeat(2)
{
	with instance_create(x,y,Seeker)
	{
		team = other.team
		creator = other
		motion_add(other.gunangle+random_range(-25,25)*other.accuracy,8)
		image_angle = direction
	}
}
repeat(4)
{
	with instance_create(x,y,Splinter)
	{
		team = other.team
		motion_add(other.gunangle+random_range(-20,20)*other.accuracy,20)
		image_angle = direction
		creator = other
	}
}

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
var _acc = random_range(-3,3)
with instance_create(x,y,CustomSlash)
{
	name = "triangle orbital"
	sprite_index = sprPlasmaBall
	mask_index 	 = mskNothing
	image_speed  = 0
	maxspeed = 6
	team 		= other.team
	creator = other
	maxrof = 6
	rof 	 = maxrof
	motion_add(other.gunangle,maxspeed)
	on_hit  = triangle_hit
	on_step = triangle_step
	on_wall = triangle_wall
}

#define triangle_hit

#define triangle_step
if instance_exists(creator)
{
	var _daddydir = point_direction(x,y,creator.x,creator.y)
	motion_add(direction,1)
	motion_add(_daddydir,2)
	if rof > 0
	{
		rof -= current_time_scale
	}
	else
	{
		//cool fire stuff here
	}
	if speed > maxspeed{speed = maxspeed}
	with instances_matching(CustomSlash,"name","triangle orbital")
	{
		if place_meeting(x,y,other)
		{
			motion_add(point_direction(other.x,other.y,x,y),1)
		}
	}
}

#define triangle_wall

#define init
global.sprAutoNader = sprite_add_weapon("sprites/Auto Nader.png", 2, 1);
global.sprAutoGrenade = sprite_add("sprites/projectiles/autonade.png",0,3,3);

#define weapon_name
return "AUTO GRENADE LAUNCHER";

#define weapon_sprt
return global.sprAutoNader;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 12;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 9;

#define weapon_reloaded
sound_play(sndNadeReload)

#define weapon_text
return "GOES WELL WITH STRESS";

#define weapon_fire
sound_play_pitch(sndGrenade,random_range(.8,1.1))
sound_play_pitch(sndClusterLauncher,1.4)
weapon_post(5,-4,4)
with instance_create(x,y,Grenade)
{
	sprite_index = global.sprAutoGrenade
	motion_add(other.gunangle+random_range(-13,13)*other.accuracy,10)
	sticky = 0
	image_angle = direction
	team = other.team
	creator = other
}

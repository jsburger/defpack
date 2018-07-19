#define init
global.sprSpikeballLauncher = sprite_add_weapon("sprites/sprSpikeballLauncher.png", 0, 2);

#define weapon_name
return "SPIKEBALL LAUNCHER"

#define weapon_sprt
return global.sprSpikeballLauncher;

#define weapon_type
return 3;

#define weapon_auto
return false;

#define weapon_laser_sight
return false;

#define weapon_load
return 44;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 12;

#define weapon_text
return choose("POINTY ORBS");

#define weapon_fire
repeat(4)
{
sound_play_pitch(sndSlugger,random_range(1.8,2))
sound_play_pitch(sndClusterLauncher,random_range(.6,.8))
weapon_post(6,-5,38)
	with mod_script_call("mod","defpack tools","create_spikeball",x,y)
	{
		creator = other
		team = other.team
		move_contact_solid(other.gunangle,24)
		motion_add(other.gunangle+random_range(-6,6)*other.accuracy,8)
	}
	wait(4)
	if !instance_exists(self) exit;
}

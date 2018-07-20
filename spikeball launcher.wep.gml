#define init
global.sprSpikeballLauncher = sprite_add_weapon("sprites/sprSpikeballLauncher.png", 9, 4);

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
return 34;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 12;

#define weapon_text
return choose("POINTY ORBS");

#define weapon_fire
sound_play_pitch(sndSlugger,random_range(1.8,2))
sound_play_pitch(sndGrenadeHitWall,random_range(1.2,1.3))
weapon_post(8,0,38)
repeat(2)
{
with mod_script_call("mod","defpack tools","create_spikeball",x,y)
{
	creator = other
	team = other.team
	move_contact_solid(other.gunangle,24)
	motion_add(other.gunangle+random_range(-6,6)*other.accuracy,16)
}
wait(3)
if !instance_exists(self) exit
}

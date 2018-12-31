#define init
global.sprMagnetBomber = sprite_add_weapon("sprMagnetBomber.png",1,2)
#define weapon_name
return "PLASMITE SHOTGUN"
#define weapon_sprt
return global.sprMagnetBomber;
#define weapon_type
return 5
#define weapon_cost
return 2
#define weapon_area
return 6
#define weapon_load
return 18
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return 1
#define weapon_laser_sight
return 0
#define weapon_text
return "JOY BURST";
#define weapon_fire
weapon_post(6,0,18)
if !skill_get(17)
{
	sound_play_pitch(sndPlasma,2)
	sound_play_pitch(sndPlasmaRifle,random_range(1.3,1.45))
}
else
{
	sound_play_pitch(sndPlasmaUpg,2)
	sound_play_pitch(sndPlasmaRifleUpg,random_range(1.3,1.45))
}
repeat(5)
{
	with mod_script_call("mod","defpack tools","create_plasmite",x,y)
	{
		fric = random_range(.06,.08) + .08
		motion_set(other.gunangle+random_range(-34,34)*other.accuracy,16)
		projectile_init(other.team,other)
		image_angle = direction
	}
}

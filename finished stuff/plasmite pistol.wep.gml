#define init
global.sprPlasmitePistol = sprite_add_weapon("sprPlasmitePistol.png",0,1)
#define weapon_name
return "PLASMITE PISTOL"
#define weapon_sprt
return global.sprPlasmitePistol;
#define weapon_type
return 5
#define weapon_cost
return 1
#define weapon_area
return 3
#define weapon_load
return 14
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return 1
#define weapon_laser_sight
return 0
#define weapon_text
return "HAHA YES";
#define weapon_fire
repeat(2)
{
	weapon_post(5,0,4)
	if !skill_get(17)
	{
		sound_play_pitch(sndPlasma,2)
	}
	else
	{
		sound_play_pitch(sndPlasmaUpg,2)
	}
	with mod_script_call("mod","defpack tools","create_plasmite",x,y)
	{
		fric = random_range(.06,.08) + .08
		motion_set(other.gunangle+random_range(-14,14)*other.accuracy,16)
		projectile_init(other.team,other)
		image_angle = direction
	}
	wait(2)
	if !instance_exists(self) exit
}

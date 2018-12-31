#define init
global.sprPlasmiteRifle = sprite_add_weapon("sprPlasmiteRifle.png",0,1)
#define weapon_name
return "PLASMITE RIFLE"
#define weapon_sprt
return global.sprPlasmiteRifle;
#define weapon_type
return 5
#define weapon_cost
return 1
#define weapon_area
return 6
#define weapon_load
return 7
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return 1
#define weapon_laser_sight
return 0
#define weapon_text
return "AH AH";
#define weapon_fire
repeat(2)
{
	weapon_post(4,0,4)
	if !skill_get(17)
	{
		sound_play_pitch(sndPlasma,2)
		sound_play_pitch(sndPlasmaMinigun,random_range(1.3,1.45))
	}
	else
	{
		sound_play_pitch(sndPlasmaUpg,2)
		sound_play_pitch(sndPlasmaMinigunUpg,random_range(1.3,1.45))
	}
	with mod_script_call("mod","defpack tools","create_plasmite",x,y)
	{
		fric = random_range(.04,.05) + .08
		motion_set(other.gunangle+random_range(-8,8)*other.accuracy,26)
		projectile_init(other.team,other)
        image_angle = direction
	}
	wait(2)
	if !instance_exists(self) exit
}

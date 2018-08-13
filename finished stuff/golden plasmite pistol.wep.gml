#define init
global.sprGoldenPlasmitePistol = sprite_add_weapon("sprGoldenPlasmitePistol.png",0,1)
#define weapon_name
return "GOLDEN PLASMITE PISTOL"
#define weapon_sprt
return global.sprGoldenPlasmitePistol;
#define weapon_type
return 5
#define weapon_cost
return 1
#define weapon_area
return 3
#define weapon_load
return 12
#define weapon_swap
sound_play(sndSwapGold)
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
	sound_play_pitchvol(sndSwapGold,random_range(1.05,1.1),.4)
	with mod_script_call("mod","defpack tools","create_plasmite",x,y)
	{
		creator = other
		team = other.team
		speedset = 1
		fric = random_range(.06,.08)
		motion_set(other.gunangle+random_range(-14,14)*other.accuracy,24)
	}
	wait(2)
}

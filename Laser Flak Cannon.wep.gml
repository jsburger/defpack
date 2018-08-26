#define init
global.sprLaserFlakCannon = sprite_add_weapon("sprites/sprLaserFlakCannon.png", 5, 4);

#define weapon_name
return "LASER FLAK CANNON";

#define weapon_sprt
return global.sprLaserFlakCannon;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 23;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 9;

#define weapon_text
return "1/10";

#define weapon_fire
weapon_post(8,-13,53)
if !skill_get(17)
{
	sound_play_pitch(sndFlakCannon,random_range(.6,.8))
	sound_play_pitch(sndLaser,random_range(.6,.8))
	sound_play_pitch(sndPlasma,random_range(.6,.8))
	sound_play_pitch(sndPlasmaRifle,random_range(.6,.8))
}
else
{
	sound_play_pitch(sndFlakCannon,random_range(.6,.8))
	sound_play_pitch(sndLaserUpg,random_range(.6,.8))
	sound_play_pitch(sndPlasmaUpg,random_range(.6,.8))
	sound_play_pitch(sndPlasmaRifleUpg,random_range(.6,.8))
}
with mod_script_call("mod","defpack tools","create_laser_flak",x,y)
{
	creator = other
	move_contact_solid(other.gunangle,8)
	motion_add(other.gunangle+random_range(-6,6)*other.accuracy,14)
	image_angle = direction
	team = other.team
	accuracy = other.accuracy
	if skill_get(17)
	{
		image_xscale = 1.2
		image_yscale = 1.2
	}
}

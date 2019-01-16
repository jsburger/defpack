#define init
global.sprSquareGun = sprite_add_weapon("sprites/sprSquareGun.png", 0, 2);

#define weapon_name
return "SQUARE GUN"

#define weapon_sprt
return global.sprSquareGun;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 28;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 9;

#define weapon_text
return choose("NO HIDING NOW","LOOK AT THIS NERD");

#define weapon_fire
sound_play_pitch(sndSlugger,random_range(1.8,2))
if skill_get(17) = true
{
	sound_play_pitchvol(sndDevastatorUpg,random_range(1.8,2),.4)
		sound_play_pitch(sndPlasmaUpg,random_range(1.3,1.5))
}
else
{
	sound_play_pitchvol(sndDevastator,random_range(1.8,2),.4)
	sound_play_pitch(sndPlasma,random_range(1.3,1.5))
}
//if skill_get(17){sound_play(sndPlasmaUpg)}else{sound_play(sndPlasma)}
weapon_post(4,-5,18)
with mod_script_call("mod","defpack tools","create_square",x,y)
{
	move_contact_solid(other.gunangle,8)
	creator = other
	team    = other.team
	pseudoteam = team
	size    = 1
	motion_add(other.gunangle+random_range(-6,6)*creator.accuracy,6)
}

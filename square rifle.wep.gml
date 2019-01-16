#define init
global.sprSquareRifle = sprite_add_weapon("sprites/sprSquareRifle.png", 0, 2);

#define weapon_name
return "SQUARE RIFLE"

#define weapon_sprt
return global.sprSquareRifle;

#define weapon_type
return 5;

#define weapon_auto
return true;

#define weapon_load
return 16;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 12;

#define weapon_text
return choose("PLAY TETRIS");

#define weapon_fire
sound_play_pitch(sndSlugger,random_range(1.8,2))
if skill_get(17) = true
{
	sound_play_pitchvol(sndDevastatorUpg,random_range(1.8,2),.4)
	sound_play_pitchvol(sndPlasmaRifleUpg,random_range(1.3,1.5),.5)
}
else
{
	sound_play_pitchvol(sndDevastator,random_range(1.8,2),.4)
	sound_play_pitchvol(sndPlasmaRifle,random_range(1.3,1.5),.5)
}
weapon_post(5,-5,18)
with mod_script_call("mod","defpack tools","create_square",x,y)
{
	move_contact_solid(other.gunangle,8)
	creator = other
	team    = other.team
	pseudoteam = team
	size    = 1
	motion_add(other.gunangle+random_range(-6,6)*creator.accuracy,6)
}

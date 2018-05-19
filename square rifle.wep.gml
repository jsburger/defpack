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
return 4;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 12;

#define weapon_text
return choose("PLAY TETRIS");

#define weapon_fire
if skill_get(17){sound_play(sndPlasmaUpg)}else{sound_play(sndPlasma)}
weapon_post(4,-5,7)
with mod_script_call("mod","defpack tools","create_square",x,y)
{
	move_contact_solid(other.gunangle,8)
	creator = other
	team    = other.team
	size    = 1
	motion_add(other.gunangle+random_range(-6,6)*creator.accuracy,6)
}

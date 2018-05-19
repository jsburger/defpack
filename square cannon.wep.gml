#define init
global.sprSquareCannon = sprite_add_weapon("sprites/sprSquareCannon.png", 0, 2);

#define weapon_name
return "SQUARE CANNON"

#define weapon_sprt
return global.sprSquareCannon;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 43;

#define weapon_cost
return 16;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 12;

#define weapon_text
return choose("THE CUBE","IT HUNTS");

#define weapon_fire
if skill_get(17){sound_play(sndPlasmaUpg)}else{sound_play(sndPlasma)}
weapon_post(4,-5,7)
with mod_script_call("mod","defpack tools","create_supersquare",x,y)
{
	move_contact_solid(other.gunangle,16)
	creator = other
	team    = other.team
	size    = 4
	motion_add(other.gunangle+random_range(-6,6)*creator.accuracy,12)
}

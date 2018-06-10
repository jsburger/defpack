#define init
global.sprAutismLauncher = sprite_add_weapon("sprites/sprSquareGun.png", 0, 2);
global.sprAutism         = sprite_add("sprAutism.png",6,7,7)
#define weapon_name
return "AUTISM LAUNCHER"

#define weapon_sprt
return global.sprAutismLauncher;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 28;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 12;

#define weapon_text
return choose("NO HIDING NOW","LOOK AT THIS NERD");

#define weapon_fire
if skill_get(17){sound_play(sndPlasmaUpg)}else{sound_play(sndPlasma)}
weapon_post(4,-5,7)
with mod_script_call("mod","defpack tools","create_square",x,y)
{
	move_contact_solid(other.gunangle,8)
	creator = other
	team    = other.team
	size    = 1
	sprite_index = global.sprAutism
	image_speed = 1 
	motion_add(other.gunangle+random_range(-6,6)*creator.accuracy,6)
}

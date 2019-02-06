#define init
global.sprPsyMachinegun = sprite_add_weapon("sprites/Psy Machinegun.png", 1, 1);

#define weapon_name
return "PSY MACHINEGUN";

#define weapon_sprt
return global.sprPsyMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 6;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "FAREWELL";

#define weapon_fire

weapon_post(3,-5,4)
sound_play_pitch(sndSwapCursed,random_range(1.4,1.7))
sound_play(sndMachinegun)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_purple)
with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,10)
	team = other.team
	motion_add(other.gunangle+random_range(-6,6)*other.accuracy,8)
	image_angle = direction
}

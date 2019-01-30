#define init
global.sprPsySMG = sprite_add_weapon("sprites/Psy SMG.png", 2, 4);

#define weapon_name
return "PSY SMG";

#define weapon_sprt
return global.sprPsySMG;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 4;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "DEAQUANTINIZED";

#define weapon_fire

weapon_post(3,-3,4)
sound_play(sndPistol)
sound_play_pitch(sndSwapCursed,random_range(1.6,1.9))
sound_play_pitch(sndSwapCursed,random_range(1.1,1.3))
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_purple)
with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,3)
	team = other.team
	motion_add(other.gunangle+random_range(-20,20)*other.accuracy,8)
	image_angle = direction
}

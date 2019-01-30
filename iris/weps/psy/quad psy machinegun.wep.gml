#define init
global.sprQuadPsyMachinegun = sprite_add_weapon("sprites/sprQuadPsyMachinegun.png", 6, 4);

#define weapon_name
return "QUAD PSY MACHINEGUN";

#define weapon_sprt
return global.sprQuadPsyMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 6;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "GO GO GO GO";

#define weapon_fire

weapon_post(12,-5,27)
sound_play_pitch(sndSwapCursed,random_range(1.2,1.4))
sound_play_pitch(sndQuadMachinegun,random_range(.6,.8))
repeat(4)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,6), c_purple)
with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,14)
	team = other.team
	motion_add(other.gunangle+17*other.accuracy+random_range(-8,8)*other.accuracy,8)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,14)
	team = other.team
	motion_add(other.gunangle+34*other.accuracy+random_range(-8,8)*other.accuracy,8)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,14)
	team = other.team
	motion_add(other.gunangle-17*other.accuracy+random_range(-8,8)*other.accuracy,8)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,14)
	team = other.team
	motion_add(other.gunangle-34*other.accuracy+random_range(-8,8)*other.accuracy,8)
	image_angle = direction
}

#define init
global.sprTriplePsyMachinegun = sprite_add_weapon("sprites/sprTriplePsyMachinegun.png", 6, 4);

#define weapon_name
return "TRIPLE PSY MACHINEGUN";

#define weapon_sprt
return global.sprTriplePsyMachinegun;

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
return "ESCAPE THIS PLACE";

#define weapon_fire

weapon_post(6,-5,15)
sound_play_pitch(sndSwapCursed,random_range(1.2,1.4))
sound_play_pitch(sndTripleMachinegun,random_range(.6,.8))
repeat(3)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_purple)
with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,10)
	team = other.team
	motion_add(other.gunangle+random_range(-8,8)*other.accuracy,8)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,10)
	team = other.team
	motion_add(other.gunangle+26*other.accuracy+random_range(-8,8)*other.accuracy,8)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,10)
	team = other.team
	motion_add(other.gunangle-26*other.accuracy+random_range(-8,8)*other.accuracy,8)
	image_angle = direction
}

#define init
global.sprPsyMinigun = sprite_add_weapon("sprites/sprPsyMinigun.png", 3, 4);

#define weapon_name
return "PSY MINIGUN";

#define weapon_sprt
return global.sprPsyMinigun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 2;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "IT WAS NICE KNOWING YOU";

#define weapon_fire

sound_play_pitch(sndCursedReminder,.4)
sound_play_pitch(sndMinigun,.8)
weapon_post(3,-12,8)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,4), c_purple)
with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,10)
	team = other.team
	motion_add(other.gunangle+random_range(-15,15)*other.accuracy,8)
	image_angle = direction
}

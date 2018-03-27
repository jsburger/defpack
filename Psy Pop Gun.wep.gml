#define init
global.sprPsyPopGun = sprite_add_weapon("sprites/Psy Pop Gun.png", 3, 2);

#define weapon_name
return "PSY POP GUN";

#define weapon_sprt
return global.sprPsyPopGun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 3;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 6;

#define weapon_text
return "GOOBY";

#define weapon_fire
weapon_post(2,-3,5)
sound_play(sndPopgun)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,4), c_purple)
with mod_script_call("mod", "defpack tools", "create_psy_shell",x,y){
	creator = other
	team = other.team
	motion_add(other.gunangle+random_range(-4,4)*other.accuracy,16)
	image_angle = direction
}

#define init
global.sprGoldenPsyRevolver = sprite_add_weapon("../../sprites/weapons/iris/psy/sprGoldenPsyRevolver.png", 0, 2);

#define weapon_name
return "GOLDEN PSY REVOLVER";

#define weapon_sprt
return global.sprGoldenPsyRevolver;

#define weapon_gold
return -1;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 6;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return choose("NO FURTHER");

#define weapon_fire

weapon_post(2,-3,2)
sound_play(sndGoldPistol)
sound_play_pitch(sndSwapCursed,random_range(1.3,1.6))
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_purple)
with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,5)
	team = other.team
	motion_add(other.gunangle+random_range(-6,6)*other.accuracy,8)
	image_angle = direction
}

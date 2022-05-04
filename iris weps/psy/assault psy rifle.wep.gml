#define init
global.sprAssaultPsyRifle = sprite_add_weapon("../../sprites/weapons/iris/psy/sprAssaultPsyRifle.png", 3, 2);

#define weapon_name
return "PSY ASSAULT RIFLE";

#define weapon_sprt
return global.sprAssaultPsyRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 11;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "NO ESCAPE";

#define weapon_fire

repeat(3)
{
	weapon_post(4,-4,0)
	sound_play_pitch(sndSwapCursed,random_range(1.4,1.7))
	sound_play(sndMachinegun)
	mod_script_call("mod","defpack tools", "shell_yeah", 180, 25, random_range(2,4), c_purple)
	with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,10)
	team = other.team
	motion_add(other.gunangle+random_range(-5,5)*other.accuracy,8)
	image_angle = direction
}
wait(2)
if !instance_exists(self){exit}

}

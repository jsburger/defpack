#define init
global.sprHyperPsyRifle = sprite_add_weapon("sprites/sprHyperPsyRifle.png", 5, 4);

#define weapon_name
return "HYPER PSY RIFLE";

#define weapon_sprt
return global.sprHyperPsyRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 10;

#define weapon_cost
return 5;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "no hope";

#define weapon_fire

repeat(5)
{
	weapon_post(4,-5,5)
	sound_play_pitch(sndSwapCursed,random_range(1.4,1.7))
	sound_play_pitch(sndHyperRifle,.7)
	mod_script_call("mod","defpack tools", "shell_yeah", 180, 15, random_range(3,5), c_purple)
	with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,14)
	team = other.team
	motion_add(other.gunangle+random_range(-4,4)*other.accuracy,7)
	image_angle = direction
}
wait(2)
if !instance_exists(self) exit
}

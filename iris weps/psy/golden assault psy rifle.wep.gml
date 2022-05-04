#define init
global.sprGoldenAssaultPsyRifle = sprite_add_weapon("../../sprites/weapons/iris/psy/sprGoldenAssaultPsyRifle.png", 3, 2);

#define weapon_name
return "GOLDEN PSY ASSAULT RIFLE";

#define weapon_sprt
return global.sprGoldenAssaultPsyRifle;

#define weapon_gold
return -1;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 9;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "NO REMORSE";

#define weapon_fire

repeat(3)
{
	weapon_post(4,-4,0)
	sound_play_pitch(sndSwapCursed,random_range(1.4,1.7))
	sound_play(sndGoldMachinegun)
	mod_script_call("mod","defpack tools", "shell_yeah", 180, 25, random_range(2,4), c_purple)
	with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,10)
	team = other.team
	motion_add(other.gunangle+random_range(-5,5)*other.accuracy,8)
	image_angle = direction
}
wait(3)
if !instance_exists(self){exit}

}

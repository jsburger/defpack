#define init
global.sprHeavyPsyMachinegun = sprite_add_weapon("../../sprites/weapons/iris/psy/sprHeavyPsyMachinegun.png", 6, 2);

#define weapon_name
return "HEAVY PSY MACHINEGUN";

#define weapon_sprt
return global.sprHeavyPsyMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 5;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "WELLFARE";

#define weapon_fire

weapon_post(5,-9,6)
var p = random_range(.8,1.2)
sound_play_pitch(sndPistol,.7*p)
sound_play_pitch(sndSwapCursed,.3*p)
sound_play_pitch(sndCursedPickup,.8*p)
sound_play_pitchvol(sndHeavyMachinegun,1.5*p,.8)
mod_script_call("mod","defpack tools", "shell_yeah_heavy", 100, 25, random_range(2,4), c_purple)
with mod_script_call("mod", "defpack tools", "create_heavy_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,10)
	team = other.team
	motion_add(other.gunangle+random_range(-6,6)*other.accuracy,12)
	image_angle = direction
}

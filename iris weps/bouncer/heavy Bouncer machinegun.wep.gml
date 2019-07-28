#define init
global.sprHeavyBouncerMachinegun = sprite_add_weapon("../../sprites/weapons/iris/bouncer/sprHeavyBouncerMachinegun.png", 4, 2);

#define weapon_name
return "HEAVY BOUNCER MACHINEGUN"

#define weapon_sprt
return global.sprHeavyBouncerMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 5;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return choose("AROUND THE CORNER");

#define weapon_fire
weapon_post(4,-7,3)
var _p = random_range(.8,1.2)
sound_play_pitch(sndBouncerSmg,.7*_p)
sound_play_pitch(sndHeavyMachinegun,1.2*_p)
sound_play_pitch(sndBouncerShotgun,1.6*_p)
mod_script_call("mod","defpack tools", "shell_yeah_heavy", 100, 25, 2+random(3), c_yellow)
with mod_script_call("mod", "defpack tools", "create_heavy_bouncer_bullet",x,y){
	creator = other
	team = other.team
	motion_set(other.gunangle + random_range(-5,5) * other.accuracy,8)
	move_contact_solid(direction,8)
	image_angle = direction + 90
}

#define init
global.sprTriplePsyMachinegun = sprite_add_weapon("../../sprites/weapons/iris/psy/sprTriplePsyMachinegun.png", 6, 4);

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

var i = -1;
with mod_script_call_self("mod", "defpack tools", "shoot_n_psy_bullets", x, y, 3, team) {
	move_contact_solid(other.gunangle, 10)
    motion_set(other.gunangle + (random_range(-8, 8) + 26 * i) * other.accuracy, 8)
    i++
    image_angle = direction
    projectile_init(other.team, other)
}
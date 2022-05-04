#define init
global.sprQuadPsyMachinegun = sprite_add_weapon("../../sprites/weapons/iris/psy/sprQuadPsyMachinegun.png", 6, 4);

#define weapon_name
return "QUAD PSY MACHINEGUN";

#define weapon_sprt
return global.sprQuadPsyMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 4;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "PSY BULLETS CAN TARGET#DIFFERENT ENEMIES";

#define weapon_fire

weapon_post(12,-5,27)
sound_play_pitch(sndSwapCursed,random_range(1.2,1.4))
sound_play_pitch(sndQuadMachinegun,random_range(.6,.8))
repeat(4)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,6), c_purple)

var i = -2;
with mod_script_call_self("mod", "defpack tools", "shoot_n_psy_bullets", x, y, 4, team) {
	move_contact_solid(other.gunangle, 10)
    motion_set(other.gunangle + (random_range(-8, 8) + 17 * i) * other.accuracy, 8)
    if ++i == 0 i++
    image_angle = direction
    projectile_init(other.team, other)
}
#define init
global.sprHorrorSmg = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprHorrorSmgOn.png", 3, 3);

#define weapon_name
return "GAMMA SMG";

#define weapon_sprt
return global.sprHorrorSmg;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 3;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "SPREAD";

#define weapon_fire

weapon_post(2,-6,2)
sound_play_pitchvol(sndRadPickup,1.2, 1.7)
sound_play_pitchvol(sndUltraPistol,3, .7)
sound_play_pitch(sndMachinegun,random_range(1.2,1.4))
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,4), c_lime)
var _i = 9;
repeat(2) with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-_i,_i) * other.accuracy,random_range(14,18))
	image_angle = direction
    _i = 21;
}

#define init
global.sprHeavyHorrorMachinegun = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprHeavyHorrorMachinegunOn.png", 6, 2);

#define weapon_name
return "HEAVY GAMMA MACHINEGUN";

#define weapon_sprt
return global.sprHeavyHorrorMachinegun;

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
return "AUTO IS BETTER";

#define weapon_fire

var _i = 5;
weapon_post(2,-8,2)
sound_play_pitchvol(sndRadPickup,1.2, 1.7)
sound_play_pitchvol(sndUltraPistol,3, .7)
sound_play_pitch(sndHeavyMachinegun,random_range(1.2,1.4))
mod_script_call("mod","defpack tools", "shell_yeah_heavy", 100, 25, random_range(2,4), c_lime)
repeat(2) with mod_script_call("mod", "defpack tools", "create_heavy_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-_i,_i) * other.accuracy,random_range(14,16))
	image_angle = direction
    _i = 13;
}

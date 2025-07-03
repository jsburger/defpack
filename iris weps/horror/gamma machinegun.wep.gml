#define init
global.sprHorrorMachinegun = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprHorrorMachinegunOn.png", 3, 1);

#define weapon_name
return "GAMMA MACHINEGUN";

#define weapon_sprt
return global.sprHorrorMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 5;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "HOLD THE LINE";

#define weapon_fire

weapon_post(2,-6,2)
sound_play_pitchvol(sndRadPickup,1.2, 1.7)
sound_play_pitchvol(sndUltraPistol,3, .7)
sound_play_pitch(sndMachinegun,random_range(1.2,1.4))
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_lime)
repeat(2) with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-15,15) * other.accuracy,random_range(14,18))
	image_angle = direction
}
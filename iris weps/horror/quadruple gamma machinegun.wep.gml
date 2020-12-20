#define init
global.sprQuadHorrorMachinegun = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprQuadHorrorMachinegunOn.png", 3, 5);

#define weapon_name
return "QUADRUPLE GAMMA MACHINEGUN";

#define weapon_sprt
return global.sprQuadHorrorMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 4;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "PEACE";

#define weapon_fire

weapon_post(5,-12,2)
sound_play_pitchvol(sndRadPickup,1.2, 1.7)
sound_play_pitchvol(sndUltraPistol,3, .7)
sound_play_pitch(sndTripleMachinegun,random_range(1.2,1.4))
repeat(3)mod_script_call("mod","defpack tools", "shell_yeah", 100, 32, random_range(4,7), c_lime)

repeat(2) with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle - 36 * other.accuracy + random_range(-9,9) * other.accuracy,random_range(14,18))
	image_angle = direction
}repeat(2) with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle - 14 * other.accuracy + random_range(-9,9) * other.accuracy,random_range(14,18))
	image_angle = direction
}
repeat(2) with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle + 36 * other.accuracy + random_range(-9,9) * other.accuracy,random_range(14,18))
	image_angle = direction
}repeat(2) with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle + 14 * other.accuracy + random_range(-9,9) * other.accuracy,random_range(14,18))
	image_angle = direction
}
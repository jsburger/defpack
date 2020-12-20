#define init
global.sprDoubleHorrorMinigunOn = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprDoubleHorrorMinigunOn.png", 4, 4);

#define weapon_name
return "DOUBLE GAMMA MINIGUN";

#define weapon_sprt
return global.sprDoubleHorrorMinigunOn;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 1;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "CONSUME THEIR @wBULLETS";

#define weapon_fire
motion_add(gunangle-180, 1)
weapon_post(2,-8,6 + random(2))
sound_play_pitchvol(sndRadPickup,1.2, 1.7)
sound_play_pitchvol(sndUltraPistol,3, .7)
sound_play_pitch(sndDoubleMinigun,random_range(.9,1.1))
mod_script_call("mod","defpack tools", "shell_yeah", 100, 40, random_range(3,5), c_lime)
repeat(2) with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle + 20 + random_range(-16,16) * other.accuracy,random_range(14,18))
	image_angle = direction
}
repeat(2) with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle - 20 + random_range(-16,16) * other.accuracy,random_range(14,18))
	image_angle = direction
}
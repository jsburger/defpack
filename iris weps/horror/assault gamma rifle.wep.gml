#define init
global.sprAssaultBouncerRifle = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprAssaultHorrorRifleOn.png", 4, 2);

#define weapon_name
return "GAMMA ASSAULT RIFLE"

#define weapon_sprt
return global.sprAssaultBouncerRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 12;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return choose("IN AND OUT");

#define weapon_fire

repeat(3)
{
	weapon_post(2,-8,2)
	sound_play_pitchvol(sndRadPickup,1.2, 1.7)
	sound_play_pitchvol(sndUltraPistol,3, .7)
	sound_play_pitch(sndPistol,random_range(1.2,1.4))
	mod_script_call("mod","defpack tools", "shell_yeah", 180, 25, random_range(2,4), c_lime)
	repeat(2) with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-12,12) * other.accuracy,random_range(14,18))
	image_angle = direction
}
	wait(2)
	if !instance_exists(self){exit}
}

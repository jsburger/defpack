#define init
global.sprHyperHorrorRifle = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprHyperHorrorRifleOn.png", 5, 6);

#define weapon_name
return "HYPER GAMMA RIFLE"

#define weapon_sprt
return global.sprHyperHorrorRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 3;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return choose("MERGED TECHNOLOGIES");

#define weapon_fire

repeat(6)
{
    var _i = 4;
	weapon_post(2,-8,4)
	sound_play_pitchvol(sndRadPickup,1.2, 1.7)
	sound_play_pitchvol(sndUltraPistol,3, .7)
	sound_play_pitch(sndHyperRifle,random_range(1.2,1.4))
	mod_script_call("mod","defpack tools", "shell_yeah", 180, 25, random_range(2,4), c_lime)
	repeat(2) with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-_i,_i) * other.accuracy,random_range(14,18))
	image_angle = direction
    _i = 12;
}
	wait(1)
	if !instance_exists(self){exit}
}

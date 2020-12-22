#define init
global.sprGammaRogueRifle = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprHorrorRogueRifleOn.png", 2, 2);

#define weapon_name
return "GAMMA ROGUE RIFLE"

#define weapon_sprt
return global.sprGammaRogueRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 6;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return choose("THEY WOULD LIKE THAT");

#define weapon_fire

repeat(2)
{
	weapon_post(2,-8,2)
	sound_play_pitchvol(sndRadPickup,1.2, 1.7)
	sound_play_pitchvol(sndUltraPistol,3, .7)
	sound_play_pitch(sndRogueRifle,random_range(1.3,1.5))
	mod_script_call("mod","defpack tools", "shell_yeah", 180, 25, random_range(2,4), c_lime)
	repeat(2) with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-8,8) * other.accuracy,random_range(14,18))
	image_angle = direction
}
	wait(2)
	if !instance_exists(self){exit}
}
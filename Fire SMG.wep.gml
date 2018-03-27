#define init
global.sprFireSMG = sprite_add_weapon("sprites/Fire SMG.png", 2, 4);

#define weapon_name
return "FIRE SMG";

#define weapon_sprt
return global.sprFireSMG;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 4;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 8;

#define weapon_text
return "WELL I HEAR YOU WHISPERING IN THE WORDS";

#define weapon_fire

weapon_post(3,-2,4)
sound_play(sndPistol)
sound_play_pitchvol(sndSwapFlame,random_range(1.4,1.6),.7)
sound_play_pitchvol(sndIncinerator,1,.2)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_red)
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x+lengthdir_x(5,gunangle),y+lengthdir_y(5,gunangle)){
    creator = other
    team = other.team
    motion_set(other.gunangle + choose(random_range(4,13),-random_range(4,13)) * other.accuracy,15)
	image_angle = direction
}

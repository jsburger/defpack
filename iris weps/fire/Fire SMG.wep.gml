#define init
global.sprFireSMG = sprite_add_weapon("../../sprites/weapons/iris/fire/sprFireSMG.png", 2, 4);

#define weapon_name
return "FIRE SMG";

#define weapon_sprt
return global.sprFireSMG;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 2.5;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "SPRAYING HELL";

#define weapon_fire

weapon_post(3,-2,4)
var vol = .8;
sound_play_pitchvol(sndPistol, 1, vol)
sound_play_pitchvol(sndSwapFlame, random_range(1.4,1.6), .7 * vol)
sound_play_pitchvol(sndIncinerator, 1, .2 * vol)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_red)
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
    creator = other
    team = other.team
    move_contact_solid(other.gunangle,4)
    motion_set(other.gunangle + random_range(-27,27) * other.accuracy,15)
	image_angle = direction
}

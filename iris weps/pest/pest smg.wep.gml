#define init
global.sprPestSMG = sprite_add_weapon("../../sprites/weapons/iris/pest/sprPestSMG.png", 4, 1);
#define weapon_name
return "PEST SMG";

#define weapon_sprt
return global.sprPestSMG;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 3;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "UNENDING TOXICITY";

#define weapon_fire

weapon_post(4,-5,5)
var vol = .6;
sound_play_pitchvol(sndMinigun,random_range(.6,.8), vol)
sound_play_pitchvol(sndPistol,random_range(1.2,1.4), vol)
sound_play_pitchvol(sndToxicBoltGas,random_range(3,3.8), vol)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_green)
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
  move_contact_solid(other.gunangle,6)
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-12,12) * other.accuracy,16)
	image_angle = direction
}

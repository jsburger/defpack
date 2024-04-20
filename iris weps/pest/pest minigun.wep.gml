#define init
global.sprPestMinigun = sprite_add_weapon("../../sprites/weapons/iris/pest/sprPestMinigun.png", 5, 5);
#define weapon_name
return "PEST MINIGUN";

#define weapon_sprt
return global.sprPestMinigun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 1;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "HOLD YOUR BREATH#WHILE RELOADING";

#define weapon_fire

weapon_post(4,-5,5)
var vol = .7;
sound_play_pitchvol(sndMinigun,random_range(.6,.8), vol)
sound_play_pitchvol(sndToxicBoltGas,random_range(4,4.8), vol)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_green)
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
  move_contact_solid(other.gunangle,10)
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-9,9) * other.accuracy,16)
	image_angle = direction
}

#define init
global.sprDoublePestMinigun = sprite_add_weapon("sprites/sprDoublePestMinigun.png", 5, 3);
#define weapon_name
return "DOUBLE PEST MINIGUN";

#define weapon_sprt
return global.sprDoublePestMinigun;

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
return "A SHAME TO OUR ANCESTORS";

#define weapon_fire

weapon_post(7,-5,10)
motion_add(gunangle - 180,1)
sound_play_pitch(sndDoubleMinigun,random_range(.6,.8))
sound_play_pitch(sndToxicBoltGas,random_range(4,4.8))
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_green)
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
  move_contact_solid(other.gunangle,10)
    creator = other
    team = other.team
    motion_set(other.gunangle + 12 + random_range(-9,9) * other.accuracy,10)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
  move_contact_solid(other.gunangle,10)
    creator = other
    team = other.team
    motion_set(other.gunangle - 12 + random_range(-9,9) * other.accuracy,10)
	image_angle = direction
}

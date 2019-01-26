#define init
global.sprTriplePestMachinegun = sprite_add_weapon("sprites/sprTriplePestMachinegun.png", 4, 5);
#define weapon_name
return "TRIPLE PEST MACHINEGUN";

#define weapon_sprt
return global.sprTriplePestMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 4;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "spread the @gBLIGHT";

#define weapon_fire

weapon_post(6,-5,7)
sound_play_pitch(sndMinigun,random_range(.6,.8))
sound_play_pitch(sndTripleMachinegun,random_range(1.2,1.4))
sound_play_pitch(sndToxicBoltGas,random_range(3,3.8))
repeat(3)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,4), c_green)
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
    creator = other
    team = other.team
    move_contact_solid(other.gunangle,11)
    motion_set(other.gunangle + 20 * other.accuracy + random_range(-2,2) * other.accuracy,10)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
    creator = other
    team = other.team
    move_contact_solid(other.gunangle,11)
    motion_set(other.gunangle + random_range(-2,2) * other.accuracy,10)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
    creator = other
    team = other.team
    move_contact_solid(other.gunangle,11)
    motion_set(other.gunangle - 20 * other.accuracy + random_range(-2,2) * other.accuracy,10)
	image_angle = direction
}

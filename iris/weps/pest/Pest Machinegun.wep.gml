#define init
global.sprPestMachinegun = sprite_add_weapon("sprites/sprPestMachinegun.png", 4, 1);
#define weapon_name
return "PEST MACHINEGUN";

#define weapon_sprt
return global.sprPestMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 5;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "SIIIIICK";

#define weapon_fire

weapon_post(4,-5,5)
sound_play_pitch(sndMinigun,random_range(.6,.8))
sound_play_pitch(sndPistol,random_range(1.2,1.4))
sound_play_pitch(sndToxicBoltGas,random_range(3,3.8))
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_green)
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
    creator = other
    team = other.team
    move_contact_solid(other.gunangle,8)
    motion_set(other.gunangle + random_range(-6,6) * other.accuracy,10)
	image_angle = direction
}

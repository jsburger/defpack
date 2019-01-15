#define init
global.sprQuadPestMachinegun = sprite_add_weapon("sprites/sprQuadPestMachinegun.png", 4, 5);
#define weapon_name
return "QUAD PEST MACHINEGUN";

#define weapon_sprt
return global.sprQuadPestMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 4;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "DONT GET TOO CLOSE";

#define weapon_fire

weapon_post(8,-5,12)
sound_play_pitch(sndMinigun,random_range(.4,.6))
sound_play_pitch(sndQuadMachinegun,random_range(1.2,1.4))
sound_play_pitch(sndToxicBoltGas,random_range(3,3.8))
repeat(4)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,7), c_green)
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
    creator = other
    team = other.team
    move_contact_solid(other.gunangle,11)
    motion_set(other.gunangle + 20 + random_range(-2,2) * other.accuracy,10)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
    creator = other
    team = other.team
    move_contact_solid(other.gunangle,11)
    motion_set(other.gunangle + 8  + random_range(-2,2) * other.accuracy,10)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
    creator = other
    team = other.team
    move_contact_solid(other.gunangle,11)
    motion_set(other.gunangle - 20 + random_range(-2,2) * other.accuracy,10)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
    creator = other
    team = other.team
    move_contact_solid(other.gunangle,11)
    motion_set(other.gunangle - 8 + random_range(-2,2) * other.accuracy,10)
	image_angle = direction
}

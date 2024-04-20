#define init
global.sprHeavyPestMachinegun = sprite_add_weapon("../../sprites/weapons/iris/pest/sprHeavyPestMachinegun.png", 4, 3);

#define weapon_name
return "HEAVY PEST MACHINEGUN";

#define weapon_sprt
return global.sprHeavyPestMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 5;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "PROBABLY A BAD IDEA";

#define weapon_fire

weapon_post(3,-8,2)
var _p = random_range(.8,1.2),
	vol = .6;
sound_play_pitchvol(sndDoubleMinigun,1.3 * _p, vol)
sound_play_pitchvol(sndPistol,.5 * _p, vol)
sound_play_pitchvol(sndHeavyMachinegun,1.2 * _p, vol)
sound_play_pitchvol(sndToxicBarrelGas,1.2 * _p, vol)
sound_play_pitchvol(sndToxicBoltGas,.8*_p,.6 * vol)
mod_script_call("mod","defpack tools", "shell_yeah_heavy", 100, 25, random_range(3,5), c_green)
with mod_script_call("mod", "defpack tools", "create_heavy_toxic_bullet",x+lengthdir_x(8,gunangle),y+lengthdir_y(8,gunangle)){
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-3,3) * other.accuracy,16)
	image_angle = direction
}

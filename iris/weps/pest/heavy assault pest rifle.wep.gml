#define init
global.sprHeavyPestAssaultRifle = sprite_add_weapon("sprites/sprHeavyPestAssaultRifle.png", 7, 3);

#define weapon_name
return "HEAVY PEST ASSAULT RIFLE";

#define weapon_sprt
return global.sprHeavyPestAssaultRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 10;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "OVERLOADED";

#define weapon_fire

repeat(3)
{
weapon_post(3,-6,2)
var _p = random_range(.8,1.2)
sound_play_pitch(sndDoubleMinigun,1.3*_p)
sound_play_pitch(sndPistol,.5*_p)
sound_play_pitch(sndHeavyRevoler,1.2*_p)
sound_play_pitch(sndToxicBarrelGas,1.2*_p)
sound_play_pitchvol(sndToxicBoltGas,.8*_p,.6)
mod_script_call("mod","defpack tools", "shell_yeah_heavy", 180, 25, random_range(2,4), c_green)
with mod_script_call("mod", "defpack tools", "create_heavy_toxic_bullet",x+lengthdir_x(8,gunangle),y+lengthdir_y(8,gunangle)){
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-2,2) * other.accuracy,16)
	image_angle = direction
}
wait(2)
if !instance_exists(self){exit}
}

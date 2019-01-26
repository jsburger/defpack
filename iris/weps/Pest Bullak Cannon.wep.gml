#define init
global.sprPestBullakCannon = sprite_add_weapon("sprites/sprPestBullakCannon.png", 4, 3);

#define weapon_name
return "PEST BULLAK CANNON"

#define weapon_sprt
return global.sprPestBullakCannon;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 18;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "@gCABBAGE @sLAUNCHER";

#define weapon_fire

mod_script_call("mod","defpack tools", "shell_yeah_big", 100, 12, 4+random(1), c_green)
sound_play_pitch(sndPistol,random_range(0.7,0.8))
sound_play_pitch(sndMachinegun,random_range(0.7,0.8))
sound_play_pitch(sndPopgun,random_range(.6,.8))
sound_play_pitch(sndQuadMachinegun,random_range(1.4,1.6))
sound_play_pitch(sndFlakCannon,random_range(.6,.8))
sound_play_pitch(sndHeavyNader,random_range(1.6,1.8))
sound_play_pitch(sndToxicBoltGas,random_range(.8,.85))
sound_play_pitch(sndMinigun,random_range(.7,.9))
weapon_post(6,-4,21)
with mod_script_call_self("mod", "defpack tools 2", "create_toxic_bullak", x, y){
    accuracy = other.accuracy
    creator = other
    team = other.team
    motion_set(other.gunangle+random_range(3,3) * other.accuracy, 18)
    image_angle = direction
}

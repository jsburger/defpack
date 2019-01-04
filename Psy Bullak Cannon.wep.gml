#define init
global.sprPsyBullakCannon = sprite_add_weapon("sprites/sprPsyBullakCannon.png", 0, 3);

#define weapon_name
return "PSY BULLAK CANNON"

#define weapon_sprt
return global.sprPsyBullakCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 38;

#define weapon_cost
return 20;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "BETTER HIT DIRECTLY";

#define weapon_fire

mod_script_call("mod","defpack tools", "shell_yeah_big", 100, 12, 4+random(1), c_purple)
sound_play_pitch(sndPistol,random_range(0.7,0.8))
sound_play_pitch(sndMachinegun,random_range(0.7,0.8))
sound_play_pitch(sndPopgun,random_range(.6,.8))
sound_play_pitch(sndQuadMachinegun,random_range(1.4,1.6))
sound_play_pitch(sndFlakCannon,random_range(.6,.8))
sound_play_pitch(sndHeavyNader,random_range(1.6,1.8))
sound_play_pitch(sndCursedReminder,random_range(.6,.8))
weapon_post(6,-4,21)
with mod_script_call_self("mod", "defpack tools 2", "create_psy_bullak", x, y){
    accuracy = other.accuracy
    creator = other
    team = other.team
    motion_set(other.gunangle+random_range(3,3) * other.accuracy, 8)
    image_angle = direction
}

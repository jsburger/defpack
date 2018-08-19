#define init
global.sprGoldenBullakCannon = sprite_add_weapon("sprites/sprGoldenBullakCannon.png", 3, 3);

#define weapon_gold
return 1;

#define weapon_name
return "GOLDEN BULLAK CANNON"

#define weapon_sprt
return global.sprGoldenBullakCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 18;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return " 90/100";

#define weapon_fire

mod_script_call("mod","defpack tools", "shell_yeah_big", 100, 12, 4+random(1), c_yellow)
sound_play_pitch(sndGoldPistol,random_range(0.7,0.8))
sound_play_pitch(sndGoldMachinegun,random_range(0.7,0.8))
sound_play_pitch(sndPopgun,random_range(.6,.8))
sound_play_pitch(sndQuadMachinegun,random_range(1.4,1.6))
sound_play_pitch(sndFlakCannon,random_range(.6,.8))
sound_play_pitch(sndHeavyNader,random_range(1.6,1.8))
weapon_post(6,-4,21)
mod_script_call("mod", "defpack tools 2","create_flak",0,2,13,0,Bullet1,10,id)

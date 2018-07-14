#define init
global.sprBullakMachinegun = sprite_add_weapon("sprites/sprBullakMachinegun.png", 5, 3);

#define weapon_name
return "BULLAK MACHINEGUN"

#define weapon_sprt
return global.sprBullakMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 8;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 10;

#define weapon_text
return "WHOOP/WHOOP";

#define weapon_fire
sound_play_pitch(sndSlugger,random_range(0.7,0.8))
sound_play_pitch(sndMachinegun,random_range(0.7,0.8))
sound_play_pitch(sndPopgun,random_range(.6,.8))
sound_play_pitch(sndQuadMachinegun,random_range(1.4,1.6))
sound_play_pitch(sndFlakCannon,random_range(.6,.8))
sound_play_pitch(sndHeavyNader,random_range(1.6,1.8))
weapon_post(4,-4,11)
mod_script_call("mod","defpack tools", "shell_yeah_big", 100, 12, 4+random(1), c_yellow)
mod_script_call("mod", "defpack tools 2","create_flak",0,14,13,0,Bullet1,3,id)

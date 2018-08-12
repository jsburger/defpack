#define init
global.sprBulletFlakCannon = sprite_add_weapon("sprites/sprBouncerBullakCannon.png", 3, 3);

#define weapon_name
return "BULLAK CANNON"

#define weapon_sprt
return global.sprBulletFlakCannon;

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
return 5;

#define weapon_text
return " 90/100";

#define weapon_fire

mod_script_call("mod","defpack tools", "shell_yeah_big", 100, 12, 4+random(1), c_yellow)
sound_play_pitch(sndPistol,random_range(0.7,0.8))
sound_play_pitch(sndMachinegun,random_range(0.7,0.8))
sound_play_pitch(sndPopgun,random_range(.6,.8))
sound_play_pitch(sndQuadMachinegun,random_range(1.4,1.6))
sound_play_pitch(sndFlakCannon,random_range(.6,.8))
sound_play_pitch(sndHeavyNader,random_range(1.6,1.8))
weapon_post(6,-4,21)
mod_script_call("mod", "defpack tools 2","create_flak",0,5,13,0,BouncerBullet,10,id) //not gonna lie this shit spooks the fuck outta me, i swear somethings gonna go wrong

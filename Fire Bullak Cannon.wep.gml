#define init
global.sprFireBullakCannon = sprite_add_weapon("sprites/sprFireBullakCannon.png", 3, 3);

#define weapon_name
return "FIRE BULLAK CANNON"

#define weapon_sprt
return global.sprFireBullakCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 9;

#define weapon_cost
return 20;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return choose("HOTTEST SCORE","LIKE SEVEN INCHES#FROM THE MIDDAY SUN");

#define weapon_fire
weapon_post(4,-6,7)
mod_script_call("mod","defpack tools", "shell_yeah_big", 100, 12, 4+random(1), c_red)
sound_play_pitch(sndPistol,random_range(0.7,0.8))
sound_play_pitch(sndMachinegun,random_range(0.7,0.8))
sound_play_pitch(sndPopgun,random_range(.6,.8))
sound_play_pitch(sndQuadMachinegun,random_range(1.4,1.6))
sound_play_pitch(sndFlakCannon,random_range(.6,.8))
sound_play_pitch(sndHeavyNader,random_range(1.6,1.8))
sound_play_pitchvol(sndFlameCannon,random_range(1.8,2.2),.8)
mod_script_call("mod", "defpack tools 2","create_flak",0,21,13,0,1,10,id)

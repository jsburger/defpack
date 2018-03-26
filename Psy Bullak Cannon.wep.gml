#define init
global.sprPsyBulletFlakCannon = sprite_add_weapon("Psy Bullet Flak Cannon.png", 0, 3);

#define weapon_name
return "PSY BULLAK CANNON"

#define weapon_sprt
return global.sprPsyBulletFlakCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 82;

#define weapon_cost
return 20;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 10;

#define weapon_text
return "BETTER HIT DIRECTLY";

#define weapon_fire

repeat(22)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_purple)
sound_play_pitch(sndPistol,random_range(0.7,0.8))
sound_play_pitch(sndGrenadeRifle,random_range(1.1,1.3))
sound_play_pitch(sndFlakCannon,random_range(1.1,1.3))
sound_play_pitch(sndBouncerShotgun,.55)
weapon_post(6,-8,8)
mod_script_call("mod", "defpack tools 2","create_flak",0,20,13,0,4,8,id)

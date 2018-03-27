#define init
global.sprPestBulletFlakCannon = sprite_add_weapon("sprites/Pest Bullet Flak Cannon.png", 4, 3);

#define weapon_name
return "PEST BULLAK CANNON"

#define weapon_sprt
return global.sprPestBulletFlakCannon;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 24;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 6;

#define weapon_text
return "@gCABBAGE @sLAUNCHER";

#define weapon_fire

repeat(22) mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_green)
sound_play_pitch(sndPistol,random_range(0.7,0.8))
sound_play_pitch(sndGrenadeRifle,random_range(1.1,1.3))
sound_play_pitch(sndFlakCannon,random_range(1.1,1.3))
sound_play_pitch(sndToxicBoltGas,random_range(.8,.85))
weapon_post(4,-8,6)
with mod_script_call("mod", "defpack tools 2","create_flak",0,20,13,0,2,10,id){
	speed += 2
}

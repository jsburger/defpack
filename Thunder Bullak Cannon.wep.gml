#define init
global.sprThunderBulletFlakCannon = sprite_add_weapon("Thunder Bullet Flak Cannon.png", 0, 3);

#define weapon_name
return "THUNDER BULLAK CANNON"

#define weapon_sprt
return global.sprThunderBulletFlakCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 48;

#define weapon_cost
return 16;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 10;

#define weapon_text
return "BALL LIGHTNING";

#define weapon_fire

repeat(16){
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_navy)
}
sound_play_pitch(sndPistol,random_range(0.7,0.8))
sound_play_pitch(sndGrenadeRifle,random_range(1.1,1.3))
sound_play_pitch(sndFlakCannon,random_range(1.1,1.3))
if !skill_get(17)sound_play_pitch(sndLightningCannon,random_range(1.6,1.8))else sound_play_pitch(sndLightningCannonUpg,random_range(1.6,1.8))
weapon_post(8,-6,9)
with mod_script_call("mod", "defpack tools 2","create_flak",0,6,13,0,3,8,id){
	speed += 3
}

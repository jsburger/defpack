#define init
global.sprThunderBulletFlakCannon = sprite_add_weapon("sprites/Thunder Bullet Flak Cannon.png", 0, 3);

#define weapon_name
return "THUNDER BULLAK CANNON"

#define weapon_sprt
return global.sprThunderBulletFlakCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 18;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return -1;

#define weapon_text
return "BALL LIGHTNING";

#define weapon_fire

mod_script_call("mod","defpack tools", "shell_yeah_big", 100, 12, 4+random(1), c_navy)
sound_play_pitch(sndPistol,random_range(0.7,0.8))
sound_play_pitch(sndMachinegun,random_range(0.7,0.8))
sound_play_pitch(sndPopgun,random_range(.6,.8))
sound_play_pitch(sndQuadMachinegun,random_range(1.4,1.6))
sound_play_pitch(sndFlakCannon,random_range(.6,.8))
sound_play_pitch(sndHeavyNader,random_range(1.6,1.8))
if !skill_get(17)sound_play_pitch(sndLightningCannon,random_range(1.6,1.8))else sound_play_pitch(sndLightningCannonUpg,random_range(1.6,1.8))
weapon_post(8,-6,9)
with mod_script_call_self("mod", "defpack tools 2", "create_lightning_bullak", x, y){
    accuracy = other.accuracy
    creator = other
    team = other.team
    motion_set(other.gunangle+random_range(3,3) * other.accuracy, 19)
    image_angle = direction
}

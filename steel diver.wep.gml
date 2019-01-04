#define init
global.sprSteelDiver = sprite_add_weapon("sprites/sprSteelDiver.png", 5, 3);

#define weapon_name
return "STEEL DIVER"

#define weapon_sprt
return global.sprSteelDiver;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 43;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return -1;

#define weapon_text
return "TAKE A DIVE";

#define weapon_fire

sound_play_pitch(sndSlugger,1.5)
sound_play_pitch(sndShotgun,1.5)
sound_play_pitch(sndDoubleShotgun,1.5)
sound_play_pitch(sndSuperSlugger,1.5)
weapon_post(7,-40,5)
with mod_script_call_self("mod", "defpack tools 2", "create_split_flak", x, y){
    motion_set(other.gunangle + random_range(-2, 2) * other.accuracy, 16)
    image_xscale += .5
    image_yscale += .5
    heavy = 1
    projectile_init(other.team,other)
    image_angle = direction
    accuracy = other.accuracy
}
with mod_script_call_self("mod", "defpack tools 2", "create_split_flak", x, y){
    motion_set(other.gunangle - 20 * other.accuracy, 16)
    projectile_init(other.team,other)
    image_angle = direction
    accuracy = other.accuracy
}
with mod_script_call_self("mod", "defpack tools 2", "create_split_flak", x, y){
    motion_set(other.gunangle + 20 * other.accuracy, 16)
    projectile_init(other.team,other)
    image_angle = direction
    accuracy = other.accuracy
}

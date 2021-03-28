#define init
global.sprKnifeThrower = sprite_add_weapon("sprites/weapons/sprKnifeThrower.png", 0, 2)
#define weapon_name
return "KNIFE THROWER"
#define weapon_type
return 3
#define weapon_cost
return 1
#define weapon_area
return 4
#define weapon_load
return 22
#define weapon_swap
return sndSwapBow
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 1
#define weapon_sprt
return global.sprKnifeThrower
#define weapon_reloaded
#define nts_weapon_examine
return{
    "d": "Launches cheaply made knife blades forwards. #The knives are surprisingly bouncy. ",
}

#define weapon_text
return choose("REN FAIRE", "@wKNIVES@s CAN HIT TWO THINGS AT ONCE")

#define weapon_fire
var _p = random_range(.8, 1.2)
sound_play_pitch(sndCrossbow, 2 * _p)
sound_play_pitchvol(sndHeavySlugger, 12 * _p, .5)
sound_play_pitchvol(sndSwapSword, 1.5 * _p, .6)
weapon_post(3, -20, 10)
with mod_script_call_nc("mod", "defpack tools", "create_knife", x, y){
    motion_set(other.gunangle + random_range(-3,3) * other.accuracy, random_range(18, 22))
    image_yscale = -other.right
    projectile_init(other.team, other)
    image_angle = direction
}

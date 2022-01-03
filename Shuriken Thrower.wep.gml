#define init
global.sprSwordThrower = sprite_add_weapon("sprites/weapons/sprShurikenThrower.png", 5, 4)
#define weapon_name
return "SHURIKEN THROWER"
#define weapon_type
return 3
#define weapon_cost
return 1
#define weapon_area
return 9
#define weapon_load
return 13
#define weapon_swap
return sndSwapBow
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 1
#define weapon_sprt
return global.sprSwordThrower
#define weapon_reloaded
#define nts_weapon_examine
return{
    "d": "The logical conclusion of enthusiast weaponry. ",
}

#define weapon_text
return choose("SHARP AS ALL CAN BE", "@wBLADES@s CAN HIT TWO THINGS AT ONCE")

#define weapon_fire
var _p = random_range(.8, 1.2)
// sound_play_pitch(sndSuperSplinterGun, 2.5 * _p)
// sound_play_pitchvol(sndHeavySlugger, 6 * _p, .7)
sound_play_pitch(sndSwapSword, 1.5 * _p)
sound_play_pitchvol(sndCrystalRicochet, 1.6 * _p, 1.5)
sound_play_pitchvol(sndSuperCrossbow, 1.4 * _p, .8)
weapon_post(7, 20, 10)
with mod_script_call_nc("mod", "defpack tools", "create_shuriken", x, y) {
    motion_set(other.gunangle, 16)
    image_yscale = -other.right
    projectile_init(other.team, other)
    image_angle = direction
}

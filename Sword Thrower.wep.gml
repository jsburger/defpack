#define init
global.sprSwordThrower = sprite_add_weapon("sprites/weapons/sprSwordThrower.png", 2, 4)
#define weapon_name
return "SWORD THROWER"
#define weapon_type
return 3
#define weapon_cost
return 2
#define weapon_area
return 8
#define weapon_load
return 25
#define weapon_swap
return sndSwapBow
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 1
#define weapon_sprt
return global.sprSwordThrower
#define weapon_reloaded

#define weapon_text
return choose("SHARP AS ALL CAN BE", "@wSWORDS@s CAN HIT TWO THINGS AT ONCE")

#define weapon_fire
var _p = random_range(.8, 1.2)
sound_play_pitch(sndHeavyCrossbow, 2 * _p)
sound_play_pitchvol(sndHeavySlugger, 6 * _p, .7)
sound_play_pitch(sndSwapSword, 1.5 * _p)
weapon_post(7, -44, 10)
with mod_script_call_nc("mod", "defpack tools", "create_sword", x, y){
    motion_set(other.gunangle + random_range(-3,3) * other.accuracy, 20)
    image_yscale = -other.right
    projectile_init(other.team, other)
    image_angle = direction
}

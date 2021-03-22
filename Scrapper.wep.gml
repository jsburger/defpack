#define init
global.sprScrapper = sprite_add_weapon("sprites/weapons/sprScrapper.png", 8, 1)
global.sprScrapperBack = sprite_add_weapon("sprites/weapons/sprScrapperBack.png", 8, 1)
global.a = [global.sprScrapper, global.sprScrapperBack]
#define weapon_name
return `SCRAPPER`
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return 7
#define weapon_load
return 24
#define weapon_swap
return sndSwapHammer
#define weapon_auto
return 1
#define weapon_melee
return 1
#define weapon_laser_sight
return 0
#define weapon_sprt(w)
return mod_script_call("mod", "defpunching", "fist_sprite", w, global.a)

#define weapon_text
return "@bCOMBO@s turns projectiles into splinters"

#define weapon_reloaded

#define fist_stats(w)
w.combocost = 6

#define script_ref_call_self(scr)
return mod_script_call_self(scr[0], scr[1], scr[2])

#define weapon_fire(w)
var active = mod_script_call("mod", "defpunching", "fist_active", w);
with mod_script_call("mod", "defpunching", "fist_fire", wep){
    damage = 10
    if active on_projectile = scrapper_proj
}
weapon_post(-12, 10, 6)
var _p = random_range(.9, 1.1);
sound_play_pitchvol(sndHammer, .7 * _p, .5)
sound_play_pitch(sndMeleeFlip, 1.3 * _p)

#define step(p)
mod_script_call("mod", "defpunching", "fist_step", p)

#define scrapper_proj()
if other.typ > 0 {
    with instance_create(other.x, other.y, Splinter){
        motion_set(other.direction + random_range(-20, 20), random_range(16, 24))
        projectile_init(other.team, other.creator)
        image_angle = direction
        sound_play(sndSplinterPistol)
    }
    with other instance_destroy()
}
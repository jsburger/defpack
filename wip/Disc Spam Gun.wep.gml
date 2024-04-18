#define init
global.sprDiscSpamGun = sprite_add_weapon("sprites/weapons/sprDiscSpamGun.png", 0, 2)
global.discang = [random(360), random(360), random(360), random(360)]
global.discang2 = [random(360), random(360), random(360), random(360)]
#define weapon_name
return "DISC SPAM GUN"
#define weapon_type
return 3
#define weapon_cost
return 1
#define weapon_area
if instance_is(other, WeaponChest) || instance_is(other, BigCursedChest){
    if other.curse > 0 return 6
}
return -1
#define weapon_load
return 2
#define weapon_swap
sound_play(sndSwapCursed)
return sndSwapBow
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
if instance_is(self, Player){
    var i = 0
    repeat(2){
        var a = i ? global.discang2 : global.discang
        var n = 400;
        var _x = lengthdir_x(1, a[index]), _y = lengthdir_y(1, a[index]);
        var xx = x, yy = y;
        do {
            xx += _x
            yy += _y
        }
        until --n = 0 or collision_point(xx, yy, Wall, 0, 0)
        draw_line_width_color(x, y, xx, yy, 1, c_red, c_red)
        i++
    }
}
return 0
#define weapon_sprt
return global.sprDiscSpamGun
#define weapon_text
return "SORRIES WON'T COVER THIS"
#define nts_weapon_examine
return{
    "d": "Evil. ",
}
#define weapon_fire
var _p = random_range(.6, 1.3)
sound_play_pitch(sndSwapExplosive, 1.7 * _p)
sound_play_pitch(sndFlyFire,.7 * _p)
sound_play_pitch(sndFrogExplode,.7 * _p)
weapon_post(random_range(-2, 2),0,5)

var i = 0
repeat(2){
    var a = i ? global.discang2 : global.discang
    with instance_create(x,y,Disc){
        motion_set(a[other.index], 5)
        projectile_init(other.team, other)
        image_angle = direction
    }
    a[index] = random(360)
    i++
}

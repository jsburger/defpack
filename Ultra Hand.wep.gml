#define init
global.smacker    = sprite_add_weapon("sprites/sprultrahand.png",-6,5)
global.smackerOff = sprite_add_weapon("sprites/sprultrahandoff.png",-6,5)

#define weapon_name
return "ULTRA HAND"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return 24
#define weapon_load
return 12
#define weapon_swap
return sndSwapHammer
#define weapon_auto
return 0
#define weapon_melee
return 1
#define weapon_laser_sight
return 0
#define weapon_reloaded

#define weapon_rads
return 28

#define weapon_fire

var _p = random_range(.8,1.2)
sound_play_pitchvol(sndLaserUpg,4*_p,.7)
sound_play_pitchvol(sndWaveGun,2*_p,.7)
sound_play_pitch(sndAssassinAttack,2*_p)
with instance_create(x,y,CustomObject){
    team = other.team
    creator = other
    depth = other.depth - 1
    name = "Ultra Hand"

    image_speed = 0
    flip = -sign(other.wepangle)
    image_yscale = -other.wepflip
    sprite_index = global.smacker
    rotspeed = 240/3
    trailcount = 6
    counter = 0
    image_angle = other.gunangle + other.wepangle

    length = sprite_width - sprite_xoffset + 20*skill_get(mut_long_arms)
    trailx = x + lengthdir_x(length, image_angle)// + other.hspeed_raw
    traily = y + lengthdir_y(length, image_angle)// + other.vspeed_raw

    on_step = hand_step
}


with instance_create(x - lengthdir_x(12*skill_get(mut_long_arms), gunangle),y - lengthdir_y(12*skill_get(mut_long_arms), gunangle),CustomSlash){
    team = other.team
    creator = other
    depth = other.depth - 1
    name = "Ultra Hand Slash"

    damage = 30
    image_speed = .4
    //sprite_index = sprSlash
    flip = -sign(other.wepangle)
    mask_index = mskSlash
    //sprite_index = mskSlash
    image_xscale = .5
    image_yscale = .7
    if skill_get(mut_long_arms){
        image_xscale = 1.2
        image_yscale = 1.4
    }
    image_angle = other.gunangle

    on_hit = hand_hit
    on_projectile = hand_proj
    on_grenade = hand_grenade
    on_anim = nothing
}
wepangle *= -1

#define nothing
instance_destroy()

#define hand_grenade
with other{
    team = other.team
    motion_set(other.image_angle, speed)
    image_angle = direction
}

#define hand_proj
with other if typ > 0{
    //if typ = 1{
        team = other.team
        motion_set(other.image_angle, speed)
        image_angle = direction
    //}
    //else instance_destroy()
}
if instance_is(other, EnemyLaser){
    with other{
        team = other.team
        x = other.x
        y = other.y
        xstart = x
        ystart = y
        image_xscale = 0
        image_angle = other.image_angle
        event_perform(ev_alarm,0)
        sprite_index = sprLaser
    }
}



#define hand_step
//var xlen = 0, ylen = 0
counter += rotspeed * current_time_scale * flip
if instance_exists(creator){
    x = creator.x + creator.hspeed_raw
    y = creator.y + creator.vspeed_raw
    //xlen = creator.hspeed_raw
    //ylen = creator.vspeed_raw
    image_angle += rotspeed * current_time_scale * flip
}
if abs(counter) > 240 instance_destroy()
else {
    var ang = image_angle - (rotspeed * current_time_scale * flip)
    for (var i = 0; i < trailcount; i++){
        ang += (rotspeed * current_time_scale * flip)/trailcount
        //with instance_create(x + lengthdir_x(length, ang) + xlen*i/trailcount, y + lengthdir_y(length, ang) + ylen*i/trailcount, BoltTrail){
        with instance_create(xstart + lengthdir_x(length, ang), ystart + lengthdir_y(length, ang), BoltTrail){
            image_xscale = point_distance(x, y, other.trailx, other.traily)
            image_angle = point_direction(x, y, other.trailx, other.traily)
            other.trailx = x
            other.traily = y
            if random(100)<((12+skill_get(mut_long_arms)*3)*current_time_scale) with instance_create(x+random_range(-3,3),y+random_range(-3,3),Wind)
            {
            sprite_index = sprEatRad
            if !irandom(4) sprite_index = sprEatBigRad
            }
            image_blend = c_yellow
            if fork(){
                while instance_exists(self){
                    image_yscale -= .05 * current_time_scale
                    image_blend = merge_color(image_blend, c_green, current_time_scale/10)
                    wait(0)
                }
                exit
            }
        }
    }
}

#define hand_hit
if projectile_canhit_melee(other){
    sound_play_pitch(sndHammerHeadProc,.6)
    sound_play_pitchvol(sndImpWristKill,.7,.9)
    sleep(150)
    view_shake_at(x,y,30)
    projectile_hit(other, damage, 1000, image_angle)
    var _x = x, _y = y, dir = image_angle - 90 * flip, leng = 90, dirfac = 11*flip, t = team;
    if fork(){
        repeat(6){
            repeat(6){
                var l = random(leng) + 16, lx = lengthdir_x(l, dir), ly = lengthdir_y(l, dir)
                with instance_create(_x + lx, _y + ly, UltraShell){
                    motion_set(dir + 90 * sign(dirfac), 10)
                    sound_play_hit(sndShotgun,.1)
                    typ = 0
                    team = t
                    if !place_meeting(x,y,Floor) || place_meeting(x,y,Wall) instance_delete(self)
                }
                dir += (dirfac)/2
            }
            wait(1)
        }
        exit
    }
}

#define weapon_sprt_hud
return global.smacker
#define weapon_sprt
if instance_is(self,Player) if array_length(instances_matching(instances_matching(CustomObject, "name", "Ultra Hand"), "creator", id)) return mskNone
if GameCont.rad >= weapon_rads() return global.smacker else return global.smackerOff
#define weapon_text
return "THE POWER OF INFINITY"

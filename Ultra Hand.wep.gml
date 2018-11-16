#define init
global.smacker = sprite_add_weapon("sprites/sprultrahand.png",-6,5)

#define weapon_name
return "ULTRA HAND"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return 24
#define weapon_load
return 16
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
return 10

#define weapon_fire

sound_play_pitch(sndLaserUpg,4)
sound_play_pitch(sndWaveGun,2)

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
    trailx = x + lengthdir_x(length, image_angle) + other.hspeed_raw
    traily = y + lengthdir_y(length, image_angle) + other.vspeed_raw

    on_step = hand_step
}


with instance_create(x,y,CustomSlash){
    team = other.team
    creator = other
    depth = other.depth - 1
    name = "Ultra Hand Slash"
    
    damage = 30
    image_speed = .4
    //sprite_index = sprSlash
    flip = -sign(other.wepangle)
    mask_index = mskSlash
    image_xscale = .5
    image_yscale = .7
    if skill_get(mut_long_arms){
        image_xscale = 1
        image_yscale = 1.4
    }
    image_angle = other.gunangle
    
    on_hit = hand_hit
    on_projectile = hand_proj
    on_anim = nothing
}
wepangle *= -1

#define nothing
instance_destroy()

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
var xlen = 0, ylen = 0
counter += rotspeed * current_time_scale * flip
if instance_exists(creator){
    x = creator.x + creator.hspeed_raw
    y = creator.y + creator.vspeed_raw
    xlen = creator.hspeed_raw
    ylen = creator.vspeed_raw
    image_angle += rotspeed * current_time_scale * flip
}
if abs(counter) > 240 instance_destroy()
else {
    var ang = image_angle - (rotspeed * current_time_scale * flip)
    for (var i = 0; i < trailcount; i++){
        ang += (rotspeed * current_time_scale * flip)/trailcount
        with instance_create(x + lengthdir_x(length, ang) + xlen*i/trailcount, y + lengthdir_y(length, ang) + ylen*i/trailcount, BoltTrail){
            image_xscale = point_distance(x, y, other.trailx, other.traily)
            image_angle = point_direction(x, y, other.trailx, other.traily)
            other.trailx = x
            other.traily = y
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

    sleep(100)
    projectile_hit(other, damage, 1000, image_angle)
    var _x = x, _y = y, dir = image_angle - 90 * flip, leng = 90, dirfac = 11*flip, t = team;
    if fork(){
        repeat(6){
            repeat(6){
                var l = random(leng) + 16
                with instance_create(_x + lengthdir_x(l, dir), _y+ lengthdir_y(l, dir), UltraShell){
                    motion_set(dir + 90 * sign(dirfac), 10)
                    sound_play_hit(sndShotgun,.1)
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
return global.smacker
#define weapon_text
return "THE POWER OF INFINITY"
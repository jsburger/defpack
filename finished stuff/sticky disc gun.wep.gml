#define init
global.sprStickyDiscGun = sprite_add_weapon("sprStickyDiscGun.png",1,3)
global.sprStickyDisc    = sprite_add("sprStickyDisc.png",2,7,6)
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#define weapon_name
return "STICKY DISC GUN"
#define weapon_type
return 3
#define weapon_cost
return 2
#define weapon_area
return 9
#define weapon_load
return 14
#define weapon_swap
return sndSwapBow
#define weapon_auto
return true
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt
return global.sprStickyDiscGun
#define weapon_text
return "I AM SO SORRY"
#define weapon_fire
weapon_post(3,4,0)
sound_play_gun(sndDiscgun, 0.2, 0.3);
with instance_create(x,y,CustomProjectile)
{
    typ = 1
    dist = 0
    damage = 4
    team = other.team
    image_speed = .4
    name = "Sticky Disc"
    sprite_index = global.sprStickyDisc
    mask_index = mskDisc
    motion_add(other.gunangle+random_range(-8,8)*other.accuracy,4)
    stuckto = -4
    teamswap = 1
    creator = other
    orspeed = speed
    hitid = [sprite_index,name]
    depth = -3
    image_angle = direction
    on_step    = stickydisc_step
    on_hit     = stickydisc_hit
    on_destroy = stickydisc_destroy
    on_wall    = stickydisc_wall
}

#define stickydisc_step
if speed > 0 && current_frame_active {instance_create(x,y,DiscTrail)}
dist += current_time_scale
if dist > 200{instance_destroy();exit}
if instance_exists(creator) && teamswap && !place_meeting(x,y,creator){
    teamswap = 0
    team = -1
}

if instance_exists(stuckto){
    x = stuckto.x - xoff + stuckto.hspeed_raw
    y = stuckto.y - yoff + stuckto.vspeed_raw
    xprevious = x
    yprevious = y
    instance_create(x,y,Dust)
}
else if skill_get(mut_bolt_marrow){
    if instance_exists(enemy){
        var q = instance_nearest(x,y,enemy)
        if distance_to_object(q) < 30
            motion_add(point_direction(x,y,q.x,q.y),.25*current_time_scale)
    }
}



#define stickydisc_hit
if projectile_canhit_melee(other){
    sound_play_hit(sndDiscHit,.2)
    projectile_hit(other, damage, 5, direction)
    if other.my_health > 0{
        if stuckto != other{
            stuckto = other
            xoff = (other.x - x)/2
            yoff = (other.y - y)/2
            sound_play(sndGrenadeStickWall)
            repeat(12){with instance_create(x,y,Smoke){depth = -4}}
        }
    }
    else {
        speed = orspeed
        stuckto = -4
    }
}

#define stickydisc_wall
if !instance_exists(stuckto) sound_play_hit(sndDiscBounce,.2)
move_bounce_solid(true)

#define stickydisc_destroy
with instance_create(x,y,DiscTrail){sprite_index=sprDiscDisappear;image_xscale = 2}
sound_play_hit(sndDiscDie, 0.2)
with instance_create(x,y,Smoke){depth = -3}

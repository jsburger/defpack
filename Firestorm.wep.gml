#define init
global.sprGun = sprite_add_weapon("sprites/sprFlareCannon.png",3,4)
global.sprProj = sprite_add("sprites/projectiles/FireShot.png",3,8,8)
#define weapon_name
return "FIRESTORM"
#define weapon_type
return 4
#define weapon_cost
return 5
#define weapon_area
return 11
#define weapon_load
return 38
#define weapon_swap
return sndSwapFlame
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_reloaded
sound_play_pitchvol(sndToxicBoltGas,.7,.7)
sound_play(sndNadeReload)
wkick = -1
repeat(3){
    with instance_create(x+lengthdir_x(15,gunangle),y+lengthdir_y(15,gunangle),Smoke){
        gravity = -.15
        
    }
}

#define weapon_fire
weapon_post(6,12,4)
sound_play_pitch(sndGrenadeRifle,.9)
sound_play_pitch(sndFlare,1.3)
with instance_create(x,y,CustomProjectile){
    motion_set(other.gunangle,15+random(2))
    image_angle = direction
    projectile_init(other.team,other)
    
    damage = 8
    force = 6
    image_speed = .4
    sprite_index = global.sprProj
    mask_index = mskFlakBullet
    
    ammo = 12
    timerbase = 4
    timer = timerbase
    angle = random(360)
    angle_speed = 5
    canshoot = 0
    
    on_step = flarestep
    on_anim = flareanim
    on_hit = flarehit
    on_destroy = flaredie
    on_draw = flaredraw
    on_wall = flarewall
    
}

#define flarestep
image_xscale = clamp(image_xscale + (random_range(-.05,.05)*current_time_scale),.9,1.1)
image_yscale = image_xscale
image_angle += (6 + speed * 3) * current_time_scale

speed /= 1 + (.1*current_time_scale)
if speed <= 1 {canshoot = 1; speed = 0}

timer -= current_time_scale
while timer <= 0{
    timer += timerbase
    if canshoot{
        angle_speed += 5
        angle += angle_speed
        flareshoot()
        if --ammo <= 0{
            instance_destroy()
            exit
        }
    }
}


#define flareanim
image_index = 1

#define flareshoot
view_shake_at(x,y,5)
sound_play_hit(sndFlare,.2)
var n = 3;
for (var i = 0; i < 360; i+=360/n){
    with instance_create(x,y,Flare){
        motion_set(other.angle + i, 5)
        projectile_init(other.team,other.creator)
        gravity_direction = direction + 120
        gravity = 1
    }
}

#define flarehit
if projectile_canhit_melee(other){
    projectile_hit_push(other,damage,force)
    flaredie()
}

#define flaredie
sound_play(sndFlareExplode)
var n = 12;
var b = 360/(3*n)
for (var i = 0; i < 360; i+=360/n){
    with instance_create(x,y,Flame){
        motion_set(other.angle + i + random_range(-b,b), random_range(7,9))
        projectile_init(other.team,other.creator)
    }
}

#define flaredraw
draw_self()
draw_set_blend_mode(bm_add)
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale*2,image_yscale*2,image_angle,image_blend,image_alpha/5)
draw_set_blend_mode(bm_normal)

#define flarewall
move_bounce_solid(1)
flaredie()
speed *= .8

#define weapon_sprt
return global.sprGun
#define weapon_text
return "They can't miss this one"
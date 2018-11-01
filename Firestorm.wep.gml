#define init
global.sprGun = sprite_add_weapon("sprites/sprFlareCannon.png",3,4)
global.sprProj = sprite_add("sprites/projectiles/BigFlare.png",2,7,7)
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
weapon_post(7,52,24)
sound_play_pitch(sndGrenadeRifle,.9)
sound_play_pitch(sndFlare,1.3)
sound_play_pitch(sndFlameCannon,1.4)
with instance_create(x,y,CustomProjectile){
    motion_set(other.gunangle,15+random(2))
    image_angle = direction
    projectile_init(other.team,other)

    damage = 8
    force = 6
    image_speed = .25
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
    on_wall = flarewall

}

#define flarestep
if image_index >= 1
{
  image_speed = 0
  if current_frame_active
  {
    if speed > friction{repeat(2)with instance_create(x,y,Flame){team = other.team;creator = other.creator;motion_add(other.direction-180+random_range(-22,22),random_range(2,3))}}
  }
}
image_xscale = clamp(image_xscale + (random_range(-.05,.05)*current_time_scale),.9,1.1)
image_yscale = image_xscale
//image_angle += (6 + speed * 3) * current_time_scale

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
    with instance_create(x,y,CustomProjectile){
        team = other.team
        damage = 5
        creator = other.creator
        sprite_index = sprFlare
        image_speed = .2
        motion_set(other.angle + i, 5)
        projectile_init(other.team,other.creator)
        gravdir = direction + 120
        grav = 1
        maxspeed = 30
        on_step    = fakeflare_step
        on_destroy = fakeflare_destroy
    }
}

#define fakeflare_step
if image_index >= 1 image_speed = 0
motion_add(gravdir,grav)
if current_frame_active{with instance_create(x,y,Flame){team = other.team;creator = other.creator}}
if speed > maxspeed speed = maxspeed

#define fakeflare_destroy
sound_play_pitchvol(sndFlareExplode,random_range(.8,1.2),.4)
repeat(16)
{
  with instance_create(x,y,Flame)
  {
    creator = other.creator
    team = other.team
    motion_add(random(360),random_range(4,5))
  }
}

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define flarehit
if projectile_canhit_melee(other){
    projectile_hit_push(other,damage,force)
    flaredie()
}

#define flaredie
sound_play_pitch(sndFlameCannonEnd,1.2)
var n = 12;
var b = 360/(3*n)
for (var i = 0; i < 360; i+=360/n){
    with instance_create(x,y,Flame){
        motion_set(other.angle + i + random_range(-b,b), random_range(7,9))
        projectile_init(other.team,other.creator)
    }
}

#define flarewall
move_bounce_solid(1)
image_angle = direction
sound_play(sndFlareExplode)
flaredie()
speed *= .8

#define weapon_sprt
return global.sprGun
#define weapon_text
return "They can't miss this one"

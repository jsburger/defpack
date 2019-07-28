#define init
global.sprMegaBouncerRevolver   = sprite_add_weapon("../../sprites/weapons/iris/bouncer/sprMegaBouncerRevolver.png", -1, 3);
global.sprMegaBouncerBullet     = sprite_add("../../sprites/projectiles/iris/bouncer/sprMegaBouncerBullet.png",2,18,18)
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#define weapon_name
return "MEGA BOUNCER REVOLVER";

#define weapon_sprt
return global.sprMegaBouncerRevolver;

#define weapon_type
return 1;

#define weapon_auto
return 0;

#define weapon_load
return 18;

#define weapon_cost
return 5;

#define weapon_swap
return sndSwapPistol

#define weapon_melee
return 0;

#define weapon_area
return -1;

#define weapon_text
return "COMEBACK"

#define weapon_fire
weapon_post(9,-40,30)
motion_add(gunangle-180,3)
var _p = random_range(.8,1.2)
mod_script_call("mod","defpack tools", "shell_yeah_big", 100, 12, 4+random(1), c_yellow)
sound_play_pitch(sndSawedOffShotgun,.7*_p)
sound_play_pitch(sndLilHunterBouncer,.6*_p)
sound_play_pitch(sndBouncerSmg,.8*_p)
sound_play_pitch(sndBouncerShotgun,.8*_p)
sound_play_pitch(sndHeavySlugger,.8*_p)
sound_play_gun(sndClickBack,1,0)
sound_stop(sndClickBack)
with instance_create(x,y,CustomProjectile)
{
    name = "mega bouncer bullet"
    typ = 1
    sprite_index = global.sprMegaBouncerBullet
    mask_index = mskHeavyBullet
    recycle_amount = 5
    damage = 4
    team = other.team
    force = 6
    defbloom = {
        xscale : 2,
        yscale : 2,
        alpha : .1
    }
    frames = 16
    bounce = 3
    image_speed = 1
    turn = choose(-1,1)
    turnspeed = 14
    creator = other
    move_contact_solid(other.gunangle,12)
    motion_add(other.gunangle+random_range(-8,8)*other.accuracy,10)
    image_angle = direction
    on_destroy = mega_destroy
    on_wall    = mega_wall
    on_anim    = mega_anim
    on_step    = mega_step
    on_hit     = mega_hit
    repeat(4)with instance_create(x+lengthdir_x(5,direction),y+lengthdir_y(5,direction),Smoke){
        gravity = -.1
        image_xscale /=2
        image_yscale/=2
    }
}
#define mega_hit
if current_frame_active{
    frames--
    if skill_get(mut_recycle_gland) and recycle_amount > 0 and irandom(9) < 5{
        instance_create(x, y, RecycleGland)
        sound_play(sndRecGlandProc)
        recycle_amount -= 1
        with creator ammo[1] = min(ammo[1] + 1, typ_amax[1])
    }

    repeat(3) instance_create(x+random_range(-8,8),y+random_range(-8,8),Smoke)
    projectile_hit(other,damage,force,direction)
    sleep(5)
    view_shake_at(x,y,12)
    if frames <= 0 instance_destroy()
}

#define mega_wall
view_shake_at(x,y,12)
if bounce > 0
{
  image_index = 0
  image_speed = 1
  sound_play_pitch(sndBouncerBounce,random_range(.5,.7))
  sound_play_pitchvol(sndExplosionS,.6,.4)
  move_bounce_solid(false)
  turnspeed /= 1.2
  repeat(3)
  {
    instance_create(x,y,Smoke)
    with instance_create(x,y,BouncerBullet)
    {
      team = other.team
      motion_add(other.direction+random_range(-38,38),8)
    }
  }
  bounce--
}
else {instance_destroy();exit}
with other{instance_create(x,y,FloorExplo);instance_destroy()}

#define mega_destroy
repeat(3)
{
  instance_create(x,y,Smoke)
  with instance_create(x,y,BouncerBullet)
  {
    team = other.team
    motion_add(other.direction+random_range(-38,38),8)
  }
}
repeat(6) instance_create(x,y,Smoke) motion_add(random(360),random_range(1,3))
with instance_create(x,y,BulletHit){sprite_index = sprSlugHit;image_index = 1}

#define mega_step
image_angle += turnspeed * turn * current_time_scale

#define mega_anim
image_index = 1
image_speed = 0
sleep(15)

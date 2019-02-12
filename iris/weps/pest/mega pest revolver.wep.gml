#define init
global.sprMegaPestRevolver   = sprite_add_weapon("sprites/sprMegaPestRevolver.png", -1, 3);
global.sprMegaPestBullet     = sprite_add("sprites/projectiles/sprMegaPestBullet.png",2,18,18)
global.sprMegaPestBulletHit  = sprite_add("sprites/projectiles/sprMegaPestBulletHit.png",3,16,16)
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#define weapon_name
return "MEGA PEST REVOLVER";

#define weapon_sprt
return global.sprMegaPestRevolver;

#define weapon_type
return 1;

#define weapon_auto
return 0;

#define weapon_load
return 8;

#define weapon_cost
return 5;

#define weapon_swap
return sndSwapPistol

#define weapon_melee
return 0;

#define weapon_area
return 14;

#define weapon_text
return "TOO BIG FOR THE HOLSTER"

#define weapon_fire
weapon_post(9,-40,30)
motion_add(gunangle-180,3)
var _p = random_range(.8,1.2)
mod_script_call("mod","defpack tools", "shell_yeah_big", 100, 12, 4+random(1), c_green)
sound_play_pitch(sndSawedOffShotgun,.8*_p)
sound_play_pitch(sndHeavySlugger,.8*_p)
sound_play_pitch(sndToxicBoltGas,.5*_p)
sound_play_pitch(sndToxicBarrelGas,.6*_p)
sound_play_pitch(sndDoubleMinigun,.8*_p)
sound_play_pitchvol(sndSwapFlame,.8*_p,.7)
sound_play_gun(sndClickBack,1,0)
sound_stop(sndClickBack)
with instance_create(x,y,CustomProjectile)
{
    name = "mega pest bullet"
    typ = 1
    sprite_index = global.sprMegaPestBullet
    mask_index = mskHeavyBullet
    recycle_amount = 5
    damage = 5
    team = other.team
    force = 18
    frames = 10
    image_speed = 1
    creator = other
    move_contact_solid(other.gunangle,12)
    motion_add(other.gunangle+random_range(-1,1)*other.accuracy,22)
    image_angle = direction
    on_destroy = mega_destroy
    on_wall    = mega_wall
    on_anim    = mega_anim
    on_hit     = mega_hit
    repeat(4)with instance_create(x+lengthdir_x(5,direction),y+lengthdir_y(5,direction),Dust){
        gravity = -.5
        image_xscale /=2
        image_yscale/=2
    }
}
#define mega_hit
if current_frame_active{
    frames--
    repeat(3) instance_create(x+random_range(-8,8),y+random_range(-8,8),ToxicGas)
    projectile_hit(other,damage,force,direction)
    sleep(5)
    view_shake_at(x,y,12)
    if frames <= 0 instance_destroy()
}

#define mega_wall
with other{instance_create(x,y,FloorExplo);instance_destroy()}
instance_destroy()

#define mega_destroy
repeat(12) instance_create(x,y,ToxicGas) motion_add(random(360),random_range(1,3))
with instance_create(x,y,BulletHit){sprite_index = global.sprMegaPestBulletHit}

#define mega_anim
image_index = 1
image_speed = 0
sleep(15)

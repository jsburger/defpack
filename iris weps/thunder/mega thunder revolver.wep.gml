#define init
global.sprMegaThunderRevolver   = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprMegaThunderRevolver.png", -1, 3);
global.sprMegaThunderBullet     = sprite_add("../../sprites/projectiles/iris/thunder/sprMegaThunderBullet.png",2,18,18)
global.sprMegaThunderBulletUpg  = sprite_add("../../sprites/projectiles/iris/thunder/sprMegaThunderBulletUpg.png",2,18,18)
global.sprMegaThunderBulletHit  = sprite_add("../../sprites/projectiles/iris/thunder/sprMegaThunderBulletHit.png",2,18,18)
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#define weapon_name
return "MEGA THUNDER REVOLVER";

#define weapon_sprt
return global.sprMegaThunderRevolver;

#define weapon_type
return 1;

#define weapon_auto
return 0;

#define weapon_load
return 28;

#define weapon_cost
return 5;

#define weapon_swap
if instance_is(self, Player){
	view_shake_at(x, y, 20);
	sleep(10);
}
sound_play_pitchvol(sndBasicUltra, 1.2, .6);
sound_play_pitch(sndSwapPistol, .9);
return -4;


#define weapon_melee
return 0;

#define weapon_area
return -1;

#define weapon_text
return "A GLORIOUS THUNDER"

#define weapon_fire
repeat(2)
{
  weapon_post(9,-40,30)
  motion_add(gunangle-180,3)
  var _p = random_range(.8,1.2)
  var _s = skill_get(mut_laser_brain)
  mod_script_call("mod","defpack tools", "shell_yeah_big", 100, 12, 4+random(1), c_navy)
  sound_play_pitch(sndSawedOffShotgun,.7*_p)
  sound_play_pitch(sndLightningCannon,.6*_p)
  sound_play_pitch(sndLightningCannonEnd,.5*_p)
  sound_play_pitch(sndGammaGutsKill,.5*_p*_s)
  sound_play_pitch(sndLightningRifleUpg,.7*_s*_p)
  sound_play_pitch(sndLightningReload,.6*_p*(1-_s))
  sound_play_gun(sndClickBack,1,0)
  sound_stop(sndClickBack)
  with instance_create(x,y,CustomProjectile)
  {
    name = "mega thunder bullet"
    typ = 1
    sprite_index = global.sprMegaThunderBullet
    if _s sprite_index = global.sprMegaThunderBulletUpg
    mask_index = mskHeavyBullet
    recycle_amount = 2
    damage = 2
    team = other.team
    force = 18
    frames = 8
    defbloom = {
        xscale : 2,
        yscale : 2,
        alpha : .1
    }
    image_speed = 1
    creator = other
    move_contact_solid(other.gunangle,12)
    motion_add(other.gunangle+random_range(-8,8)*other.accuracy,14)
    with instance_create(x,y,LightningSpawn){image_angle = other.direction}
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
  wait(9)
  if !instance_exists(self) exit
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
with other{instance_create(x,y,FloorExplo);instance_destroy()}
instance_destroy()

#define mega_destroy
var i = random(360)
repeat(6)
{
  with instance_create(x,y,Lightning)
  {
    image_angle = i
    team = other.team
  	creator = other.creator
    ammo = 6
  	alarm0 = 1
  	visible = 0
    with instance_create(x,y,LightningSpawn){image_angle = other.image_angle}
  }
  i += 60
}
repeat(6) instance_create(x,y,Smoke) motion_add(random(360),random_range(1,3))
with instance_create(x,y,BulletHit){sprite_index = global.sprMegaThunderBulletHit}

#define mega_step
if irandom(1)
{
  with instance_create(x,y,Lightning)
  {
    image_angle = random(360)
    team = other.team
    creator = other.creator
    ammo = 2
    alarm0 = 1
    visible = 0
    with instance_create(x,y,LightningSpawn){image_angle = other.image_angle}
  }
}

#define mega_anim
image_index = 1
image_speed = 0
sleep(15)

#define step
  with instances_matching(Player, "wep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}
  with instances_matching(instances_matching(Player, "race", "steroids"), "bwep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}

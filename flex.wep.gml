#define init
global.sprInfinigun2   = sprite_add_weapon("sprites/weapons/sprFlex.png",8,4)
global.sprBluellet2    = sprite_add("sprites/projectiles/sprFlexBullet.png",2,12,12)
global.sprBluellet2Hit = sprite_add("sprites/projectiles/sprFlexBulletHit.png",6,12,12)
global.sprHUD1 = sprite_add("sprites/interface/sprFlexHUD1.png", 1, 8, 4);
global.sprHUD2 = sprite_add("sprites/interface/sprFlexHUD2.png", 1, 8, 4);

#define weapon_name
return "FLEX"

#define weapon_sprt_hud
if "infammo" in self{
  if infammo > 0{
    return global.sprHUD2;
  }else return global.sprHUD1;
}
return global.sprHUD1;

#define weapon_type
return 1

#define weapon_cost
return 2

#define weapon_area
return 13

#define weapon_load
return 2

#define weapon_swap
return sndSwapMachinegun

#define weapon_auto
return true

#define weapon_melee
return false

#define weapon_laser_sight
return false

#define step
//if infammo > 0 sound_play_gun(sndFootOrgSand4,9999999999999999999999,.0000001)

#define weapon_fire
var _a = (other.infammo != 0)
var _p = random_range(.9,1.2)
sound_play_pitchvol(sndFlakExplode,.3*_p,.5*_a)
sound_play_pitchvol(sndSuperFlakExplode,.2*_p,.5*_a)
sound_play_pitchvol(sndSawedOffShotgun,.6*_p,.5*_a)
//sound_play_pitchvol(sndMinigun,.8*_p,.8)
sound_play_pitchvol(sndPopgun,1.2*_p,1)
sound_play_pitchvol(sndHeavyRevoler,.8*_p,.5+.2*_a)
sound_play_pitchvol(sndTripleMachinegun,.8*_p,.5+.2*_a)
sound_play_gun(sndClickBack,1,.4*(1-_a))
sound_stop(sndClickBack)
weapon_post(4+_a,3,5+_a*6)
with instance_create(x,y,CustomProjectile){
    //if irandom(19) = 0 charged = 1 else charged = 0
    mask_index   = mskBullet1
    sprite_index = _a ? global.sprBluellet2 : sprBullet2
    motion_add(other.gunangle+random_range(-8,8)*other.accuracy,18)
    projectile_init(other.team,other)
    name = "Flex Bullet" //not sponsored i swear
    image_angle = direction
    image_speed = 1
    bounce = 1
    damage = 4
    falloff = 1
    fallofftime = current_frame + 2
    defbloom = {
        xscale : 2,
        yscale : 2,
        alpha : .2
    }
    force  = 7
    wallbounce = 5 * skill_get(mut_shotgun_shoulders)
    friction = 1 - _a * .3
     _f = fallofftime >= current_frame
    on_hit     = b_hit
    on_step    = b_step
    on_anim    = b_anim
    on_wall    = b_wall
    on_destroy = b_destroy
}

#define b_anim
image_speed = 0
image_index = 1

#define b_hit
var dmg = fallofftime >= current_frame ? damage : damage - falloff
projectile_hit(other,dmg,force,direction)
if instance_exists(other) && other.my_health <= 0{
    var o = other
    sleep(6)
    if instance_exists(creator){
        var a = max(16*other.size,6)
        sleep(a*2)
        with creator if infammo >= 0 infammo = min(infammo + a, 120)  //limit infammo gain to 120 frames
    }
}
instance_destroy()

#define b_wall
move_bounce_solid(false)
defbloom.alpha = .2
direction += random_range(-4,4)
image_angle = direction
speed *= .9
speed = min(speed + wallbounce, 18)
wallbounce *= .9
fallofftime = current_frame + 2 + skill_get(15) * 2
sound_play_hit(sndShotgunHitWall,.2)
instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust)

#define b_destroy
with instance_create(x,y,BulletHit){image_angle = other.direction;if other.sprite_index = global.sprBluellet2 sprite_index = global.sprBluellet2Hit else sprite_index = sprBullet2Disappear}

#define b_step
if fallofftime < current_frame defbloom.alpha = .1
if speed <= friction * 2 instance_destroy()

#define weapon_sprt
return global.sprInfinigun2

#define weapon_text
return choose("KILLING @wENEMIES#@sGIVES YOU @wINFINITE AMMO")

#define nts_weapon_examine
return{
    "d": "The absolute pinnacle of pop gun technology. #This gun senses fallen enemies and provides infinite ammo everytime it does so. ",
}

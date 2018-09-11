#define init
global.sprite = sprite_add_weapon("sprites/sprBigShotgun.png",4,1)
global.sprMegaFlash = sprHeavySlugHit//sprite_add("sprites/projectiles/sprMegaFlashShort.png",4,16,24)
global.mskMegaFlash = sprite_add("sprites/projectiles/mskMegaFlashShort.png",4,16,24)
if(fork()){
    wait 20;
    sprite_collision_mask(global.mskMegaFlash, false, 0, 0, 0, 0, 0, 0, 0);
    exit;
}
global.shells = [sprite_add("sprites/sprFatShell.png",1,3,5),sprite_add("sprites/sprFatShellUpg.png",1,3,5)]

#define weapon_name
return "BIG SHOTGUN"
#define weapon_type
return 2
#define weapon_cost
return 6
#define weapon_area
return 11
#define weapon_load
return 43
#define weapon_swap
sound_play_pitch(sndHammer,1.5)
return sndSwapShotgun
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_reloaded
wkick = -2
sound_play_pitch(sndShotReload,.76)
if fork(){
    repeat(12) wait(0)
    if instance_exists(self) wkick = 2
    sound_play_pitch(sndShotReload,.82)
    exit
}
repeat(interfacepop){
    with instance_create(x,y,Shell){
        sprite_index = global.shells[skill_get(mut_shotgun_shoulders)]
        motion_add(other.gunangle + (120+random(30))*other.right,6)
        repeat(6)with instance_create(x+lengthdir_x(5,direction),y+lengthdir_y(5,direction),Smoke){
            gravity = -.1
            image_xscale /=2
            image_yscale/=2
        }
        if vspeed < -1{
            gravity = .5
            friction = .1
            image_angle = direction -90
            bounces = 2 + irandom(2)
            if fork(){
                while instance_exists(self){
                    image_angle += 10*current_time_scale*-(hspeed)
                    if y > ystart{
                      vspeed*= -1
                      hspeed*= random_range(.25,1.5) * choose(-1,1)
                      instance_create(x,y,Dust)
                      sound_play_pitchvol(sndWallBreak,20,.35)
                      if --bounces = 0 instance_destroy()
                   }
                   wait(0)
               }
               exit
            }
        }
    }
}

#define weapon_fire
sound_play_pitch(sndDoubleShotgun,2)
sound_play(sndSuperSlugger)
sound_play_pitch(sndExplosionL,1.3)
weapon_post(15,-120,60)
var AP = 0
with instance_create(x+lengthdir_x(30,gunangle),y+lengthdir_y(30,gunangle),SmallExplosion){
    sprite_index = global.sprMegaFlash
    mask_index = global.mskMegaFlash
    team = other.team
    damage = 15
    depth = -2
    image_angle = other.gunangle
    if place_meeting(x,y,PopoShield) || place_meeting(x,y,CrystalShield){
        AP = 1
        sound_play_gun(sndHammerHeadEnd,.2,.2)
    }
    hitid = [sprite_index,"MUZZLE FLARE"]
}
sleep(100)
repeat(45){
    with instance_create(x,y,Bullet2){
        motion_set(other.gunangle+random_range(-20,20)*other.accuracy,random_range(8,16)*2)
        friction += speed/50
        projectile_init(other.team,other)
        image_angle = direction
        if AP = 1 typ = 0
    }
}

roll = 1
direction = gunangle+180

if fork(){
    repeat(20+random(10)){
        if instance_exists(self) with instance_create(x+lengthdir_x(25,gunangle),y+lengthdir_y(25,gunangle),Smoke){
            gravity = -.1
            image_xscale /=2
            image_yscale/=2
        }
        wait(1)
    }
    exit
}

#define weapon_sprt
return global.sprite
#define weapon_text
return "LARGENESS OVERWHELMING"

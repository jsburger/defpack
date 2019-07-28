#define init
global.sprite = sprite_add_weapon("sprites/sprHugeShotgun.png",6,3)
global.sprMegaFlash = sprHeavySlugHit//sprite_add("sprites/projectiles/sprMegaFlashShort.png",4,16,24)
global.mskMegaFlash = sprite_add("sprites/projectiles/mskMegaFlashShort.png",4,16,24)
if(fork()){
    wait 20;
    sprite_collision_mask(global.mskMegaFlash, false, 0, 0, 0, 0, 0, 0, 0);
    exit;
}
global.shells = [sprite_add("sprites/sprFatShell.png",1,3,5),sprite_add("sprites/sprFatShellUpg.png",1,3,5)]
global.slowed = 0

#define weapon_name
return "HUGE SHOTGUN"
#define weapon_type
return 2
#define weapon_cost
return 14
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
            depth = -2
            friction = .1
            image_angle = direction -90
            bounces = 2 + irandom(2)
            if fork(){
                while instance_exists(self) && bounces > 0{
                    image_angle += 10*current_time_scale*-(hspeed)
                    if y > ystart{
                        vspeed*= -1
                        hspeed*= random_range(.25,1.5) * choose(-1,1)
                        instance_create(x,y,Dust)
                        sound_play_pitchvol(sndWallBreak,20,.35)
                        if --bounces = 0{
                          gravity = 0
                          speed = 0
                        }
                   }
                   wait(0)
               }
               exit
            }
        }
    }
}

#define slugstep
timer--
if timer <= 0 instance_destroy()

#define slugdraw
draw_sprite_ext(sprite_index, image_index, x, y, 1.5*image_xscale, 1.5*image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 3*image_xscale, 3*image_yscale, image_angle, image_blend, 0.25);
draw_set_blend_mode(bm_normal);

#define weapon_fire
//sound_play_pitchvol(sndSlugger,.6,.8)
weapon_post(15,-320,60)
var AP = 0
with instance_create(x+lengthdir_x(20,gunangle),y+lengthdir_y(20,gunangle),CustomObject)
{
  sprite_index = sprHeavySlug
  image_speed = 0
  timer = 2
  on_step = slugstep
  on_draw = slugdraw
}
with instance_create(x+lengthdir_x(20,gunangle),y+lengthdir_y(20,gunangle),SmallExplosion){
    sprite_index = global.sprMegaFlash
    mask_index = global.mskMegaFlash
    team = other.team
    sparked = 1
    damage = 20
    image_xscale = 1.5
    image_yscale = image_xscale
    depth = -2
    image_angle = other.gunangle
    if place_meeting(x,y,PopoShield) || place_meeting(x,y,CrystalShield){
        AP = 1
        sound_play_gun(sndHammerHeadEnd,.2,.2)
        if fork(){
            if global.slowed = 0{
                global.slowed = 1
                var ts = current_time_scale
                current_time_scale /= 10
                wait(1)
                current_time_scale = ts
                global.slowed = 0
            }
            exit
        }
    }
    hitid = [sprite_index,"MUZZLE BLAST"]
}
sound_play_pitch(sndEmpty,1.25)
sleep(260)
var _p = random_range(.8,1.2)
sound_play_pitch(sndDoubleShotgun,2*_p)
sound_play(sndSuperSlugger)
sound_play(sndHammerHeadProc)
sound_play_pitch(sndExplosionL,1.3*_p)
//sound_play_pitchvol(sndExplosionXL,.8*_p,.7)
var angle = gunangle
if fork(){
    wait(1)
    repeat(3){
        repeat(50){
            with instance_create(x,y,Bullet2){
                motion_set(angle+random_range(-35,35)*other.accuracy,random_range(10,18)*2)
                friction += speed/60
                projectile_init(other.team,other)
                image_angle = direction
                if AP = 1 typ = 0
            }
        }
        //wait(1)
    }
    exit
}
if fork(){
    var ang = gunangle + 180, dist = 36;
    repeat(4){
        if instance_exists(self){
            move_contact_solid(ang,dist)
            dist -= 4
            repeat(25){
                with instance_create(x,y,Dust){
                    motion_set(ang + 180 + sqr(random_range(6,9)) * choose(-1,1), random_range(4, 12))
                    depth = -8
                }
            }
            if place_meeting(x+lengthdir_x(4,ang),y+lengthdir_y(4,ang),Wall){
                sound_play(sndHammerHeadProc)
                with instance_nearest(x,y,Wall){
                    instance_create(x,y,FloorExplo)
                    instance_destroy()
                }
                sleep(50)
            }
        }
        wait(1)
    }
    exit
}
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
return "HOLY SHIT"

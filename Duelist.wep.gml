#define init
global.sprApergigTanat = sprite_add_weapon("sprites/weapons/sprApergigTanat.png", 0, 3);
global.sprBullet = sprite_add("sprites/projectiles/sprDuelistBullet.png", 2, 5, 4);

#define weapon_name
return "DUELIST";

#define weapon_sprt
return global.sprApergigTanat;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 30;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapPistol

#define weapon_area
return 8;

#define weapon_reloaded
motion_add(gunangle,2)
sound_play_pitch(sndShotReload,1.05)
repeat(12){
    with instance_create(x,y,Smoke){
        motion_set(other.gunangle + 160*other.right+random_range(-6,6),random_range(1,4))
        image_xscale = .6
        image_yscale = .6
    }
}
repeat(interfacepop) {
    with instance_create(x,y,CustomProjectile){
        team = other.team
        creator = other
        motion_set(other.gunangle + 160*other.right,20)
        on_step = shellstep
        on_wall = nothing
        damage = 10 + 10*skill_get(mut_shotgun_shoulders)
        sprite_index = skill_get(mut_shotgun_shoulders) ? sprShotShellBig : sprShotShell;
    }
}
#define nothing
move_bounce_solid(1)
if skill_get(mut_shotgun_shoulders) speed += 2

#define shellstep
image_angle += 4*speed_raw
speed /= 1 + (.2*current_time_scale)
if speed <= .01 instance_destroy()

#define nts_weapon_examine
return{
    "d": "These pistols were used in battles of honor between mutants. ",
}

#define weapon_text
return choose("CHOOSE YOUR TARGET WISELY","LIKE OLD TIMES");

#define weapon_fire

var r = random_range(.8,1.2);
sound_play_pitch(sndGoldShotgun,r)
sound_play_pitch(sndGoldPistol,r)
sound_play_pitch(sndGoldTankShoot,r)
sound_play_pitch(sndSlugger,2*r)
sound_play_pitch(sndFlakCannon,.8*r)
motion_set(gunangle-180,4)
weapon_post(9,-30,24)
with instance_create(x,y,CustomProjectile){
    name = "suddenDeathBullet"
    defbloom = {
        xscale : 2,
        yscale : 2,
        alpha : .1
    }
    sprite_index = global.sprBullet
    mask_index   = mskBullet2
    image_speed = 1
    friction = .6
	force = 50
	damage = 60
	motion_add(other.gunangle,22)
	team = other.team
	creator = other
	repeat(6){instance_create(x+lengthdir_x(random_range(1,6),direction),y+lengthdir_y(random_range(1,6),direction),Smoke)}
    image_angle = direction
    on_wall    = shell_wall
    on_step    = shell_step
    on_hit     = shell_hit
    on_anim    = shell_anim
    on_destroy = shell_destroy
}

#define shell_anim
image_index = 1
image_speed = 0

#define shell_wall
speed *= (.8+skill_get(15)*.2)
sound_play_pitchvol(sndHitWall,random_range(.8,1.2),.3)
instance_create(x,y,Dust)
move_bounce_solid(false)
direction += random_range(-5,5)
image_angle = direction

#define shell_step
if speed < friction
{
  with instance_create(x,y,BulletHit)
  {
    sprite_index = sprEBullet3Disappear
    image_angle = other.image_angle
    image_xscale = other.image_xscale
    image_yscale = other.image_yscale
  }
  instance_destroy()
}

#define shell_hit
mod_script_call_self("mod", "defpack tools", "crit")
sleep(200)
projectile_hit(other, damage, force, direction)

with instance_create(x,y,BulletHit) {
	sprite_index = sprEBullet3Disappear
	image_angle = random(360)
	image_xscale = other.image_xscale
	image_yscale = other.image_yscale
}
instance_destroy()

#define shell_destroy

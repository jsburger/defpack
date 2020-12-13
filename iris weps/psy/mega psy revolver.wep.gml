#define init
global.sprMegaPsyRevolver   = sprite_add_weapon("../../sprites/weapons/iris/psy/sprMegaPsyRevolver.png", -1, 3);
global.sprMegaPsyBullet     = sprite_add("../../sprites/projectiles/iris/psy/sprMegaPsyBullet.png",2,18,18)
global.sprMegaPsyBulletHit  = sprite_add("../../sprites/projectiles/iris/psy/sprMegaPsyBulletHit.png",3,18,18)
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#define weapon_name
return "MEGA PSY REVOLVER";

#define weapon_sprt
return global.sprMegaPsyRevolver;

#define weapon_type
return 1;

#define weapon_auto
return 0;

#define weapon_load
return 18;

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
return "@pMY @sDOMAIN"

#define weapon_fire
weapon_post(9,-40,30)
motion_add(gunangle-180,3)
var _p = random_range(.8,1.2)
mod_script_call("mod","defpack tools", "shell_yeah_big", 100, 12, 4+random(1), c_purple)
sound_play_pitch(sndSawedOffShotgun,.5*_p)
sound_play_pitch(sndHeavySlugger,.7*_p)
sound_play_pitch(sndCursedChest,1.4*_p)
sound_play_pitch(sndCursedPickupDisappear,.6*_p)
sound_play_pitchvol(sndBigCursedChest,.4*_p,.5)
sound_play_gun(sndClickBack,1,0)
sound_stop(sndClickBack)
with instance_create(x,y,CustomProjectile){
    name = "mega psy bullet"
    typ = 2
    sprite_index = global.sprMegaPsyBullet
    mask_index = mskHeavyBullet
    recycle_amount = 5
    damage = 2
    team = other.team
    force = 4
    timer = 6
    range = 140
    turnspeed = .25
    frames = 30
    defbloom = {
        xscale : 2,
        yscale : 2,
        alpha : .1
    }
    image_speed = 1
    creator = other
    move_contact_solid(other.gunangle,12)
    motion_add(other.gunangle+random_range(-8,8)*other.accuracy,7)
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
with other{instance_create(x,y,FloorExplo);instance_destroy()}
instance_destroy()

#define mega_destroy
repeat(6) instance_create(x,y,Smoke) motion_add(random(360),random_range(1,3))
with instance_create(x,y,BulletHit){sprite_index = global.sprMegaPsyBulletHit}

#define mega_step
mod_script_call_self("mod", "defpack tools", "psy_step")
if timer <= 0{
    var q = mod_script_call_nc("mod","defpack tools","instance_nearest_matching_ne",x,y,hitme,"team",team)
    if instance_exists(q) and distance_to_object(q) < range * 2{
        with q motion_add(point_direction(x, y, other.x, other.y), current_time_scale)
    }
}

#define mega_anim
image_index = 1
image_speed = 0
sleep(15)

#define step
  with instances_matching(Player, "wep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}
  with instances_matching(instances_matching(Player, "race", "steroids"), "bwep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}

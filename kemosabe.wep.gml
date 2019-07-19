#define init
global.sprKemosabe    = sprite_add_weapon("sprites/sprKemosabe.png", 3, 2);
global.sprLuckyBullet = sprite_add("sprites/projectiles/Lucky Bullet.png",2,11,11)
global.sprMagazine    = sprite_add("sprites/sprKemosabeMag.png", 1, 2, 3)
#define weapon_name
return "KEMOSABE";

#define weapon_sprt
return global.sprKemosabe;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 3;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 6;

#define weapon_text
return choose("SO CLEAN FOR#SUCH DIRTY WORK", "LIL FRIEND");

#define weapon_reloaded(p)
/*if ammo[1] mod 16 == 0{
    with instance_create(x + lengthdir_x(3, gunangle), y + lengthdir_y(3, gunangle), Shell){
        motion_set(other.gunangle - other.right * 90 * sign(p - .1) + random_range(-10, 10), random_range(4,6))
        friction *= 2
        sprite_index = global.sprMagazine
    }
    if p wkick++
    else bwkick++
    sound_play_pitch(sndSwapShotgun, 1.6)
} sorry burg but this is too distracting*/

#define weapon_fire
weapon_post(5,-5,5)
sleep(10)
var _pitch = random_range(.8,1.2);
sound_play_pitch(sndMachinegun,.7*_pitch)
sound_play_pitch(sndSnowTankShoot,1.5*_pitch)
sound_play_pitch(sndPopgun,.8*_pitch)
sound_play_pitch(sndMinigun,.45*_pitch)
with instance_create(x,y,Shell){
	motion_add(other.gunangle+other.right*100+random(50)-25,2+random(3))
}
with instance_create(x,y,CustomProjectile){
    defbloom = {
        xscale : 2,
        yscale : 2,
        alpha : .1
    }
	typ = 1
	name = "crit bullet"
    damage = 3
    force = 7
    team = other.team
    creator = other
    sprite_index = global.sprLuckyBullet
    mask_index   = mskBullet1
    can_crit = 1
    recycle_amount = 1
	motion_add(other.gunangle+random_range(-14,14)*other.accuracy,20)
    image_angle = direction
    on_anim    = kemosabe_anim
    on_hit     = kemosabe_hit
    on_destroy = kemosabe_destroy
}

#define kemosabe_anim
image_speed = 0
image_index = 1

#define kemosabe_hit
if irandom(16-(skill_get(mut_lucky_shot)*5)) = 0 && can_crit = 1{
    can_crit = 0
    mod_script_call("mod","defpack tools","crit")
}
with creator{
    var num = (skill_get(mut_recycle_gland) * (irandom(9) < 5)) + 10*skill_get("recycleglandx10")
    if num{
        ammo[1] = min(ammo[1] + other.recycle_amount * num, typ_amax[1])
        instance_create(other.x, other.y, RecycleGland)
        sound_play(sndRecGlandProc)
    }
}
projectile_hit(other,damage,force,direction)
instance_destroy()

#define kemosabe_destroy
with instance_create(x,y,BulletHit){sprite_index = sprEnemyBulletHit}

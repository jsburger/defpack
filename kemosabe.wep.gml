#define init
global.sprKemosabe    = sprite_add_weapon("sprites/sprKemosabe.png", 3, 2);
global.sprLuckyBullet = sprite_add("sprites/projectiles/Lucky Bullet.png",2,11,11)
#define weapon_name
return "KEMOSABE";

#define weapon_sprt
return global.sprKemosabe;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 2;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 12;

#define weapon_text
return choose("IS IT STATTRACK","A NICER DICER","CRITICAL");

#define weapon_fire
weapon_post(5,-5,5)
sleep(10)
var _pitch = random_range(.8,1.2);
sound_play_pitch(sndMachinegun,.7*_pitch)
sound_play_pitch(sndSnowTankShoot,1.3*_pitch)
sound_play_pitch(sndPopgun,1.4*_pitch)
with instance_create(x,y,Shell){
	motion_add(other.gunangle+other.right*100+random(50)-25,2+random(3))
}
with instance_create(x,y,CustomProjectile)
{
    damage = 3
    force = 5
    team = other.team
    creator = other
    image_speed = 1
    sprite_index = global.sprLuckyBullet
    mask_index   = mskBullet1
    can_crit = 1
    recycle_amount = 2
    move_contact_solid(other.gunangle,4)
	  motion_add(other.gunangle+random_range(-14,14)*other.accuracy,20)
    image_angle = direction
    on_step    = kemosabe_step
    on_draw    = kemosabe_draw
    on_hit     = kemosabe_hit
    on_destroy = kemosabe_destroy
}

#define kemosabe_step
if image_index = 1 image_speed = 0

#define kemosabe_hit
if projectile_canhit(other) = true
{
  if irandom(29-(skill_get(6)*5)) = 0 && can_crit = 1
  {
    can_crit = 0
    mod_script_call("mod","defpack tools","crit")
  }
  projectile_hit(other,damage,force,direction)
  instance_destroy()
}

#define kemosabe_destroy
with instance_create(x,y,BulletHit){sprite_index = sprEnemyBulletHit}

#define kemosabe_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.75*image_xscale, 1.75*image_yscale, image_angle, image_blend, 0.15);
draw_set_blend_mode(bm_normal);

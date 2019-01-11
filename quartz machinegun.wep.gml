#define init
global.sprQuartzMachinegun = sprite_add_weapon("sprites/sprQuartzMachinegun.png",7,3)
global.sprQuartzBullet     = sprite_add("sprites/projectiles/sprQuartzBullet.png",2,12,12)
global.sprHud = sprite_add("sprites/sprQuartzMachinegunHud.png", 1, 12, 3)

#define weapon_name
return "QUARTZ MACHINEGUN"

#define weapon_sprt_hud
return global.sprHud

#define weapon_sprt
return global.sprQuartzMachinegun;

#define weapon_type
return 1;

#define weapon_cost
return 1;

#define weapon_area
return 13;

#define weapon_load
return 4;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_auto
return true;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_text
return choose("GLASS CANNON","BE CAREFUL WITH IT")

#define weapon_fire
weapon_post(7,0,18)
sound_play_pitch(sndHeavyRevoler,random_range(1,1.1))
sound_play_pitch(sndLaserCrystalHit,random_range(1.7,2.1))
with instance_create(x,y,CustomProjectile)
{
  sprite_index = global.sprQuartzBullet
  mask_index   = mskHeavyBullet
  projectile_init(other.team,other)
  force  = 4
  damage = 6
  typ = 1
  image_speed = 1
  recycle_amount = 1
  motion_add(other.gunangle+random_range(-2,2)*other.accuracy,20)
  image_angle = direction
  pierce  = 2
  lasthit = -4
  on_hit     = quartzbullet_hit
  on_anim   = quartzbullet_anim
  on_draw    = quartzbullet_draw
  on_destroy = quartzbullet_destroy
}

#define quartzbullet_anim
image_index = 1
image_speed = 0

#define quartzbullet_destroy
repeat(3) with instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust){sprite_index = sprExtraFeetDust}
instance_create(x+lengthdir_x(sprite_width/2,direction),y+lengthdir_y(sprite_height/2,direction),WepSwap){image_angle = random(360)}
view_shake_at(x,y,2)
sleep(1)

#define quartzbullet_hit
if projectile_canhit_melee(other) = true || lasthit != other
{
  sleep(5)
  view_shake_at(x,y,6)
  projectile_hit(other,damage,force,direction)
  pierce--
  lasthit = other
  recycle_amount = 0
}
if pierce < 0{instance_destroy()}

#define quartzbullet_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);

#define step
mod_script_call("mod","defpack tools","quartz_penalty",mod_current)

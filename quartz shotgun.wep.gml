#define init
global.sprQuartzShotgun = sprite_add_weapon("sprites/sprQuartzShotgun.png",7,3)
global.sprQuartzBullet2 = sprite_add("sprites/projectiles/sprQuartzBullet2.png",2,12,12)

#define weapon_name
return "QUARTZ SHOTGUN"

#define weapon_sprt
return global.sprQuartzShotgun;

#define weapon_type
return 2;

#define weapon_cost
return 2;

#define weapon_area
return 13;

#define weapon_load
return 12;

#define weapon_swap
return sndSwapShotgun;

#define weapon_auto
return false;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_text
return choose("PRODUCT OF PRISMATIC FORGERY","BE CAREFUL WITH IT")

#define weapon_fire
weapon_post(7,0,25)
sound_play_pitch(sndSawedOffShotgun,random_range(1.2,1.4))
sound_play_pitch(sndSlugger,random_range(.7,.8))
sound_play_pitch(sndLaserCrystalHit,random_range(1.4,1.7))
repeat(5) with instance_create(x,y,CustomProjectile)
{
  sprite_index = global.sprQuartzBullet2
  mask_index   = mskHeavyBullet
  projectile_init(other.team,other)
  force  = 4
  damage[0] = 6
  damage[1] = 4
  typ = 1
  friction = random_range(.6,2)
  image_speed = 1
  motion_add(other.gunangle+random_range(-9,9)*other.accuracy,26)
  image_angle = direction
  pierce  = 2
  lasthit = -4
  on_hit     = quartzbullet_hit
  on_step    = quartzbullet_step
  on_draw    = quartzbullet_draw
  on_destroy = quartzbullet_destroy
  on_wall    = quartzbullet_wall
}

#define quartzbullet_wall
move_bounce_solid(false)
image_angle = direction
direction += random_range(-4,4)
sound_play_pitchvol(sndHitWall,random_range(.8,1.2),.5)
with instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust){sprite_index = sprExtraFeetDust}

#define quartzbullet_step
if image_index = 1 image_speed = 0;
if speed <= friction instance_destroy()

#define quartzbullet_destroy
repeat(3) with instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust){sprite_index = sprExtraFeetDust}
instance_create(x+lengthdir_x(sprite_width/2,direction),y+lengthdir_y(sprite_height/2,direction),WepSwap){image_angle = random(360)}
view_shake_at(x,y,2)
sleep(1)

#define quartzbullet_hit
if projectile_canhit(other) = true && lasthit != other
{
  sleep(damage[image_index])
  view_shake_at(x,y,damage[image_index])
  projectile_hit(other,damage[image_index],force,direction)
  pierce--
  lasthit = other
}
if pierce < 0{instance_destroy()}

#define quartzbullet_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);

#define step
mod_script_call("mod","defpack tools","quartz_penalty",mod_current)

#define init
global.sprDynamicSlugger = sprPopoSlugger//sprite_add_weapon("sprDynamicSlugger.png",3,2)

#define weapon_name
return "DYNAMIC SLUGGER"

#define weapon_type
return 2;

#define weapon_cost
return 2;

#define weapon_area
return 8;

#define weapon_load
return 26;

#define weapon_swap
return sndSwapShotgun;

#define weapon_auto
return false;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_sprt
return global.sprDynamicSlugger;

#define weapon_text
return "SO DYNAMIC"

#define weapon_fire
weapon_post(6,-20,15)
sound_play_pitch(sndSlugger,.6)
sound_play_pitch(sndSuperSlugger,1.6)
with instance_create(x,y,CustomProjectile)
{
  team    = other.team
  creator = other
  sprite_index = sprPopoSlug
  mask_index   = 847
  motion_add(other.gunangle+random_range(-4,4)*other.accuracy,28)
  image_angle = direction
  opierce = 12
  pierce  = opierce
  damage[0] = 3
  damage[1] = 2
  force[0]  = 7
  force[1]  = 2
  friction  = 2
  image_speed = 1
  on_destroy = dyn_destroy
  on_step = dyn_step
  on_wall = dyn_wall
  on_draw = dyn_draw
  on_hit  = dyn_hit
}
#define dyn_destroy
with instance_create(x,y,BulletHit){sprite_index = sprPopoSlugDisappear;image_angle = other.image_angle}

#define dyn_step
if image_index = 1 image_speed = 0
if speed <= friction instance_destroy()

#define dyn_wall
move_bounce_solid(false)
sleep(10)
direction += random_range(10,10)
repeat(3)instance_create(x,y,Dust)
speed *= .9 + skill_get(15)*.1
image_angle = direction

#define dyn_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.15);
draw_set_blend_mode(bm_normal);

#define dyn_hit
if projectile_canhit(other) = true
{
    if other.team != team
    {
      x -= hspeed/(1+other.size)*skill_get(15)*.8
      y -= vspeed/(1+other.size)*skill_get(15)*.8
      pierce--
      projectile_hit(other,damage[image_index],force[image_index],direction)
      speed *= .95 + skill_get(15)*.1
      sleep(5*other.size)
      view_shake_at(x,y,2*other.size)
      if other.my_health <= 0{sleep(16*other.size);view_shake_at(x,y,8*other.size);pierce = opierce}
      if pierce <= 0 instance_destroy()
    }
}

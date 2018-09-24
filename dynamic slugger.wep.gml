#define init
global.sprDynamicSlugger = sprite_add_weapon("sprWideSlugger.png",3,5)
global.sprWideSlug = sprite_add("sprites/projectiles/sprWideSlug.png",2,12,17);
global.mskWideSlug = sprite_add("sprites/projectiles/mskWideSlug.png",2,12,17);

#define weapon_name
return "DYNAMIC SLUGGER"

#define weapon_type
return 2;

#define weapon_cost
return 3;

#define weapon_area
return 8;

#define weapon_load
return 48;

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
  sprite_index = global.sprWideSlug
  mask_index = global.mskWideSlug
  motion_add(other.gunangle+random_range(-4,4)*other.accuracy,6)
  maxspeed = speed
  image_angle = direction
  damage[0] = 3
  damage[1] = 2
  force[0]  = 1
  force[1]  = 2
  typ       = 0
  friction  = .03
  image_speed = 1
  pierce = 45
  on_destroy = dyn_destroy
  on_step = dyn_step
  on_wall = dyn_wall
  on_draw = dyn_draw
  on_hit  = dyn_hit
}
#define dyn_destroy
repeat(3)
{
  with instance_create(x,y,Bullet2)
  {
    motion_add(random(360),random_range(8,12))
    image_angle = direction
    team    = other.team
    creator = other.creator
  }
}
with instance_create(x,y,BulletHit){sprite_index = sprHeavySlugHit;image_angle = other.image_angle}

#define dyn_step
if image_index = 1 image_speed = 0
with instances_matching_ne(hitme,"team",other.team)
{
  if distance_to_object(other) <= 12 && current_frame mod 2 = 0
  {
    var _id = id;
    with other
    {
      x -= hspeed*3/4
      y -= vspeed*3/4
      other.direction = direction
      projectile_hit(_id,damage[image_index],min(0,force[image_index]-other.size),direction)
      speed *= .95 + skill_get(15)*.1
      sleep(5*other.size)
      view_shake_at(x,y,2*other.size)
      if other.my_health <= 0{sleep(16*other.size);view_shake_at(x,y,8*other.size);speed += 2}
      if speed > maxspeed speed = maxspeed
      pierce--
      if pierce <= 0{instance_destroy();exit}
    }
  }
}
if speed <= friction instance_destroy()

#define dyn_wall
if image_index = 0
{
  with other
  {
    instance_create(x,y,FloorExplo)
    instance_destroy()
  }
}
else instance_destroy()

#define dyn_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.15);
draw_set_blend_mode(bm_normal);

#define dyn_hit
/*
if projectile_canhit(other) = true
{
    if other.team != team
    {

    }
}

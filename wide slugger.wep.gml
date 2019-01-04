#define init
global.sprWideSlugger = sprite_add_weapon("sprites/sprWideSlugger.png",3,5)
global.sprWideSlug = sprite_add("sprites/projectiles/sprWideSlug.png",2,12,17);
global.mskWideSlug = sprite_add("sprites/projectiles/mskWideSlug.png",2,12,17);

#define weapon_name
return "WIDE SLUGGER"

#define weapon_type
return 2;

#define weapon_cost
return 2;

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
return global.sprWideSlugger;

#define weapon_text
return "BRICK BLASTER"

#define weapon_fire
weapon_post(7,-40,15)
var _p = random_range(.8,1.2);

sound_play_pitch(sndSlugger,.7*_p)
sound_play_pitch(sndDoubleShotgun,.7*_p)
sound_play_pitch(sndSuperSlugger,1.4*_p)

with instance_create(x,y,CustomProjectile)
{
  team    = other.team
  creator = other
  sprite_index = global.sprWideSlug
  mask_index = global.mskWideSlug
  motion_add(other.gunangle+random_range(-4,4)*other.accuracy,6)
  maxspeed = speed
  image_angle = direction
  damage = 2
  force  = 6
  typ       = 0
  friction  = .03
  image_speed = 1
  image_xscale = 1.25
  image_yscale = 1.25
  pierce = 45
  on_destroy = dyn_destroy
  on_end_step = dyn_step
  on_wall = dyn_wall
  on_draw = dyn_draw
  on_hit  = dyn_hit
  on_anim = dyn_anim
}
#define dyn_anim
image_xscale = 1
image_yscale = 1
image_speed = 0
image_index = 1

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
if current_frame mod 2 < current_time_scale with instances_matching_ne(hitme,"team",team)
{
  if distance_to_object(other) <= 12 
  {
    var _id = id;
    with other
    {
      x -= hspeed*3/4
      y -= vspeed*3/4
      other.direction = direction
      projectile_hit(_id,damage + 1 - floor(image_index),min(0,force + 3 * (1 - floor(image_index)) -other.size/4),direction)
      speed *= .95 + skill_get(15)*.1
      var s = min(other.size,4)
      sleep(5*s)
      view_shake_at(x,y,2*s)
      if other.my_health <= 0{sleep(16*s);view_shake_at(x,y,8*s);speed += 2}
      if speed > maxspeed speed = maxspeed
      if --pierce <= 0{instance_destroy();exit}
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
sound_play_pitchvol(sndFlakExplode,1.3,.2)
sound_play_pitchvol(sndHitWall,1.3,.5)

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

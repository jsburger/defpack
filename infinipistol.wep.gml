#define init
global.sprInfiniPistol = sprite_add_weapon("sprites/sprPelletPistol.png", -3, 2);
global.sprPellet       = sprite_add("sprites/projectiles/sprPellet.png",2,7,6)
global.sprPelletHit    = sprite_add("sprites/projectiles/sprPelletHit.png",4,8,8)
#define weapon_name
return "INFINIPISTOL";

#define weapon_sprt
return global.sprInfiniPistol;

#define weapon_type
return 0;

#define weapon_auto
return -100;

#define weapon_load
return 0;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapPistol

#define weapon_melee
return 0;

#define weapon_area
return 6;

#define weapon_text
return "POTENTIAL"

#define weapon_fire
weapon_post(2,0,3)
motion_add(gunangle-180,2)
sound_play_pitch(sndPopgun,random_range(1,2))
sound_play_pitchvol(sndRustyRevolver,random_range(2,3),.6)
sound_play_pitchvol(sndNothing2Ball,random_range(2,3),.4)
with instance_create(x,y,CustomProjectile)
{
  typ = 1
  sprite_index = global.sprPellet
  mask_index   = global.sprPellet
  recycle_amount = 0
  damage = 1 if irandom(999999) = 0 damage = 999999999999999999999999
  team = other.team
  force = 5
  bounce = 2
  image_speed = 1
  creator = other
  move_contact_solid(other.gunangle,6)
  motion_add(other.gunangle+random_range(-7,7)*other.accuracy,18)
  image_angle = direction
  on_destroy = pellet_destroy
  on_wall    = pellet_wall
  on_anim    = pellet_step
  on_draw    = pellet_draw
}

#define pellet_wall
if place_meeting(x+hspeed,y,Wall)
{
  instance_create(x,y,Dust)
  sound_play_pitch(sndHitWall,random_range(.8,1.2))
  hspeed *= -1
  bounce--
  image_angle = direction
}
if place_meeting(x,y+vspeed,Wall)
{
  instance_create(x,y,Dust)
  sound_play_pitch(sndHitWall,random_range(.8,1.2))
  vspeed *= -1
  bounce--
  image_angle = direction
}
if place_meeting(x+hspeed,y+vspeed,Wall)
{
  instance_create(x,y,Dust)
  sound_play_pitch(sndHitWall,random_range(.8,1.2))
  vspeed *= -1
  hspeed *= -1
  bounce--
  image_angle = direction
}
if bounce < 0 instance_destroy()

#define pellet_destroy
with instance_create(x,y,BulletHit){sprite_index = global.sprPelletHit}

#define pellet_step
image_speed = 0
image_index = 1

#define pellet_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);

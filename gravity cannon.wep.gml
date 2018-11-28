#define init
global.sprGravityCannon = sprite_add_weapon("sprites/sprGravityCannon.png",4,4);
global.sprGravityBall   = sprite_add("sprites/projectiles/sprGravityBall.png",2,24,24);

#define weapon_name
return "GRAVITY CANNON"

#define weapon_type
return 5

#define weapon_cost
return 3

#define weapon_area
return -1

#define weapon_load
return 40

#define weapon_swap
return sndSwapEnergy

#define weapon_auto
return true

#define weapon_melee
return false

#define weapon_laser_sight
return false

#define weapon_fire
with instance_create(x,y,CustomProjectile)
{
  sprite_index = global.sprGravityBall
  mask_index   = sprGrenade
  image_speed = 1
  force  = 0
  radius = 48 + skill_get(17) * 12
  creator = other
  team    = other.team
  move_contact_solid(other.gunangle,16)
  motion_add(other.gunangle,3-skill_get(17)*.5)
  image_angle = direction

  on_hit     = gravy_hit
  on_step    = gravy_step
  on_wall    = gravy_wall
  on_draw    = gravy_draw
  on_destroy = gravy_destroy
}

#define gravy_hit
projectile_hit(other,choose(1,1,0),force,direction)

#define gravy_step
if image_index = 1{image_speed = 0}
if irandom(2) != 0{instance_create(x+random_range(-10,10),y+random_range(-10,10),PlasmaTrail)}
with instances_matching_ne(hitme,"team",other.team)
{
  if self = prop{exit}
  if distance_to_object(other) <= other.radius
  {
    motion_add(point_direction(x,y,other.x,other.y),2/max(1,size))
  }
}

#define gravy_wall
instance_destroy()

#define gravy_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);

#define gravy_destroy
instance_create(x,y,BulletHit)

#define weapon_sprt
return global.sprGravityCannon

#define weapon_text
return "FAUX @pPORTALS"

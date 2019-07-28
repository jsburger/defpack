#define init
global.sprPlasmaCharger = sprite_add_weapon("sprites/sprPlasmaCharger.png",4,4);
global.sprPlasmaBall    = sprite_add("sprites/projectiles/sprPlasmaBall.png",2,12,12);

#define weapon_name
return "PLASMA CHARGER"

#define weapon_type
return 5

#define weapon_cost
return 1

#define wepaon_chrg
return 1

#define weapon_area
return -1

#define weapon_reloaded
with instances_matching(CustomObject,"name","plasmacharge")
{
  if other = creator
  {
    return -4
  }
}
return sndPlasmaReload


#define weapon_load
with instances_matching(CustomObject,"name","plasmacharge")
{
  if other = creator
  {
    return 1
  }
}
return 1

#define weapon_swap
return sndSwapEnergy

#define weapon_auto
return true

#define weapon_melee
return false

#define weapon_laser_sight
return false

#define weapon_fire
/*var p = random_range(.8,1.2)
if !skill_get(17)
{
	sound_set_track_position(sndLaser,.09)
	sound_play_pitch(sndLaser,.2*p)
	sound_play_charge(sndLaser,1)
}
else
{
	sound_play_pitch(sndLaserUpg,.4*p)
	sound_play_charge(sndLaser,1)
}
sound_play_pitch(sndPlasmaRifle,.2*p)*/

with instances_matching(CustomObject,"name","plasmacharge")
{
  if other = creator
  {
    lifetime = 3
    exit
  }
}
with instance_create(x,y,CustomObject)
{
  creator = other
  team = other.team
  name = "plasmacharge"
	image_xscale = .2
	image_yscale = .2
  size = 0
  force = 1
	sprite_index = global.sprPlasmaBall
  image_speed = 0
	gunangle = other.gunangle
	lifetime = 3
	on_step    = sphere_step
	on_draw    = sphere_draw
  on_destroy = sphere_destroy
}

#define sphere_step
var _r = random(360)
repeat(3) instance_create(x+lengthdir_x(sprite_get_width(sprite_index)*image_xscale*random_range(.4,.7),_r),y+lengthdir_y(sprite_get_width(sprite_index)*image_yscale*random_range(.4,.7),_r),PlasmaTrail)
if instance_exists(creator)
{
  x = creator.x + lengthdir_x(16+size*2,creator.gunangle)
  y = creator.y + lengthdir_y(16+size*2,creator.gunangle)
  image_angle = creator.gunangle
  direction = image_angle
  with creator weapon_post(other.size*3,other.size*3,1)
}
if size < 1.5
{
  size += .1/(size*4+1)/current_time_scale
}
else size = 1.5
image_xscale = .2 + size
image_yscale = .2 + size
with instances_matching_ne(hitme,"team",other.team)
{
  if place_meeting(x,y,other)
  {
    projectile_hit(self,1,other.force,other.direction)
  }
}
lifetime--
if lifetime <= 0 instance_destroy()

#define sphere_draw
var _v = random_range(.95,1.05)
draw_self();
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, 0, x, y, image_xscale*1.5*_v, image_yscale*1.5*_v, image_angle, image_blend, .15+skill_get(17)*.05);
draw_set_blend_mode(bm_normal);

#define sphere_destroy
with instance_create(x,y,PlasmaBall)
{
  image_index = 1
  creator = other.creator
  team = other.team
  image_xscale = .2 + other.size * 1.7
  image_yscale = .2 + other.size * 1.7
  motion_add(other.direction,14-other.size)
  image_angle = direction
}

#define weapon_sprt
return global.sprPlasmaCharger

#define weapon_text
return "WAIT FOR THE @w PUNCHLINE"

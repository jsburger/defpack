#define init
global.sprBulletHead = sprite_add("sprites/projectiles/sprFricBulletHead.png", 0, 0, 5)
global.sprBulletBody = sprite_add("sprites/projectiles/sprFricBulletBody.png", 0, 0, 5)

#define weapon_name
return "GUN"
#define weapon_type
return 1
#define weapon_cost
return 0
#define weapon_area
return -1
#define weapon_load
return 12
#define weapon_swap
return sndSwapPistol
#define weapon_auto
return false
#define weapon_melee
return false
#define weapon_laser_sight
return false
#define weapon_sprt
return sprRevolver
#define weapon_text
return "SHOOT"
#define weapon_fire

with instance_create(x, y, CustomProjectile){
  damage = 5
  sprite_index = global.sprBulletHead
  xstart = x
  ystart = y
  motion_add(other.gunangle + random_range(-20, 20), 80)
  timer = 1
  length = speed * timer
  image_angle = direction
  on_step = b_step
  on_draw = b_draw
}

#define b_step
timer--
if timer <= 0 speed = 0
if timer = -3 instance_destroy()

#define b_draw
draw_sprite_ext(global.sprBulletBody, 0, xstart, ystart, length,  1, image_angle, c_white, 1)
draw_self()

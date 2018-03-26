#define init
global.sprStickyDiscGun = sprite_add_weapon("sprStickyDiscGun.png",-3,3)
global.sprStickyDisc = sprite_add("sprStickyDisc.png",2,6,6)
return "STICKY DISC GUN"
#define weapon_type
return 3
#define weapon_cost
return 2
#define weapon_area
return -1
#define weapon_load
return 17
#define weapon_swap
return sndSwapBow
#define weapon_auto
return true
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt
return global.sprStickyDiscGun
#define weapon_text
return "I AM SO SORRY"
#define weapon_fire
weapon_post(3,4,0)
sound_play_gun(sndDiscgun, 0.2, 0.3);
with instance_create(x,y,CustomProjectile)
{
  typ = 1
  dist = 0
  damage = 6
  team = -10
  image_speed = .5
  name = "Sticky Disc"
  sprite_index = global.sprStickyDisc
  move_contact_solid(other.gunangle,16)
  soundcheck = 0
  motion_add(other.gunangle+random_range(-8,8)*other.accuracy,5)
  image_angle = direction
  on_step = stickydisc_step
  on_hit = stickydisc_hit
  on_wall = stickydisc_wall
  on_destroy = stickydisc_destroy
}

#define stickydisc_step
if speed > 0{instance_create(x,y,DiscTrail)}
dist += 1
if instance_exists(Player) and instance_exists(enemy)
{dir = instance_nearest(x,y,enemy)
if speed > 0 and skill_get(21) = 1 and point_distance(x,y,dir.x,dir.y) < 32
{
x += lengthdir_x(1,point_direction(x,y,dir.x,dir.y))
y += lengthdir_y(1,point_direction(x,y,dir.x,dir.y))}
}
if dist > 200{instance_destroy()}

#define stickydisc_hit
if other.my_health-damage>0&&soundcheck=0
{
  speed = 0
  instance_create(other.x,other.y,Dust);repeat(5){if depth!=-3{with instance_create(x,y,Smoke){depth = -4}}}
  x=other.x
  y=other.y
  depth = -3
}
if other.sprite_index != other.spr_hurt{projectile_hit(other, damage, 5, other.direction-180)}

#define stickydisc_wall
if soundcheck = 0{soundcheck = 1;speed = 0;sound_play(sndGrenadeStickWall);instance_create(x,y,Dust);repeat(5){with instance_create(x,y,Smoke){depth = -3}}}

#define stickydisc_destroy
with instance_create(x,y,DiscTrail){sprite_index=sprDiscDisappear}
sound_play_hit(sndDiscDie, 0.2)
with instance_create(x,y,Smoke){depth = -3}

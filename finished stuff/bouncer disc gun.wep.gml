#define init
global.sprBouncerDiscGun = sprite_add_weapon("sprBouncerDiscGun.png",-3,3)
global.sprBouncerDisc = sprite_add("sprBouncerDisc.png",2,6,6)
return "BOUNCER DISC GUN"
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
return global.sprBouncerDiscGun
#define weapon_text
return "I AM SO SORRY"
#define weapon_fire
weapon_post(3,4,0)
sound_play_pitch(sndDiscgun,random_range(.85,.95))
sound_play_pitch(sndBouncerSmg,1.4)
with instance_create(x+lengthdir_x(4,gunangle),y+lengthdir_y(4,gunangle),CustomProjectile)
{
  typ = 1
  dist = 0
  damage = 11
  team = -10
  image_speed = .5
  name = "Bouncer Disc"
  sprite_index = global.sprBouncerDisc
  move_contact_solid(other.gunangle,12+other.speed)
  motion_add(other.gunangle+random_range(-8,8)*other.accuracy,4)
  image_angle = direction
  on_step = bouncerdisc_step
  on_hit = bouncerdisc_hit
  on_wall = bouncerdisc_wall
  on_destroy = bouncerdisc_destroy
}

#define bouncerdisc_step
if speed > 0{instance_create(x,y,DiscTrail)}
dist += 1
if instance_exists(Player) and instance_exists(enemy)
{dir = instance_nearest(x,y,enemy)
if speed > 0 and skill_get(21) = 1 and point_distance(x,y,dir.x,dir.y) < 32
{
x += lengthdir_x(1,point_direction(x,y,dir.x,dir.y))
y += lengthdir_y(1,point_direction(x,y,dir.x,dir.y))}
}

#define bouncerdisc_hit
if other.my_health-damage>0{motion_set(point_direction(other.x,other.y,x,y),speed)}else{motion_set(random(359),speed)}
if other.sprite_index != other.spr_hurt{projectile_hit(other, damage, 5, other.direction-180)}
if speed < 8{speed+=.1}

sound_play_pitch(sndDiscBounce,random_range(.8,1.2))
sound_play_pitch(sndBouncerBounce,random_range(1,1))
image_angle = direction

#define bouncerdisc_wall
move_bounce_solid(false)
instance_create(x,y,DiscBounce)
image_angle = direction
sound_play_pitch(sndDiscBounce,random_range(.9,1.1)+((speed/4)-1)*.2)
sound_play_pitch(sndBouncerBounce,random_range(1,1))
if dist > 250{instance_destroy();exit}
if speed < 8{speed+=.13}

#define bouncerdisc_destroy
with instance_create(x,y,DiscTrail){sprite_index=sprDiscDisappear}
sound_play_hit(sndDiscDie, 0.2)

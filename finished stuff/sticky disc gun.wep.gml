#define init
global.sprStickyDiscGun = sprite_add_weapon("sprStickyDiscGun.png",-3,3)
global.sprStickyDisc = sprite_add("sprStickyDisc.png",2,12,12)
return "STICKY DISC GUN"
#define weapon_type
return 3
#define weapon_cost
return 2
#define weapon_area
return -1
#define weapon_load
return 14
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
  damage = 8
  team = -10
  image_speed = .45
  name = "Sticky Disc"
  sprite_index = global.sprStickyDisc
  move_contact_solid(other.gunangle,50)
  soundcheck = 0
  motion_add(other.gunangle+random_range(-8,8)*other.accuracy,4)
  orspeed = speed
  image_angle = direction
  on_step    = stickydisc_step
  on_hit     = stickydisc_hit
  on_destroy = stickydisc_destroy
  on_wall    = stickydisc_wall
}

#define stickydisc_step
if speed > 0{with instance_create(x,y,DiscTrail){image_xscale = 2;image_yscale = 2}}
dist += 1
if dist > 200{instance_destroy();exit}
if place_meeting(x,y,enemy)
{
  if other.my_health-damage>0 && soundcheck=0
  {
    soundcheck = 1
    sound_play(sndGrenadeStickWall)
    speed = 0
    instance_create(other.x,other.y,Dust);repeat(12){if depth!=-3{with instance_create(x,y,Smoke){depth = -4}}}
    x=other.x
    y=other.y
    depth = -3
  }
}

#define stickydisc_hit
if projectile_canhit_melee(other){projectile_hit(other, damage, 5, direction)}

#define stickydisc_wall
move_bounce_solid(false)

#define stickydisc_destroy
with instance_create(x,y,DiscTrail){sprite_index=sprDiscDisappear;image_xscale = 2}
sound_play_hit(sndDiscDie, 0.2)
with instance_create(x,y,Smoke){depth = -3}

#define init
global.sprMegaDiscGun    = sprite_add_weapon("sprites/sprMegaDiscGun.png",5,9);
global.sprMegaDisc       = sprite_add("sprites/projectiles/sprMegaDisc.png",2,12,12);
global.sprMegaDiscDie    = sprite_add("sprites/projectiles/sprMegaDiscDie.png",6,12,12);
global.sprMegaDiscTrail  = sprite_add("sprites/projectiles/sprMegaDiscTrail.png",3,12,12);
global.sprMegaDiscBounce = sprite_add("sprites/projectiles/sprMegaDiscBounce.png",4,12,12);

#define weapon_name
return "MEGA DISC GUN"

#define weapon_type
return 3;

#define weapon_cost
return 2;

#define weapon_area
return -1;

#define weapon_load
return 50;

#define weapon_swap
return sndSwapBow;

#define weapon_auto
return true;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_fire
weapon_post(12,-80,25)
sleep(20)
motion_add(gunangle-180,3)
var _p = random_range(.8,1.2);
sound_play_pitch(sndDiscgun,.7*_p)
sound_play_pitchvol(sndDiscHit,.5*_p,.8)
sound_play_pitchvol(sndDiscDie,.4,.8*_p)
with instance_create(x,y,CustomProjectile)
{
  move_contact_solid(other.gunangle,14)
  sprite_index = global.sprMegaDisc
  creator = other
  team    = other.team
  dist = 0
  damage = 2
  image_speed = .5
  motion_add(other.gunangle+random_range(-6,6),5)
  maxspeed = speed
  hitid = [sprite_index,"MEGA DISC"]
  image_angle = direction
  on_step    = md_step
  on_wall    = md_wall
  on_hit     = md_hit
  on_destroy = md_destroy
}

#define md_step
dist++
if current_frame mod 1 / current_time_scale = 0
{
  with instance_create(x,y,DiscTrail)
  {
    sprite_index = global.sprMegaDiscTrail
  }
}
if skill_get(21) = true
{
    var closeboy = instance_nearest(x,y,enemy);
    if distance_to_object(closeboy) <= 40
    {
      motion_add(point_direction(x,y,closeboy.x,closeboy.y),.5)
      speed = maxspeed
    }
}
if instance_exists(creator){if team = creator.team{if !place_meeting(x,y,creator){team = -10}}}

#define md_wall
dist += 5
sleep(20)
view_shake_at(x,y,8)
sound_play_pitchvol(sndDiscBounce,random_range(.6,.8),.4)
move_bounce_solid(false)
direction += random_range(-12,12)
with other{instance_create(x,y,FloorExplo);instance_destroy()}
with instance_create(x,y,DiscBounce)
{
  sprite_index = global.sprMegaDiscBounce
}
if dist >= 200 instance_destroy()

#define md_destroy
sound_play_pitchvol(sndDiscDie,random_range(.6,.8),.4)
with instance_create(x,y,DiscDisappear)
{
  sprite_index = global.sprMegaDiscDie
}

#define md_hit
if place_meeting(x,y,creator)
{
  sound_play(sndDiscHit)
  other.lasthit = hitid
  sleep(3*other.size+4)
}
x -= hspeed/2
y -= vspeed/2
projectile_hit(other,damage,0,direction)
sleep(other.size * 7)
view_shake_at(x,y,10)
dist++

#define weapon_sprt
return global.sprMegaDiscGun;

#define weapon_text
return "watch out"

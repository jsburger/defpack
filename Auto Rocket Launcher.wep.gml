#define init
global.sprAutoRocketLauncher = sprite_add_weapon("Auto Rocket Launcher.png", 1, 3);
global.sprRocklet = sprite_add("rocklet.png",0,5,4)
global.sprSmallGoldExplosion = sprite_add("small gold explosion.png",7,12,12)

#define weapon_name
return "AUTO ROCKET LAUNCHER";

#define weapon_sprt
return global.sprAutoRocketLauncher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 8;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 4;

#define weapon_text
return "PEST BULLETS CREATE TOXIN WHEN CONNECTING";

#define weapon_fire
if fork(){
    repeat(2){
      weapon_post(4,-3,2)
        sound_play_pitch(sndRocket,1.3)
        with instance_create(x,y,CustomProjectile)
        {
          sprite_index = global.sprRocklet
          swarm = true
          creator = other
          damage = 3
          team = creator.team
          motion_add(other.gunangle+random_range(-4,4)*creator.accuracy,random_range(5,6))
          maxspeed = speed
          timer = 2
          friction = -  .2
          t = 0;
          turn = choose(-1,1)
          increment = random_range(11,25);
          amplitude = random_range(1,7);
          on_step = rocket_step
          on_destroy = rocket_destroy
        }
        wait(2)
    }
}

#define rocket_step
with instance_create(x,y,BoltTrail)
{
  image_blend = $1A1726
  image_angle = other.direction
  image_yscale = 1.6
  image_xscale = other.speed
}
image_angle = direction
timer -= 1;
if timer <= 0
{
  t = (t + increment) mod 360;
  shift = amplitude * dsin(t);
  direction += (shift/2) * turn
  if instance_exists(enemy)
  {
    var closeboy = instance_nearest(x,y,enemy)
    if point_distance(x,y,closeboy.x,closeboy.y) < 60
    {
      motion_add(point_direction(x,y,closeboy.x,closeboy.y),.8)
    }
  }
}
if speed > maxspeed{speed = maxspeed}

#define rocket_destroy
with instance_create(x,y,SmallExplosion){sprite_index = global.sprSmallGoldExplosion; damage -= 2}

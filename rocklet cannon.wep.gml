#define init
global.sprRockletCannon = sprite_add_weapon("sprites/sprRockletCannon.png", 5, 3);
global.sprRocklet       = sprite_add("sprites/projectiles/sprRocklet.png",0,0,3)
global.sprPuncherRocket = sprite_add("sprites/projectiles/sprPuncherRocket.png",0,6,4)

#define weapon_name
return "ROCKLET CANNON";

#define weapon_sprt
return global.sprRockletCannon;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 32;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 3;

#define weapon_text
return "replace me please";

#define weapon_fire
weapon_post(7,-3,20)
sound_play_pitch(sndSlugger,1.3)
sound_play_pitch(sndRocketFly,random_range(2,2.6))
sound_play_pitch(sndGrenadeRifle,random_range(.2,.3))
sound_play_pitch(sndHeavyNader,random_range(.7,.8))
with instance_create(x,y,CustomProjectile)
{
  creator = other
  team = other.team
  damage = 3
  sprite_index = global.sprPuncherRocket
  motion_add(other.gunangle+random_range(-5,5)*other.accuracy,2)
  friction = -.8
  maxspeed = 16
  image_angle = direction
  ammo = 4
  on_draw    = cannon_draw
  on_step    = cannon_step
  on_destroy = cannon_destroy
}

#define cannon_step
with instance_create(x-lengthdir_x(16+speed,other.direction),y-lengthdir_y(16+speed,other.direction),BoltTrail)
{
	image_blend = c_yellow
	image_angle = other.direction
	image_yscale = 1.4
	image_xscale = 12+other.speed
	if fork(){
	    while instance_exists(self){
	        image_blend = merge_color(image_blend,c_red,.1*current_time_scale)
	        wait(0)
	    }
	    exit
	}
}
if speed > maxspeed{speed = maxspeed}

#define cannon_destroy
var i = random(360);
if fork(){
    repeat(ammo){
        sound_play_pitch(sndSlugger,2)
        sound_play_pitch(sndRocketFly,random_range(2.6,3.2))
        sound_play_pitch(sndGrenadeRifle,random_range(.3,.4))
        sound_play_pitch(sndMachinegun,random_range(.7,.8))
        with instance_create(x,y,CustomProjectile)
        {
          sprite_index = global.sprRocklet
          creator = other.creator
          damage = 3
          team = other.team
          motion_add(i+random_range(-3,3),2)
          maxspeed = 12
          timer = 7
          typ = 1
          friction = -.6
          t = 0;
          image_angle = direction
          turn = choose(-1,1)
          increment = random_range(32,36);
          amplitude = random_range(1,7);
          instance_create(x,y,Smoke)
          on_step = rocket_step
          on_destroy = rocket_destroy
        }
        sound_play(sndExplosionS)
        instance_create(x+lengthdir_x(16,i),y+lengthdir_y(16,i),SmallExplosion)
        i += 360/ammo
    }
}


#define cannon_draw
draw_self()
draw_sprite_ext(sprRocketFlame,-1,x,y,1,1,image_angle,c_white,image_alpha)

#define rocket_step
with instance_create(x,y,BoltTrail)
{
	image_blend = c_yellow
	image_angle = other.direction
	image_yscale = 1.2
	image_xscale = 4+other.speed
	if fork(){
	    while instance_exists(self){
	        image_blend = merge_color(image_blend,c_red,.1*current_time_scale)
	        wait(0)
	    }
	    exit
	}
}
timer -= 1;
if timer <= 0
{
  t = (t + increment) mod 360;
  shift = amplitude * dsin(t);
  direction += (shift/2) * turn / 3
  /*if instance_exists(enemy)
  {
    var closeboy = instance_nearest(x,y,enemy)
    if point_distance(x,y,closeboy.x,closeboy.y) <= 32
    {
      motion_add(point_direction(x,y,closeboy.x,closeboy.y),1.2)
    }
  }*/
}
if speed > maxspeed{speed = maxspeed}
image_angle = direction

#define rocket_destroy
sound_play(sndExplosionS)
with instance_create(x+lengthdir_x(speed,direction),y+lengthdir_y(speed,direction),SmallExplosion){damage -= 2}
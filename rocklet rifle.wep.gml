#define init
global.sprRockletRifle = sprite_add_weapon("sprites/sprRockletRifle.png", 2, 1);
global.sprRocklet = sprite_add("sprites/projectiles/sprRocklet.png",0,0,3)

#define weapon_name
return "ROCKLET RIFLE";

#define weapon_sprt
return global.sprRockletRifle;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 9;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 5;

#define weapon_text
return "replace me please";

#define weapon_fire
if fork(){
    repeat(1){
      weapon_post(4,-3,2)
        sound_play_pitch(sndSlugger,2)
        sound_play_pitch(sndRocket,random_range(1.2,1.4))
        with instance_create(x,y,CustomProjectile)
        {
          sprite_index = global.sprRocklet
          creator = other
          damage = 3
          team = creator.team
          move_contact_solid(other.gunangle,8)
          motion_add(other.gunangle+random_range(-3,3)*creator.accuracy,2)
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
        wait(2)
    }
}

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

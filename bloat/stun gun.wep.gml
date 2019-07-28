#define init
global.sprBouncerPistol = sprite_add_weapon("sprites/Bouncer Pistol.png", -2, 2);

#define weapon_name
return "BOUNCER PISTOL"

#define weapon_sprt
return global.sprBouncerPistol;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 6;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 3;

#define weapon_text
return choose("WOBBLE WOBBLE","YOU AND I WEREN'T MEANT TO BE");

#define weapon_fire

sound_play_pitch(sndBouncerSmg,random_range(1.1,1.2))
sound_play(sndPistol)
weapon_post(2,-2,3)

with instance_create(x,y,CustomProjectile)
{
	damage = 0
	sprite_index = sprBullet1
	team = other.team
	creator = other
	motion_add(other.gunangle+(random(14)-7)*other.accuracy,16)
	trailscale = 2
	hyperspeed = 8
	dir = 0
	on_step 	 = sniper_step
	on_hit 		 = void
	on_destroy = stun_destroy
}

#define sniper_step

while !collision_line(x,y,x+lengthdir_x(100,direction),y+lengthdir_y(100,direction),Wall,1,1) && !collision_line(x,y,x+lengthdir_x(100,direction),y+lengthdir_y(100,direction),hitme,0,1) && dir <1000{
    x+=lengthdir_x(100,direction)
    y+=lengthdir_y(100,direction)
    dir+=100
}

do
{
	dir += hyperspeed
	x += lengthdir_x(hyperspeed,direction)
	y += lengthdir_y(hyperspeed,direction)
	with instances_matching_ne(hitme, "team", team)
	{
		if distance_to_object(other) <= 4
		{
      var _hp = my_health;
			projectile_hit(self,other.damage,other.force,other.direction)
			with other
			{
        if _hp >= damage*3
        {
			    instance_destroy()
			    exit
        }
        else
        {
          damage--
          if damage <= 0
          {
            instance_destroy()
            exit
          }
        }
			}
		}
	}
  if place_meeting(x+lengthdir_x(hyperspeed,direction),y+lengthdir_y(hyperspeed,direction),Wall)
  {
    sleep(5)
    instance_destroy()
    exit
  }
}
while instance_exists(self) and dir < 1000
instance_destroy()

#define stun_destroy
with instance_create(x,y,CustomProjectile)
{
	damage = 0
	sprite_index = sprPopoExplo
	lifetime = 6
	on_hit  = warp_hit
	on_step = warp_step
	on_wall = void
}

#define void

#define warp_hit
with other
{
	if place_meeting(x,y,Wall){exit}
	var _i = 0
	var _dir = point_direction(other.x,other.y,x,y)
	do
	{
		_i++
		x += lengthdir_x(1,_dir)
		y += lengthdir_y(1,_dir)
	}
	until _i >= 600 || place_meeting(x+lengthdir_x(4,_dir),y+lengthdir_y(4,_dir),Wall)
}

#define warp_step
lifetime -= current_time_scale
if lifetime <= 0{instance_destroy()}

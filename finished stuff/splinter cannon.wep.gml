#define init
global.sprSplinterCannon = sprite_add_weapon("sprSplinterCannon.png",6,3)
global.sprSuperSplinter = sprite_add("sprHeavySplinter.png",0,11,5)
return "SPLINTER CANNON"
#define weapon_type
return 3
#define weapon_cost
return 6
#define weapon_area
return 10
#define weapon_load
return 36
#define weapon_swap
return sndSwapBow
#define weapon_auto
return false
#define weapon_melee
return 0
#define weapon_laser_sight
return 1
#define weapon_sprt
return global.sprSplinterCannon
#define weapon_text
return "CONSIDER IT HYPER"
#define weapon_fire
weapon_post(13,22,0)
motion_add(gunangle-180,3)
sound_play_pitch(sndHeavyCrossbow,.8)
sound_play_pitch(sndSuperSplinterGun,.7)
sound_play_pitch(sndSplinterPistol,.6)
with instance_create(x,y,HeavyBolt)
{
  creator = other
  damage = 35
  p = -99999
  i = 0
  sprite_index = global.sprSuperSplinter
  team = creator.team
  move_contact_solid(other.gunangle,20)
  motion_add(other.gunangle+random_range(-2,2)*other.accuracy,12)
  image_angle = direction
  do
  {
    with instance_create(x,y,BoltTrail){
      y += other.vspeed
      x += other.hspeed
      image_angle = point_direction(xprevious,yprevious,x,y)
      image_xscale = point_distance(xprevious,yprevious,x,y)
      image_yscale = 2
    }
    if (place_meeting(x+lengthdir_x(1+speed,direction),y+lengthdir_y(1+speed,direction),enemy) || place_meeting(x+lengthdir_x(1+speed,direction),y+lengthdir_y(1+speed,direction),prop)) && !instance_exists(p){p = instance_nearest(x+lengthdir_x(1+speed,direction),y+lengthdir_y(1+speed,direction),hitme).id}
    if p > -4
    {
      if damage <= p.my_health
      {
        view_shake_max_at(x,y,34)
        repeat(12)
        {
          with instance_create(x,y,Splinter)
          {
            if !skill_get(19){motion_add(random(359),random_range(12,26))}
            else
            {
              motion_add(360/12*other.i,random_range(12,26))
            }
            team = other.team
            image_angle = direction
          }
          i++
        }
      }
      else
      {
        splinterfac = irandom_range(3,5)
        view_shake_max_at(x,y,20)
        repeat(splinterfac)
        {
          with instance_create(x,y,Splinter)
          {
            if !skill_get(19){motion_add(random(359),random_range(12,26))}
            else
            {
              motion_add(360/other.splinterfac*other.i,random_range(12,26))
            }
            team = other.team
            image_angle = direction
          }
          i++
        }
        i = 0
      }
      p = -99999
    }
    sleep(4)
    if place_meeting(x+lengthdir_x(1+speed,direction),y+lengthdir_y(1+speed,direction),Wall){
      sound_play_pitch(sndBoltHitWall,.7)
      sound_play_pitch(sndExplosionS,random_range(.4,.6))
      view_shake_max_at(x,y,55)
      repeat(8)with instance_create(x+random_range(-5,5),y+random_range(-5,5),Dust){
          motion_add(other.direction-180+random_range(-20,20),random_range(1,7))
      }
      repeat(12)
      {
        if !skill_get(19){
        {
          with instance_create(x,y,Splinter){
              motion_add(other.direction-180+random_range(-35,35)*other.creator.accuracy,random_range(12,26))
              image_angle = direction
              team = other.team
            }
          }
        }
        else
        {
          with instance_create(x,y,Splinter){
            motion_add(other.direction-180-35/2+35/12*other.i,random_range(12,26))
            image_angle = direction
            team = other.team
          }
        }
        i++
      }
      sleep(12)
      with instance_nearest(x+lengthdir_x(1+speed,direction),y+lengthdir_y(1+speed,direction),Wall){instance_create(x,y,FloorExplo);instance_destroy()}
      instance_destroy()
    }
    wait(1)
  }
  while instance_exists(self)
}

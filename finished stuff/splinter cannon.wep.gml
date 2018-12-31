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
weapon_post(13,-72,30)
sleep(15)
motion_add(gunangle-180,3)
sound_play_pitch(sndHeavyCrossbow,.8)
sound_play_pitch(sndSuperSplinterGun,.7)
sound_play_pitch(sndSplinterPistol,.6)

with instance_create(x,y,CustomProjectile){
    motion_set(other.gunangle + random_range(-2,2) * other.accuracy, 14)
    projectile_init(other.team, other)
    damage = 35
    sprite_index = global.sprSuperSplinter
    mask_index = mskHeavyBolt
    image_angle = direction
    wall = 0
    on_hit = bolt_hit
    on_end_step = bolt_end_step
    on_wall = bolt_wall
    on_destroy = bolt_destroy
}

#define bolt_destroy
view_shake_max_at(x,y,34)
repeat(12){
    with instance_create(x,y,Splinter){
        team = other.team
        creator = other.creator
        motion_set(other.wall ? other.direction + 180 + random_range(-45,45) : random(360), random_range(14,18))
        image_angle = direction
    }
}

#define bolt_wall
repeat(8) with instance_create(x+random_range(-5,5),y+random_range(-5,5),Dust){
    motion_add(other.direction-180+random_range(-20,20),random_range(1,7))
}

wall = 1
with other {
    instance_create(x,y,FloorExplo)
    instance_destroy()
}
repeat(3){
    with instance_create(x,y,Shell){
        image_index = choose(3,4);
        image_speed = 0;
        sprite_index = sprTutorialSplinter
        motion_add(random(360),random_range(3,6))
    }
}
sound_play_pitch(sndBoltHitWall,.7)
sound_play_pitch(sndExplosionS,random_range(.4,.6))
instance_destroy()


#define bolt_hit
sleep(10)
var o = other, hp = other.my_health;
projectile_hit(o, damage, direction, force)
if hp > damage/2{
    with instance_create(x,y,BoltStick){
        target = o
        sprite_index = other.sprite_index
        image_angle = point_direction(x,y,o.x,o.y)
    }
    instance_destroy()
}
else {
    repeat(irandom_range(3, 5)){
        with instance_create(x,y,Splinter){
            team = other.team
            creator = other.creator
            motion_set(random(360), random_range(14,18))
            image_angle = direction
        }
    }
}


#define bolt_end_step
var hitem = 0
if skill_get(mut_bolt_marrow){
    var q = mod_script_call_nc("mod","defpack tools","instance_nearest_matching_ne",x,y,hitme,"team",team)
    if instance_exists(q) and distance_to_object(q) < 10 {
        x = q.x - hspeed_raw
        y = q.y - vspeed_raw
        hitem = 1
    }
}
with instance_create(x,y,BoltTrail){
    image_xscale = point_distance(x,y,other.xprevious,other.yprevious)
    image_angle = point_direction(x,y,other.xprevious,other.yprevious)
    image_yscale++
}
if hitem with q with other bolt_hit()

#define weapon_fire_old
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
    /*with instance_create(x,y,BoltTrail){
      y += other.vspeed
      x += other.hspeed
      image_angle = point_direction(xprevious,yprevious,x,y)
      image_xscale = point_distance(xprevious,yprevious,x,y)
      image_yscale = 2
    }*/
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
        view_shake_max_at(x,y,30)
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
      with instance_nearest(x+lengthdir_x(1+speed,direction),y+lengthdir_y(1+speed,direction),Wall){repeat(3){with instance_create(other.x,other.y,Shell){image_index = choose(3,4);image_speed = 0;sprite_index = sprTutorialSplinter;motion_add(random(360),random_range(3,6))}};instance_create(x,y,FloorExplo);instance_destroy()}
      instance_destroy()
    }
    wait(1)
  }
  while instance_exists(self)
}

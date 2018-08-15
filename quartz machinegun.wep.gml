#define init
global.sprQuartzMachinegun = sprite_add_weapon("sprites/sprQuartzMachinegun.png",7,6)
global.sprQuartzBullet     = sprite_add("sprites/projectiles/sprQuartzBullet.png",2,8,8)
global.sprShard            = sprite_add("sprites/projectiles/sprShard.png",0,13,4)
global.sprSmallShard       = sprite_add("sprites/projectiles/sprSmallShard.png",0,5,3)

#define weapon_name
return "QUARTZ MACHINEGUN"

#define weapon_sprt
return global.sprQuartzMachinegun;

#define weapon_type
return 1;

#define weapon_cost
return 3;

#define weapon_area
return -1;

#define weapon_load
return 4;

#define weapon_swap
return -4;

#define weapon_auto
return true;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_text
return "QUARTZ CANNON"

#define weapon_fire
weapon_post(6,0,14)
sound_play_pitch(sndHeavyRevoler,1)
sound_play_pitch(sndLaserCrystalHit,random_range(1.7,2.1))
with instance_create(x,y,CustomProjectile)
{
  sprite_index = global.sprShard
  projectile_init(other.team,other)
  move_contact_solid(other.gunangle,16)
  force  = 4
  damage = 5
  image_speed = 1
  motion_add(other.gunangle+random_range(-8,8)*other.accuracy,16)
  image_angle = direction
  ammo = 3
  on_step    = quartzbullet_step
  on_destroy = quartzbullet_destroy
}

#define quartzbullet_step
if image_index = 1 image_speed = 0;

#define quartzbullet_destroy
repeat(3)instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust)
view_shake_at(x,y,3)
sleep(2)
var i = random(360);
repeat(ammo)
{
  with instance_create(x,y,CustomProjectile)
  {
    team = other.team
    creator = other
    sprite_index = global.sprSmallShard
    damage = 5
    motion_add(i + random_range(-50,50),12)
    image_angle = direction
  }
  i += 360/ammo
}

#define init
global.sprboomerang = sprite_add_weapon("sprites/sprBOOMerang.png",3,3);

#define weapon_name
return "BOOMERANG";

#define weapon_type
return 4;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_load
return 1;//???

#define weapon_swap
return sndSwapHammer;

#define weapon_auto
return false;

#define weapon_melee
return true;

#define weapon_laser_sight
return false;

#define weapon_fire
sound_play(sndChickenThrow)
with instance_create(x,y,CustomSlash)
{
  canfix = false
  team = other.team
  creator = other
  sprite_index = global.sprboomerang
  mask_index = sprEnemyBullet1
  image_speed = 0
  damage = 4
  curse = other.curse
  other.wep = 0
  maxspeed = 9 + skill_get(13)*3
  phase = 0
  friction = .4
  lasthit = -4
  motion_add(other.gunangle,12)
  on_projectile = boom_proj
  on_step       = boom_step
  on_wall       = boom_wall
  on_hit         = boom_hit
  with instance_create(x,y,MeleeHitWall){image_angle = other.direction-180}
}

#define boom_proj
if other.team != team with other instance_destroy()

#define boom_step
if instance_exists(creator){if current_frame mod 6 = 0{sound_play_pitchvol(sndAssassinAttack,random_range(.9,1.1),.6*(1-distance_to_object(creator)/200))}}
with Pickup
{
   if place_meeting(x,y,other)
   {
     x = other.x
     y = other.y
   }
}
with chestprop
{
  if self != GiantAmmoChest && self != GiantWeaponChest
  if place_meeting(x,y,other)
  {
    x = other.x
    y = other.y
  }
}
if curse = true{instance_create(x+random_range(-2,2),y+random_range(-2,2),Curse)}
image_angle += 20
if phase = 0 //move regularly
{
  if speed <= friction
  {
    phase = 1
    friction *= -1
  }
}
else//return to player
{
  if instance_exists(creator)
  {
    var _d = point_direction(x,y,creator.x,creator.y)
    if phase = 1 motion_add(_d,8)
    if place_meeting(x,y,creator)
    {
      if creator.wep  = 0{sleep(30);sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.wep = mod_current;instance_destroy();exit}
      if creator.bwep = 0{sleep(30);sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.bwep = mod_current;instance_destroy();exit}
      //zphase = 2//not homing anymore
    }
  }
}
if speed > maxspeed speed = maxspeed

#define boom_wall
phase = 1
lasthit = -4
var _y = false;
if instance_exists(creator){if !collision_line(x,y,creator.x,creator.y,Wall,0,0){_y = true}}else{_y = true}
if _y = false
{
  with instance_create(x,y,ThrownWep)
  {
    sprite_index = other.sprite_index
    wep = mod_current
    curse = other.curse
    motion_add(other.direction-180+random_range(-30,30),other.speed*.3)
    team = other.team
    creator = other.creator
  }
  sound_play(sndExplosionS)
  instance_create(x,y,SmallExplosion)
  instance_destroy()
}

#define boom_hit
if lasthit != other
{
  lasthit = other
  sound_play(sndExplosionS)
  instance_create(x,y,SmallExplosion)
}

#define weapon_sprt
return global.sprboomerang

#define weapon_text
return choose("WATCH OUT FOR THAT 'RANG","BOOM OF RANGE")

#define step
with WepPickup if wep = 0 instance_delete(self)

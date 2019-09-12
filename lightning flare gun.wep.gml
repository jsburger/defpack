#define init
global.sprLightningFlareGun = sprite_add_weapon("sprites/weapons/sprLightningFlareGun.png",2,3)
global.sprLightingGrenade   = sprite_add("sprites/projectiles/sprLightingNade.png", 0, 3, 3)
return "LIGHTNING FLARE GUN"
#define weapon_type
return 4 // cmon burg
#define weapon_cost
return 3
#define weapon_area
return -1
#define weapon_load
return 42
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return false
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt
return global.sprLightningFlareGun
#define weapon_text
return "ELECTRIC BUBBLE"
#define weapon_fire
weapon_post(6,8,0)
var _p = random_range(.8, 1.2);
sound_play_pitch(skill_get(mut_laser_brain) > 0 ? sndLightningShotgunUpg : sndLightningShotgun,1.2 * _p)
sound_play_pitch(skill_get(mut_laser_brain) > 0 ? sndLightningPistolUpg :sndLightningPistol,1.5 * _p)
sound_play_pitch(sndFlare,_p)
with instance_create(x, y, CustomProjectile)
{
  sprite_index = global.sprLightingGrenade
  mask_index   = sprite_index
  team = other.team
  creator = other
  damage = 12
  force  = 7
  motion_add(other.gunangle + random_range(-5, 5), 16)
  image_angle = direction
  friction = .8
  on_step    = lflare_step
  on_destroy = lflare_destroy
}
with instance_create(x + lengthdir_x(16, gunangle),y + lengthdir_y(16, gunangle),LightningSpawn){image_angle = other.gunangle}

#define lflare_step
if irandom(2) = 0
{
  with instance_create(x,y,Lightning)
  {
    image_angle = random(360)
    team = other.team
    creator = other.creator
    ammo = 1 + irandom(1)
    alarm0 = 1
    visible = 0
  }
}
if speed < friction instance_destroy()

#define lflare_destroy
sleep(25)
view_shake_at(x, y, 20)
sound_play_pitchvol(sndLightningCannonEnd, 1.5, .5)
sound_play_pitchvol(sndGammaGutsKill, 1.5, .5)
with instance_create(x, y, CustomObject)
{
  team    = other.team
  creator = other.creator
  timer = 12 + 3 * (skill_get(mut_laser_brain))
  on_step = field_step
}
repeat(12){with instance_create(x, y, Dust){motion_add(random(360), random_range(3, 7))}}
#define field_step
if timer > 0
{
  timer -= current_time_scale
  view_shake_at(x, y, 1.6)
  repeat(2)
  {
    sound_play_pitchvol(sndLightningHit, random_range(.8, 1.2), .6)
    with instance_create(x,y,Lightning)
    {
      image_angle = random(360)
      team = other.team
      creator = other.creator
      ammo = 7 + irandom(1) + 2 * (skill_get(mut_laser_brain))
      alarm0 = 1
      visible = 0
      with instance_create(x,y,LightningSpawn){image_angle = other.image_angle}
    }
  }
}
else instance_delete(self)

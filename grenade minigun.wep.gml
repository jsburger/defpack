#define init
global.sprGrenadeMinigun = sprite_add_weapon("sprites/sprGrenadeMinigun.png",8,3);

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_name
return "GRENADE MINIGUN"
#define weapon_type
return 4
#define weapon_cost
return 1
#define weapon_area
return -1
#define weapon_load
return 12
#define weapon_swap
return sndSwapExplosive
#define weapon_auto
return true
#define weapon_melee
return false
#define weapon_laser_sight
return false
#define weapon_sprt
return global.sprGrenadeMinigun
#define weapon_text
return "BLESSED BY#THE @wGRENADE @sGOD HIMSELF"
#define weapon_chrg
return true
#define weapon_fire
with instance_create(x, y, CustomObject)
{
    btn = other.specfiring ? "spec" : "fire"
    hand = other.specfiring and other.race = "steroids"
    creator = other
    team = other.team
    name = "grenade minigun charge"
    reload = -1
    ammo     = 1
    maxammo  = 25
    ammobase = 3
    charged = 0
    ammotime = ammobase
    index = other.index

    on_step = chargestep
    on_destroy = chargedestroy
}

#define chargestep
if !instance_exists(creator) or !button_check(index, btn){
    instance_destroy()
    exit
}
if reload = -1{
    reload = (hand ? creator.breload : creator.reload) + creator.reloadspeed * current_time_scale
}
else{
    if hand creator.breload = max(reload, creator.breload)
    else creator.reload = max(reload, creator.reload)
}

with creator other.ammotime -= (reloadspeed + ((race = "venuz") * (.2 + .4 * ultra_get("venuz", 1))) + ((1 - my_health/maxhealth) * skill_get(mut_stress))) * current_time_scale
if ammotime <= 0 and (creator.ammo[weapon_type()] >= weapon_cost() or creator.infammo != 0){
    if ammo <= maxammo{
        sound_play_pitchvol(sndNadeReload,ammo/12+1,.8)
        ammo++
        if hand creator.bwkick = 1
        else creator.wkick = 1
        with creator if infammo = 0{
            ammo[weapon_type()] -= weapon_cost()
        }
    }
    else
    {
      if charged = 0
      {
        charged = 1
        sound_play_pitch(sndSnowTankCooldown,8)
        sound_play_pitch(sndNadeReload,1.4)
        sound_play_pitchvol(sndShielderDeflect,4,.5)
        sound_play_pitchvol(sndBigCursedChest,20,.1)
        sound_play_pitchvol(sndCursedChest,12,.2)
        with instance_create(creator.x+lengthdir_x(18,creator.gunangle),creator.y+lengthdir_y(18,creator.gunangle),ChickenB)
        {
            creator = other.creator
            image_xscale = .5
            image_yscale = .5
            with instance_create(x,y,ChickenB)
            {
                creator = other.creator
                image_speed = .75
            };
        };
      }
    }
    ammotime = ammobase

}
if current_frame mod 6 < current_time_scale && charged = 1 creator.gunshine = 1
x = creator.x + lengthdir_x(7, creator.gunangle)
y = creator.y + lengthdir_y(7, creator.gunangle)

#define chargedestroy
with instance_create(x,y,CustomObject)
{
  name = "grenade burst"
  ammo = other.ammo
  creator = other.creator
  timer = 0
  maxtimer = 2
  accuracy = creator.accuracy
  on_step = burststep
}

#define burststep
if !instance_exists(creator){instance_destroy();exit}
x = creator.x + lengthdir_x(10, creator.gunangle)
y = creator.y + lengthdir_y(10, creator.gunangle)

timer -= current_time_scale
if timer <= 0
{
  with creator
  {
    weapon_post(5,-7,3)
  }
  var _p = random_range(.8,1.2)
  sound_play_pitch(sndGrenadeRifle,.8*_p)
  sound_play_pitch(sndGrenadeShotgun,.7*_p + ammo/15)
  repeat(3) with instance_create(x,y,MiniNade)
  {
    motion_add (other.creator.gunangle+random_range(-32,32)*other.accuracy,choose(12,16,18))
    image_angle = direction
  }
  ammo--
  timer = maxtimer
}
if ammo <= 0 or !instance_exists(creator)instance_destroy()

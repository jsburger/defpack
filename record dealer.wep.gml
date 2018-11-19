#define init
global.sprRecordDealer    = sprite_add_weapon("sprites/sprRecordDealer.png",6,4)
global.sprVinyl           = sprite_add("sprites/projectiles/sprVinyl.png",2,7,7)
global.sprGoldVinyl       = sprite_add("sprites/projectiles/sprGoldVinyl.png",2,7,7)
global.sprStickyVinyl     = sprite_add("sprites/projectiles/sprStickyVinyl.png",2,7,7)
global.sprBouncerVinyl    = sprite_add("sprites/projectiles/sprBouncerVinyl.png",2,7,7)
global.sprMegaVinyl       = sprite_add("sprites/projectiles/sprMegaVinyl.png",2,12,12)
global.sprNTVinyl         = sprite_add("sprites/projectiles/sprNTVinyl.png",2,12,12)
#define weapon_name
return "RECORD DEALER";

#define weapon_type
return 3;

#define weapon_cost
return 2;

#define weapon_area
return 13;

#define weapon_load
return 32;

#define weapon_swap
return sndSwapBow;

#define weapon_auto
return false;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_fire
var _disc = choose("normal","golden","sticky","bouncer","mega");
repeat(4)
{
  sound_play_slowdown(sndSuperDiscGun,.8)
  weapon_post(6,-50,5)
  switch _disc
  {
    case "normal":
    with instance_create(x,y,Disc)
    {
      sprite_index = global.sprVinyl
      creator = other
      team = other.team
      move_contact_solid(other.gunangle,sprite_get_width(sprite_index))
      hitid = [sprite_index,"VINYL"]
      motion_add(other.gunangle + random_range(-6,6),5)
      image_angle = direction
    }
    break;
    case "golden":
    with instance_create(x,y,Disc)
    {
      sprite_index = global.sprGoldVinyl
      creator = other
      team = other.team
      hitid = [sprite_index,"GOLDEN VINYL"]
      move_contact_solid(other.gunangle,sprite_get_width(sprite_index))
      motion_add(other.gunangle + random_range(-6,6),8)
      image_angle = direction
    }
    break;
    case "sticky":
    with mod_script_call("mod","defpack tools","create_stickydisc",x,y)
    {
      sprite_index = global.sprStickyVinyl
      creator = other
      team = other.team
      hitid = [sprite_index,"STICKY VINYL"]
      move_contact_solid(other.gunangle,sprite_get_width(sprite_index))
      motion_add(other.gunangle + random_range(-6,6),4)
      image_angle = direction
      orspeed = speed
    }
    break;
    case "bouncer":
    with mod_script_call("mod","defpack tools","create_bouncerdisc",x,y)
    {
      sprite_index = global.sprBouncerVinyl
      team = other.team
      creator = other
      hitid = [sprite_index,"BOUNCER VINYL"]
      move_contact_solid(other.gunangle,sprite_get_width(sprite_index))
      motion_add(other.gunangle + random_range(-6,6),4)
      image_angle = direction
    }
    break;
    case "mega":
    with mod_script_call("mod","defpack tools","create_megadisc",x+lengthdir_x(12,gunangle),y+lengthdir_y(12,gunangle))
    {
      team = other.team
      sprite_index = global.sprMegaVinyl
      if irandom(99) = 0 sprite_index = global.sprNTVinyl
      creator = other
      if sprite_index = global.sprMegaVinyl hitid = [sprite_index,"MEGA VINYL"] else hitid = [sprite_index,"THE NUCLEAR THRONE#SOUNDTRACK"]
      move_contact_solid(other.gunangle,14)
      motion_add(other.gunangle + random_range(-6,6),4)
      image_angle = direction
      maxspeed = speed
    }
    break;
  }
  wait(3)
  if !instance_exists(self) exit
}
#define weapon_sprt
return global.sprRecordDealer;

#define weapon_text
return "A FUNKY MIX";

#define sound_play_slowdown(_snd,_vol)
with instance_create(x,y,CustomObject)
{
  pitch = 1.2
  decel = random_range(.05,.07)
  p = random_range(.8,1.2)
  lifetime = pitch/decel + 1
  vol = _vol
  snd = _snd
  on_step = sound_step
  persistent = 1
}

#define sound_step
pitch -= decel
sound_play_pitchvol(snd,pitch*p,vol)
lifetime -= 1
if lifetime <= 0 instance_destroy() //should need time scale adjustments since sound speed is independent of it

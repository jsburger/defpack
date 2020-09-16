#define init
global.sprRecordDealer    = sprite_add_weapon("sprites/weapons/sprRecordDealer.png",6,4)
global.sprRecordDealerHUD = sprite_add_weapon("sprites/weapons/sprRecordDealer.png",10,3)
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
return 12;

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

#define weapon_sprt
return global.sprRecordDealer;

#define weapon_sprt_hud
return global.sprRecordDealerHUD;

#define weapon_text
return "WRITE A LOVE SONG";

#define weapon_fire
var _disc = choose("normal","golden","sticky","bouncer","mega");
repeat(4)
{
  sound_play_slowdown(sndSuperDiscGun,.8)
  weapon_post(6,-50,5)
  var angle = gunangle + random_range(-6,6)*accuracy
  with get_disc(_disc){
      direction = angle
      projectile_init(other.team, other)
      move_contact_solid(other.gunangle, min(sprite_width, 14))
      image_angle = direction
  }
  wait(3)
  if !instance_exists(self) exit
}

#define get_disc(disc)
switch disc{
    case "normal":
        with instance_create(x, y, Disc){
            sprite_index = global.sprVinyl
            hitid = [sprite_index, "VINYL"]
            speed = 5
            return id
        }
    case "golden":
        with instance_create(x, y, Disc){
            sprite_index = global.sprGoldVinyl
            hitid = [sprite_index, "GOLDEN VINYL"]
            speed = 8
            return id
        }
    case "sticky":
        with mod_script_call_nc("mod", "defpack tools", "create_stickydisc", x, y){
            sprite_index = global.sprStickyVinyl
            hitid = [sprite_index, "STICKY VINYL"]
            speed = 4
            orspeed = speed
            return id
        }
    case "bouncer":
        with mod_script_call_self("mod", "defpack tools", "create_bouncerdisc", x, y){
            sprite_index = global.sprBouncerVinyl
            hitid = [sprite_index, "BOUNCER VINYL"]
            speed = 4
            return id
        }
    case "mega":
        with mod_script_call_nc("mod", "defpack tools", "create_megadisc", x, y){
            sprite_index = (irandom(99) == 0) ? global.sprNTVinyl : global.sprMegaVinyl
            hitid[0] = sprite_index
            hitid[1] = sprite_index = global.sprMegaVinyl ? "MEGA VINYL" : "THE NUCLEAR THRONE#SOUNDTRACK"
            speed = 4
            maxspeed = speed
            return id
        }
}

#define sound_play_slowdown(_snd,_vol)
with instance_create(x,y,CustomObject){
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
if frac(current_frame) < current_time_scale{
    pitch -= decel
    sound_play_pitchvol(snd,pitch*p,vol)
    lifetime -= 1
    if lifetime <= 0 instance_destroy()
}

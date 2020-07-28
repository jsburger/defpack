#define init
  global.sprHexNeedle      = sprite_add_weapon("sprites/weapons/sprHexNeedle.png",       4, 6);
  global.sprHexNeedleHUD   = sprite_add_weapon("sprites/weapons/sprHexNeedle.png",       0, 5);
  global.sprHexNeedleWall  = sprite_add_weapon("sprites/weapons/sprHexNeedle.png",      14, 5);
  global.sprHexNeedleStick = sprite_add_weapon("sprites/weapons/sprHexNeedle.png",      24, 5);
  global.mskHexNeedle      = sprite_add_weapon("sprites/projectiles/mskHexNeedle.png",  20, 6);
  global.sprHexNeedleShank = sprite_add("sprites/projectiles/sprHexNeedleShank.png", 5, -6, 4);

#macro  current_frame_active (current_frame % 1) < current_time_scale

#define weapon_chrg
  return true;

#define weapon_name
  return "HEX NEEDLE";

#define weapon_type
  return 0;

#define weapon_cost
  return 0;

#define weapon_area
  return -1;

#define weapon_load
  return 18;

#define weapon_swap
  return sndSwapSword;

#define weapon_auto
  return true;

#define weapon_melee
  return false;

#define weapon_laser_sight
  return false;

#define weapon_sprt
  return global.sprHexNeedle;

#define weapon_sprt_hud
  return global.sprHexNeedleHUD;

#define weapon_text
  return "ANGRY SPIRITS";

#define weapon_fire
  with instance_create(x, y, CustomObject)
  {
      btn = other.specfiring ? "spec" : "fire"
      hand = other.specfiring and other.race = "steroids"
      creator = other
      team = other.team
      name = "hex needle charge"
      reload = -1
      charged = 0
      index = other.index
      curse  = other.curse;
      bcurse = other.bcurse;

      ammobase = 1;
      ammotime = ammobase;
      maxammo  = 20;
      ammo     = 0;

      defcharge = {
          style : 1,
          maxcharge : maxammo,
          charge : ammo,
          power : 1
      }

      on_step    = charge_step;
      on_destroy = charge_destroy;
  }

#define charge_step
  if (creator.wep != creator.bwep and button_check(index, "swap")){
    instance_delete(self);
    exit;
  }
  if !instance_exists(creator) or !button_check(index, btn){
      instance_destroy();
      exit;
  }

  with creator{
    weapon_post(other.ammo / 3, other.ammo / 3, 0);
  }

  var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
  if reload = -1{
      reload = hand ? creator.breload : creator.reload
      reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale
  }
  else{
      if hand creator.breload = max(creator.breload, reload)
      else creator.reload = max(reload, creator.reload)
  }

  ammotime -= mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale
  if ammotime <= 0{
      if ammo < maxammo{
          sound_play_pitch(sndOasisMelee, 1 / (1 - ((ammo / maxammo) * 0.25)));
          sound_play_pitch(sndCursedReminder, .6 / (1 - ((ammo / maxammo) * 0.25)));
          ammo++
          defcharge.charge++
          with creator if infammo = 0{
              ammo[weapon_type()] -= weapon_cost()
          }
      }
      else{
          if charged = 0{
              charged = 1
              mod_script_call_self("mod","defpack tools", "weapon_charged", creator, 18)
          }
      }
      ammotime = ammobase
  }
  if current_frame mod 12 < current_time_scale && charged = 1{
      creator.gunshine = 1
      with defcharge blinked = 1
  }
  x = creator.x + lengthdir_x(1, creator.gunangle)
  y = creator.y + lengthdir_y(1, creator.gunangle)

#define charge_destroy
  if !instance_exists(creator) exit;
  var _offset = 12 + skill_get(mut_long_arms) * 8;
  if charged = true{ // Throw Weapon:
    if hand = 0{
      creator.wep   = 0;
      creator.curse = 0;
    }else{
      creator.bwep   = 0;
      creator.bcurse = 0;
    }
    var _p = random_range(.8, 1.2);
    sound_play_pitchvol(sndAssassinAttack, 1.3 * _p, 1.6);
    sound_play_pitchvol(sndCursedPickup,   1.5 * _p, 1);
    with instance_create(x+lengthdir_x(_offset, creator.gunangle), y+lengthdir_y(_offset, creator.gunangle), CustomSlash){
        sprite_index = global.sprHexNeedleHUD;
        mask_index   = mskBullet1;
        image_speed  = 0;
        image_alpha  = 1;

        visible    = true;
        team       = other.team;
        creator    = other.creator;
        damage     = 16;
        force      = 10;
        can_fix    = false;
        curse = other.hand ? other.bcurse: other.curse;
        with instance_create(x, y, Wind){
          sprite_index = global.sprHexNeedleShank;
          image_angle = other.creator.gunangle;
          image_speed = .5;
        }

      direction = creator.gunangle + random_range(-8, 8) * creator.accuracy;
      speed = 24;
      image_angle = direction;

      on_hit        = needle_hit;
      on_step       = needle_step;
      on_wall       = needle_wall;
      on_end_step   = needle_end_step;
      on_destroy    = needle_destroy;
      on_grenade    = needle_projectile;
      on_projectile = needle_projectile;
    }
  }
  else{ // Stabby:
    var _p = random_range(.8, 1.2);
    sound_play_pitchvol(sndScrewdriver, 1.5 * _p, .8);
    sound_play_pitchvol(sndCursedReminder, 2 * _p, .3);
    sound_play_pitchvol(sndBlackSword, 2 * _p, .8);

    with creator{
      weapon_post(-_offset, _offset * 3 / 5, 0);
    }
    sleep(5);
    with instance_create(x+lengthdir_x(_offset, creator.gunangle), y+lengthdir_y(_offset, creator.gunangle), CustomSlash){
        sprite_index = global.mskHexNeedle;
        mask_index   = global.mskHexNeedle;
        image_speed  = 1;
        image_alpha  = 0;

        team       = other.team;
        creator    = other.creator;
        damage     = 4;
        force      = 4;
        can_fix    = false;
        canreflect = false;
        with instance_create(x, y, Wind){
          sprite_index = global.sprHexNeedleShank;
          image_angle = other.creator.gunangle;
          image_speed = .5;
        }

      direction = creator.gunangle + random_range(-8, 8) * creator.accuracy;
      speed = .0001;
      image_angle = direction;

      on_hit        = needle_hit;
      on_grenade    = needle_projectile;
      on_projectile = needle_projectile;
    }
  }

#define needle_hit
  if projectile_canhit_melee(other) = true && speed > 0{
    var _origin = self;
    projectile_hit(other, damage, force, direction);
    with instances_matching(hitme, "object_index", other.object_index){
      if distance_to_object(_origin) <= 164{
        with instance_create(x, y, CustomObject){
          target = other;
          timer  = 20 + irandom(point_distance(other.x, other.y, _origin.x, _origin.y)) / 2;
          damage = _origin.damage + 4;
          force  = 6;
          direction = _origin.direction;

          on_step = hex_step;
        }
      }
    }
    if other.my_health > 0 && "curse" in self{
      view_shake_max_at(x, y, 10);
      sleep(10);
      speed = 0;
      mans = other;
      with instance_create(x, y, WepPickup){
          wep   = "hex needle";
          curse = other.curse;
          sprite_index = mskNone;
          other.child = self;
      }
    }
    if "curse" not in self{
      instance_delete(self);
    }
  }

#define needle_step
  if("curse" in self && curse){
    if(visible && current_frame_active){
      instance_create(x + random_range(-4, 4), y + random_range(-4, 4), Curse);
    }
  }
  if "mans" not in self with(instances_matching_ne(instances_matching(projectile, "typ", 1, 2), "team", team)){
    if(object_index != PopoNade && distance_to_object(other) <= 8){
      sleep(2);
      instance_destroy();
    }
  }

 if(!place_free(x, y)){
   xprevious = x;
   yprevious = y;
   if(visible){
     visible = false;
     sound_play_pitch(sndCursedReminder, 1 + random_range(-.3, .3));
     repeat(4) with(instance_create(x + random_range(-8, 8), y + random_range(-8, 8), Smoke)){
       motion_add(other.direction + 180, random(1));
     }
   }
 }
 else if(place_meeting(x, y, Floor)){
   if(!visible){
     visible = true;
     sound_play_pitch(sndSwapCursed, 1 + random_range(-.3, .3));
     repeat(4) with(instance_create(x + random_range(-8, 8), y + random_range(-8, 8), Smoke)){
       motion_add(other.direction + 180, random(1));
     }
   }
 }
 if speed = 0{
   if "child" not in self{
     var _a = direction;
     with instance_create(x, y, WepPickup){
         wep   = "hex needle";
         curse = other.curse;
         sprite_index = mskNone;
         image_angle = _a;
         rotspeed = 0;
         other.child = self;
     }
   }
   if ("mans" in self and instance_exists(mans) and "child" in self and instance_exists(child)){
     sprite_index = global.sprHexNeedleStick;
     direction = point_direction(x, y, mans.x, mans.y);
     x = mans.x + mans.hspeed_raw;
     y = mans.y + mans.vspeed_raw;
     child.x = x - lengthdir_x(24, image_angle);
     child.y = y - lengthdir_y(24, image_angle);
     xprevious = x;
     yprevious = y;
   }
   if ("mans" in self and !instance_exists(mans)) instance_destroy();
   if ("child" in self and !instance_exists(child)){
     sleep(10);
     view_shake_max_at(x, y, 6);
     if "mans" in self projectile_hit(mans, 4, 0, 0);
     instance_delete(self);
   }
 }

#define needle_wall
  if(speed > 0){
    speed = 0;
    mask_index = mskFlakBullet;
    sprite_index = global.sprHexNeedleWall;
    move_contact_solid(direction, -6);
    repeat(1 + choose(0, 1, 1)) instance_create(x, y, Debris);
    sound_play_pitchvol(sndExplosionS, 1.5, 0.7);
    sound_play_pitchvol(sndBoltHitWall,  1, 0.7);
  }

#define needle_end_step
  if(visible){
    var	_x1 = x,
      _y1 = y,
      _x2 = xprevious,
      _y2 = yprevious;

    with(instance_create(_x1, _y1, BoltTrail)){
      image_xscale = point_distance(_x1, _y1, _x2, _y2);
      image_angle = point_direction(_x1, _y1, _x2, _y2);
      //if(other.curse) image_blend = make_color_rgb(235, 0, 67);
      creator = other.creator;
    }
  }

#define needle_destroy
  if "target" not in self target = self;
  with instance_create((x + target.x) / 2, (y + target.y) / 2, WepPickup){
    wep   = "hex needle";
    curse = other.curse;
    image_angle = other.image_angle;
    direction   = image_angle;
  }

#define needle_projectile
  if "mans" not in self with other{
    instance_destroy();
  }

#define hex_step
  if !instance_exists(target) || target.team = 0 || instance_is(target, LilHunterFly) || instance_is(target, RavenFly) || instance_is(target, BigMaggotBurrow){
    instance_delete(self);
    exit;
  }
  if timer > 0{
    timer -= 2 * current_time_scale;
    if irandom(1 / current_time_scale) = 0{
      instance_create(target.x + random_range(-2, 2), target.y - sprite_get_height(target.sprite_index) / 2  + random_range(-2, 2), Curse)
    }
  }
  else{
    view_shake_max_at(x, y, 8);
    sleep(12);
    sound_play_pitchvol(sndCursedReminder, random_range(1.6, 2.4), .8);
    sound_play_pitchvol(sndCursedPickup, random_range(.6, .8), .8);
    sound_play_pitchvol(sndBigCursedChest, .2 * random_range(.8, 1.2), .6);
    sound_play(target.snd_hurt)
    projectile_hit(target, damage, 0, direction + random_range(-8, 8));
    speed = force
    repeat(target.size + 1 + irandom(2)){
      with instance_create(target.x, target.y, Smoke){
        motion_add(random(360), random(2) + 1)
      }
    }
    instance_destroy();
  }

#define correct_step
  if !instance_exists(target){
    instance_delete(self);
    exit;
  }
  else{
    other.image_angle = direction;
    other.direction = other.image_angle;
  }

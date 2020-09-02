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
  return false;

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
  var _offset = 12 + skill_get(mut_long_arms) * 8;
  var _p = random_range(.8, 1.2);

  sound_play_pitchvol(sndScrewdriver, 1.2 * _p, .8);
  sound_play_pitchvol(sndCursedReminder, 2 * _p, .3);
  sound_play_pitchvol(sndBlackSword, 2 * _p, .8);
  sound_play_pitchvol(sndAssassinAttack, 1.7 * _p, 1.5);
  sound_play_pitchvol(sndCursedPickup,   1.5 * _p, 1);


  weapon_post(-_offset, _offset * 3 / 5, 0);
  sleep(5);

  with instance_create(x+lengthdir_x(_offset, gunangle), y+lengthdir_y(_offset, gunangle), CustomSlash){
      sprite_index = global.mskHexNeedle;
      mask_index   = global.mskHexNeedle;
      image_speed  = 1;
      image_alpha  = 0;

      team       = other.team;
      creator    = other;
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

#define needle_hit
  if projectile_canhit_melee(other) = true && speed > 0{
    var _origin = self;
    projectile_hit(other, damage, force, direction);
    with instances_matching(hitme, "team", other.team){
      if distance_to_object(_origin) <= 128{
        with instance_create(x, y, CustomObject){
          target = other;
          timer  = 15 + irandom(point_distance(other.x, other.y, _origin.x, _origin.y)) / 2;
          damage = _origin.damage + 4;
          force  = 6;
          direction = point_direction(_origin.x, _origin.y, x, y);

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

#define hex_step
  if !instance_exists(target) || target.team = 0 || instance_is(target, LilHunterFly) || instance_is(target, RavenFly) || instance_is(target, BigMaggotBurrow){
    instance_delete(self);
    exit;
  }
  if timer > 0{
    timer -= 2 * current_time_scale;
    if irandom(1 / current_time_scale) = 0{
      var _w = sprite_get_width(target.sprite_index) / 2 * .6,
          _h = sprite_get_height(target.sprite_index) * .3;
      with instance_create(target.x + random_range(-_w, _w), target.y - sprite_get_height(target.sprite_index) / 2  + random_range(0, _h), Curse){motion_add(90, 1);friction = .05}
      with instance_create(target.x, target.y, Wind){
        target = other.target
        sprite_index = target.sprite_index
        image_index  = target.image_index
        image_speed  = 0
        image_alpha = 2 / other.timer
        image_blend = c_purple;
        if fork(){
          wait(1)
          instance_delete(self)
        }
      }
    }
  }
  else{
    view_shake_max_at(x, y, 12);
    sleep(30);
    sound_play_pitchvol(sndCursedReminder, random_range(1.6, 2.4), .8);
    sound_play_pitchvol(sndCursedPickup, random_range(.6, .8), .8);
    sound_play_pitchvol(sndBigCursedChest, .2 * random_range(.8, 1.2), .6);
    sound_play_pitchvol(sndSwapCursed, 1.4 * random_range(.8, 1.2), .8);
    sound_play_pitchvol(sndStatueHurt, 1.2 * random_range(.8, 1.2), .8);
    sound_play(target.snd_hurt)
    projectile_hit(target, damage, 0, direction + random_range(-8, 8));
    speed = force
    repeat(target.size + 1 + irandom(2)){
      with instance_create(target.x, target.y, Smoke){
        motion_add(random(360), random(2) + 3)
      }
    }
    instance_destroy();
  }

#define needle_projectile
  with other instance_destroy();

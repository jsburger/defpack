#define init
  global.sprboomerang     = sprite_add_weapon("sprites/weapons/sprKaboomerang.png",  3, 12);
  global.sprboomerangHUD  = sprite_add_weapon("sprites/weapons/sprKaboomerang.png", -1,  4);
  global.sprboomerangProj = sprite_add("sprites/projectiles/sprKaboomerangProj.png", 4, 11, 11);
  global.sprBounce = sprImpactWrists//sprite_add("sprites/projectiles/sprKaboomerangBounce.png", 3, 12, 11);

#define weapon_name
  return "KABOOMERANG";

#define weapon_type
  return 4;

#define weapon_sprt_hud
  return global.sprboomerangHUD;

#define weapon_cost
  return 1;

#define weapon_area
  return 4;

#define weapon_load
  return 6;//!!!

#define weapon_swap
  return sndSwapHammer;

#define weapon_auto
  return true;

#define weapon_melee
  return true;

#define weapon_laser_sight
  return false;

#define weapon_fire
  sound_play(sndChickenThrow);
  with instance_create(x,y,CustomObject)
  {
    team = other.team
    creator = other
    sprite_index = global.sprboomerangProj
    mask_index   = sprBullet1
    image_speed = .5
    curse = other.curse
    other.curse = 0
    other.wep = 0
    maxspeed = 18 + skill_get(13)*4
    phase = 0
    ang = 0
    whooshtime = 0
    maxwhoosh = 3
    length = 6
    friction = 1.4
    lasthit = -4
    motion_add(other.gunangle, maxspeed)
    on_end_step = boom_step
    on_draw = boom_draw
    with instance_create(x,y,MeleeHitWall){image_angle = other.direction-180}
  }

#define boom_step

  var _w = sprite_get_width(sprite_index)/2 - 2,
      _o = other.speed * 2;
  repeat(2){
      with instance_create(x - lengthdir_x(_o, direction) + lengthdir_x(_w, direction + 90), y - lengthdir_y(_o, direction) + lengthdir_y(_w, direction + 90), BoltTrail){
       image_xscale = _o * .85;
       image_yscale = (.7 + other.speed / 30) * .7;
       image_angle  = other.direction;
      }
      _w *= -1;
  }

  if instance_exists(creator)
  {
      whooshtime = (whooshtime + current_time_scale) mod (maxwhoosh + phase)
      if whooshtime < current_time_scale audio_play_ext(sndMeleeFlip, x, y, 2.4 - length/6 + random_range(-.1, .1) - phase * .4, length/6, 0);
  }
  with Pickup
  {
    if distance_to_object(other) <= 4 && ("rang" not in self || ("rang" in self && rang != other.id)){rang = other.id}
    if "rang" in self{if instance_exists(rang){x = rang.x;y = rang.y}}
  }
  with instances_matching([AmmoChest, RadChest, WeaponChest, RogueChest, GoldChest, chestprop], "", null)
  {
    if distance_to_object(other) <= 4 && ("rang" not in self || ("rang" in self && rang != other.id)){rang = other.id}
    if "rang" in self and instance_exists(rang){
        x = rang.x
        y = rang.y
    }
  }
  with instances_matching_ne(hitme,"team",team)
  {
    if distance_to_object(other) <= 5
    {
      if projectile_canhit(other) = true
      {
        with other
        {
          if lasthit != other
          {
            lasthit = other;
            sound_play(sndExplosionS);
            var meetx = (x + other.x)/2 + random_range(-3, 3) * other.size;
            var meety = (y + other.y)/2 + random_range(-3, 3) * other.size;
            instance_create(meetx,meety,SmallExplosion);
            projectile_hit(other, 3, speed / 4, direction)
            sleep(9 * other.size);
            view_shake_at(x, y, 6 * other.size);
          }
        }
      }
    }
  }
  with instances_matching_ne(projectile,"team",other.team)
  {
    if distance_to_object(other) <= 4
    {
      with other if other.team != team with other instance_destroy()
    }
  }
  if curse = true and current_frame < floor(current_frame) + current_time_scale {instance_create(x+random_range(-2,2),y+random_range(-2,2),Curse)}
  if phase = 0 //move regularly
  {
    if speed <= friction
    {
      lasthit = -4
      phase = 1
      friction *= -1
      maxspeed += 6
      with instance_create(x, y, ChickenB) image_speed *= 2;
      with instance_create(x, y, DiscBounce){sprite_index = global.sprBounce; image_index = 1; image_speed = 1}
    }
    ang += 21*current_time_scale
  }
  else//return to player
  {
    if instance_exists(creator)
    {
      var _d = point_direction(x,y,creator.x,creator.y)
      if phase = 1 {
        if irandom(3) <= current_time_scale{repeat(1 + irandom(2)) with instance_create(x + random_range(-4, 4), y + random_range(-4, 4), Dust){motion_add(other.direction, random_range(2, 4))}}
        motion_add(_d,8*current_time_scale)
      }
      var _r = weapon_get_load(mod_current)
      if distance_to_object(creator) <= 9+skill_get(17)*3
      {
        if creator.wep  = 0{creator.reload += _r;sleep(30);creator.curse = curse;sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.wep = mod_current;instance_destroy();exit}
        if creator.bwep = 0{creator.breload += _r;sleep(30);creator.bcurse = curse;sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.bwep = mod_current;instance_destroy();exit}
        //zphase = 2//not homing anymore
      }
      if creator.mask_index = 268 && place_meeting(x,y,Portal)
      {
        if creator.wep  = 0{creator.reload += _r;sleep(30);creator.curse = curse;sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.wep = mod_current;instance_destroy();exit}
        if creator.bwep = 0{creator.breload += _r;sleep(30);creator.bcurse = curse;sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.bwep = mod_current;instance_destroy();exit}
        //zphase = 2//not homing anymore
      }
      if creator.wep != 0 && creator.bwep != 0
      {
        repeat(20) instance_create(x + random_range(-6, 6), y + random_range(-6, 6), Smoke)
        with instance_create(x,y,ThrownWep)
        {
          sprite_index = global.sprboomerang
          wep = mod_current
          curse = other.curse
          motion_add(other.direction+random_range(-8,8), other.speed * .7)
          team = other.team
          creator = other.creator
        }
        instance_destroy()
        exit
      }
    }
  }
  if place_meeting(x, y, Wall) && phase != 1
  {
    speed *= -.6;
    phase = 1
    instance_create(x, y, SmallExplosion)
    sound_play(sndExplosionS)
    maxspeed += 6
    with instance_create(x, y, ChickenB) image_speed *= 2;
  }
  if speed > maxspeed speed = maxspeed

#define weapon_sprt
  return global.sprboomerang

#define nts_weapon_examine
return{
    "d": "It always returns to its wielder. # Use at a safe distance. ",
}

#define weapon_text
  return choose("WATCH OUT FOR THAT 'RANG","BOOM OF RANGE")

#define boom_draw
  draw_sprite_ext(sprite_index,image_index,x,y, image_xscale, image_yscale, ang, image_blend, image_alpha);

#define audio_play_ext(snd, x, y, pitch, vol, stack) mod_script_call("mod", "defpack tools", "audio_play_ext", snd, x, y, pitch, vol, stack)

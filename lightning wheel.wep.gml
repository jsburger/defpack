#define init
  global.sprLightningWheel     = sprite_add_weapon("sprites/weapons/sprLightningWheel.png",9,8);
  global.sprLightningWheelHUD  = sprite_add_weapon("sprites/weapons/sprLightningWheel.png",3,5);
  global.sprLightningWheelProj = sprite_add("sprites/projectiles/sprLightningWheelProj.png", 4, 17, 17);
  global.sprBounce = sprite_add("sprites/projectiles/sprKaboomerangBounce.png", 3, 12, 12);

#define weapon_name
  return "LIGHTNING WHEEL";

#define weapon_sprt_hud
  return global.sprLightningWheelHUD;

#define weapon_type
  return 5;

#define weapon_chrg
  return 1;

#define weapon_cost
  return 2;

#define weapon_area
  return 7;

#define weapon_load
  return 16;//???

#define weapon_swap
  return sndSwapHammer;

#define weapon_auto
  return false;

#define weapon_melee
  return true;

#define weapon_laser_sight
  return false;

#define weapon_fire
  var _pitch = random_range(.8, 1.2)
  sound_play(sndChickenThrow);
  sound_play_pitch(skill_get(mut_laser_brain) > 0 ? sndEnergyHammerUpg : sndEnergyHammer, 1.25 * _pitch)
  sound_play_pitch(skill_get(mut_laser_brain) > 0 ? sndEnergyScrewdriverUpg : sndEnergyScrewdriver, 1.6 * _pitch)
  sound_play_pitch(sndLightningReload, .7 * _pitch)
  with instance_create(x,y,CustomObject)
  {
    defbloom = {
          xscale : 1.33,
          yscale : 1.33,
          alpha : .1 + skill_get(mut_laser_brain) * .025
      }
    name = "Lightning Wheel"
    btn = other.specfiring ? "spec" : "fire";
    timer = 7
    team = other.team
    creator = other
    sprite_index = global.sprLightningWheelProj
    mask_index   = sprBullet1
    image_speed = .49
    curse = other.curse
    other.curse = 0
    other.wep = 0
    maxspeed = 20 + skill_get(13)*4
    phase = 0
    ang = 0
    damage = 6
    whooshtime = 0
    maxwhoosh = 3
    length = 6
    friction = 1.4

    potential = .2;
    motion_add(other.gunangle, maxspeed)
    on_end_step = boom_step
    //on_draw = boom_draw
    with instance_create(x,y,LightningHit){image_angle = other.direction}
    if place_meeting(x + hspeed, y + vspeed, Wall){speed = 16; move_bounce_solid(false)}
  }

#define boom_step

  if image_index >= 3.5{image_angle = random(360)}
  var _w = 10,
      _o = other.speed * 2;
  repeat(2){
      with instance_create(x - lengthdir_x(_o, direction) + lengthdir_x(_w, direction + 90), y - lengthdir_y(_o, direction) + lengthdir_y(_w, direction + 90), BoltTrail){
       image_xscale = _o * .85;
       image_yscale = (.7 + other.speed / 30) * .7 + .2;
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
    if distance_to_object(other) <= 12
    {
      if projectile_canhit(other) = true
      {
        with other
        {
          if current_frame mod 3 < current_time_scale{
            sound_play_pitchvol(skill_get(mut_laser_brain) > 0 ? sndLightningPistolUpg : sndLightningPistol, random_range(1.3, 1.5), .7);
            sound_play_pitchvol(sndLightningHammer, random_range(1.8, 2), .7);

            var meetx = (x + other.x)/2 + random_range(-3, 3) * other.size;
            var meety = (y + other.y)/2 + random_range(-3, 3) * other.size;
            with instance_create(x ,y, LightningHit) image_angle = other.image_angle

            if !instance_is(other, prop){
              x -= lengthdir_x(2 * other.size, direction)
              y -= lengthdir_y(2 * other.size, direction)
            }
            projectile_hit(other, damage, speed, direction)

            sleep(3 + 14 * clamp(1 + other.size / 3, 1, 4));
            view_shake_max_at(x, y, 2 + 6 * clamp(other.size, 1, 4));
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
    var _b = false;
    if place_meeting(x + hspeed, y, Wall){_b = true; hspeed *= -1}
    if place_meeting(x, y + vspeed, Wall){_b = true; vspeed *= -1}
    if place_meeting(x + hspeed, y + vspeed, Wall){_b = true; hspeed *= -1; vspeed = 1}

    if _b
    {
      with instance_create(x, y, DiscBounce){sprite_index = global.sprBounce}
      speed *= (1 + potential);
      potential *= .5
      with instance_create(x ,y, LightningHit) image_angle = other.image_angle
      sound_play_pitchvol(sndLightningReload, random_range(.6, .8), .6)
      sound_play_pitchvol(sndLightningPistol, random_range(1.4, 1.6), 1)
      sound_play_pitchvol(sndGammaGutsKill,8*random_range(.8, 1.2), .6)
    }

    if speed <= friction
    {
      if current_frame mod 2 < current_time_scale{

      }
      if current_frame mod 5 < current_time_scale{
        var _dir = random(360),
            _dis = 12 + irandom(4);
        with instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), LightningSpawn) image_angle = _dir
      }

      if button_check(creator.index, btn) and creator.mask_index != mskNone{
          speed = 0
          if timer > 0 timer -= current_time_scale
          else{
              timer = 7
                  if collision_line(creator.x,creator.y,x,y,Wall,0,0) <= -4{
                    if (creator.ammo[5] > 0 || creator.infammo > 0){
                        if creator.infammo <= 0 creator.ammo[5]--
                        sound_play_pitchvol(sndGammaGutsKill,5*random_range(.6, 1.2), .6)
                        repeat(2 + irandom(1) + round(skill_get(mut_laser_brain))) with instance_create(x,y,Lightning){
                            image_angle = random(360)
                            direction = image_angle
                            team = other.team
                            creator = other.creator
                            ammo = 4 + irandom(2) + 2*skill_get(mut_laser_brain)
                            alarm0 = 1
                            visible = 0
                        }

                        var angl = point_direction(creator.x, creator.y, x, y)
                        if fork(){
                            repeat(irandom_range(1,4)){
                                if !instance_exists(self) || !instance_exists(creator) exit
                                with mod_script_call_self("mod", "defparticles", "create_spark", creator.x+random_range(-4,4), creator.y+random_range(-4,4)){
                                    color = c_blue
                                    fadecolor = c_aqua
                                    gravity = 0
                                    var n = irandom_range(5,9)
                                    fadespeed = .2 + random(.4)
                                    age = n
                                    motion_set(angl, point_distance(x,y,other.x,other.y)/n)
                                }
                                wait(1)
                            }
                            exit
                        }
                    }
                    else{
                      phase = 1
                      sound_play(sndEmpty)
                      sleep(20)
                      with instance_create(x, y, PopupText){
                        mytext = "EMPTY";
                        target = other.creator.index;
                      }
                    }
                  }
          }
      }else{
        phase = 1
        friction *= -1
        maxspeed += 6
        with instance_create(x, y, ChickenB) image_speed *= 2;
        with instance_create(x, y, DiscBounce){sprite_index = global.sprBounce}
      }
    }
    ang += 21*current_time_scale
  }
  else//return to player
  {
    if instance_exists(creator)
    {
      var _d = point_direction(x,y,creator.x,creator.y)
      if phase = 1 {
        if irandom(3) <= current_time_scale{repeat(1 + irandom(2)) with instance_create(x + random_range(-4, 4), y + random_range(-4, 4), LightningHit){image_angle = random(360)}}
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
          sprite_index = global.sprLightningWheel
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
  if speed > maxspeed speed = maxspeed

#define weapon_sprt
  return global.sprLightningWheel

#define nts_weapon_examine
return{
    "d": "a former piece used to a mighty vehicle known as the thundertank. ",
}

#define weapon_text
  return choose("HOLD FIRE TO HOLD THE SPIN","TESLA COIL")

#define boom_draw
  draw_sprite_ext(sprite_index,image_index,x,y, image_xscale, image_yscale, ang, image_blend, image_alpha);

#define audio_play_ext(snd, x, y, pitch, vol, stack) mod_script_call("mod", "defpack tools", "audio_play_ext", snd, x, y, pitch, vol, stack)

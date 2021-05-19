#define init
  global.sprLightningWheel     = sprite_add_weapon("sprites/weapons/sprLightningWheel.png",9,8);
  global.sprLightningWheelHUD  = sprite_add_weapon("sprites/weapons/sprLightningWheel.png",3,5);
  global.sprLightningWheelProj = sprite_add("sprites/projectiles/sprLightningWheelProj.png", 4, 17, 17);
  global.sprBounce = sprImpactWrists//prite_add("sprites/projectiles/sprKaboomerangBounce.png", 3, 12, 12);
  global.msk = sprite_add_weapon("sprites/weapons/sprKaboomerang.png", 3, 12);

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
  weapon_post(0, 12, 4);
  var _pitch = random_range(.8, 1.2)
  sound_play(sndChickenThrow);
  sound_play_pitchvol(sndLightningShotgunUpg, 2 * _pitch, skill_get(mut_laser_brain) > 0)
  sound_play_pitch(skill_get(mut_laser_brain) > 0 ? sndEnergyHammerUpg : sndEnergyHammer, 1.5 * _pitch)
  sound_play_pitch(skill_get(mut_laser_brain) > 0 ? sndEnergyScrewdriverUpg : sndEnergyScrewdriver, 1.6 * _pitch)
  sound_play_pitch(sndLightningReload, .7 * _pitch)


    var _c = instance_is(self, FireCont) && "creator" in self ? creator : self;

    with create_lightning_wheel(x, y) {
        motion_set(other.gunangle, maxspeed)
        team = other.team
        creator = other

        wheel_throw(self, _c)
    }

//   with instance_create(x - lengthdir_x(8, gunangle), y - lengthdir_y(8, gunangle), CustomObject)
//   {
//     defbloom = {
//           xscale : 1.33,
//           yscale : 1.33,
//           alpha : .1 + skill_get(mut_laser_brain) * .025
//       }
//     name = "Lightning Wheel"
//     btn = other.specfiring ? "spec" : "fire";
//     timer = 7
//     team = other.team
//     creator = other
//     sprite_index = global.sprLightningWheelProj
//     mask_index   = sprHeavyGrenadeBlink
//     image_speed = .49
//     curse = other.curse
//     other.curse = 0
//     other.wep = 0
//     maxspeed = 20
//     phase = 0
//     ang = 0
//     damage = 5
//     depth = -1;
//     returngain = 12
//     whooshtime = 0
//     maxwhoosh = 3
//     length = 6
//     friction = 1.4 - skill_get(mut_long_arms)*.25
//     imang = random(360)

//     potential = .2;
//     motion_add(other.gunangle, maxspeed)
//     on_end_step = boom_step
//     on_draw = boom_draw
//     //on_draw = boom_draw
//     with instance_create(x,y,LightningHit){image_angle = other.direction}
//     if place_meeting(x + hspeed, y + vspeed, Wall){speed = 12; move_bounce_solid(false)}
//   }


//Sets some variables that need checks
//They all have defaults so failing any is fine
#define wheel_throw(wheel, creator)
    if "wep" in creator {
        wheel.info.wep = creator.wep
        creator.wep = wep_none
    }
    if "curse" in creator {
        wheel.info.curse = creator.curse
        creator.curse = 0
    }
    if "index" in creator {
        wheel.index = creator.index
    }


#define create_lightning_wheel(x, y)
    with instance_create(x, y, CustomObject) {

        name = "Lightning Wheel"
        defbloom = {
            xscale : 1.33,
            yscale : 1.33,
            alpha : .1 + skill_get(mut_laser_brain) * .025
        }

        sprite_index = global.sprLightningWheelProj
        mask_index   = sprHeavyGrenadeBlink
        //Mask used for colliding with projectiles and hitme
        proj_mask    = mskSnowTank
        image_speed  = .4

        damage = 5

        friction = max(1.4 - skill_get(mut_long_arms)*.25, .2) //arbitrary minimum
        depth  = -1
        maxspeed = 20

        index = -1
        btn = "fire"
        timermax = 7
        timer = timermax
        returning = false
        returnspeed = 12
        //info stores stuff that is required for the extra functions to work, like wheel_equip, that aren't standard on projectiles
        info = {
            wep : mod_current,
            curse : 0,
            //Saves this object's ID so its easy to tell if its copied later
            id : id
        }
        whooshtime = 0
        maxwhoosh = 3
        wallbonus = .2
        pickupList = []
        trailPoints = null
        trailSize = 10

        on_end_step = wheel_endstep
        on_step = wheel_step

        return id
    }


#define wheel_endstep
    //Trails                                             v- Uses Y Scale because its perpendicular to direction -v
    var left  = {x: x + lengthdir_x(trailSize * image_yscale, direction + 90), y: y + lengthdir_y(trailSize * image_yscale, direction + 90)},
        right = {x: x + lengthdir_x(trailSize * image_yscale, direction - 90), y: y + lengthdir_y(trailSize * image_yscale, direction - 90)},
        newPoints = [left, right];

    if (trailPoints != null) {
        with [0, 1] {
            var current = newPoints[self],
                last    = other.trailPoints[self];
            with instance_create(current.x, current.y, BoltTrail) {
                image_angle = point_direction(x, y, last.x, last.y)
                image_xscale = point_distance(x, y, last.x, last.y)
            }
        }
    }

    trailPoints = newPoints



#define wheel_step

    //Simply drop if the creator dies
    if !instance_exists(creator) {
        wheel_drop(x, y, self)
        instance_destroy()
        exit
    }

    //Pseudo animation
    if (image_index >= 3.5) {
        image_angle = random(360)
    }

    //Sound Effects
    whooshtime = (whooshtime + current_time_scale) mod (maxwhoosh + returning)
    if whooshtime < current_time_scale audio_play_ext(sndMeleeFlip, x, y, 1.4 + random_range(-.1, .1) - returning * .4, 1, 0);

    //Gather Pickups
    if instance_number(Pickup) > 0 {
        //Move existing Pickups out of the way, and update their positions to the wheel's
        var _x = x + 10000,
            _y = y;
        with pickupList if instance_exists(self) {
            x = _x
            y = _y
        }
        //Check for new pickups
        if distance_to_object(Pickup) <= 4 {
            //Not wep pickups
            with instances_matching_ne(Pickup, "object_index", WepPickup) {
                if distance_to_object(other) <= 4 {
                    array_push(other.pickupList, id)
                    depth = other.depth - 1
                }
            }
        }
        //Restore the pickups to on top of the wheel
        with pickupList if instance_exists(self) {
            x -= 10000
        }
    }

    //Open Chests in flight
    with chestprop {
        if distance_to_object(other) <= 4{
            //Pops them right open
            with instance_create(x, y, PortalShock) {
                mask_index = sprMapDot
            }
        }
    }


    //Normal Flight
    if !returning {
        //Wall Collision
        var bounced = false;
        if place_meeting(x + hspeed, y, Wall){bounced = true; hspeed *= -1}
        if place_meeting(x, y + vspeed, Wall){bounced = true; vspeed *= -1}
        if place_meeting(x + hspeed, y + vspeed, Wall){bounced = true; hspeed *= -1; vspeed = 1}

        if bounced {
            create_wheel_bounce(x, y)
            //Grant a decreasing speed bonus
            speed *= (1 + wallbonus);
            wallbonus *= .5
            instance_create(x, y, LightningHit).image_angle = image_angle
            sound_play_pitchvol(sndLightningReload,   random_range(0.6, 0.8), 0.6)
            sound_play_pitchvol(sndLightningPistol,   random_range(1.4, 1.6), 1)
            sound_play_pitchvol(sndGammaGutsKill, 8 * random_range(0.8, 1.2), 0.3)
            trailPoints = null
        }

        //Stopping
        if (speed <= friction) {
            //Whether or not the wheel is returned to the player
            var sendBack = true;

            //Particles
            if current_frame mod 5 < current_time_scale {
                var _dir = random(360),
                    _dis = 12 + irandom(4);
                with instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), LightningSpawn) image_angle = _dir
            }

            //Dont bother with button checking if theres no index to check
            if index != -1 {
                //Hover Mode                v-Checks for going into portals-v
                if button_check(index, btn) && creator.mask_index != mskNone {
                    //Hold in place
                    sendBack = false
                    speed = 0
                    if (timer > 0) timer -= current_time_scale * mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator)
                    else {
                        timer = timermax

                        //Try spawning Lightning
                        var hasammo = creator.ammo[5] > 0 || creator.infammo != 0;
                        if (hasammo && !collision_line(creator.x, creator.y, x, y, Wall, 0, 0)) {
                            if (creator.infammo = 0) creator.ammo[5]--

                            sound_play_pitchvol(sndGammaGutsKill, 5 * random_range(.6, 1.2), .6)
                            //Spawn Lightning
                            repeat(2 + irandom(1) + round(skill_get(mut_laser_brain))) {
                                with instance_create(x, y, Lightning) {
                                    image_angle = random(360)
                                    direction = image_angle
                                    team = other.team
                                    creator = other.creator
                                    ammo = 4 + irandom(2) + 2*skill_get(mut_laser_brain)
                                    alarm0 = 1
                                }
                            }

                            //Particles
                            var sparkAngle = point_direction(creator.x, creator.y, x, y);
                            if fork() {
                                repeat(irandom_range(1,4)) {
                                    if !instance_exists(self) || !instance_exists(creator) exit
                                    with mod_script_call_self("mod", "defparticles", "create_spark", creator.x + random_range(-4, 4), creator.y + random_range(-4, 4)) {
                                        color = c_blue
                                        fadecolor = c_aqua
                                        gravity = 0
                                        var n = irandom_range(5, 9)
                                        fadespeed = .2 + random(.4)
                                        age = n
                                        motion_set(sparkAngle, point_distance(x, y, other.x, other.y) / n)
                                    }
                                    wait(1)
                                }
                                exit
                            }
                        }
                        //Out of ammo
                        if !(hasammo) {
                            sendBack = true
                            sound_play(sndEmpty)
                            with instance_create(x, y, PopupText) {
                                text = "EMPTY"
                                target = other.index
                            }
                        }
                    }
                }
            }
            //Start the wheel on its return trip
            if sendBack {
                returning = true
                trailPoints = null
                friction *= -1
                maxspeed += 6
                with instance_create(x, y, ChickenB) image_speed *= 2;
                create_wheel_bounce(x, y)
            }
        }

    }
    //Return trip
    else {
        //Accelerate towards player
        motion_add_ct(point_direction(x, y, creator.x, creator.y), returnspeed)
        returnspeed += .5 * current_time_scale
        //Player retrieving the disk
        var distance = min(point_distance(x, y, creator.x, creator.y), distance_to_object(creator));
        if (distance <= 9 + skill_get(mut_laser_brain) * 3) {
            //Whether the wheel should drop to the ground
            var drop = true;
            //Eliminate anything that couldn't acquire the wheel in the first place from being checked
            if "wep" in creator && "bwep" in creator {
                //If the player has space
                if (creator.wep = wep_none || creator.bwep = wep_none) {
                    wheel_equip(creator, self, info, creator.wep == wep_none)
                    drop = false
                }
            }

            if drop wheel_drop(x, y, self)
            instance_destroy()
            exit

        }
    }

    //Clamping speed
    if (speed > maxspeed) speed = maxspeed

    //Post direction changing so speed variables are accurate
    //Creating the hitbox for the wheel that interacts with hitme and projectiles
    with instance_create(x, y, CustomSlash) {
        name = "WheelSlash"
        mask_index = other.proj_mask
        typ = 0

        damage = other.damage
        team = other.team
        creator = other.creator
        wheel = other

        //Since this is in step, the slash and the wheel will move to the same position due to event order
        motion_set(other.direction, other.speed)
        force = speed

        on_wall = nothing
        on_anim = nothing
        on_hit = wheelslash_hit
        on_projectile = wheelslash_proj
        on_grenade    = wheelslash_grenade
        on_end_step   = wheelslash_endstep

    }



#define nothing

#define wheelslash_hit
    //The wheel uses 3 iFrames as opposed to the standard 6
    if (other.nexthurt - current_frame <= 3) {
        projectile_hit(other, damage, force, direction)
        //Sounds
        sound_play_pitchvol(skill_get(mut_laser_brain) > 0 ? sndLightningPistolUpg : sndLightningPistol, random_range(1.3, 1.5), .7);
        sound_play_pitchvol(sndLightningHammer, random_range(1.8, 2), .7);
        //Particles
        instance_create(x, y, LightningHit).image_angle = direction

        //Delay the wheel on hit
        var size = clamp(other.size, 1, 3);
        if !instance_is(other, prop) {
            wheel.x -= lengthdir_x(speed_raw, direction) * (1 - size / 10)
            wheel.y -= lengthdir_y(speed_raw, direction) * (1 - size / 10)
        }

        //Screenshake
        if "maxhealth" in other {
            view_shake_max_at(x, y, 10 * (1 - other.my_health/other.maxhealth));
        }
        //On Kill, do small effect
        if other.my_health <= 0 {
            sleep(10 + 6 * size);
        }
    }

#define wheelslash_proj
    //Destroy all valid projectiles
    with other {
        if typ > 0 instance_destroy()
    }

#define wheelslash_grenade
    //Weapons are always better if they dont blow up IDPD grenades
    with other {
        motion_set(point_direction(other.x, other.y, x, y), speed)
        instance_create(x, y, Deflect)
    }

#define wheelslash_endstep
    //Simply destroy the slash after collisions have been done
    instance_destroy()

//Helper functions
//Gives the player the wheel
#define wheel_equip(player, wheel, info, primary)
    if primary {
        player.wep = info.wep
        player.curse = info.curse
        player.reload = weapon_get_load(info.wep)
    }
    else {
        player.bwep = info.wep
        player.bcurse = info.curse
        player.breload = weapon_get_load(info.wep)
    }
    instance_create(wheel.x, wheel.y, WepSwap)
    sound_play(weapon_get_swap(info.wep))


//Spawns a thrown wep to drop the wheel
#define wheel_drop(x, y, wheel)
    //Check for duplication
    if wheel.info.id == wheel.id {
        repeat(14) {
            instance_create(x + random_range(-6, 6), y + random_range(-6, 6), Smoke)
        }
        with instance_create(x, y, ThrownWep) {
            wep = wheel.info.wep
            sprite_index = weapon_get_sprite(wep)
            curse = wheel.info.curse
            team = wheel.team
            creator = wheel.creator
            motion_set(wheel.direction + random_range(-8, 8), wheel.speed * .6)
        }
    }
    //Puff into smoke instead of dropping if not a real wheel
    else {
        repeat(8) with instance_create(wheel.x, wheel.y, Dust) sprite_index = sprExtraFeetDust
    }

//Custom particle
#define create_wheel_bounce(x, y)
    with instance_create(x, y, DiscBounce) {
        sprite_index = global.sprBounce;
        image_index = 1;
        image_speed = 1

        return id
    }



#define boom_draw
  draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, imang, image_blend, image_alpha)


#define boom_step
  if image_index >= 3.5{imang = random(360)}
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
  with Pickup if !instance_is(self, WepPickup){
    if distance_to_object(other) <= 4 && ("rang" not in self || ("rang" in self && rang != other.id)){rang = other.id}
    if "rang" in self{if instance_exists(rang){x = rang.x;y = rang.y;depth = other.depth-1}}
  }
  with instances_matching([AmmoChest, RadChest, WeaponChest, RogueChest, GoldChest, chestprop], "", null)
  {
    if distance_to_object(other) <= 4{
      with instance_create(other.x, other.y, PortalShock){
        mask_index = sprMapDot;
      }
    }
  }
  mask_index = mskSnowTank;
  with instances_matching_ne(hitme,"team",team)
  {
    if distance_to_object(other) <= 8
    {
      //this is supposed to take the hitme as an argument but i guess it just compares teams so its fine?
      if projectile_canhit(other) = true
      {
        with other
        {
          if current_frame mod 3 < current_time_scale{
            sound_play_pitchvol(skill_get(mut_laser_brain) > 0 ? sndLightningPistolUpg : sndLightningPistol, random_range(1.3, 1.5), .7);
            sound_play_pitchvol(sndLightningHammer, random_range(1.8, 2), .7);

            var meetx = (x + other.x)/2,
                meety = (y + other.y)/2,
                   _s = clamp(other.size, 1, 3);
            with instance_create(x ,y, LightningHit) image_angle = other.image_angle
            with other{
              var _xx = lengthdir_x(other.speed, other.direction) * (1 - _s / 10),
                  _yy = lengthdir_y(other.speed, other.direction) * (1 - _s / 10);
              if !place_meeting(x + _xx, y + _yy, Wall){
                x += _xx;
                y += _yy;
              }
              speed = 0
            }
            projectile_hit(other, damage, speed, direction)
            if !instance_is(other, prop){
              x -= lengthdir_x(speed, direction) * (1 - _s / 10)
              y -= lengthdir_y(speed, direction) * (1 - _s / 10)
            }

            sleep(10 + 6 * clamp(other.size, 1, 3));
            view_shake_max_at(x, y, 10);
          }
        }
      }
    }
  }
  with instances_matching_ne(instances_matching_ne(projectile, "team", team), "typ", 0) {
    if distance_to_object(other) <= 4 {
      instance_destroy()
    }
  }
  mask_index = sprHeavyGrenadeBlink;

  if curse = true and current_frame < floor(current_frame) + current_time_scale {instance_create(x+random_range(-2,2),y+random_range(-2,2),Curse)}
  if phase = 0 //move regularly
  {
    var _b = false;
    if place_meeting(x + hspeed, y, Wall){_b = true; hspeed *= -1}
    if place_meeting(x, y + vspeed, Wall){_b = true; vspeed *= -1}
    if place_meeting(x + hspeed, y + vspeed, Wall){_b = true; hspeed *= -1; vspeed = 1}

    if _b
    {
      with instance_create(x, y, DiscBounce){sprite_index = global.sprBounce; image_index = 1; image_speed = 1}
      speed *= (1 + potential);
      potential *= .5
      with instance_create(x ,y, LightningHit) image_angle = other.image_angle
      sound_play_pitchvol(sndLightningReload, random_range(.6, .8), .6)
      sound_play_pitchvol(sndLightningPistol, random_range(1.4, 1.6), 1)
      sound_play_pitchvol(sndGammaGutsKill,8*random_range(.8, 1.2), .3)
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
          if timer > 0 timer -= current_time_scale * mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator)
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
        with instance_create(x, y, DiscBounce){sprite_index = global.sprBounce; image_index = 1; image_speed = 1}
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
        motion_add(_d,returngain * current_time_scale)
        returngain += .5 * current_time_scale
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
    "d": "a former piece of a mighty vehicle known as the thundertank. ",
}

#define weapon_text
  return choose("HOLD FIRE TO HOLD THE SPIN","TESLA COIL")

#define audio_play_ext(snd, x, y, pitch, vol, stack) mod_script_call("mod", "defpack tools", "audio_play_ext", snd, x, y, pitch, vol, stack)

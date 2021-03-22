#define init
  //global.gun
  global.sprDrillLauncher = sprite_add_weapon("sprites/weapons/sprDrillLauncher.png",6,4)
  global.sprDrill      = sprite_add("sprites/projectiles/sprDrill.png"     , 4, 7, 4)
  global.sprDrillBlink = sprite_add("sprites/projectiles/sprDrillBlink.png", 2, 7, 4)
  global.explosive = 0 //boolean, try turning it off

#define weapon_name
  return "DRILL LAUNCHER"
#define weapon_type
  return 3
#define weapon_cost
  return 2
#define weapon_area
  return 8
#define weapon_load
  return 26
#define weapon_swap
  return sndSwapMotorized
#define weapon_auto
  return 0
#define weapon_melee
  return 0
#define weapon_laser_sight
  return 1
#define weapon_sprt
  return global.sprDrillLauncher
#define nts_weapon_examine
return{
    "d": "They were once used to dig tunnels for water pipelines. ",
}
#define weapon_text
  return "HOLLOW THE EARTH"

#define weapon_fire
  weapon_post(5,-22,5)
  var _fac = random_range(.8,1.2);
  sound_play_pitch(sndSwapMotorized,1.3*_fac)
  sound_play_pitch(sndCrossbow,.7*_fac)
  sound_play_pitch(sndDiscBounce,1.5*_fac)
  sound_play_drill(.6)
  with instance_create(x,y,CustomProjectile){
      motion_set(other.gunangle+random_range(-3,3)*other.accuracy,1)
      friction = -1.5
      image_speed = .4
      maxspeed = 14
      damage = 2
      bounce = round(skill_get("compoundelbow") * 5)
      sprite_index = global.sprDrill
      lasthit = -4
      hits = 0
      walls = 6 + (skill_get(mut_bolt_marrow) * 4 * !global.explosive) + 1
      image_angle = direction
      projectile_init(other.team,other)
      repeat(4) instance_create(x,y,Smoke)
      on_hit = global.explosive ? drill_explo : drill_hit
      on_end_step = global.explosive ? drill_step : bolt_step
      on_wall = drill_wall
  }

#define bolt_step
  if skill_get(mut_bolt_marrow){
      var q = mod_script_call("mod","defpack tools","instance_nearest_matching_ne",x,y,hitme,"team",team)
      if instance_exists(q) and distance_to_object(q) < 120{
          var ang = angle_difference(direction, point_direction(x,y,q.x,q.y))
          if abs(ang) < 50 direction -= ang/5
      }
  }
  drill_step()
  if speed > 0{
    var flutes = 3, num = 360/(flutes)
    var w = sprite_height/2 -1;
    var ang = direction;
    var n = 36
    var spd = speed;
    var off = (current_frame)*n
    for (var i = 0; i < 360; i+=num){
        i+=off
        var _x = x + lengthdir_x(w*dsin(i),ang+90), _y = y + lengthdir_y(w*dsin(i),ang+90);
        var _x2 = xprevious + lengthdir_x(w*dsin(i-n*current_time_scale),image_angle+90), _y2 = yprevious + lengthdir_y(w*dsin(i-n*current_time_scale),image_angle+90);
        with instance_create(_x,_y,BoltTrail){
            image_angle = point_direction(x,y,_x2,_y2)
            image_xscale = point_distance(x,y,_x2,_y2)
            if random(100) < 20*current_time_scale with instance_create(x,y,Dust) motion_add(other.image_angle,random(spd/2))
        }
        i-=off
    }
  }
  image_angle = direction

#define drill_step
  if speed > maxspeed speed = maxspeed
  if speed > 0 image_speed = max(speed * .075,.4)
  if "target" in self{
    if !instance_exists(target){
      instance_create(x, y, SmallExplosion);
      sound_play(sndExplosionS);
      instance_delete(self);
      exit;
    }else{
      x = target.x + target.hspeed_raw - lengthdir_x(12, direction);
      y = target.y + target.vspeed_raw - lengthdir_y(12, direction);
    }
  }

#define drill_wall
  if bounce > 0{
    bounce--;
    view_shake_max_at(x, y, 2)
    repeat(3)instance_create(x, y, Dust)
    move_bounce_solid(false)
    with other{
        instance_create(x, y, FloorExplo)
        instance_destroy()
    }
  }else if walls > 0
  {
    sound_play_drill(.4)
     with other{instance_create(x,y,FloorExplo);instance_destroy()}
     walls--
     speed = 4
     //sleep(15)
     view_shake_at(x,y,5)
  }
  else
  {
    with drillstick_create(x, y){
      target = noone;
      direction = other.direction;
      image_angle = direction;
    }
    instance_destroy()
  }

#define drill_hit
  view_shake_at(x,y,3*min(other.size,4))
  sound_play_drill(.4)
  //karm youre fucking insane if you think ill allow you to sleep for 35ms for TEN FRAMES IN A ROW
  //seriously though, use them for big chunky freezes, not several small ones, that just makes it look like the game is running poorly
  //sleep(35)
  //speed = max(speed - 3, 3)
  x = xprevious
  y = yprevious
  speed = 2
  other.speed = 0
  sleep(8)
  view_shake_at(x,y,4)
  projectile_hit(other,damage)
  var mans = other;
  if other = lasthit{
      if ++hits > 10{

        with drillstick_create(x, y){
          target = mans;
          direction = other.direction;
          image_angle = direction;
        }

        instance_destroy();
        exit;
      }
    }else{
      lasthit = other
      hits = 0
  }

#define sound_play_drill(_vol)
  if fork(){
      repeat(8){
          sound_play_pitchvol(sndJackHammer,.8,_vol)
          sound_play_pitchvol(sndWallBreak,1.4,_vol)
          sound_play_pitchvol(sndDiscHit,1.6,_vol)
          wait(0)
      }
      exit
  }


#define drillstick_create(X, Y)
  var _i = instance_create(X, Y, CustomObject)
  with _i{
    timer = 0;
    image_speed  = 0;
    sprite_index = global.sprDrill;

    on_wall    = void;
    on_step    = drillstick_step;
    on_destroy = drillstick_destroy;
  }
  return _i;

#define drillstick_step
  if !instance_exists(target) && target != noone{
    instance_delete(self);
    exit;
  }

  if target != noone{
    x = target.x + target.hspeed_raw - lengthdir_x(12, direction);
    y = target.y + target.vspeed_raw - lengthdir_y(12, direction);
  }

  var _t1 = 20,
      _t2 = 12;

  if timer >= _t1{
      sprite_index = global.sprDrillBlink;
      image_speed = .4;
      if timer >= _t1 + _t2{
        instance_destroy();
        exit;
      }
  }
  timer++;

#define drillstick_destroy
  sleep(20)
  instance_create(x + lengthdir_x(8, direction), y + lengthdir_y(8, direction), SmallExplosion);
  sound_play(sndExplosionS);

#define void

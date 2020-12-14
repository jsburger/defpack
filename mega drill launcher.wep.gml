#define init
//global.gun
global.sprMegaDrillLauncher    = sprite_add_weapon("sprites/weapons/sprBigDrillLauncher.png",21,10)
global.sprMegaDrillLauncherHUD = sprite_add_weapon("sprites/weapons/sprBigDrillLauncher.png",37,5)
global.sprMegaDrill            = sprite_add("sprites/projectiles/sprBigDrill.png",4,15,10)
global.sprMegaDrillBlink       = sprite_add("sprites/projectiles/sprBigDrillBlink.png", 2, 15, 10)
global.explosive = 0 //boolean, try turning it off

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_name
return "MEGA DRILL LAUNCHER"
#define weapon_type
return global.explosive ? 4 : 3
#define weapon_cost
return 8
#define weapon_area
return 23
#define weapon_load
return 75
#define weapon_swap
if instance_is(self, Player){
	view_shake_at(x, y, 20);
	sleep(10);
}
sound_play_pitchvol(sndBasicUltra, 1.2, .6);
sound_play_pitch(sndSwapMotorized, .9);
return -4;
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 1
#define weapon_sprt
return global.sprMegaDrillLauncher
#define weapon_sprt_hud
return global.sprMegaDrillLauncherHUD
#define weapon_text
//how could you not
return "PIERCE THE HEAVENS"
#define weapon_fire
  weapon_post(21,-260,80)
  var _fac = random_range(.8,1.2);
  sound_play_pitch(sndSwapMotorized,.7*_fac)
  sound_play_pitch(sndHeavyCrossbow,.7*_fac)
  sound_play_pitch(sndHeavySlugger,.7*_fac)
  sound_play_pitch(sndGrenade,.3*_fac)
  sound_play_pitch(sndDiscBounce,1.5*_fac)
  sound_play_drill(.6)
  motion_set(gunangle-180,maxspeed * 2)
  sleep(55)
  if fork(){
      var ang = gunangle + 180;
      repeat(10){
          if instance_exists(self){
              motion_set(ang,4)
          }
          wait(1)
      }
      exit
  }
  with instance_create(x,y,CustomProjectile){
      motion_set(other.gunangle+random_range(-3,3)*other.accuracy,1)
      friction = -.6
      image_speed = .4
      maxspeed = 12
      damage = 7 - 2*global.explosive
      sprite_index = global.sprMegaDrill
      lasthit = -4
      hits = 0
      walls = 14 + (skill_get(mut_bolt_marrow) * 6 * !global.explosive)
      image_angle = direction
      projectile_init(other.team,other)
      repeat(12) instance_create(x,y,Smoke)
      on_hit = drill_hit
      on_end_step = global.explosive ? drill_step : bolt_step
      on_wall = drill_wall
  }

#define step
with instances_matching(Player, "wep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}
with instances_matching(instances_matching(Player, "race", "steroids"), "bwep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}
#define bolt_step
  if skill_get(mut_bolt_marrow){
      var q = mod_script_call("mod","defpack tools","instance_nearest_matching_ne",x,y,hitme,"team",team)
      if instance_exists(q) and distance_to_object(q) < 120{
          var ang = angle_difference(direction, point_direction(x,y,q.x,q.y))
          if abs(ang) < 50 direction -= ang/10
      }
  }
  drill_step()
  if speed > 0{
    var flutes = 5, num = 360/(flutes)
    var w = sprite_height/2 -1;
    var ang = direction;
    var n = 24
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
  if walls > 0
  {
    sound_play_drill(.4)
     with other{instance_create(x,y,FloorExplo);instance_destroy()}
     walls--
     speed = 3
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
  if current_frame_active {
    view_shake_at(x,y,7*min(other.size,4))
    sound_play_drill(.4)
    //karm youre fucking insane if you think ill allow you to sleep for 35ms for TEN FRAMES IN A ROW
    //seriously though, use them for big chunky freezes, not several small ones, that just makes it look like the game is running poorly
    //sleep(35)
    //speed = max(speed - 3, 3)
    x = lerp(xprevious, x, .2)
    y = lerp(yprevious, y, .2)
    other.speed = 0
    sleep(5)
    projectile_hit(other,damage)
    var mans = other;
    if other = lasthit{
        if ++hits > 30{

          with drillstick_create(x, y){
            target = mans;
            direction = other.direction;
            image_angle = direction;
            sprite_index = other.sprite_index;
          }

          instance_destroy();
          exit;
        }
      }else{
        lasthit = other
        hits = 0
  }}


#define sound_play_drill(_vol)
  if fork(){
      repeat(10) if instance_exists(self){
          sound_play_hit_big(sndWallBreakScrap,.1)
          //sound_play_pitchvol(sndJackHammer,.4,_vol)
          //sound_play_pitchvol(sndCrossbow,1.6,_vol)
          //sound_play_pitchvol(sndHyperRifle,.6,_vol)
          //sound_play_pitchvol(sndDiscHit,1.5,_vol)
          wait(1)
      }
      exit
  }

  #define drillstick_create(X, Y)
    var _i = instance_create(X, Y, CustomObject)
    with _i{
      timer = 0;
      image_speed  = 0;
      sprite_index = global.sprMegaDrill;

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
        sprite_index = global.sprMegaDrillBlink;
        image_speed = .4;
        if timer >= _t1 + _t2{
          instance_destroy();
          exit;
        }
    }
    timer++;

  #define drillstick_destroy
		sleep(50)
    var _l = 24;
    instance_create(x + lengthdir_x(_l, direction), y + lengthdir_y(_l, direction), Explosion)
    instance_create(x + lengthdir_x(_l, direction + 90), y + lengthdir_y(_l, direction + 90), Explosion)
    instance_create(x + lengthdir_x(_l, direction - 90), y + lengthdir_y(_l, direction - 90), Explosion)
    sound_play(sndExplosion)
    sound_play(sndExplosionL)

  #define void

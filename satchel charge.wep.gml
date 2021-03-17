#define init
global.sprSatchelCharge = sprite_add_weapon("sprites/weapons/sprSatchelCharge.png", 4, 6);
global.sprSatchelHUD    = sprite_add_weapon("sprites/weapons/sprSatchelCharge.png", -1, 6);
global.sprSatchelReady  = sprite_add("sprites/weapons/sprSatchelReady.png", 7, 4, 6);

#define weapon_name
return "SATCHEL CHARGE"
#define weapon_type
return 4
#define weapon_cost
return 2
#define weapon_area
return 5
#define weapon_load
return 15
#define weapon_swap
return sndSwapHammer
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_chrg
return 1
#define weapon_sprt
return global.sprSatchelCharge
#define weapon_sprt_hud
return global.sprSatchelHUD
#define weapon_reloaded
#define nts_weapon_examine
return{
    "d": "Used in mining operations. #Take cover before detonating them! ",
}

#define weapon_text
return choose("ROCK AND STONE")

#define weapon_fire
  with instance_create(x,y,CustomObject){
  	name    = "satchel charge charge"
  	creator = other
  	charge    = 0
      maxcharge = 12
      defcharge = {
          style : 0,
          width : 12,
          charge : 0,
          power : 10,
          maxcharge : maxcharge
      }
  	charged = 0
  	depth = TopCont.depth
  	index = creator.index
    accuracy = other.accuracy
  	on_step    = chrg_step
  	on_destroy = chrg_destroy
  	reload = -1
  	btn = other.specfiring ? "spec" : "fire"
  	hand = other.specfiring and other.race == "steroids"
  }

#define chrg_step
  if !instance_exists(creator){instance_delete(self);exit;sound_stop(sndIDPDNadeAlmost)}
  x = creator.x + creator.hspeed
  y = creator.y + creator.vspeed
  if button_check(creator.index, "swap") && (creator.canswap = true || creator.bwep != 0){
    var _t = weapon_get_type(mod_current);
    creator.ammo[_t] += weapon_get_cost(mod_current)
    if creator.ammo[_t] > creator.typ_amax[_t] creator.ammo[_t] = creator.typ_amax[_t]
    instance_delete(self)
    sound_stop(sndIDPDNadeAlmost)
    exit
  }
  var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
  with creator{
    weapon_post(2 * other.charge / other.maxcharge, 0, 0);
  }
  if button_check(index,"swap"){instance_destroy();exit;sound_stop(sndIDPDNadeAlmost)}
  if reload = -1{
      reload = hand ? creator.breload : creator.reload
      reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale
  }
  else{
      if hand creator.breload = max(creator.breload, reload)
      else creator.reload = max(reload, creator.reload)
  }
  defcharge.charge = charge
  if button_check(index, btn){
      if charge < maxcharge{
          charge += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale;
          charged = 0
          sound_play_pitchvol(sndIDPDNadeAlmost, charge/maxcharge * .45 + .25, .05 + .95 * charge/maxcharge)
      }
      else{
          if current_frame mod 6 < current_time_scale {
              creator.gunshine = 1
              with defcharge blinked = 1
          }
          charge = maxcharge;
          if charged = 0{
              mod_script_call_self("mod","defpack tools", "weapon_charged", creator, 12)
              charged = 1
          }
      }
  }
  else{instance_destroy();sound_stop(sndIDPDNadeAlmost)}

#define chrg_destroy
if instance_exists(creator) with creator{
  weapon_post(-4, -4, 0);
}
if charge/maxcharge = 1{
  var _yes = false,
      _c = creator;
  with instances_matching(CustomProjectile, "name", "Satchel Charge") if point_seen(x, y, _c){
    if creator = other.creator{
      countdown = true;
      _yes = true;
      timer = irandom(2) + distance_to_object(creator) / 30
    }
  }
  if _yes = false{
    with instance_create(x, y, PopupText){
      text = "NO SATCHELS PLACED"
      target = other.creator.index
      sound_play(sndCursedReminder)
    }
  }
}else{
  var _pitch = random_range(.8, 1.2)
  sound_play_pitchvol(sndChickenThrow, .8 * _pitch, 2)
  sound_play_pitchvol(sndAssassinAttack, 1.3 * _pitch, 1.2)
  with instance_create(x, y, CustomProjectile){
      spr_idle = global.sprSatchelReady;
      sprite_index = spr_idle;
      mask_index   = sprGrenade;
      image_speed  = 0;
      depth = -3;
      is_grenade = true;
      maxtimer   = 3;
      timer      = maxtimer;
      countdown  = false;

      maxhealth = 15;
      my_health = maxhealth;
      team = other.creator.team;
      sticky = true;
      friction = .5;
      creator = other.creator;
      stick_target = -4;
      name = "Satchel Charge"

      motion_set(creator.gunangle + random_range(-4,4) * creator.accuracy, 10 + 3 * other.charge/other.maxcharge);
      image_xscale = creator.right

      on_hit  = satchel_hit;
      on_wall = satchel_wall;
      on_step = satchel_step;
      on_destroy = satchel_destroy;
  }
}

#define satchel_hit
  mask_index = mskNone;
  stick(other);

#define satchel_wall
  stick(other);

#define satchel_step
  if place_meeting(x, y, Explosion){
    instance_destroy();
    exit;
  }

  if stick_target > noone{
    if !instance_exists(stick_target){
      instance_destroy();
      exit;
    }
    x = stick_target.x + stick_target.hspeed;
    y = stick_target.y + stick_target.vspeed;
    if instance_is(stick_target, RavenFly) || instance_is(stick_target, BigMaggotBurrow) || instance_is(stick_target, LilHunterFly){
      instance_destroy();
      exit;
    }
  }

  if countdown = true
  {
    //if timer = maxtimer sound_play_pitch(sndTVOn, .1)
    timer -= current_time_scale;
    if timer <= 0{
      instance_destroy();
      exit;
    }
  }

  if sticky = false && stick_target > -4 && !instance_exists(stick_target){
    stick_target = -4;
    with instance_create(x, y, Smoke) depth = other.depth - 1
  }

  if speed <= friction && sticky = true{
    sticky = false;
    with instance_create(x, y, Smoke) depth = other.depth - 1;
    image_speed  = .5;
    countdown = true;
    timer += 47;
  }
  if my_health <= 0{instance_destroy()}

#define stick(TARGET)
  var _pt = other,
      _cs = true;
  with instances_matching(CustomProjectile, "name", "Satchel Charge"){
    if stick_target = _pt && !instance_is(stick_target, Wall) _cs = false;

  }
  if _cs = true{
    if sticky = true{
      sticky = false;
      sound_play(sndGrenadeStickWall)
      stick_target = TARGET;
      with instance_create(x, y, Dust) depth = other.depth - 1
      image_speed  = .5;
      speed = 0;
      friction = 100;
    }
  }

#define satchel_destroy
  sleep(100);
  view_shake_at(x, y, 24);
  sound_play(sndExplosion)
  if stick_target > -4{
    sound_play(sndExplosionL)
  }
  sound_play_pitch(sndFlareExplode, .4)
  sound_play_pitch(sndIncinerator, .7)

  var i = random(360);
  repeat(32 +  + (other.stick_target > -4 ? 12 : 0)){
    with instance_create(x, y, Flame){
      team = other.team;
      creator = other;

      friction *= 4;
      motion_add(random(360), random_range(8, 9) + (other.stick_target > -4 ?1.2 : 0))
    }
  }
  instance_create(x, y, GreenExplosion);
  repeat(3){
    instance_create(x + lengthdir_x(24, i), y + lengthdir_y(24, i), stick_target > -4 ? Explosion : SmallExplosion);
    i += 120;
  }

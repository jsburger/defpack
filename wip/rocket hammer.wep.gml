#define init
global.sprTurboHammer = sprite_add_weapon("sprites/projectiles/sprTurboHammer.png", 3, 4);

#define weapon_name
return "ROCKET HAMMER"

#define weapon_type
return 4;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_chrg
return 1;

#define weapon_load
return 12;

#define weapon_swap
return sndSwapHammer;

#define weapon_auto
return false;

#define weapon_melee
return true;

#define weapon_sprt
return global.sprTurboHammer;

#define weapon_text
return "SPIN TO WIN";

#define weapon_fire
with instance_create(x, y, CustomObject) {
  sound   = sndMeleeFlip;
	name    = "turbo hammer charge";
	creator = other;
	charge    = 0;
  maxcharge = 25;
    defcharge = {
        style : 2,
        width : 13,
        charge : 0,
        maxcharge : maxcharge
    }
	charged = 0;
	depth = TopCont.depth
	index = creator.index
	accuracy = other.accuracy
	on_step    = th_step
	on_destroy = th_destroy
	on_cleanup = th_cleanup
	reload = -1
	btn = other.specfiring ? "spec" : "fire"
	hand = other.specfiring and other.race == "steroids"
}


#define th_step
if !instance_exists(creator){instance_delete(self); exit}

  if button_check(creator.index, "swap") && (creator.canswap = true || creator.bwep != 0) {

    var _t = weapon_get_type(mod_current);

    creator.ammo[_t] += weapon_get_cost(mod_current);
    if creator.ammo[_t] > creator.typ_amax[_t] creator.ammo[_t] = creator.typ_amax[_t];

    instance_delete(self);
    exit;
  }

  var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;

  if button_check(index, "swap"){instance_destroy(); exit}
  if reload = -1 {

      reload = hand ? creator.breload : creator.reload;
      reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale * 1.2;
  }else {

      if hand creator.breload = max(creator.breload, reload) else creator.reload = max(reload, creator.reload)
  }
  view_pan_factor[index] = 3 - (charge / maxcharge * .5);
  defcharge.charge = charge;
  if button_check(index, btn) {

      if charge < maxcharge {

          charge += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale * 1.2;
          charged = 0;
          sound_play_pitchvol(sound, sqr((charge / maxcharge) * 3.5) + 6, 1 - charge / maxcharge);
      }else {

          if current_frame mod 6 < current_time_scale {
              creator.gunshine = 1;
              with defcharge blinked = 1;
          }

          charge = maxcharge;
          if charged = 0 {

              mod_script_call_self("mod","defpack tools", "weapon_charged", creator, 12);
              charged = 1;
          }
      }
  }else{instance_destroy(); exit}

  if charged {
    creator.speed *= .75;
  }

#define th_cleanup
  view_pan_factor[index] = undefined;
  sound_stop(sound);

#define th_destroy
  th_cleanup();


  if !charged {

  }else {

  }

#define init
global.sprGasLigher     = sprite_add_weapon("sprites/weapons/sprGasLighter.png",  7, 2);
global.sprGasLigherFire = sprite_add_weapon("sprites/weapons/sprGasLighterFire.png",  7, 2);

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_name
return "GAS LIGHTER"

#define weapon_sprt
if instance_is(self,Player){
	with instances_matching(instances_matching(CustomObject, "name", "lighter charge"),"creator", id)
		if charged{
			return global.sprGasLigher;
	}
}

return global.sprGasLigherFire;

#define weapon_type
return 4;

#define weapon_auto
return mod_script_call_nc("mod", "defpack tools", "abris_weapon_auto", "lighter charge", self)

#define weapon_load
return 13;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapFlame;

#define weapon_area
return 5;

#define weapon_chrg
return 1

#define weapon_text
return "FALSE MEMORIES";

#define weapon_melee
return false;

#define weapon_fire

with instance_create(x,y,CustomObject){
  sound   = sndOasisExplosionSmall
	name    = "lighter charge"
	creator = other
	charge    = 0
  maxcharge = 25
  defcharge = {
        style : 2,
        width : 14,
        charge : 0,
        maxcharge : maxcharge
    }
	charged = 0
	depth = TopCont.depth
	index = creator.index
  accuracy = other.accuracy
	on_step    = lighter_step
	on_destroy = lighter_destroy
	on_cleanup = lighter_cleanup
	reload = -1
	btn = other.specfiring ? "spec" : "fire"
	hand = other.specfiring and other.race == "steroids"
}

#define lighter_step
if !instance_exists(creator){instance_delete(self);exit}
x = creator.x + creator.hspeed
y = creator.y + creator.vspeed
if button_check(creator.index, "swap") && (creator.canswap = true || creator.bwep != 0){
  var _t = weapon_get_type(mod_current);
  creator.ammo[_t] += weapon_get_cost(mod_current)
  if creator.ammo[_t] > creator.typ_amax[_t] creator.ammo[_t] = creator.typ_amax[_t]
  instance_delete(self)
  exit
}

var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
if button_check(index,"swap"){instance_destroy();exit}
if reload = -1{
    reload = hand ? creator.breload : creator.reload
    reload = .1
    reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale * 3

}
else{
    if hand creator.breload = max(creator.breload, reload)
    else creator.reload = max(reload, creator.reload)
}
view_pan_factor[index] = 3 + (charge/maxcharge * 2)
defcharge.charge = charge
if button_check(index, btn){
    if charge < maxcharge{
        charge += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale * 3;
        charged = 0
        sound_play_pitchvol(sound,.4 + (charge/maxcharge) * 2.1,.7)
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
    with creator{
    	weapon_post(2 * other.charge/other.maxcharge, 0, 0);
    }
}
else{instance_destroy(); exit}
if charged {
	creator.speed *= .9;
}

#define lighter_cleanup
view_pan_factor[index] = undefined
if !charged sound_stop(sound)

#define lighter_destroy
	var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
    reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale
	var _ch = other.charge < other.maxcharge;


	with creator{
		weapon_post(7, 8, 0);
		motion_add(gunangle - 180, 1)
		var _p = random_range(.8, 1.2);
	}
	with creator if _ch{
		sound_play_pitch(sndFlamerStart, .7 * _p)
		sound_play_pitch(sndDoubleFireShotgun, .8 * _p)
		sound_play_pitch(sndSuperSlugger, .9 * _p)

		repeat(42)with create_gas_fire(x + hspeed, y + vspeed){
			move_contact_solid(other.gunangle, 12);
			motion_add(other.gunangle + random_range(-3, 3) * other.accuracy, 3.5 + irandom(8))
      friction += .25
			team = other.team;
			image_angle = direction + random_range(-12, 12);
		}
	}else{
		sound_play_pitch(sndOasisExplosion, 2.5 * _p)
		sound_play_pitch(sndToxicBarrelGas, .8 * _p)

		repeat(42)with instance_create(x + hspeed, y + vspeed, ToxicGas){
      team = other.team
      move_contact_solid(other.gunangle, 16)
			motion_add(other.gunangle + random_range(-2, 2) * other.accuracy, 6 + irandom(5))
			friction = .35;
      gas_special = true
		}
	}

#define step
  with instances_matching(ToxicGas, "gas_special", true){
    if !place_meeting(x, y, Player){
      team = -4;
      gas_special = false;
    }
  }

#define create_gas_fire( _x, _y) return mod_script_call("mod", "defpack tools", "create_gas_fire", _x, _y);

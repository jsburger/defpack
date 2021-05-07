#define init
global.sprGasLigher = sprite_add_weapon("sprites/weapons/sprPushPiston1.png",  2, 2);

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_name
return "GAS LIGHTER"

#define weapon_sprt
return global.sprGasLigher;

#define nts_weapon_examine
return{
    "d": "Unleash a large quantity of kinetic energy on both ends. ",
}

#define weapon_type
return 0;

#define weapon_auto
return true;

#define weapon_load
return 15;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 4;

#define weapon_chrg
return 1

#define weapon_text
return "FAST TRAVEL";

#define weapon_melee
return false;

#define weapon_fire

with instance_create(x,y,CustomObject){
  sound   = sndCrossReload
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
	on_step    = piston_step
	on_destroy = piston_destroy
	on_cleanup = piston_cleanup
	reload = -1
	btn = other.specfiring ? "spec" : "fire"
	hand = other.specfiring and other.race == "steroids"
}

#define piston_step
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
        sound_play_pitchvol(sound,(charge/maxcharge) * .55,.7)
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
else{instance_destroy()}

#define piston_cleanup
view_pan_factor[index] = undefined
if !charged sound_stop(sound)

#define piston_destroy
	var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
    reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale
	var _ch = other.charged;


	with creator{
		weapon_post(6, 7, 0);
		motion_set(gunangle - 180, 3)
	}
	with creator if _ch{
		repeat(36)with instance_create(x + hspeed, y + vspeed, Flame){
			move_contact_solid(other.gunangle, 16);
			motion_add(other.gunangle + random_range(-3, 3) * other.accuracy, 4 + irandom(6))
			team = other.team;
			damage += 2;
		}
		var _t = self;
		if instance_exists(ToxicGas){
			view_shake_max_at(_t.x, _t.y, 16);
		}
		with ToxicGas{
			repeat(4)with instance_create(x, y, Flame){
				motion_add(random(360), 5)
				team = _t.team;
				damage += 2;
			}
			instance_destroy()
		}
		with FrogQueenBall{
			repeat(24)with instance_create(x, y, Flame){
				motion_add(random(360), 8 + irandom(1))
				team = _t.team;
				damage += 2;
			}
			instance_destroy()
		}
	}else{
		repeat(36)with instance_create(x + hspeed, y + vspeed, ToxicGas){
			move_contact_solid(other.gunangle, 16)
			motion_add(other.gunangle, 7 + irandom(3))
			friction = .35;
		}
	}



	#define extraspeed_add(_player, __speed, _direction) return mod_script_call("mod", "defpack tools", "extraspeed_add", _player, __speed, _direction);

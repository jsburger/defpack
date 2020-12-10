#define init
global.sprAssaultSonicLauncher = sprite_add_weapon("sprites/weapons/sprAssaultSonicLauncher.png", 4, 2);
global.sprTripleSonicNade      = sprite_add("sprites/projectiles/sprSonicGrenade.png",1,3,3);
global.sprSonicStreak          = sprite_add("sprites/projectiles/sprSonicStreak.png",6,8,32);

#define weapon_name
return "SONIC CHARGER"

#define weapon_sprt
return global.sprAssaultSonicLauncher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 19;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 9;

#define weapon_text
return choose("SO LOUD", "BASE CONTROL");

#define weapon_fire
with instance_create(x,y,CustomObject){
  sound   = sndHitWall
	name    = "sonic charge"
	creator = other
	charge    = 0
  maxcharge = 18
  defcharge = {
	  style : 0,
	  width : 14,
	  charge : 0,
	  maxcharge : maxcharge
  }
	charged = 0
	index = creator.index
	on_step    = charger_step
	on_destroy = charger_fire
	reload = -1
	btn = other.specfiring ? "spec" : "fire"
	hand = other.specfiring and other.race == "steroids"
}

#define charger_step
	if !instance_exists(creator){instance_delete(self);exit}
	if button_check(creator.index, "swap") && (creator.canswap = true || creator.bwep != 0){
	  var _t = weapon_get_type(mod_current);
	  creator.ammo[_t] += weapon_get_cost(mod_current)
	  if creator.ammo[_t] > creator.typ_amax[_t] creator.ammo[_t] = creator.typ_amax[_t]
	  instance_delete(self)
	  exit
	}

	x = creator.x + creator.hspeed
	y = creator.y + creator.vspeed

	var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
	if button_check(index,"swap"){instance_destroy();exit}
	if reload = -1{
	    reload = hand ? creator.breload : creator.reload
	    reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale
	}
	else{
	    if hand creator.breload = max(creator.breload, reload)
	    else creator.reload = max(reload, creator.reload)
	}
	defcharge.charge = charge
	with creator weapon_post(3 * other.charge/other.maxcharge,-6, 0)
	if button_check(index, btn){
	    if charge < maxcharge{
	        charge += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale;
	        charged = 0
	        sound_play_pitchvol(sound,sqr((charge/maxcharge) * .5) + .3, 2)
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
	else{instance_destroy()}

#define charger_fire
	var _c = charge/maxcharge;
	with instance_create(x,y,CustomProjectile){
		move_contact_solid(other.creator.gunangle,6)
		sprite_index = global.sprTripleSonicNade
		creator = other.creator
		team = creator.team
		damage = 6
		force = 5
		typ = 1
		dt = 4
		timer = 1;
		bounce = 1
		anglefac = choose(1,-1)
		motion_add(creator.gunangle + random_range(-4, 4) * creator.accuracy * _c, 16 + 8 * _c)
		lifetime = 9
		charged = floor(_c)
		sound_play_pitch(sndHyperLauncher,1.3+(speed-10)/20)
	   on_step    = sonic_launcher_step
		 on_wall    = sonic_launcher_wall
	   on_destroy = sonic_launcher_destroy
		 with creator weapon_post(5 + 4 * _c,-6,7)
		}
		sound_play_pitch(sndHeavyNader,1.8)
		sound_play_pitch(sndNothingFire,.7)

#define sonic_launcher_wall
if bounce > 0{
	instance_create(x,y,Dust)
	move_bounce_solid(false)
	bounce -= 1
	sound_play_pitch(sndBouncerBounce,random_range(1.6,1.8))
	with instance_create(x+lengthdir_x(12,direction),y+lengthdir_y(12,direction),AcidStreak){
		sprite_index = global.sprSonicStreak
		image_angle = other.direction - 90
		motion_add(image_angle+90,12)
		friction = 2.1
	}
}else{instance_destroy()}

#define sonic_launcher_step
	if dt > 0 dt -= current_time_scale
	else if dt > -1{
	    dt = -1
		repeat(4) with instance_create(x,y,Dust){
			motion_add(random(359),random_range(0,2))
		}
	}
	if timer > 0{
		timer -= current_time_scale * charged
	}else{
		timer = 1
		with mod_script_call("mod","defpack tools","create_small_sonic_explosion",x - lengthdir_x(6, direction),y - lengthdir_y(6, direction)){
			var scalefac = random_range(0.6,0.75);
			image_xscale = scalefac
			image_yscale = scalefac
			image_speed = 0.6
			team = other.team
			creator = other.creator
			repeat(round(scalefac*10)){ with instance_create(x,y,Dust) {sprite_index = sprExtraFeet; motion_add(random(360),3)}}
		}
	}
	if lifetime > 0{
		lifetime -= current_time_scale
	}else{
		instance_destroy()
		exit
	}
	image_angle += anglefac * speed/1.5 * current_time_scale
	if speed <= 0{
		instance_destroy()
	}

#define sonic_launcher_destroy
  var _c = charged
	with mod_script_call("mod","defpack tools","create_sonic_explosion",x - lengthdir_x(2, direction),y - lengthdir_y(2, direction)){
		var scalefac = random_range(0.6,0.75);
		image_xscale = scalefac
		image_yscale = scalefac
		image_speed = 0.6
		team = other.team
		creator = other.creator
		force *= 1 + _c * 3
		sound_play(sndExplosion)
		repeat(round(scalefac*10)){ with instance_create(x,y,Dust) {sprite_index = sprExtraFeet; motion_add(random(360),3)}}
	}
	var _a = random(360)
	repeat(3 + 2 * _c){
		with instance_create(x+lengthdir_x(36,_a),y+lengthdir_y(36,_a),AcidStreak){
			sprite_index = global.sprSonicStreak
			image_angle = _a - 90
		}
		_a += 120 - 48 * _c
	}

#define init
global.sprPushPiston1   = sprite_add_weapon("sprites/weapons/sprPushPiston1.png",  2, 2);
global.sprPushPiston2   = sprite_add_weapon("sprites/weapons/sprPushPiston2.png",  4, 2);
global.sprPushPiston3   = sprite_add_weapon("sprites/weapons/sprPushPiston3.png",  6, 2);
global.sprPushPiston4   = sprite_add_weapon("sprites/weapons/sprPushPiston4.png",  8, 2);
global.sprPushPistonHUD = sprite_add_weapon("sprites/weapons/sprPushPiston4.png", 11, 4);
global.sprToothbrushShank = sprite_add("sprites/projectiles/sprHexNeedleShank.png", 4, -6, 4);

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_name
return "PUSH PISTON"

#define weapon_sprt
if instance_is(self, hitme){
	var _r = reload/weapon_get_load(mod_current)
	if _r <= 0 return global.sprPushPiston1;
	if _r <= .12 return global.sprPushPiston2;
	if _r <= .24 return global.sprPushPiston3;
	if _r > .24 return global.sprPushPiston4;
}
return global.sprPushPiston1;

#define weapon_sprt_hud
return global.sprPushPistonHUD;

#define nts_weapon_examine
return{
    "d": "Unleash a large quantity of kinetic energy on both ends. ",
}

#define weapon_type
return 4;

#define weapon_auto
return mod_script_call_nc("mod", "defpack tools", "abris_weapon_auto", "piston charge", self)

#define weapon_load
return 22;

#define weapon_cost
return 1;

#define weapon_reloaded
sound_play_pitchvol(sndSpiderMelee, .6, .35);

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 3;

#define weapon_chrg
return 1

#define weapon_text
return "FAST TRAVEL";
#define weapon_fire
	with instance_create(x,y,CustomObject){
	
		sound   = sndCrossReload;
		name    = "piston charge";
		creator = other;
		
		charge    = 0;
		charged   = 0;
		maxcharge = 25;
		
		defcharge = {
	
			style : 2,
			width : 13,
			charge : 0,
			maxcharge : maxcharge
		}
		
		depth = TopCont.depth;
		index = creator.index;
		accuracy = other.accuracy;
		on_step    = piston_step;
		on_destroy = piston_destroy;
		on_cleanup = piston_cleanup;
		reload = -1;
		btn = other.specfiring ? "spec" : "fire";
		hand = other.specfiring and other.race == "steroids";
	}

#define piston_step
	// Delete self if creator doesnt exist:
	if !instance_exists(creator){instance_delete(self); exit}

	x = creator.x + creator.hspeed;
	y = creator.y + creator.vspeed;

	// Refund spent ammo on swap (cancel charge):
	if (button_check(creator.index, "swap") && (creator.canswap = true || creator.bwep != 0)) {
		
		var _t = weapon_get_type(mod_current);
		
		creator.ammo[_t] += weapon_get_cost(mod_current);
		if creator.ammo[_t] > creator.typ_amax[_t] creator.ammo[_t] = creator.typ_amax[_t];
		
		instance_delete(self);
		exit;
	}

	var _timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale,
	    _reloadspd = weapon_get_load(mod_current) + mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * _timescale;

	// Freeze reloadspeed:
	if(reload = -1) {
		
	    reload = hand ? creator.breload : creator.reload;
	    creator.reload = _reloadspd; 
	}
	else {
		
	    if hand creator.breload = max(_reloadspd, reload);
	    else creator.reload = max(reload, _reloadspd);
	}
	
	view_pan_factor[index] = 3 + (charge/maxcharge * 2);
	defcharge.charge = charge;
	
	if(button_check(index, btn)) {
		
		// Do this while charging:
	    if(charge < maxcharge) {
	    
		    charge += _timescale * 3;
		    charged = 0
		    
		    // Charge sound:
        	if(charge > maxcharge * .2) { 
        	
        		sound_play_pitchvol(sound,.2 + (charge/maxcharge) * .35, .7);
        	}	
		}
    	else {

			// On-weapon fx:
			if(current_frame mod 6 < current_time_scale) {
				
				creator.gunshine = 1;
				with defcharge blinked = 1;
			}
			
			charge = maxcharge;
			
			// Arrow drawing:
			if(!charged) {
			
				mod_script_call_self("mod","defpack tools", "weapon_charged", creator, 12);
				charged = 1;
			}
		}	
	}else{instance_destroy(); exit}
	
	// Reduce speed just a bit for gamefeel when charged:
	if(charged) {creator.speed *= .9}

#define piston_cleanup
	view_pan_factor[index] = undefined
	if !charged sound_stop(sound)

#define piston_destroy
	with instance_create(x + lengthdir_x(24, creator.gunangle), y + lengthdir_y(24, creator.gunangle), AcidStreak){
		image_angle = other.creator.gunangle;
		sprite_index = global.sprToothbrushShank;
	}with instance_create(x + lengthdir_x(12, creator.gunangle - 20), y + lengthdir_y(12, creator.gunangle - 20), AcidStreak){
		image_angle = other.creator.gunangle - 20;
		sprite_index = global.sprToothbrushShank;
		image_speed += .1;
	}with instance_create(x + lengthdir_x(12, creator.gunangle + 20), y + lengthdir_y(12, creator.gunangle + 20), AcidStreak){
		image_angle = other.creator.gunangle + 20;
		sprite_index = global.sprToothbrushShank;
		image_speed += .1;
	}
	var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
    reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale * 1.2
	var _ch = other.charged,
	     _c = 5 + 50 * _ch;

	if !charged sound_stop(sound)

	var _p = random_range(.8, 1.2);
	sound_play_pitchvol(sndImpWristKill, .6 * _p, 1.4);
	sound_play_pitchvol(sndGeneratorBreak, 2 * _p, 1.4);
	if _ch sound_play_pitchvol(sndSuperBazooka, 2 * _p, .6);

	with creator{
		weapon_post(12 + _ch * 8, 24 + _ch * 16, 12 + _ch * 8);
		sleep(30 * _ch);
	}

	with mod_script_call("mod","defpack tools","create_sonic_explosion",creator.x + lengthdir_x(18, creator.gunangle),creator.y + lengthdir_y(18, creator.gunangle)){
		with instance_create(x, y, BubblePop){
			image_index = 1;
			with instance_create(x, y, ImpactWrists) image_speed = 1
		}
		image_xscale = 2
		image_yscale = 2
		damage = 0;
		image_speed = 0.6
		superfriction = 1.4 / (1.2 + _ch *.5);
		sprite_index = mskNone;
		image_index = 2;
		image_speed = 2;
		mask_index = mskExploder
		//superdirection = other.gunangle
		team = other.creator.team
		creator = other.creator
		force = 22 + _ch * 8;
		fx_check = false;
		superdirection = creator.gunangle;
		dontwait = true;
		can_crown = false;
		var _e = self;
		with instances_matching_ne(hitme, "team", other.creator.team){
			if !_e.fx_check && distance_to_object(other) <= 0{
				sound_play(snd_hurt);
				sprite_index = spr_hurt;
				sleep(100);
				_e.fx_check = true;
			}
		}
	}
	extraspeed_add(creator, _c, creator.gunangle + 180);

#define extraspeed_add(_player, __speed, _direction) return mod_script_call("mod", "defpack tools", "extraspeed_add", _player, __speed, _direction);
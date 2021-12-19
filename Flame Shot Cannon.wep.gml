#define init
global.sprShotCannon = sprite_add_weapon("sprites/weapons/sprFlameShotCannon.png", 4, 2);
global.sprShotBullet = sprite_add("sprites/projectiles/sprFireShot.png",3,12,12)
global.sndShotHit = sound_add("sounds/sndShotHit.ogg");
sprite_collision_mask(global.sprShotBullet,1,1,0,0,0,0,0,0)

#define weapon_name
return "FLAME SHOT CANNON";

#define weapon_sprt
return global.sprShotCannon;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 35;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 9;

#define weapon_text
return "FIRE STRING";

#macro maxspeed 12

#define weapon_fire
	weapon_post(7,43,0)
	
	var _p = random_range(.8, 1.2);
	sound_play_pitch(sndFlakCannon,1.2 * _p)
	sound_play_pitchvol(sndFlakExplode,.6 * _p,.8)
	sound_play_pitch(sndDoubleFireShotgun,1.2 * _p)
	
	with instance_create(x + lengthdir_x(12, gunangle),y + lengthdir_y(12, gunangle), CustomProjectile) {
		
		sprite_index = global.sprShotBullet;
		mask_index   = mskFlakBullet;
		image_speed  = .25;
		depth        = -1;
		
		move_contact_solid(other.gunangle, 6);
		motion_set(other.gunangle + random_range(-3, 3) * other.accuracy, maxspeed);
		friction = .6;
		
		team       = other.team;
		creator    = other;
		damage     = 6;
		force      = 4;
		accuracy   = other.accuracy;
		wallbounce = 8 + skill_get(mut_shotgun_shoulders) * 12;
		
		ortimer = 10
		hitammo = ortimer
		ftimer = 1.5
		time = ftimer
		canshoot = 0
		dirfac = random(359)
		sage_no_bounce = true;
		
		hitenemies    = []; // List of recently hit enemies
		hitenemiesmax = 1; // Remember up to this many enemies
		target_margin = 128; // aims at enemies up to this range
		
		on_hit     = script_ref_create(cannon_hit);
		on_wall    = script_ref_create(cannon_wall);
		on_step    = script_ref_create(cannon_step);
		on_draw    = script_ref_create(cannon_draw);
		on_anim    = cannon_anim
		
	}

#define cannon_anim
	image_index = 1

#define cannon_wall
	view_shake_at(x, y, 12);
	sound_play_pitch(sndShotgunHitWall, .8);
	
	// Randomly dont bounce off of walls (makes it stick to it instead);
	if (!irandom(1)) {
		
		move_bounce_solid(false);
	}
	hitenemies = []
	cannon_target(-1);
	cannon_fire();
	
	if hitammo <= 0 {
		
		instance_destroy();
	}

#define cannon_fire()

	dirfac += 14;
	hitammo -= 1;
	
	sound_play_pitch(sndShotgun, 1 * random_range(1.2, .8));
	sound_play_pitch(sndPopgun, .7 * random_range(1.2, .8));
	
	var  _angle = dirfac,
	    _amount = 5;
	repeat (_amount) {
		
		with instance_create(x, y, FlameShell) {
			
			motion_set(_angle + random_range(-4, 4) * other.accuracy, 11 + 1 * skill_get(mut_shotgun_shoulders));
			team    = other.team;
			creator = other.creator;
			
			_angle += 360 / _amount;
			
			image_angle = direction;
		}
	}

#define cannon_target(DIRECTION)

	// Change direction based on target:
	var _t = nearest_enemy();
	if (_t > -4) {
			
		direction = point_direction(x, y, _t.x, _t.y);
			
	}
	else {
		
		if (DIRECTION != -1) {	
		
			direction = DIRECTION;
		}
	}
		
	// Reset speed with wallbounce:	
	var _spd = maxspeed - speed;
	if (_spd > 0) {
				
		var _diff = min(wallbounce, _spd);
		speed += _diff;
		wallbounce -= _diff;
	}
	
#define cannon_hit
	
	// Check if enemy has been hit recently:
	var _canhit = (array_find_index(hitenemies, other) == -1);
	
	if (_canhit) {
		
		// Enemy hit stuff:
		x = xprevious;
		y = yprevious;
		projectile_hit_push(other, damage + (speed > 9 ? 2 : 0), force);
		cannon_fire();
		
		sound_play_pitchvol(global.sndShotHit, random_range(.85, 1.3), 1.5);
		view_shake_at(x, y, 5);
		
		// Enter enemy to list
		array_push(hitenemies, other)
		
		// Toss out oldest entry
		if (array_length(hitenemies) > hitenemiesmax) {
			hitenemies = array_slice(hitenemies, 1, hitenemiesmax)
		}
		
		cannon_target(random(360));
		
		if (hitammo <= 0) {
			
			instance_destroy();
		}
	}

#define cannon_step

	with instances_matching(Slash, "team", team){
		if (place_meeting(x, y, other)) {
			with other{
				motion_add(other.direction, maxspeed);
				
				time = ftimer;
				cannon_fire();
				
				with instance_create(x, y, Deflect) {
					image_angle = other.direction;
					sound_play_pitchvol(sndFlakExplode, .6, .8);
					sound_play_pitchvol(sndShotgun, 1, .8);
				}
				sleep(30);
				view_shake_at(x, y, 4);
			}
		}
	}
	
	with instances_matching(instances_matching(CustomSlash, "candeflect", true), "team", team){
		if (place_meeting(x, y, other)) {
			with other{
				motion_add(other.direction, maxspeed);
				
				time = ftimer;
				cannon_fire();
				
				with instance_create(x, y, Deflect) {
					image_angle = other.direction;
					sound_play_pitchvol(sndFlakExplode, .6, .8);
					sound_play_pitchvol(sndShotgun, 1, .8);
				}
				sleep(30);
				view_shake_at(x, y, 4);
			}
		}
	}

	image_angle += (5 + speed * 3) * current_time_scale;
	time -= current_time_scale;

	image_xscale = clamp(image_xscale + (random_range(-.05, .05) * current_time_scale), 1.2, 1.4);
	image_yscale = image_xscale;
	
	if (hitammo = 4) {
		
		ftimer = 3;
	}
	if (speed <= 1) {
		
		canshoot = 1;
		speed = 0;
	}

	while (time <= 0) {
		
	    time += ftimer;
	    
	    if canshoot {
	    	
			view_shake_at(x, y, 5);
			cannon_fire();
				
			if (hitammo <= 0) {
					
				instance_destroy();
				exit;
			}
		}
	}

#define cannon_draw
	if (image_index = 0) {
		
		var i = .4;
	}else {
		
		var i = .1;
		
		if (speed > 9) {
			
			i += .1;
		}
	}
	draw_sprite_ext(sprite_index, image_index, x, y, .7*image_xscale+i, .7*image_yscale+i, image_angle, image_blend, 1.0);
	draw_set_blend_mode(bm_add);
	draw_sprite_ext(sprite_index, image_index, x, y, 1.25*image_xscale+i*2, 1.25*image_yscale+i*2, image_angle, image_blend, i);
	draw_set_blend_mode(bm_normal);

#define nearest_enemy()

	var _target = -4,
	    _origin = self,
		_distance = _origin.target_margin;
	with instances_matching_ne(enemy, "team", _origin.team) {
		
		var _x = x + hspeed_raw,
	        _y = y + vspeed_raw;
		
		// Check if in line of sight:
		if (collision_line(_x, _y, _origin.x, _origin.y, Wall, false, false) > -4) {			
			continue;
		}
		
		// Check if has been recently hit:
		if array_find_index(_origin.hitenemies, self) != -1 {
			continue;
		}
		
		// Distance check:
		var tempDist = point_distance(_x, _y, _origin.x, _origin.y);
		if (tempDist > _distance) {
			continue;
		}
		
		// No target has been set:
		if (_target = -4) {
			
			_target = self;
		}
		else {
			
			// Compare wich target is closer:
			if (tempDist < _distance ) {
				_target = self;
				_distance = tempDist
			}
		}
	}
	return _target;
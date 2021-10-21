#define init

	global.rockletCount = 0
	global.lastRockletSound = 0
	global.HUDRequests = []

	var i = "../sprites/projectiles/";
	global.spr = {}

	//Sprites, sorted by ammo type, misc at the bottom
	with spr {

		//Rocklets
		Rocklet      = sprite_add(i + "sprRocklet.png", 2, 1, 6);
		RockletFlame = sprite_add(i + "sprRockletFlame.png", 0, 8, 3);
	
	}
	
#macro spr global.spr
#macro msk global.spr.msk
#macro snd global.spr.snd


#define request_hud_draw(scriptRef)
	array_push(global.HUDRequests, scriptRef)

#define draw_gui
	for (var i = 0, l = array_length(global.HUDRequests); i < l; i++) {
		script_ref_call(global.HUDRequests[i])
	}
	if l > 0 {
		global.HUDRequests = []
	}

#define angle_approach(a, b, n, dn)
return angle_difference(a, b) * (1 - power((n - 1)/n, dn))

#define bullet_anim
	image_index = 1
	image_speed = 0

#define sound_play_hit_big_ext(_sound, _pitch, _volume)
	var s = sound_play_hit_big(_sound, 0);
	sound_pitch(s, _pitch);
	sound_volume(s, audio_sound_get_gain(s) * _volume);
	return s;

	
// Returns a LWO with three fields:
//	x and y: world space coordinates.
//	is_input: indicates whether the coordinates should be treated as an active control source.
//		A nuke for example might ignore the coords if they aren't coming from an actual mouse, as enemies don't really aim over time.
// Used for logic and should be syncronous.
// Of note, the format of the LWO and scr_get_mouse integration are what make this important, thats what ought to be standard.
// If you don't like other choices, feel free to replace them. 
#define object_get_mouse(inst)
	//Compat hook. If you need self, be sure to include it in your script ref as an argument.
	//Return a LWO in your script that would match the output of this one.
	//You can return to the default behavior by setting scr_get_mouse to something that isn't a script reference.
	if "scr_get_mouse" in inst && is_array(inst.scr_get_mouse) {
		with inst return script_ref_call(scr_get_mouse)
	}
	
	//If there is a mouse at play, use it.
	if instance_is(inst, Player) || ("index" in inst && player_is_active(inst.index)) {
		return {x: mouse_x[inst.index], y: mouse_y[inst.index], is_input: true}
	}
	
	//If there is a target, consider it the mouse position.
	if "target" in inst && instance_exists(inst.target) {
		return {x: target.x, y: target.y, is_input: false}
	}
	
	//If no real way to find mouse coords is found, then make some assumptions regarding generally intended behavior.
	//In this case, project a point a moderate distance from the source, with direction as the default angle, optionally picking up gunangle.
	var _length = 48, _dir = inst.direction;
	if "gunangle" in inst {
		_dir = inst.gunangle;
	}

	return {x: inst.x + lengthdir_x(_length, _dir), y: inst.y + lengthdir_y(_length, _dir), is_input: false}

// WOOO TRIG AND ALGEBRA WOOOOOOO
#define rotate_around_point(center, point, angle)
    var _sin = dsin(angle),
        _cos = dcos(angle);
    
    return {
        x: (point.x - center.x)*_cos - (point.y - center.y)*_sin + center.x,
        y: (point.x - center.x)*_sin + (point.y - center.y)*_cos + center.y
    }



#define create_rocklet(_x,_y)
with instance_create(_x, _y, CustomProjectile) {
    sprite_index = spr.Rocklet
    damage = 3
    name = "Rocklet"
    maxspeed = 14
    immuneToDistortion = 1;
    typ = 1
    depth = -1
    
    goal = -1
    phase = 0
    friction = .2
    slidetime = random(360)
    slidelength = 1 + random(1)
    // Used to seed rocklet speeds, see guns.
    rocklet_number = ++global.rockletCount;
    // Why not?
    bounce = 0
    // Used for the Hydra
    transform_mouse = -1
    // Used to reduce the amount of trails created
    lastTrail = {x: _x, y: _y}
    makeTrail = false
    
    on_step = rocklet_step
    on_end_step = rocklet_end_step
    on_destroy = rocklet_destroy
    on_anim = bullet_anim
    on_draw = rocklet_draw
    on_wall = rocklet_wall
    return id
}

#define sound_play_rocklet()
	var vol = .8;
	//Reduces the volume so the sounds stack a little less aggressively
	if global.lastRockletSound == current_frame {
		vol = .4
	}
	global.lastRockletSound = current_frame
	
	// Uses audio functions so the sounds can stack
	var q = audio_play_sound(sndRocket, 0, 0); //Play sound
	audio_sound_pitch(q, 1 + random_nonsync(.2))  //Pitch
	audio_sound_gain(q, (0.8 + random_nonsync(.1)) * vol, 0)  //Volume
	audio_sound_set_track_position(q, .25) //Starting position
	
	q = audio_play_sound(sndToxicBoltGas, 0, 0);
	audio_sound_pitch(q, 1 + random_nonsync(.4)) //Pitch
    audio_sound_gain(q, vol, 0) //Volume


#define rocklet_step
	//Point towards goal, direction is locked in once boosters start
	if phase = 0 && instance_exists(creator) {
		if goal = -1 {
			goal = object_get_mouse(creator)
			if is_array(transform_mouse) goal = script_ref_call(transform_mouse, self, goal)
		}
		image_angle = point_direction(x, y, goal.x, goal.y)
	}
	//Start boosters
	if phase = 0 && speed <= 0 {
		phase = 1
		direction = image_angle
		sound_play_rocklet()
		repeat(irandom(2) + 1) with instance_create(x, y, Dust) {
			motion_set(other.direction + random_range(-30, 30), random(1))
			friction = -.2 + random(.2)
		}
		lastTrail.x = x
		lastTrail.y = y
		//Start accelerating
		friction = -1.2
		speed = 1
	}
	//Boosters active, slide around on a sine wave
	if phase = 1 {
		if instance_exists(creator) {
			var mouse = object_get_mouse(creator);
			if mouse.is_input {
				if is_array(transform_mouse) mouse = script_ref_call(transform_mouse, self, mouse)
				if abs(angle_difference(direction, point_direction(x, y, mouse.x, mouse.y))) < 100 {
					var dif = angle_approach(direction, point_direction(x, y, mouse.x, mouse.y), 6, current_time_scale)
					direction -= dif;
					if abs(dif) >= 8 makeTrail = true
					image_angle = direction
				}
			}
		}
		// dX = timescale
		slidetime += current_time_scale
		// dY/dX * sin(x) = cos(x), therefor dY * sin(x) = dX * cos(x), i think.
		var l = slidelength * dcos(slidetime * 20) * current_time_scale;
		x += lengthdir_x(l, direction + 90);
		y += lengthdir_y(l, direction + 90);
	}
	if speed > maxspeed
		speed = maxspeed

#define rocklet_end_step
	if phase = 1 {
		if makeTrail {
			create_rocklet_trail(x, y, lastTrail.x, lastTrail.y).image_yscale = slidelength/2
			lastTrail.x = x
			lastTrail.y = y
		}
		makeTrail = !makeTrail
	}
	
#define rocklet_wall
	if phase = 0  || speed < 2{
		move_bounce_solid(false)
		if phase != 0 image_angle = direction
	}
	else {
		if bounce-- > 0 {
			move_bounce_solid(false)
			image_angle = direction
		}
		else instance_destroy()
	}

#define rocklet_destroy
	sound_play_hit_big_ext(sndExplosion, 2.5 * random_range(.8, 1.2), .8)
	with instance_create(x, y, SmallExplosion)
		damage = 3

#define rocklet_draw
	draw_self()
	if phase = 1 draw_sprite_ext(spr.RockletFlame, -1, x, y, 1, 1, point_direction(x, y, xprevious, yprevious) + 180, c_white, image_alpha)


#define create_rocklet_trail(x, y, x2, y2)
	with instance_create(x, y, CustomObject) {
		depth = 0
		name = "RockletTrail"
		sprite_index = sprBoltTrail
		image_xscale = point_distance(x, y, x2, y2)
		image_angle = point_direction(x, y, x2, y2)
		image_yscale = 1
		
		on_step = rocklet_trail_step
		
		return self
	}
	
#define rocklet_trail_step
	// image_blend = merge_color(image_blend, c_dkgray, .2 * current_time_scale)
	if image_yscale > .3 {
		image_yscale *= power(.8, current_time_scale)
	}
	else {
		image_yscale -= .15 * current_time_scale
	}
	image_alpha = image_yscale + .2
	if image_yscale <= 0 {
		instance_destroy()
	}
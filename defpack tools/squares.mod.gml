#define init

	global.HUDRequests = []
	
	#macro squareCounter global.squareCounter
	squareCounter = ds_map_create();
	#macro ringArray global.ringArray
	ringArray = []
	#macro indexArray global.indexArray
	indexArray = []
	#macro squareMax global.squareMax
	squareMax = 0
	
	global.boostedDevastators = []

	var i = "../sprites/projectiles/";
	global.spr = {}
	msk = {}

	with spr {

		Square      = sprite_add(i + "sprNewSquare.png", 4, 4, 4);
		SquareShell = sprite_add(i + "sprSquareShell.png", 2, 8, 8);
		SquareShellDisappear = sprite_add(i + "sprSquareShellDisappear.png", 5, 8, 8)
		SquareShank = sprite_add_precise(i + "sprSquareShank.png", 4, -5, 8)

		SquareImpactSmall = sprite_add(i + "sprSquareImpactSmall.png", 7, 8, 8);
		msk.SquareImpactSmall = sprite_add_precise(i + "mskPlasmaImpactSmall.png", 7, 8, 8);
		SquareImpactLarge = sprite_add(i + "sprSquareImpact.png", 7, 16, 16)
	
	}
	with instances_matching(CustomSlash, "name", "Square") sprite_index = spr.Square
	
	
	#macro dev false
	if dev {
		if mod_exists("mod", "defpackloader") {
			mod_script_call("mod", "defpackloader", "add_post_load_statement", "Squares mod has loaded in dev mode", c_yellow)
		}
		else trace_color("Squares mod has loaded in dev mode", c_yellow)
	}
	
#macro spr global.spr
#macro msk global.spr.msk


#define sprite_add_precise(sprite, subimages, xoffset, yoffset)
	var q = sprite_add(sprite, subimages, xoffset, yoffset)
	if fork(){
		var t = sprite_get_texture(q, 0),
		    w = 150;

		while(t == sprite_get_texture(q, 0) && w-- > 0){
		    wait 0;
		}
	    sprite_collision_mask(q, 1, 1, 0, 0, 0, 0, 0, 0)
	    exit
	}
	return q


// DEBUG {
#define trace_lwo_start(lwo, _x, _y)
	trace_lwo(lwo, {x: _x, y: _y})

#define trace_lwo(lwo, pos)
	for (var i = 0, l = lq_size(lwo); i < l; i++) {
		var value = lq_get_value(lwo, i),
			key =   lq_get_key(lwo, i) + " : ";
		
		if is_object(value) {
			key += "{"
		}
		else {
			key += string(value)
		}
		
		draw_line_pos(pos, key)

		if is_object(value) {
			pos.x += 6
			trace_lwo(value, pos)
			pos.x -= 6
			draw_line_pos(pos, "}")
		}
	}
	
#define draw_line_pos(pos, text)
	draw_text_nt(pos.x, pos.y, text)
	pos.y += string_height(text) + 1
// DEBUG }

#define game_start
	ds_map_clear(global.squareCounter)

#define angle_approach(a, b, n, dn)
return angle_difference(a, b) * (1 - power((n - 1)/n, dn))

#define bullet_anim
	image_index = image_number-1
	image_speed = 0
	
#define nothing

#define sound_play_hit_big_ext(_sound, _pitch, _volume)
	var s = sound_play_hit_big(_sound, 0);
	sound_pitch(s, _pitch);
	sound_volume(s, audio_sound_get_gain(s) * _volume);
	return s;

	
// WOOO TRIG AND ALGEBRA WOOOOOOO
#define rotate_around_point(center, point, angle)
    var _sin = dsin(angle),
        _cos = dcos(angle);
    
    return {
        x: (point.x - center.x)*_cos - (point.y - center.y)*_sin + center.x,
        y: (point.x - center.x)*_sin + (point.y - center.y)*_cos + center.y
    }
    
    
#macro default_bloom {
        xscale : 1.5,
        yscale : 1.5,
        alpha : .1
    };

#macro bloom_2x {
        xscale : 2,
        yscale : 2,
        alpha : .1
    };


    
#macro easeFunction easeInBack

//Got these from easings.net
#define easeOutBack(n) 
#macro c1 1.70158;
#macro c3 c1 + 1;

return 1 + c3 * power(n - 1, 3) + c1 * power(n - 1, 2);

#define easeInBack(x)
return c3 * x * x * x - c1 * x * x;

#define easeOutElastic(x)
#macro c4 (2 * pi) / 3;

return x == 0
  ? 0
  : x == 1
  ? 1
  : power(2, -10 * x) * sin((x * 10 - 0.75) * c4) + 1;

#define easeInOutCubic(x)
return x < 0.5 ? 4 * x * x * x : 1 - power(-2 * x + 2, 3) / 2;



#define step
	if dev && instance_exists(Player) {
		if button_check(0, "horn") {
			with create_square(mouse_x[0], mouse_y[0]) {
				team = Player.team
				creator = Player.id
				motion_set(random(360), random(6))
			}
		}
	}
	
	if instance_exists(GameCont) && GameCont.timer mod 1 < current_time_scale {
		//Remove nonexistant projectiles from list
		global.boostedDevastators = instances_matching_ne(global.boostedDevastators, "id", null);
		
		if array_length(global.boostedDevastators) > 0 {
			//Spawn square explos on boosted devastator shots
			with (global.boostedDevastators) {
				var dir = random(360), length = random(15) + 15;
				with create_square_explo(x + lengthdir_x(length, dir), y + lengthdir_y(length, dir)) {
					team = other.team
					creator = other.creator
					image_angle = random(360)
				}
			}
		}
	}
	

#define create_square(x, y)
	with instance_create(x, y, CustomSlash) {
		name = "Square"
		sprite_index = spr.Square
		
		damage = 5
		force = 4
		typ = 0
		image_speed = random_range(.3, .5)
		image_angle = random(360)
		motion_set(random(360), random(2))
		friction = .3
		defbloom = default_bloom
		
		pseudo_team = -1
		
		// lerp_progress = 0
		can_lerp = false
		// lerp_xstart = x
		// lerp_ystart = y
		// in_orbit = false
		// last_count = 0
		// last_total = 1
		// last_ring = 0
		
		square_speed = 0
		
		on_hit = square_hit
		on_step = square_step
		on_destroy = square_destroy
		on_projectile = square_projectile
		on_grenade = nothing
		on_anim = square_anim
		on_wall = square_wall
		
		return self
	}

#define square_anim
	bullet_anim()
	can_lerp = true
	speed = 0
	
#define square_wall
	move_outside_solid(point_direction(x, y, creator.x, creator.y), 8 * current_time_scale)

#define square_step
	if !instance_exists(creator) {
		instance_destroy()
		exit
	}
	
	if (team != id) {
		pseudo_team = team
		team = id
	}
	
	// //Part of the complicated orbiting code
	// if lerp_progress < 1 && can_lerp {
	// 	lerp_progress += .06 * current_time_scale
	// 	if lerp_progress >= 1 {
	// 		square_finish_lerp()
	// 		lerp_progress = 1
	// 	}
	// }
	
	//Overly complicated orbiting code
	if can_lerp {
		var squares = get_square_numbers(creator);
	
		#macro startingAmount 0;
		#macro squarePerRing 10;
	
		var ring = get_square_ring(squares.count),
			totalRings = get_square_ring(squares.total),
			ringTotal = ring < totalRings ? (squarePerRing * ring + startingAmount) : (get_square_ring_slot(squares.total)),
			ringSlot = get_square_ring_slot(squares.count),
			angOff = 360/(ringTotal),
			flip = ((ring mod 2) * 2 - 1),
			angle = (angOff * ringSlot) + GameCont.timer * 2 * flip;
	
		//amount of squares in ring * size of square/2*pi (divided bc its radius in terms of circumference)
		//wrote this before i did the ring system
		// var r = max((squares.total * 8)/(2*pi), 12),
		var r = max(12, (16 * (ring)) + (ringTotal * 2/(2*pi))),
			wantX = creator.x + lengthdir_x(r, angle) + creator.hspeed,
			wantY = creator.y + lengthdir_y(r, angle) + creator.vspeed;
			
		// WHO WOULD WIN ?
		// FIVE LINES OF CODE
		var distance = point_distance(x, y, wantX, wantY),
			dir = point_direction(x, y, wantX, wantY);
		
		square_speed = clamp(square_speed + 1 * current_time_scale, 0, distance/2);
		
		if place_free(x + lengthdir_x(square_speed, dir), y) x += lengthdir_x(square_speed, dir)
		if place_free(x, y + lengthdir_y(square_speed, dir)) y += lengthdir_y(square_speed, dir)
		// speed = square_speed
		// direction = dir
		
		
		// OR FOURTY LINES OF NONSENSE
		
		// if in_orbit && (last_count != squares.count || (last_total != squares.total && ring == last_ring)) {
		// 	if lerp_progress >= .7 {
		// 		lerp_count = last_count
		// 		lerp_total = last_total
		// 		lerp_progress = 0
		// 	}
		// 	lerp_progress = max(0, lerp_progress - .2)
		// 	// trace(squares.count, last_count, squares.total, last_total)
		// }
		// if in_orbit && lerp_progress < 1 {
		// 	var Lerp_ring = get_square_ring(lerp_count),
		// 		Lerp_totalRings = get_square_ring(lerp_total),
		// 		Lerp_ringTotal = Lerp_ring < Lerp_totalRings ? (squarePerRing * Lerp_ring + startingAmount) : (get_square_ring_slot(lerp_total)),
		// 		Lerp_ringSlot = get_square_ring_slot(lerp_count),
		// 		Lerp_angOff = 360/(Lerp_ringTotal),
		// 		Lerp_flip = ((Lerp_ring mod 2) * 2 - 1),
		// 		Lerp_angle = (Lerp_angOff * Lerp_ringSlot) + current_frame * 2 * Lerp_flip;
				
		// 	var r = max(14, (16 * (Lerp_ring)) + (Lerp_ringTotal * 2/(2*pi)));
		// 	lerp_xstart = creator.x + lengthdir_x(r, Lerp_angle) + creator.hspeed;
		// 	lerp_ystart = creator.y + lengthdir_y(r, Lerp_angle) + creator.vspeed;
	
		// }
		
		// if lerp_progress < 1 {
		// 	if !in_orbit {
		// 		x = lerp(lerp_xstart, wantX, easeOutBack(lerp_progress))
		// 		y = lerp(lerp_ystart, wantY, easeOutBack(lerp_progress))
		// 	}
		// 	else {
		// 		x = lerp(lerp_xstart, wantX, easeInOutCubic(lerp_progress))
		// 		y = lerp(lerp_ystart, wantY, easeInOutCubic(lerp_progress))
		// 	}
		// }
		// else {
		// 	x = wantX
		// 	y = wantY
		// }
		
		// last_count = squares.count
		// last_total = squares.total
		// last_ring = ring
	}

	image_angle -= current_time_scale * flip
	
#define square_finish_lerp
	in_orbit = true

#define square_hit
	if other.team != pseudo_team {
		projectile_hit_push(other, damage, force)
		instance_destroy()
	}

#define square_projectile
	var proj = other, square = self;
	if other.team == pseudo_team {
		if "on_square" in other {
			script_ref_call(other.on_square, square, proj)
		}
		else if "square_boosted" not in other {
			var dontMark = false;
			switch (other.object_index) {
				
				case Laser:
					//Split the laser into three
					var onLaser = nearest_point_on_line({x: proj.xstart, y: proj.ystart, dir: proj.image_angle}, square);
					proj.image_yscale = max(proj.image_yscale, 1)
					for (var i = -1; i <= 1; i+= 2) {
						with instance_create(onLaser.x, onLaser.y, Laser) {
							team = other.pseudo_team
							creator = other.creator
							image_angle = proj.image_angle + i * 20
							square_boosted = true
							alarm0 = 1
						}
					}
					instance_destroy()
					break
					
				case PlasmaBall:
					//Take squares away from the player and have them orbit the plasma
					var fellowSquares = instances_matching_ne(instances_matching(instances_matching(CustomSlash, "name", "Square"), "creator", creator), "id", square),
						l = array_length(fellowSquares),
						taken = [square];
					if (l > 0) {
						repeat(min(4, l)) {
							array_push(taken, fellowSquares[irandom(l-1)])
						}
					}
					with taken {
						damage += 2
						creator = proj
					}
					if mod_exists("mod", "defpack tools") {
						with taken on_destroy = ["mod", mod_current, "plasma_square_destroy"]
					}
					break
					
				case EnergySlash:
					//Fire the squares as 'shells'
					dontMark = true;
					with create_square_shell(x, y) {
						motion_set(proj.direction, 20)
						image_angle = direction
						projectile_init(square.pseudo_team, square.creator)
					}
					instance_destroy()
					break
					
				case EnergyShank:
					//Accelerate the shank
					with proj {
						speed += 30
						friction += 3
						image_index = 0
						sprite_index = spr.SquareShank
					}
					instance_destroy()
					break
					
				case EnergyHammerSlash:
					//CONSIDER: Square Slugs instead of this
					//Convert squares to ammo
					dontMark = true
					if "ammo" in proj.creator {
						var ammo = proj.creator.ammo,
							amax = proj.creator.typ_amax;
						if ammo[5] < amax[5] {
							ammo[5] = min(ammo[5] + 1, amax[5])
							instance_destroy()
						}
					}
					break
				
				case Devastator:
					//Grant the devastator Square Explos
					var ownedSquares = instances_matching(instances_matching(CustomSlash, "name", "Square"), "creator", creator);
					#macro devastatorCost 6
					if array_length(ownedSquares) >= devastatorCost {
						with array_slice(ownedSquares, 0, devastatorCost) {
							instance_destroy()
						}
						proj.devastator_square_boost = true
						array_push(global.boostedDevastators, proj)
					}
					else {
						dontMark = true
					}
					break
			}
			if dontMark == false {
				proj.square_boosted = true
			}
		}
	}


#define square_destroy

	var s = audio_play_sound(sndPlasmaHit, 1, 0);
	audio_sound_gain(s, .5, 0)
	audio_sound_pitch(s, random_range(3, 6))

	var n = irandom_range(3, 6), int = 360/n;
	for (var i = 0; i < 360; i += int) {
	    with mod_script_call("mod", "defparticles", "create_spark", x, y) {
	        gravity = 0
	        friction = 1.2
	        motion_set(i + random_range(-int/3, int/3), random(8) + 1)
	        age = speed
	        color = c_white
	        fadecolor = c_lime
	    }
	}




//Orbital Math {
//Gets the ring of the square from its square number (which square it is)
#define get_square_ring(squareNumber)
	check_square_max(squareNumber)
	return ringArray[squareNumber-1]

//Gets the index of the square in its ring from the square number
#define get_square_ring_slot(squareNumber)
	check_square_max(squareNumber)
	return indexArray[squareNumber-1]

//Caches the values of the fucked up math functions so squares can be fast. As it would happen, this is a fixed sequence so an array is fine.
#define check_square_max(squareNumber)
	while (squareMax < squareNumber) {
		squareMax++
		array_push(ringArray, get_ring_index(squareMax))
		array_push(indexArray, get_index_of_orbital_in_ring(squareMax))
	}


//Gets the ring of the square from its square number (which square it is)
#define get_ring_index(orbital)

	if orbital <= squarePerRing {
		return 1
	}
	var count = 1,
		temp = orbital - startingAmount;
	while (squarePerRing * count < temp) {
		temp -= squarePerRing * count
		count++
	}
	return count
	
	

//Gets the index of the square in its ring from the square number
#define get_index_of_orbital_in_ring(orbital)
	var ring = 1,
		temp = orbital - startingAmount;
		
	while (temp - (squarePerRing * ring)) >= 0 {
		temp -= squarePerRing * ring
		ring ++
	}
	if temp == 0 return (ring-1) * squarePerRing
	return temp
	

#define get_square_numbers(creator)
	var squares = squareCounter[? creator];
	if (squares == undefined) {
		squares = {
			lastChecked: 0,
			count: 0,
			total: 1,
			lastTotal: 1
		}
		squareCounter[? creator] = squares
	}
	
	
	if squares.lastChecked != current_frame {
		squares.total = squares.lastTotal
		squares.lastTotal = max(1, squares.count)
		squares.lastChecked = current_frame
		squares.count = 0
	}
	squares.count += 1
	
	return {
		count: squares.count,
		total: squares.total
	}
//Orbital Math }

//Algebra moment
#define nearest_point_on_line(_line, _point)
//_line is anything with the variables x, y, and dir, being world position and direction, origin is the lines coordinates
//_point is anything with x and y, those being world position
var _slope = dtan(-_line.dir),
	_dx = _point.x - _line.x,
	_dy = _point.y - _line.y,
	_x = (_dx + _slope * _dy)/(sqr(_slope) + 1),
	_y = -1/_slope * _x + _dx/_slope + _dy;
	if (_slope == 0) _y = 0;
	return {x: _line.x + _x, y: (_line.y + _y)}


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



//Square adjacent projectiles

//Plasma Ball orbitals explode
#define plasma_square_destroy
	mod_script_call("mod", "defpack tools", "sound_play_hit_ext", sndPlasmaHit, random_range(1.45, 1.83), 1)
	with mod_script_call("mod", "defpack tools", "create_plasma_impact_small", x + lengthdir_x(hspeed, direction), y + lengthdir_y(hspeed, direction)) {
		team = other.pseudo_team;
		creator = other.creator
	}


//Square Shells (Created by Energy Slashes)
#define create_square_shell(x, y)
	with instance_create(x, y, CustomProjectile) {
		name = "SquareShell"
		
		mask_index = mskBullet2
		sprite_index = spr.SquareShell
		spr_disappear = spr.SquareShellDisappear
		image_speed = 1
		defbloom = {
			
			xscale : 2,
			yscale : 2,
			alpha : .1 + .1 * skill_get(mut_laser_brain)
		}
		
		typ = 2
		damage = 7
		force = 6
		friction = .25
		disappearing = false
		return_square = true
		timer = 60
		
		on_anim = square_shell_anim
		on_step = square_shell_step
		on_hit  = square_shell_hit
		on_wall = square_shell_wall
		
		return self;
	}
	
#define square_shell_anim
	if disappearing {
		instance_destroy()
	}
	else {
		image_speed = 0
		image_index = 1
	}

#define square_shell_step
	timer -= current_time_scale;
	if (timer < current_time_scale || (abs(speed) < friction))  && !disappearing {
		square_shell_disable()
	}

#define square_shell_disable
	disappearing = true
	sprite_index = spr_disappear
	image_speed = .4
	image_index = 0
	speed *= .2
	friction = .2
	if return_square {
		with create_square(x, y) {
			creator = other.creator
			team = creator.team
		}
	}
	
#define square_shell_hit
	if !disappearing {
		return_square = false
		projectile_hit(other, damage, force, direction)
		square_shell_disable()
	}
	
#define square_shell_wall
	if !disappearing {
		//Secret attfooy code (badass)
		move_contact_solid(direction + 180, 800)
		timer -= 1
		var q = sound_play_hit(sndHitWall, .2);
		sound_volume(q, .5)
		sound_pitch(q, 2)
	}
	
//Square Explos (used by Devastators and Ionizer)	
#define create_square_explo(x, y)
	with instance_create(x, y, CustomProjectile) {
		name = "SquareExplo"
		sprite_index = spr.SquareImpactSmall
		mask_index = msk.SquareImpactSmall
		
		defbloom = bloom_2x
		depth = -6
		image_speed = .4
		
		damage = 10
		force = 6
		typ = 0
		hitlist = [];
		
		view_shake_at(x, y, 1)
		
		on_step = square_explo_step
		on_hit = square_explo_hit
		on_anim = square_explo_anim
		on_wall = nothing
		
		return self
	}
	
#define create_large_square_explo(x, y)
	with create_square_explo(x, y) {
		name = "LargeSquareExplo"
		sprite_index = spr.SquareImpactLarge
		mask_index = mskPlasmaImpact
		
		force = 8
		
		return self
	}
	
#define square_explo_step
	if frac(GameCont.timer) < current_time_scale && image_index < 5 {
		if random(100) < 15 {
			instance_create(x, y, Smoke)
		}
	}

#define square_explo_hit
	if array_find_index(hitlist, other) == -1 {
		array_push(other, hitlist)
		projectile_hit_push(other, damage, force)
	}

#define square_explo_anim
	instance_destroy()
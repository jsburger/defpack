#define init
	global.lastAllyCacheTime = current_frame
	global.allyCache = []
	
	global.lastProjCacheTime = current_frame
	global.projCache = []
	
	global.spr = mod_variable_get("mod", "defpack tools", "spr")
	#macro spr global.spr
	
	global.scrTravel = script_ref_create(get_hitscan_target)
	global.scrGammaTravel = script_ref_create(get_gamma_target)
	global.scrGammaProjectile = ["mod", "defpack tools", "gamma_projectile"]
	#macro scrTravel global.scrTravel
	#macro scrGammaTravel global.scrGammaTravel
	#macro scrGammaProj global.scrGammaProjectile
	global.scrThunderHit = ["mod", "defpack tools", "new_thunder_hit"]
	global.scrFireDestroy= ["mod", "defpack tools", "fire_destroy"]
	
	vertex_format_begin()
	vertex_format_add_position()
	global.psyTrailFormat = vertex_format_end()
	
	global.sprAltShellBonus = sprite_add("../sprites/other/sprAltshellBonusEffect.png", 3, 5, 5)


#macro neurons skill_get("excitedneurons")

#macro hitscan_dis 300

#define get_hitscan_target()
/// get_hitscan_target(x1, y1, angle, team, dis = hitscan_dis)
var x1 = argument[0], y1 = argument[1], angle = argument[2], team = argument[3];
var dis = argument_count > 4 ? argument[4] : hitscan_dis;
    var noteam = get_ally_list(team);
    var shields = instances_matching(PopoShield, "team", team);
    with lasthit x += 10000
    with shields x += 10000
    with noteam x += 10000

    var _wall   = collision_line_first(x1, y1, x1 + lengthdir_x(dis, angle), y1 + lengthdir_y(dis, angle), Wall, 0, 0);

    if instance_exists(Wall) {
		if !place_meeting(_wall[0], _wall[1], Floor) {
			// trace("Missed first pass")
			_wall = collision_line_first(x1 + 1, y1 + 1, _wall[0] + 1, _wall[1] + 1, Wall, 0, 0)
			_wall[0] -= 1
			_wall[1] -= 1
			// Couldn't find a single instance of this missing twice, so no need to check again
			// if !place_meeting(_wall[0], _wall[1], Floor) {
			// 	trace("Missed second pass")
			// }
			// else {
			// 	trace("But found on second pass")
			// }
		}
    }

    var _shield = collision_line_first(x1, y1, _wall[0], _wall[1], PopoShield, 1, 1),
        _hitme  = collision_line_first(x1, y1, _shield[0], _shield[1], hitme, 0, 1);

    with lasthit x -= 10000
    with shields x -= 10000
    with noteam x -= 10000
    return _hitme;


#define collision_line_first(x1,y1,x2,y2,object,prec,notme)
//  Returns the instance id of an object colliding with a given line and
//  closest to the first point, or noone if no instance found.
// yo whats up jsburg here, made this shit return the point of collison as the first two indexes of the array, and the instance as the third
{
    var ox,oy,dx,dy,object,prec,notme,sx,sy,inst,i;
    ox = argument0;
    oy = argument1;
    dx = argument2;
    dy = argument3;
    object = argument4;
    prec = argument5;
    notme = argument6;
    sx = dx - ox;
    sy = dy - oy;
    inst = collision_line(ox,oy,dx,dy,object,prec,notme);
    if (inst != noone) {
        while ((abs(sx) >= 1) || (abs(sy) >= 1)) {
            sx *= .5;
            sy *= .5;
            i = collision_line(ox,oy,dx,dy,object,prec,notme);
            if (i) {
                dx -= sx;
                dy -= sy;
                inst = i;
            }else{
                dx += sx;
                dy += sy;
            }
        }
    }
    return [dx, dy, inst];
}


#define get_ally_list(team)
	if (global.lastAllyCacheTime == current_frame) {
		return global.allyCache
	}
	global.lastAllyCacheTime = current_frame
	global.allyCache = instances_matching(hitme, "team", team)
	return global.allyCache


#define nothing


// BULLET TRAILS
#define create_bullet_trail(x1, y1, x2, y2)
	with instance_create(x1, y1, CustomObject) {
		lifeTime = 0
		colors = [c_yellow, c_white, c_ltgray, c_orange]
		alpha = [1, .75, .5, .25]
		lifeMax  = array_length(colors)
		mask_index = mskNone
		sprite_index = mskNone
		depth = 0

		xGoal = x2
		yGoal = y2
		width = .8

		on_step = custom_trail_step
		on_draw = custom_trail_draw

		return self;
	}


#define custom_trail_step
	lifeTime += current_time_scale
	if (lifeTime >= lifeMax) instance_destroy()

#define custom_trail_draw
	var n = clamp(lifeTime, 0, array_length(colors) - 1),
	    col = merge_color(colors[floor(n)], colors[ceil(n)], frac(n)),
	    alp = lerp(alpha[floor(n)], alpha[ceil(n)], frac(n));

	draw_set_alpha(alp)
	draw_line_width_color(x, y, xGoal, yGoal, width, col, col)
	draw_set_alpha(1)


// BULLET CODE
#define hitscan_travel
	lastteam = team
	//This number works so well it should just be enforced
	speed = 8
	var endPoint = script_ref_call(targetScript, x, y, direction, team, hitscanLength);
	with create_bullet_trail(lastx, lasty, endPoint[0], endPoint[1]) {
		colors = other.trailcolor
		width = other.trailsize
	}
	x = endPoint[0]
	y = endPoint[1]
	lastx = x
	lasty = y
	image_angle = direction
	move_outside_solid(direction + 180, 2)
	xprevious = x
	yprevious = y
	hashitwall = false
	// if (!place_meeting(x, y, Floor)) {
	// 	shouldDestroy = true
	// }

#define hitscan_endstep
	if (shouldDestroy && lastteam == team) instance_destroy()

#define hitscan_wall
	if !hashitwall {
		hashitwall = true
		if (bounce > 0) {
			bounce -= 1
			mod_script_call("mod", "defpack tools", "audio_play_hit_pitch", sndBouncerBounce, .5 + random(1.5))
			if !irandom(1) instance_create(x, y, Dust)

			move_bounce_solid(true)
			direction += random_range(-5, 5)
			image_angle = direction
			shouldDestroy = false

			if neurons {
				instance_create(x + hspeed, y + vspeed, CaveSparkle)
				damage += 1
			}
		}
		else {
			shouldDestroy = true
		}
	}

#define hitscan_hit
	if (other != lasthit) {
		projectile_hit(other, damage, force, direction)
		if recycle_amount > 0 {
			if mod_script_call_self("mod", "defpack tools", "recycle_gland_roll", recycle_chance) {
				recycle_amount = 0
			}
		}
		if (pierce >= 0) {
			lasthit = other
			pierce -= 1
			shouldDestroy = false
		}
		if (pierce < 0) {
			instance_destroy()
		}

	}

#define hitscan_destroy
	instance_create(x, y, BulletHit).sprite_index = spr_dead
	sound_play_hit(sndHitWall, .2)


// BULLET CREATION
#define create_hitscan_bullet(x, y)
	with instance_create(x, y, CustomProjectile) {
		name = "Hitscan Bullet"
		typ = 1
		damage = 3
		force = 4
		speed = 8

		sprite_index = mskNone
		mask_index = mskPlayer

		shouldDestroy = false
		pierce = 0
		bounce = 4 * neurons
		lasthit = -4
		recycle_amount = 1
		recycle_chance = 60

		hashitwall = false

		targetScript = scrTravel
		lastx = x
		lasty = y
		lastteam = 0
		hitscanLength = hitscan_dis

    	sage_no_hitscan = true;

		trailcolor = [merge_color(c_yellow, c_red, random(.4)), c_white, c_ltgray, c_orange]
		trailsize = 1.4
		spr_dead = sprBulletHit

		on_step = hitscan_travel
		on_end_step = hitscan_endstep
		on_wall = hitscan_wall
		on_hit  = hitscan_hit
		on_destroy = hitscan_destroy

		return id
	}

//BOUNCER
#define create_bouncer_hitscan_bullet
	with create_hitscan_bullet(x, y) {
		name = "Bouncer Hitscan Bullet"

		bounce += 2
		damage += 1

		return id
	}


//FLAME
#define create_fire_hitscan_bullet(x, y)
	with create_hitscan_bullet(x, y) {
		name = "Fire Hitscan Bullet"

		trailcolor = [merge_color(c_red, c_yellow, random(.4) + .2), merge_color(c_yellow, c_white, .8), c_gray, c_red]
		spr_dead = spr.FireBulletHit

		damage = 4
		on_destroy = global.scrFireDestroy

		return id
	}


#define fire_step
	hitscan_travel()
	repeat(irandom_range(2, 5)) {
		var r = random(1);
		with instance_create(lerp(x, lastx, r), lerp(y, lasty, r), Flame) {
			team = other.team
			creator = other.creator
		}
	}


//GAMMA
#define create_gamma_hitscan_bullet(x, y)
	// Copying all the code because its a custom slash this time
	with instance_create(x, y, CustomSlash) {
		name = "Gamma Hitscan Bullet"
		typ = 1
		damage = 2
		force = 4
		speed = 8

		sprite_index = mskNone
		mask_index = mskPlayer

		shouldDestroy = false
		pierce = 1
		bounce = 4 * neurons
		lasthit = -4
		recycle_amount = 1
		recycle_chance = 40
		hashitwall = false

		targetScript = scrGammaTravel
		lastx = x
		lasty = y
		lastteam = 0
		hitscanLength = hitscan_dis

		trailcolor = [merge_color(c_yellow, c_lime, .2), c_white, c_lime, c_orange]
		trailsize = 1.4
		spr_dead = spr.GammaBulletHit

		on_step = hitscan_travel
		on_end_step = hitscan_endstep
		on_wall = hitscan_wall
		on_hit  = hitscan_hit
		on_destroy = hitscan_destroy

		on_projectile = gamma_projectile
		on_grenade    = nothing
		on_anim       = nothing

		return id
	}

#define gamma_projectile
if (instance_exists(other) && other.typ > 0) {
	with other instance_destroy()
	shouldDestroy = false
	if (instance_exists(self) && --pierce < 0) instance_destroy()
}

#define get_gamma_target(x1, y1, angle, team)
    var noteam = get_ally_list(team);
    var projectiles = get_proj_list(team);
    var shields = instances_matching(PopoShield, "team", team);

    with lasthit x += 10000
    with shields x += 10000
    with noteam x += 10000
    with projectiles x += 10000
    with Grenade x += 10000

    var _wall   = collision_line_first(x1, y1, x1 + lengthdir_x(hitscan_dis, angle), y1 + lengthdir_y(hitscan_dis, angle), Wall, 0, 0);

    if instance_exists(Wall) {
		if !place_meeting(_wall[0], _wall[1], Floor) {
			_wall = collision_line_first(x1 + 1, y1 + 1, _wall[0] + 1, _wall[1] + 1, Wall, 0, 0)
			_wall[0] -= 1
			_wall[1] -= 1
		}
    }

    var _shield = collision_line_first(x1, y1, _wall[0], _wall[1], PopoShield, 1, 1),
        _hitme  = collision_line_first(x1, y1, _shield[0], _shield[1], hitme, 0, 1),
        _proj   = collision_line_first(x1, y1, _hitme[0], _hitme[1], projectile, 0, 1);

    with Grenade x -= 10000
    with lasthit x -= 10000
    with shields x -= 10000
    with noteam x -= 10000
    with projectiles x -= 10000
    return _proj;


#define get_proj_list(team)
	if (global.lastProjCacheTime == current_frame) {
		return global.projCache
	}
	global.lastProjCacheTime = current_frame
	global.projCache = instances_matching(projectile, "team", team)
	return global.projCache


//PEST
#define create_pest_hitscan_bullet(x, y)
	with create_hitscan_bullet(x, y) {
		name = "Pest Hitscan Bullet"
		trailcolor = [merge_color(c_lime, c_white, random(.3)), c_white, c_ltgray, c_orange]
		spr_dead = spr.ToxicBulletHit
		on_destroy = pest_destroy

		damage = 2
		force = 8

		return id
	}

#define pest_destroy
	repeat(2) {
		with instance_create(x,y,ToxicGas) {
			friction *= 10;
			growspeed /= 8
			creator = other.creator
		}
	}
	hitscan_destroy()


//THUNDER
#define create_thunder_hitscan_bullet(x, y)
	with create_hitscan_bullet(x, y) {
		name = "Thunder Hitscan Bullet"

	    spr_dead = spr.LightningBulletHit
	    trailcolor = [merge_color(c_blue, c_aqua, .3 + random(.4)), c_white, c_aqua, c_black]

	    force = 7
	    damage = 3
	    typ = 2
	    charge = choose(2, 2, 3)

		on_hit = global.scrThunderHit

		return id
	}

#define new_thunder_hit
	if "thunder_charge" not in other {
		other.thunder_charge = 0
	}
	other.thunder_charge += charge
	var _team = team, _c = creator;
	hitscan_hit()
	var laserbrain = ceil(skill_get(mut_laser_brain));
	if other.my_health <= 0 {
		var _charge = max(other.thunder_charge, 5);
		while(_charge) > 0 {
			var r = min(irandom(_charge) + 1 + laserbrain, 12 + laserbrain);
			with instance_create(other.x, other.y, Lightning) {
				image_angle = random(360)
				direction = image_angle
				ammo = r + 1
				creator = _c
				team = _team
				alarm0 = irandom(1) + 1
			}
			_charge -= max(r - laserbrain, 1)
		}
		view_shake_at(other.x, other.y, other.thunder_charge/5)
		sound_play_pitchvol(sndLightningCannonEnd, 1 + max(1 - other.thunder_charge/30, -.8), .4)
		if laserbrain {
			sound_play_pitchvol(sndLightningPistolUpg, .8, .4)
		}
	}

#define new_thunder_destroy
	instance_create(x + random_range(-5, 5), y + random_range(-5, 5), LightningHit)
	hitscan_destroy()


//Novelty shell. Concepted for different project
#define altshell_create(x, y)
	with create_hitscan_bullet(x, y) {
		name = "AltShell"
		
		trailsize *= .5
		
		damage = 2
		hitscanLength = 40 + random(20)
		range = 130 + random(30)
		
		recycle_amount = 0
		bounce = 4 * skill_get(mut_shotgun_shoulders)
		
		on_wall = altshell_wall
		on_hit = altshell_hit
		on_step = altshell_step
		
		return self
	}

#define altshell_step
	var _x = x, _y = y;
	hitscanLength = min(range + 5, hitscanLength)
	hitscan_travel()
	range -= point_distance(_x, _y, x, y)
	if (range <= 0) shouldDestroy = true
	
#define altshell_wall	
	if !hashitwall {
		hashitwall = true
		mod_script_call("mod", "defpack tools", "audio_play_hit_pitch", sndShotgunHitWall, .5 + random(1.5))
		if !irandom(1) instance_create(x, y, Dust)
		move_bounce_solid(true)
		direction += random_range(-5, 5)
		image_angle = direction

		if (bounce > 0) {
			range += 5 * bounce
			bounce -= .5
			hitscanLength = min(max(60, hitscanLength + 5), range)
		}
		else {
			range -= 10
			hitscanLength -= 5
			if range <= 0 shouldDestroy = true
		}
	}

#define altshell_hit
	if (other != lasthit) {
		//Stacking damage bonus. Every 2 shell hits increases other shell damage by 1
		//2 shell hits = 4 damage, 3 shells = 7, 4 shells = 10, 5 shells = 14, 6 shells = 18
		var bonus = 0;
		if ("altshell_damage_bonus" in other) {
			if abs(other.altshell_damage_time - current_frame) <= 2 {
				bonus += other.altshell_damage_bonus
			}
		}
		projectile_hit(other, damage + floor(bonus/2), force, direction)
		
		if (bonus > 1) {
			sleep(bonus * 4)
		}
		if (bonus > 1) {
			if fork() {
				var _x = other.x, _y = other.y;
				wait(irandom(min(6, bonus)))
				var xoff = random_range(-24, 24),
					yoff = random_range(-24, 24);
				with instance_create(_x + xoff, _y + yoff, RecycleGland) {
					sprite_index = global.sprAltShellBonus
					image_xscale = sign(xoff)
					image_yscale = -sign(yoff)
				}
				
				exit
			}
		}
		
		other.altshell_damage_bonus = bonus + 1
		other.altshell_damage_time = current_frame

		if (pierce >= 0) {
			lasthit = other
			pierce -= 1
			shouldDestroy = false
		}
		if (pierce < 0) {
			instance_destroy()
		}
	}



//alright now for the real shit
//PSY
#define create_psy_hitscan_bullet(x, y)
	with create_hitscan_bullet(x, y) {
		name = "Psy Hitscan Bullet"

		spr_dead = spr.PsyBulletHit
		//Pardon my French
		trailcolor = [$D73AFF, c_white, $CC14AD, c_purple]

		damage = 4

		isSniper = false
		original_direction = undefined
		sight = 30
		minsight = 5
		radius = 10

		on_step = psy_hitscan_step

		return id

	}

#define psy_hitscan_step
	if (original_direction = undefined || team != lastteam) original_direction = direction
	lastteam = team
	//This number works so well it should just be enforced
	speed = 8
	// var endPoint = script_ref_call(targetScript, x, y, direction, team);
	// with create_bullet_trail(lastx, lasty, endPoint[0], endPoint[1]) {
	// 	colors = other.trailcolor
	// }
	// x = endPoint[0]
	// y = endPoint[1]

	var vbuf = vertex_create_buffer();
	vertex_begin(vbuf, global.psyTrailFormat)

	var results = psy_hitscan_travel(original_direction, vbuf)

	vertex_end(vbuf)
	vertex_freeze(vbuf)

	with create_psy_bullet_trail(x, y, vbuf) {
		colors = other.trailcolor
		if other.isSniper lifeMax *= 2
	}

	if instance_exists(Wall) && !place_meeting(x, y, Floor) {
		shouldDestroy = true
	}

	if isSniper {
		on_hit = nothing
		with results.hitList {
			create_psy_dummy(x, y, other)
		}
		shouldDestroy = true
	}


	x = results.x /*- hspeed*/
	y = results.y /*- vspeed*/
	direction = results.direction
	lastx = x
	lasty = y
	image_angle = direction
	move_outside_solid(direction + 180, 2)
	xprevious = x
	yprevious = y
	hashitwall = false


#define create_psy_dummy(x, y, parent)
	with instance_create(x, y, CustomProjectile) {
		name = "PsyDummy"
		mask_index = mskPlayer
		// sprite_index = sprJockIdle
		team = parent.team
		creator = parent.creator
		damage = parent.damage
		force = parent.force
		recycle_chance = parent.recycle_chance
		self.parent = parent

		on_hit = dummy_hit
		on_end_step = dummy_end_step
		on_wall = nothing

		return self
	}

#define dummy_hit
	if instance_exists(parent) {
		projectile_hit(other, damage, force, point_direction(parent.xstart, parent.ystart, x, y))
		if parent.recycle_amount > 0 {
			if recycle_gland_roll_special_edition(recycle_chance) {
				parent.recycle_amount -= 1
			}
		}
		instance_destroy()
	}

#define dummy_end_step
	instance_destroy()

#define recycle_gland_roll_special_edition
/// recycle_gland_roll_special_edition(_chance = 60)
var _chance = argument_count > 0 ? argument[0] : 60;

	var _gland = skill_get(mut_recycle_gland) + (10 * skill_get("recycleglandx10"));
	if chance_raw(_chance * _gland) {
		instance_create(x, y, RecycleGland)
		sound_play(sndRecGlandProc)
		var num = 1 * _gland
		with creator if instance_is(self, Player) {
			ammo[1] = min(ammo[1] + num, typ_amax[1])
		}
		return true
	}

	return false

#define chance_raw(percentage)
return random(100) <= percentage


#macro sort_distance 10000

#define psy_hitscan_travel(original_direction, vertex_buffer)
	var bullet = {
		dir    : direction,
		x      : x,
		y      : y,
		odir   : original_direction,
		radius : radius,
		sight  : sight,
		minSight: minsight,
		team   : team,
		target : -4,
		nextTarget: -4,
		missCounter: 0,
		targets: [],
		hitList: [],
		// targetcounter: array_length(instances_matching_ne([enemy, Player, Generator], "team", team))
		targetcounter: instance_number(hitme),
		pierce: isSniper,
		lastHit: lasthit,
		vbuf: vertex_buffer,
		trailSize: trailsize
	};

	var exists = true, count = 0, missedLast = false, missed = false;
	//Has to initialize targetting, since there a buffer
	bullet_target(bullet)
	bullet_add_to_trail(bullet)

	while(exists && ++count < 1000) {
		missed = false

		if bullet.missCounter > 0 {
			var l = min(2 * bullet.missCounter, 16)
			bullet.x += lengthdir_x(l, bullet.dir)
			bullet.y += lengthdir_y(l, bullet.dir)
		}

		bullet_add_to_trail(bullet)


		//Get target
		bullet_target(bullet)

		if (bullet.target == -4) {
			// var _wall = collision_line_first(bullet.x, bullet.y,
			// 			bullet.x + lengthdir_x(300, bullet.dir), bullet.y + lengthdir_y(300, bullet.dir),
			// 			Wall, false, false);
			var _wall = get_psy_hitscan_target(bullet.x, bullet.y, bullet.dir, bullet.team);
			bullet.x = _wall[0]
			bullet.y = _wall[1]
			exists = false
			bullet_add_to_trail(bullet)
			break
		}
		else {
			var target = {
				x: bullet.target.x - sort_distance,
				y: bullet.target.y,
				id: bullet.target.id
			};
		}
		//LOS finding
		var canReach = bullet_can_reach(bullet, target.x, target.y);

		//If target in sight cone
		if (canReach != false) {
			//If target can be reached
			if (canReach.succeeded) {
				bullet.x = canReach.x
				bullet.y = canReach.y
				var turn = bullet_turn(bullet, point_direction(bullet.x, bullet.y, target.x, target.y));
				if (turn.succeeded) {
					if bullet.pierce {
						bullet.x = target.x
						bullet.y = target.y
					}
					else {
						var _t = collision_line_first(bullet.x + sort_distance, bullet.y, target.x + sort_distance, target.y, hitme, 0, 0);
						bullet.x = _t[0] - sort_distance
						bullet.y = _t[1]
					}
					bullet.dir = point_direction(turn.x, turn.y, target.x, target.y)
					bullet_add_to_trail(bullet)
					array_push(bullet.hitList, target.id)
					bullet.sight = max(bullet.sight - 5, bullet.minSight)
					if !bullet.pierce {
						exists = false
					}
				}
				else {
					exists = false
				}
			}
			//If target cannot be reached
			else {
				missed = true
			}
		}
		//If not within bullet sight cone
		else {
			missed = true
		}

		//Add a stacking penalty for repeated misses, basically prevents the bullet from checking literally everything if its stuck in a weird hallway
		if missed {
			if missedLast {
				++bullet.missCounter
			}
			missedLast = true
		}
		else {
			missedLast = false
			bullet.missCounter = 0
		}

		var _nearestWall = instance_nearest(bullet.x, bullet.y, Wall);
		if (instance_exists(_nearestWall)) {
			var _wallX = clamp(bullet.x, _nearestWall.bbox_left, _nearestWall.bbox_right),
				_wallY = clamp(bullet.y, _nearestWall.bbox_top, _nearestWall.bbox_bottom);
			if (point_distance(bullet.x, bullet.y, _wallX, _wallY) < 8) {
				exists = false
			}
		}
	}

	bullet_add_to_trail(bullet)
	//Fix vertex connecting to 0,0
	repeat(3) {
		vertex_position(bullet.vbuf, bullet.x, bullet.y)
	}

	bullet_target_resolve(bullet)


	return {
		x: bullet.x,
		y: bullet.y,
		direction: bullet.dir,
		hitList: bullet.hitList
	}



//Turns the bullet, returning if it was successful or not
#define bullet_turn_auto(bullet, dir)
	if (bullet.dir == dir) return true
	var turn = bullet_turn(bullet, dir);
	if (turn.succeeded) {
		bullet.x = turn.x
		bullet.y = turn.y
		bullet.dir = turn.dir
		return true
	}
	else return false


//Gets the next target for the bullet
#define bullet_target(_bullet)
	if (_bullet.targetcounter > 0) {
		var nearest = instance_nearest(_bullet.x, _bullet.y, hitme);
		if (!instance_exists(nearest)) exit

		_bullet.targetcounter--
		array_push(_bullet.targets, nearest)
		nearest.x += sort_distance
		if (nearest.team != _bullet.team && (!(instance_is(nearest, prop) || nearest.team == 0) || instance_is(nearest, Generator)) && (nearest != _bullet.lastHit)) {
			//Buffers targets so it goes wiggly
			_bullet.target = _bullet.nextTarget
			_bullet.nextTarget = nearest
		}
		else {
			bullet_target(_bullet)
		}
	}
	else {
		_bullet.target = _bullet.nextTarget
		_bullet.nextTarget = -4
	}


//Undoes any effects the targeting script has
#define bullet_target_resolve(_bullet)
	with _bullet.targets x -= sort_distance


//Checks if the bullet will have LOS to a point at some point along travel
#define bullet_can_reach(_bullet, _x, _y)
var _a = angle_difference(_bullet.odir, point_direction(_bullet.x, _bullet.y, _x, _y));
	if abs(_a) > _bullet.sight
		return false
	var _wall = collision_line(_bullet.x, _bullet.y, _x, _y, Wall, 0, 0);
	if _wall == noone
		return {succeeded: true, x: _bullet.x, y: _bullet.y}
	else {
		var _dest = {
			x : _x,
			y : _y,
			dir : _bullet.odir - _bullet.sight * sign(_a)
		},
		_max = point_intersect(_bullet, _dest);
		var _wallMax = collision_line_first(_bullet.x, _bullet.y, _max.x, _max.y, Wall, false, false);
		_max.x = _wallMax[0]
		_max.y = _wallMax[1]

		var _tries = floor(point_distance(_bullet.x, _bullet.y, _max.x, _max.y)/18),
			xoff = (_max.x - _bullet.x)/_tries,
			yoff = (_max.y - _bullet.y)/_tries;
		for (var i = 1; i < _tries; i++) {
			if (collision_line(_bullet.x + xoff * i, _bullet.y + yoff * i, _x, _y, Wall, false, false) == noone) {
				return {
					succeeded: true,
					x: _bullet.x + xoff * i,
					y: _bullet.y + yoff * i
				}
			}
		}

		return {
			succeeded : false,
			x: _max.x,
			y: _max.y
		}

	}


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

#define point_intersect(_line1, _line2)
//Uses negative angle because of GML's y going 'down' as it increases, despite 90 degrees still being 'up'
var _m1 = dtan(-_line1.dir),
	_m2 = dtan(-_line2.dir),
	_b1 = _line1.y,
	_b2 = _line2.y,
	_h1 = _line1.x,
	_h2 = _line2.x,
	_x  = (((-_m2 / _m1) * _h2) + ((_b2 - _b1)/_m1) + _h1)/(1 - (_m2/_m1)),
	_y  = _m1 * (_x - _h1) + _b1;
	return {x: _x, y: _y}


//Tries to turn the bullet, checking for wall collision along the arc, and returning the theoretical result
#define bullet_turn(_bullet, _dir)
var _dif = angle_difference(_bullet.dir, _dir),
	_cdir = _bullet.dir - 90 * sign(_dif),
	_cx = _bullet.x + lengthdir_x(_bullet.radius, _cdir),
	_cy = _bullet.y + lengthdir_y(_bullet.radius, _cdir);

	// draw_primitive_begin(pr_trianglestrip)
	for var i = 0; i <= 1; i += .2 {
		var a = _cdir - _dif * i + 180, l = _bullet.radius - _bullet.trailSize/2;
		// draw_vertex_color(_cx + lengthdir_x(l, a) + 1, _cy + lengthdir_y(l, a) + 1, _col, 1)
		// draw_vertex_color(_cx + lengthdir_x(l+1, a) + 1, _cy + lengthdir_y(l+1, a) + 1, _col, 1)
		vertex_position(_bullet.vbuf, _cx + lengthdir_x(l + _bullet.trailSize, a), _cy + lengthdir_y(l + _bullet.trailSize, a))
		vertex_position(_bullet.vbuf, _cx + lengthdir_x(l, a), _cy + lengthdir_y(l, a))
	}
	// draw_primitive_end()

	var _walls = instances_in_bbox(_cx - _bullet.radius, _cy - _bullet.radius, _cx + _bullet.radius, _cy + _bullet.radius, Wall);

	if array_length(_walls) > 0 {
		with _walls {
			if circle_in_bbox(_cx, _cy, _bullet.radius) {
				var _x = clamp(_bullet.x, bbox_left, bbox_right),
					_y = clamp(_bullet.y, bbox_top, bbox_bottom),
					_d = point_direction(_cx, _cy, _x, _y);
				if (_d > min(_bullet.dir, _dir) && _d < max(_bullet.dir, _dir)) {
					return {
						succeeded: false,
						x: _x,
						y: _y,
						dir: _d + 90 * sign(_dif)
					}
				}
			}
		}
	}
	return {
		succeeded: true,
		x: _cx + lengthdir_x(_bullet.radius, _dir + 90 * sign(_dif)),
		y: _cy + lengthdir_y(_bullet.radius, _dir + 90 * sign(_dif)),
		dir: _dir
	}


#define circle_in_bbox(_x, _y, _r)
	return circle_in_rectangle(_x, _y, _r, bbox_left, bbox_top, bbox_right, bbox_bottom)

#define circle_in_rectangle(_x, _y, _r, _left, _top, _right, _bottom)
var _dx = _x - clamp(_x, _left, _right),
	_dy = _y - clamp(_y, _top, _bottom);

	return (_dx * _dx + _dy * _dy) < (_r * _r)

#define instances_in_bbox(left,top,right,bottom,obj)
	return instances_matching_gt(instances_matching_lt(instances_matching_gt(instances_matching_lt(obj,"bbox_top",bottom),"bbox_bottom",top),"bbox_left",right),"bbox_right",left)


#define create_psy_bullet_trail(x, y, vertex_buffer)
	with create_bullet_trail(x, y, 0, 0) {
		vbuf = vertex_buffer

		on_draw = psy_trail_draw
		on_destroy = psy_trail_destroy

		return self
	}


#define psy_trail_draw
	var q = (lifeTime/lifeMax) * (array_length(colors) - 1),
		n = clamp(q, 0, array_length(colors) - 1),
	    col = merge_color(colors[floor(n)], colors[ceil(n)], frac(n)),
	    alp = lerp(alpha[floor(n)], alpha[ceil(n)], frac(n));

	col = merge_color(col, background_color, 1-alp);

	d3d_set_fog(1, col, 0, 0)
	vertex_submit(vbuf, pr_trianglestrip)
	d3d_set_fog(0, 0, 0, 0)

#define psy_trail_destroy
	vertex_delete_buffer(vbuf)

#define add_point_to_trail(vbuf, x, y, direction, thickness)
	vertex_position(vbuf, x + lengthdir_x(thickness/2, direction + 90), y + lengthdir_y(thickness/2, direction + 90))
	vertex_position(vbuf, x + lengthdir_x(-thickness/2, direction + 90), y + lengthdir_y(-thickness/2, direction + 90))

#define bullet_add_to_trail(bullet)
	add_point_to_trail(bullet.vbuf, bullet.x, bullet.y, bullet.dir, bullet.trailSize)



#define get_psy_hitscan_target()
/// get_hitscan_target(x1, y1, angle, team, dis = hitscan_dis)
var x1 = argument[0], y1 = argument[1], angle = argument[2], team = argument[3];
var dis = argument_count > 4 ? argument[4] : hitscan_dis;
    var noteam = get_ally_list(team);
    var shields = instances_matching(PopoShield, "team", team);
    with lasthit x += 10000
    with shields x += 10000
    with noteam x += 10000

    var _wall   = collision_line_first(x1, y1, x1 + lengthdir_x(dis, angle), y1 + lengthdir_y(dis, angle), Wall, 0, 0);

    if instance_exists(Wall) {
		if !place_meeting(_wall[0], _wall[1], Floor) {
			// trace("Missed first pass")
			_wall = collision_line_first(x1 + 1, y1 + 1, _wall[0] + 1, _wall[1] + 1, Wall, 0, 0)
			_wall[0] -= 1
			_wall[1] -= 1
			// Couldn't find a single instance of this missing twice, so no need to check again
			// if !place_meeting(_wall[0], _wall[1], Floor) {
			// 	trace("Missed second pass")
			// }
			// else {
			// 	trace("But found on second pass")
			// }
		}
    }

    var _shield = collision_line_first(x1, y1, _wall[0], _wall[1], PopoShield, 1, 1),
        _hitme  = collision_line_first(x1 + sort_distance, y1, _shield[0] + sort_distance, _shield[1], hitme, 0, 1);

	_hitme[0] -= sort_distance
    with lasthit x -= 10000
    with shields x -= 10000
    with noteam x -= 10000
    return _hitme;

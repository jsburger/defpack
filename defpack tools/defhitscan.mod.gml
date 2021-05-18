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
global.scrThunderDestroy = ["mod", "defpack tools", "thunder_destroy"]

#macro neurons skill_get("excitedneurons")


#macro hitscan_dis 500

#define get_hitscan_target(x1, y1, angle, team)
    var noteam = get_ally_list(team);
    var shields = instances_matching(PopoShield, "team", team);
    with lasthit x += 10000
    with shields x += 10000
    with noteam x += 10000

    var _wall   = collision_line_first(x1, y1, x1 + lengthdir_x(hitscan_dis, angle), y1 + lengthdir_y(hitscan_dis, angle), Wall, 1, 0),
        _shield = collision_line_first(x1, y1, _wall[0], _wall[1], PopoShield, 1, 1),
        _hitme  = collision_line_first(x1, y1, _shield[0], _shield[1], hitme, 1, 1);

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
	draw_line_width_color(x, y, xGoal, yGoal, .8, col, col)
	draw_set_alpha(1)


// BULLET CODE
#define hitscan_travel
	lastteam = team
	var endPoint = script_ref_call(targetScript, x, y, direction, team);
	with create_bullet_trail(lastx, lasty, endPoint[0], endPoint[1]) {
		colors = other.trailcolor
	}
	x = endPoint[0]
	y = endPoint[1]
	lastx = x
	lasty = y
	xprevious = x - hspeed
	yprevious = y - vspeed
	shouldDestroy = true

#define hitscan_endstep
	if (shouldDestroy && lastteam == team) instance_destroy()

#define hitscan_wall
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
		speed = 12

		sprite_index = mskNone
		mask_index = mskBullet1

		shouldDestroy = false
		pierce = 0
		bounce = 4 * neurons
		lasthit = -4
		recycle_amount = 1
		recycle_chance = 60

		targetScript = scrTravel
		lastx = x
		lasty = y
		lastteam = 0

		trailcolor = [merge_color(c_yellow, c_red, random(.4)), c_white, c_ltgray, c_orange]
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

		trailcolor = [merge_color(c_red, c_yellow, random(.4)), c_white, c_ltgray, c_red]
		spr_dead = spr.FireBulletHit

		on_hit = fire_hit

		return id
	}

#define fire_hit
	with mod_script_call("mod", "defpack tools", "create_miniexplosion", x, y) {
		team = other.team
		creator = other.creator
	}
	hitscan_hit()

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
		speed = 12

		sprite_index = mskNone
		mask_index = mskBullet1

		shouldDestroy = false
		pierce = 1
		bounce = 4 * neurons
		lasthit = -4
		recycle_amount = 1
		recycle_chance = 40


		targetScript = scrGammaTravel
		lastx = x
		lasty = y
		lastteam = 0

		trailcolor = [c_yellow, c_lime, c_ltgray, c_orange]
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

    var _wall   = collision_line_first(x1, y1, x1 + lengthdir_x(hitscan_dis, angle), y1 + lengthdir_y(hitscan_dis, angle), Wall, 1, 0),
        _shield = collision_line_first(x1, y1, _wall[0], _wall[1], PopoShield, 1, 1),
        _hitme  = collision_line_first(x1, y1, _shield[0], _shield[1], hitme, 1, 1),
        _proj   = collision_line_first(x1, y1, _hitme[0], _hitme[1], projectile, 1, 1);

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
	    trailcolor = [merge_color(c_blue, c_aqua, .2 + random(.4)), c_white, c_aqua, c_orange]

	    force = 7
	    damage = 2
	    typ = 2

		on_destroy = global.scrThunderDestroy

		return id
	}


//alright now for the real shit
//psy bullet goes here

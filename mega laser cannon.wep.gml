#define init
global.sprBeamer       = sprite_add_weapon("sprites/weapons/sprBeamer.png",12,6);
global.sprBeamerHUD    = sprite_add("sprites/interface/sprBeamerHUD.png",1,12,6);
global.sprBeam         = sprite_add("sprites/projectiles/sprBeam.png",1,0,10);
global.mskBeam         = sprite_add("sprites/projectiles/mskBeam.png",1,1,10);
global.sprBeamStart    = sprite_add("sprites/projectiles/sprBeamStart.png",1,12,10);
global.sprBeamCharge   = sprite_add("sprites/projectiles/sprBeamCharge.png",1,16,16);
global.sprBeamEnd      = sprite_add("sprites/projectiles/sprBeamEnd.png",1,10,12);

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#macro brain_active skill_get(mut_laser_brain) > 0

#define weapon_name
return "MEGA LASER CANNON"

#define weapon_type
return 5;

#define weapon_cost
return 8;

#define weapon_area
return 15;

#define weapon_load
return 64;

#define weapon_swap
if instance_is(self, Player){
	view_shake_at(x, y, 20);
	// sleep(10);
}
sound_play_pitchvol(sndBasicUltra, 1.2, .6);
sound_play_pitch(sndSwapEnergy, .9);
return -4;

#define weapon_auto
return false;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_sprt
return global.sprBeamer;

//#define weapon_sprt_hud
//return global.sprBeamerHUD;

#define weapon_text
return "MASSIVE POWER";

#define weapon_fire
var p = random_range(.8,1.2);
if skill_get(mut_laser_brain) > 0{
	sound_play_pitch(sndLaserUpg,.4*p)
	sound_play_charge(sndLaser,.6, 0)
}
else{
	sound_play_pitch(sndLaserUpg,.6*p)
	sound_play_charge(sndLaser,1, 0)
}
sound_play_pitch(sndPlasmaRifle,.2*p)
// with instance_create(x,y,CustomProjectile){
//     name = "beamer sphere"
// 	image_xscale = .25
// 	image_yscale = .25
// 	sprite_index = global.sprBeamCharge
// 	creator = other
// 	team = other.team
// 	gunangle = other.gunangle
// 	ammo = 30
// 	sage_no_hitscan = true;
// 	orammo = ammo
// 	on_step = sphere_step
// 	on_wall = nothing
// 	on_hit = sphere_hit
// 	on_draw = sphere_draw
// }

// 	exit
	var _c = instance_is(self, FireCont) && "creator" in self ? creator : self;
	with create_charge_object(x, y) {
		creator = _c
		team = other.team
		laser_angle = other.gunangle
	}
	

#define create_charge_object(x, y)
	with instance_create(x, y, CustomObject) {
		name = "MegaLaserCharge"
		
		creator = noone
		team = -1
		laser_angle = undefined
		points = undefined
		lastPoints = undefined
		drawPoints = undefined
		normals = undefined
		beamSize = 10
		ball = noone
		phase = 0
		progress = 0
		
		on_step = charge_step
		on_draw = charge_draw
		
		return id
	}

#define charge_step
	if !instance_exists(creator) {
		instance_destroy()
		exit
	}
	
	x = creator.x + creator.hspeed
	y = creator.y + creator.vspeed
	if "gunangle" in creator {
		var len = phase == 1 ? 32 : 26;
		x += lengthdir_x(len, creator.gunangle)
		y += lengthdir_y(len, creator.gunangle)
		laser_angle = creator.gunangle
	}

	
	progress += current_time_scale
	
	//Ball phase
	if (phase == 0) {
		//Ball management
		if !instance_exists(ball) {
			ball = create_ball(x, y);
			with ball {
				charger = other
				creator = other.creator
				team = other.team
				image_xscale += ballScaling * (other.progress - 1)
				image_yscale += ballScaling * (other.progress - 1)
			}
		}
		else {
			ball.x = x
			ball.y = y
			ball.xprevious = x
			ball.yprevious = y
			ball.image_angle = laser_angle
		}
		
		//Fire Laser, move to laser phase
		if progress > 30 {
			phase = 1
			progress = 0
			with ball instance_destroy()
			
			var p = random_range(.8, 1.2);
			if skill_get(mut_laser_brain) {
				sound_play_pitch(sndLaserCannonUpg, .6 * p);
				sound_play_pitch(sndLaserCannon, 2 * p)
			}
			else {
				sound_play_pitch(sndLaserCannon, .7 * p)
			}
			sleep(20)
			sound_play_pitchvol(sndDevastatorExplo,5,.7)
			view_shake_at(x, y, 100)
			if instance_is(creator, Player) with creator weapon_post(20, 100, 40)
			repeat(15) {
				with instance_create(x, y, PlasmaTrail){
					image_index = choose(3, 4)
					sprite_index = sprPlasmaImpact
					motion_add(random(360), random_range(2, 7))
					image_xscale = .25
					image_yscale = .25
					image_speed = .5
				}
				with instance_create(x, y, PlasmaTrail){
					motion_add(random(360), random_range(4, 7))
				}
				with instance_create(x, y, Smoke){
					motion_add(random(360), random_range(2, 4))
				}
			}
		}
	}
	
	//Laser Phase
	if (phase == 1) {
		if progress > 30 {
			instance_destroy()
			exit
		}
		
		if "wkick" in creator {
			creator.wkick += .5 * current_time_scale
		}

		#macro segments 3
		if points == undefined {
			points = []
			lastPoints = []
			var raycast = cast(x, y, laser_angle);
			for (var i = 0; i <= 1; i += 1/segments) {
				array_push(points, point_lerp({x: x, y: y}, raycast, i))
				array_push(lastPoints, point_lerp({x: x, y: y}, raycast, i))
			}
		}
		
		//Move the beam control points towards the ideal points over time
		var raycast = cast(x, y, laser_angle),
			lastAngle = laser_angle,
			bonus = 0,
			angle = laser_angle;
		for (var i = 0; i < segments; i += 1) {
			//Ideal points are simply points at n% of the way through a straight forward raycast
			points[i] = point_lerp({x: x, y: y}, raycast, i/segments)
			
			//Calculate a bonus to point speed according to how much bend there is
			if i > 0 {
				angle = point_direction(lastPoints[i-1].x, lastPoints[i-1].y, lastPoints[i].x, lastPoints[i].y);
				bonus = abs(angle_difference(lastAngle, angle))
				lastAngle = angle
			}
			//Move towards goal
			lastPoints[i] = point_move_towards(lastPoints[i], points[i], 7 * current_time_scale * sqr(1 + bonus/180))
			
		}

		//Cast from last control point straight forwards so it meets walls
		var endcast = cast(lastPoints[segments-1].x, lastPoints[segments-1].y, lastAngle);

		//Draw beam
		var drawSegments = 10
		
		normals = [];
		drawPoints = [];

		var lastLaserPoint = {x: creator.x, y: creator.y};

		for (var i = 0; i <= 1; i += 1/drawSegments) {
			//Sample bezier curve using Control points and the raycast end point
			var samplePoint = sample_cubic_bezier(lastPoints[0], lastPoints[1], lastPoints[2], endcast, i),
				normalSample= sample_cubic_bezier_normal(lastPoints[0], lastPoints[1], lastPoints[2], endcast, i);
			
			with create_laser_segment(lastLaserPoint.x, lastLaserPoint.y, samplePoint.x, samplePoint.y) {
				team = other.team
				creator = other.creator
			}
			lastLaserPoint = samplePoint
			
			//Width of beam/2
			point_scale(normalSample, beamSize * random_range(.9, 1.1))
				
			array_push(normals, normalSample)
			array_push(drawPoints, samplePoint)
		}

	}

#define charge_draw
	
	if normals != undefined {
		var texture = sprite_get_texture(global.sprBeam, 0),
			beamStartTexture = sprite_get_texture(global.sprBeamStart, 0);
	
		draw_beam_scaled(1, texture, 1)
		draw_beam_start(1, beamStartTexture, 1)
		draw_set_blend_mode(bm_add)	
		draw_beam_scaled(1.5, texture, .2)
		draw_beam_start(1.5, beamStartTexture, .2)
		draw_set_blend_mode(bm_normal)
	}

#define draw_beam_start(scale, texture, alpha)
	draw_primitive_begin_texture(pr_trianglestrip, texture)
	
	var point = point_move_towards(self, creator, 24);
	
	draw_vertex_texture_color(point.x + lengthdir_x(beamSize * scale, laser_angle + 90), point.y + lengthdir_y(beamSize * scale, laser_angle + 90), 0, 0, image_blend, image_alpha * alpha)
	draw_vertex_texture_color(point.x + lengthdir_x(beamSize * scale, laser_angle - 90), point.y + lengthdir_y(beamSize * scale, laser_angle - 90), 0, 1, image_blend, image_alpha * alpha)
	draw_vertex_texture_color(drawPoints[0].x + normals[0].x * scale, drawPoints[0].y + normals[0].y * scale, 1, 0, image_blend, image_alpha * alpha)
	draw_vertex_texture_color(drawPoints[0].x - normals[0].x * scale, drawPoints[0].y - normals[0].y * scale, 1, 1, image_blend, image_alpha * alpha)

	draw_primitive_end()
	
#define draw_beam_scaled(scale, texture, alpha)
	draw_primitive_begin_texture(pr_trianglestrip, texture)
	var n = 0,
		f = scale,
		i = 0,
		xUv = 0,
		yUv = 0;
	with drawPoints {
		repeat(2) {
			yUv = n mod 2 == 0 ? 0 : 1
			xUv = n mod 4 >= 2 ? 1 : 0
			draw_vertex_texture_color(x + other.normals[i].x * f, y + other.normals[i].y * f, xUv, yUv, other.image_blend, other.image_alpha * alpha)
			f *= -1
			n += 1
		}
		i++
	}
	draw_primitive_end()




#define create_laser_segment(x1, y1, x2, y2)
	with instance_create(x1, y1, CustomProjectile) {
		name = "MegaLaserBeam"
		typ = 0
		
		sprite_index = global.sprBeam
		
		image_angle = point_direction(x1, y1, x2, y2)
		direction = image_angle
		image_xscale = point_distance(x1, y1, x2, y2)

		damage = 6 + skill_get(mut_laser_brain) * 3
		force = 10
		
		on_wall = beam_wall
		on_end_step = beam_endstep
		on_hit = beam_hit
		
		return id
	}
	
#define beam_wall
	if current_frame_active {
		if instance_exists(creator) && point_distance(creator.x, creator.y, other.x, other.y) <= 240 with other {
			sleep(2)
			instance_create(x, y, FloorExplo)
			instance_destroy()
		}
		view_shake_max_at(x, y, 3)
		with instance_create(x + random_range(-8, 8), y + random_range(-8, 8), PlasmaImpact) {
			var _size = random_range(.4, .8)
			image_xscale = _size
			image_yscale = _size
			image_speed *= random_range(.8, 1.2)
			team = other.team
			creator = other.creator
		}
	}
	

#define beam_endstep

	if (random(100) <= 30 * current_time_scale) {
		with instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), BulletHit) {
        	sprite_index = sprPlasmaTrail
        	image_angle = other.direction
        	motion_set(other.direction, irandom_range(2, 4))
		}
	}
	
	instance_destroy()

#define beam_hit
	if current_frame_active && other.nexthurt != current_frame + 6 {
		view_shake_at(x, y, 2)
	    view_shake_max_at(other.x, other.y, min(other.size, 4))
	    projectile_hit(other, damage, force, image_angle)
	    if other.my_health <= 0 {
	        sleep(min(other.size, 4) * 20)
	        view_shake_max_at(creator.x, creator.y, 5 * min(4, other.size))
	    }
	}


#define create_ball(x, y)
	with instance_create(x, y, CustomProjectile) {
		name = "MegaLaserChargeBall"
		sprite_index = global.sprBeamCharge
		defbloom = {
			xscale: 1.5,
			yscale: 1.5,
			alpha: .1
		}
		
		charger = noone
		typ = 0
		damage = 3
		force = 2
		image_xscale = .25
		image_yscale = .25
		
		on_step = ball_step
		on_wall = nothing
		on_hit  = ball_hit

		return self
	}

#define ball_step
	if !instance_exists(charger) instance_destroy()
	#macro ballScaling .035
	image_xscale += ballScaling * current_time_scale
	image_yscale += ballScaling * current_time_scale
	
	if current_frame_active {
		var ang = random(360);
		repeat(3) {
			with instance_create(x + lengthdir_x(sprite_width * .5, ang), y + lengthdir_y(sprite_height * .5, ang), PlasmaTrail) {
				motion_set(ang, random(3))
			}
		}
	}

#define ball_hit
	if current_frame_active {
		projectile_hit_push(other, damage, force)
	}

#define nothing


#define cast(x, y, dir)
	#macro castLength 300
	return collision_line_first(x, y, x + lengthdir_x(castLength, dir), y + lengthdir_y(castLength, dir), Wall, 0, 0);

//Faster version of quad_lerp. uses the Bernstein Polynomial Form of a bezier curve
#define sample_cubic_bezier(pointA, pointB, pointC, pointD, t)
	var tCubed = power(t, 3), tSqr = sqr(t),
		n1 =   -tCubed + 3*tSqr - 3*t + 1,
		n2 =  3*tCubed - 6*tSqr + 3*t,
		n3 = -3*tCubed + 3*tSqr,
		n4 =    tCubed;
	return {
		x : (
			pointA.x * (n1) +
			pointB.x * (n2) +
			pointC.x * (n3) +
			pointD.x * (n4)
		),
		y : (
			pointA.y * (n1) +
			pointB.y * (n2) +
			pointC.y * (n3) +
			pointD.y * (n4)
		)
	}
	
//Derivative of the Bernstein Polynomial Form
#define sample_cubic_bezier_derivative(pointA, pointB, pointC, pointD, t)
	var tSqr = sqr(t),
		n1 = -3*tSqr +  6*t - 3,
		n2 =  9*tSqr - 12*t + 3,
		n3 = -9*tSqr +  6*t,
		n4 =  3*tSqr;
	//As the derivative of the function gives us change over time, we get the "speed" at a point
	return {
		x : (
			pointA.x * (n1) +
			pointB.x * (n2) +
			pointC.x * (n3) +
			pointD.x * (n4)
		),
		y : (
			pointA.y * (n1) +
			pointB.y * (n2) +
			pointC.y * (n3) +
			pointD.y * (n4)
		)
	}
	
#define sample_cubic_bezier_normal(pointA, pointB, pointC, pointD, t)
	//Since the derivative of the curve is its velocity, we can rotate it 90 degrees to get
	//the normal of the curves apparent motion.
	var derivative = sample_cubic_bezier_derivative(pointA, pointB, pointC, pointD, t);
	//Normalize, swap x and y, negate y because of GMS
	normalize(derivative)
	return {
		x: derivative.y,
		y: -derivative.x
	}

#define normalize(vector)
	var magnitude = point_distance(0, 0, vector.x, vector.y);
	return point_scale(vector, 1/magnitude);

#define point_move_towards(pointA, pointB, len)

	var dist = point_distance(pointA.x, pointA.y, pointB.x, pointB.y);
	if dist == 0 return pointA;
	dist = (min(dist, len))/dist
	var	xdif = (pointB.x - pointA.x) * dist,
		ydif = (pointB.y - pointA.y) * dist;
	return {
		x: pointA.x + xdif,
		y: pointA.y + ydif
	}
	
#define point_add(pointA, pointB)
	return {
		x: pointA.x + pointB.x,
		y: pointA.y + pointB.y
	}
	
#define point_subtract(pointA, pointB)
	return {
		x: pointA.x - pointB.x,
		y: pointA.y - pointB.y
	}

#define point_scale(point, n)
	point.x *= n
	point.y *= n
	return point

#define point_lerp(pointA, pointB, t)
	return {
		x: lerp(pointA.x, pointB.x, t),
		y: lerp(pointA.y, pointB.y, t)
	}

#define collision_line_first(x1, y1, x2, y2, object, prec, notme)
    var sx, sy, inst, i;
    sx = x2 - x1;
    sy = y2 - y1;
    inst = collision_line(x1,y1,x2,y2,object,prec,notme);
    if (inst != noone) {
        while ((abs(sx) >= 1) || (abs(sy) >= 1)) {
            sx *= .5;
            sy *= .5;
            i = collision_line(x1, y1, x2, y2, object, prec, notme);
            if (i) {
                x2 -= sx;
                y2 -= sy;
                inst = i;
            }else{
                x2 += sx;
                y2 += sy;
            }
        }
    }
    return {
    	x: x2,
    	y: y2, 
    	"inst": inst
	};












#define sphere_hit
if current_frame_active{
    projectile_hit(other, 3, other.friction + .1, image_angle)
    if other.my_health <= 0{
        sleep(min(other.size, 4)*4)
        view_shake_at(x,y,3*min(4,other.size))
    }
}

#define sphere_step
if instance_exists(creator){
	x = creator.x+creator.hspeed + lengthdir_x(26,creator.gunangle)
	y = creator.y+creator.vspeed + lengthdir_y(26,creator.gunangle)
	image_angle = creator.gunangle
}
else {
    instance_destroy()
    exit
}
xprevious = x
yprevious = y
ammo -= current_time_scale;
image_xscale += .035 * current_time_scale
image_yscale += .035 * current_time_scale
var _r = random(360)
if current_frame_active repeat(3) instance_create(x+lengthdir_x(sprite_width*random_range(.4,.7),_r),y+lengthdir_y(sprite_height*random_range(.4,.7),_r),PlasmaTrail)
if floor(ammo) < current_time_scale and floor(ammo) >= 0{
    with instance_create(x,y,CustomProjectile){
        name = "beamer beam"
        creator = other.creator
        team = other.team
        direction = creator.gunangle
        image_angle = direction
				sage_no_hitscan = true;
    	sprite_index = global.sprBeam
    	spr_head     = global.sprBeamEnd
    	spr_tail     = global.sprBeamStart
    	mask_index   = global.mskBeam

        on_step = beam_step
        on_wall = old_beam_wall
    	on_draw = beam_draw
    	on_hit  = old_beam_hit
    	on_square = script_ref_create(beam_square)

        sound = -1
        time = 28
        image_speed = 0
        /*repeat(1+skill_get(mut_laser_brain))with sound_play_charge(sndLaserUpg, 1, .33){
            creator = noone
            pitch = 2
            decel = -.05 * random_range(.9, 1.2)
            lifetime = 40
        }
        with sound_play_charge(sndEnergyHammerUpg, .6, .32){
            creator = noone
            pitch = .7
            decel = 0
            lifetime = 40
        }*/
    }
}
if ammo <= 0{
	var p = random_range(.8,1.2)
	if !skill_get(17){
	    sound_play_pitch(sndLaserCannon,.7*p)
	}
    else{
        sound_play_pitch(sndLaserCannonUpg,.6*p);
        sound_play_pitch(sndLaserCannon,2*p)
    }
	sleep(20)
	sound_play_pitchvol(sndDevastatorExplo,5,.7)
	view_shake_at(x,y,100)
	with creator weapon_post(-20,100,40)
	repeat(15){
		with instance_create(x,y,PlasmaTrail){
			image_index = choose(3,4)
			sprite_index = sprPlasmaImpact
			motion_add(random(360),random_range(2,7))
			image_xscale = .25
			image_yscale = .25
			image_speed = .5
		}
		with instance_create(x,y,PlasmaTrail){
			motion_add(random(360),random_range(4,7))
		}
		with instance_create(x,y,Smoke){
			motion_add(random(360),random_range(2,4))
		}
	}
	instance_destroy()
}

#define beam_step
if instance_exists(creator){
    with creator{
        weapon_post(5,20*current_time_scale,0)
        motion_add(gunangle, -2*current_time_scale)
    }
	sound_play_gun(sndClickBack,1,.2 - brain_active *.2)
	sound_stop(sndClickBack)
    time -= current_time_scale
    if time <= 0 {instance_destroy(); exit}
    x = creator.x + creator.hspeed_raw + lengthdir_x(26,creator.gunangle)
    y = creator.y + creator.vspeed_raw + lengthdir_y(26,creator.gunangle)
    xstart = x
    ystart = y
    image_xscale = 1
    image_yscale = .5
    direction = creator.gunangle
    image_angle = direction

    var _x = lengthdir_x(2,direction), _y = lengthdir_y(2,direction)
    var dir = 0
    do {
    	dir += 2;
    	x += _x
    	y += _y
    }
    until dir >= 1800 || place_meeting(x,y,Wall)
		if place_meeting(x, y, Wall)
		{
			var _w = instance_nearest(x, y, Wall);
			if point_distance(creator.x, creator.y, _w.x, _w.y) <= 240 with _w
			{
				instance_create(x, y, FloorExplo)
				instance_destroy()
			}
			view_shake_at(x, y, 3)
			sleep(2)
			with instance_create(x + random_range(-8, 8), y + random_range(-8, 8), PlasmaImpact)
			{
				var _size = random_range(.4, .8)
				image_xscale = _size
				image_yscale = _size
				image_speed *= random_range(.8, 1.2)
				team = other.team
				creator = other.creator
			}
		}
    xprevious = x
    yprevious = y

    image_xscale = dir
    if current_frame_active{
        repeat(4)
        {
            var _r = random_range(0,image_xscale)
            with instance_create(xstart+lengthdir_x(_r,direction)+random_range(-5,5),ystart+lengthdir_y(_r,direction)+random_range(-5,5),BulletHit)
            {
            	sprite_index = sprPlasmaTrail
            	image_angle = other.direction
            	motion_set(other.direction,irandom_range(1, 3))
            }
        }
    }
    image_yscale = 1 * random_range(.9,1.1)
}
else instance_destroy()

#define old_beam_wall

#define beam_square
with other{
    motion_add(other.direction, 4*current_time_scale)
    if current_frame_active with instance_create(x + lengthdir_x(random(sprite_width/2),random(360)),y+lengthdir_y(random(sprite_height/2),random(360)),PlasmaImpact) {
        image_speed *= random_range(.4,.6);
        image_xscale = random_range(.6,.8);
        image_yscale = image_xscale
        team = other.pseudoteam
    }
}

#define old_beam_hit
if current_frame_active{
	sleep(5)
	view_shake_at(x,y,2)
    with other motion_set(other.direction,2 + skill_get(mut_laser_brain))
    view_shake_max_at(other.x,other.y,min(other.size,4))
    projectile_hit(other,6 + skill_get(mut_laser_brain)*3, 1, direction)
    if other.my_health <= 0{
        sleep(min(other.size, 4) * 20)
        view_shake_max_at(creator.x,creator.y,5*min(4, other.size))
    }
}
#define beam_draw
draw_sprite_ext(sprite_index, image_index, xstart + lengthdir_x(12, image_angle), ystart + lengthdir_y(12, image_angle), image_xscale - 16, image_yscale, image_angle, image_blend, 1.0);
	if x != xstart draw_sprite_ext(spr_tail, 0, xstart, ystart, 1, image_yscale, image_angle, image_blend, 1.0);
	if x != xstart draw_sprite_ext(spr_head, 0, x, y, 1, image_yscale*1, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, xstart + lengthdir_x(12, image_angle), ystart + lengthdir_y(12, image_angle), image_xscale - 27, 1.5*image_yscale, image_angle, image_blend, 0.15+brain_active*.05);
	if x != xstart draw_sprite_ext(spr_tail, 0, xstart, ystart, 1, image_yscale*1.5, image_angle, image_blend, .15+brain_active*.05);
	if x != xstart draw_sprite_ext(spr_head, 0, x, y, 1.5, image_yscale*1.5, image_angle, image_blend, .15+brain_active*.05);
draw_set_blend_mode(bm_normal);



#define sphere_draw
var _v = random_range(.95,1.05)
draw_self();
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, 0, x, y, image_xscale*1.5*_v, image_yscale*1.5*_v, image_angle, image_blend, .15+brain_active*.05);
draw_set_blend_mode(bm_normal);


#define sound_play_charge(_snd, _vol, _time)
with instance_create(x,y,CustomObject){
	creator = other
    pitch = .4 * choose(.8,1.2) * brain_active
    decel = random_range(.05,.06) * (.6 + brain_active * .2)
    p = random_range(.9,1.1)
    lifetime = 27
    vol = _vol
    snd = _snd
    time = _time
    sound = -1
    on_step    = sound_step
    on_destroy = sound_destroy
    return id
}

#define sound_step
if current_frame_active{
    if instance_exists(creator){
        with creator weapon_post((24-other.lifetime)/4,(24-other.lifetime)/4,0)
        view_shake_at(x,y,(24-lifetime)/3)
    }
    pitch += decel
    audio_stop_sound(sound)
    var q = audio_play_sound(snd, 1, 0)
    audio_sound_set_track_position(q, time)
    audio_sound_pitch(q, pitch * p)
    audio_sound_gain(q, vol, 0)
    sound = q
    //sound_play_pitchvol(snd,pitch*p,vol)
}
lifetime -= current_time_scale
if lifetime <= 0 instance_destroy()

#define sound_destroy
audio_stop_sound(sound)
//sound_play_pitch(snd,random_range(.8,1.2))

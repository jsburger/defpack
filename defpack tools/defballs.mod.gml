#define init
	global.sprDefBallS  = sprite_add("../sprites/projectiles/sprDefballS.png", 1, 3, 3);
	global.sprDefBallM  = sprite_add("../sprites/projectiles/sprDefballM.png", 1, 7, 7);
	global.sprDefBallL  = sprite_add("../sprites/projectiles/sprDefballL.png", 1, 15, 15);
	global.sprDefBallXL = sprite_add("../sprites/projectiles/sprDefballXL.png", 1, 30, 30);
	global.sprDefSquareS   = sprite_add("../sprites/projectiles/sprDefsquareS.png", 1, 3, 3);
	global.sprDefSquareM   = sprite_add("../sprites/projectiles/sprDefsquareM.png", 1, 7, 7);
	global.sprDefSquareL   = sprite_add("../sprites/projectiles/sprDefsquareL.png", 1, 15, 15);
	global.sprDefSquarelXL = sprite_add("../sprites/projectiles/sprDefsquareXL.png", 1, 30, 30);
	
#macro dev false
#macro alpha_cutoff random_range(.9, 1) // must be > 255 * alpha_cutoff to be drawn
#macro c_outline $00FF00 // colour of the outline
#macro c_square $3AFFAA  // outline colour for squares

#define step
	if (dev && button_pressed(0, "horn")) {
		
		repeat(16) with create_defball(mouse_x, mouse_y) {
			
			team = 0.team;
			creator = 0;
			accuracy = 0.accuracy;
			motion_add(0.gunangle, 12);
		}
	}

#define create_defball_s(X, Y)
	with create_defball(X, Y) {
		
		sprite_index = global.sprDefBallS;
		
		return self;
	}

#define create_defball_m(X, Y)
	with create_defball(X, Y) {
		
		sprite_index = global.sprDefBallM;
		
		return self;
	}

#define create_defball_l(X, Y)
	with create_defball(X, Y) {
		
		sprite_index = global.sprDefBallL;
		
		return self;
	}

#define create_defball_xl(X, Y)
	with create_defball(X, Y) {
		
		sprite_index = global.sprDefBallXL;
		
		return self;
	}

#define create_defball(X, Y)
	with instance_create(X, Y, CustomSlash) {
		
		sprite_index = choose(global.sprDefBallM, global.sprDefBallL, global.sprDefBallL);
		mask_index   = mskBigRad;
		image_speed  = 0;
		
		name = "defball";
		friction = 1;
		minspeed = .3 + random(.2);
		damage = 5;
		force  = 0;
		accuracy = 1;
		timer = 30 * choose(5, 6, 6, 8);
		color = c_outline // make_colour_hsv(random(255), 255, 255);
		target = -4; // if a target exists it homes into that
		
		image_angle = random(360);
		angspeed = choose(-1, 1) * (2 + random(40))
		
		on_hit  = defball_hit;
		on_step = defball_step;
		on_wall = defball_wall;
		on_projectile = defball_proj;
		on_grenade = nothing;
		on_draw = nothing;
		
		return self;
	}

#define defball_proj
	/*var _s = speed;
	motion_add(other.direction, other.speed);
	speed = _s;
	other.x -= lengthdir_x(other.speed * .3, other.direction);
	other.y -= lengthdir_y(other.speed * .3, other.direction);
	*/
#define defball_hit
		if (projectile_canhit_melee(other)) {
			
			projectile_hit(other, damage, speed * 1.6, direction);
			
			if (other.my_health <= 0) {
				
				sleep(10 + 20 * clamp(other.size, 1, 3));
				view_shake_at(x, y, 2 + 2 * clamp(other.size, 1, 3));
			}
			
			speed *= .5;
		}

#define defball_step
	direction += random_range(-12, 12) * accuracy * current_time_scale;

	if (speed < minspeed) {
		
		speed += friction + .15;
	}
	
	if (place_meeting(x, y, enemy)) {
		
		timer -= current_time_scale;
	}
	
	if (skill_get(mut_laser_brain) > 0) {
		
		if (irandom(99) < current_time_scale) {
			
			with instance_create(x + hspeed, y + vspeed, PlasmaTrail) {
				
				
				motion_add(random(360), .75 + random(.2));
				image_speed = .1;
			}
		}
	}
	
	angspeed *= .98;
	
	if (instance_exists(target)) {
		
		var _s = speed;
		motion_add(point_direction(x, y, target.x, target.y), max(3, speed * .2));
		speed = _s;
	}
	
	image_angle += angspeed
	
	timer -= current_time_scale;
	if (timer <= 0) {
		
		image_xscale -= .2;
		image_yscale -= .2;
		
		if (image_xscale <= .2) {
			
			instance_destroy();
		}
	}

#define defball_wall
	move_bounce_solid(false);
	speed *= .9;
	direction += random_range(-12, 12);

#define draw
	script_bind_draw(draw_defballs, -2);

#define draw_defballs()
	var _surface_main = surface_create(game_width, game_height),
		_surface_out  = surface_create(game_width, game_height);
	if (surface_exists(_surface_main) && surface_exists(_surface_out)) {
		
		draw_set_blend_mode(bm_add);
		surface_set_target(_surface_main);
		draw_clear_alpha(c_black, 0);
		with instances_matching(CustomSlash, "name", "defball") {
			
			x -= view_xview_nonsync;
			y -= view_yview_nonsync;
			draw_self();
			x += view_xview_nonsync;
			y += view_yview_nonsync;
		}
		surface_reset_target();
		
		surface_set_target(_surface_out);
		draw_clear_alpha(c_black, 0);
		with instances_matching(CustomSlash, "name", "defball") {
			
			x -= view_xview_nonsync;
			y -= view_yview_nonsync;
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 1.3, image_yscale * 1.3, image_angle, color, image_alpha);
			x += view_xview_nonsync;
			y += view_yview_nonsync;
		}
		surface_reset_target();
		
		draw_set_blend_mode(bm_normal);
		draw_set_alpha_test(true);
		draw_set_alpha_test_ref_value(255 * alpha_cutoff);
		
		draw_surface(_surface_out, view_xview_nonsync, view_yview_nonsync);
		draw_surface(_surface_main, view_xview_nonsync, view_yview_nonsync);
		
		surface_free(_surface_out);
		surface_free(_surface_main);
		
		draw_set_alpha_test(false);
	}
	instance_delete(self);

#define nothing
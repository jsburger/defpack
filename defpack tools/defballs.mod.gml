#define init
	global.sprDefBallS  = sprite_add("../sprites/projectiles/sprDefballS.png", 1, 3, 3);
	global.sprDefBallM  = sprite_add("../sprites/projectiles/sprDefballM.png", 1, 7, 7);
	global.sprDefBallL  = sprite_add("../sprites/projectiles/sprDefballL.png", 1, 15, 15);
	global.sprDefBallXL = sprite_add("../sprites/projectiles/sprDefballXL.png", 1, 30, 30);
	global.sprDefSquareS   = sprite_add("../sprites/projectiles/sprDefsquareS.png", 1, 3, 3);
	global.sprDefSquareM   = sprite_add("../sprites/projectiles/sprDefsquareM.png", 1, 7, 7);
	global.sprDefSquareL   = sprite_add("../sprites/projectiles/sprDefsquareL.png", 1, 15, 15);
	global.sprDefSquarelXL = sprite_add("../sprites/projectiles/sprDefsquareXL.png", 1, 30, 30);
	
	global.ballDrawer = noone
	
#macro dev false
#macro alpha_cutoff .75 + sin(current_frame) * .01 // must be > 255 * alpha_cutoff to be drawn
#macro c_outline $00FF00 // colour of the outline
#macro c_square $3AFFAA  // outline colour for squares

#macro surfaceMain global.surfaceMain
#macro surfaceOut global.surfaceOut
	surfaceMain = undefined;
	surfaceOut = undefined;
#macro ballList global.ballList
	ballList = []
	
#macro ballObj CustomSlash

#define cleanup
	with global.ballDrawer {
		instance_destroy()
	}
	surface_free(surfaceMain)
	surface_free(surfaceOut)

#define step
	if (dev && button_pressed(0, "horn")) {
		
		repeat(16) with create_defball(0.x, 0.y) {
			team = Player.team;
			creator = Player.id;
			accuracy = Player.accuracy;
			motion_add(Player.gunangle, sqrt(point_distance(x, y, mouse_x, mouse_y)));
		}
	}
	
	//Manage ballList and Ball Drawer
	if array_length(ballList) > 0 {
		//Remove nonexistant entries
		ballList = instances_matching_ne(ballList, "id", null)
		if array_length(ballList) > 0 {
			//Create the Ball Drawer
			if !instance_exists(global.ballDrawer) {
				with script_bind_draw(draw_defballs, -2) {
					persistent = true
					global.ballDrawer = id
				}
			}
		}
		else {
			//Destroy the Ball Drawer if no balls exist
			if instance_exists(global.ballDrawer) {
				with global.ballDrawer instance_destroy()
			}
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
	with instance_create(X, Y, ballObj) {
		
		sprite_index = choose(global.sprDefBallM, global.sprDefBallL, global.sprDefBallL);
		mask_index   = mskBigRad;
		image_speed  = 0;
		
		name = "defball";
		friction = .4;
		minspeed = .3 + random(.2);
		damage = 5;
		force  = 0;
		accuracy = 1;
		timer = 30 * choose(5, 6, 6, 8) + irandom(5);
		fadeColor = c_outline
		color = merge_color(c_white, fadeColor, random(.5)) // make_colour_hsv(random(255), 255, 255);
		target = -4;
		if array_length(ballList) > 0 {
			target = ballList[array_length(ballList) - 1]; // if a target exists it homes into that
		}
		
		image_angle = random(360);
		angspeed = choose(-1, 1) * (2 + random(40))
		image_alpha = random(.2) + .8
		
		on_hit  = defball_hit;
		on_step = defball_step;
		on_wall = defball_wall;
		on_projectile = defball_proj;
		on_grenade = nothing;
		on_draw = nothing;
		
		
		array_push(ballList, self)
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
	color = merge_color(color, fadeColor, .25 * current_time_scale)
	direction += random_range(-12, 12) * accuracy * current_time_scale;

	if (speed < minspeed) {
		
		speed = friction + minspeed;
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
	
	if (instance_exists(target)) && distance_to_object(target) > 5 {
		
		// var _s = speed;
		motion_add(point_direction(x, y, target.x, target.y), max(speed * .3, .5));
		speed = min(point_distance(x, y, target.x, target.y)/5, speed);
		
		with target {
			motion_add(point_direction(x, y, other.x, other.y), max(speed * .3, .5)/2);
		}
	}
	
	//Finds nearest defball and targets it
	if !instance_exists(target) && target != noone {
		var a = [];
		with ballList if instance_exists(self) {
			array_push(a, [self, distance_to_object(other)])
		}
		if array_length(a) > 1 {
			array_sort_sub(a, 1, true)
			target = a[1][0]
		}
	}
	
	image_angle += angspeed
	
	timer -= current_time_scale;
	if (timer <= 0) {
		
		image_xscale -= .1;
		image_yscale -= .1;
		
		if (image_xscale <= .2) {
			
			instance_destroy();
		}
	}

#define defball_wall
	move_bounce_solid(false);
	speed *= .9;
	direction += random_range(-12, 12);
	color = c_white

#define draw_defballs()
	if !surface_exists(surfaceMain) {
		surfaceMain = surface_create(game_width, game_height)
	}
	if !surface_exists(surfaceOut) {
		surfaceOut = surface_create(game_width, game_height)
	}
	
	//Blurs textures, fixes lower alpha test values looking dithered
	texture_set_interpolation(true)
	//Additive blending without alpha multiplication
	//Could be bm_one twice, but I'm trying to fix the issue with the square color blending
	draw_set_blend_mode_ext(bm_one, bm_inv_src_alpha);
	surface_set_target(surfaceMain);
	//Anything drawn will be converted to screenspace
	draw_set_projection(1)
	draw_clear_alpha(c_black, 0);
	with ballList if instance_exists(self) {
		draw_self();
	}
	
	surface_set_target(surfaceOut);
	draw_set_projection(1)
	draw_clear_alpha(c_black, 0);
	with ballList if instance_exists(self) {
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 1.5, image_yscale * 1.5, image_angle, color, image_alpha);
	}
	surface_reset_target();
	draw_reset_projection()
	
	//Reset interpolation (defaults off)
	texture_set_interpolation(false)
	
	//These two effects let it draw at full alpha without blending
	//Prevents the surfaces from writing to alpha
	draw_set_color_write_enable(true, true, true, false)
	//Makes the drawn surfaces not blend with anything below them
	draw_set_blend_mode_ext(bm_one, bm_zero)
	
	draw_set_alpha_test(true);
	draw_set_alpha_test_ref_value(255 * alpha_cutoff);
	draw_surface(surfaceOut, view_xview_nonsync, view_yview_nonsync);
	draw_surface(surfaceMain, view_xview_nonsync, view_yview_nonsync);
	
	draw_set_color_write_enable(true, true, true, true)
	draw_set_blend_mode(bm_normal);
	draw_set_alpha_test(false);

#define nothing
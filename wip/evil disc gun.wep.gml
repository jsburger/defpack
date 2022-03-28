#define init

#define weapon_name
return "EVIL DISC GUN"

#define weapon_type
return 3;

#define weapon_cost
return 1;

#define weapon_area
return -1;

#define weapon_load
return 12;

#define weapon_swap
return sndSwapBow;

#define weapon_auto
return false;

#define weapon_sprt
return sprDiscGun;

#define weapon_text
return "POSSESSED BY GREATER EVILS#THAN YOU COULD KNOW";

#define weapon_fire
	var c = instance_is(self, FireCont) && "creator" in self ? creator : self;
	sound_play_gun(sndDiscgun, .2, .8)
	with evil_disc_create(x, y) {
		motion_set(other.gunangle, 8)
		image_angle = direction
		projectile_init(other.team, c)
	}


#define evil_disc_create(x, y)
	with instance_create(x, y, CustomProjectile) {
		name = "EvilDisc"
		damage = 5;
		force = 4;
		image_speed = .4
		sprite_index = sprDisc
		image_blend = c_red
		curve = irandom_range(1, 5) * choose(-1, 1)
		lastBounce = 0
		
		mod_script_call("mod", "defpack tools", "disc_init")
		
		on_step = evil_step
		on_hit = evil_hit
		on_wall = evil_wall
		
		return id
	}
	
#define evil_step
	mod_script_call("mod", "defpack tools", "disc_step", 1)
	if dist >= 200 {
		instance_destroy()
		exit
	}
	if skill_get(mut_bolt_marrow) && instance_exists(enemy) {
		var nearest = instance_nearest(x, y, enemy);
		if !instance_exists(collision_line(x, y, nearest.x, nearest.y, Wall, false, false)) {
			//Ancient, forbidden, and incomprehesible homing technique
			var	dir = point_direction(x, y, nearest.x, nearest.y),
				diff = angle_difference(direction + curve/2 * current_time_scale, dir);
			
			curve -= clamp(abs(diff), 0, max(1, abs(curve)/3)) * sign(diff) * current_time_scale;
		}
	}
	//This is where the magic happens
	direction += curve * current_time_scale
	image_angle += curve * current_time_scale

#define evil_hit
	if (projectile_canhit_melee(other)) {
		projectile_hit(other, damage, force, direction)
	}

#define evil_wall
	if (lastBounce != current_frame) {
		lastBounce = current_frame
		
		//0 top, 1 left, 2 bottom, 3 right
		var deflectFace = (floor((point_direction(other.x + 8, other.y + 8, x, y) - 45)/90) + 4) mod 4;
		
		//Horizontal deflection
		if (deflectFace mod 2 == 1) {
			hspeed *= -1
		}
		//Vertical deflection
		else {
			vspeed *= -1
		}
		image_angle = direction
		// curve = irandom_range(-5, 5)
		sound_play_hit(sndDiscBounce, .1)
		// move_outside_solid((deflectFace + 1) * 90, speed_raw)
		move_outside_solid(direction, speed_raw)

	}






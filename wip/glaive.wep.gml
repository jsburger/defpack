#define init
  global.sprGlaive = sprite_add_weapon("../sprites/weapons/sprGlaive.png", 11, 11);

#define weapon_name
  return "GLAIVE";

#define weapon_sprt
  return global.sprGlaive;

#define weapon_type
  return 0;

#define weapon_auto
  return true;

#define weapon_load
  return 24;

#define weapon_cost
  return 0;

#define weapon_swap
  return sndSwapHammer;

#define weapon_area
  return -1;

#define weapon_text
  return "ON THE HUNT";

#define weapon_fire
	var _p = random_range(.8, 1.2);
	
	with instance_create(x, y, CustomSlash){
		sprite_index = sprBullet1;
		mask_index   = sprite_index;
		
		image_speed = 0;
		
		team       = other.team;
		creator    = other;
		hitmes[0]  = -4;	 // array of hitmes that have been hit
		maxhit     = 4;		 // how many enemies can be hit before the glaive returns
		bounce     = 5;
		target     = -4;     // current hitme target
		damage     = 12;
		force      = 0;
		maxspeed   = 12;
		trnspeed   = 4;
		candeflect = false;
		dis        = 0;
		maxdis     = 480;
		motion_set(creator.gunangle + random_range(-6, 6) * creator.accuracy, maxspeed);
		
		on_step = glaive_step;
		on_wall = glaive_wall;
		on_hit  = glaive_hit;
	}
	
 #define glaive_step
	dis += speed;
	if (instance_exists(target) && target > noone && maxhit > 0){
		var _td = point_direction(x, y, target.x, target.y);
		motion_add(_td, trnspeed);
		//trace(object_get_name(target.object_index))
	}else{
	}
	if speed > maxspeed{speed = maxspeed}

 #define glaive_wall
	sleep(10);
	view_shake_at(x, y, 2);
	bounce--;
	array_push(hitmes, other);
	move_bounce_solid(false);
	target = target_find(x, y, hitmes, team);
	if target > -4 {
			motion_set(point_direction(x, y, target.x, target.y), maxspeed);
	}
	instance_create(x, y, Dust);
	with instance_create(x - hspeed, y - vspeed, MeleeHitWall){
		image_angle = other.direction - 180;
	}
	sound_play_pitchvol(sndMeleeWall, 1, .35);
	if bounce < 0 || dis >= maxdis{
		instance_destroy();
	}

 #define glaive_hit
	if other = target || target = -4{
		maxhit--;
		if target = -4{
			target = other;
		}
		array_push(hitmes, other);
		if projectile_canhit_melee(other) = true projectile_hit(other, damage, force, direction);
		target = target_find(x, y, hitmes, team);
		if target > -4 {
			motion_set(point_direction(x, y, target.x, target.y), maxspeed);
		}else{
			direction += random_range(-28, 28) * max(1, other.size);
		}
		sleep(9 + 5 * clamp(other.size, 1, 4));
		view_shake_at(x, y, 2 + 1.5 * clamp(other.size, 1, 3));
	}
	if instance_is(other, prop){
		projectile_hit(other, damage, force, direction);
	}

 #define target_find(_x, _y, _targets, _team)
	var mans = [],
	    found = -4;
	    
	    with instances_matching_ne(hitme, "team", _team){
	    	if collision_line(_x ,_y, x, y, Wall, 0, 0) = -4 && distance_to_object(other) <= 128 &&  projectile_canhit_melee(other) = true && !instance_is(self, prop) && _targets[array_length(_targets) - 1] != id{
	        	array_push(mans, self);
	    	}
	    }
	if array_length_1d(mans) > 0 found = mans[irandom(array_length_1d(mans) - 1)];
	return found;
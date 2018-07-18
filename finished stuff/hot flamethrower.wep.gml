#define init
global.sprHotFlamethrower = sprite_add_weapon("sprHotFlamethrower.png", 7, 4);

#define weapon_name
return "HOT FLAMETHROWER";

#define weapon_sprt
return global.sprHotFlamethrower;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 5;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapFlame;

#define weapon_area
return 9;

#define weapon_text
return "SPICY";


#define weapon_fire
sleep(6)
//huge fuckin props to yokin for letting me use code from GunLocker for this
var _load = weapon_get_load(argument0);

	 // Sound:
	if(button_pressed(index, "fire") ||(race = "steroids" || race = "venuz" || race = "skeleton") && button_pressed(index, "spec")) instance_create(x,y,FlameSound);
	with(FlameSound) timeout = -_load;

	 // Kick, Shift, Shake:
	if(fork()){
		repeat(_load) if(instance_exists(self)){
			weapon_post(3, -3, 2);
			wait 1;
		}
		exit;
	}

	 // Flames:
	repeat(_load) if(instance_exists(self)){
		repeat(4) with instance_create(x,y,CustomProjectile){
			move_contact_solid(other.gunangle, 6);
			sprite_index = sprFishBoost
			image_angle = random(360)
			motion_add(other.gunangle + (random_range(-43, 43) * other.accuracy),random_range(8,14));
			hitid = [sprite_index, "Water"];
			damage = 2
			image_speed = .5
			team = other.team;
			creator = other;
			on_anim 	 = water_anim
			on_wall 	 = water_wall
			on_destroy = water_destroy
		}
		wait 1;
	}

#define water_anim
instance_destroy()

#define water_wall
move_bounce_solid(false)

#define water_destroy
with instance_create(x,y,RainSplash){image_angle = other.direction + 90}

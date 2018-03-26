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
		repeat(3) with instance_create(x,y,Flame){
			move_contact_solid(other.gunangle, 6);
			sprite_index = sprFireLilHunter
			motion_add(other.gunangle + (random_range(-2, 2) * other.accuracy), 10 + random(2));
			hitid = [sprite_index, "Hot Flame"];
			damage = 5
			team = other.team;
			creator = other;
		}
		wait 1;
	}

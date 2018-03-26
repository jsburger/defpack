#define init
global.sprHotDragon = sprite_add_weapon("sprHotDragon.png", 8, 8);

#define weapon_name
return "HOT DRAGON";

#define weapon_sprt
return global.sprHotDragon;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 6;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapDragon;

#define weapon_area
return 13;

#define weapon_text
return choose("HEY, IT'S DPS","LET THEM FEEL THE DRAGONS ANGER");

#define weapon_fire
//huge fuckin props to yokin for letting me use code from GunLocker for this
//thank you yokin!
var _load = weapon_get_load(argument0);

	 // Sound:
	if(button_pressed(index, "fire") ||(race = "steroids" || race = "venuz" || race = "skeleton") && button_pressed(index, "spec")) instance_create(x,y,DragonSound);
	with(DragonSound) timeout = -_load;

	 // Kick, Shift, Shake:
	if(fork()){
		repeat(_load) if(instance_exists(self)){
			weapon_post(6, -3, 5);
			wait 1;
		}
		exit;
	}

	 // Flames:
	repeat(_load) if(instance_exists(self)){
		repeat(7) with instance_create(x,y,Flame){
			move_contact_solid(other.gunangle, 6);
			sprite_index = sprFireLilHunter
			motion_add(other.gunangle + (random_range(-15, 15) * other.accuracy), 10 + random(5));
			hitid = [sprite_index, "Hot Flame"];
			team = other.team;
			damage = 5
			creator = other;
		}
		wait 1;
	}

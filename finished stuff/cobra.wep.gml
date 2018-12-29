#define init
global.sprCobra = sprite_add_weapon("sprCobra.png", 8, 6);

#define weapon_name
return "COBRA";

#define weapon_sprt
return global.sprCobra;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 12;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapDragon;

#define weapon_area
if array_length(instances_matching(Player, "notoxic", 1)) return 13
return -1;

#define weapon_text
return choose("HEY, IT'S DPS","DO THE SERPENT SWAY");

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
		repeat(4) with instance_create(x,y,ToxicGas){
			move_contact_solid(other.gunangle, 16);
			motion_add(other.gunangle + (random_range(-15, 15) * other.accuracy), random_range(2,4));
		}
		wait 1;
	}

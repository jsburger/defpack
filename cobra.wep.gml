#define init
global.sprCobra = sprite_add_weapon("sprites/weapons/sprCobra.png", 8, 6);

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
sound_play_pitchvol(sndScorpionHit, 1.4, 1.3);
sound_play_pitch(sndToxicBoltGas, 1.4);
sound_play_pitchvol(sndSwapFlame, 1, .6);
return -4;

#define weapon_area
if array_length(instances_matching(Player, "notoxic", 1)) return 13
return -1;

#define weapon_text
return choose("HEY, IT'S DPS","DO THE SERPENT SWAY");

#define nts_weapon_examine
return{
	"frog": "Why them and not mom? ",
    "d": "A beefed up Toxicthrower. #Cobras used to be a common - and deadly sight in the Desert. ",
}
#define weapon_fire
//huge fuckin props to yokin for letting me use code from GunLocker for this
//thank you yokin!
var _load = weapon_get_load(argument0);

	 // Sound:
	if(button_pressed(index, "fire") ||(race = "steroids" || race = "venuz" || race = "skeleton") && button_pressed(index, "spec")) instance_create(x,y,DragonSound);
	with(DragonSound){
		timeout = -_load;
		is_cobra = true;
	};

	 // Kick, Shift, Shake:
	if(fork()){
		repeat(_load) if(instance_exists(self)){
			weapon_post(6, -12, 0);
			wait(1);
		}
		exit;
	}

	 // Flames:
	repeat(_load) if(instance_exists(self)){
		repeat(4) with instance_create(x,y,ToxicGas){
			move_contact_solid(other.gunangle,18);
			motion_add(other.gunangle + (random_range(-15, 15) * other.accuracy), random_range(2,4));
		}
		wait 1;
	}

#define step
with instances_matching(DragonSound, "is_cobra", true){
	if timeout >= 0{
		sound_play_pitchvol(sndScorpionFireStart, 1.5, 1.4);
	}
}

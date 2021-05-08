#define init
global.sprToxicthrower = sprite_add_weapon("sprites/weapons/sprToxicthrower.png", 7, 4);

#define weapon_name
return "TOXICTHROWER";

#define weapon_sprt
return global.sprToxicthrower;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 12;

#define weapon_cost
return 1;

#define weapon_swap
sound_play_pitch(sndToxicBoltGas, 1.4);
sound_play_pitchvol(sndSwapFlame, 1, .6);
return -4;

#define weapon_area
if array_length(instances_matching(Player, "notoxic", 1)) return 9
return -1;

#define weapon_text
return "FOUL REPTILE";

#define nts_weapon_examine
return{
	"frog": "A lovely little weapon. ",
    "d": "Fires a stream of noxious gas. #You have to have the right nose to find one of these. ",
}
#define weapon_fire
sleep(6)
//huge fuckin props to yokin for letting me use code from GunLocker for this
var _load = weapon_get_load(mod_current);

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
		repeat(2) with instance_create(x,y,ToxicGas){
			move_contact_solid(other.gunangle,18);
			image_angle = random(360)
			gas_special = true
			team = other.team
			motion_add(other.gunangle + (random_range(-6, 6) * other.accuracy),random_range(2,3));
		}
		wait 1;
	}

#define step
with instances_matching(ToxicGas, "gas_special", true){
	if !place_meeting(x, y, Player){
		team = -4;
		gas_special = false;
	}
}

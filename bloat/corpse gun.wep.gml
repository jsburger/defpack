#define init
global.brush[0] = sprite_add_weapon("../sprites/weapons/sprToothbrush.png"      ,0,0)

#define weapon_name
return "CORPSE GUN"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return -1;
#define weapon_load
return 2
#define weapon_swap
return sndSwapHammer
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
	var _pitch = random_range(.8, 1.2);
	sound_play_pitch(sndFlyFire, _pitch)

	repeat(1 + irandom(1))with instance_create(x, y, Corpse){
		size = 3;
		sprite_index = sprMaggotDead
		motion_add(other.gunangle + random_range(-8, 8), 14 + random(6))
		friction *= 3;
	}

#define weapon_sprt
return global.brush[0]
#define weapon_text
return "no toothpaste"
#define nts_weapon_examine
return{
    "d": "Keep your enemies clean. ",
}

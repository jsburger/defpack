#define init
global.sprFlechetteRifle = sprite_add_weapon("sprites/weapons/sprFlechetteRifle.png", 6, 3);

#define weapon_name
return "FLECHETTE RIFLE";

#define weapon_sprt
return global.sprFlechetteRifle;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 6;

#define weapon_cost
return 3;

#define weapon_laser_sight
return true;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 12;

#define weapon_text
return "TERROR ABSOLUTE";

#define weapon_fire
repeat(2){
weapon_post(5,-4,8)
with instance_create(x,y,Shell){motion_add(other.gunangle+other.right*100+random(80)-40,2+random(2))}
sound_play_pitch(sndUltraCrossbow,random_range(2.5,3))
sound_play_pitch(sndCrossbow,random_range(.4,.6))
sound_play_pitchvol(sndShotgun,random_range(1.4,1.6),.3)
	with mod_script_call("mod", "defpack tools", "create_flechette", x, y){
		creator = other;
		team    = creator.team;
		motion_add(other.gunangle + random_range(-6, 6) * creator.accuracy, 20);
		image_angle = direction;
	}
	wait(3)
	if !instance_exists(self){exit}
}

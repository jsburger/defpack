#define init
global.sprFlechetteRifle = sprite_add_weapon("sprites/weapons/sprFlechetteRifle.png", 6, 3);

#define weapon_name
return "DART RIFLE";

#define weapon_sprt
return global.sprFlechetteRifle;

#define weapon_type
return 3;

#define weapon_auto
return true;

#define weapon_load
return 6;

#define weapon_cost
return 2; // 1 bolt + 1 explo

#define weapon_laser_sight
return true;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 12;

#define weapon_text
return "STICKY @wDARTS";

#define weapon_fire
weapon_post(5,-4,8)
sound_play_pitch(sndUltraCrossbow,random_range(2.5,3))
sound_play_pitch(sndCrossbow,random_range(.4,.6))
sound_play_pitchvol(sndShotgun,random_range(1.4,1.6),.3)
with mod_script_call("mod", "defpack tools", "create_flechette", x + lengthdir_x(6, gunangle), y + lengthdir_y(6, gunangle)){
	creator = other;
	team    = creator.team;
	motion_add(other.gunangle + random_range(-6, 6) * creator.accuracy, 20);
	image_angle = direction;
}
if !instance_exists(self){exit}

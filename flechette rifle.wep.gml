#define init
global.sprFlechetteRifle = sprite_add_weapon("sprites/sprFlechetteRifle.png", 6, 3);
global.sprShellFlechette = sprite_add("sprites\sprShellFlechette.png",0,2,4)
global.sprFlechette  = sprite_add("sprites\projectiles\sprFlechette.png",0,3,2)
global.mskFlechette  = sprite_add("sprites\projectiles\mskFlechette.png",0,3,2)

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
return 14;

#define weapon_text
return "TERROR ABSOLUTE";

#define weapon_fire
repeat(2){
weapon_post(5,-4,8)
with instance_create(x,y,Shell){sprite_index = global.sprShellFlechette;motion_add(other.gunangle+other.right*100+random(80)-40,2+random(2))}
sound_play_pitch(sndUltraCrossbow,random_range(2.5,3))
sound_play_pitch(sndCrossbow,random_range(.4,.6))
sound_play_pitchvol(sndShotgun,random_range(1.4,1.6),.3)
	with instance_create(x+lengthdir_x(3,gunangle),y+lengthdir_y(3,gunangle),Splinter){
		motion_add(other.gunangle+random_range(-7,7)*other.accuracy,26)
		image_angle = direction
		team = other.team
		damage = 6
		sprite_index = global.sprFlechette
		mask_index   = global.mskFlechette
		creator = other
	}
	wait(3)
	if !instance_exists(self){exit}
}

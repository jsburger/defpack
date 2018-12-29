#define init
global.sprFlechetteShotgun = sprite_add_weapon("sprites/sprFlechetteShotgun.png", 5, 2);
global.sprFlechette  = sprite_add("sprites\projectiles\sprFlechette.png",0,3,2)
global.mskFlechette  = sprite_add("sprites\projectiles\mskFlechette.png",0,3,2)

#define weapon_name
return "FLECHETTE SHOTGUN";

#define weapon_sprt
return global.sprFlechetteShotgun;

#define weapon_type
return 2;

#define weapon_auto
return true;

#define weapon_load
return 20;

#define weapon_cost
return 1;

#define weapon_laser_sight
return true;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 14;

#define weapon_text
return "ANTI-PERSONELL WATER GUN";

#define weapon_fire
repeat(2){
weapon_post(7,-8,22)
sound_play_pitch(sndUltraCrossbow,random_range(2.5,3))
sound_play_pitch(sndCrossbow,random_range(.4,.6))
sound_play_pitch(sndDoubleShotgun,random_range(1.2,1.4))
with instance_create(x+lengthdir_x(3,gunangle),y+lengthdir_y(3,gunangle),Splinter){
	motion_add(other.gunangle+random_range(-7,7)*other.accuracy-4*other.accuracy,26+random_range(-3,3))
	image_angle = direction
	team = other.team
	damage = 6
	sprite_index = global.sprFlechette
	mask_index   = global.mskFlechette
	creator = other
}

with instance_create(x+lengthdir_x(3,gunangle),y+lengthdir_y(3,gunangle),Splinter){
	motion_add(other.gunangle+random_range(-7,7)*other.accuracy+4*other.accuracy,26+random_range(-3,3))
	image_angle = direction
	team = other.team
	damage = 6
	sprite_index = global.sprFlechette
	mask_index   = global.mskFlechette
	creator = other
}
}
with instance_create(x+lengthdir_x(3,gunangle),y+lengthdir_y(3,gunangle),Splinter){
	motion_add(other.gunangle+random_range(-2,2)*other.accuracy,26+random_range(-2,2))
	image_angle = direction
	team = other.team
	damage = 6
	sprite_index = global.sprFlechette
	mask_index   = global.mskFlechette
	creator = other
}

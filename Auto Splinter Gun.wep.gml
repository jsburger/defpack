#define init
global.sprAutoSplinterGun = sprite_add_weapon("sprites/Auto Splinter Gun.png", 2, 3);

#define weapon_name
return "AUTO SPLINTER GUN";

#define weapon_sprt
return global.sprAutoSplinterGun;

#define weapon_type
return 3;

#define weapon_auto
return true;

#define weapon_load
return 7;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 14;

#define weapon_text
return "TERROR ABSOLUTE";

#define weapon_fire
weapon_post(2,-3,3)
sound_play_pitch(sndSplinterGun,random_range(1.1,1.4))
sound_play_pitchvol(sndSplinterPistol,.8,.7)
repeat(4){
	with instance_create(x+lengthdir_x(3,gunangle),y+lengthdir_y(3,gunangle),Splinter){
		motion_add(other.gunangle+(random(20)-10)*other.accuracy,20+random(4))
		image_angle = direction
		team = other.team
		creator = other
	}
}

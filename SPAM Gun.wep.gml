#define init
global.sprSpamGun = sprite_add_weapon("sprites/SPAM Gun.png", 0, 2);

#define weapon_name
return "SPAM GUN";

#define weapon_sprt
return global.sprSpamGun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 1;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 10;

#define weapon_text
return choose("DOING NOBODY A FAVOUR","STALE");

#define weapon_fire
sound_play(sndPistol)
weapon_post(0,0,5)
with instance_create(x,y,Shell){
	motion_add(random(359),2+random(2))
}
with instance_create(x, y ,Bullet1){
	motion_add(random(359),4 + random(2))
	damage = 4
	creator = other
	image_angle = direction
	image_speed = 0
	team = other.team
}

#define init
global.sprSpamGun = sprite_add_weapon("sprites/weapons/sprSpamGun.png", 0, 2);

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
return 7;

#define nts_weapon_examine
return{
    "d": "Can you believe it? #There is a gun in this can! ",
}
#define weapon_text
return choose("DOING NOBODY A FAVOUR","STALE");

#define weapon_fire
var _p = random_range(.6, 1.3)
sound_play_pitch(sndSwapExplosive, 1.7 * _p)
sound_play_pitch(sndFlyFire,.7 * _p)
sound_play_pitch(sndFrogExplode,.7 * _p)
weapon_post(random_range(-2, 2),0,5)
with instance_create(x,y,Shell){
	motion_add(other.gunangle-180+random_range(-180,180)*other.accuracy,2+random(2))
}
with instance_create(x, y ,Bullet1){
	motion_add(other.gunangle+random_range(-180,180)*other.accuracy,4 + random(2))
	damage = 4
	creator = other
	image_angle = direction
	image_speed = 0
	team = other.team
}

#define init
global.sprFireSpamGun = sprite_add_weapon("sprites/weapons/sprFireSpamGun.png", 0, 2);

#define weapon_name
return "FIRE SPAM GUN";

#define weapon_sprt
return global.sprFireSpamGun;

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
return 9;

#define weapon_text
return choose("BURN THEM TO THE BOILING BOTTOM","STALE & STEAMING");

#define weapon_fire
var _p = random_range(.6, 1.3)
sound_play_pitch(sndSwapExplosive, 1.7 * _p)
sound_play_pitch(sndFrogExplode,.7 * _p)
sound_play_pitch(sndFlyFire,.7 * _p)
weapon_post(random_range(-3, 3),0,5)
with instance_create(x,y,Shell){
	motion_add(other.gunangle-180+random_range(-180,180)*other.accuracy,2+random(2))
}
with instance_create(x,y,FireBall){
	motion_add(other.gunangle+random_range(-180,180)*other.accuracy,5)
	damage = 5
	image_angle = direction
	team = other.team
	creator = other
	if fork() {
		while(instance_exists(self))
		{
			if place_meeting(x +hspeed,y +vspeed,enemy)
			{
				with instance_create(x +hspeed,y +vspeed,Flame)
				{
					team = other.team
					sound_play(sndBurn)
				}
			}
			wait(1)
		}
		exit
	}
}

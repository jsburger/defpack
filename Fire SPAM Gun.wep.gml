#define init
global.sprFireSpamGun = sprite_add_weapon("sprites/Fire SPAM Gun.png", 0, 2);

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
return 12;

#define weapon_text
return choose("BURN THEM TO THE BOILING BOTTOM","STALE & STEAMING","TO MELT EVERYONE");

#define weapon_fire
weapon_post(0,0,6)
sound_play_pitch(sndSwapExplosive,random_range(1.5,1.9))
sound_play_pitch(sndFrogExplode,random_range(.6,.8))
sound_play_pitch(sndFlyFire,random_range(.6,.8))
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

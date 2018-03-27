#define init
global.sprFireSpamGun = sprite_add_weapon("sprites/Fire SPAM Gun.png", 2, 0);

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
weapon_post(0,0,3)
sound_play(sndPistol)
with instance_create(x,y,Shell){
	motion_add(random(359),2+random(2))
}
with instance_create(x,y,FireBall){
	motion_add(random(359),5)
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

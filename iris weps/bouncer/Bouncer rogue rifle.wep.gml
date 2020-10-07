#define init
global.sprBouncerRogueRifle = sprite_add_weapon("../../sprites/weapons/iris/bouncer/sprBouncerRogueRifle.png", 3, 2);

#define weapon_name
return "BOUNCER ROGUE RIFLE"

#define weapon_sprt
return global.sprBouncerRogueRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 6;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return choose("TACTICAL ADVANTAGE");

#define weapon_fire

repeat(2){
	sound_play_pitch(sndBouncerSmg,random_range(1.1,1.2))
	sound_play(sndRogueRifle)
	weapon_post(4,-7,3)
	with instance_create(x,y,Shell){motion_add(other.gunangle+180+random(80)-40,2+random(2))}
	with instance_create(x,y,BouncerBullet)
	{
		team = other.team
		creator = other
		motion_add(other.gunangle+(random_range(-8, 8))*other.accuracy,6)
	}
	wait(3);
}

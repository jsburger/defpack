#define init
global.sprGoldenAssaultBouncerRifle = sprite_add_weapon("../../sprites/weapons/iris/bouncer/sprGoldenAssaultBouncerRifle.png", 3, 2);

#define weapon_name
return "GOLDEN BOUNCER ASSAULT RIFLE"

#define weapon_sprt
return global.sprGoldenAssaultBouncerRifle;

#define weapon_gold
return -1;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 14;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return choose("TRIPLE BOUNCE @yDELUXE");

#define weapon_fire

repeat(3)
{
	with instance_create(x,y,Shell){motion_add(other.gunangle-180+random_range(-40,40),2+random(2))}
	sound_play_pitch(sndBouncerSmg,random_range(1.1,1.2))
	sound_play_pitch(sndGoldMachinegun,random_range(.8,1.2))
	weapon_post(4,0,5)
	with instance_create(x,y,BouncerBullet)
	{
		team = other.team
		creator = other
		motion_add(other.gunangle+random_range(-8,8)*other.accuracy,6)
	}
	wait(3)
	if !instance_exists(self){exit}
}

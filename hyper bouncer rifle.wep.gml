#define init
global.sprHyperBouncerRifle = sprite_add_weapon("sprites/sprHyperBouncerRifle.png", 6, 7);
#define weapon_name
return "HYPER BOUNCER RIFLE";

#define weapon_sprt
return global.sprHyperBouncerRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 10;

#define weapon_cost
return 5;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "bizarre looking weaponry";

#define weapon_fire

repeat(5)
{
	weapon_post(3,0,7)
	sound_play_pitch(sndHyperRifle,random_range(1.2,1.3))
	sound_play_pitch(sndBouncerSmg,random_range(.6,.8))
	with instance_create(x,y,Shell){motion_add(other.gunangle+180+random_range(-40,40),2+random(2))}
	with instance_create(x,y,BouncerBullet)
	{
		move_contact_solid(other.gunangle,10)
		team = other.team
		creator = other
		motion_add(other.gunangle+random_range(-4,4)*other.accuracy,8)
		image_angle = direction - 90
	}
	wait(2)
	if !instance_exists(self) exit
}

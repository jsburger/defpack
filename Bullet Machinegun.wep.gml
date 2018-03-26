#define init
global.sprBulletMachinegun = sprite_add_weapon("Bullet Machinegun.png", 2, 1);

#define weapon_name
return "BULLET MACHINEGUN";

#define weapon_sprt
return global.sprBulletMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 6;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 13;

#define weapon_text
return "OUR POWERS COMBINED";

#define weapon_fire

weapon_post(4,-10,7)
sound_play(sndTripleMachinegun)
repeat(3)
{
	with instance_create(x,y,Shell)
	{
		motion_add(other.gunangle+other.right*100+random(50)-25,2+random(5))
	}
}
with instance_create(x,y,Shell)
{
	sprite_index = sprHeavyShell
	motion_add(other.gunangle+other.right*100+random(50)-25,2+random(5))
}
with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),Bullet1)
{
	motion_add(other.gunangle+random_range(-14,14)*other.accuracy,20)
	team = other.team
	creator = other
	image_angle = direction
}
with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),BouncerBullet)
{
	motion_add(other.gunangle+random_range(-14,14)*other.accuracy,8)
	team = other.team
	image_angle = random(359)
	creator = other
}
with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),HeavyBullet)
{
	motion_add(other.gunangle+random_range(-14,14)*other.accuracy,16)
	team = other.team
	creator = other
	image_angle = direction
}

#define init
global.sprDoubleBouncerMinigun = sprite_add_weapon("sprites/sprDoubleBouncerMinigun.png", 4, 2);

#define weapon_name
return "DOUBLE BOUNCER MINIGUN"

#define weapon_sprt
return global.sprDoubleBouncerMinigun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 2;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return choose("WOBBLE WOBBLE","YOU AND I WEREN'T MEANT TO BE");

#define weapon_fire
motion_add(gunangle-180,1.5)
sound_play_pitch(sndBouncerSmg,random_range(1.1,1.2))
sound_play_pitch(sndDoubleMinigun,random_range(.8,1.2))
weapon_post(6,0,14)
repeat(2)with instance_create(x,y,Shell){motion_add(other.gunangle+90+random_range(-40,40),2+random(2))}
with instance_create(x,y,BouncerBullet)
{
	move_contact_solid(other.gunangle,12)
	team = other.team
	creator = other
	motion_add(other.gunangle-20+random_range(-21,21)*other.accuracy,6)
	image_angle = direction
}
with instance_create(x,y,BouncerBullet)
{
	move_contact_solid(other.gunangle,12)
	team = other.team
	creator = other
	motion_add(other.gunangle+20+random_range(-21,21)*other.accuracy,6)
	image_angle = direction
}

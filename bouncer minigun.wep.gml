#define init
global.sprBouncerMinigun = sprite_add_weapon("sprites/sprBouncerMinigun.png", 3, 4);

#define weapon_name
return "BOUNCER MINIGUN"

#define weapon_sprt
return global.sprBouncerMinigun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 2;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return choose("WOBBLE WOBBLE","YOU AND I WEREN'T MEANT TO BE");

#define weapon_fire

sound_play_pitch(sndBouncerSmg,random_range(1.1,1.2))
sound_play_pitch(sndMinigun,random_range(.8,1.2))
weapon_post(5,0,8)
with instance_create(x,y,Shell){motion_add(other.gunangle+90+random_range(-40,40),2+random(2))}
with instance_create(x,y,BouncerBullet)
{
	move_contact_solid(other.gunangle,12)
	team = other.team
	creator = other
	motion_add(other.gunangle+random_range(-21,21)*other.accuracy,6)
	image_angle = direction
}

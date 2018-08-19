#define init
global.sprQuartzCrossbow = sprite_add_weapon("sprites/sprQuartzCrossbow.png", 11, 6);
global.sprQuartzBolt 	   = sprite_add("sprites/projectiles/sprQuartzBolt.png",0, 13, 4);

#define weapon_name
return "QUARTZ CROSSBOW"

#define weapon_sprt
return global.sprQuartzCrossbow;

#define weapon_type
return 3;

#define weapon_auto
return false;

#define weapon_load
return 27;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return -1;

#define weapon_text
return choose("BREAKTHROUGH");

#define weapon_fire
weapon_post(10,-25,6)
sound_play(sndHeavyCrossbow)
with instance_create(x,y,HeavyBolt)
{
	sprite_index = global.sprQuartzBolt
	damage = 50
	motion_add(other.gunangle + random_range(-2,2)*other.accuracy,28)
	image_angle = direction
}

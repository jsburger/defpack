#define init
global.sprAFC = sprite_add_weapon("sprites/sak/sprAutoFlakCannon.png", 2, 2);

#define weapon_name
return "AUTO FLAK CANNON";

#define weapon_sprt
return global.sprAFC;

#define weapon_type
return 2;

#define weapon_auto
return true;

#define weapon_load
return 12;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 12;

#define weapon_text
return "NOT ENOUGH WATER";

#define weapon_fire
weapon_post(3,-4,7)
sound_play(sndFlakCannon)
with instance_create(x+lengthdir_x(sprite_height-6,gunangle),y+lengthdir_y(sprite_height-6,gunangle),FlakBullet)
{
	motion_add(other.gunangle +(random(12)-6)*other.accuracy,11+random(2))
	image_angle = direction
	team = other.team
	creator = other
}

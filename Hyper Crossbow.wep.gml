#define init
global.sprHyperCrossbow = sprite_add_weapon("sprites/Hyper Crossbow.png", 7, 3);
global.sprHyperBolt = sprite_add("sprites/projectiles/hyper bolt.png",2, 8, 8);
global.sprHyperSplinter = sprite_add("sprites/projectiles/hyper splinter.png",3, -6, 3);

#define weapon_name
return "HYPER CROSSBOW"

#define weapon_sprt
return global.sprHyperCrossbow;

#define weapon_type
return 3;

#define weapon_auto
return false;

#define weapon_load
return 8;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 9;

#define weapon_text
return choose("THOSE BOLTS ARE HUGE","A CONTINOUS STATE OF HYPE","HYPER HYPER");

#define weapon_fire
sound_play(sndCrossbow)
sound_play_pitch(sndHyperLauncher,7)
sound_play(sndHyperRifle)
weapon_post(8,-20,4)
with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),Bolt)
{
	damage = 40
	var dir = 0;
	do
	{
		dir += 1 x += lengthdir_x(1,direction) y += lengthdir_y(1,direction)
		if irandom(1) = 0 with instance_create(x,y,Dust){motion_add(other.direction-random_range(-80,80),random_range(2,7));growspeed = random_range(0.1,0.005)}
		if place_meeting(x,y,enemy) || place_meeting(x,y,Wall)
		{

		}
	}
	while instance_exists(self) and !place_meeting(x,y,Wall) and !place_meeting(x,y,enemy) and dir < 1000
	speed = other.speed+1
	mask_index = other.mask_index
	instance_destroy()
}

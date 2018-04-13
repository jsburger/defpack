#define init
global.sprHyperCrossbow = sprite_add_weapon("sprites/sprHyperCrossbow.png", 5, 8);
global.sprHyperBolt 		= sprite_add("sprites/projectiles/sprHyperBolt.png",2, 8, 8);

#define weapon_name
return "HYPER CROSSBOW"

#define weapon_sprt
return global.sprHyperCrossbow;

#define weapon_type
return 3;

#define weapon_auto
return false;

#define weapon_load
return 14;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 9;

#define weapon_text
return choose("BOLT STREAMER","A CONTINOUS STATE OF HYPE","HYPER HYPER");

#define weapon_fire
repeat(5)
{
	sound_play_pitchvol(sndHeavyCrossbow,1.2,.5)
	sound_play_pitch(sndHyperLauncher,7)
	sound_play_pitch(sndHyperRifle,.9)
	weapon_post(4,-20,4)
	with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),Bolt)
	{
		team = other.team
		sprite_index = global.sprHyperBolt
		damage = 20
		motion_add(other.gunangle+random_range(-1,1)*other.accuracy,25)
		image_angle = direction
	}
	wait(3);
}

#define init
global.sprPopper = sprite_add_weapon("sprites/sprPopper.png", 4, 1);
#define weapon_name
return "POPPER";

#define weapon_sprt
return global.sprPopper;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 6;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 3;

#define weapon_text
return "POP POP";

#define weapon_fire

weapon_post(4,0,22)
sound_play_pitch(sndPopgun,.7+random_range(-.1,.1))
sound_play_pitch(sndMachinegun,.8+random_range(-.1,.1))
with instance_create(x,y,Bullet2)
{
	creator = other
	team = other.team
	image_xscale = 4/3
	image_yscale = 4/3
	move_contact_solid(other.gunangle,6)
	motion_add(other.gunangle + random_range(-10,10)*other.accuracy,14)
	damage += 4
	image_angle = direction
	on_destroy = script_ref_create(pop_destroy)
}

#define pop_destroy
i = random(360);
repeat(2)
{
	with instance_create(x,y,Bullet2)
	{
		creator = other.creator
		team = other.team
		motion_add(i+random_range(-180,180)*creator.accuracy,16)
		image_angle = direction
	}
	i += 360/2
}

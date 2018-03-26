#define init
global.sprMasterScrewdriver = sprite_add_weapon("Auto Screwdriver.png", 2, 1);

#define weapon_name
return "AUTO SCREWDRIVER";

#define weapon_sprt
return global.sprMasterScrewdriver;

#define weapon_type
return 0;

#define weapon_auto
return true;

#define weapon_load
return 5;//sorry karm, but a 1 frame reload is just too fast

#define weapon_cost
return 0;

#define weapon_melee
return 1

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return 13;

#define weapon_text
return choose("TOO POWERFUL TO FIX THINGS","PAPER DRILL");

#define weapon_fire
weapon_post(8,8,4)
sound_play_pitch(sndScrewdriver,random_range(.9,1.2))
wepangle = -wepangle
motion_add(gunangle, 4)
with instance_create(x,y,Shank)
{
	damage = 8
	creator = other
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	image_angle = direction
	team = other.team
	image_xscale *= 1.1
	image_yscale *= 1.3
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
}

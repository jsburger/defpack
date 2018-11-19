#define init
global.sprOtherSword = sprite_add_weapon("sprites/sprOtherSword.png", 1, 5);

#define weapon_name
return "OTHER SWORD"

#define weapon_sprt
return global.sprOtherSword;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 42;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapSword;

#define weapon_area
return -1;

#define weapon_text
return "BE BRAVE";

#define weapon_melee
return 1

#define weapon_fire

sound_play_pitch(sndChickenSword,1.4)
sound_play_pitch(sndShovel,1.5)
sound_play_pitch(sndNothingFootstep,2.5)
weapon_post(6,-5,30)
wepangle = -wepangle
with instance_create(x,y,Slash)
{
	creator = other
	motion_add(other.gunangle, 1 + (skill_get(13)))
	image_angle = direction
	team = other.team
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	sprite_index = sprHeavySlash
	image_xscale *= 1
	image_yscale *= 1
	damage += 8
	if place_meeting(x,y,enemy){
		creator.reload = round(creator.reload*.4)
		creator.gunshine = 12
	}
}
motion_add(gunangle,4)

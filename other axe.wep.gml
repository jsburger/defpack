#define init
global.sprOtherSword = sprite_add_weapon("sprites/sprOtherSword.png", 3, 7);

#define weapon_name
return "OTHER AXE"

#define weapon_sprt
return global.sprOtherSword;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 47;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapSword;

#define weapon_area
return 9;

#define weapon_text
return "BE BRAVE";

#define weapon_melee
return 1

#define weapon_fire
var _p = random_range(.8,1.2)
sound_play_pitch(sndChickenSword,.8*_p)
sound_play_pitch(sndShovel,.7*_p)
sound_play_pitch(sndHitMetal,.5*_p	)
sound_play_pitch(sndHammer,.8*_p	)
weapon_post(8,-8,60)
wepangle = -wepangle
with instance_create(x,y,CustomSlash)
{
	image_speed = 1/3
	creator = other
	motion_add(other.gunangle, 1 + (skill_get(13)*2))
	image_angle = direction
	team = other.team
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	sprite_index = sprHeavySlash
	damage = 10
	if place_meeting(x,y,enemy){
		creator.reload = round(creator.reload*.3)
		sound_play_pitchvol(sndImpWristHit,.8,1)
		sound_play_pitchvol(sndImpWristKill,.8,1)
		view_shake_at(x,y,other.size * 4)
		sleep(min(other.size, 4) * 15)
		creator.gunshine = 12
	}
	on_anim = s_anim
	on_hit  = s_hit
}
motion_add(gunangle,5)

#define s_anim
instance_destroy()

#define s_hit
if projectile_canhit_melee(other) = true
{
	projectile_hit(other,damage+other.size,12,direction)
}

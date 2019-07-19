#define init
global.sprOtherSword = sprite_add_weapon("sprites/sprOtherSword.png", 3, 7);

#define weapon_name
return "REBOUNCE AXE"

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
return choose("BE BRAVE", "STRIKE AGAIN");

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
	image_speed = .5
	creator = other
	motion_add(other.gunangle, 2 + (skill_get(13)*2))
	image_angle = direction
	team = other.team
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	sprite_index = sprHeavySlash
	damage = 12
	on_anim = s_anim
	on_hit  = s_hit
}
motion_add(gunangle,5)

#define s_anim
instance_destroy()

#define s_hit
if projectile_canhit_melee(other) = true
{
	projectile_hit(other,damage,12,direction)
	if team != other.team
	{
		creator.reload = round(creator.reload*.3)
		var _p = random_range(.8, 1.2);
		sound_play_pitchvol(sndImpWristHit,.5 * _p,2)
		sound_play_pitchvol(sndHitMetal,.6 * _p,2)
		view_shake_at(x,y,other.size * 4)
		sleep(min(other.size, 4) * 25)
		creator.gunshine = 8
		sound_play_gun(sndEmpty,1,.4)
		sound_stop(sndEmpty)
		repeat(12) with instance_create(other.x, other.y, Dust)
		{
			motion_add(other.direction + random_range(-70, 70), random_range(4, 6))
		}
	}
}

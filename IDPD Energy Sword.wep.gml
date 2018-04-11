#define init
global.sprIDPDEnergySword = sprite_add_weapon("sprites/Elite IDPD Energy Sword.png", 0, 3);

#define weapon_name
return "I.D.P.D ENERGY BATON"

#define weapon_sprt
return global.sprIDPDEnergySword;

#define weapon_type
return 5;

#define weapon_auto
return true;

#define weapon_load
return 54;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return -1;

#define weapon_text
return "THE END";

#define weapon_melee
return 1

#define weapon_fire

sound_play(sndEliteInspectorFire)
weapon_post(4,-5,10)
with instance_create(x,y,EnergySlash)
{
	creator = other
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	image_angle = direction
	team = other.team
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	sprite_index = sprPopoSlash
	image_xscale *= 1.1
	image_yscale *= 1.1
	damage += 8
	if place_meeting(x,y,enemy)
	{
		creator.reload = round(creator.reload*.86)
		creator.gunshine = 12
	}
}
motion_add(gunangle,4)
wepangle = -wepangle

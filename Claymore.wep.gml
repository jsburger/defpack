#define init
global.sprClaymore = sprite_add_weapon("sprites/Claymore.png", 4, 4);
//FUCC ALL Y'ALL WHO DONT LIKE THIS PART HE DESERVES IT
trace("Thanks to Wonderis_ for putting a ton of time testing all this");
trace("Also Jsburg did a bunch of work polishing the mod")
trace("Many thanks to Xefs and Yokin for code help, much appreciated lads :)")
#define weapon_name
return "CLAYMORE";

#define weapon_sprt
return global.sprClaymore;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 23;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return 7;

#define weapon_melee
return 1

#define weapon_text
return "ABSOLUTELY LUNATIC";

#define weapon_fire

sound_play(sndHammer)
weapon_post(8,10,5)

with instance_create(x,y,Slash)
{
	damage = 22
	creator = other
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	image_angle = direction
	team = other.team
	image_xscale *= 1.4
	image_yscale *= 1.4
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	instance_create(x+lengthdir_x(65,direction),y+lengthdir_y(57,direction),Explosion)
	instance_create(x+lengthdir_x(57,direction-20),y+lengthdir_y(57,direction-20),SmallExplosion)
	instance_create(x+lengthdir_x(57,direction+20),y+lengthdir_y(57,direction+20),SmallExplosion)

}
wepangle = -wepangle
motion_add(gunangle,5)
sound_play(sndExplosion)

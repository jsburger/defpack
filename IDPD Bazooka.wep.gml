#define init
global.sprIDPDBazooka = sprite_add_weapon("sprites/Elite IDPD Rifle.png", 5, 4);

#define weapon_name
return "I.D.P.D. BAZOOKA";

#define weapon_sprt
return global.sprIDPDBazooka;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 26;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 12;

#define weapon_text
return "CLEAN MISSILE";

#define weapon_fire

weapon_post(7,-13,6)
sound_play(sndRocket)
with instance_create(x,y,PopoRocket){
	motion_add(other.gunangle+(random(4)-2)*other.accuracy,14)
	team = other.team
	creator = other
	image_angle = direction
	image_xscale *= 1.3
	image_yscale *= 1.3
}
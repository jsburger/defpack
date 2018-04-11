#define init
global.sprIDPDSlugger = sprite_add_weapon("sprites/IDPD Slugger.png", -2, 4);

#define weapon_name
return "I.D.P.D. SLUGGER";

#define weapon_sprt
return global.sprIDPDSlugger;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 33;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return -1;

#define weapon_text
return "ENEMY INTELLIGENCE";

#define weapon_fire

weapon_post(5,-12,7)
sound_play(sndGruntFire)
with instance_create(x,y,PopoSlug){
	motion_add(other.gunangle+random(12)-6,18)
	image_angle = direction
	creator = other
	damage = 25
	image_xscale *= 1.1
	image_yscale *= 1.1
	team = other.team
}

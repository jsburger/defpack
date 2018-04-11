#define init
global.sprIDPDPlasmaMinigun = sprite_add_weapon("sprites/Elite IDPD Minigun.png", 6, 4);

#define weapon_name
return "I.D.P.D. PLASMA MINIGUN";

#define weapon_sprt
return global.sprIDPDPlasmaMinigun;

#define weapon_type
return 5;

#define weapon_auto
return true;

#define weapon_load
return 5;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return -1;

#define weapon_text
return "JOKER SPOTTED";

#define weapon_fire

sound_play(sndEliteShielderFire)

weapon_post(5,-6,5)
with instance_create(x,y,PopoPlasmaBall){
	motion_add(other.gunangle+(random(8)-4)*other.accuracy,2 + random(.5))
	image_angle = direction
	image_xscale *= 1.6 + (skill_get(17)*.2)
	image_yscale *= 1.6 + (skill_get(17)*.2)
	team = other.team
	creator = other
}

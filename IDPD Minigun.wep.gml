#define init
global.sprIDPDMinigun = sprite_add_weapon("sprites/IDPD Minigun.png", 6, 7);

#define weapon_name
return "I.D.P.D. MINIGUN";

#define weapon_sprt
return global.sprIDPDMinigun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 3;

#define weapon_cost
return 1;

#define weapon_swap
return sndMinigun;

#define weapon_area
return -1;

#define weapon_text
return "@bBLUE @sBULLETS";

#define weapon_fire
weapon_post(4,-4,4)
sound_play(sndGruntFire)
with instance_create(x,y,IDPDBullet){
	motion_add(other.gunangle+random(20)-10,20 +random(2))
	image_angle = direction
	damage = 4
	creator = other
	team = other.team
}

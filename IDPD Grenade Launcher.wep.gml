#define init
global.sprIDPDNader = sprite_add_weapon("IDPD Nader.png", 3, 3);

#define weapon_name
return "I.D.P.D. GRENADE LAUNCHER";

#define weapon_sprt
return global.sprIDPDNader;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 20;

#define weapon_cost
return 2;

#define weapon_swap
return sndMinigun;

#define weapon_area
return 8;

#define weapon_text
return "@bBLUE @sBOMBING";

#define weapon_fire

weapon_post(5,-7,3)
sound_play(sndGrenade)
with instance_create(x,y,PopoNade){
	motion_add(other.gunangle+random(20)-10*other.accuracy,10 +random(2))
	image_angle = direction
	team = other.team
	creator = other
}

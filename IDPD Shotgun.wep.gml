#define init
global.sprIDPDShotgun = sprite_add_weapon("sprites/IDPD Shotgun.png", 5, 3);

#define weapon_name
return "I.D.P.D SHOTGUN"

#define weapon_sprt
return global.sprIDPDShotgun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 21;

#define weapon_cost
return 8;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "NOT EVEN A SHOTGUN ANYMORE";

#define weapon_fire

repeat(5)
{
	with instance_create(x,y,Shell)
	{
		motion_add(point_direction(x,y,mouse_x,mouse_y)+other.right*100+random(50)-25,2+random(5))
		image_blend = c_blue
	}
}
sound_play(sndGrenadeRifle)
weapon_post(5,-12,4)
with mod_script_call("mod", "defpack tools 2","create_flak",0,4,13,0,IDPDBullet,18,id){ //god damn im spooked, i tested this but fuck man its gonna go wrong
	ammo = 12
}

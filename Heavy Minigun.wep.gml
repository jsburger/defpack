#define init
global.sprHeavyMinigun = sprite_add_weapon("sprites/Heavy Minigun.png", 5, 2);

#define weapon_name
return "HEAVY MINIGUN";

#define weapon_sprt
return global.sprHeavyMinigun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 1;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 15;

#define weapon_text
return "HEAVY OCEAN";

#define weapon_fire
//i absolutely did not take inspiration from GunLocker's sound effects (i absolutely did)
//also move_contact_solid is neat, i didnt know it was a thing, i might use that on other long guns
//the spread was like this before, i didnt copy that from GunLocker
//whoa, look at how the commas and i didnt's line up, neat
sound_play(sndHyperRifle)
sound_play(sndMinigun)
sound_play(sndTripleMachinegun)
sound_play(sndHeavyNader)
weapon_post(4,-9,5)

with instance_create(x,y,Shell) {
	motion_add(other.gunangle+other.right*100+random(80)-40,3+random(2))
	sprite_index = sprHeavyShell
}

with instance_create(x,y,HeavyBullet){
	move_contact_solid(other.gunangle,4)
	motion_add(other.gunangle+(random(26)-13)*other.accuracy,16)
	image_angle = direction
	team = other.team
	creator = other
}
motion_add(gunangle+180,1)

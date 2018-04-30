#define init
global.sprFlakShotgun = sprite_add_weapon("sprites/sprFlakShotgun.png", 4, 4);

#define weapon_name
return "FLAK SHOTGUN"

#define weapon_sprt
return global.sprFlakShotgun;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 47;

#define weapon_cost
return 8;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 11;

#define weapon_text
return "540/600";

#define weapon_fire

sound_play(sndMachinegun)
sound_play(sndCrossbow)
sound_play_pitch(sndShotgun,.7)
sound_play_pitch(sndFlakCannon,1.2)
sound_play_pitch(sndSuperFlakCannon,.7)
weapon_post(8,-20,20)
repeat(5){
	with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),FlakBullet){
		team = other.team
		creator = other
		motion_add(other.gunangle+(random(80)-45)*other.accuracy,random_range(9,12))
		image_angle = direction
	}
}

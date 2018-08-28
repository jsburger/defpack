#define init
global.sprNailGun = sprite_add_weapon("sprites/sprNailGun.png", 1, 3);

#define weapon_name
return "NAIL GUN"

#define weapon_sprt
return global.sprNailGun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 3;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 2;

#define weapon_text
return "TAC TAC TAC";

#define weapon_fire
sound_play_pitchvol(sndSplinterGun,random_range(1.3,1.6),.7)
sound_play_pitchvol(sndCrossbow,random_range(1.3,1.6),.7)
sound_play_pitchvol(sndPopgun,random_range(1.3,1.6),.7)
weapon_post(1,0,4)
with instance_create(x,y,Splinter)
{
	team = other.team
	motion_add(other.gunangle+random_range(-7,7)*other.accuracy,16)
	image_angle = direction
	creator = other
}

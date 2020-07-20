#define init
global.sprGoldenBouncerPistol = sprite_add_weapon("../../sprites/weapons/iris/bouncer/sprGoldenBouncerRevolver.png", -2, 2);

#define weapon_name
return "GOLDEN BOUNCER PISTOL"

#define weapon_sprt
return global.sprGoldenBouncerPistol;

#define weapon_gold
return true;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 5;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return choose("@yBOUNCE @sWHITH STYLE");

#define weapon_fire

sound_play_pitch(sndBouncerSmg,random_range(1.1,1.2))
sound_play(sndGoldPistol)
weapon_post(2,-2,3)
with instance_create(x,y,Shell){motion_add(other.gunangle+other.right*100+random(80)-40,2+random(2))}
with instance_create(x,y,BouncerBullet)
{
	team = other.team
	creator = other
	motion_add(other.gunangle+(random(14)-7)*other.accuracy,6)
}

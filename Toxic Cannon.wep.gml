#define init
global.sprToxicCannon = sprite_add_weapon("sprites/Toxic Cannon.png", 4, 4);
#define weapon_name
return "TOXIC CANNON";

#define weapon_sprt
return global.sprToxicCannon;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 95;

#define weapon_cost
return 8;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 8;

#define weapon_text
return "HOW LONG CAN YOU HOLD YOUR BREATH?";

#define weapon_fire

weapon_post(6,-8,15)
sound_play(sndGrenade)
with instance_create(x+lengthdir_x(19,gunangle),y+lengthdir_y(19,gunangle),FrogQueenBall)
{
	motion_set(other.gunangle,2)
	creator = other
	team = other.team
}
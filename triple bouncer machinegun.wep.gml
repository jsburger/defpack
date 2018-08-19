#define init
global.sprTripleBouncerMachinegun = sprite_add_weapon("sprites/sprTripleBouncerMachinegun.png", -1, 4);

#define weapon_name
return "TRIPLE BOUNCER MACHINEGUN"

#define weapon_sprt
return global.sprTripleBouncerMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 5;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return choose("THE POWER");

#define weapon_fire

sound_play_pitch(sndBouncerSmg,random_range(.9,1.1))
sound_play_pitch(sndTripleMachinegun,random_range(.8,1.2))
weapon_post(6,0,12)
repeat(3)with instance_create(x,y,Shell){motion_add(other.gunangle+other.right*100+random(80)-40,2+random(2))}
with instance_create(x,y,BouncerBullet)
{
	team = other.team
	creator = other
	motion_add(other.gunangle-25+random_range(-9,9)*other.accuracy,6)
}
with instance_create(x,y,BouncerBullet)
{
	team = other.team
	creator = other
	motion_add(other.gunangle+random_range(-9,9)*other.accuracy,6)
}
with instance_create(x,y,BouncerBullet)
{
	team = other.team
	creator = other
	motion_add(other.gunangle+25+random_range(-9,9)*other.accuracy,6)
}

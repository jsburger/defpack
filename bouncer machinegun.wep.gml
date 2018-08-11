#define init
global.sprBouncerMachinegun = sprite_add_weapon("sprites/sprBouncerMachinegun.png", 3, 1);

#define weapon_name
return "BOUNCER MACHINEGUN"

#define weapon_sprt
return global.sprBouncerMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 5;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return choose("GO FOR A @wTRICKSHOT @sOR TWO");

#define weapon_fire

with instance_create(x,y,Shell){motion_add(other.gunangle+other.right*100+random(80)-40,2+random(2))}
sound_play_pitch(sndBouncerSmg,random_range(1.1,1.2))
sound_play(sndMachinegun)
weapon_post(4,0,7)

with instance_create(x,y,BouncerBullet)
{
	team = other.team
	creator = other
	motion_add(other.gunangle+random_range(-9,9)*other.accuracy,6)
}

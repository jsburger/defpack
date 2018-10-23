#define init
global.sprToxicCannon = sprite_add_weapon("sprites/sprToxicCannon.png", 4, 4);
#define weapon_name
return "TOXIC CANNON";

#define weapon_sprt
return global.sprToxicCannon;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 43;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 8;

#define weapon_text
return "HOW LONG CAN YOU HOLD YOUR BREATH?";

#define weapon_fire
weapon_post(6,-12,15)
motion_add(gunangle-180,5)
var _p = random_range(.8,1.2)
sound_play_pitch(sndToxicBarrelGas,.8*_p)
sound_play_pitch(sndFlameCannon,2.4*_p)
sound_play_pitch(sndToxicLauncher,.6*_p)
sound_play_pitch(sndHeavyCrossbow,.6*_p)
with instance_create(x,y,FrogQueenBall)
{
	move_contact_solid(other.gunangle,18)
	motion_set(other.gunangle,3)
	team = other.team
}

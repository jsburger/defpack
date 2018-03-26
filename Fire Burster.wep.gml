#define weapon_name
return "FIRE BURSTER"

#define weapon_sprt
return sprFlareGun;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 22;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 11;

#define weapon_text
return "SUN LAUNCHER";

#define weapon_fire

sound_play(sndFlameCannon)
repeat(20)
{
	with instance_create(x,y,Smoke)motion_set(other.gunangle + random_range(-3,3), 3+random(5))
	with instance_create(x,y,Flame){team = other.team;motion_add(other.gunangle+random_range(-66,66)*(1-skill_get(19)),3+random(4))}
	with instance_create(x,y,Flame){team = other.team;motion_add(other.gunangle+random_range(-14,14)*(1-skill_get(19)),4+random(7))}
}
with instance_create(x,y,Flame){team = other.team;motion_add(other.gunangle+random_range(-2,2)*(1-skill_get(19)),9+random(3))}
#define step
with Smoke move_bounce_solid(false)

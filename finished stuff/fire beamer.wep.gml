#define init
global.sprFireBeamer = sprite_add_weapon("sprFireBeamer.png", 2, 3);

#define weapon_name
return "FIRE BEAMER";

#define weapon_sprt
return global.sprFireBeamer;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 27;

#define weapon_cost
return 1;

#define weapon_melee
return 0;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 9;

#define weapon_text
return "HEAT WAVES";

#define weapon_fire

sound_play_pitch(sndFlare,1.4)
sound_play_pitch(sndFlareExplode,1.4)
sound_play_pitch(sndFlamerStop,2)
weapon_post(8,8,4)
instance_create(x+lengthdir_x(26+speed,gunangle),y+lengthdir_y(26+speed,gunangle),SmallExplosion)
repeat(6)
{
	repeat(2)with instance_create(x+lengthdir_x(2,direction)+random_range(-2,2),y+lengthdir_y(2,direction)+random_range(-2,2),Smoke)motion_set(other.gunangle + random_range(-8,8), 1+random(3))
	repeat(4)with instance_create(x+lengthdir_x(2,direction)+random_range(-2,2),y+lengthdir_y(2,direction)+random_range(-2,2),Flame){team = other.team;motion_add(other.gunangle+random_range(-14,14)*(1-skill_get(19)),4+random(8))}
}

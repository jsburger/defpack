#define init
global.sprApergigTanat = sprite_add_weapon("Apergig Tanat.png", 0, 3);

#define weapon_name
return "APERGIG TANAT";

#define weapon_sprt
return global.sprApergigTanat;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 30;

#define weapon_cost
return 30;

#define weapon_swap
return sndSwapPistol

#define weapon_area
return 8;

#define weapon_text
return choose("MMMMH THATS SOME GOOD SHIT
RIGHT THERE
(RIGHT THERE)","THIS IS THE @yWAY");

#define weapon_fire

sound_play(sndGoldShotgun)
sound_play(sndGoldPistol)
sound_play(sndGoldTankShoot)
sound_play_pitch(sndSlugger,2)
sound_play_pitch(sndFlakCannon,.8)
motion_set(gunangle-180,4)
wkick = 9
with instance_create(x,y,Bullet2)
{
	force = 50
	damage = 1026
	motion_add(other.gunangle,22)
	image_xscale /= 2
	image_yscale /= 2
	team = other.team
	creator = other
	repeat(6){instance_create(x+lengthdir_x(random_range(1,6),direction),y+lengthdir_y(random_range(1,6),direction),Smoke)}
}

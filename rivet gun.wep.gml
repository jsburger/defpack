#define init
global.sprRivetGun = sprite_add_weapon("sprites/sprRivetGun.png", 3, 3);

#define weapon_name
return "RIVET GUN"

#define weapon_sprt
return global.sprRivetGun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 2;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 3;

#define weapon_text
return "RIVETING";

#define weapon_fire
var _p = random_range(.8, 1.2)
sound_play_pitch(sndHeavyCrossbow, .7 * _p)
sound_play_pitch(sndMachinegun, .7 * _p)
sound_play_pitch(sndSuperSplinterGun, 1.4 * _p)
sound_play_pitch(sndSplinterPistol, .7 * _p)
sound_play_pitch(sndExplosionS, 2 * _p)
weapon_post(7,-16,8)
motion_add(gunangle - 180,1.4)
with instance_create(x,y,Splinter)
{
	team = other.team
	motion_add(other.gunangle+random_range(-9,9)*other.accuracy,24)
	image_angle = direction
	creator = other
}

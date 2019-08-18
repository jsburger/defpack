#define init
global.sprRivetGun = sprite_add_weapon("sprites/weapons/sprRivetGun.png", 3, 3);

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
return 10;

#define weapon_text
return "RIVETING";

#define weapon_fire
var _p = random_range(.8, 1.2), _v = .6
sound_play_pitchvol(sndHeavyCrossbow, .7 * _p, _v)
sound_play_pitchvol(sndMachinegun, .7 * _p, _v)
sound_play_pitchvol(sndSuperSplinterGun, 1.4 * _p, _v)
sound_play_pitchvol(sndSplinterPistol, .7 * _p, _v)
sound_play_pitchvol(sndExplosionS, 2 * _p, _v)
weapon_post(7,-16,8)
motion_add(gunangle - 180, 1.4)
with instance_create(x, y, Splinter){
	motion_add(other.gunangle+random_range(-9,9)*other.accuracy, 24)
	projectile_init(other.team, other)
	image_angle = direction
}

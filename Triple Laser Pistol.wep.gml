#define init
global.sprTripleLaserGun = sprite_add_weapon("sprites/Triple Laser Gun.png", 0, 4);

#define weapon_name
return "TRIPLE LASER PISTOL"

#define weapon_sprt
return global.sprTripleLaserGun;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 19;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 6;

#define weapon_text
return "LIKE A RIGHTEOUS BISON";

#define weapon_fire

weapon_post(5,-15,6)
sound_play(sndLaserUpg)
var _n = 3 //the amount of shots
var _s = 8 //distance between the shots
var _p = Laser //the projectile itelf, in plain text
var _r = 3 //random spread range
var _sp = 0 //speed of the shots
var _d = 0 //delay between the shots
var ang = gunangle - (.5 * _s * (_n - 1) * accuracy)
repeat(_n){
	with instance_create(x, y, _p){
		image_angle = (ang + ((.5 *_r) * random_range(-1,1) * other.accuracy));
		ang += _s * other.accuracy;
		//insert additional projectile things here
		alarm0 = 1
		team = other.team;
		creator = other
		if (_d > 0) wait(_d); //this should be at the end
	}
}

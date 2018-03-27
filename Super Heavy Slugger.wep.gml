#define init
global.sprSuperHeavySlugger = sprite_add_weapon("sprites/Super Heavy Slugger.png", 6, 4);

#define weapon_name
return "SUPER HEAVY SLUGGER";

#define weapon_sprt
return global.sprSuperHeavySlugger;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 34;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 7;

#define weapon_text
return "NO NEED TO GET OUT OF HERE";

#define weapon_fire

weapon_post(12,-40,30)
sound_play(sndSuperSlugger)
sound_play(sndHeavySlugger)
motion_add(gunangle+180,8)
//hey its my old firing script thing, i forgot about this, bit shit innit
var _n = 5 //the amount of shots
var _s = 20 //distance between the shots
var _p = HeavySlug //the projectile itelf, in plain text
var _r = 5 //random spread range
var _sp = 13 //speed of the shots
var _d = 0 //delay between the shots
var ang = gunangle - (.5 * _s * (_n - 1) * accuracy)
repeat(_n){
	with instance_create(x, y, _p){
		motion_add(ang + ((.5 *_r) * random_range(-1,1) * other.accuracy),_sp);
		ang += _s * other.accuracy;
		image_angle = direction;
		//insert additional projectile things here
		team = other.team;
		creator = other
		if (_d > 0) wait(_d); //this should be at the end
	}
}

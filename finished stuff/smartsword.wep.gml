#define init
global.sprSmartSword = sprite_add_weapon("SmartSword.png",1,7)
#define weapon_name
return "SMART SWORD"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return 01
#define weapon_load
return 9
#define weapon_swap
return sndSwapSword
#define weapon_auto
return 1
#define weapon_melee
return 1
#define weapon_laser_sight
return 0
#define weapon_fire
weapon_post(6,0,0)
sound_play_pitch(sndSmartgun,1.8)
sound_play(sndScrewdriver)
wepangle *= -1
with instance_create(x,y,Shank)
{
	direction = other.gunangle
	image_angle = direction
	team = other.team
	image_xscale = 2
	speed = 2
}
#define weapon_sprt
return global.sprSmartSword
#define weapon_text
return "@qMOOOOM HES USING AN AIMBOT"

#define instance_nearest_matching_ne(_x, _y, _obj, _var, _val)
var _dudes = instances_matching_ne(_obj, _var, _val),
	_dude = noone;

if(array_length_1d(_dudes) > 0){
	with(_dudes) x += 10000;
	_dude = instance_nearest(_x + 10000, _y, _obj);
	with(_dudes) x -= 10000;
}

return _dude;

#define init
global.sprAbrisLauncher = sprite_add_weapon("sprites/weapons/sprAbrisLauncher.png", 0, 4);

#define weapon_name
return "ABRIS LAUNCHER"

#define weapon_sprt
return global.sprAbrisLauncher;

#define weapon_type
return 4;

#define weapon_auto
return mod_script_call_nc("mod", "defpack tools", "abris_weapon_auto", mod_current, self)

#define weapon_load
return 22;

#define weapon_cost
return 2;

#define weapon_chrg
return true;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 6;

#define weapon_reloaded
weapon_post(-1,-3,0)
sound_play_pitchvol(sndNadeReload,1.4,.6)

#define nts_weapon_examine
return{
    "d": "A bigger Abris Pistol with more explosions and spread. ",
}

#define weapon_text
return "INCOMING";

#define weapon_fire
var _strtsize = 16;
var _endsize  = 34;
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
	accspeed = 1.75
	damage = 10
	maxdamage = 26
	name = mod_current
	payload = script_ref_create(pop)
}
sound_play_pitch(sndSniperTarget,1.5)

#define pop
sound_play_pitch(sndGrenadeRifle,random_range(.5,.8))
sound_play_pitch(sndGrenade,random_range(.5,.8))
sound_play_pitch(sndGrenadeShotgun,random_range(.5,.8))
sound_play(sndExplosion)
if isplayer with creator weapon_post(6,25,35)
with instance_create(x, y, CustomObject) {
	n = 3
	timer = 1
	accmin = other.accmin
	acc = other.acc
	on_step = pop_step
	creator = other.creator
	explodir = random(360)
}

#define pop_step
if !instance_exists(creator){instance_delete(self);exit}
if n > 0 {
	timer -= current_time_scale;
	if timer <= 0 repeat(2){
		n--
		var _d = explodir + random(360), _r = accmin + random(acc);
		if n != 0 with instance_create(x + lengthdir_x(_r, _d), y + lengthdir_y(_r, _d), SmallExplosion) {
			sound_play(sndExplosionS)
			sleep(5)
			view_shake_at(x, y, 4)
			line(x, y, other.creator.x, other.creator.y)
		}
		else with instance_create(x + lengthdir_x(_r, _d), y + lengthdir_y(_r, _d), Explosion) {
			sound_play(sndExplosion)
			sleep(20)
			view_shake_at(x, y, 24)
			line(x, y, other.creator.x, other.creator.y)
		}
		explodir = _d
		if n = 1 timer = 3 + irandom(1) else timer = 1 + irandom(1)
	}
}
else {
	instance_delete(self)
	exit
}

#define make_trail(range,direction)
var num = random_range(20,40)
var _x = lengthdir_x(range,direction), _y = lengthdir_y(range,direction)
with instance_create(x-random(_x),y-random(_y),Dust){
    motion_set(direction + num*choose(-1,1),3+random(1))
    x+=hspeed
    y+=vspeed
}

#define line(x1, y1, x2, y2)
var _num    = 25,												  //subdivisions of the distance in line segments
	_length = irandom_range(4, 6),								  //amount of subdivisions used for the bolt trail
	_width  = random_range(.7, 1.2),							  //the scale of all the bolt trails
	_pivot  = _num - _length - irandom((_num - 2 * _length)/3),   //the point at which the trails are centered, based off of the _num subdivisions
	_dist   = point_distance(x1, y1, x2, y2),					  //point distance
	_dir    = point_direction(x2, y2, x1, y1),					  //point direction
	_x      = lengthdir_x(_dist/_num, _dir),					  //used so i dont have to recalculate the size of one of the subdivisions
	_y      = lengthdir_y(_dist/_num, _dir),					  //^
	_xscale = _dist/_num,										  //xscale of all bolt trails
	_speed  = (_dist * (_pivot/_num)/_width * .2),				  //speed of all of the bolt trails, _width * .2 represents the most time itll take for the trails to disperse
	_yscale;

	for (var i = 1; i <= _num; i++) {
		_yscale = 1 - (min(abs(_pivot - i), _length)/_length)	  //i mean, its the width of the bolt trail, idk what the min is for
		if _yscale > 0 {
			with instance_create(x1 - _x * i, y1 - _y * i, BoltTrail) {
				image_xscale = _xscale
				image_angle = _dir
				image_yscale = _yscale * _width
				motion_set(image_angle, _speed)
				if i < _num - 2 and !irandom(7)
					make_trail(image_xscale, image_angle + 180)
			}
		}
	}

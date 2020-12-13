#define init
global.sprBloodAbrisLauncher = sprite_add_weapon("sprites/weapons/sprBloodAbrisLauncher.png", 2, 4);
global.stripes = sprite_add("sprites/other/sprBigStripes.png",1,1,1)

#define weapon_name
return "BLOOD ABRIS LAUNCHER"

#define weapon_sprt
return global.sprBloodAbrisLauncher;

#define weapon_type
return 4;

#define weapon_auto
return 1;

#define weapon_load
return 19;

#define weapon_cost
return 2

#define weapon_chrg
return true;

#define weapon_swap
return sndSwapExplosive;

#define weapon_reloaded
weapon_post(-1,-3,0)
sound_play_pitchvol(sndNadeReload,1.4,.6)

#define weapon_area
return 10;

#define weapon_text
return "GRUESOME";

#define step(p)
if ammo[weapon_type()] < weapon_cost(){
    if (p and button_pressed(index, "fire")) or (!p and race = "steroids" and button_pressed(index, "spec")){
        projectile_hit(self, 1)
        lasthit = [global.sprBloodAbrisLauncher,"Blood Abris#Launcher"]
        sound_play(sndBloodHurt);
        ammo[weapon_type()] += weapon_cost()
    }
}

#define weapon_fire
var _strtsize = 45;
var _endsize  = 25;
sound_play_pitch(sndSniperTarget,1/accuracy+1.5)
with mod_script_call_self("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
	accspeed = 1.15
	cost = 2
	damage = 2
  name = mod_current
    maxdamage = 5
	payload = script_ref_create(pop)
}

#define pop
with instance_create(x, y, CustomObject){
	creator = other.creator
	team = other.team
	accmin = other.accmin
	acc = other.acc
	n = 4;
	timer = 1;
	on_step = pop_step
}

#define pop_step
if !instance_exists(creator){instance_delete(self);exit}
if timer-- <= 0
{
	with instance_create((x + creator.x)/2, (y + creator.y)/2, BloodStreak){
	    image_angle = point_direction(x, y, other.x, other.y)
	    line(x, y, other.creator.x, other.creator.y)
	}
	n--;
	sound_play_pitch(sndBloodLauncher, random_range(.8, 1.2))
	sound_play_pitch(sndBloodLauncherExplo, random_range(.8, 1.2))
	if instance_is(creator, Player) with creator weapon_post(5,12,45)
    repeat(2)with instance_create(x + lengthdir_x((accmin + random(acc)) * .8, random(360)), y  + lengthdir_x((accmin + random(acc)) * .8, random(360)), MeatExplosion){
        team = other.creator.team
    }
    timer = 3;
}
if n <= 0 instance_destroy()

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
				image_blend = c_red
				image_xscale = _xscale
				image_angle = _dir
				image_yscale = _yscale * _width

				motion_set(image_angle, _speed)
				if i < _num - 2 and !irandom(7)
					make_trail(image_xscale, image_angle + 180)
			}
		}
	}

#define init
global.sprBigIron = sprite_add_weapon("sprites/weapons/sprBigIron.png", 2, 4);

#define weapon_name
return "BIG IRON"

#define weapon_sprt
return global.sprBigIron;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 17;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 11;

#define weapon_text
return "ONE AND NINETEEN MORE";


#define sound_play_hit_ext(_sound, _pitch, _vol)
var _s = sound_play_hit(_sound, 0);
sound_pitch(_s, _pitch);
sound_volume(_s, _vol);


#define sound_play_bulk(_sounds, _pitch, _vol)
for (var i = 0, _l = array_length(_sounds); i < _l; i++){
	sound_play_hit_ext(_sounds[i].sound, lq_defget(_sounds[i], "pitch", 1) * _pitch, lq_defget(_sounds[i], "volume", 1) * _vol)
}

#define weapon_fire
weapon_post(7, 30, 52)
sleep(30)
var _p = random_range(.7, 1.3)
var _sounds = [
	{sound : sndSlugger, pitch : 1.2},
	{sound : sndDoubleShotgun, pitch : .8},
	{sound : sndShotgun, pitch : .8},
	{sound : sndHeavyNader, pitch : 1.3},
	{sound : sndMachinegun, pitch : .6},
	{sound : sndSawedOffShotgun, pitch : .8},
	{sound : sndSuperSlugger, pitch : .7}
];

sound_play_bulk(_sounds, _p, .6)

/*
sound_play_pitchvol(sndSlugger,1.2*_p,.6)
sound_play_pitchvol(sndDoubleShotgun,.8*_p,.6)
sound_play_pitchvol(sndShotgun,.8*_p,.6)
sound_play_pitchvol(sndHeavyNader,1.3*_p,.6)
sound_play_pitchvol(sndMachinegun,.6*_p,.6)
sound_play_pitchvol(sndSawedOffShotgun,.8*_p,.6)
sound_play_pitchvol(sndSuperSlugger,.7*_p,.6)
*/
with instance_create(x + lengthdir_x(24, gunangle), y + lengthdir_y(24, gunangle), CustomObject) {
	depth = -1
	sprite_index = sprBullet1
	image_speed = .9
	on_step = muzzle_step
	on_draw = muzzle_draw
	image_yscale = .5
	image_angle = other.gunangle
}

repeat(3){
    repeat(2){
        with instance_create(x, y, Shell) {
        	motion_add(other.gunangle + 90 + random_range(-40, 40), 2 + random(2))
        }
        with create_bullet(x + lengthdir_x(24, gunangle), y + lengthdir_y(24, gunangle)) {
            on_destroy = shell_destroy
            direction = other.gunangle + random_range(-14, 14) * other.accuracy;
            image_angle = direction;
            creator = other
            team = other.team
        }
    }
    wait(1)
    if !instance_exists(self) exit
}

#define create_bullet(_x,_y)
with instance_create(_x,_y,CustomProjectile){
	typ = 1
	creator = other
	team  = other.team
	image_yscale = .5
	trailscale = 1
	hyperspeed = 8
	sprite_index = mskNothing
	mask_index = mskBullet2
	force = 2
	damage = 4
	lasthit = -4
	recycle = skill_get(mut_recycle_gland)
	dir = 0
	on_end_step  = sniper_step
	on_hit 		 = void
	return id
}

#define make_trail(range,direction)
var num = random_range(20,40)
var _x = lengthdir_x(range,direction), _y = lengthdir_y(range,direction)
with instance_create(x-random(_x),y-random(_y),Dust){
    motion_set(direction + num*choose(-1,1),3+random(1))
    x+=hspeed
    y+=vspeed
}

#define shell_destroy
with instance_create(x + lengthdir_x(hyperspeed, direction), y + lengthdir_y(hyperspeed, direction), MeleeHitWall) {
    image_angle = other.direction
    image_speed *= 2
    image_index++
}
sound_play_hit(sndShotgunHitWall, .1)
x += lengthdir_x(hyperspeed, direction)
y += lengthdir_y(hyperspeed, direction)

line()
if mod_exists("mod","defparticles") {
	repeat(random(2) + 2) with mod_script_call_nc("mod", "defparticles", "create_spark", x, y) {
    	motion_set(random(360), random(3) + 1)
	    gravity = 0
	    age /= 2
	    depth = -5
	    color = merge_color(c_yellow, c_white, .5)
	    fadecolor = c_white
	}
}
else {
	with instance_create(x, y, BulletHit) {
		image_speed = .8
	}
}

#define sniper_step

while !collision_line(x,y,x+lengthdir_x(100,direction),y+lengthdir_y(100,direction),Wall,1,1) && !collision_line(x,y,x+lengthdir_x(100,direction),y+lengthdir_y(100,direction),hitme,0,1) && dir <1000{
    x+=lengthdir_x(100,direction)
    y+=lengthdir_y(100,direction)
    dir+=100
}

var _x = lengthdir_x(hyperspeed,direction), _y = lengthdir_y(hyperspeed,direction);
var shields = instances_matching_ne([CrystalShield,PopoShield], "team", team),
    slashes = instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team),
    shanks = instances_matching_ne([Shank,EnergyShank], "team", team),
    customslashes = instances_matching_ne(CustomSlash, "team", team),
    enemies = instances_matching_ne(hitme, "team", team),
    olddirection = direction

do
{
    dir += hyperspeed
	x += _x
	y += _y
	with shields {if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction;with instance_create(other.x,other.y,Deflect){image_angle = other.direction;sound_play_pitch(sndCrystalRicochet,random_range(.9,1.1))}}}
	with slashes {if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = direction ;other.image_angle = other.direction}}
	with shanks {if place_meeting(x,y,other){with other{instance_destroy();exit}}}
	with customslashes {if place_meeting(x,y,other){with other{line()};mod_script_call_self(on_projectile[0],on_projectile[1],on_projectile[2]);}}
	if direction != olddirection{
	    _x = lengthdir_x(hyperspeed,direction);
	    _y = lengthdir_y(hyperspeed,direction);
        var shields = instances_matching_ne([CrystalShield,PopoShield], "team", team),
            slashes = instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team),
            shanks = instances_matching_ne([Shank,EnergyShank], "team", team),
            customslashes = instances_matching_ne(CustomSlash, "team", team),
            enemies = instances_matching_ne(hitme, "team", team),
            olddirection = direction
	}
	with enemies{
        if distance_to_object(other) <= 4 and mask_index != mskNone and my_health > 0{
            with other{
                if recycle && irandom(2){
                    recycle--
                    with creator ammo[1] = min(ammo[1]+1,typ_amax[1])
                    sound_play(sndRecGlandProc)
                    with instance_create(x,y,RecycleGland) image_speed *= random_range(.8,1.2)
                }
                projectile_hit_np(other,damage,force,20)
                sleep(12)
                view_shake_at(x,y,4)
                sound_play_gun(sndEmpty,1,.5)
                sound_stop(sndEmpty)
                if other.my_health >= damage*3 || --damage <= 0{
                    instance_destroy()
                    exit
                }
            }
        }
	}
    if place_meeting(x, y, Wall){
        instance_destroy()
        exit
    }
}
while instance_exists(self) and dir < 1000
instance_destroy()

#define void


#define line()
var _num    = 25,												  //subdivisions of the distance in line segments
	_length = irandom_range(4, 6),								  //amount of subdivisions used for the bolt trail
	_width  = random_range(.7, 1.2),							  //the scale of all the bolt trails
	_pivot  = _num - _length - irandom((_num - 2 * _length)/2),   //the point at which the trails are centered, based off of the _num subdivisions
	_dist   = point_distance(x, y, xstart, ystart),				  //point distance
	_x      = lengthdir_x(_dist/_num, direction),				  //used so i dont have to recalculate the size of one of the subdivisions
	_y      = lengthdir_y(_dist/_num, direction),				  //^
	_xscale = _dist/_num,										  //xscale of all bolt trails
	_speed  = (_dist * (_pivot/_num)/_width * .2),				  //speed of all of the bolt trails, _width * .2 represents the most time itll take for the trails to disperse
	_yscale;
	
	for (var i = 1; i <= _num; i++) {
		_yscale = 1 - (min(abs(_pivot - i), _length)/_length)	  //i mean, its the width of the bolt trail, idk what the min is for
		if _yscale > 0 {
			with instance_create(x - _x * i, y - _y * i, BoltTrail) {
				image_xscale = _xscale
				image_angle = other.direction
				image_yscale = _yscale * _width
				motion_set(image_angle, _speed)
				if i < _num - 2 and !irandom(7)
					make_trail(image_xscale, image_angle + 180)
			}
		}
	}
	
	xstart = x
	ystart = y


#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);

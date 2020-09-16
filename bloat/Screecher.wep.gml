#define init
global.sprScreecher   = sprite_add_weapon("../sprites/weapons/sprScreecher.png", 2, 4);
global.sprSonicStreak = sprite_add("../sprites/projectiles/sprSonicStreak.png",6,8,64);

#define weapon_name
return "SCREECHER"

#define weapon_sprt
return global.sprScreecher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 22;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 9;

#define weapon_melee
return 0;

#define weapon_text
return "MAGIC REFLECTION";

#define weapon_fire
var _p = random_range(.8,1.2);
sound_play_pitch(sndFreakPopoHurt,.8*_p)
sound_play_pitch(sndFreakPopoRevive,1.8*_p)
sound_play_pitch(sndFreakPopoReviveArea,1.8*_p)
sound_play_pitch(snd_hurt,2*_p)
weapon_post(6,0,1)
sleep(50)
var ang = gunangle
var x1 = x, y1 = y
repeat(4)with instance_create(x+lengthdir_x(2,ang),y+lengthdir_y(2,ang),AcidStreak)
{
	speed = 4
	friction = random_range(.3,1.2)
	sprite_index = global.sprSonicStreak
	image_speed *= random_range(.8,1.2)
	image_angle = ang - 90 + random_range(-24,24)
	direction = image_angle + 90
}

with mod_script_call("mod","defpack tools","create_sonic_explosion",x1+lengthdir_x(16,ang),y1+lengthdir_y(16,ang))
{
	image_xscale = .1
	image_yscale = .1
	damage = 14
	image_speed = 0.75
	team = other.team
	creator = other
}
wait(2)
if !instance_exists(self){exit}
with mod_script_call("mod","defpack tools","create_sonic_explosion",x1+lengthdir_x(32,ang),y1+lengthdir_y(32,ang))
{
	image_xscale = .2
	image_yscale = .2
	damage = 10
	image_speed = 0.75
	team = other.team
	creator = other
}
wait(2)
if !instance_exists(self){exit}
with mod_script_call("mod","defpack tools","create_sonic_explosion",x1+lengthdir_x(72,ang),y1+lengthdir_y(72,ang))
{
	image_xscale = .5
	image_yscale = .5
	damage = 6
	image_speed = 0.75
	team = other.team
	creator = other
}

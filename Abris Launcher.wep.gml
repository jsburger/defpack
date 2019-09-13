#define init
global.sprAbrisLauncher = sprite_add_weapon("sprites/weapons/sprAbrisLauncher.png", 0, 4);

#define weapon_name
return "ABRIS LAUNCHER"

#define weapon_sprt
return global.sprAbrisLauncher;

#define weapon_type
return 4;

#define weapon_auto
return 1;

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

#define weapon_text
return "INCOMING";

#define weapon_fire
var _strtsize = 50;//never thought id have to nerf eagle eyes im so proud of you
var _endsize  = 30;
var _accspeed = 1.2;
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
	accspeed = 1.15
	damage = 3
	maxdamage = 15
	payload = script_ref_create(pop)
}
sound_play_pitch(sndSniperTarget,1/accuracy+.5)

#define pop
sound_play_pitch(sndGrenadeRifle,random_range(.5,.8))
sound_play_pitch(sndGrenade,random_range(.5,.8))
sound_play_pitch(sndGrenadeShotgun,random_range(.5,.8))
sound_play(sndExplosion)
if isplayer with creator weapon_post(6,25,35)
with instance_create(x, y, CustomObject)
{
	n = 8
	acc = other.acc
	timer = 0
	accmin = other.accmin
	accbase = other.accbase
	on_step = pop_step
}

#define pop_step
if n > 0
{
	if timer-- <= 0
	{
		n--
		var _d = random(360)
		if n != 0 with instance_create(x + lengthdir_x((accbase * acc)/accmin, _d) * random_range(.6,1), y + lengthdir_y((accbase * acc)/accmin, _d) * random_range(.6,1), SmallExplosion)
		{
			hitid = [sprite_index,"small explosion"]
			sound_play(sndExplosionS)
			sleep(5)
			view_shake_at(x, y, 4)
		}
		else with instance_create(x + lengthdir_x((accbase * acc)/accmin, _d) * random_range(.6,1), y + lengthdir_y((accbase * acc)/accmin, _d) * random_range(.6,1), Explosion)
		{
			hitid = [sprite_index,"explosion"]
			sound_play(sndExplosion)
			sleep(20)
			view_shake_at(x, y, 24)
		}
		timer = 1
		if n = 1 timer = 4
		if n = 2 timer = 2
	}
}
else
{
	instance_delete(self)
	exit
}

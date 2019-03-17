#define init
global.sprAutoAbrisLauncher = sprite_add_weapon("sprites/sprAutoAbrisLauncher.png", 0, 2);

#define weapon_name
return "AUTO ABRIS LAUNCHER"

#define weapon_sprt
return global.sprAutoAbrisLauncher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 13;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 10;

#define weapon_reloaded
weapon_post(-1,-3,0)
sound_play_pitchvol(sndNadeReload,1.4,.6)

#define weapon_text
return "RECOVERY FUEL";

#define weapon_fire
var _strtsize = 30;
var _endsize  = 14;
sound_play_pitch(sndSniperTarget,3)
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
	accspeed = 1.3
	payload = script_ref_create(pop)
	auto = 1
	damage = 4
	maxdamage = 12
}
sound_play_pitch(sndSniperTarget,1/accuracy+3)

#define pop
sound_play_pitch(sndGrenadeRifle,random_range(.5,.8))
sound_play_pitch(sndGrenadeShotgun,random_range(.5,.8))
sound_play(sndExplosionS)
if isplayer with creator weapon_post(5,25,5)
instance_create(x + lengthdir_x(acc, offset), y + lengthdir_y(acc, offset), Explosion)
repeat(3){
	instance_create(x + lengthdir_x(acc+accmin, offset), y + lengthdir_y(acc+accmin, offset), SmallExplosion)
	offset = random(360)
}

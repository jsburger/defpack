#define init
global.sprAbrisLauncher = sprite_add_weapon("sprites/sprAbrisLauncher.png", 0, 4);

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
var n = 8;
repeat(n){
	with instance_create(x + lengthdir_x(acc + accmin, offset), y + lengthdir_y(acc + accmin, offset), SmallExplosion){
	    hitid = [sprite_index,"small explosion"]
	}
	offset += 360/n
}

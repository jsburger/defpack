#define init
global.sprAbrisPistol = sprite_add_weapon("sprites/sprAbrisPistol.png", -1, 3);

#define weapon_name
return "ABRIS PISTOL"

#define weapon_sprt
return global.sprAbrisPistol;

#define weapon_type
return 4;

#define weapon_auto
return 1;

#define weapon_load
return 21;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 3;

#define weapon_reloaded
weapon_post(-1,-3,0)
sound_play_pitchvol(sndNadeReload,1.4,.6)

#define weapon_text
return "GET SOME COVER";

#define weapon_fire
var _strtsize = 30;
var _endsize  = 15;
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
	accspeed = 1.33
	damage = 1
	maxdamage = 3
	payload = script_ref_create(pop)
}
sound_play_pitch(sndSniperTarget,1/accuracy+1.5)

#define pop
sound_play_pitch(sndGrenadeRifle,random_range(1.5,1.8))
sound_play_pitch(sndGrenade,random_range(1.5,1.8))
sound_play(sndExplosionS)
with creator weapon_post(4,12,6)
repeat(3)
{
	with instance_create(explo_x+lengthdir_x(acc+12,offset),explo_y+lengthdir_y(acc+12,offset),SmallExplosion){hitid = [sprite_index,"small explosion"]}
	offset += 120
}

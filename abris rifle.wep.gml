#define init
global.sprAbrisRifle = sprite_add_weapon("sprites/sprAbrisRifle.png", 3, 2);

#define weapon_name
return "ABRIS RIFLE"

#define weapon_sprt
return global.sprAbrisRifle;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 4;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 11;

#define weapon_reloaded
weapon_post(-1,-3,0)
sound_play_pitchvol(sndNadeReload,1.4,.6)

#define weapon_text
return "FASTER, FASTER";

#define weapon_fire
var _strtsize = 20;
var _endsize  = 8;
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
	accspeed = 1.07
	auto = 1
	damage = 2
	maxdamage = 2
	payload = script_ref_create(pop)
}
sound_play_pitch(sndSniperTarget,1/accuracy+1)

#define pop
sound_play_pitch(sndGrenadeShotgun,random_range(1.5,1.8))
sound_play_pitch(sndGrenade,random_range(1.5,1.8))
sound_play(sndExplosionS)
with creator weapon_post(4,12,6)
repeat(3)
{
	with instance_create(explo_x+lengthdir_x(acc+12,offset),explo_y+lengthdir_y(acc+12,offset),SmallExplosion){hitid = [sprite_index,"small explosion"]}
	offset += 120
}

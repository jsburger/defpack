#define init
global.sprAbrisRifle = sprite_add_weapon("sprites/sprAbrisRifle.png", 3, 1);
global.stripes 		   = sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_name
return "ABRIS RIFLE"

#define weapon_sprt
return global.sprAbrisRifle;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 12;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 11;

#define weapon_text
return "DISTANT ADMIRATION";

#define weapon_fire
var _strtsize = 52;
var _endsize  = 8;
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
	accspeed = 1.1
	payload = script_ref_create(pop)
}
sound_play_pitch(sndSniperTarget,exp((_strtsize-_endsize)/room_speed/current_time_scale/accuracy*(1.33)))

#define pop
sound_play_pitch(sndGrenadeRifle,random_range(1.1,1.4))
sound_play(sndExplosionS)
creator.wkick = 2
repeat(3)
{
	with instance_create(explo_x+lengthdir_x(acc+12,offset),explo_y+lengthdir_y(acc+12,offset),SmallExplosion){hitid = [sprite_index,"small explosion"]}
	offset += 120
}
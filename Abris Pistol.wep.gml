#define init
global.sprAbrisPistol = sprite_add_weapon("sprites/sprAbrisPistol.png", -1, 3);
global.stripes = sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_name
return "ABRIS PISTOL"

#define weapon_sprt
return global.sprAbrisPistol;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 13;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 5;

#define weapon_text
return "GET SOME COVER";

#define weapon_fire
var _strtsize = 27;
var _endsize  = 18;
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
	accspeed = 1.33
	payload = script_ref_create(pop)
}
sound_play_pitch(sndSniperTarget,exp((_strtsize-_endsize)/room_speed/current_time_scale/accuracy*(1.33)))

#define pop
sound_play_pitch(sndGrenadeRifle,random_range(1.1,1.4))
sound_play(sndExplosionS)
creator.wkick = 2
repeat(3)
{
	with instance_create(mouse_x[index]+lengthdir_x(acc+12,offset),mouse_y[index]+lengthdir_y(acc+12,offset),SmallExplosion){hitid = [sprite_index,"small explosion"]}
	offset += 120
}

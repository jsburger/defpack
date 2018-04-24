#define init
global.sprGoldenAbrisPistolLoadout = sprite_add_weapon("sprites/sprGoldenAbrisPistolLoadout.png", 16, 16);
global.sprGoldenAbrisPistol 			 = sprite_add_weapon("sprites/sprGoldenAbrisPistol.png", -1, 2);
global.stripes 										 = sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_gold
return 1;

#define weapon_loadout
return global.sprGoldenAbrisPistolLoadout;

#define weapon_name
return "GOLDEN ABRIS PISTOL"

#define weapon_sprt
return global.sprGoldenAbrisPistol;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 10;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 17;

#define weapon_text
return "PROTECTED BY @yWEALTH";

#define weapon_fire
var _strtsize = 27-skill_get(13)*5;
var _endsize  = 18;
with mod_script_call("mod","defpack tools","create_abris",self,27,18,argument0){
	accspeed = 1.45
	payload = script_ref_create(pop)
}
sound_play_pitch(sndSniperTarget,exp((_strtsize-_endsize)/room_speed/current_time_scale/accuracy*(1.2)))


#define pop
sound_play_pitch(sndGrenadeRifle,random_range(1.1,1.4))
sound_play(sndExplosionS)
sound_play(sndGoldShotgun)
creator.wkick = 2
repeat(3)
{
	with instance_create(mouse_x[index]+lengthdir_x(acc+12,offset),mouse_y[index]+lengthdir_y(acc+12,offset),SmallExplosion){hitid = [sprite_index,"small explosion"]}
	offset += 120
}

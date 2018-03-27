#define init
global.sprSmallAbrisLauncher = sprite_add_weapon("sprites/Small Abris Launcher.png", -1, 3);
global.stripes = sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_name
return "ABRIS PISTOL"

#define weapon_sprt
return global.sprSmallAbrisLauncher;

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
sound_play_pitch(sndSniperTarget,1.8)
with mod_script_call("mod","defpack tools","create_abris",self,27,18,argument0){
	accspeed = [1.33,3.5]
	payload = script_ref_create(pop)
}

#define pop
sound_play(sndGrenadeRifle)
sound_play(sndExplosionS)
creator.wkick = 2
repeat(3)
{
	with instance_create(mouse_x[index]+lengthdir_x(acc+12,offset),mouse_y[index]+lengthdir_y(acc+12,offset),SmallExplosion){hitid = [sprite_index,"small explosion"]}
	offset += 120
}

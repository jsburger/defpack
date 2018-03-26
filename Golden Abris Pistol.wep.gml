#define init
global.sprGSmallAbrisLauncher = sprite_add_weapon("Golden Small Abris Launcher.png", -1, 2);
global.stripes = sprite_add("BIGstripes.png",1,1,1)

#define weapon_gold
return 1;

#define weapon_loadout
return global.sprGSmallAbrisLauncherLoadout;

#define weapon_name
return "GOLDEN ABRIS PISTOL"

#define weapon_sprt
return global.sprGSmallAbrisLauncher;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 10;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 17;

#define weapon_text
return "PROTECTED BY @yWEALTH";

#define weapon_fire
sound_play_pitch(sndSniperTarget,1.8)
with mod_script_call("mod","defpack tools","create_abris",self,27,18,argument0){
	accspeed = [1.45,3.5]
	payload = script_ref_create(pop)
}

#define pop
sound_play(sndGrenadeRifle)
sound_play(sndExplosionS)
sound_play(sndGoldShotgun)
creator.wkick = 2
repeat(3)
{
	with instance_create(mouse_x[index]+lengthdir_x(acc+12,offset),mouse_y[index]+lengthdir_y(acc+12,offset),SmallExplosion){hitid = [sprite_index,"small explosion"]}
	offset += 120
}

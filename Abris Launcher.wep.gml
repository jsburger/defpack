#define init
global.sprAbrisLauncher = sprite_add_weapon("sprites/Abris Launcher.png", 0, 3);
global.stripes = sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_name
return "ABRIS LAUNCHER"

#define weapon_sprt
return global.sprAbrisLauncher;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 24;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 8;

#define weapon_text
return "HIDE AND KILL";

#define weapon_fire
sound_play_pitch(sndSniperTarget,1.5)
with mod_script_call("mod","defpack tools","create_abris",self,45,30,argument0){
	accspeed = [1.2,2.8]
	payload = script_ref_create(pop)
}

#define pop
sound_play(sndGrenadeRifle)
sound_play(sndExplosion)
creator.wkick = 5
repeat(3)
{
	with instance_create(mouse_x[index]+lengthdir_x(acc+30,offset),mouse_y[index]+lengthdir_y(acc+30,offset),Explosion){hitid = [sprite_index,"explosion"]}
	offset += 120
}

#define init
global.sprSteelDiver = sprite_add_weapon("sprites/sprSteelDiver.png", 5, 3);

#define weapon_name
return "STEEL DIVER"

#define weapon_sprt
return global.sprSteelDiver;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 43;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return -1;

#define weapon_text
return "TAKE A DIVE";

#define weapon_fire

sound_play_pitch(sndSlugger,1.5)
sound_play_pitch(sndShotgun,1.5)
sound_play_pitch(sndDoubleShotgun,1.5)
sound_play_pitch(sndSuperSlugger,1.5)
weapon_post(7,-40,5)
with mod_script_call("mod", "defpack tools 2","create_flak",0,2,8,0,"split",35,id){ //god damn im spooked, i tested this but fuck man its gonna go wrong
	ammo = 1
	image_xscale += .5
	image_yscale += .5
}
with mod_script_call("mod", "defpack tools 2","create_flak",0,2,8,0,"split",22,id){ //god damn im spooked, i tested this but fuck man its gonna go wrong
	ammo = 1
	direction += 20 * other.accuracy
}
with mod_script_call("mod", "defpack tools 2","create_flak",0,2,8,0,"split",22,id){ //god damn im spooked, i tested this but fuck man its gonna go wrong
	ammo = 1
	direction -= 20 * other.accuracy
}

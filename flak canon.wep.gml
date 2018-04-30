#define init
global.sprFlakCanon = sprite_add_weapon("sprites/sprFlakCanon.png", 4, 4);

#define weapon_name
return "@qF@qL@qA@qK @qC@qA@qN@qO@qN"

#define weapon_sprt
return global.sprFlakCanon;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 47;

#define weapon_cost
return 8;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 11;

#define weapon_text
return "540/600";

#define weapon_fire

sound_play(sndMachinegun)
sound_play(sndCrossbow)
sound_play_pitch(sndShotgun,.7)
sound_play_pitch(sndFlakCannon,1.2)
sound_play_pitch(sndSuperFlakCannon,.7)
weapon_post(8,-20,20)
mod_script_call("mod", "defpack tools 2","create_flak",0,80,13,random_range(0.4,0.85),"recursive",25,id)

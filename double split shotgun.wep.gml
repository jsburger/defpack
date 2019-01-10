#define init
global.sprDoubleSplitShotgun = sprite_add_weapon("sprites/sprDoubleSplitShotgun.png", 3, 2);

#define weapon_name
return "DOUBLE SPLIT SHOTGUN";

#define weapon_sprt
return global.sprDoubleSplitShotgun;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 38;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 9;

#define weapon_text
return "THE MANY BEAT THE FEW";

#define weapon_fire
weapon_post(7,0,26)
sound_play_pitch(sndDoubleShotgun,random_range(1.3,1.5))
sound_play_pitch(sndSlugger,random_range(1.3,1.5))
sound_play_pitch(sndLaser, random_range(1, 1.3))
repeat(5){
	with mod_script_call("mod","defpack tools","create_split_shell",x,y){
		creator = other
		team = other.team
		motion_add(other.gunangle + 12 + random_range(-20,20)*other.accuracy,random_range(14,18))
		image_angle = direction
	}
}
repeat(5){
	with mod_script_call("mod","defpack tools","create_split_shell",x,y){
		creator = other
		team = other.team
		motion_add(other.gunangle - 12 + random_range(-20,20)*other.accuracy,random_range(14,18))
		image_angle = direction
	}
}

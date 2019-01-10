#define init
global.sprHeavySplitShotgun = sprite_add_weapon("sprites/sprSplitSlugShotgun.png", 3, 2);

#define weapon_name
return "HEAVY SPLIT SHOTGUN";

#define weapon_sprt
return global.sprHeavySplitShotgun;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 23;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 11;

#define weapon_text
return "THE HORDE BEATS THE MANY";

#define weapon_fire

weapon_post(7,0,27)
sound_play_pitch(sndShotgun,random_range(1.3,1.5))
sound_play_pitch(sndSuperSlugger,random_range(1.3,1.5))
sound_play_pitch(sndLaser, random_range(.8, 1))
repeat(5){
	with mod_script_call("mod","defpack tools","create_heavy_split_shell",x,y){
		creator = other
		team = other.team
		motion_add(other.gunangle + random_range(-20,20)*other.accuracy,random_range(14,18))
		image_angle = direction
	}
}

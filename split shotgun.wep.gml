#define init
global.sprSplitShotgun = sprite_add_weapon("sprites/sprSplitShotgun.png", 3, 2);

#define weapon_name
return "SPLIT SHOTGUN";

#define weapon_sprt
return global.sprSplitShotgun;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 23;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 7;

#define weapon_text
return "MORE @ySHELL @sPER @ySHELL";

#define weapon_fire

weapon_post(6,0,19)
sound_play_pitch(sndShotgun,random_range(1.3,1.5))
sound_play_pitch(sndSlugger,random_range(1.3,1.5))
sound_play_pitch(sndLaser, random_range(1.4, 1.6))
repeat(5){
	with mod_script_call("mod","defpack tools","create_split_shell",x,y){
		creator = other
		team = other.team
		motion_add(other.gunangle + random_range(-20,20)*other.accuracy,random_range(14,18))
		image_angle = direction
	}
}

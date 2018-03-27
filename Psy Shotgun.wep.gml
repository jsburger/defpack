#define init
global.sprPsyShotgun = sprite_add_weapon("sprites/Psy Shotgun.png", 3, 2);

#define weapon_name
return "PSY SHOTGUN";

#define weapon_sprt
return global.sprPsyShotgun;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 21;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 7;

#define weapon_text
return "MOVE";

#define weapon_fire

weapon_post(6,-14,11)
sound_play(sndShotgun)
repeat(7){
	with mod_script_call("mod","defpack tools","create_psy_shell",x,y){
		creator = other
		team = other.team
		motion_add(other.gunangle + random_range(-20,20)*other.accuracy,random_range(10,14))
		image_angle = direction
	}
}

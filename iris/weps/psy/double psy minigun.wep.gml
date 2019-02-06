#define init
global.sprDoublePsyMinigun = sprite_add_weapon("sprites/sprDoublePsyMinigun.png", 6, 4);

#define weapon_name
return "DOUBLE PSY MINIGUN";

#define weapon_sprt
return global.sprDoublePsyMinigun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 2;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "BANNED";

#define weapon_fire

sound_play_pitch(sndCursedReminder,.4)
sound_play_pitch(sndDoubleMinigun,.8)
weapon_post(8,-12,8)
motion_add(gunangle-180,4)
repeat(2)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,4), c_purple)

with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,10)
	team = other.team
	motion_add(other.gunangle+15+random_range(-17,17)*other.accuracy,8)
	maxspeed = speed
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
	creator = other
	move_contact_solid(other.gunangle,10)
	team = other.team
	motion_add(other.gunangle-15+random_range(-17,17)*other.accuracy,8)
	maxspeed = speed
	image_angle = direction
}

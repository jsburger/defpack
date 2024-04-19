#define init
global.sprAssaultFireRifle = sprite_add_weapon("../../sprites/weapons/iris/fire/sprAssaultFireRifle.png", 6, 2);
#define weapon_name
return "FIRE ASSAULT RIFLE";

#define weapon_sprt
return global.sprAssaultFireRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 10;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "MAN ITS A HOT ONE";

#define weapon_fire

repeat(3)
{
	weapon_post(2,-1,3)
	var vol = .6
	sound_play_pitchvol(sndMachinegun, 1, vol)
	sound_play_pitchvol(sndSwapFlame, .7, vol)
	sound_play_pitchvol(sndIncinerator, .9, vol)
	mod_script_call("mod","defpack tools", "shell_yeah", 180, 25, 2+random(2), c_red)
	with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
		creator = other
		team = other.team
		motion_set(other.gunangle + random_range(-10,10) * other.accuracy,15)
		image_angle = direction
	}
	wait(2)
	if !instance_exists(self){exit}
}

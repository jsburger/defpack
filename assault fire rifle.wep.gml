#define init
global.sprAssaultFireRifle = sprite_add_weapon("sprites/sprAssaultFireRifle.png", 6, 2);
#define weapon_name
return "ASSAULT FIRE RIFLE";

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
	sound_play(sndMachinegun)
	sound_play_pitch(sndSwapFlame,.7)
	sound_play_pitch(sndIncinerator,.9)
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_red)
	with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
		creator = other
		team = other.team
		motion_set(other.gunangle + random_range(-10,10) * other.accuracy,15)
		image_angle = direction
	}
	wait(2)
	if !instance_exists(self){exit}
}

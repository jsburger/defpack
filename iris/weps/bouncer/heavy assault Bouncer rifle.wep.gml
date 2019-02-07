#define init
global.sprHeavyBouncerRifle = sprite_add_weapon("sprites/sprHeavyBouncerAssaultRifle.png", 4, 2);

#define weapon_name
return "HEAVY ASSAULT BOUNCER RIFLE"

#define weapon_sprt
return global.sprHeavyBouncerRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 14;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return choose("DO YOU WONDER HOW#THESE BULLETS WORK");

#define weapon_fire
repeat(3)
{
	weapon_post(4,-7,3)
	var _p = random_range(.8,1.2)
	sound_play_pitch(sndBouncerSmg,.7*_p)
	sound_play_pitch(sndHeavyRevoler,1.2*_p)
	sound_play_pitch(sndBouncerShotgun,1.6*_p)
	mod_script_call("mod","defpack tools", "shell_yeah_heavy", 180, 25, 2+random(2), c_yellow)
	with mod_script_call("mod", "defpack tools", "create_heavy_bouncer_bullet",x,y){
		creator = other
		team = other.team
		motion_set(other.gunangle + random_range(-3,3) * other.accuracy,8)
		image_angle = direction
	}
	wait(3)
	if !instance_exists(self) exit
}

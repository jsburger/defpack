#define init
global.sprAssaultPsyRifle = sprite_add_weapon("sprites/sprHeavyPsyAssaultRifle.png", 4, 3);

#define weapon_name
return "HEAVY PSY ASSAULT RIFLE";

#define weapon_sprt
return global.sprAssaultPsyRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 18;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "NO ESCAPE";

#define weapon_fire

repeat(3)
{
	weapon_post(5,-12,10)
	var p = random_range(.8,1.2)
	sound_play_pitch(sndPistol,.7*p)
	sound_play_pitch(sndSwapCursed,.3*p)
	sound_play_pitch(sndCursedPickup,.8*p)
	sound_play_pitchvol(sndHeavyRevoler,1.5*p,.8)
	mod_script_call("mod","defpack tools", "shell_yeah_heavy", 180, 25, random_range(2,4), c_purple)
	with mod_script_call("mod", "defpack tools", "create_heavy_psy_bullet",x,y){
		creator = other
		move_contact_solid(other.gunangle,5)
		team = other.team
		motion_add(other.gunangle+random_range(-6,6)*other.accuracy,12)
		image_angle = direction
	}
wait(2)
if !instance_exists(self){exit}

}

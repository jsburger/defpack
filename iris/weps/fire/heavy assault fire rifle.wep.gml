#define init
global.sprHeavyAssaultFireRifle = sprite_add_weapon("sprites/sprHeavyFireAssaultRifle.png", 6, 3);
#define weapon_name
return "HEAVY FIRE ASSAULT RIFLE";

#define weapon_sprt
return global.sprHeavyAssaultFireRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 10;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "THIS ONE'S HOT";

#define weapon_fire

repeat(3)
{
	var p = random_range(.8,1.2)
	sound_play_pitchvol(sndHeavyRevoler,.9*p,.8)
	sound_play_pitchvol(sndSwapFlame,.8*p,.7)
	sound_play_pitchvol(sndIncinerator,p,.6)
	sound_play_pitchvol(sndFlameCannonEnd,.8*p,.4)
	weapon_post(4,-7,3)
	mod_script_call("mod","defpack tools", "shell_yeah_heavy", 180, 25, 2+random(2), c_red)
	with mod_script_call("mod", "defpack tools", "create_heavy_fire_bullet",x,y){
		creator = other
		team = other.team
		motion_set(other.gunangle + random_range(-6,6) * other.accuracy,16)
		image_angle = direction
	}
	wait(2)
	if !instance_exists(self){exit}
}

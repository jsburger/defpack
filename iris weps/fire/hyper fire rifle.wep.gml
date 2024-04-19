#define init
global.sprHyperFireRifle = sprite_add_weapon("../../sprites/weapons/iris/fire/sprHyperFireRifle.png", 7, 4);
#define weapon_name
return "HYPER FIRE RIFLE";

#define weapon_sprt
return global.sprHyperFireRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 4;

#define weapon_cost
return 5;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "MAKESHIFT FLAMETHROWER";

#define weapon_fire

var vol = .8,
	pitch = random_range(.8, 1.2);
repeat(5)
{
	weapon_post(4,-1,7)
	sound_play_pitchvol(sndHyperRifle, pitch, vol)
	sound_play_pitchvol(sndIncinerator, .4 * pitch, vol)
	mod_script_call("mod","defpack tools", "shell_yeah", 180, 25, 2+random(3), c_red)
	with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
		creator = other
		team = other.team
		move_contact_solid(other.gunangle,6)
		motion_set(other.gunangle + random_range(-7,7) * other.accuracy,17)
		image_angle = direction
	}
	wait(1)
	if !instance_exists(self) exit
}

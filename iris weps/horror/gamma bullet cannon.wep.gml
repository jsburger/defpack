#define init
global.sprHorrorBulletCannon = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprHorrorCannonOn.png", 5, 3);
#define weapon_name
return "GAMMA BULLET CANNON";

#define weapon_sprt
return global.sprHorrorBulletCannon;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 24;

#define weapon_cost
return 7;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "RADIOACTIVE SHOCK";

#define weapon_fire

weapon_post(9,-6,62)
var _ptch = random_range(-.4,.4);
sound_play_pitch(sndPistol,.8)
sound_play_pitch(sndMachinegun,.8+_ptch)
sound_play_pitchvol(sndUltraPistol,2.4, .7)
repeat(7)
{
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(2), c_lime)
	repeat(2)with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x+lengthdir_x(random_range(-7,7)*accuracy,gunangle+90),y+lengthdir_y(random_range(-7,7)*accuracy,gunangle+90))
	{
		team = other.team
		creator = other
		move_contact_solid(other.gunangle,5)
		motion_add(other.gunangle+random_range(-32,32)*other.accuracy,14+random_range(-2,2)*other.accuracy)
		image_angle = direction
	}
}

#define init
global.sprBouncerBulletCannon = sprite_add_weapon("sprites/sprBouncerCannon.png", 4, 0);
#define weapon_name
return "BOUNCER BULLET CANNON";

#define weapon_sprt
return global.sprBouncerBulletCannon;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 32;

#define weapon_cost
return 7;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "WOBBLING BLAST";

#define weapon_fire

weapon_post(9,-6,62)
var _ptch = random_range(-.4,.4);
sound_play_pitch(sndPistol,.5)
sound_play_pitch(sndMachinegun,.6+_ptch)
sound_play_pitch(sndBouncerShotgun,.8)
sound_play_pitch(sndBouncerSmg,.7+_ptch/4)
repeat(8)
{
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(2), c_yellow)
	with instance_create(x+lengthdir_x(random_range(-7,7)*accuracy,gunangle+90),y+lengthdir_y(random_range(-7,7)*accuracy,gunangle+90),BouncerBullet)
	{
		team = other.team
		creator = other
		move_contact_solid(other.gunangle,5)
		motion_add(other.gunangle+random_range(-11,11)*other.accuracy,8+random_range(-3,3)*other.accuracy)
		image_angle = direction
	}
}

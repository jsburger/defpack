#define init
global.sprPsyBulletCannon = sprite_add_weapon("sprites/sprPsyBulletCannon.png", 4, 2);
global.sprPsyBullet 	 		= sprite_add("defpack tools/Psy Bullet.png", 2, 8, 8)
#define weapon_name
return "PSY BULLET CANNON";

#define weapon_sprt
return global.sprPsyBulletCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 50;

#define weapon_cost
return 14;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "replace me please";

#define weapon_fire
weapon_post(9,-6,72)
var _ptch = random_range(-.4,.4);
sound_play_pitch(sndPistol,.5)
sound_play_pitch(sndSwapShotgun,5+_ptch/7)
sound_play_pitch(sndCursedReminder,.2)
sound_play_pitch(sndMinigun,.4+_ptch/12)
//sound_play_pitchvol(sndStatueDead,.7+_ptch/7,.2) to good for this
repeat(8)
{
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(2), c_purple)
	with mod_script_call("mod", "defpack tools", "create_psy_bullet",x+lengthdir_x(random_range(-7,7)*accuracy,gunangle+90),y+lengthdir_y(random_range(-7,7)*accuracy,gunangle+90)){
		team = other.team
		move_contact_solid(other.gunangle,5)
		motion_add(other.gunangle+random_range(-12,12)*other.accuracy,5+random_range(-1,1)*other.accuracy)
		image_angle = direction
	}
}

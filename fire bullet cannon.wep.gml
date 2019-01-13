#define init
global.sprFireBulletCannon = sprite_add_weapon("sprites/sprFireBulletCannon.png", 4, 2);
global.sprFireBullet 			 = sprite_add("defpack tools/Fire Bullet.png", 2, 8, 8)
#define weapon_name
return "FIRE BULLET CANNON";

#define weapon_sprt
return global.sprFireBulletCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 23;

#define weapon_cost
return 7;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "GOUTS OF @rFLAME@d";

#define weapon_fire

weapon_post(9,-6,72)
var _ptch = random_range(-.4,.4);
sound_play_pitch(sndHeavySlugger,2+_ptch)
sound_play_pitch(sndDoubleFireShotgun,2)
sound_play_pitch(sndSawedOffShotgun,1.8)
sound_play_pitch(sndFlamerStop,.4)
repeat(8)
{
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_red)
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x+lengthdir_x(random_range(-7,7)*accuracy,gunangle+90),y+lengthdir_y(random_range(-7,7)*accuracy,gunangle+90)){
	creator = other
	team = other.team
	team = other.team
	move_contact_solid(other.gunangle,5)
	motion_add(other.gunangle+random_range(-18,18)*other.accuracy,18+random_range(-9,7)*other.accuracy)
	image_angle = direction
}
}

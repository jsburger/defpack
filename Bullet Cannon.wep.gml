#define init
global.sprBulletCannon    = sprite_add_weapon("sprites/weapons/sprBulletCannon.png", 4, 2);
global.sprBulletCannonHUD = sprite_add_weapon("sprites/weapons/sprBulletCannon.png", 4, 4);

#define weapon_name
return "BULLET CANNON";

#define weapon_sprt
return global.sprBulletCannon;

#define weapon_sprt_hud
return global.sprBulletCannonHUD;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 24;

#define weapon_cost
return 7;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 7;

#define weapon_iris
return "x bullet cannon"

#define nts_weapon_examine
return{
    "d": "Plenty of space to cram in some bullets. ",
}

#define weapon_text
return "YOU CAN FIT SO MANY @yBULLETS@s IN HERE";

#define weapon_fire

weapon_post(9,-6,62)
//sound_play_pitch(sndTurretFire,.6) smarter gun sound
var _ptch = random_range(-.4,.4);
sound_play_pitch(sndPistol,.5)
sound_play_pitch(sndMachinegun,1.6+_ptch)
sound_play_pitch(sndHeavySlugger,2+_ptch)
sound_play_pitch(sndSawedOffShotgun,2)
//sound_play_pitch(sndGrenade,.2) sexy energy
repeat(8)
{
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(2), c_yellow)
	with instance_create(x+lengthdir_x(random_range(-7,7)*accuracy,gunangle+90),y+lengthdir_y(random_range(-7,7)*accuracy,gunangle+90),Bullet1)
	{
		team = other.team
		creator = other
		move_contact_solid(other.gunangle,5)
		motion_add(other.gunangle+random_range(-7,7)*other.accuracy,16+random_range(-3,3)*other.accuracy)
		image_angle = direction
	}
}

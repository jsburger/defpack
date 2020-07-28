#define init
global.sprPlasmitePistol = sprite_add_weapon("sprites/weapons/sprPlasmitePistol.png",0,1)
#define weapon_name
return "PLASMITE PISTOL"
#define weapon_sprt
return global.sprPlasmitePistol;
#define weapon_type
return 5
#define weapon_cost
return 1
#define weapon_area
return 3
#define weapon_load
return 12
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return 0
#define weapon_laser_sight
return 0
#define weapon_text
return "EHE";
#define weapon_fire
var _flip = instance_is(self, Player) ? wepflip : choose(-1, 1)
repeat(2)
{
	weapon_post(5,0,4)
	sound_pitch(
		sound_play_gun(skill_get(17) > 0 ? sndPlasmaUpg : sndPlasma, 0, .7), 2 + random(.1)
	)
	with mod_script_call("mod", "defpack tools", "create_plasmite", x, y)
	{
		fric = random_range(.06,.08) + .08
		motion_set(other.gunangle + random_range(6, 16) * other.accuracy * _flip, 16 * random_range(.8, 1.2))
		maxspeed = speed
		projectile_init(other.team, other)
		image_angle = direction
	}
	_flip *= -1
	wait(2)
	if !instance_exists(self) exit
}

#define init
global.sprDoublePsyMinigun = sprite_add_weapon("../../sprites/weapons/iris/psy/sprDoublePsyMinigun.png", 6, 4);

#define weapon_name
return "DOUBLE PSY MINIGUN";

#define weapon_sprt
return global.sprDoublePsyMinigun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 1;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "BANNED";

#define weapon_fire

sound_play_pitch(sndCursedReminder,.4)
sound_play_pitch(sndDoubleMinigun,.8)
weapon_post(8,-14,5)
motion_add(gunangle-180,4)
repeat(2)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,4), c_purple)

var i = -1;
repeat(2) {
	with mod_script_call_self("mod", "defpack tools", "shoot_psy_random_target", x, y, 5, team) {
		move_contact_solid(other.gunangle, 10)
	    motion_set(other.gunangle + (random_range(-17, 17) + 15 * i) * other.accuracy, 8)
	    image_angle = direction
	    projectile_init(other.team, other)
	    i+=2
	}
}
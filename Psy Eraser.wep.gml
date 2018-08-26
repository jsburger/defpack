#define init
global.PsyEraser = sprite_add_weapon("sprites/Psy Eraser.png", 2, 1);

#define weapon_name
return "PSY ERASER";

#define weapon_sprt
return global.PsyEraser;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 26;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 12;

#define weapon_text
return "STEP AWAY";

#define weapon_fire

weapon_post(6,-20,5)
sound_play(sndEraser)
var spd = 1
repeat(23){
	with mod_script_call("mod", "defpack tools", "create_psy_shell",x,y){
		creator = other
		team = other.team
		motion_add(other.gunangle,6+spd/3)
		image_angle = direction
	}
	spd += 1
}

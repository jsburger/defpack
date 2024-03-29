#define init
global.sprGammaSubata = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprHorrorSubataOn.png",4,3)
global.sprBullet = sprite_add("../../sprites/projectiles/iris/horror/sprGammaBullet.png", 2, 8, 8);

#define weapon_name
return "GAMMA SUBATA"
#define weapon_type
return 1
#define weapon_cost
return 1
#define weapon_area
return -1;
#define weapon_load
return 3
#define weapon_swap
return sndSwapPistol
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
var _p = random_range(.8, 1.4);
sound_play_pitchvol(sndUltraPistol, 2 * _p, .6)
sound_play_pitchvol(sndDoubleMinigun, .4 * _p, .6)
sound_play_pitchvol(sndUltraShotgun, 1.5 * _p, .5)
sound_play(sndMinigun)
sound_play_gun(sndClickBack, 0, 1)
sound_stop(sndClickBack)

weapon_post(5, 10, 0)

with instance_create(x + lengthdir_x(16, gunangle) + hspeed, y + lengthdir_y(16, gunangle) + vspeed, CustomObject) {
	depth = -1
	sprite_index = global.sprBullet
	image_speed = .9
	on_step = muzzle_step
	on_draw = muzzle_draw
	image_yscale = .33
	image_xscale = .66
	image_angle = other.gunangle
}

mod_script_call("mod", "defpack tools", "shell_yeah", 90, 40, 2 + random(2), c_lime);

with mod_script_call("mod", "defhitscan", "create_gamma_hitscan_bullet", x + lengthdir_x(12, gunangle) + hspeed, y + lengthdir_y(12, gunangle) + vspeed){
	direction = other.gunangle + random_range(-2, 2) * other.accuracy;
	image_angle = direction;
	creator = other
	team = other.team
	force += 4;
	damage++
	trailsize += .35
}
//Second bullet intentionally does not get the damage boost. It's spam
with mod_script_call("mod", "defhitscan", "create_gamma_hitscan_bullet", x + lengthdir_x(12, gunangle) + hspeed, y + lengthdir_y(12, gunangle) + vspeed){
	direction = other.gunangle + random_range(-8, 8) * other.accuracy;
	image_angle = direction;
	creator = other
	team = other.team
	force += 4;
}

#define weapon_sprt
return global.sprGammaSubata
#define weapon_text
return "BLOWTHROUGH ROUNDS"

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);

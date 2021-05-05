#define init
global.sprSubata = sprite_add_weapon("sprites/weapons/sprSubata.png",4,3)

#define weapon_name
return "SUBATA"
#define weapon_type
return 1
#define weapon_cost
return 2
#define weapon_area
return 6;
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
//sound_play_pitch(sndHitMetal, .1 * _p)
sound_play_pitchvol(sndMachinegun, 2 * _p, .7)
sound_play_pitchvol(sndDoubleMinigun, .6 * _p, 1)
weapon_post(5, 10, 0)

with instance_create(x + lengthdir_x(16, gunangle), y + lengthdir_y(16, gunangle), CustomObject) {
	depth = -1
	sprite_index = sprBullet1
	image_speed = .9
	on_step = muzzle_step
	on_draw = muzzle_draw
	image_yscale = .33
	image_xscale = .66
	image_angle = other.gunangle
}

mod_script_call("mod", "defpack tools", "shell_yeah", right * 90, 40, 2 + random(2), c_yellow);

with mod_script_call("mod", "defhitscan", "create_hitscan_bullet", x + lengthdir_x(12, gunangle), y + lengthdir_y(12, gunangle)){
		direction = other.gunangle + random_range(-4, 4) * other.accuracy;
		image_angle = direction;
		creator = other
		team = other.team
		damage += 1;
		force += 4;
}

#define weapon_sprt
return global.sprSubata
#define weapon_text
return "PEST CONTROL"
#define nts_weapon_examine
return{
    "d": "A weapon favoured by those who hunt bugs and mine minerals for a living. ",
}

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);

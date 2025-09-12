#define init
global.sprSubata = sprite_add_weapon("sprites/weapons/sprSubata.png",4,3)
global.c_spitz = make_color_rgb(0, 255, 199);
global.c_spitz_dark = make_color_rgb(0, 186, 164);

#define weapon_name
return "SPITZ RIFLE"
// #define weapon_iris
// return "x subata"
#define weapon_type
return 1
#define weapon_cost
return 6
#define weapon_area
return 6;
#define weapon_load
return 18
#define weapon_swap
return sndSwapPistol
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt
return global.sprSubata
#define weapon_text
return "PEST CONTROL"
#define nts_weapon_examine
return{
    "d": "A weapon favoured by those who hunt bugs and mine minerals for a living. ",
}

/*Todo
	Try lower damage, piercing (simple)
	On hit, split into two (inherit lasthit), split angle depends on burst round
	On hit, mark for piercing. All further bullets will pierce, for like 5 frames. Lower damage slightly.
*/

#define weapon_fire
	mod_script_call("mod", "defburst", "burst", 6, .5, self, script_ref_create(fire_burst))

#define fire_burst(_burst)
	if (_burst.fired_rounds == 0) {
		_burst.pitch = random_range(1, 1.4)
	}
	var _p = _burst.pitch * random_range(.9, 1.1),
		vol = .7;
	sound_play_pitchvol(sndHyperRifle, 1.6 * _p, .6 * vol)
	//sound_play_pitchvol(sndDoubleMinigun,   .4 * _p, .6 * vol)
	sound_play_pitchvol(sndShotgun, 2 * _p, vol)
	//sound_play_pitchvol(sndMinigun, 1, vol)
	if (_burst.ammo == 0) {
		sound_play_gun(sndClickBack, 0, 1)
		sound_stop(sndClickBack)
		weapon_post(5, 10, 0)
	}
	else weapon_post(1, 10, 0)
	
	var angle = gunangle + random_range(-30, 30) * max(0, accuracy - 1);

	with instance_create(x + lengthdir_x(16, gunangle), y + lengthdir_y(16, gunangle), CustomObject) {
		depth = -1
		on_step = muzzle_step
		on_draw = muzzle_draw
		image_yscale = .5
		image_angle = other.gunangle;
		sprite_index = mod_variable_get("mod", "defpack tools", "spr").SplitShell;
	}

	mod_script_call("mod", "defpack tools", "shell_yeah", 90, 40, 2 + random(2), c_yellow);

	var c = instance_is(self, FireCont) ? creator : self;
	with spitz_bullet_create(x + lengthdir_x(12, gunangle) + random_range(-2, 2), y + lengthdir_y(12, gunangle) + random_range(-2, 2)) {
		direction = angle;
		image_angle = direction;
		projectile_init(other.team, c)
		damage = 4
		trailsize = .5
	}

#define muzzle_step
if image_index >= 1 {instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);

#define spitz_bullet_create(x, y)
	with mod_script_call("mod", "defhitscan", "create_hitscan_bullet", x, y) {
		hitscanLength = 80 + random(40);
		trailsize = 1;
		//damage += 1;
		damage -= 1;
		
		trailcolor = [merge_color(global.c_spitz, c_green, random(.2)), c_white, global.c_spitz_dark, merge_color(global.c_spitz_dark, c_black, .4)];
		
		can_split = true;
		on_destroy = spitz_destroy;
		
		spr_dead = mod_variable_get("mod", "defpack tools", "spr").SplitShellDisappear;
		
		return self;
	}
	
#define spitz_destroy(original_destroy)
	with instance_create(x, y, BulletHit) {
		sprite_index = other.spr_dead;
		// image_blend = global.c_spitz;
		image_xscale = .5;
		image_yscale = .5;
		image_speed *= 2;
		image_angle = other.image_angle;
	}
	sound_play_hit(sndHitWall, .2)
	if !hashitwall && can_split {
		for (var i = -1; i <= 1; i += 2) {
			with spitz_bullet_create(x, y) {
				direction = other.direction + i * 15;
				image_angle = direction;
				creator = other.creator;
				team = other.team;
				lasthit = other.lasthit;
				can_split = false;
				
				recycle_chance /= 2;
				if other.recycle_amount == 0 {
					recycle_amount = 0
				}
			}
		}
		can_split = false;
	}

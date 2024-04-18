#define init
global.sprSubata = sprite_add_weapon("sprites/weapons/sprSubata.png",4,3)

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

#define burst_create(_x, _y, _rounds, _delay, _creator, _script)
	with instance_create(_x, _y, CustomObject) {
		ammo = _rounds
		delay = _delay
		creator = _creator
		fire_script = _script
		
		reload = 0
		fired_rounds = 0
		on_step = script_ref_create(burst_step)
		
		burst_step()
	}

#define burst_step
	if instance_exists(creator) {
		if reload > 0 {
			reload -= current_time_scale
		}
		else while reload <= 0 {
			reload += delay
			ammo -= 1;
			with creator {
				mod_script_call(other.fire_script[0], other.fire_script[1], other.fire_script[2], other)
			}
			fired_rounds += 1
			if ammo <= 0 {
				instance_destroy()
				exit
			}
		}
	}
	else {
		instance_destroy()
	}

#define weapon_fire
	burst_create(x, y, 6, .5, self, script_ref_create(fire_burst))

#define fire_burst(_burst)
	if (_burst.fired_rounds == 0) {
		_burst.pitch = random_range(1, 1.4)
	}
	var _p = _burst.pitch * random_range(.9, 1.1),
		vol = .8;
	sound_play_pitchvol(sndHyperRifle, 1.6 * _p, .6 * vol)
	//sound_play_pitchvol(sndDoubleMinigun,   .4 * _p, .6 * vol)
	sound_play_pitchvol(sndShotgun, 2 * _p, vol)
	sound_play_pitchvol(sndMinigun, 1, vol)
	if (_burst.ammo == 0) {
		sound_play_gun(sndClickBack, 0, 1)
		sound_stop(sndClickBack)
		weapon_post(5, 10, 0)
	}
	else weapon_post(1, 10, 0)
	

	with instance_create(x + lengthdir_x(16, gunangle), y + lengthdir_y(16, gunangle), CustomObject) {
		depth = -1
		sprite_index = sprBullet1
		on_step = muzzle_step
		on_draw = muzzle_draw
		image_yscale = .5
		image_angle = other.gunangle
	}

	mod_script_call("mod", "defpack tools", "shell_yeah", 90, 40, 2 + random(2), c_yellow);

	var c = instance_is(self, FireCont) ? creator : self;
	with mod_script_call("mod", "defhitscan", "create_hitscan_bullet", x + lengthdir_x(12, gunangle) + random_range(-2, 2), y + lengthdir_y(12, gunangle) + random_range(-2, 2)) {
		hitscanLength = 80 + random(40);
		direction = other.gunangle;
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

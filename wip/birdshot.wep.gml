#define init

#define weapon_name
return "BIRDSHOT"

#define weapon_type
return 2;

#define weapon_cost
return 1;

#define weapon_area
return 4;

#define weapon_load
return 16;

#define weapon_swap
return sndSwapShotgun;

#define weapon_auto
return false;

#define weapon_sprt
return sprShotgun;

#define weapon_text
return "BIRDSHOT HAS A STACKING DAMAGE BONUS";

#define weapon_fire
	var c = instance_is(self, FireCont) && "creator" in self ? creator : self;
	sound_play_pitchvol(sndHyperSlugger, 1.3 * random_range(.8, 1.2), .7)
	sound_play_gun(sndShotgun, .2, .8)
	weapon_post(6, 10, 5)
	repeat(6) {
		with birdshot_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle)) {
			var ang = random_range(-4, 4);
			ang += (random(random(25))) * sign(ang)
			motion_set(other.gunangle + ang * other.accuracy, 8)
			image_angle = direction
			projectile_init(other.team, c)
		}
	}


#define birdshot_create(x, y)
	return mod_script_call("mod", "defhitscan", "altshell_create", x, y)

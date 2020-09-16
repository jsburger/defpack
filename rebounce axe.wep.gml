#define init
global.sprOtherSword = sprite_add_weapon("sprites/weapons/sprRebounceAxe.png", 3, 7);

#define weapon_name
return "REBOUNCE AXE"

#define weapon_sprt
return global.sprOtherSword;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 47;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapSword;

#define weapon_area
return 9;

#define weapon_text
return choose("BE BRAVE", "STRIKE AGAIN");

#define weapon_melee
return 1

#define weapon_fire
	var _p = random_range(.8, 1.2);
	sound_play_pitch(sndChickenSword, .8 * _p)
	sound_play_pitch(sndShovel, .7 * _p)
	sound_play_pitch(sndHitMetal, .5 *_p)
	sound_play_pitch(sndHammer, .8 * _p)
	
	var _l = skill_get(mut_long_arms),
		_c = instance_is(self, FireCont) ? creator : self;
		
	weapon_post(8, -8, 60)
	wepangle = -wepangle
	
	motion_add(other.gunangle, 5)
	
	with instance_create(x + lengthdir_x(20 * _l, gunangle), y + lengthdir_y(20 * _l, gunangle), CustomSlash) {
		name = "RebounceSlash"
		motion_add(other.gunangle, 2 + (_l*2))
		image_speed = .5
		image_angle = direction
		projectile_init(other.team, _c)
		origin = other
		//steroids support baby
		hand = 0
		if "race_id" in _c {
			//1 if steroids is using active
			hand = other.specfiring && _c.race_id == char_steroids
		}
		sprite_index = sprHeavySlash
		mask_index = mskSlash
		damage = 12
		force = 40
		on_anim = s_anim
		on_hit  = s_hit
	}

#define s_anim
	instance_destroy()

#define wep_get(w)
	return is_object(w) ? w.wep : w;

#define s_hit
	if projectile_canhit_melee(other) {
		projectile_hit(other, damage, force, direction)
		
		var _p = random_range(.8, 1.2);
		sound_play_pitchvol(sndImpWristHit, .5 * _p, 2)
		sound_play_pitchvol(sndHitMetal, .6 * _p, 2)
		//this is for playing multiple sounds with the sound_play_gun fade effect intact
		sound_play_gun(sndEmpty, 1, .4)
		sound_stop(sndEmpty)
		
		view_shake_at(x, y, min(other.size, 3) * 4)
		sleep(min(other.size, 4) * 25)
		
		if instance_exists(origin) {
			if instance_is(origin, FireCont) {
				origin.reload *= .3
			}
			//very important to check for not being firecont, instead of being a player, opens up more options for shenanigans
			else {
				//in primary slot, in secondary slot, both
				var _p = wep_get(creator.wep) == mod_current,
					_s = wep_get(creator.bwep) == mod_current,
					_b = _p and _s;
				//in mainhand
				if _p or (_b and hand == 0) {
					//dont need to round because decimal reloads are fine
					creator.reload *= .3
				}
				if _s or (_b and hand == 1) {
					creator.breload *= .3
				}
				creator.gunshine = 8
			}
		}
		repeat(12) with instance_create(other.x, other.y, Dust) {
			motion_add(other.direction + random_range(-70, 70), random_range(4, 6))
		}
	}

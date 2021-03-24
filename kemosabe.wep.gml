#define init
	global.sprKemosabe    = sprite_add_weapon("sprites/weapons/sprKemosabe.png", 3, 2);
	global.sprLuckyBullet = sprite_add("sprites/projectiles/sprCritBullet.png",2,11,11)
	global.sprLuckyBulletBounce = sprite_add("sprites/projectiles/sprCritBulletBounce.png", 2, 6, 8)
	global.sprMagazine    = sprite_add("sprites/other/sprKemosabeMag.png", 1, 2, 3)
#define weapon_name
return "KEMOSABE";

#define weapon_sprt
return global.sprKemosabe;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 3;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 6;

#define nts_weapon_examine
return{
    "d": "The perfect fit for organized crime. ",
}

#define weapon_text
return choose("SO CLEAN FOR#SUCH DIRTY WORK", "LITTLE FRIEND");

#define weapon_fire
	weapon_post(5, -5, 5)
	sleep(10)
	var _pitch = random_range(.8, 1.2);
	sound_play_pitch(sndPistol, .8 * _pitch)
	sound_play_pitch(sndSnowTankShoot, 2 * _pitch)
	sound_play_pitch(sndPopgun, 1.5 * _pitch)
	sound_play_pitch(sndMinigun, .7 * _pitch)
	with instance_create(x, y, Shell) {
		motion_add(other.gunangle + other.right * 100 + random_range(-25, 25), 2 + random(3))
	}
	with critbullet_create(x, y) {
		motion_set(other.gunangle + random_range(-11, 11) * other.accuracy, 18)
		image_angle = direction
		projectile_init(other.team, instance_is(other, FireCont) ? other.creator : other)
	}

#define critbullet_create(x, y)
	with mod_script_call_nc("mod", "defpack tools", "create_bullet", x, y) {
		name = "CritBullet"
		sprite_index = skill_get("excitedneurons") ? global.sprLuckyBulletBounce : global.sprLuckyBullet
		spr_dead = sprEnemyBulletHit
		bounce_color = c_red

		force = 7
		on_hit = kemosabe_hit

		return self
	}

#define kemosabe_hit
	var _damage = damage;
	if irandom(13-(skill_get(mut_lucky_shot)*5)) = 0{
	    _damage = (damage + 1) * 3
	    mod_script_call("mod", "defpack tools", "crit")
	}
	mod_script_call_self("mod", "defpack tools", "recycle_gland_roll")
	projectile_hit(other, _damage, force, direction)
	instance_destroy()

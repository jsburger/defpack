// this mod is a subset of defpack tools to split up the content and allow for more streamlined development
// consider any bullet scripts in defpack tools deprecated, as it will only redirect to this file's scripts

/* File Structure, ... means to build from here, things included in parenthesis can be selected and ctrl + f'd to skip to
	Init
		Pre-init
		Sprite loading
		...
	Macros
	Generic Scripts, generally linking to defpack tools
	General Bullet Scripts, things like recycle gland rolling
	Basic Bullets (create_bullet)
		Generic events
		Basic Iris bullets
	
	Heavy Bullets (create_heavy_bullet)
		Heavy Iris bullets

*/
#macro spr global.spr
#macro msk global.spr.msk

#define init
	spr = {}
	msk = {}

	// Wait five seconds for Defpack Tools to show up, abort loading otherwise
	var n = 0, l = 150;
	repeat(l) {
		n += 1
		if mod_exists("mod", "defpack tools") break
		else wait(1)
	}
	if n == l trace_color("Couldn't find defpack tools, please load that!", c_yellow)
	exit
	spr = mod_variable_get("mod", "defpack tools", "spr");
	
	var i = "../sprites/projectiles/";
	
	with spr {
		
		//Fire Bullets
		FireBullet         = sprite_add(i + "iris/fire/sprFireBullet.png",    2, 8, 8);
		FireBulletHit      = sprite_add(i + "iris/fire/sprFireBulletHit.png", 4, 8, 8);
		HeavyFireBullet    = sprite_add(i + "iris/fire/sprHeavyFireBullet.png",    2, 12, 12);
		HeavyFireBulletHit = sprite_add(i + "iris/fire/sprHeavyFireBulletHit.png", 4, 12, 12);

		//Bouncers
		HeavyBouncerBullet = sprite_add(i + "iris/bouncer/sprHeavyBouncerBullet.png", 2, 12, 12);

		//Toxic Bullets
		ToxicBullet         = sprite_add(i + "iris/pest/sprPestBullet.png",    2, 8, 8);
		ToxicBulletHit      = sprite_add(i + "iris/pest/sprPestBulletHit.png", 4, 8, 8);
		HeavyToxicBullet    = sprite_add(i + "iris/pest/sprHeavyPestBullet.png",    2, 12, 12);
		HeavyToxicBulletHit = sprite_add(i + "iris/pest/sprHeavyPestBulletHit.png", 4, 12, 12);

		//Lightning Bullets
		LightningBullet         = sprite_add(i + "iris/thunder/sprThunderBullet.png",    2, 8, 8);
		LightningBulletUpg      = sprite_add(i + "iris/thunder/sprThunderBulletUpg.png", 2, 8, 8);
		LightningBulletHit      = sprite_add(i + "iris/thunder/sprThunderBulletHit.png", 4, 8, 8);
		HeavyLightningBullet    = sprite_add(i + "iris/thunder/sprHeavyThunderBullet.png",    2, 12, 12);
		HeavyLightningBulletUpg = sprite_add(i + "iris/thunder/sprHeavyThunderBulletUpg.png", 2, 12, 12);
		HeavyLightningBulletHit = sprite_add(i + "iris/thunder/sprHeavyThunderBulletHit.png", 4, 12, 12);

		//Psy Bullets
		PsyBullet         = sprite_add  (i + "iris/psy/sprPsyBullet.png",    2, 8, 8);
		PsyBulletHit      = sprite_add  (i + "iris/psy/sprPsyBulletHit.png", 4, 8, 8);
		msk.PsyBullet     = sprite_add_p(i + "iris/psy/mskPsyBullet.png",    0, 7, 3);
		HeavyPsyBullet    = sprite_add  (i + "iris/psy/sprHeavyPsyBullet.png",    2, 12, 12);
		HeavyPsyBulletHit = sprite_add  (i + "iris/psy/sprHeavyPsyBulletHit.png", 4, 12, 12);

		//Dark Bullets
		DarkBullet     = sprite_add  (i + "sprBlackBullet.png",    2, 8, 8);
		DarkBulletHit  = sprite_add  (i + "sprBlackBulletHit.png", 4, 8, 8);
		msk.DarkBullet = sprite_add_p(i + "mskBlackBullet.png",    0, 3, 5);

		//Light Bullets
		LightBullet    = sprite_add(i + "sprWhiteBullet.png",    2, 8, 8);
		LightBulletHit = sprite_add(i + "sprWhiteBulletHit.png", 4, 8, 8);

	}
	
#macro current_frame_active (current_frame % 1 < current_time_scale)

#macro default_bloom {
        xscale : 2,
        yscale : 2,
        alpha : .1
    };

//notes on excited neurons
// bullets retain their damage
// bouncers get 2 extra bounces
// bullets lose speed when transformed ( set to 11, from 16 default )
// all bullets gain 1 damage on bounce
#macro nuerons skill_get("excitedneurons")


#define chance(percentage)
return random(100) <= percentage * current_time_scale

#define chance_raw(percentage)
return random(100) <= percentage


#define recycle_gland_roll
/// recycle_gland_roll(_chance = 60)
var _chance = argument_count > 0 ? argument[0] : 60;
	
	var _gland = skill_get(mut_recycle_gland) + (10 * skill_get("recycleglandx10"));
	if chance_raw(_chance * _gland) {
		if recycle_amount != 0 {
			instance_create(x, y, RecycleGland)
			sound_play(sndRecGlandProc)
			var num = recycle_amount * _gland
			with creator if instance_is(self, Player) {
				ammo[1] = min(ammo[1] + num, typ_amax[1])
			}
		}
	}


#define create_bullet(x, y)
with instance_create(x, y, CustomProjectile){
    name = "Bullet"

    sprite_index = sprBullet1
    spr_dead = sprBulletHit
    mask_index = mskBullet1
    image_speed = 1

    defbloom = {
        xscale : 2,
        yscale : 2,
        alpha : .1
    }

    recycle_amount = 1
    force = 8
    damage = 3
    typ = 1

    on_anim = bullet_anim
    on_wall = bullet_wall
    on_hit = bullet_hit
    on_destroy = bullet_destroy

    return id
}

#define bullet_hit
	projectile_hit(other, damage, force, direction);
	recycle_gland_roll()
	instance_destroy()
	
#define bullet_destroy
	with instance_create(x, y, BulletHit) sprite_index = other.spr_dead

#define bullet_anim
	image_index = 1
	image_speed = 0

#define bullet_wall
	instance_create(x, y, Dust)
	sound_play_hit(sndHitWall, .2)
	instance_destroy()

#define create_heavy_bullet(x, y)
with create_bullet(x, y){
    name = "Heavy Bullet"

    sprite_index = sprHeavyBullet
    spr_dead = sprHeavyBulletHit
    mask_index = mskHeavyBullet

    recycle_amount = 2
    force = 12
    damage = 7

    return id
}
	
#define create_heavy_bouncer_bullet
with create_heavy_bullet(x, y){
    name = "Heavy Bouncer Bullet"
    sprite_index = spr.HeavyBouncerBullet
    damage = 9
    turn = choose(-1, 1)
    bounce = 2

    on_step = bouncer_step
    on_wall = heavy_bouncer_wall

    return id
}


#define bouncer_step
image_angle += 6*turn * current_time_scale

#define heavy_bouncer_wall
if bounce > 0{
    bounce--
    instance_create(x, y, Dust)
    sound_play_pitchvol(sndBouncerBounce, random_range(.7, .8), .7)
    move_bounce_solid(false)
    direction += random_range(6, 6)
}
else instance_destroy()

	
	
	
	
	
	
	
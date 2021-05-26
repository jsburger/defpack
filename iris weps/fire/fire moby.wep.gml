#define init
global.sprFireMoby = sprite_add_weapon("../../sprites/weapons/iris/fire/sprFireMoby.png", 8, 3);
global.FireBullet = sprite_add("../../sprites/projectiles/iris/fire/sprFireBullet.png", 3, 8, 8);

#macro maxchrg 18

#define weapon_name
return "FIRE MOBY";

#define weapon_sprt
return global.sprFireMoby;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load(w)
//Should shoot 6 times a frame at max charge
if is_object(w) return 4-((w.charge/maxchrg)*3.834)
return 4;

#define weapon_cost(w)
if is_object(w) && w.charge > 14 && (!instance_is(self,Player) || ammo[1] > 1) return irandom(1)
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "BRIMSTONE";

#define charge_base
return {
    maxcharge : maxchrg - 1,
    charge : 0,
    style : 0,
    width : 12,
    power : 1
}

#define weapon_fire(w)
if !is_object(w){
    w = {
        wep: w,
        charge : 1,
        persist : 0,
        canbloom : 1,
        defcharge : charge_base()
    }
    wep = w
}
else{
    var q = lq_defget(w, "charge", 1)
    w.charge = min(q + 1.8/q, maxchrg)
    w.persist = 10
}

mod_script_call("mod", "defpack tools", "shell_yeah", 100, 40, 3 + random(3), c_red);

with mod_script_call("mod", "defhitscan", "create_fire_hitscan_bullet", x + hspeed + lengthdir_x(8, gunangle), y + vspeed + lengthdir_y(8, gunangle)){
	motion_set(other.gunangle + random_range(-10, 10)*other.accuracy*sqr(sqrt(w.charge)/2), 5)
	image_angle = direction
	projectile_init(other.team, other)
}


if lq_defget(w, "canbloom", 1){
    with instance_create(x+lengthdir_x(20 - wkick,gunangle) + hspeed,y+ lengthdir_y(20 - wkick,gunangle) + vspeed,CustomObject){
    	depth = -1
    	sprite_index = global.FireBullet
    	image_speed = .8
    	on_step = muzzle_step
    	on_draw = muzzle_draw
    	image_yscale = .5
    	image_angle = other.gunangle
    }
    w.canbloom = 0
    weapon_post(5+random_range(w.charge * .06,-w.charge * .06), (w.charge >= maxchrg) ? -3 - irandom(3): -3, 2 + w.charge/maxchrg/2)
    sound_play_pitch(sndTripleMachinegun,(.7 + w.charge * .02)*random_range(.95,1.05))
    sound_play(sndMinigun)
    sound_play_gun(sndClickBack, 0, 1 - (w.charge/(maxchrg*1.5)))
    sound_play_pitch(sndIncinerator,(.7 + w.charge * .02)*random_range(.95,1.05))
    sound_play_pitch(sndDoubleFireShotgun,(1.3 + w.charge * .02)*random_range(.95,1.05))
    sound_stop(sndClickBack)

    if w.charge > maxchrg - 2 {
	    if !irandom(1 + (maxchrg - w.charge)) {
	    	with instance_create(x, y, Flame) {
	    		image_xscale = random(.5) + .3
	    		image_yscale = image_xscale
	    		motion_set(other.gunangle + random_range(-20, 20), 4 + random(4))
	    		friction = .4
	    		gravity = -.2
	    		projectile_init(other.team, other)
	    	}
	    }
    }

}

#define step(w)
	mod_script_call_self("weapon", "moby", "step", w)

#define muzzle_step
if image_index+.01 >= 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);

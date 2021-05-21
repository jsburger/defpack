#define init
global.sprBouncerMoby = sprite_add_weapon("../../sprites/weapons/iris/bouncer/sprBouncerMoby.png", 9, 3);
global.yellow = merge_color(c_yellow, c_white, .4)

#macro maxchrg 28

#define weapon_name
return "BOUNCER MOBY";

#define weapon_sprt
return global.sprBouncerMoby;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load(w)
//Four shots a frame at max
if is_object(w) return 6-((w.charge/maxchrg) * 5.75)
return 6;

#define weapon_cost(w)
if is_object(w) && w.charge > 24 && (!instance_is(self,Player) || ammo[1] > 1) return irandom(1)
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "RUBBER HELL";

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
    w.charge = min(q + 2/q, maxchrg)
    w.persist = 15
}

with instance_create(x,y,Shell){motion_add(other.gunangle+other.right*100+random(80)-40,3+random(3))}

with mod_script_call("mod", "defhitscan", "create_bouncer_hitscan_bullet", x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle)){
	motion_set(other.gunangle + random_range(-25,25)*other.accuracy*sqrt(w.charge)/6, 5)
	image_angle = direction
	projectile_init(other.team, other)
}


if lq_defget(w, "canbloom", 1){
    with instance_create(x+lengthdir_x(20 - wkick,gunangle),y+ lengthdir_y(20 - wkick,gunangle),CustomObject){
    	depth = -1
    	sprite_index = sprBullet1
    	image_speed = .8
    	on_step = muzzle_step
    	on_draw = muzzle_draw
    	image_yscale = .5
    	image_angle = other.gunangle
    }
    w.canbloom = 0
    weapon_post(5+random_range(w.charge * .04,-w.charge * .04),-3,2)
    sound_play_pitch(sndTripleMachinegun,(.7 + w.charge * .02)*random_range(.95,1.05))
    sound_play_pitch(sndBouncerShotgun,(.5 + w.charge * .015)*random_range(.95,1.05))
    sound_play(sndMinigun)
    sound_play_gun(sndClickBack, 0, 1 - (w.charge/(maxchrg*1.5)))
    sound_stop(sndClickBack)
}

#define step(w)
	mod_script_call_self("weapon", "moby", "step", w)


#define muzzle_step
if image_index+.01 >= 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);

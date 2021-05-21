#define init
global.sprGammaMoby = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprHorrorMobyOn.png", 8, 3);
global.Bullet = sprite_add("../../sprites/projectiles/iris/horror/sprGammaBullet.png", 2, 8, 8);

#macro maxchrg 24

#define weapon_name
return "GAMMA MOBY";

#define weapon_sprt
return global.sprGammaMoby;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load(w)
//Shoots 4 times a frame at max (nobody will notice its slower because it shoots 2 bullets at once)
if is_object(w) return 5-((w.charge/maxchrg) * 4.75)
return 5;

#define weapon_cost(w)
if is_object(w) && w.charge > 20 && (!instance_is(self,Player) || ammo[1] > 1) return irandom(1)
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "AN HOMAGE TO THE @dTHRONE";

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

repeat(2){
    mod_script_call("mod", "defpack tools", "shell_yeah", 100, 40, 3 + random(3), c_lime);
}

//Focus fire
with mod_script_call("mod", "defhitscan", "create_gamma_hitscan_bullet", x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle)){
	motion_set(other.gunangle + random_range(-20, 20) * other.accuracy * sqrt(w.charge)/6, 8)
    image_angle = direction
    projectile_init(other.team, other)
}
//Secondary Spam
with mod_script_call("mod", "defhitscan", "create_gamma_hitscan_bullet", x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle)){
    motion_set(other.gunangle + random_range(-20, 20) * other.accuracy * sqr(sqrt(w.charge)/3), 8)
    image_angle = direction
    projectile_init(other.team, other)
}

if lq_defget(w, "canbloom", 1){
    with instance_create(x+lengthdir_x(20 - wkick,gunangle) + hspeed,y+ lengthdir_y(20 - wkick,gunangle) + vspeed,CustomObject){
    	depth = -1
    	sprite_index = global.Bullet
    	image_speed = .8
    	on_step = muzzle_step
    	on_draw = muzzle_draw
    	image_yscale = .5
    	image_angle = other.gunangle
    }
    w.canbloom = 0
    weapon_post(5+random_range(w.charge * .04,-w.charge * .04), (w.charge >= maxchrg) ? -3 - irandom(3): -3, 2 + w.charge/maxchrg/2)
    sound_play_pitch(sndTripleMachinegun,(.8 + w.charge * .02)*random_range(.95,1.05))
    sound_play_pitch(sndUltraPistol,(.7 + w.charge * .04)*random_range(.95,1.05))sound_play_pitch(sndUltraPistol,(.7 + w.charge * .04)*random_range(.95,1.05))
    sound_play_pitch(sndUltraShotgun,(1.2 + w.charge * .02)*random_range(.95,1.05))
    sound_play_pitch(sndDoubleMinigun,(1.8 + w.charge * .02)*random_range(.95,1.05))
    sound_play(sndMinigun)
    sound_play_gun(sndClickBack, 0, 1 - (w.charge/(maxchrg*1.5)))
    sound_stop(sndClickBack)
    
    if w.charge > maxchrg - 2 {
	    if !irandom(2 + (maxchrg - w.charge)) {
	        var _l = random_range(8, 32), _a = gunangle + random_range(-30, 30);
	    	with instance_create(x + lengthdir_x(_l, _a), y + lengthdir_y(_l, _a), LightningHit) {
	    		image_xscale = random(.4) + .6
	    		image_yscale = image_xscale
	    		image_blend = c_yellow
	    		image_index = 1
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

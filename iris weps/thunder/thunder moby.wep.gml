#define init
global.sprThunderMoby = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprThunderMoby.png", 8, 3);
global.Bullet = sprite_add("../../sprites/projectiles/iris/thunder/sprThunderBullet.png", 2, 8, 8);

#macro maxchrg 26

#define weapon_name
return "THUNDER MOBY";

#define weapon_sprt
return global.sprThunderMoby;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load(w)
//Shoots 4 at max charge
if is_object(w) return 7 - ((w.charge/maxchrg) * 6.75)
return 7;

#define weapon_cost(w)
if is_object(w) && w.charge > 17 && (!instance_is(self,Player) || ammo[1] > 1) {
    var i = 0
    repeat(3) {
        i += irandom(1)
    }
    if "ammo" in self return min(i, ammo[1])
    return i
}
return 3;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "ROLLING THUNDER";

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
    //slower charge
    w.charge = min(q + 1.5/q, maxchrg)
    //longer persist time
    w.persist = 30
}

var flip = "wepflip" in self ? wepflip : choose(-1, 1)

if fork() {
    for (var i = -1; i <= 1; i+=1) {
        mod_script_call("mod", "defpack tools", "shell_yeah", 100, 40, 3 + random(3), c_navy);
        
        with mod_script_call("mod", "defhitscan", "create_thunder_hitscan_bullet", x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle)) {
            motion_set(other.gunangle + (((15 * (1 + w.charge/maxchrg)*.8)) * (i * flip) + random_range(-10, 10)) * other.accuracy * sqrt(w.charge)/6, 8)
            image_angle = direction
          	projectile_init(other.team, other)
        }
        wait(2 - i)
        if !instance_exists(self) exit

    }
    exit
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
    sound_play_pitch(sndTripleMachinegun,(.7 + w.charge * .02)*random_range(.95,1.05))
    sound_play_pitch(sndLightningShotgun,(1.3 + w.charge * .02)*random_range(.95,1.05))
    sound_play_pitch(sndLightningCannon,(.7 + w.charge * .02)*random_range(.95,1.05))
    if skill_get(mut_laser_brain) > 0{
      sound_play_pitch(sndLightningPistolUpg,(.7 + w.charge * .02)*random_range(.95,1.05))
      sound_play_pitch(sndGammaGutsKill,(1.2 + w.charge * .015)*random_range(.95,1.05))
    }else{
      sound_play_pitch(sndLightningPistol,(.7 + w.charge * .02)*random_range(.95,1.05))
    }
    sound_play(sndMinigun)
    sound_play_gun(sndClickBack, 0, 1 - (w.charge/(maxchrg*1.5)))
    sound_stop(sndClickBack)
    
    if w.charge > maxchrg - 5 {
	    if !irandom(1 + (maxchrg - w.charge)) {
	        var _l = random_range(8, 50), _a = gunangle + random_range(-30, 30);
	    	with instance_create(x + lengthdir_x(_l, _a), y + lengthdir_y(_l, _a), LightningHit) {
	    		image_xscale = random(.4) + .6
	    		image_yscale = image_xscale
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

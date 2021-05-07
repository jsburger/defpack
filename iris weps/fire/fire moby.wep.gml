#define init
global.sprFireMoby = sprite_add_weapon("../../sprites/weapons/iris/fire/sprFireMoby.png", 9, 4);
global.FireBullet = sprite_add("../../sprites/projectiles/iris/fire/sprFireBullet.png", 2, 8, 8);

#macro maxchrg 17

#define weapon_name
return "FIRE MOBY";

#define weapon_sprt
return global.sprFireMoby;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load(w)
if is_object(w) return 3.35-w.charge/5
return 3.35;

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
    w.charge = min(q + 2.2/q, maxchrg)
    w.persist = 10
}

mod_script_call("mod", "defpack tools", "shell_yeah", other.gunangle+other.right*100+random(80)-40, 40, 3 + random(3), c_red);

// with create_bullet(x+lengthdir_x(20,gunangle),y+ lengthdir_y(20,gunangle)){
// 	on_destroy = shell_destroy
// 	direction = other.gunangle + random_range(-20,20)*other.accuracy*sqrt(w.charge)/6;
// 	olddirection = direction
// 	image_angle = direction;
// 	creator = other
// 	team = other.team
// }

with mod_script_call("mod", "defhitscan", "create_fire_hitscan_bullet", x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle)){
	motion_set(other.gunangle + random_range(-42,42)*other.accuracy*sqrt(w.charge)/6, 5)
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
    weapon_post(5+random_range(w.charge * .04,-w.charge * .04),-3,2)
    sound_play_pitch(sndTripleMachinegun,(.7 + w.charge * .02)*random_range(.95,1.05))
    sound_play(sndMinigun)
    sound_play_gun(sndClickBack, 0, 1 - (w.charge/(maxchrg*1.5)))
    sound_play_pitch(sndIncinerator,(.7 + w.charge * .02)*random_range(.95,1.05))
    sound_play_pitch(sndDoubleFireShotgun,(1.3 + w.charge * .02)*random_range(.95,1.05))
    sound_stop(sndClickBack)
}

#define step(w)
if w && is_object(wep) && wep.wep = mod_current goodstep(wep)
else if !w && is_object(bwep) && bwep.wep = mod_current goodstep(bwep)

if instance_number(Shell) > 100{
    var q = instances_matching(Shell,"speed",0)
    var l = array_length(q)
    var r = random_range(11, l)
    if l > 10 repeat(10){
        instance_delete(q[(--r)])
    }
}
if instance_number(BulletHit) > 100{
    var q = instances_matching(BulletHit,"speed",0)
    var l = array_length(q)
    var r = random_range(11, l)
    if l > 10 repeat(10){
        instance_delete(q[(--r)])
    }
}


#define goodstep(w)
w.canbloom = 1
if w.persist > 0{
    w.persist-= current_time_scale
}
else if w.charge > 1{
    if random(100) <= 50 * current_time_scale with instance_create(x+lengthdir_x(16,gunangle),y+lengthdir_y(16,gunangle),Smoke) {vspeed -= random(1); image_xscale/=2;image_yscale/=2; hspeed/=2}
    w.charge = max (w.charge - current_time_scale*.25, 1)
}
if lq_get(w, "defcharge") == undefined{
    w.defcharge = charge_base()
}
w.defcharge.charge = w.charge - 1

#define muzzle_step
if image_index+.01 >= 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);

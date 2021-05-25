#define init
global.sprMoby = sprite_add_weapon("sprites/weapons/sprMoby.png", 7, 2);
global.yellow = merge_color(c_yellow, c_white, .4)

#macro maxchrg 24

#define weapon_name
return "MOBY";

#define weapon_iris
return "x moby"

#define weapon_sprt
return global.sprMoby;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load(w)
//5 shots a frame at max
if is_object(w) return 5-w.charge/5
return 5;

#define weapon_cost(w)
if is_object(w) && w.charge > 20 && (!instance_is(self,Player) || ammo[1] > 1) return irandom(1)
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 14;

#define nts_weapon_examine
return{
    "d": "Ball bearings keep the barrel spinning for a bit after firing. ",
}


#define weapon_text
return "HEAVY OCEAN";

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


with create_hitscan_bullet(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle)) {
	motion_set(other.gunangle + random_range(-20, 20) * other.accuracy * sqrt(w.charge)/6, 8)
	image_angle = direction
	projectile_init(other.team, other)
}


if lq_defget(w, "canbloom", 1){
    with instance_create(x + hspeed +lengthdir_x(20 - wkick,gunangle),y + vspeed + lengthdir_y(20 - wkick,gunangle),CustomObject){
    	depth = -1
    	sprite_index = sprBullet1
    	image_speed = .8
    	on_step = muzzle_step
    	on_draw = muzzle_draw
    	image_yscale = .5
    	image_angle = other.gunangle
    }
    w.canbloom = 0
    weapon_post(5+random_range(w.charge * .04,-w.charge * .04), (w.charge >= maxchrg) ? -3 - irandom(3): -3, 2 + w.charge/maxchrg/2)
    sound_play_pitch(sndTripleMachinegun,(.7 + w.charge * .02)*random_range(.95,1.05))
    sound_play(sndMinigun)
    sound_play_gun(sndClickBack, 0, 1 - (w.charge/(maxchrg*1.5)))
    sound_stop(sndClickBack)
}

#define step(w)
if w && is_object(wep) goodstep(wep)
else if !w && is_object(bwep) goodstep(bwep)

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


#define create_hitscan_bullet(x, y)
return mod_script_call("mod", "defhitscan", "create_hitscan_bullet", x, y)

#define muzzle_step
if image_index+.01 >= 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);

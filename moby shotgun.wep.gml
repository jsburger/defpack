#define init
global.sprMobyShotgun = sprite_add_weapon("sprites/weapons/sprMobyShotgun.png", 4, 2);
global.yellow = merge_color(c_yellow, c_white, .4)

#macro maxchrg 16

#define weapon_name
return "MOBY SHOTGUN";

#define weapon_sprt
return global.sprMobyShotgun;

#define weapon_type
return 2;

#define weapon_auto
return true;

#define weapon_load(w)
if is_object(w) return 8 - round(w.charge/3.5)
return 8;

#define weapon_cost(w)
if is_object(w) && w.charge >= maxchrg && (!instance_is(self,Player) || ammo[2] > 1) return irandom(1)
return 1;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 12;

#define nts_weapon_examine
return{
    "d": "Ball bearings keep the barrel spinning for a bit after firing. ",
}


#define weapon_text
return "GIVE 'EM HELL";

#define charge_base
return {
    maxcharge : maxchrg,
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

repeat(7) with instance_create(x, y, w.charge/w.defcharge.maxcharge = 1 ? FlameShell : Bullet2){
  team = other.team
  creator = other
  var _a = 28 - w.charge * 1.35
  if w.charge/maxchrg = 1{_a = 6}
  motion_add(other.gunangle + random_range(-_a, _a) * other.accuracy, 10 + irandom(2) + 6 *w.charge/w.defcharge.maxcharge )
}

if lq_defget(w, "canbloom", 1){
    w.canbloom = 0
    w.charge += current_time_scale
    weapon_post(3 + w.charge /10,-1 - w.charge / 3,2)
    sound_play_pitch(sndQuadMachinegun,(.7 + w.charge * .02)*random_range(.95,1.05))
    sound_play_pitch(sndDoubleShotgun, .5 + w.charge / 35)
    sound_play_pitchvol(sndIncinerator, .8, w.charge >= maxchrg)
    sound_play_gun(sndClickBack, 0, 1 - (w.charge/(maxchrg*1.5)))
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

#define shell_destroy
instance_create(x,y,BulletHit)

#define muzzle_step
if image_index+.01 >= 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);

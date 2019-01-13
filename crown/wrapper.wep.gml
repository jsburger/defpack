#define init

#define weapon_name(w)
if is_object(w) return weapon_get_name(w.wrapped)
return "exchange wrapper"
#define weapon_type(w)
if is_object(w) return weapon_get_type(w.wrapped)
return 0
#define weapon_cost(w)
if is_object(w) return weapon_get_cost(w.wrapped)
return 0
#define weapon_area
return -1
#define weapon_load(w)
if is_object(w) return weapon_get_load(w.wrapped)
return 1
#define weapon_swap(w)
if is_object(w) return weapon_get_swap(w.wrapped)
return sndSwapHammer
#define weapon_auto(w)
if is_object(w) return weapon_get_auto(w.wrapped)
return 0
#define weapon_melee(w)
if is_object(w) return weapon_is_melee(w.wrapped)
return 0
#define weapon_laser_sight(w)
if is_object(w) return weapon_get_laser_sight(w.wrapped)
return 0
#define weapon_sprt(w)
if is_object(w) return weapon_get_sprite(w.wrapped)
return mskNone
#define weapon_text(w)
if is_object(w) return weapon_get_text(w.wrapped)
return "this aint right"
#define step(w)
if w && has_step(wep){
    mod_script_call_self("weapon", wep_find(wep), "step", w)
}
else if !w && has_step(bwep){
    mod_script_call_self("weapon", wep_find(wep), "step", w)
}

#define has_step(w)
if !is_object(w) return 0
if is_real(w.wrapped) return 0
else {
    var e = wep_find(w)
    return mod_script_exists("weapon", e, "step")
}

#define wep_find(w)
if is_object(w) return wep_find(w.wep)
return w
#define weapon_fire
if instance_is(self,Player) and is_object(wep){
    var w = wep, inf = infammo;
    wep = wep.wrapped
    infammo = -1
    player_fire()
    reload -= weapon_load(w)
    infammo = inf
    w.wrapped = wep
    wep = w
    if weapon_get_type(wep.wrapped) == 0 wep.meleeammo -= weapon_get_load(w.wep)
    if w.wep = 0 wep = 0
}
else{
    with instance_create(x,y,ConfettiBall){
        team = other.team
        creator = other
        motion_set(other.gunangle + random_range(-7,7), random_range(8,10))
        image_angle = direction
    }    
}
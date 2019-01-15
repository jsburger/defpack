#define init

#define weapon_name(w)
if is_object(w) return weapon_get_name(w.wrapped)
return "exchange wrapper"
#define weapon_type(w)
if is_object(w) return weapon_get_type(w.wrapped)
return 0
#define weapon_cost(w)
if is_object(w){
    if instance_is(self, Player) and (ammo[weapon_get_type(w)] >= weapon_get_cost(w.wrapped) and infammo = 0) return 0
    return weapon_get_cost(w.wrapped)
}
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
#define weapon_rads(w)
if is_object(w) return weapon_get_rads(w.wrapped)
return 0
#define weapon_sprt_hud(w)
if is_object(w) return weapon_get_sprt_hud(w.wrapped)
return mskNone
#define weapon_text(w)
if is_object(w) return weapon_get_text(w.wrapped)
return "this aint right"
#define weapon_wep(w)
return "wrapped"
#define step(w)
if w && has_step(wep){
    var e = wep
    var r = wep_find(e)
    wep = e.wrapped
    mod_script_call_self("weapon", r, "step", w)
    e.wrapped = wep
    wep = e
}
else if !w && has_step(bwep){
    var e = bwep
    var r = wep_find(e)
    bwep = e.wrapped
    mod_script_call_self("weapon", r, "step", w)
    e.wrapped = bwep
    bwep = e
}

#define has_step(w)
if !is_object(w) return 0
if is_real(w.wrapped) return 0
else {
    var e = wep_find(w)
    return mod_script_exists("weapon", e, "step")
}

#define wep_find(w)
if is_object(w){
    if w.wep = mod_current return wep_find(w.wrapped)
    return wep_find(w.wep)
}
return w

#define weapon_fire
if instance_is(self,Player) and is_object(wep){
    var w = wep
    wep = wep.wrapped
    player_fire()
    reload -= weapon_load(w)
    w.wrapped = wep
    wep = w
    if weapon_get_type(wep.wrapped) == 0 wep.meleeammo -= weapon_get_load(w.wrapped)
    if wep.wrapped = 0 wep = 0
}
else{
    with instance_create(x,y,ConfettiBall){
        team = other.team
        creator = other
        motion_set(other.gunangle + random_range(-7,7), random_range(8,10))
        image_angle = direction
    }    
}
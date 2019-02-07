#define init

#define race_name
return "GUN"

#define race_text
return "SHOOTS"

#define race_mapicon()
with player_find(argument0) if instance_is(wielder, WepPickup) return weapon_get_sprite(weapon)
return mskNone

#define create()
spr_idle = mskNone
spr_walk = mskNone
spr_hurt = mskNone
spr_dead = mskNone
snd_dead = -1
snd_hurt = -1
snd_wrld = -1
snd_cptn = -1
snd_thrn = -1
snd_chst = -1
snd_lowa = -1
snd_lowh = -1
snd_crwn = -1
snd_idpd = -1
snd_spch = -1
mask_index = mskNone
if instance_is(self, CustomObject) exit
weapon = wep
with instance_create(x,y,WepPickup){
    wep = {
        weapon = other.wep
        wep = "race"
        index = other.index
    } 
    view_object[other.index] = id
    other.wielder = id
}

#define step
with Player if is_object(wep){
    if lq_defget(wep, "index", -1) == other.index and wep.wep = "race"{
        view_object[wep.index] = id
        player_find(wep.index).wielder = id
    }
}
with Player if is_object(bwep){
    if lq_defget(bwep, "index", -1) == other.index and bwep.wep = "race"{
        view_object[bwep.index] = id
        player_find(bwep.index).wielder = id
    }
}

if instance_is(wielder, Player){
    var w = wielder
    ammo = array_clone(w.ammo)
    my_health = w.my_health
    view_object[wep.index] = w
}
with WepPickup if is_object(wep){
    if lq_defget(wep, "index", -1) == other.index and wep.wep = "race"{
        view_object[wep.index] = id
        player_find(wep.index).wielder = id
    }
}
if !instance_exists(wielder)
    my_health = 0
    
    
    
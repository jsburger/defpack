#define init
//admittedly its not as good as i thought itd be
//needs sounds and polish but its 5 am so im calling it here
//remind me to stop doing stupid code shit and just make the mod better


#define weapon_name
return "STAMPEDE"

#macro maxchrg 8

#define weapon_type
return 1
#define weapon_cost
return 5
#define weapon_area
return 12
#define weapon_load(w)
if is_object(w) return max(5, 10-power(w.charge/3, 2))
return 10;
#define weapon_swap
return sndSwapMotorized
#define weapon_auto
return true
#define weapon_melee
return false
#define weapon_laser_sight
return false
#define weapon_sprt
return mod_variable_get("weapon", "grenade minigun", "sprGrenadeMinigun")
#define weapon_text
return "THUNDER ACROSS THE LANDSCAPE"

#define charge_base
return {
    maxcharge : maxchrg - 1,
    charge : 0,
    style : 0,
    width : 12,
    power : 2
}

#define weapon_fire(w)
if !is_object(w){
    w = {
        wep: w,
        charge : 1,
        persist : 30,
        defcharge : charge_base()
    }
    wep = w
}
else{
    var q = lq_defget(w, "charge", 1);
    w.charge = min(q + 2/q, maxchrg)
    w.persist = 30
}

var r = random_range(.9, 1.1);
sound_play_pitchvol(sndHyperSlugger, .7 * r + w.charge/(1.5 * maxchrg), .8)
sound_play_pitch(sndQuadMachinegun, .8 * r)

with mod_script_call("mod", "defpack tools 2", "create_bullak", x, y){
    motion_set(other.gunangle + random_range(-1, 1) * other.accuracy, 24)
    projectile_init(other.team, other)
    accuracy = other.accuracy
    image_angle = direction
}
motion_add(gunangle + 180, 2 + 2 * w.charge/maxchrg)
weapon_post(1 + power(w.charge/3, 2), -7, 3)


#define step(w)
if w && is_object(wep) && wep.wep = mod_current goodstep(wep)
else if !w && is_object(bwep) && bwep.wep = mod_current goodstep(bwep)

#define goodstep(w)
if w.persist > 0{
    w.persist-= current_time_scale
    if w.persist <= 0{
        sound_play_pitchvol(sndToxicBoltGas, 1.4, .8)
        wkick = -2
    }
}
else if w.charge > 1{
    if random(100) <= 50 * current_time_scale with instance_create(x+lengthdir_x(16,gunangle),y+lengthdir_y(16,gunangle),Smoke) {vspeed -= random(1); image_xscale/=2;image_yscale/=2; hspeed/=2}
    w.charge = max (w.charge - current_time_scale*.5, 1)
}
if lq_get(w, "defcharge") == undefined{
    w.defcharge = charge_base()
}
w.defcharge.charge = w.charge - 1

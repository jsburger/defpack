#define init
global.sprVanguard = sprite_add_weapon("sprites/weapons/sprVanguard.png", 8, 1)
global.sprScrapperBack = sprite_add_weapon("sprites/weapons/sprScrapperBack.png", 8, 1)
global.a = [global.sprVanguard, global.sprScrapperBack]
#define weapon_name
return `VANGUARD`
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return 7
#define weapon_load
return 40
#define weapon_swap
return sndSwapHammer
#define weapon_auto
return 1
#define weapon_melee
return 1
#define weapon_laser_sight
return 0
#define weapon_sprt(w)
return mod_script_call("mod", "defpunching", "fist_sprite", w, global.a)

#define weapon_text
return "CHARGE"

#define weapon_reloaded

#define fist_stats(w)
w.combocost = 7

#define weapon_fire(w)
with instance_create(x,y,CustomObject){
    sound   = sndMeleeFlip
	name    = "VanguardCharge"
	creator = other
	charge    = 0
    maxcharge = 25
    defcharge = {
        style : 0,
        width : 14,
        charge : 0,
        maxcharge : maxcharge
    }
	charged = 0
	index = creator.index
    accuracy = other.accuracy
	on_step    = vanguard_step
	on_destroy = vanguard_destroy
	on_cleanup = vanguard_cleanup
	reload = -1
	btn = other.specfiring ? "spec" : "fire"
	hand = other.specfiring and other.race == "steroids"
	charge_pitch = 0;
	charge_sound = sound_play_pitch(sndVanWarning, charge_pitch);
}

#define vanguard_hit
if instance_exists(creator) && projectile_canhit_melee(other){
    nexthurt = current_frame + 1
    sound_play_hit(sndImpWristHit, .1)
	mod_script_call_self("mod", "defpunching", "fist_hit", other, fist, creator)
	with instance_create(other.x, other.y, MeleeHitWall){
		image_angle = other.image_angle
	}
	var _s = clamp(other.size, 0, 4),
	    _x = x,
	    _y = y;
    if (other.my_health <= 0)/*space*/{
        if fork(){
            wait(1)
            sleep(20 + 80 * _s);
            wait(1)
            view_shake_max_at(_x, _y,8 + 16 * _s);
            exit;
        }
    }
    else/*space*/if fork()/*space*/{
        wait(1)
        sleep(10 + 8 * _s);
        wait(1)
	    view_shake_max_at(_x, _y, 4 + 8 * _s);
        exit;
    }
}

#define vanguard_step
if !instance_exists(creator){instance_delete(self);exit}
var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
if button_check(index,"swap"){instance_destroy();exit}
if reload = -1{
    reload = hand ? creator.breload : creator.reload
    reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale
}
else{
    if hand creator.breload = max(creator.breload, reload)
    else creator.reload = max(reload, creator.reload)
}
view_pan_factor[index] = 3 - (charge/maxcharge * .5)
defcharge.charge = charge
if button_check(index, btn){
    with instance_create(creator.x + random_range(-64, 64), creator.y + random_range(-64, 64), Wind) {
        var _f = choose(1, 2, 2)
        motion_add(point_direction(x, y, other.creator.x, other.creator.y), _f)
        image_speed = .22 * _f;
        sprite_index = 681;
    }
    sound_pitch(charge_sound, charge_pitch + 1 * (charge/maxcharge))
    view_shake_max_at(x, y, 3.1 * (other.charge/other.maxcharge))
    with creator weapon_post(6 * (other.charge/other.maxcharge), 0, 0)
    if charge < maxcharge{
        charge += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale;
        charged = 0
        //sound_play_pitchvol(sound,sqr((charge/maxcharge) * 3.5) + 6,1 - charge/maxcharge)
    }
    else{
        if current_frame mod 6 < current_time_scale {
            creator.gunshine = 1
            with defcharge blinked = 1
        }
        charge = maxcharge;
        if charged = 0{
            mod_script_call_self("mod","defpack tools", "weapon_charged", creator, 12)
            charged = 1
        }
    }
}
else{instance_destroy()}

#define vanguard_cleanup
sound_stop(charge_sound)
view_pan_factor[index] = undefined
sound_stop(sound)

#define vanguard_destroy
if charged {
    sound_set_track_position(sndVanPortal, 300)
    sound_play_pitch(sndVanPortal, 2)
}
var _c = self,
    _cmin = max((_c.charge/_c.maxcharge), .2);
vanguard_cleanup();
with creator with mod_script_call("mod", "defpunching", "fist_fire", wep){
        other.fistinfo.dashtime = 24 * _cmin
        time = other.fistinfo.dashtime;
        other.fistinfo.dashspeed = 5 + 13 * _cmin      
        damage = 10 + 20 * _cmin
        length *= 1.25
        on_step = vanguardproj_step
        on_hit = vanguard_hit
        charged = _c.charged
    }

#define vanguardproj_step
with creator {
    fistinfo.dashspeed *= .95;
    weapon_post(max(-speed, -8), 0, 0);
}
if charged {
    repeat(irandom(2) + 1) {
        instance_create(x + random_range(-8, 8), y + random_range(-8, 8), BlueFlame)
    }
}
script_ref_call_self(base_step);

#define script_ref_call_self(scr)
return mod_script_call_self(scr[0], scr[1], scr[2])

#define step(p)
mod_script_call("mod", "defpunching", "fist_step", p)
#define init
global.sprBow      = sprite_add_weapon("sprites/weapons/sprArchClassique.png", 2, 7)
global.sprArrow    = sprite_add("sprites/projectiles/sprArchClassiqueArrow.png", 1, 3, 4)
global.sprArrowHUD = sprite_add_weapon("sprites/projectiles/sprArchClassiqueArrow.png", 5, 3)

#define weapon_name
return "ARC CLASSIQUE"

#define weapon_type
return 3

#define weapon_cost
return 1

#define weapon_area
return 8

#define weapon_chrg
return 1

#define weapon_load
return 5

#define weapon_swap
return sndSwapHammer

#define weapon_auto
return 1

#define weapon_melee
return false

#define weapon_laser_sight
return false

#define weapon_reloaded

#define weapon_sprt
if instance_is(self, Player){
    with instances_matching(instances_matching(CustomObject, "name", "bow charge"), "creator", id){
        var yoff = (creator.race = "steroids" and btn = "spec") ? -1 : 1;
        with creator{
            var l = other.charge/other.maxcharge * 4 - 1;
            draw_sprite_ext(other.spr_arrow, 0, x - lengthdir_x(l, gunangle), y - lengthdir_y(l, gunangle) + yoff, 1, 1, gunangle, c_white, 1)
        }
    }
}
return global.sprBow

#define weapon_sprt_hud
return global.sprArrowHUD

#define weapon_text
return "CLASSIC"

#define weapon_fire
with instance_create(x, y, CustomObject){
    sound   = sndMeleeFlip
	name    = "CritBowCharge"
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
	depth = TopCont.depth
	index = creator.index
	spr_arrow  = global.sprArrow
	on_step    = bow_step
	on_destroy = bow_destroy
	on_cleanup = bow_cleanup
	reload = -1
	btn = other.specfiring ? "spec" : "fire"
	hand = other.specfiring and other.race == "steroids"
}

#define sound_play_hit_ext(_sound, _pitch, _vol)
var _s = sound_play_hit(_sound, 0);
sound_pitch(_s, _pitch);
sound_volume(_s, _vol);

#define bow_step
if !instance_exists(creator) {
	instance_delete(self);
	exit;
}
var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
if button_check(index, "swap") {
	instance_destroy();
	exit;
}
if reload = -1 {
    reload = hand ? creator.breload : creator.reload
    reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale
}
else {
    if hand creator.breload = max(creator.breload, reload)
    else creator.reload = max(reload, creator.reload)
}
view_pan_factor[index] = 3 - (charge/maxcharge * .5)
defcharge.charge = charge
if button_check(index, btn) {
    if charge < maxcharge{
        charge += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale;
        charged = 0
        sound_play_hit_ext(sound, sqr((charge/maxcharge) * 3.5) + 6, 1 - charge/maxcharge)
    }
    else{
        if current_frame mod 6 < current_time_scale {
            creator.gunshine = 1
            with defcharge blinked = 1
        }
        charge = maxcharge;
        if charged == 0 {
            mod_script_call_self("mod", "defpack tools", "weapon_charged", creator, 12)
            charged = 1
        }
    }
}
else {
	instance_destroy()
}

#define bow_cleanup
view_pan_factor[index] = undefined
sound_stop(sound)

#define bow_destroy
bow_cleanup()
var _p = random_range(.8, 1.2);
sound_play_hit_ext(sndSwapGuitar, 4 * _p, .8)
sound_play_hit_ext(sndAssassinAttack, 2 * _p, .8)
sound_play_hit_ext(sndClusterOpen, 2 * _p, .2)
if charged = 0 {
    with creator weapon_post(1, -10, 0)
    with instance_create(creator.x, creator.y, Bolt) {
        sprite_index = other.spr_arrow
        mask_index   = mskBullet1
        creator = other.creator
        team    = creator.team
        damage = 10
        move_contact_solid(creator.gunangle, 6)
        motion_add(creator.gunangle + random_range(-8, 8) * creator.accuracy * (1 - (other.charge/other.maxcharge)), 16 + (6 * other.charge/other.maxcharge))
        image_angle = direction
    }
}
else {
    with creator{
        weapon_post(1, -30, 0)
        repeat(6) with instance_create(x, y, Dust){
            motion_add(random(360), choose(5, 6))
        }
    }
    sound_play_pitchvol(sndShovel, 2, .8)
    sound_play_pitchvol(sndUltraCrossbow, 3, .8)
    var ang = creator.gunangle + random_range(-5, 5) * creator.accuracy
    var i = -12;
    repeat(3) {
        with instance_create(creator.x, creator.y, Bolt) {
            sprite_index = other.spr_arrow
            mask_index   = mskBullet1
            creator = other.creator
            team    = creator.team
            damage = 10
            move_contact_solid(creator.gunangle, 6)
            motion_add(ang + i, 20)
            image_angle = direction
        }
        i += 12;
    }
}

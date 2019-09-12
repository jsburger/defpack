#define init
global.sprSmarterGun 	  = sprite_add_weapon("sprites/weapons/sprSmarterGun.png",8,6)
global.sprSmarterGunHUD = sprite_add_weapon("sprites/weapons/sprSmarterGun.png",1,4)
#define weapon_name
return "SMARTER GUN"
#define weapon_type
return 1
#define weapon_cost
return 1
#define weapon_area
return 15
#define weapon_load
return 4
#define weapon_swap
return sndSwapMachinegun
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_iris
return "smarter x gun"
#define weapon_sprt_hud
return global.sprSmarterGunHUD
#define weapon_sprt(w)
return mod_script_call_self("mod", "defpack tools", "smarter_gun_sprite", global.sprSmarterGun, w)
#define weapon_text
return "massive brain"

#define weapon_fire
shoot(wep, 1)

#define shoot(wep, manual)
var _tx = wep.x, _ty = wep.y;
var angle, _canshoot = manual

if !manual {
    var targets = mod_script_call_nc("mod", "defpack tools", "get_n_targets", _tx, _ty, hitme, "team", team, 3), target = noone;
    with targets{
        if !(collision_line(_tx, _ty, x, y, Wall, 0, 0) or collision_line(_tx, _ty, x, y, PopoShield, 0, 0) or collision_line(_tx, _ty, x, y, ProtoStatue, 0, 0)){
            target = id
            _canshoot = 1
            break
        }
    }
    if _canshoot{
        angle = point_direction(_tx, _ty, target.x + target.hspeed, target.y + target.vspeed)
    }
    /*var target = mod_script_call_nc("mod", "defpack tools", "instance_nearest_matching_ne", _tx, _ty, hitme, "team", team)
    if instance_exists(target){
        var oldtarget = -4, targets = [], n = 0
        while ++n <= 3 and target != oldtarget and !_canshoot and instance_exists(target){
            if collision_line(_tx,_ty,target.x,target.y,Wall,0,0) or collision_line(_tx,_ty,target.x,target.y,PopoShield,0,0) or collision_line(_tx,_ty,target.x,target.y,ProtoStatue,0,0){
                //with instance_create(target.x, target.y - 6*n, WepSwap) image_blend = merge_color(c_red, c_yellow, (n-1)/2)
                target.x += 10000
                target.y += 10000
                oldtarget = target
                targets[n-1] = target
                target = mod_script_call_nc("mod", "defpack tools", "instance_nearest_matching_ne", _tx, _ty, hitme, "team", team)
            }
            else _canshoot = 1
        }
        with targets {
            x -= 10000
            y -= 10000
        }
        if _canshoot {
            //with target with instance_create(x, y, WepSwap) image_blend = c_lime
            angle = point_direction(_tx, _ty, target.x + target.hspeed, target.y + target.vspeed)
        }
    }*/
}
else {
    angle = point_direction(_tx, _ty, mouse_x[index], mouse_y[index])
}

if _canshoot{
    wep.kick = 3
    wep.gunangle = angle
    weapon_post(0,3,6)
    var _r = random_range(.9, 1.1), _v = manual ? 1 : .8
    sound_play_pitchvol(sndSmartgun, .8 * _r, .8 * _v)
    sound_play_pitchvol(sndGruntFire, 1.4 * _r, _v)
    sound_play_pitchvol(sndServerBreak, 1.4 * _r, _v * .7)
    //sound_play_pitchvol(sndTurretFire, .8 * _r, _v * .8)
    with instance_create(_tx,_ty,Bullet1){
    	sprite_index = sprBullet1
    	spr_dead = sprBulletHit
    	creator = other
    	team = other.team
    	motion_set(angle,16)
    	image_angle = direction
    }
}
return _canshoot

#define step(w)
mod_script_call_self("mod", "defpack tools", "smarter_gun_step", w)


/*if !is_object(w ? wep : bwep){
    if w wep = wep_init()
    else bwep = wep_init()
}
smart_step(self, w ? wep : bwep, sign(w - .1))


if ammo[1] >= weapon_cost() or infammo != 0 {
    if w and reload <= 0 and !button_check(index, "fire"){
        if shoot(wep, 0){
            reload = weapon_load()
            if infammo = 0 ammo[1] -= weapon_cost()
        }
    }
    if !w and breload <= 0 and !(button_check(index, "spec") and race = "steroids"){
        if shoot(bwep, 0){
            breload = weapon_load()
            if infammo = 0 ammo[1] -= weapon_cost()
        }
    }
}


if !w && race != "steroids" && breload > 0{
	breload -= current_time_scale * reloadspeed
	if skill_get(mut_stress) breload -= (1 - my_health/maxhealth) * current_time_scale
	if race = "venuz"
	{
		breload -= .2 * current_time_scale
		if ultra_get(race,1) breload -= .4 * current_time_scale
	}
}

#define wep_init
var w = {
    wep : mod_current,
    x : x,
    y : y,
    xgoal : x,
    ygoal : y,
    yoff : 0,
    gunangle : 0,
    kick : 0,
    is_drone : 1
}
return w

#define smart_step(c, w, p)
var timescale = current_time_scale;
with w{
    x += approach(x, xgoal, 6, timescale) - lengthdir_x(kick, gunangle)/2
    y += approach(y, ygoal, 6, timescale) - lengthdir_y(kick, gunangle)/2
    yoff = (sin(current_frame/10) * 3 * p)

    var l = 24, a = c.gunangle + 180 + 50 * p, d = 6;

    var wantx = c.x + 24 * p
    var wanty = c.y - 24

    var q = mod_script_call("mod", "defpack tools", "collision_line_first", c.x, c.y, wantx, wanty, Wall, 0, 0), a = point_direction(c.x, c.y, wantx, wanty);
    xgoal = q[0] - lengthdir_x(d, a)
    ygoal = q[1] - lengthdir_y(d, a)

    kick -= clamp(sign(kick) * timescale/2, -kick * timescale, kick * timescale)
}

#define approach(a, b, n, dn)
return (b - a) * (1 - power((n - 1)/n, dn))
*/

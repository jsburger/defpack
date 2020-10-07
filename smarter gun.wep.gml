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
return "THINK FASTER"

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


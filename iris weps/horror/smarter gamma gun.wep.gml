#define init
global.sprSmarterGun 	  = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprSmarterHorrorGunOn.png",9,8)
global.sprSmarterGunHUD   = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprSmarterHorrorGunOn.png",1,4)
#define weapon_name
return "SMARTER GAMMA GUN"
#define weapon_type
return 1
#define weapon_cost
return 1
#define weapon_area
return -1
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
return "DEFRAGMENTING..."

#define weapon_fire
shoot(wep, 1)

#define shoot(wep, manual)
var _tx = wep.x, _ty = wep.y;
var angle, _canshoot = manual;

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
}
else {
    angle = point_direction(_tx, _ty, mouse_x[index], mouse_y[index])
}


if _canshoot {
    
    var secondAngle = angle + random_range(-14, 14);
    var projTargets = mod_script_call_nc("mod", "defpack tools", "get_n_targets", _tx, _ty, projectile, "team", team, 3);
    with projTargets {
        
        //i did some geometry to get this
        //full scribbles here https://cdn.discordapp.com/attachments/519628606851514376/837747179220500583/image0.jpg
        
        var _angleDiff = angle_difference(direction, point_direction(x, y, _tx, _ty));
        var _angleOffset = arcsin((speed * dsin(_angleDiff))/16)
        
        var _bulletLine = {"x": x, "y": y, dir: direction},
            _droneLine = {"x": _tx, "y": _ty, dir: point_direction(_tx, _ty, x, y) - (_angleOffset * 180/pi)},
            _collisionPoint = point_intersect(_bulletLine, _droneLine);
        var cx = _collisionPoint.x, cy = _collisionPoint.y;
        
        // with instance_create(cx, cy, CaveSparkle) depth = -10
        
        if !(collision_line(_tx, _ty, cx, cy, Wall, 0, 0) or collision_line(_tx, _ty, cx, cy, PopoShield, 0, 0) or collision_line(_tx, _ty, cx, cy, ProtoStatue, 0, 0)) {
            secondAngle = _droneLine.dir;
            break
        }
        
    }
    
    wep.kick = 3
    wep.gunangle = angle
    weapon_post(0,3,6)
    var _r = random_range(.9, 1.1), _v = manual ? .8 : .6
    sound_play_pitchvol(sndSmartgun, .8 * _r, .8 * _v)
    sound_play_pitchvol(sndGruntFire, 1.2 * _r, _v)
    sound_play_pitchvol(sndServerBreak, 1.25 * _r, _v * .5)
    sound_play_pitchvol(sndUltraPistol, 2.5 * _r, _v*.7)
    with mod_script_call("mod", "defpack tools", "create_gamma_bullet",_tx,_ty){
    	motion_set(angle,16)
    	image_angle = direction
    	projectile_init(other.team, other)
    }
    with mod_script_call("mod", "defpack tools", "create_gamma_bullet",_tx,_ty){
    	motion_set(secondAngle, 16)
    	image_angle = direction
    	projectile_init(other.team, other)
    }
}
return _canshoot

#define step(w)
mod_script_call_self("mod", "defpack tools", "smarter_gun_step", w)


#define point_intersect(_line1, _line2)
//Uses negative angle because of GML's y going 'down' as it increases, despite 90 degrees still being 'up'
var _m1 = dtan(-_line1.dir),
	_m2 = dtan(-_line2.dir),
	_b1 = _line1.y,
	_b2 = _line2.y,
	_h1 = _line1.x,
	_h2 = _line2.x,
	_x  = (((-_m2 / _m1) * _h2) + ((_b2 - _b1)/_m1) + _h1)/(1 - (_m2/_m1)),
	_y  = _m1 * (_x - _h1) + _b1;
	return {x: _x, y: _y}

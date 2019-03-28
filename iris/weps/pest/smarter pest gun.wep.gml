#define init
global.sprSmarterGun 	  = sprite_add_weapon("sprites/sprSmarterPestGun.png",9,7)
global.sprSmarterGunHUD = sprite_add_weapon("sprites/sprSmarterPestGun.png",1,4)
#define weapon_name
return "SMARTER PEST GUN"
#define weapon_type
return 1
#define weapon_cost
return 1
#define weapon_area
return -1
#define weapon_load
return 3
#define weapon_swap
return sndSwapMachinegun
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt_hud
return global.sprSmarterGunHUD
#define weapon_sprt(w)
return mod_script_call_self("mod", "defpack tools", "smarter_gun_sprite", global.sprSmarterGun, w)
#define weapon_text
return "massive brain"
#define weapon_iris
return "smarter x gun"
#define weapon_fire
shoot(wep, 1)

#define shoot(wep, manual)
var _tx = wep.x, _ty = wep.y;
var angle, _canshoot = manual;

if !manual {
    var targets = mod_script_call_nc("mod", "defpack tools", "get_n_targets", _tx, _ty, hitme, "team", team, 3), target = noone;
    with targets{
        if !(instance_is(self, Exploder) or instance_is(self, FrogQueen) or point_distance(_tx, _ty, x, y) < 30 or collision_line(_tx, _ty, x, y, Wall, 0, 0) or collision_line(_tx, _ty, x, y, PopoShield, 0, 0) or collision_line(_tx, _ty, x, y, ProtoStatue, 0, 0)){
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
    wep.kick = 3
    wep.gunangle = angle
    weapon_post(0,3,6)
    var _r = random_range(.9, 1.1), _v = manual ? 1 : .8
	sound_play_pitchvol(sndSmartgun, .8 * _r, .8 * _v)
    sound_play_pitchvol(sndGruntFire, 1.2 * _r, _v)
    sound_play_pitchvol(sndServerBreak, 1.4 * _r, _v * .5)
	sound_play_pitchvol(sndMinigun, .7 * _r, _v*.7)
	sound_play_pitchvol(sndToxicBoltGas, .8 * _r, _v*.8)
    with mod_script_call_nc("mod", "defpack tools", "create_pest_bullet", _tx,_ty){
        creator = other
    	team = other.team
    	motion_set(angle,16)
    	image_angle = direction
    }
}
return _canshoot

#define step(w)
mod_script_call_self("mod", "defpack tools", "smarter_gun_step", w)

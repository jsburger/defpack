#define init
global.sprSmarterGun 	  = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprSmarterThunderGun.png",9,7)
global.sprSmarterGunHUD = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprSmarterThunderGun.png",1,4)
#define weapon_name
return "SMARTER THUNDER GUN"
#define weapon_type
return 1
#define weapon_cost
return 3
#define weapon_area
return -1
#define weapon_load
return 9
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
return "RACING MIND"

#define weapon_iris
return "smarter x gun"

#define weapon_fire
shoot(wep, true);

#define shoot(wep, manual)
var _tx = wep.x, _ty = wep.y;
var angle, angles = [], _canshoot = manual

if !manual {
    var targets = mod_script_call_nc("mod", "defpack tools", "get_n_targets", _tx, _ty, hitme, "team", team, 5), bursttargets = [];
    with targets{
        if !(collision_line(_tx, _ty, x, y, Wall, 0, 0) or collision_line(_tx, _ty, x, y, PopoShield, 0, 0) or collision_line(_tx, _ty, x, y, ProtoStatue, 0, 0)){
            array_push(bursttargets, self)
            _canshoot = 1
            if array_length(bursttargets) >= weapon_cost() break
        }
    }
    if _canshoot {
        for (var i = 0; i < weapon_cost(); i++) {
            target = bursttargets[i mod array_length(bursttargets)]
            array_push(angles,point_direction(_tx, _ty, target.x + target.hspeed, target.y + target.vspeed))
        }
    }
}
else {
    angle = point_direction(_tx, _ty, mouse_x[index], mouse_y[index])
    repeat(weapon_cost()) array_push(angles, angle)
}

if _canshoot {
	with mod_script_call("mod", "defburst", "burst", weapon_cost(), 1, script_ref_create(burst_fire)) {
		firing_angles = angles;
		smarter_gun = wep;
		manually_fired = manual;
	}
}
return _canshoot

#define burst_fire(burst)
	var wep = burst.smarter_gun,
		angle = burst.firing_angles[burst.shots_fired mod array_length(burst.firing_angles)];
	wep.kick = 2 * (burst.shots_fired + 1);
	wep.gunangle = angle;
	weapon_post(0, 3, 6)
	var _r = random_range(.9, 1.1),
		_v = burst.manually_fired ? .8 : .6;
	sound_play_pitchvol(sndSmartgun, .8 * _r, .8 * _v)
	sound_play_pitchvol(sndGruntFire, 1.2 * _r, _v)
	sound_play_pitchvol(sndServerBreak, 1.4 * _r, _v * .5)
	sound_play_pitchvol(sndGammaGutsKill, 1.6*_r, (.3+skill_get(17)*.2) * _v)
	if !skill_get(17) sound_play_pitchvol(sndLightningRifle,1.5*_r, _v)
	else sound_play_pitchvol(sndLightningRifleUpg,1.7*_r, _v)
	
	with mod_script_call_nc("mod", "defpack tools", "create_lightning_bullet", wep.x, wep.y) {
		creator = instance_is(other, FireCont) ? other.creator : other;
		team = other.team;
		motion_set(angle, 16);
		image_angle = direction;
	}

#define step(w)
mod_script_call_self("mod", "defpack tools", "smarter_gun_step", w)

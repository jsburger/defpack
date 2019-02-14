#define init
global.sprSmarterGun 	  = sprite_add_weapon("sprites/sprSmarterThunderGun.png",9,7)
global.sprSmarterGunHUD = sprite_add_weapon("sprites/sprSmarterThunderGun.png",1,4)
#define weapon_name
return "SMARTER THUNDER GUN"
#define weapon_type
return 1
#define weapon_cost
return 3
#define weapon_area
return -1
#define weapon_load
return 10
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
if instance_is(self,Player)
{
	if wep = w{
	    var q = shoot(1, 1, 0, 0, 1)
		draw_sprite_ext(global.sprSmarterGun, 0, q[0], q[1], right, 1, 0, c_white, 1)
	}
	if bwep = w
	{
	    var q = shoot(-1, -1, 1, 0, 1)
		draw_sprite_ext(global.sprSmarterGun, 0, q[0], q[1], right, 1, 0, c_white, 1)
	}
	return mskNothing
}
else{return global.sprSmarterGun}


#define weapon_text
return "massive brain"

#define weapon_iris
return "smarter x gun"
#define weapon_fire
var hand = specfiring and race = "steroids"
if shoot( 1 - 2*hand, 1- 2*hand, hand, 1, 0){
    weapon_post(1, 0, 0)
}

#define shoot(xm, ym, hand, manual, justcoords)
var xw = (sprite_get_width(sprite_index)/1.5 - (4 * (hand ? breload: reload)/weapon_load() * right)) * xm;
var yw = -8+(sin(current_frame/10)*4 * ym);

/*var _tx = x + lengthdir_x(xw, gunangle + 90),
    _ty = y + lengthdir_y(xw, gunangle + 90) + yw
*/
var _tx = x + xw, _ty = y + yw;

if justcoords return [_tx, _ty]

var angles = []
var angle = gunangle, _canshoot = 0

if !manual {
    var target = mod_script_call_nc("mod", "defpack tools", "instance_nearest_matching_ne", _tx, _ty, hitme, "team", team)
    if instance_exists(target){
        var oldtarget = -4, targets = [], n = 0, bursttargets = []
        while ++n <= 5 and target != oldtarget and instance_exists(target) and array_length(bursttargets) < weapon_cost(){
            oldtarget = target
            targets[n-1] = target
            if !collision_line(_tx,_ty,target.x,target.y,Wall,0,0) and !collision_line(_tx,_ty,target.x,target.y,PopoShield,0,0) and !collision_line(_tx,_ty,target.x,target.y,ProtoStatue,0,0){
                array_push(bursttargets, target)
                _canshoot = 1
            }
            target.x += 10000
            target.y += 10000
            target = mod_script_call_nc("mod", "defpack tools", "instance_nearest_matching_ne", _tx, _ty, hitme, "team", team)
        }
        with targets {
            x -= 10000
            y -= 10000
        }
        if _canshoot {
            //with target with instance_create(x, y, WepSwap) image_blend = c_lime
            //var d = point_distance(_tx, _ty, target.x, target.y)/16
            for var i = 0; i < weapon_cost(); i++{
                target = bursttargets[i mod array_length(bursttargets)]
                array_push(angles,point_direction(_tx, _ty, target.x + target.hspeed, target.y + target.vspeed))
            }
        }
    }
}
else {
    angle = point_direction(_tx, _ty, mouse_x[index], mouse_y[index])
    repeat(weapon_cost()) array_push(angles, angle)
}

if manual or _canshoot {
    if fork(){
        for var i = 0; i < weapon_cost(); i++{
            if instance_exists(self){
                angle = angles[i mod array_length(angles)]
                weapon_post(0,3,6)
                var _r = random_range(.9, 1.1), _v = manual ? 1 : .8
								sound_play_pitchvol(sndSmartgun, .8 * _r, .8 * _v)
						    sound_play_pitchvol(sndGruntFire, 1.2 * _r, _v)
						    sound_play_pitchvol(sndServerBreak, 1.4 * _r, _v * .5)
								sound_play_pitchvol(sndGammaGutsKill,1.6*_r,.3+skill_get(17)*.2)
								if !skill_get(17)sound_play_pitch(sndLightningRifle,1.5*_r)else sound_play_pitch(sndLightningRifleUpg,1.7*_r)
                with mod_script_call_nc("mod", "defpack tools", "create_lightning_bullet", _tx,_ty)
                {
                	creator = other
                	team = other.team
                	motion_set(angle,16)
                	image_angle = direction
                }
                wait(1)
            }
        }
        exit
    }
    return 1
}
return 0

#define step(w)

if ammo[1] >= weapon_cost() or infammo != 0 {
    if w and reload <= 0 and !button_check(index, "fire"){
        if shoot(1, 1, 0, 0, 0){
            reload = weapon_load()
            if infammo = 0 ammo[1] -= weapon_cost()
        }
    }
    if !w and breload <= 0 and !(button_check(index, "spec") and race = "steroids"){
        if shoot(-1, -1, 1, 0, 0){
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

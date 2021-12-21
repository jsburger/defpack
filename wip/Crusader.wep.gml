#define init
global.sprScrapper = sprite_add_weapon("sprites/weapons/sprScrapper.png", 8, 1)
global.sprScrapperBack = sprite_add_weapon("sprites/weapons/sprScrapperBack.png", 8, 1)

global.sprArms = sprite_add("sprites/other/sprGuardianArm.png", 3, 0, 8)

global.a = [global.sprScrapper, global.sprScrapperBack]
#define weapon_name
return "GUARDIAN'S GRASP"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return 7
#define weapon_load
return 24
#define weapon_swap
return sndSwapHammer
#define weapon_auto
return 1
#define weapon_melee
return 1
#define weapon_rads
return 6
#define weapon_laser_sight
return 0
#define weapon_sprt(w)
return mod_script_call("mod", "defpunching", "fist_sprite", w, global.a)

#define weapon_text
return "@bCOMBO@s awakens your guardian spirit"

#define weapon_reloaded

#define fist_stats(w)
w.combocost = 50
w.stand = -4
w.combotime = 150

#define script_ref_call_self(scr)
return mod_script_call_self(scr[0], scr[1], scr[2])

#define weapon_fire(w)
var active = mod_script_call("mod", "defpunching", "fist_active", w);
with mod_script_call("mod", "defpunching", "fist_fire", wep) {
    damage = 10
}
weapon_post(-12, 10, 6)
var _p = random_range(.9, 1.1);
sound_play_pitchvol(sndHammer, .7 * _p, .5)
sound_play_pitch(sndMeleeFlip, 1.3 * _p)

#define step(p)
mod_script_call("mod", "defpunching", "fist_step", p)
if button_pressed(index, "horn") {
    with create_guardian(x, y){
        timer = 100000
        team = other.team
        creator = other
    }
}

#define is_any()
for var i = 1; i < argument_count; i++{
    if instance_is(argument[0], argument[i]) return true
}
return false

#define get_target(_x, _y, team)
return instance_nearest_matching_ne(_x, _y, hitme, "team", team)

#define instance_nearest_matching_ne(_x, _y, obj, varname, value)
return mod_script_call_self("mod", "defpack tools", "instance_nearest_matching_ne", _x, _y, obj, varname, value)




#define create_guardian(_x, _y)
with instance_create(_x, _y, CustomObject) {
	name = "GuardianStand"
	
	on_end_step = guardian_end_step
	on_step     = guardian_step
	on_draw     = guardian_draw
	on_destroy  = guardian_delete
	on_cleanup  = on_destroy
	
	creator = noone
	team    = 0
	mask_index = mskPlayer
	spr_arm    = global.sprArms
	
	timer    = 600
	facing   = 270
	armpoint = [facing, facing]
	armscale = [16, 16]
	hand = 0
	
	image_alpha = 0
	surf = surface_create(100, 100)
	
	return id
}


#define guardian_step





#define punch(t, f)
var reach = 48 - random(8)
var ang = point_direction(x,y,t.x,t.y) + random_range(-10,20) * f;
var p = random_range(.9, 1.2);
//sound_play_pitchvol(sndHammerHeadProc, .8*p, .8*p)
sound_play_pitchvol(sndSlugger, 1.4*p, .6)
sound_play_pitchvol(sndImpWristKill, 1.4*p, 1)
sound_play_gun(sndImpWristHit, .2, .6)
view_shake_at(t.x, t.y, 7)
projectile_hit(t, 3, 10, ang)
with instance_create(x + lengthdir_x(reach, ang), y + lengthdir_y(reach, ang), BulletHit){
    sprite_index = sprMeleeHitWall
    image_angle = ang + 180
    if fork(){
        wait(1)
        if instance_exists(self) image_blend = c_black
        wait(1)
        if instance_exists(self) image_blend = c_white
        exit
    }
    image_xscale = .75 + random(.75)
    image_yscale = .75 + random(.5)
    image_speed = 1
    image_index = 1
    motion_set(image_angle, 1 + random(3))
    with instance_create(x, y, BulletHit){
        sprite_index = sprImpactWrists
        image_angle = other.image_angle + 90
        image_xscale = 1.1 * other.image_yscale
        image_yscale = .15
        image_speed = 1
        image_index = 2
    };
};
return ang;

#define guardian_end_step
// if instance_exists(creator){
// 	x = creator.x
// 	y = creator.y
// }
var lim = 4, sp = 15, a = 20;
for (var o = 0; o <= 1; o++){
    armscale[o] = max(armscale[o] - sp*current_time_scale, lim)
    armpoint[o] -= angle_difference(armpoint[o], facing + a * (2*o - 1))/3*current_time_scale
}

var canpunch = armscale[hand] <= lim and armscale[!hand] < lim + sp or armscale[!hand] = lim;
var reach = 48, left = (armscale[0] <= lim and (armscale[1] <= lim + sp or armscale[1] = lim)), right = (armscale[1] <= lim and (armscale[0] <= lim + sp or armscale[0] = lim));
if canpunch {
    var q = get_target(x, y, team), p = instance_nearest_matching_ne(x, y, projectile, "team", team);
    var t = -4;
    if instance_exists(p) and !is_any(p, Laser, EnemyLaser){
        if instance_exists(q){
            t = distance_to_object(p) < distance_to_object(q) ? p : q
        }
        else{
            t = p
        }
    }
    else if instance_exists(q){
        t = q
    }
    if t != -4 and distance_to_object(t) < reach and !collision_line(x, y, t.x, t.y, Wall, 0, 0){
        var i = hand;
        //if right i = 1;
        armscale[i] = reach
        if t == q
            armpoint[i] = punch(t, -(i*2 - 1))
        else {
            var e = point_direction(x, y, t.x, t.y);
            armpoint[i] = e
            with t{
                motion_set(e, 20)
                var p = random_range(.9, 1.2)
                sound_play_pitchvol(sndRecGlandProc, 1.2*p, 1)
                sound_play_pitch(sndCoopUltraA,22*p)
                sound_play_gun(sndHitWall, .1, .6)
                image_angle = direction
                with instance_create(x, y, BulletHit){
                    sprite_index = sprImpactWrists
                    image_angle = other.image_angle + 90
                    image_xscale = 1.1
                    image_yscale = .15
                    image_speed = 1
                    image_index = 2
                };
            }
        }
        hand = !hand
    }
}

facing = armpoint[0] - angle_difference(armpoint[0], armpoint[1])/2
// if instance_exists(creator) and armscale[0] <= lim and armscale[1] <= lim facing += angle_difference(creator.gunangle, facing)/1.5*current_time_scale
if armscale[0] <= lim and armscale[1] <= lim facing += angle_difference(270, facing)/1.5*current_time_scale

if timer > 0 {timer -= current_time_scale}
if timer = 0 || !instance_exists(creator) {
	repeat(30){
		with instance_create(x,y,Dust){
			motion_add(random(360),2+random(3))
		}
	}
	instance_destroy()
}

#define guardian_draw
draw_sprite(sprCrownGuardianIdle, 0, x, y)

surface_set_target(surf)
draw_clear_alpha(0, 0)
for (var o = 0; o <= 1; o++) {
    draw_arm_2(50, 50, 50 + lengthdir_x(armscale[o], armpoint[o]), 50 + lengthdir_y(armscale[o], armpoint[o]), o * 2 - 1, armpoint[o])
}
surface_reset_target()
d3d_set_fog(1, 0, 0, 0)
for (var i = 0; i < 360; i += 90) {
    draw_surface(surf, x - 50 + lengthdir_x(1, i), y - 50 + lengthdir_y(1, i))
}
d3d_set_fog(0, 0, 0, 0)
draw_surface(surf, x - 50, y - 50)


#define guardian_delete
surface_destroy(surf)
surface_free(surf)

#define draw_arm(x, y, x2, y2, flip, angle)
var l = 16, dis = point_distance(x, y, x2, y2);
var ml = 44, tl = min(dis, ml), a = (darcsin(2*(tl/ml) - 1) - 90) * flip + angle, e = 6*flip, f = 20*flip * (1.1-(tl/ml)), _x = x + lengthdir_x(e, angle - 90), _y = y + lengthdir_y(e, angle - 90);
draw_sprite_ext(global.arm[0], 0, _x, _y, 1, -flip, a, c_white, 1)
var ang2 = point_direction(_x + lengthdir_x(l, a), _y + lengthdir_y(l, a), x2 + lengthdir_x(f, angle - 90), y2 + lengthdir_y(f, angle - 90));
draw_sprite_ext(global.arm[0], 1, _x + lengthdir_x(l, a), _y + lengthdir_y(l, a), 1, -flip, ang2, c_white, 1)
draw_sprite_ext(global.arm[0], 2, _x + lengthdir_x(l, a) + lengthdir_x(l, ang2), _y + lengthdir_y(l, a) + lengthdir_y(l, ang2), 1, -flip, ang2, c_white, 1)


#define draw_arm_2(shoulder_x, shoulder_y, wrist_x, wrist_y, flip, angle)
var _armlen = 16,
    _dis = point_distance(shoulder_x, shoulder_y, wrist_x, wrist_y),
    _maxlength = 48,
    _totallength = min(_dis, _maxlength),
    _armangle = (darcsin(2 * (_totallength/_maxlength) - 1) - 90) * flip + angle,
    _dx = shoulder_x + lengthdir_x(6 * flip, angle - 90),
    _dy = shoulder_y + lengthdir_y(6 * flip, angle - 90),
    _wristoffset = 20 * flip * (1.1 - (_totallength/_maxlength)),
    _ex = _dx + lengthdir_x(_armlen, _armangle),
    _ey = _dy + lengthdir_y(_armlen, _armangle),
    _foreangle = point_direction(_ex, _ey, wrist_x + lengthdir_x(_wristoffset, angle - 90), wrist_y + lengthdir_y(_wristoffset, angle - 90));
    
    draw_sprite_ext(global.sprArms, 0, _dx, _dy, 1, -flip, _armangle, c_white, 1)
    draw_sprite_ext(global.sprArms, 1, _ex, _ey, 1, -flip, _foreangle, c_white, 1)
    draw_sprite_ext(global.sprArms, 2, _ex + lengthdir_x(_armlen, _foreangle), _ey + lengthdir_y(_armlen, _foreangle), 1, -flip, _foreangle, c_white, 1)










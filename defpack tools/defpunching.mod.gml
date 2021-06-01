#define init


#macro bouncemax 3

#macro newfistinfo {
			dashdir : 0,
			dashtime : 0,
			dashcheck : 0,
			combo : 0,
			combotime : 0,
			couldaim : 0,
			couldspec: 0,
			bounce : -bouncemax - 1
		}

#macro dashmax 8

// global.mouseAim = 1
// #macro mouseAim global.mouseAim

// mod_script_call("mod", "defpermissions", "permission_register", "mod", mod_current, "mouseAim", "Fists use roll controls")


#define bool_to_sign(n)
//n = 1 returns 1, n = 0 returns -1
return (2 * n - 1)

#define gunangle_set(angle)
gunangle = angle
if fork(){
	wait(0)
	if instance_exists(self){
		gunangle = angle
	}
}

#define weapon_is_fist(wep)
if is_object(wep) {
	return lq_defget(wep, "is_fist", 0)
}
return false

#define fist_active(wep)
if instance_is(self, Player) and weapon_is_fist(wep){
	if fistinfo.combo >= wep.combocost return true
}
return false

#define script_ref_call_self(scr)
return mod_script_call_self(scr[0], scr[1], scr[2])


#define step
with Player {
	if "fistinfo" not in self {
		fistinfo = newfistinfo
	}
	else {
		var f = fistinfo;
		f.dashcheck = 0
		if f.bounce >= -bouncemax {
			y -= f.bounce
			spr_shadow_y += f.bounce
			f.bounce -= current_time_scale
		}
		// if !mouseAim{
		// 	var _fist = weapon_is_fist(wep);
		// 	if f.dashtime <= 0 or !_fist{
		// 		if _fist and speed > friction{
		// 			f.couldaim = max(canaim, f.couldaim)
		// 			gunangle = direction
		// 			canaim = 0
		// 		}
		// 		else {
		// 			if f.couldaim {
		// 				f.couldaim = 0
		// 				canaim = 1
		// 			}
		// 		}
		// 	}
		// }
	}
}

#define fist_fire(w)
if "fistinfo" not in self fistinfo = newfistinfo
var dir = gunangle;
// if speed > friction and !mouseAim{
// 	var vs = 0, hs = 0;
// 	if button_check(index, "nort") vs = -1
// 	if button_check(index, "sout") vs = 1
// 	if button_check(index, "east") hs = 1
// 	if button_check(index, "west") hs = -1
// 	if hs != 0 or vs != 0
// 		dir = point_direction(0, 0, hs, vs)
// }

while fistinfo.bounce >= -bouncemax {
	y -= fistinfo.bounce
	spr_shadow_y += fistinfo.bounce
	fistinfo.bounce -= current_time_scale
}

fistinfo.dashdir = dir
fistinfo.dashtime = dashmax
fistinfo.dashspeed = 8
// if !mouseAim{
// 	fistinfo.couldaim = max(canaim, fistinfo.couldaim)
// 	gunangle_set(dir)
// 	canaim = 0
// }

with instance_create(x + lengthdir_x(15, dir), y + lengthdir_y(15, dir), CustomSlash){
	name = "FistSlash"
	creator = other
	team = other.team

	on_step = hitbox_step
	base_step = on_step
	on_hit = hitbox_hit
	base_hit = on_hit
	on_wall = hitbox_wall
	on_projectile = hitbox_proj
	base_projectile = on_projectile
	on_grenade = hitbox_grenade

	on_step = dust_step

	sprite_index = mskNone
	mask_index   = mskScorpion
	image_angle = dir
	image_xscale = 1 + .5 * skill_get(mut_long_arms)
	length = 15 * (1 + .5 * skill_get(mut_long_arms))
	image_yscale = 1
	image_speed = 0
	direction = dir
	image_angle = dir

	damage = 8
	force = 4
	time = dashmax
	fist = w

	return id
}

#define dust_step
if instance_exists(creator) and random(100) <= 50 * current_time_scale{
	with instance_create(x, y, Dust){
		direction = other.direction + 180
		direction += sqr(random_range(2, 10)) * choose(-1, 1)
		speed = random_range(-3, 2)
	}
}
hitbox_step()

#define hitbox_step
if instance_exists(creator){
	direction = creator.direction
	image_angle = direction
	x = creator.x + lengthdir_x(length, direction)
	y = creator.y + lengthdir_y(length, direction)
	xprevious = x
	yprevious = y
}
time -= current_time_scale
if time <= 0 instance_destroy()

#define hitbox_wall

#define hitbox_proj
with other if typ > 0 instance_destroy()

#define hitbox_grenade
with other {
	motion_set(other.direction, other.damage)
	with instance_create(x, y, Deflect)
		image_angle = other.direction
}
#define hitbox_hit
with creator {
	fistinfo.dashdir = fistinfo.dashdir + 180
	fistinfo.dashtime = 5
	fistinfo.dashspeed = 4
	nexthurt = current_frame + 8
	fistinfo.bounce = bouncemax
	var w = other.fist;
	if w == wep reload /= 2
	if w == bwep breload /= 2
}
sleep(10 + 12 * clamp(other.size, 1, 3))
view_shake_max_at(x, y, 2 + 4 * clamp(other.size, 1, 3))
sound_play_hit(sndImpWristHit, .1)
sound_play_pitchvol(sndSpiderDead, 1.25, .6)
sound_play_pitchvol(sndHitFlesh, 1, 1.25)
if instance_exists(creator){
	fist_hit(other, fist, creator)
	with instance_create(other.x, other.y, MeleeHitWall){
		image_angle = other.image_angle
	}
}
instance_destroy()

#define fist_hit(_target, _fist, _creator)
projectile_hit(_target, damage, force, image_angle)
_creator.fistinfo.combo++
_creator.fistinfo.combotime = _fist.combotime
with counter_create(_creator.fistinfo.combo, _fist.combocost){
	index = _creator.index
}

#define counter_create(_num, _bignum)
with instance_create(x, y, CustomObject){
	name = "ComboText"
	depth = -8
	target = 0
	text = string(_num)
	big = (_num mod _bignum == 0)
	basecolor = c_aqua
	blendcolor = big ? c_white : c_black
	image_xscale += .2 * big
	image_yscale = image_xscale

	on_draw = counter_draw
	on_step = counter_step
	time = 12
	gravity = 1 - big * .6
	friction = .2 + big * .2
	motion_set(random_range(30, 150), random_range(2, 4))
	return id
}

#define counter_draw
var _c = merge_color(basecolor, blendcolor, .3 + .1*(sin(current_frame/2)));
draw_set_visible_all(0)
draw_set_visible(target, 1)
	draw_set_color(c_black)
	draw_text_transformed(x, y + 1, text, image_xscale, image_yscale, image_angle)
	draw_set_color(_c)
	draw_text_transformed(x, y, text, image_xscale, image_yscale, image_angle)
	draw_set_color(c_white)
draw_set_visible_all(1)

#define counter_step
time -= current_time_scale
if time <= 0 instance_destroy()



#define fist_sprite(weapon, sprites)
if instance_is(self, Player){
	var _s = (race == "steroids" and bwep == weapon);
	if _s
		return sprites[1]
}
return sprites[0]

#define fist_init()
	is_fist = 1
	fistowner = other
	combotime = 60

#define fist_step(_p)
var _w = _p ? wep : bwep;
if !is_object(_w) {
	var s = _w
	_w = {
		wep : _w,
	}
	with _w {
		fist_init()
	}
	if _p wep = _w
	else bwep = _w
	mod_script_call("weapon", s, "fist_stats", _w)
}
else if !weapon_is_fist(_w){
	with _w {
		fist_init()
	}
	mod_script_call("weapon", _w.wep, "fist_stats", _w)
}
var f = fistinfo;
if f.dashtime > 0 and f.dashcheck == 0{
	f.dashtime -= current_time_scale
	speed = f.dashspeed
	direction = f.dashdir
}
if f.combotime > 0 and f.dashcheck == 0{
	f.combotime -= current_time_scale
	if f.combotime <= 0 and f.combo > 0{
		with counter_create(0, 1){
			text = string(f.combo) + " HIT" + (f.combo > 1 ? "S!" : "!")
			basecolor = merge_color(c_red, c_yellow, .2)
			blendcolor = c_yellow
			time *= 3
			image_angle = random_range(-10, 10)
		}
		fistinfo.combo = 0
	}
}
f.dashcheck = 1

// if !mouseAim {
// 	if (_p or (race == "steroids" and !_p)) and speed > friction {
// 		var b = sign(dsin(gunangle));
// 		if b != 0 back = b
// 		var e = sign(dcos(gunangle));
// 		if e != 0 right = e
// 	}
// }

var _k = abs(wkick), _b = abs(bwkick);
if _p {
	if wkick != 0 wkick -= clamp(wkick/8, -_k, _k) * current_time_scale
	wepflip = right
	wepangle = (_k + 1) * wepflip
}
else if race == "steroids"{
	if bwkick != 0 bwkick -= clamp(bwkick/8, -_b, _b) * current_time_scale
	bwepflip = right
	bwepangle = -(_b + 1) * bwepflip
}

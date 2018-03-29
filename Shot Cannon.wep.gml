#define init
global.sprShotCannon = sprite_add_weapon("sprites/Shot Cannon.png", 4, 2);
global.sprShotBullet = sprite_add("sprites/projectiles/Shot.png",2,8,8)
#define weapon_name
return "SHOT CANNON";

#define weapon_sprt
return global.sprShotCannon;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 25;

#define weapon_cost
return 8;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 7;

#define weapon_text
return "VORTEX-SHAPED DESTRUCTION";

#define weapon_fire
weapon_post(6,-8,9)
sound_play_pitch(sndFlakCannon,.8)
with instance_create(x,y,CustomProjectile) {
	motion_set(other.gunangle, 10 + random(2))
	team = other.team
	creator = other
	sprite_index = global.sprShotBullet
	image_speed = .5
	timer = 27
	ftimer = 2
	dirfac = random(359)
	on_hit = script_ref_create(actually_nothing)
	on_wall = script_ref_create(actually_nothing)
	on_step = script_ref_create(cannon_step)
	on_draw = script_ref_create(cannon_draw)
}

#define actually_nothing

#define cannon_step
image_angle+=6+speed*3
var _scl = random_range(.9,1.1);
image_xscale = _scl
image_yscale = _scl
if place_meeting(x + hspeed,y,Wall){
	hspeed *= -1
}
if place_meeting(x,y +vspeed,Wall){
	vspeed *= -1
}
if timer < 5{ftimer = 3}
if (current_frame % ftimer) = 0{
	var scale = random_range(0.9,1.1);
	image_xscale = 1.5*scale
	image_yscale = 1.5*scale
	dirfac += 10
	if speed >= 1{
		speed /= 1.25
	}
	else{
		speed = 0
	};
	if speed = 0 {
		var ang = dirfac;
		sound_play_pitchvol(sndShotgun, random_range(.8,1.2), .5)
		view_shake_at(x,y,5)
		repeat (5){
			with instance_create(x, y, Bullet2){
				team = other.team
				creator = other.creator
				motion_set(ang, 11)
				ang += 75
				image_angle = direction
			}
		}
		timer -= 1;
		if timer <= 0
		{
			instance_destroy()
		}
	}
}

#define cannon_draw
draw_sprite_ext(sprite_index, image_index, x, y, .8*image_xscale, .8*image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.25*image_xscale, 1.25*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);

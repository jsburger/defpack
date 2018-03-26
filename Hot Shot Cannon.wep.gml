#define init
global.sprHotShotCannon = sprite_add_weapon("Hot Shot Cannon.png", 4, 2);
global.sprHotShotBullet = sprite_add("FireShot.png",2,8,8)
#define weapon_name
return "HOT SHOT CANNON";

#define weapon_sprt
return global.sprHotShotCannon;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 25;

#define weapon_cost
return 15;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 14;

#define weapon_text
return "PROTOPLANETARY ANNIHILATION";

#define weapon_fire
weapon_post(6,-12,7)
sound_play(sndFireShotgun)
sound_play_pitch(sndFlakCannon,.8)
with instance_create(x,y,CustomProjectile) {
	motion_set(other.gunangle, 10 + random(2))
	team = other.team
	creator = other
	sprite_index = global.sprHotShotBullet
	image_speed = .5
	timer = 33
	ftimer = 2
	dirfac = random(359)
	dirfac2 = dirfac
	on_hit = script_ref_create(actually_nothing)
	on_wall = script_ref_create(actually_nothing)
	on_step = script_ref_create(cannon_step)
	on_draw = script_ref_create(cannon_draw)
}

#define actually_nothing

#define cannon_step
image_angle+=6+speed*3
var _scl = random_range(.8,1.2)
image_xscale = _scl
image_yscale = _scl
if place_meeting(x + hspeed,y,Wall){
	hspeed *= -1
}
if place_meeting(x,y +vspeed,Wall){
	vspeed *= -1
}
if timer < 6{ftimer = 3}
if (current_frame % ftimer) = 0{
	scale = random_range(0.9,1.1)
	image_xscale = 1.5*scale
	image_yscale = 1.5*scale
	dirfac += 9
	dirfac2 -= 12
	if speed >= 1{
		speed /= 1.25
	}
	else{
		speed = 0
	};
	if speed = 0 {
		view_shake_at(x,y,2)
		var ang = dirfac
		sound_play_pitchvol(sndFireShotgun, 1, .5)
		sound_play_pitchvol(sndIncinerator, random_range(.8,1.2), .5)
		repeat (5){
			with instance_create(x, y, FlameShell){
				team = other.team
				creator = other.creator
				motion_set(ang, 9)
				ang += 75
				image_angle = direction
			}
		}
		var ang2 = dirfac2
		repeat(3){
			with instance_create(x, y, FlameShell){
				team = other.team
				creator = other.creator
				motion_set(ang2, 11)
				ang2 += 120
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
draw_sprite_ext(sprite_index, image_index, x, y, 1.5*image_xscale, 1.5*image_yscale, image_angle, image_blend, 0.25);
draw_set_blend_mode(bm_normal);

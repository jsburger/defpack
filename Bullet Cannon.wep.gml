#define init
global.sprBulletCannon = sprite_add_weapon("Bullet Cannon.png", 4, 2);
#define weapon_name
return "BULLET CANNON";

#define weapon_sprt
return global.sprBulletCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 75;

#define weapon_cost
return 55;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 11;

#define weapon_text
return "GLASSY CANNON";

#define weapon_fire

weapon_post(6,-6,8)
sound_play(sndGrenade)
with instance_create(x,y,CustomProjectile)
{
	team = other.team
	creator = other
	speed = 20
	image_xscale *= 1.5
	image_yscale *= 1.5
	dir = random(359)
	timer = room_speed*2.5
	dirfac = random(359)
	sprite_index = sprAllyBullet
	direction = other.gunangle
	image_speed = 0
	on_step = script_ref_create(bullet_cannon)
	on_hit = script_ref_create(actually_nothing)
	on_wall = script_ref_create(actually_nothing)
	on_draw = script_ref_create(bullet_draw)
}

#define actually_nothing

#define bullet_cannon
if place_meeting(x + hspeed,y,Wall){
	hspeed *= -1
	sound_play_pitchvol(sndBouncerBounce,.5,1)
}
if place_meeting(x,y +vspeed,Wall){
	vspeed *= -1
	sound_play_pitchvol(sndBouncerBounce,.5,1)
}
if (current_frame % 2) = 0{
	scale = random_range(0.9,1.1)
	image_xscale = 1.5*scale
	image_yscale = 1.5*scale
	image_speed = 0
	dirfac += 10
	if speed >= 1{
		speed /= 1.4
	}
	else{
		speed = 0
	};
	if speed = 0 {
		var ang = dirfac
		sound_play_pitchvol(sndPistol, 1, .15)
		repeat (4){
			with instance_create(x, y, Bullet1){
				team = other.team
				creator = other.creator
				motion_set(ang, 12)
				ang += 90
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

#define bullet_draw
draw_sprite_ext(sprite_index, image_index, x, y, .8*image_xscale, .8*image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.5*image_xscale, 1.5*image_yscale, image_angle, image_blend, 0.25);
draw_set_blend_mode(bm_normal);

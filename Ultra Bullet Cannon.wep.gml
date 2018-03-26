#define init
global.sprUltraBulletCannon = sprite_add_weapon("Ultra Bullet Cannon.png", 4, 2);
global.sprUltraBulletCannonOff = sprite_add_weapon("Ultra Bullet Cannon Off.png", 4, 2);
#define weapon_name
return "ULTRA BULLET CANNON";

#define weapon_sprt
with(GameCont)
{
	if "rad" in self && rad >= 110 {return global.sprUltraBulletCannon};
	else {return global.sprUltraBulletCannonOff};
}

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 48;

#define weapon_cost
return 30;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 20;

#define weapon_text
return "ASTRAL DESTRUCTION";

#define weapon_rads
return 110

#define weapon_fire

weapon_post(6,-17,4)
sound_play(sndGrenade)
with instance_create(x,y,CustomProjectile)
{
	team = other.team
	creator = other
	speed = 20
	image_xscale *= 1.5
	image_yscale *= 1.5
	timer = 35
	dirfac = random(359)
	sprite_index = sprUltraBullet
	direction = other.gunangle
	image_speed = 0
	on_step = script_ref_create(bullet_cannon)
	on_hit = script_ref_create(actually_nothing)
	on_wall = script_ref_create(actually_nothing)
	on_draw = script_ref_create(bullet_draw)
}

#define actually_nothing

#define bullet_cannon
if instance_exists(enemy){with enemy{motion_add(point_direction(x,y,other.x,other.y),0.3)}}
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
	image_xscale = 1.2*scale
	image_yscale = 1.2*scale
	image_speed = 0
	dirfac += 34
	if speed >= 1{
		speed /= 1.4
	}
	else{
		speed = 0
	};
	if speed = 0 {
		var ang = dirfac
		view_shake_at(x,y,4)
		sound_play_pitchvol(sndUltraPistol, 1, .25)
		repeat (4){
			with instance_create(x, y, UltraBullet){
				team = other.team
				creator = other.creator
				motion_set(ang, 10)
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
draw_sprite_ext(sprite_index, image_index, x - 4, y, .8*image_xscale, .8*image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x - 8, y, 1.5*image_xscale, 1.5*image_yscale, image_angle, image_blend, 0.2);
draw_set_blend_mode(bm_normal);

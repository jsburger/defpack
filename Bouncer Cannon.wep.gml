#define init
global.sprBouncerBulletCannon = sprite_add_weapon("sprites/Bouncer Cannon.png", 4, 0);
#define weapon_name
return "BOUNCER CANNON";

#define weapon_sprt
return global.sprBouncerBulletCannon;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 65;

#define weapon_cost
return 35;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 14;

#define weapon_text
return "FRAGILE WOBBLING";

#define weapon_fire

weapon_post(6,-6,7)
sound_play(sndGrenade)
with instance_create(x,y,CustomProjectile)
{
	team = other.team
	creator = other
	speed = 14
	damage = 10
	force = 6
	friction = .16
	image_xscale *= 1.5
	image_yscale *= 1.5
	dir = random(359)
	timer = room_speed*2.5
	sprite_index = sprFlakBullet
	mask_index = sprAllyBullet
	direction = other.gunangle
	on_step = script_ref_create(bouncer_cannon)
	on_hit = script_ref_create(bouncer_hit)
	on_wall = script_ref_create(actually_nothing)
	on_draw = script_ref_create(bouncer_draw)
}

#define bouncer_hit
if place_meeting(x + hspeed,y,enemy){
	if "size" in self{if other.size >= 1{hspeed *= -1}}
	projectile_hit(other, damage, force, direction)
	sound_play_pitchvol(sndBouncerBounce,.5,1)
}
if place_meeting(x,y +vspeed,enemy){
	if "size" in self{if other.size >= 1{vspeed *= -1}}
	projectile_hit(other, damage, force, direction)
	sound_play_pitchvol(sndBouncerBounce,.5,1)
}

#define actually_nothing

#define bouncer_cannon
if place_meeting(x + hspeed,y,Wall){
	hspeed *= -1
	sound_play_pitchvol(sndBouncerBounce,.5,1)
}
if place_meeting(x,y +vspeed,Wall){
	vspeed *= -1
	sound_play_pitchvol(sndBouncerBounce,.5,1)
}
if (current_frame % 3) = 0{
	var scale = random_range(0.9,1.1);
	image_xscale = 1.5*scale
	image_yscale = 1.5*scale
	image_speed = 0
	if speed < 4 {
		speed = 4
		with instance_create(x,y,BouncerBullet)
		{
			team = other.team
			direction = other.direction-180+random_range(-5,5)*other.creator.accuracy
			speed = 5
			image_angle = direction
			creator = other.creator
		}
		timer -= 1;
		if timer <= 0
		{
			instance_destroy()
		}
	}
}

#define bouncer_draw
draw_sprite_ext(sprite_index, image_index, x, y, .8*image_xscale, .8*image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.5*image_xscale, 1.5*image_yscale, image_angle, image_blend, 0.25);
draw_set_blend_mode(bm_normal);

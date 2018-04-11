#define init
global.sprPsyBulletCannon = sprite_add_weapon("sprites/sprPsyBulletCannon.png", 4, 2);
global.sprPsyBullet 	 		= sprite_add("defpack tools/Psy Bullet.png", 2, 8, 8)
#define weapon_name
return "PSY BULLET CANNON";

#define weapon_sprt
return global.sprPsyBulletCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 200;

#define weapon_cost
return 120;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "replace me please";

#define weapon_fire
weapon_post(8,-6,42)
sound_play(sndGrenade)
with instance_create(x,y,CustomProjectile)
{
	team = other.team
	creator = other
	speed = 20
	image_xscale *= 1.5
	image_yscale *= 1.5
	dir = random(359)
	timer = room_speed*2
	dirfac = random(359)
	sprite_index = global.sprPsyBullet
	direction = other.gunangle
	image_speed = 0
	on_step = script_ref_create(bullet_cannon)
	on_hit = script_ref_create(actually_nothing)
	on_wall = script_ref_create(actually_nothing)
	on_draw = script_ref_create(bullet_draw)
}
repeat(40)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_purple)

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
if (current_frame % 4) = 0{
	scale = random_range(0.9,1.1)
	image_xscale = 1.5*scale
	image_yscale = 1.5*scale
	image_speed = 0
	dirfac += 10
	if speed >= 1{
		speed /= 1.3
	}
	else{
		speed = 0
	};
	if speed = 0 {
		var ang = dirfac
		sound_play_pitchvol(sndPistol, 1, .15)
		repeat (4){
			with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
				creator = other
				team = other.team
				motion_add(ang,5)
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

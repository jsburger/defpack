#define init
global.sprPsyShotCannon = sprite_add_weapon("sprites/Psy Shot Cannon.png", 4, 2);
global.ball = sprite_add("sprites/projectiles/psy flak ball.png",2,8,8)
global.eye = sprite_add("sprites/projectiles/psy bullet eye.png",1,1,1)
#define weapon_name
return "PSY SHOT CANNON";

#define weapon_sprt
return global.sprPsyShotCannon;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 43;

#define weapon_cost
return 12;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 14;

#define weapon_text
return "YOU GO NOW";

#define weapon_fire
weapon_post(6,-8,9)
sound_play_pitch(sndFlakCannon,.8)
sound_play_pitch(sndCursedPickup,.4)
sound_play_pitch(sndSwapCursed,.4)
sound_play_pitch(sndSwapCursed,.1)
with instance_create(x,y,CustomProjectile) {
	motion_set(other.gunangle, 10 + random(2))
	team = other.team
	creator = other
	sprite_index = global.ball
	image_speed = .7
	mask_index = mskFlakBullet
	timer = 32
	angle = 0
	on_hit = script_ref_create(actually_nothing)
	on_wall = script_ref_create(actually_nothing)
	on_step = script_ref_create(cannon_step)
	on_draw = script_ref_create(cannon_draw)
}

#define actually_nothing

#define cannon_step
if place_meeting(x + hspeed,y,Wall){
	hspeed *= -1
}
if place_meeting(x,y +vspeed,Wall){
	vspeed *= -1
}
if instance_exists(enemy) {angle = point_direction(x,y,instance_nearest(x,y,enemy).x,instance_nearest(x,y,enemy).y)}
else if instance_exists(creator) {angle = point_direction(x,y,creator.x,creator.y)}
if (current_frame % 3) = 0{
	var scale = random_range(0.9,1.1);
	image_xscale = 1.5*scale
	image_yscale = 1.5*scale
	accuracy = 1
	if speed >= 1{
		speed /= 1.25
	}
	else{
		speed = 0
	};
	if speed = 0 {
		sound_play_pitchvol(sndShotgun, 1, .5)
		view_shake_at(x,y,4)
		repeat (2){
			with mod_script_call("mod", "defpack tools", "create_psy_shell", x,y){
				creator = other.creator
				team = other.team
				motion_set(other.angle,12)
				image_angle = direction
			}
			angle += 180
		}
		timer -= 1;
	}
}
if timer <= 0
{
	instance_destroy()
}

#define cannon_draw
draw_sprite_ext(sprite_index, image_index, x, y, .8*image_xscale, .8*image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.25*image_xscale, 1.25*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);
draw_sprite(global.eye,0,x+lengthdir_x(3,angle),y+lengthdir_y(3,angle)) //spooky

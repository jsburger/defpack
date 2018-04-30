#define init
global.sprShotCannon = sprite_add_weapon("sprites/Shot Cannon.png", 4, 2);
global.sprShotBullet = sprite_add("sprites/projectiles/Shot.png",2,8,8)
sprite_collision_mask(global.sprShotBullet,1,1,0,0,0,0,0,0)
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
return 6;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 7;

#define weapon_text
return "VORTEX-SHAPED DESTRUCTION";

#define weapon_fire
weapon_post(6,-8,9)
sound_play_pitch(sndFlakCannon,.8)
with instance_create(x+lengthdir_x(12,gunangle),y+lengthdir_y(12,gunangle),CustomProjectile) {
	motion_set(other.gunangle, 15 + random(2))
    projectile_init(other.team,other)
	sprite_index = global.sprShotBullet
	damage = 6
	force = 6
	image_speed = .5
	timer = 16
	ftimer = 1.5
	time = ftimer
	canshoot = 0
	dirfac = random(359)
	on_hit = script_ref_create(cannon_hit)
	on_wall = script_ref_create(cannon_wall)
	on_step = script_ref_create(cannon_step)
	on_draw = script_ref_create(cannon_draw)
}

#define cannon_wall
move_bounce_solid(1)
speed *= .7

#define cannon_hit
if projectile_canhit_melee(other){
    projectile_hit_push(other,damage,force)
    dirfac += 12
	var ang = dirfac;
	sound_play_hit(sndShotgun,.4)
	view_shake_at(x,y,5)
	repeat (5){
		with instance_create(x, y, Bullet2){
			motion_set(ang, 11)
			projectile_init(other.team,other.creator)
			ang += 72
			image_angle = direction
		}
	}
	timer -= 1;
	if timer <= 0
	{
		instance_destroy()
	}
}


#define cannon_step
image_angle+=(6+speed*3)*current_time_scale
time -= current_time_scale

image_xscale = clamp(image_xscale + (random_range(-.05,.05)*current_time_scale),1.2,1.4)
image_yscale = image_xscale
speed /= 1 + (.1*current_time_scale)
if speed <= .2 canshoot = 1

while time <= 0{
    time += ftimer
    if canshoot{
    	dirfac += 12
		var ang = dirfac;
		sound_play_hit(sndShotgun,.4)
		view_shake_at(x,y,5)
		repeat (5){
			with instance_create(x, y, Bullet2){
				motion_set(ang, 11)
				projectile_init(other.team,other.creator)
				ang += 72
				image_angle = direction
			}
		}
		timer -= 1;
		if timer <= 0
		{
			instance_destroy()
			exit
		}
    }
}

#define cannon_draw
draw_sprite_ext(sprite_index, image_index, x, y, .8*image_xscale, .8*image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.25*image_xscale, 1.25*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);

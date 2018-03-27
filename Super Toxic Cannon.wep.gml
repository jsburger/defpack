#define init
global.sprSTC = sprite_add_weapon("sprites/STC.png", 7, 4);
#define weapon_name
return "SUPER TOXIC CANNON";

#define weapon_sprt
return global.sprSTC;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 155;

#define weapon_cost
return 8;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 14;

#define weapon_text
return choose("BETTER HAVE BRUCEPACK LOADED IN","WE COULD HAVE MADE IT BOUNCE AROUND");

#define weapon_fire
weapon_post(15,-30,15)
sound_play(sndToxicLauncher)
with instance_create(x+lengthdir_x(24,gunangle),y+lengthdir_y(24,gunangle),CustomProjectile){
	motion_set(other.gunangle,.8)
	sprite_index = sprFrogQueenBall
	image_angle = direction
	timer = 20
	mask_index = 1100
	team = other.team
	image_xscale = 2
	image_yscale = 2
	creator = other
	damage = 10
	dirfac = random(359)
	on_step = script_ref_create(toxic_step)
	on_destroy = script_ref_create(toxic_destroy)
	on_hit = nothing
}

#define nothing

#define toxic_destroy
if place_meeting(x + hspeed, y +vspeed, Wall){
	repeat (5){
		with instance_nearest(x,y,Wall) if point_distance(other.x, other.y, x, y) < 160 {
			instance_create(x,y,FloorExplo)
			instance_destroy()
		}
	}
}
repeat(20){
	with instance_create(x,y,ToxicGas){
		motion_set(random(359), random_range(2,3))
		creator = other.creator
	}
}

#define toxic_step
speed += 0.1
dirfac += 40/room_speed
if timer > 0 {
	timer -= 1
}
if timer = 1{sound_play(sndToxicBoltGas)}
if timer = 0{
	var ang = 0
	repeat (12){
		with instance_create(x,y,ToxicGas){
			motion_set(other.dirfac + ang, random_range(2,3))
			creator = other.creator
		}
		ang += 90
	}
	repeat(2){
		with instance_create(x,y,ToxicGas){
			motion_set(random(359), random_range(2,3))
			creator = other.creator
		}
	}
}

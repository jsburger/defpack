#define init
global.sprHotShotCannon = sprite_add_weapon("sprites/Hot Shot Cannon.png", 4, 2);
global.sprHotShotBullet = sprite_add("sprites/projectiles/FireShot.png",3,8,8)
wait(10)
sprite_collision_mask(global.sprHotShotBullet,1,1,0,0,0,0,0,0)
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
return 8;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 11;

#define weapon_text
return "PROTOPLANETARY ANNIHILATION";

#define weapon_fire
weapon_post(7,43,18)
sound_play(sndDoubleFireShotgun)
sound_play_pitch(sndFlakCannon,1.2)
sound_play_pitchvol(sndFlakExplode,random_range(.4,.7),.8)
sound_play_pitch(sndDoubleShotgun,1.2)
with instance_create(x+lengthdir_x(12,gunangle),y+lengthdir_y(12,gunangle),CustomProjectile) {
	motion_set(other.gunangle, 15 + random(2))
	team = other.team
	creator = other
	sprite_index = global.sprHotShotBullet
	damage = 2
	force = 2
	image_speed = .4
	timer = 16
	ftimer = 1.5
	time = ftimer
	canshoot = 0
	dirfac = random(359)
	dirfac2 = dirfac
	on_hit = script_ref_create(cannon_hit)
	on_wall = script_ref_create(cannon_wall)
	on_step = script_ref_create(cannon_step)
	on_draw = script_ref_create(cannon_draw)
}

#define cannon_wall
view_shake_at(x,y,20)
sound_play_pitch(sndShotgunHitWall,.8)
if skill_get(15){speed ++;image_index = 0}
move_bounce_solid(1)
speed *= .7
	repeat(irandom(1)+2){
	with instance_create(x, y, FlameShell){
		motion_set(random(360), random_range(8, 12))
		projectile_init(other.team,other.creator)
		image_angle = direction
	}
}

#define cannon_hit
x = xprevious
y = yprevious
projectile_hit_push(other,damage,force)
dirfac += 9
dirfac2 -= 12
view_shake_at(x,y,4)
var ang = dirfac
sound_play_pitchvol(sndFireShotgun, 1, .5)
sound_play_pitchvol(sndIncinerator, random_range(.8,1.2), .5)
repeat (5){
	with instance_create(x, y, FlameShell){
		team = other.team
		creator = other.creator
		motion_set(ang, 9)
		ang += 72
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


#define cannon_step
image_angle+=(6+speed*3)*current_time_scale
time -= current_time_scale

if image_index >= 2.5{image_index = 1}

image_xscale = clamp(image_xscale + (random_range(-.05,.05)*current_time_scale),1.2,1.4)
image_yscale = image_xscale
if timer = 4 ftimer = 3
speed /= 1 + (.1*current_time_scale)
if speed <= 1 {canshoot = 1; speed = 0}

while time <= 0{
    time += ftimer
    if canshoot{
    	dirfac += 9
    	dirfac2 -= 12
    	view_shake_at(x,y,4)
		var ang = dirfac
		sound_play_pitchvol(sndFireShotgun, 1, .5)
		sound_play_pitchvol(sndIncinerator, random_range(.8,1.2), .5)
		repeat (5){
			with instance_create(x, y, FlameShell){
				team = other.team
				creator = other.creator
				motion_set(ang, 9)
				ang += 72
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
			exit
		}
    }
}


/*#define cannon_step
image_angle+=6+speed*3
if image_index >= 2.5 image_speed = 0
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
		view_shake_at(x,y,4)
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
}*/

#define cannon_draw
if image_index = 0{var i = .5}else{var i = .1}
draw_sprite_ext(sprite_index, image_index, x, y, .7*image_xscale+i, .7*image_yscale+i, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.25*image_xscale+i*2, 1.25*image_yscale+i*2, image_angle, image_blend, i);
draw_set_blend_mode(bm_normal);

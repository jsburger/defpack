#define init
global.sprUltraShotCannon = sprite_add_weapon("sprites/Ultra Shot Cannon.png", 4, 2);
global.sprUltraShotCannonOff = sprite_add_weapon("sprites/Ultra Shot Cannon Off.png", 4, 2);
global.sprUltraShotBullet = sprite_add("sprites/projectiles/UltraShot.png",3,8,8)
sprite_collision_mask(global.sprUltraShotBullet,1,1,0,0,0,0,0,0)
#define weapon_name
return "ULTRA SHOT CANNON";

#define weapon_sprt
with(GameCont)
{
	if "rad" in self && rad >= 130 {return global.sprUltraShotCannon};
	else {return global.sprUltraShotCannonOff};
}

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
return 20;

#define weapon_rads
return 130

#define weapon_text
return "GREEN GALAXY OF TORMENT";

#define weapon_fire
weapon_post(7,-43,33)
sound_play_pitch(sndFlakCannon,1.2)
sound_play_pitch(sndSuperFlakExplode,1.4)
sound_play_pitchvol(sndFlakExplode,random_range(.4,.7),.8)
sound_play_pitch(sndDoubleShotgun,1.2)
sound_play_pitch(sndUltraGrenade,1.2)
with instance_create(x,y,CustomProjectile) {
	motion_set(other.gunangle, 18 + random(2))
	team = other.team
	creator = other
	sprite_index = global.sprUltraShotBullet
	image_speed = .45
	timer = 16
	ftimer = 2
	dirfac = random(359)
	dirfac2 = dirfac
	on_hit = script_ref_create(cannon_hit)
	on_wall = script_ref_create(cannon_wall)
	on_step = script_ref_create(cannon_step)
	on_draw = script_ref_create(cannon_draw)
}

#define cannon_hit
if projectile_canhit_melee(other){
    projectile_hit_push(other,damage,force)
    dirfac += 12
	var ang = dirfac;
	sound_play_hit(sndShotgun,.4)
	view_shake_at(x,y,12)
	repeat (5){
		sleep(50)
		with instance_create(x, y,UltraShell){
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

#define cannon_wall
view_shake_at(x,y,32)
sleep(30)
sound_play_pitch(sndShotgunHitWall,.8)
if skill_get(15){speed ++;image_index = 0}
move_bounce_solid(1)
speed *= .8
	repeat(irandom(1)+2){
	with instance_create(x, y, UltraShell){
		motion_set(random(360), random_range(12, 14))
		projectile_init(other.team,other.creator)
		image_angle = direction
	}
}

#define cannon_step
image_angle+=8+speed*3
if image_index >= 2.5{image_index = 1}
if instance_exists(enemy){with enemy{motion_add(point_direction(x,y,other.x,other.y),0.3)}}
if timer < 6{ftimer = 3}
if (current_frame % ftimer) = 0{
	dirfac += 10
	dirfac2 -= 20
	if speed >= 1{
		speed /= 1.25
	}
	else{
		speed = 0
	};
	if speed = 0 {
		var ang = dirfac
		var ang2 = dirfac2
		sound_play_pitchvol(sndShotgun, 1, .5)
		sound_play_pitchvol(sndUltraShotgun, random_range(.8,1.2), .5)
		repeat (2){
			with instance_create(x, y, UltraShell){
				team = other.team
				creator = other.creator
				motion_set(ang, 12)
				ang += 180
				image_angle = direction
			}
			with instance_create(x, y, UltraShell){
				team = other.team
				creator = other.creator
				motion_set(ang2, 8)
				ang2 += 180
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
if image_index = 0{var i = .5}else{var i = .1}
draw_sprite_ext(sprite_index, image_index, x, y, .7*image_xscale+i, .7*image_yscale+i, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.25*image_xscale+i*2, 1.25*image_yscale+i*2, image_angle, image_blend, i);
draw_set_blend_mode(bm_normal);

/*
#define weapon_fire

wkick = 8
if GameCont.rad >= 120
{
	GameCont.rad -= 120
	sound_play(sndGrenadeShotgun)
	with instance_create(Player.x+lengthdir_x(sprite_height,point_direction(Player.x,Player.y,mouse_x,mouse_y)),Player.y+lengthdir_y(sprite_height,point_direction(Player.x,Player.y,mouse_x,mouse_y)),CustomObject)
	{
	team = other.team
	speed = 11
	dir = random(359)
	damage = 60
	timer = 60
	dirfac = random(359)
	dirfac2 = dirfac
	sprite_index = sprUltraShell
	image_index = 0
	direction = point_direction(x,y,mouse_x,mouse_y)
	do
	{
			if place_meeting(x+3,y,Wall) || place_meeting(x-3,y,Wall)
			{
				hspeed *= -1
			}
			if place_meeting(x,y+3,Wall) || place_meeting(x,y-3,Wall)
			{
				vspeed *= -1
			}
			scale = random_range(0.9,1.1)
			image_speed = 0
			dirfac += 10
			dirfac2 -= 20
			image_xscale = 1.2*scale
			image_yscale = 1.2*scale
			if speed > 1.0000000001
			{
				speed /= 1.6
			}
			else
			{
				speed = 0
				if x = xprevious && y = yprevious && timer > 1
				{
						sound_play(sndUltraShotgun)
						with instance_create(x,y,UltraShell)
						{
							team = other.team
							if instance_exists(CustomObject)
							{
								direction = instance_nearest(x,y,CustomObject).dirfac
							}
							else
							{
								instance_destroy()
							}
							speed = 22
							image_angle = direction
						}
						with instance_create(x,y,UltraShell)
						{
							team = other.team
							if instance_exists(CustomObject)
							{
								direction = instance_nearest(x,y,CustomObject).dirfac-180
							}
							else
							{
								instance_destroy()
							}
							speed = 22
							image_angle = direction
						}
						with instance_create(x,y,UltraShell)
						{
							team = other.team
							if instance_exists(CustomObject)
							{
								direction = instance_nearest(x,y,CustomObject).dirfac2
							}
							else
							{
								instance_destroy()
							}
							speed = 11
							image_angle = direction
						}
						with instance_create(x,y,UltraShell)
						{
							team = other.team
							if instance_exists(CustomObject)
							{
								direction = instance_nearest(x,y,CustomObject).dirfac2-180
							}
							else
							{
								instance_destroy()
							}
							speed = 11
							image_angle = direction
						}
				}
					timer -= 1
					if timer <= 0
					{
						instance_destroy()
					}
			}
		wait 2
	}while (instance_exists(self))
	}
}
else
{
	sound_play(sndUltraEmpty)
	ammo[2] += 10
	with instance_create(x,y,PopupText)
	{
		mytext = "NOT ENOUGH RADS"
	}
}

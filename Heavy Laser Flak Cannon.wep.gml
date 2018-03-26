#define init
global.sprHeavyLaserFlakCannon = sprite_add_weapon("Heavy Laser Flak Cannon.png", 2, 4);
global.sprLaserFlakBullet = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAACAAAAAQCAYAAAB3AH1ZAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAADDSURBVEhL7ZQxFsIwDENzNI7GzQO2okQ1MaavAwx8vSy1JHtqu93bfL3jtb4X55q5jC7XZe+kR2TwWL6Us8spy+wOmAvFa5rfIzuzKaIzKhZmXaqXI2Ko4uhFh6E9GWuODJifoQr1ugY8oAIeZABqxuAzNOMVY7mpYvksacxP/wN+4ABThXpdAx5RAQ8yDoNUxdGLDkN7MtYcGUeDqojOqEPRk6xLFTPf/xVbydkjzMtcBhfypbCIR7hZlqk418w1WnsAq2ceLVskifwAAAAASUVORK5CYII=",2, 7, 7);


#define weapon_name
return "HEAVY LASER FLAK CANNON";

#define weapon_sprt
return global.sprHeavyLaserFlakCannon;

#define weapon_type
return 5;

#define weapon_auto
return true;

#define weapon_load
return 38;

#define weapon_cost
return 8;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 13;

#define weapon_text
return "OH JOY HAS COME";

#define weapon_fire

sound_play(sndLaserCannonCharge)
with instance_create(x,y,CustomProjectile)
{
	motion_add(other.gunangle+(random(12)-6)*other.accuracy,11+random(2))
	image_angle = direction
	team = other.team
	typ = 2
	creator = other
	sprite_index = global.sprLaserFlakBullet
	image_speed = 0
	damage = 30 + skill_get(17)*15
	image_speed = 0
	force = 30
	image_xscale = 0.1
	image_yscale = 0.1
	timer = 3
	check = 0
	Bulletmass_origin = 12
	Bulletmass = Bulletmass_origin
	ammo_origin = 3
	ammo = ammo_origin
	offset = random(359)
	mask_index = mskFlakBullet
	on_draw = script_ref_create(laserflak_draw)
	on_hit = script_ref_create(hlaserflak_hit)
	on_step = script_ref_create(hlaserflak_step)
	on_wall = script_ref_create(actually_nothing)
}

#define hlaserflak_step
image_angle = direction
if check != 0
{
	if place_meeting(x + hspeed,y,Wall){
		hspeed *= -1
		sound_play_pitchvol(sndBouncerBounce,.5,1)
		}
	if place_meeting(x,y +vspeed,Wall){
		vspeed *= -1
		sound_play_pitchvol(sndBouncerBounce,.5,1)
	}
	image_speed = 1
}
if check = 0
{
	if instance_exists(creator)
	{
		x = creator.x+lengthdir_x(17*image_xscale-sprite_width/2,creator.gunangle)
		y = creator.y+lengthdir_y(17*image_xscale-sprite_width/2,creator.gunangle)
		direction = creator.gunangle
	}
	else {instance_destroy()}
	image_xscale += 1.6/room_speed
	image_yscale += 1.6/room_speed
	if image_xscale >= 1.1
	{
		check = 1
		sound_play(sndFlakCannon)
		sound_play(sndLaser)
		creator.wkick = 8
	}
}
if check = 1
{
	if irandom(2-skill_get(17)) = 1
	{
		with instance_create(x+random_range(-8,8),y+random_range(-8,8),PlasmaTrail)
		{
			image_xscale += skill_get(17)/3
			image_yscale = image_xscale
		}
	}
	friction = 0.6
	if irandom(1) = 1
	{
		instance_create(x+random_range(-4,4),y+random_range(-4,4),Smoke)
	}
	if speed <= 0
	{
		check = 2
		sound_play(sndLaserCannonCharge)
	}
}
if check = 2 || (check = 1 && place_meeting(x+hspeed,y+vspeed,Wall))
{
	timer -= 1
	if timer = 0 && ammo > 0
	{
		timer = 3
		repeat(Bulletmass)
		{
			if skill_get(17)
			sound_play(sndLaserCannonUpg)
			else
			sound_play(sndLaserCannon)
			//EAGLE EYES SYNERGY
			if skill_get(19) = false
			{
				with instance_create(x,y,Laser)
				{
					image_angle = random(360)-7*(other.ammo_origin-other.ammo)
					team = other.team
					event_perform(ev_alarm,0)
				}
			}
			else
			{
				with instance_create(x,y,Laser)
				{
					image_angle = other.offset-7*(other.ammo_origin-other.ammo)
					team = other.team
					event_perform(ev_alarm,0)
				}
				offset += 360/Bulletmass_origin
			}
		}
		ammo -= 1
		if ammo = 0{instance_destroy()}
	}
}

#define laserflak_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.75*image_xscale, 1.75*image_yscale, image_angle, image_blend, 0.25);
draw_set_blend_mode(bm_normal);

#define hlaserflak_hit
if projectile_canhit_melee(other){
	projectile_hit_push(other,damage,force)
}

#define actually_nothing

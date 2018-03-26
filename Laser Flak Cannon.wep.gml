#define init
global.sprLaserFlakCannon = sprite_add_weapon("Laser Flak Cannon.png", 2, 4);
global.sprLaserFlakBullet = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAACAAAAAQCAYAAAB3AH1ZAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAADDSURBVEhL7ZQxFsIwDENzNI7GzQO2okQ1MaavAwx8vSy1JHtqu93bfL3jtb4X55q5jC7XZe+kR2TwWL6Us8spy+wOmAvFa5rfIzuzKaIzKhZmXaqXI2Ko4uhFh6E9GWuODJifoQr1ugY8oAIeZABqxuAzNOMVY7mpYvksacxP/wN+4ABThXpdAx5RAQ8yDoNUxdGLDkN7MtYcGUeDqojOqEPRk6xLFTPf/xVbydkjzMtcBhfypbCIR7hZlqk418w1WnsAq2ceLVskifwAAAAASUVORK5CYII=",2, 7, 7);


#define weapon_name
return "LASER FLAK CANNON";

#define weapon_sprt
return global.sprLaserFlakCannon;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 23;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 7;

#define weapon_text
return "1/10";

#define weapon_fire
weapon_post(5,-13,5)
sound_play(sndFlakCannon)
sound_play(sndLaser)
with instance_create(x+lengthdir_x(sprite_height-6,gunangle),y+lengthdir_y(sprite_height-6,gunangle),CustomProjectile)
{
	direction = other.gunangle+(random(12)-6)*other.accuracy
	image_angle = direction
	speed = 11+random(2)
	team = other.team
	sprite_index = global.sprLaserFlakBullet
	image_speed = 1
	damage = 20
	Bulletmass_origin = 15
	Bulletmass = Bulletmass_origin
	offset = random(360)
	mask_index = mskFlakBullet
	on_draw = script_ref_create(laserflak_draw)
	if skill_get(17)
	{
		image_xscale = 1.2
		image_yscale = 1.2
		damage += 10
	}
	do
	{
		if irandom(2-skill_get(17)) = 1
		{
			with instance_create(x+random_range(-8,8),y+random_range(-8,8),PlasmaTrail)
			{
				image_xscale += skill_get(17)/3
				image_yscale = image_xscale
			}
		}
		speed -= 0.5
		if irandom(1) = 1
		{
			instance_create(x+random_range(-4,4),y+random_range(-4,4),Smoke)
		}
		if speed <= 0 || place_meeting(x+lengthdir_x(16,direction),y+lengthdir_y(16,direction),enemy) || place_meeting(x+lengthdir_x(16,direction),y+lengthdir_y(16,direction),Wall) || place_meeting(x+lengthdir_x(16,direction),y+lengthdir_y(16,direction),prop)
		{
			if skill_get(17)
			sound_play(sndLaserUpg)
			else
			sound_play(sndLaser)
			repeat(Bulletmass)
			{
				//EAGLE EYES SYNERGY
				if skill_get(19) = false
				{
					with instance_create(x,y,Laser)
					{
						image_angle = random(359)
						team = other.team
						event_perform(ev_alarm,0)
					}
				}
				else
				{
					with instance_create(x,y,Laser)
					{
						image_angle = other.offset
						team = other.team
						event_perform(ev_alarm,0)
					}
					offset += 360/Bulletmass_origin
				}
			}
			instance_destroy()
		}
		wait(1)
	}while(instance_exists(self))

}

#define laserflak_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.75*image_xscale, 1.75*image_yscale, image_angle, image_blend, 0.25);
draw_set_blend_mode(bm_normal);

#define flakdraw
draw_self()
draw_set_blend_mode(bm_add)
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale*1.5,image_yscale*1.5,image_angle,image_blend,.15)
draw_set_blend_mode(bm_normal)

#define init
global.sprLaserFlakCannon = sprite_add_weapon("sprites/sprLaserFlakCannon.png", 2, 4);
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
return 4;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 7;

#define weapon_text
return "1/10";

#define weapon_fire
weapon_post(6,-13,33)
sound_play(sndFlakCannon)
sound_play(sndLaser)
with instance_create(x,y,CustomProjectile)
{
	move_contact_solid(other.gunangle,8)
	motion_add(other.gunangle+random_range(-6,6)*other.accuracy,12)
	image_angle = direction
	team = other.team
	image_speed = 1
	accuracy = other.accuracy
	damage = 8 + skill_get(17)*3
	friction = .5
	ammo = 12
	sprite_index = global.sprLaserFlakBullet
	mask_index = mskFlakBullet
	on_hit      = laserflak_hit
	on_draw     = laserflak_draw
	on_step     = laserflak_step
	on_destroy  = laserflak_destroy
	if skill_get(17)
	{
		image_xscale = 1.2
		image_yscale = 1.2
	}
}

#define laserflak_hit
if projectile_canhit_melee(other) = true
{
	var k = other.my_health;
	projectile_hit(other,damage,ammo,direction)
	repeat(3) with instance_create(x,y,PlasmaTrail)
	{
		view_shake_at(x,y,8)
		motion_add(random(180),random_range(7,8))
	}
	damage -= k
	if damage <= 0 instance_destroy()
}

#define laserflak_destroy
view_shake_at(x,y,32)
var i = random(360);
if skill_get(17) sound_play(sndLaserUpg) else sound_play(sndLaser)
repeat(ammo)
{
	repeat(2) with instance_create(x,y,PlasmaTrail)
	{
		motion_add(random(360),random_range(5,12))
	}
	with instance_create(x,y,Laser)
	{
		image_angle = i+random_range(-32,32)*other.accuracy
		team = other.team
		event_perform(ev_alarm,0)
	}
	i += 360/ammo
}

#define laserflak_step
if irandom(2) != 0
{
	with instance_create(x+random_range(-8,8),y+random_range(-8,8),PlasmaTrail)
	{
		image_xscale += skill_get(17)/3
		image_yscale = image_xscale
	}
}
/*if irandom(1) = 1
{
	instance_create(x+random_range(-4,4),y+random_range(-4,4),Smoke)
}
*/
if speed < friction instance_destroy()

#define laserflak_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.75*image_xscale, 1.75*image_yscale, image_angle, image_blend, 0.25);
draw_set_blend_mode(bm_normal);

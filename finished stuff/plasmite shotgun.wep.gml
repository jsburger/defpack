#define init
global.sprMagnetBomber = sprite_add_weapon("sprMagnetBomber.png",1,2)
global.sprMagnetBomb = sprite_add("sprMagnetBomb.png",0,3,3)
#define weapon_name
return "PLASMITE SHOTGUN"
#define weapon_sprt
return global.sprMagnetBomber;
#define weapon_type
return 5
#define weapon_cost
return 2
#define weapon_area
return 6
#define weapon_load
return 18
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return 1
#define weapon_laser_sight
return 0
#define weapon_text
return "JOY BURST";
#define weapon_fire
weapon_post(6,0,18)
if !skill_get(17)
{
	sound_play_pitch(sndPlasma,2)
	sound_play_pitch(sndPlasmaRifle,random_range(1.3,1.45))
}
else
{
	sound_play_pitch(sndPlasmaUpg,2)
	sound_play_pitch(sndPlasmaRifleUpg,random_range(1.3,1.45))
}
repeat(5)
with instance_create(x,y,CustomProjectile)
{
	creator = other
	team = other.team
	sprite_index = sprBullet1
	image_speed = 0
	image_index = 0
	damage = 2+skill_get(17)
	sprite_index = global.sprMagnetBomb
	fric = random_range(1.1,1.2)
	motion_set(other.gunangle+random_range(-14,14)*other.accuracy,random_range(11,17))
	speedset = 0
	maxspeed = 7
	on_step 	 = mb_step
	on_wall 	 = mb_wall
	on_destroy = mb_destroy
}

#define mb_step
image_angle = direction
if irandom(12-skill_get(17)*5) = 1{instance_create(x,y,PlasmaTrail)}
if speedset = 0
{
	move_bounce_solid(false)
	speed/= fric
	if speed < 1.00005{speedset = 1}
}
else
{
	if instance_exists(enemy)
	{
		var closeboy = instance_nearest(x,y,enemy)
		motion_add(point_direction(x,y,closeboy.x,closeboy.y),.5+skill_get(17)*.3)
		if speed > maxspeed{speed = maxspeed}
	}
	else motion_add(direction,.5)
}

#define mb_wall
instance_destroy()

#define mb_destroy
sound_play_pitch(sndPlasmaHit,random_range(1.55,1.63))
with instance_create(x,y,PlasmaImpact){image_xscale=.5;image_yscale=.5;damage-=1}

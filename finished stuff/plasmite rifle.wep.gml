#define init
global.sprPlasmiteRifle = sprite_add_weapon("sprPlasmiteRifle.png",0,1)
global.sprMagnetBomb = sprite_add("sprMagnetBomb.png",0,3,3)
#define weapon_name
return "PLASMITE RIFLE"
#define weapon_sprt
return global.sprPlasmiteRifle;
#define weapon_type
return 5
#define weapon_cost
return 1
#define weapon_area
return 6
#define weapon_load
return 7
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return 1
#define weapon_laser_sight
return 0
#define weapon_text
return "AH AH";
#define weapon_fire
repeat(2)
{
	weapon_post(4,0,4)
	if !skill_get(17)
	{
		sound_play_pitch(sndPlasma,2)
		sound_play_pitch(sndPlasmaMinigun,random_range(1.3,1.45))
	}
	else
	{
		sound_play_pitch(sndPlasmaUpg,2)
		sound_play_pitch(sndPlasmaMinigunUpg,random_range(1.3,1.45))
	}
	with instance_create(x,y,CustomProjectile)
	{
		creator = other
		team = other.team
		image_speed = 0
		image_index = 0
		damage = 2+skill_get(17)
		sprite_index = global.sprMagnetBomb
		fric = random_range(1.25,1.37)
		motion_set(other.gunangle+random_range(-6,6)*other.accuracy,random_range(14,19))
		speedset = 0
		maxspeed = 7
		on_step 	 = mb_step
		on_wall 	 = mb_wall
		on_destroy = mb_destroy
		wait(3)
	}
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
with instance_create(x,y,PlasmaImpact){image_xscale=.5;image_yscale=.5;damage = round(damage/2)}

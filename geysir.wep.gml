#define init
global.sprGeysir 		= sprite_add_weapon("sprites/sprGeysir.png", 9, 8);
global.sprWaterBeam = sprite_add("sprites/projectiles/sprWaterBeam.png",0,1,6);
global.mskWaterBeam = sprite_add("sprites/projectiles/mskWaterBeam.png",0,1,6);

#define weapon_name
return "GEYSIR";

#define weapon_sprt
return global.sprGeysir;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 25;

#define weapon_cost
return 8;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 15;

#define weapon_text
return "VERY HOT";

#define weapon_fire
with instance_create(x,y,CustomObject)
{
	creator = other
	team = other.team
	gunangle = other.gunangle
	ammo = weapon_get_load(mod_current)+1
	on_step = charge_step
}

#define charge_step
if !instance_exists(creator){instance_delete(self);exit}
x = creator.x+creator.hspeed
y = creator.y+creator.vspeed
gunangle = creator.gunangle
with instance_create(x,y+vspeed,CustomSlash)
{
	name = "geysir beam"
	team = other.team
	creator = other.creator
	ammo = 2
	maxammo = ammo
	image_speed = 0
	dir = 0
	startx = x
	starty = y
	image_yscale = 1
	direction = other.gunangle
	image_angle = direction - 180
	sprite_index = global.sprWaterBeam
	mask_index   = global.mskWaterBeam
	on_wall 		  = beam_wall
	on_step 			= beam_step
	on_hit  			= beam_hit
	on_projectile = beam_projectile
}
ammo--
if ammo <= 0{instance_destroy()}

#define beam_step
do
{
	dir++;x+=lengthdir_x(1,direction);y+=lengthdir_y(1,direction);
}
until dir >= 500 || place_meeting(x,y,Wall)
image_xscale = dir
//hitme collision
with instances_matching_ne(hitme,"team",other.team)
{
	if place_meeting(x,y,other)
	{
		speed = 0
		motion_set(other.direction,2/max(size,1))
	}
}
ammo--
if ammo = 1
{
	instance_create(x,y,FishBoost)
}
x = startx + lengthdir_x(dir,direction) * ammo
y = starty + lengthdir_y(dir,direction) * ammo
if ammo <= 0 instance_destroy()

#define beam_wall

#define beam_hit
if projectile_canhit_melee(other)
{
	with other
	{
			if place_meeting(x+hspeed,y+vspeed,Wall)
			{
				with instance_create(x,y,Bullet1)
				{
					damage = 2
				}
			}
	}
}

#define beam_projectile
with other
{
	team = -10
	if "_s" not in self _s = speed
	motion_add(other.direction,.5)
	image_angle = direction
	if speed > _s speed = _s
}

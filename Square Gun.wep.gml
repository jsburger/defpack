#define init
global.sprSquareGun = sprite_add_weapon("sprites/Square Gun.png", 0, 2);
global.sprSquare = sprite_add("sprites/projectiles/Square.png", 0, 7, 7)
global.mskSquare = sprite_add("sprites/projectiles/Square mask.png",0,5,5)
global.sprMagnetBomb = sprite_add("finished stuff/sprMagnetBomb.png",0,3,3)
//global.sprSquareTP = sprite_add("Square TP start.png", 5, 5, 5)

#define weapon_name
return "SQUARE GUN"

#define weapon_sprt
return global.sprSquareGun;

#define weapon_type
return 5;

#define weapon_auto
return true;

#define weapon_load
return 12;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 12;

#define weapon_text
return choose("NO HIDING NOW","LOOK AT THIS NERD");

#define weapon_fire

if skill_get(17){sound_play(sndPlasmaUpg)}else{sound_play(sndPlasma)}
weapon_post(4,-5,7)

with instance_create(x,y,CustomProjectile)
{
	typ = 1
	name = "square"
	creator = other
	size = 1
	motion_add(other.gunangle+random_range(-6,6)*creator.accuracy,0)//5+skill_get(17)*3
	friction = .3
	bounce = 7+skill_get(17)*3
	damage = 2
	image_xscale = 1+skill_get(17)*.3
	image_yscale = 1+skill_get(17)*.3
	force = 6
	iframes = 0
	team = other.team
	anglefac = random_range(0.8,2.5)
	fac = choose(1,-1)
	mask_index = global.mskSquare
	istp = false
	hitframes = 0
	lifetime = room_speed * 6
	sprite_index = global.sprSquare
	on_step = square_step
	on_hit = square_hit
	on_wall = actually_nothing
	on_draw = square_draw
	on_destroy = square_destroy
}

#define square_destroy
sound_play_pitch(sndPlasmaHit,random_range(.9,1.1))
with instance_create(x,y,PlasmaImpact){team = other.team;image_xscale=2;image_yscale=2}

#define square_hit
if speed > 2{projectile_hit(other, round(5*damage), force, direction)}else{hitframes += 1;projectile_hit(other, damage, force, direction)};

#define square_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);

#define actually_nothing

#define square_step
if "childs" in self
{
	with enemy{if !collision_line(x,y,other.x,other.y,Wall,0,0){motion_add(point_direction(x,y,other.x,other.y),other.childs/size/200)}}
}
if speed > 2
{
	with instance_create(x+random_range(-8,8),y+random_range(-8,8),PlasmaImpact)
	{
		image_index = 1
		image_speed = 0.3-skill_get(17)*0.05
		image_xscale = .25
		image_yscale = .25
		with Smoke if place_meeting(x,y,other) instance_destroy()
	}
}
with instance_create(x+random_range(-8,8),y+random_range(-8,8),PlasmaTrail)
{
	image_speed = 0.35-skill_get(17)*0.05
	image_xscale += skill_get(17)/2
	image_yscale = image_xscale
}
if iframes <= 0
{
	with EnergyShank
	{
		if place_meeting(x,y,other)
		{
				with instance_create(other.x,other.y,GunGun){image_index=2}
				if other.bounce<7{other.bounce++};
				if other.speed <20{with other{direction=other.direction;speed=9}}
				sound_play_pitch(sndPlasmaBigExplode,1.4)
				sound_play_pitch(sndPlasmaHit,2.2)
				if skill_get(17){sound_play_pitch(sndPlasmaBigExplodeUpg,2.2)}
				other.iframes += 10*image_speed
		}
	}
	with EnergySlash
	{
		if place_meeting(x,y,other)
		{
				with instance_create(other.x,other.y,GunGun){image_index=2}
				if other.bounce<7{other.bounce++};
				with other{direction=other.direction;speed=12}
				sound_play_pitch(sndPlasmaBigExplode,1.4)
				sound_play_pitch(sndPlasmaHit,2.2)
				if skill_get(17){sound_play_pitch(sndPlasmaBigExplodeUpg,2.2)}
				other.iframes += 10*image_speed
		}
	}
	with EnergyHammerSlash
	{
		if place_meeting(x,y,other)
		{
				with instance_create(other.x,other.y,GunGun){image_index=2}
				if other.bounce<7{other.bounce++};
				with other{direction=other.direction;speed=17}
				sound_play_pitch(sndPlasmaBigExplode,1.4)
				sound_play_pitch(sndPlasmaHit,2.2)
				if skill_get(17){sound_play_pitch(sndPlasmaBigExplodeUpg,2.2)}
				other.iframes += 10*image_speed
		}
	}
}
else{iframes--}
with instances_matching(Laser,"team",other.team)//Laser interaction
{
	if place_meeting(x,y,other)
	{
		if "flag" not in self
		{
			x = other.x
			y = other.y
			flag = other
			image_xscale = point_distance(x,y,xstart,ystart)/2
		}
		else
		{
				if flag != other
				{
					x = other.x
					y = other.y
					image_xscale = point_distance(x,y,xstart,ystart)/2
					if irandom(2)=0{exit}
				}
				else{exit}
		}
		with other
		{
				sound_play(sndLaser)
				with instance_create(x+lengthdir_x(speed,direction), y+lengthdir_y(speed,direction),Laser)
				{
					image_angle = (other.image_angle + random_range(-3,3) * other.creator.accuracy);
					//insert additional projectile things here
					alarm0 = 1
					team = other.team;
					creator = other
					flag = other
				}
				with instance_create(x+lengthdir_x(speed,direction), y+lengthdir_y(speed,direction),Laser)
				{
					image_angle = (other.image_angle + 90 + random_range(-3,3) * other.creator.accuracy);
					//insert additional projectile things here
					alarm0 = 1
					team = other.team;
					creator = other
					flag = other
				}
				with instance_create(x+lengthdir_x(speed,direction), y+lengthdir_y(speed,direction),Laser)
				{
					image_angle = (other.image_angle - 90 + random_range(-3,3) * other.creator.accuracy);
					//insert additional projectile things here
					alarm0 = 1
					team = other.team;
					creator = other
					flag = other
				}
				with instance_create(x+lengthdir_x(speed,direction), y+lengthdir_y(speed,direction),Laser)
				{
					image_angle = (other.image_angle + 180 + random_range(-3,3) * other.creator.accuracy);
					//insert additional projectile things here
					alarm0 = 1
					team = other.team;
					creator = other
					flag = other
				}
		}
	}
}
with instances_matching(CustomProjectile,"name","square")
{
	if place_meeting(x,y,other)
	{
		other.hitframes++
		direction = point_direction(other.x,other.y,x,y)
		with instance_create((x+other.x)/2,(y+other.y)/2,PlasmaImpact)
		{
			image_xscale = .9+skill_get(17)*.2
			image_yscale = .9+skill_get(17)*.2
			sound_play_pitch(sndPlasmaHit,random_range(.9,1.1))
		}
		if size > other.size{speed += 3*(other.size/size)}else{speed += 3/size}
	}
}
with PlasmaBall
{
	if place_meeting(x,y,other)
	{
		with other
		{
			var _ordir = other.direction;
			repeat(3) with instance_create(x,y,CustomProjectile)
			{
				creator = other.creator
				team = other.team
				image_speed = 0
				image_index = 0
				damage = 2+skill_get(17)
				sprite_index = global.sprMagnetBomb
				fric = random_range(1.25,1.37)
				motion_set(_ordir+random_range(20,20),random_range(12,19))
				speedset = 1
				maxspeed = 7
				other.bounce++
				with other if "childs" not in self{childs = 0}else{childs++}
				radius = random_range(.6,1)
				target = other
				on_step 	 = mb_step
				on_wall 	 = mb_wall
				on_destroy = mb_destroy
			}
		}
		instance_destroy()
	}
}
with PlasmaBig
if place_meeting(x,y,other)
{
	with other
	{
		var _ordir = other.direction;
		repeat(6) with instance_create(x,y,CustomProjectile)
		{
			creator = other.creator
			team = other.team
			image_speed = 0
			image_index = 0
			damage = 2+skill_get(17)
			sprite_index = global.sprMagnetBomb
			fric = random_range(1.25,1.37)
			motion_set(_ordir+random_range(20,20),random_range(12,19))
			speedset = 1
			maxspeed = 7
			other.bounce++
			with other if "childs" not in self{childs = 0}else{childs++}
			radius = random_range(.6,1)
			target = other
			on_step 	 = mb_step
			on_wall 	 = mb_wall
			on_destroy = mb_destroy
		}
	}
	instance_destroy()
}
with PlasmaHuge
if place_meeting(x,y,other)
{
	with other
	{
		var _ordir = other.direction;
		repeat(25) with instance_create(x,y,CustomProjectile)
		{
			creator = other.creator
			team = other.team
			image_speed = 0
			image_index = 0
			damage = 2+skill_get(17)
			sprite_index = global.sprMagnetBomb
			fric = random_range(1.25,1.37)
			motion_set(_ordir+random_range(20,20),random_range(12,19))
			speedset = 1
			maxspeed = 7
			other.bounce++
			with other if "childs" not in self{childs = 0}else{childs++}
			radius = random_range(.6,1)
			target = other
			on_step 	 = mb_step
			on_wall 	 = mb_wall
			on_destroy = mb_destroy
		}
	}
	instance_destroy()
}

if speed < 2{speed = 2}
image_angle +=speed*3*fac
if place_meeting(x + hspeed,y,Wall){
	hspeed *= -1
	bounce -= 1
	hitframes -= 1
}
if place_meeting(x,y +vspeed,Wall){
	vspeed *= -1
	bounce -= 1
	hitframes -= 1
}
if speed > 20{speed = 15}
if bounce <= 0{instance_destroy();exit}
speed = 0
if hitframes >= 20+skill_get(17)*10{instance_destroy()}

#define mb_wall
instance_destroy()

#define mb_destroy
if "target" in self{if instance_exists(target){target.childs--;}}
sound_play_pitch(sndPlasmaHit,random_range(1.55,1.63))
with instance_create(x,y,PlasmaImpact){image_xscale=.5;image_yscale=.5;damage-=1}

#define mb_step
if instance_exists(target){move_bounce_solid(false)}
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
	if instance_exists(target)
	{
		motion_add(point_direction(x,y,target.x,target.y),radius)
		if speed > maxspeed{speed = maxspeed}
	}
	else
	{
		{
			if instance_exists(enemy)
			{
				var closeboy = instance_nearest(x,y,enemy)
				motion_add(point_direction(x,y,closeboy.x,closeboy.y),.5+skill_get(17)*.3)
				if speed > maxspeed{speed = maxspeed}
			}
			else motion_add(direction,.5)
		}
	}
}

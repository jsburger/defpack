#define init
global.sprSquareGun = sprite_add_weapon("sprites/Square Gun.png", 0, 2);
global.sprSquare = sprite_add("sprites/projectiles/Square.png", 0, 7, 7)
global.mskSquare = sprite_add("sprites/projectiles/Square mask.png",0,5,5)
//global.sprSquareTP = sprite_add("Square TP start.png", 5, 5, 5)

#define weapon_name
return "SQUARE GUN"

#define weapon_sprt
return global.sprSquareGun;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 42;

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
	motion_add(other.gunangle+random_range(-6,6)*creator.accuracy,5+skill_get(17)*3)
	friction = .3
	bounce = 7+skill_get(17)*3
	damage = 2
	image_xscale = 1+skill_get(17)*.3
	image_yscale = 1+skill_get(17)*.3
	force = 6
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
with instance_create(x,y,PlasmaImpact){team = other.team}

#define square_hit
projectile_hit(other, damage, force, direction);
hitframes += 1
if hitframes >= 20+skill_get(17)*10{instance_destroy()}

#define square_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);

#define actually_nothing

#define square_step
if irandom(2-skill_get(17)) = 1
{
	with instance_create(x+random_range(-8,8),y+random_range(-8,8),PlasmaTrail)
	{
		image_speed = 0.35-skill_get(17)*0.05
		image_xscale += skill_get(17)/2
		image_yscale = image_xscale
	}
}
with instances_matching(CustomProjectile,"name","square")
{
	if place_meeting(x,y,other)
	{
		direction = point_direction(other.x,other.y,x,y)
		with instance_create((x+other.x)/2,(y+other.y)/2,PlasmaImpact)
		{
			image_xscale = .9+skill_get(17)*.2
			image_yscale = .9+skill_get(17)*.2
		}
		if size > other.size{speed += 3*(other.size/size)}else{speed += 3/size}
	}
}
if speed < 2+skill_get(17){speed = 2+skill_get(17)}
image_angle +=speed*3*fac
if place_meeting(x + hspeed,y,Wall){
	hspeed *= -1
	bounce -= 1
	fac *= -1
	hitframes -= 1
}
if place_meeting(x,y +vspeed,Wall){
	vspeed *= -1
	bounce -= 1
	fac *= -1
	hitframes -= 1
}
if speed > 20{speed = 15}
if bounce <= 0{instance_destroy()}

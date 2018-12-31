#define init
global.sprBeamer       = sprite_add_weapon("sprites/sprBeamer.png",12,6);
global.sprBeam         = sprite_add("sprites/projectiles/sprBeam.png",1,0,10);
global.mskBeam         = sprite_add("sprites/projectiles/mskBeam.png",1,0,10);
global.sprBeamStart    = sprite_add("sprites/projectiles/sprBeamStart.png",1,12,10);
global.sprBeamCharge   = sprite_add("sprites/projectiles/sprBeamCharge.png",1,16,16);
global.sprBeamEnd      = sprite_add("sprites/projectiles/sprBeamEnd.png",1,10,12);

#define weapon_name
return "BEAMER"

#define weapon_type
return 5;

#define weapon_cost
return 15;

#define weapon_area
return 14;

#define weapon_load
return 64;

#define weapon_swap
return sndSwapEnergy;

#define weapon_auto
return false;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_sprt
return global.sprBeamer;

#define weapon_text
return choose("MASSIVE POWER");

#define weapon_fire
var p = random_range(.8,1.2)
if !skill_get(17)
{
	sound_set_track_position(sndLaser,.09)
	sound_play_pitch(sndLaser,.2*p)
	sound_play_charge(sndLaser,1)
}
else
{
	sound_play_pitch(sndLaserUpg,.4*p)
	sound_play_charge(sndLaser,1)
}
sound_play_pitch(sndPlasmaRifle,.2*p)
with instance_create(x,y,CustomObject)
{
	image_xscale = .25
	image_yscale = .25
	sprite_index = global.sprBeamCharge
	creator = other
	team = other.team
	gunangle = other.gunangle
	ammo = 26
	orammo = ammo
	on_step = sphere_step
	on_draw = sphere_draw
	with instances_matching(CustomSlash,"name","vector beam")
	{
		if creator = other.creator _s = false
	}
}

#define sphere_step
if instance_exists(creator)
{
	x = creator.x+creator.hspeed + lengthdir_x(26,creator.gunangle)
	y = creator.y+creator.vspeed + lengthdir_y(26,creator.gunangle)
	image_angle = creator.gunangle
}
ammo--;
image_xscale += .035
image_yscale += .035
with instances_matching_ne(hitme,"team",other.team)
{
	if place_meeting(x,y,other)
	{
		projectile_hit(self,2,0,other.direction)
		sleep(size*4)
		view_shake_at(x,y,3*size)
	}
}
var _r = random(360)
repeat(3) instance_create(x+lengthdir_x(sprite_get_width(sprite_index)*image_xscale*random_range(.4,.7),_r),y+lengthdir_y(sprite_get_width(sprite_index)*image_yscale*random_range(.4,.7),_r),PlasmaTrail)
if ammo = 0
{
	with instance_create(x,y,CustomObject)
	{
		creator = other.creator
		team = other.team
		gunangle = other.gunangle
		ammo = 24
		on_step = charge_step
		with instances_matching(CustomSlash,"name","vector beam")
		{
			if creator = other.creator _s = false
		}
	}
}
if ammo < -2
{
	var p = random_range(.8,1.2)
	if !skill_get(17){sound_play_pitch(sndLaserCannon,.7*p)}else{sound_play_pitch(sndLaserCannonUpg,.6*p);sound_play_pitch(sndLaserCannon,2*p)}
	sleep(30)
	sound_play_pitchvol(sndDevastatorExplo,5,.7)
	view_shake_at(x,y,40)
	with creator weapon_post(-20,100,40)
	repeat(15)
	{
		with instance_create(x,y,PlasmaTrail)
		{
			image_index = choose(3,4)
			sprite_index = sprPlasmaImpact
			motion_add(random(360),random_range(2,7))
			image_xscale = .25
			image_yscale = .25
			image_speed = .5
		}
		with instance_create(x,y,PlasmaTrail)
		{
			motion_add(random(360),random_range(4,7))
		}
		with instance_create(x,y,Smoke)
		{
			motion_add(random(360),random_range(2,4))
		}
	}
	instance_destroy()
}

#define charge_step
if !instance_exists(creator){instance_delete(self);exit}
x = creator.x+creator.hspeed + lengthdir_x(26,creator.gunangle)
y = creator.y+creator.vspeed + lengthdir_y(26,creator.gunangle)
with creator motion_add(gunangle-180,2)

gunangle = creator.gunangle
with creator weapon_post(14,40,5)
with instance_create(x,y,CustomSlash)
{
	sound_set_track_position(sndEnergyHammerUpg,.3)
	sound_play_pitch(sndEnergyHammerUpg,.5)
	projectile_init(other.team,other.creator)
	name = "beam"
	ammo = 1
	maxammo = ammo
	image_speed = 0
	dir = 0
	startx = x
	starty = y
	image_yscale = 1
	direction = other.gunangle
	image_angle = direction
	sprite_index = global.sprBeam
	mask_index   = global.mskBeam
	do
	{
		dir++;x+=lengthdir_x(1,direction);y+=lengthdir_y(1,direction);
	}
	until dir >= 1700 || place_meeting(x,y,Wall)
	//if instance_exists(creator){with creator weapon_post(6,30,0)}
	on_wall 		  = beam_wall
	on_step 			= beam_step
	on_draw       = beam_draw
	on_hit  			= beam_hit
	on_projectile = beam_projectile
	on_destroy    = beam_destroy
}
ammo--
if ammo <= 0{instance_destroy()}

#define beam_step
image_xscale = dir
var _r = random_range(0,image_xscale)
with instances_matching_ne(hitme,"team",other.team)
{
	if place_meeting(x,y,other)
	{
		motion_set(other.direction,(2+skill_get(17)))
		projectile_hit(self,4,1,other.direction)
	  view_shake_at(other.creator.x,other.creator.y,3*size)
	  sleep(4*size)
		if my_health <= 0
		{
			sleep(20*size)
			view_shake_at(other.creator.x,other.creator.y,5*size)
		}
	}
}
with instances_matching_ne(prop,"team",other.team){if place_meeting(x,y,other){speed = 0}}//5000 iq workaround
x = startx + lengthdir_x(dir,direction) * ammo
y = starty + lengthdir_y(dir,direction) * ammo
if ammo <= 0 {repeat(2) instance_create(x+lengthdir_x(image_xscale,direction)+random_range(-12,12),y+lengthdir_y(image_xscale,direction)+random_range(-12,12),Smoke);instance_destroy();exit}
ammo--

#define beam_wall

#define beam_projectile

#define beam_hit

#define sphere_draw
var _v = random_range(.95,1.05)
draw_self();
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, 0, x, y, image_xscale*1.5*_v, image_yscale*1.5*_v, image_angle, image_blend, .15+skill_get(17)*.05);
draw_set_blend_mode(bm_normal);

#define beam_draw
var _v = random_range(.95,1.05)
if ammo = 0
{
	draw_sprite_ext(global.sprBeamStart, 0, x-lengthdir_x(5,direction), y-lengthdir_y(5,direction), 1*_v, image_yscale*_v, image_angle, image_blend, 1.0);
	draw_sprite_ext(sprite_index, image_index, x+lengthdir_x(6,direction), y+lengthdir_y(6,direction), image_xscale, image_yscale*_v, image_angle, image_blend, 1.0);
	draw_sprite_ext(global.sprBeamEnd, 0, x+lengthdir_x(image_xscale,direction), y+lengthdir_y(image_xscale,direction), 2, image_yscale*_v, image_angle, image_blend, 1.0);
}
draw_set_blend_mode(bm_add);
if ammo = 0
{
	draw_sprite_ext(global.sprBeamStart, 0, x-lengthdir_x(6,direction), y-lengthdir_y(6,direction), 1.5, image_yscale*1.5, image_angle, image_blend, .15+skill_get(17)*.05);
	draw_sprite_ext(sprite_index, image_index, x+lengthdir_x(12,direction), y+lengthdir_y(12,direction), image_xscale, 1.5*image_yscale, image_angle, image_blend, 0.15+skill_get(17)*.05);
}
draw_set_blend_mode(bm_normal);

#define beam_destroy
repeat(4)
{
var _r = random_range(0,image_xscale)
with instance_create(x+lengthdir_x(_r,direction)+random_range(-5,5),y+lengthdir_y(_r,direction)+random_range(-5,5)	,BulletHit)
{
	sprite_index = sprPlasmaTrail
	image_angle = other.direction
	speed = 0
	motion_add(other.direction,choose(1,2))
}
}
sound_set_track_position(sndEnergyHammerUpg,0)
sound_set_track_position(sndLaserUpg,0)
sound_set_track_position(sndLaser	,0)

#define step
if "extraspeed" in self
{
  if extraspeed > 30{extraspeed = 30} //cap speed for safety reasons
	if extraspeed > 0
	{
    sleep(1)
    sound_play_gun(sndFootOrgSand4,999999999999999999999999999999999999999999999999,.00001)//mute action
		if irandom(2) != 0{instance_create(x,y,Dust)}
		canaim = false;
		with instance_create(x+lengthdir_x(extraspeed+20*skill_get(13),frac(extraspeed)*10000),y+lengthdir_y(extraspeed+20*skill_get(13),frac(extraspeed)*10000),Shank)
    {
			team = other.team;
      creator = other;
      damage = 20;
      sprite_index = mskNone;
      mask_index = sprHeavyNade;
      image_xscale = 4;
      image_yscale = 4;
			image_angle = other.gunangle;
		}
		motion_add(frac(extraspeed)*10000-180,extraspeed-frac(extraspeed));
		extraspeed -= current_time_scale;
	}
	else{extraspeed = 0;canaim = true}
}

#define weapon_reloaded

#define sound_play_charge(_snd,_vol)
with instance_create(x,y,CustomObject)
{
	creator = other
  pitch = .4 * choose(.8,1.2)
  decel = random_range(.05,.06)
  p = random_range(.8,1.2)
  lifetime = 26
  vol = _vol
  snd = _snd
  on_step    = sound_step
  on_destroy = sound_destroy
}

#define sound_step
if instance_exists(creator) with creator weapon_post((24-other.lifetime)/4,(24-other.lifetime)/4,0)
pitch += decel
sound_play_pitchvol(snd,pitch*p,vol)
lifetime -= 1
view_shake_at(x,y,(24-lifetime)/3)
if lifetime <= 0 instance_destroy() //should need time scale adjustments since sound speed is independent of it

#define sound_destroy
sound_play_pitch(snd,random_range(.8,1.2))

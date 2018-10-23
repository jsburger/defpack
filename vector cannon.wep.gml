#define init
global.sprGeysir 		      = sprite_add_weapon("sprites/sprGeysir.png", 7, 7);
global.sprWaterBeam       = sprite_add("sprites/projectiles/sprWaterBeam.png",0,1,6);
global.mskWaterBeam       = sprite_add("sprites/projectiles/mskWaterBeam.png",0,1,6);
global.sprVectorBeamEnd   = sprite_add("sprites/projectiles/sprVectorBeamEnd.png",3,5,5);
global.sprVectorBeamStart = sprite_add("sprites/projectiles/sprVectorBeamStart.png",0,8,8);
global.sprVectorHead 	    = sprite_add("sprites/projectiles/sprVectorHead.png",0,8,2)

#define weapon_name
return "VECTOR CANNON";

#define weapon_sprt
return global.sprGeysir;

#define weapon_type
return 5;

#define weapon_auto
return true;

#define weapon_load
return 18;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 13;

#define weapon_reloaded
if !button_check(index,"fire") || (race = "steroids" and bwep = mod_current and !button_check(index,"spec"))
{
	sound_play_pitchvol(sndIDPDNadeAlmost,.5,.2)
	sound_play_pitchvol(sndPlasmaReload,1.4,.4)
}
#define weapon_text
return "BEAMING";

#define weapon_fire
if !skill_get(17)
{
	sound_set_track_position(sndLaser,.09)
	sound_play_pitch(sndLaser,.2*random_range(.8,1.2))
}
else
{
	sound_set_track_position(sndLaserUpg,.2)
	sound_play_pitch(sndLaserUpg,.4*random_range(.8,1.2))
}
var _s = true
with instance_create(x,y,CustomObject)
{
	creator = other
	team = other.team
	gunangle = other.gunangle
	ammo = weapon_get_load(mod_current)+1
	on_step = charge_step
	with instances_matching(CustomSlash,"name","vector beam")
	{
		if creator = other.creator _s = false
	}
}
if _s = true sound_play_pitch(sndPlasmaRifle,.2*random_range(.8,1.2))

#define charge_step
if !instance_exists(creator){instance_delete(self);exit}
x = creator.x+creator.hspeed + lengthdir_x(16,creator.gunangle)
y = creator.y+creator.vspeed + lengthdir_y(16,creator.gunangle)
gunangle = creator.gunangle
with creator weapon_post(5,20,0)
with instance_create(x,y,CustomSlash)
{
	sound_set_track_position(sndEnergyHammerUpg,.3)
	sound_play_pitch(sndEnergyHammerUpg,.5)
	projectile_init(other.team,other.creator)
	name = "vector beam"
	ammo = 1
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
	do
	{
		dir++;x+=lengthdir_x(1,direction);y+=lengthdir_y(1,direction);
	}
	until dir >= 1800 || place_meeting(x,y,Wall)
	//if instance_exists(creator){with creator weapon_post(6,30,0)}
	on_wall 		  = beam_wall
	on_end_step 			= beam_step
	on_draw       = beam_draw
	on_hit  			= beam_hit
	on_projectile = beam_projectile
	on_destroy    = beam_destroy
	image_xscale = dir
	image_yscale = 1 * random_range(.9,1.1)
    x = startx + lengthdir_x(dir,direction) * ammo
    y = starty + lengthdir_y(dir,direction) * ammo

}
ammo--
if ammo <= 0{instance_destroy()}

#define beam_step
/*
with instances_matching_ne(hitme,"team",other.team)
{

	if place_meeting(x,y,other)
	{
		speed = 0
		motion_set(other.direction,max((4+skill_get(17)*2-size),1))
		view_shake_at(other.creator.x,other.creator.y,.35*size)
		projectile_hit(self,choose(0,0,1),1,other.direction)
	}
}
with instances_matching_ne(prop,"team",other.team){if place_meeting(x,y,other){speed = 0}}//5000 iq workaround
*/
if ammo <= 0 {instance_destroy();exit}
ammo-= current_time_scale
with instance_create(x+random_range(-12,12),y+random_range(-12,12),BulletHit)
{
	sprite_index = global.sprVectorBeamEnd
	image_angle = other.direction
	speed = 0
}
#define beam_wall

#define beam_hit
with other motion_set(other.direction,max((4+skill_get(17)*2-size/2),1))
view_shake_at(other.x,other.y,other.size)
if !irandom(2) projectile_hit(other,1,1,direction)
with other{
    if place_meeting(x+lengthdir_x(speed+1,other.direction)+hspeed,y+lengthdir_y(speed+1,other.direction)+vspeed,Wall){
	    with other projectile_hit(other,other.speed ,1,direction)
		view_shake_at(x,y,6*size)
	}
}

#define beam_projectile
/*with other
{
	team = -10
	if "_s" not in self _s = speed
	motion_add(other.direction,.5)
	image_angle = direction
	if speed > _s speed = _s
}*/

#define beam_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
if ammo = 0
{
	draw_sprite_ext(global.sprVectorBeamStart, 0, x, y, 1, image_yscale, image_angle-180, image_blend, 1.0);
	draw_sprite_ext(global.sprVectorHead, 0, x+lengthdir_x(image_xscale,direction), y+lengthdir_y(image_xscale,direction), 2, image_yscale*2, image_angle-45+180, image_blend, 1.0);
}
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, 1.5*image_yscale, image_angle, image_blend, 0.15+skill_get(17)*.05);
if ammo = 0
{
	draw_sprite_ext(global.sprVectorBeamStart, 0, x, y, 1.5, image_yscale*1.5, image_angle-180, image_blend, .15+skill_get(17)*.05);
	draw_sprite_ext(global.sprVectorHead, 0, x+lengthdir_x(image_xscale,direction), y+lengthdir_y(image_xscale,direction), 2.5, image_yscale*2.5, image_angle-45+180, image_blend, .15+skill_get(17)*.05);
}
draw_set_blend_mode(bm_normal);

#define beam_destroy
var _r = random_range(0,image_xscale+12)
with instance_create(x+lengthdir_x(_r,direction)+random_range(-5,5),y+lengthdir_y(_r,direction)+random_range(-5,5)	,BulletHit)
{
	sprite_index = global.sprVectorBeamEnd
	image_angle = other.direction
	speed = 0
	motion_add(other.direction,choose(1,2))
}
sound_set_track_position(sndEnergyHammerUpg,0)
sound_set_track_position(sndLaserUpg,0)
sound_set_track_position(sndLaser	,0)

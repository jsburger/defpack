#define init
global.sprBeamer       = sprite_add_weapon("sprites/sprBeamer.png",12,6);
global.sprBeam         = sprite_add("sprites/projectiles/sprBeam.png",1,0,10);
global.mskBeam         = sprite_add("sprites/projectiles/mskBeam.png",1,1,10);
global.sprBeamStart    = sprite_add("sprites/projectiles/sprBeamStart.png",1,12,10);
global.sprBeamCharge   = sprite_add("sprites/projectiles/sprBeamCharge.png",1,16,16);
global.sprBeamEnd      = sprite_add("sprites/projectiles/sprBeamEnd.png",1,10,12);

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_name
return "BEAMER"

#define weapon_type
return 5;

#define weapon_cost
return 10;

#define weapon_area
return 15;

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
if !irandom(50) return "IT'S NOT A SLUR"
return "MASSIVE POWER";

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
with instance_create(x,y,CustomProjectile)
{
    name = "beamer sphere"
	image_xscale = .25
	image_yscale = .25
	sprite_index = global.sprBeamCharge
	creator = other
	team = other.team
	gunangle = other.gunangle
	ammo = 26
	orammo = ammo
	on_step = sphere_step
	on_wall = nothing
	on_hit = sphere_hit
	on_draw = sphere_draw
}

#define nothing

#define sphere_hit
if current_frame_active{
    projectile_hit(other, 2, 1, image_angle)
    if other.my_health <= 0{
        sleep(min(other.size, 4)*4)
        view_shake_at(x,y,3*min(4,other.size))
    }
}

#define sphere_step
if instance_exists(creator)
{
	x = creator.x+creator.hspeed + lengthdir_x(26,creator.gunangle)
	y = creator.y+creator.vspeed + lengthdir_y(26,creator.gunangle)
	image_angle = creator.gunangle
}
else {
    instance_destroy()
    exit
}
xprevious = x
yprevious = y
ammo -= current_time_scale;
image_xscale += .035 * current_time_scale
image_yscale += .035 * current_time_scale
var _r = random(360)
if current_frame_active repeat(3) instance_create(x+lengthdir_x(sprite_width*random_range(.4,.7),_r),y+lengthdir_y(sprite_height*random_range(.4,.7),_r),PlasmaTrail)
if floor(ammo) < current_time_scale and floor(ammo) >= 0
{
    with instance_create(x,y,CustomProjectile){
    name = "beamer beam"
    creator = other.creator
    team = other.team
    direction = creator.gunangle
    image_angle = direction
	sprite_index = global.sprBeam
	mask_index   = global.mskBeam

    on_step = beam_step
    on_wall = beam_wall
	on_draw = beam_draw
	on_hit  = beam_hit
	on_square = script_ref_create(beam_square)

    time = 28
    image_speed = 0
}

}
if ammo < -2
{
	var p = random_range(.8,1.2)
	if !skill_get(17){sound_play_pitch(sndLaserCannon,.7*p)}else{sound_play_pitch(sndLaserCannonUpg,.6*p);sound_play_pitch(sndLaserCannon,2*p)}
	sleep(30)
	sound_play_pitchvol(sndDevastatorExplo,5,.7)
	view_shake_at(x,y,100)
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

#define beam_step
if instance_exists(creator){
    with creator{
        weapon_post(5,20*current_time_scale,0)
        motion_add(gunangle, -2*current_time_scale)
    }
		sound_play_gun(sndClickBack,1,.2-skill_get(mut_laser_brain)*.2)
		sound_stop(sndClickBack)
    time -= current_time_scale
    if time <= 0 {instance_destroy(); exit}
    x = creator.x + creator.hspeed_raw + lengthdir_x(26,creator.gunangle)
    y = creator.y + creator.vspeed_raw + lengthdir_y(26,creator.gunangle)
    xstart = x
    ystart = y
    image_xscale = 1
    image_yscale = .5
    direction = creator.gunangle
    image_angle = direction

    var _x = lengthdir_x(2,direction), _y = lengthdir_y(2,direction)
    var dir = 0
    do {
    	dir += 2;
    	x += _x
    	y += _y
    }
    until dir >= 1800 || place_meeting(x,y,Wall)
    xprevious = x
    yprevious = y

    image_xscale = dir
    if current_frame_active{
        repeat(4)
        {
            var _r = random_range(0,image_xscale)
            with instance_create(xstart+lengthdir_x(_r,direction)+random_range(-5,5),ystart+lengthdir_y(_r,direction)+random_range(-5,5),BulletHit)
            {
            	sprite_index = sprPlasmaTrail
            	image_angle = other.direction
            	motion_set(other.direction,choose(1,2))
            }
        }
    }
    image_yscale = 1 * random_range(.9,1.1)
}
else instance_destroy()

#define beam_wall

#define beam_square
with other{
    motion_add(direction, 4*current_time_scale)
    if current_frame_active with instance_create(x + lengthdir_x(random(sprite_width/2),random(360)),y+lengthdir_y(random(sprite_height/2),random(360)),PlasmaImpact) {
        image_speed *= random_range(.4,.6);
        image_xscale = random_range(.6,.8);
        image_yscale = image_xscale
        team = other.pseudoteam
    }
}

#define beam_hit
if current_frame_active{
		sleep(5)
		view_shake_at(x,y,2)
    with other motion_set(other.direction,2+skill_get(mut_laser_brain))
    view_shake_max_at(other.x,other.y,min(other.size,4))
    projectile_hit(other,3 + skill_get(mut_laser_brain)*2,1,direction)
    if other.my_health <= 0{
        sleep(min(other.size, 4) * 20)
        view_shake_max_at(creator.x,creator.y,5*min(4, other.size))
    }
}
#define beam_draw
draw_sprite_ext(sprite_index, image_index, xstart + lengthdir_x(12, image_angle), ystart + lengthdir_y(12, image_angle), image_xscale - 16, image_yscale, image_angle, image_blend, 1.0);
	if x != xstart draw_sprite_ext(global.sprBeamStart, 0, xstart, ystart, 1, image_yscale, image_angle, image_blend, 1.0);
	if x != xstart draw_sprite_ext(global.sprBeamEnd, 0, x, y, 1, image_yscale*1, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, xstart + lengthdir_x(12, image_angle), ystart + lengthdir_y(12, image_angle), image_xscale - 27, 1.5*image_yscale, image_angle, image_blend, 0.15+skill_get(17)*.05);
	if x != xstart draw_sprite_ext(global.sprBeamStart, 0, xstart, ystart, 1, image_yscale*1.5, image_angle, image_blend, .15+skill_get(17)*.05);
	if x != xstart draw_sprite_ext(global.sprBeamEnd, 0, x, y, 1.5, image_yscale*1.5, image_angle, image_blend, .15+skill_get(17)*.05);
draw_set_blend_mode(bm_normal);



#define sphere_draw
var _v = random_range(.95,1.05)
draw_self();
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, 0, x, y, image_xscale*1.5*_v, image_yscale*1.5*_v, image_angle, image_blend, .15+skill_get(17)*.05);
draw_set_blend_mode(bm_normal);


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
    on_cleanup = sound_cleanup
}

#define sound_step
if current_frame_active{
    if instance_exists(creator) with creator weapon_post((24-other.lifetime)/4,(24-other.lifetime)/4,0)
    pitch += decel
    sound_play_pitchvol(snd,pitch*p,vol)
    view_shake_at(x,y,(24-lifetime)/3)
}
lifetime -= current_time_scale
if lifetime <= 0 instance_destroy()

#define sound_destroy
sound_cleanup()
sound_play_pitch(snd,random_range(.8,1.2))

#define sound_cleanup
sound_set_track_position(snd,0)

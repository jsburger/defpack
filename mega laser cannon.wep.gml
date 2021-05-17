#define init
global.sprBeamer       = sprite_add_weapon("sprites/weapons/sprBeamer.png",12,6);
global.sprBeamerHUD    = sprite_add("sprites/interface/sprBeamerHUD.png",1,12,6);
global.sprBeam         = sprite_add("sprites/projectiles/sprBeam.png",1,0,10);
global.mskBeam         = sprite_add("sprites/projectiles/mskBeam.png",1,1,10);
global.sprBeamStart    = sprite_add("sprites/projectiles/sprBeamStart.png",1,12,10);
global.sprBeamCharge   = sprite_add("sprites/projectiles/sprBeamCharge.png",1,16,16);
global.sprBeamEnd      = sprite_add("sprites/projectiles/sprBeamEnd.png",1,10,12);

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#macro brain_active skill_get(mut_laser_brain) > 0

#define weapon_name
return "MEGA LASER CANNON"

#define weapon_type
return 5;

#define weapon_cost
return 15;

#define weapon_area
return 15;

#define weapon_load
return 64;

#define weapon_swap
if instance_is(self, Player){
	view_shake_at(x, y, 20);
	sleep(10);
}
sound_play_pitchvol(sndBasicUltra, 1.2, .6);
sound_play_pitch(sndSwapEnergy, .9);
return -4;

#define weapon_auto
return false;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_sprt
return global.sprBeamer;

#define weapon_sprt_hud
return global.sprBeamerHUD;

#define weapon_text
return "MASSIVE POWER";

#define weapon_fire
var p = random_range(.8,1.2);
if skill_get(mut_laser_brain) > 0{
	sound_play_pitch(sndLaserUpg,.4*p)
	repeat(1)sound_play_charge(sndLaser,.6, 0)
}
else{
	sound_play_pitch(sndLaserUpg,.6*p)
	repeat(1)sound_play_charge(sndLaser,1, 0)
}
sound_play_pitch(sndPlasmaRifle,.2*p)
with instance_create(x,y,CustomProjectile){
    name = "beamer sphere"
	image_xscale = .25
	image_yscale = .25
	sprite_index = global.sprBeamCharge
	creator = other
	team = other.team
	gunangle = other.gunangle
	ammo = 30
	orammo = ammo
	on_step = sphere_step
	on_wall = nothing
	on_hit = sphere_hit
	on_draw = sphere_draw
}

#define step
with instances_matching(Player, "wep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}
with instances_matching(instances_matching(Player, "race", "steroids"), "bwep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}
#define nothing

#define sphere_hit
if current_frame_active{
    projectile_hit(other, 3, other.friction + .1, image_angle)
    if other.my_health <= 0{
        sleep(min(other.size, 4)*4)
        view_shake_at(x,y,3*min(4,other.size))
    }
}

#define sphere_step
if instance_exists(creator){
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
if floor(ammo) < current_time_scale and floor(ammo) >= 0{
    with instance_create(x,y,CustomProjectile){
        name = "beamer beam"
        creator = other.creator
        team = other.team
        direction = creator.gunangle
        image_angle = direction
    	sprite_index = global.sprBeam
    	spr_head     = global.sprBeamEnd
    	spr_tail     = global.sprBeamStart
    	mask_index   = global.mskBeam

        on_step = beam_step
        on_wall = beam_wall
    	on_draw = beam_draw
    	on_hit  = beam_hit
    	on_square = script_ref_create(beam_square)

        sound = -1
        time = 28
        image_speed = 0
        /*repeat(1+skill_get(mut_laser_brain))with sound_play_charge(sndLaserUpg, 1, .33){
            creator = noone
            pitch = 2
            decel = -.05 * random_range(.9, 1.2)
            lifetime = 40
        }
        with sound_play_charge(sndEnergyHammerUpg, .6, .32){
            creator = noone
            pitch = .7
            decel = 0
            lifetime = 40
        }*/
    }
}
if ammo <= 0{
	var p = random_range(.8,1.2)
	if !skill_get(17){
	    sound_play_pitch(sndLaserCannon,.7*p)
	}
    else{
        sound_play_pitch(sndLaserCannonUpg,.6*p);
        sound_play_pitch(sndLaserCannon,2*p)
    }
	sleep(20)
	sound_play_pitchvol(sndDevastatorExplo,5,.7)
	view_shake_at(x,y,100)
	with creator weapon_post(-20,100,40)
	repeat(15){
		with instance_create(x,y,PlasmaTrail){
			image_index = choose(3,4)
			sprite_index = sprPlasmaImpact
			motion_add(random(360),random_range(2,7))
			image_xscale = .25
			image_yscale = .25
			image_speed = .5
		}
		with instance_create(x,y,PlasmaTrail){
			motion_add(random(360),random_range(4,7))
		}
		with instance_create(x,y,Smoke){
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
	sound_play_gun(sndClickBack,1,.2 - brain_active *.2)
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
		if place_meeting(x, y, Wall)
		{
			var _w = instance_nearest(x, y, Wall);
			if point_distance(creator.x, creator.y, _w.x, _w.y) <= 240 with _w
			{
				instance_create(x, y, FloorExplo)
				instance_destroy()
			}
			view_shake_at(x, y, 3)
			sleep(2)
			with instance_create(x + random_range(-8, 8), y + random_range(-8, 8), PlasmaImpact)
			{
				var _size = random_range(.4, .8)
				image_xscale = _size
				image_yscale = _size
				image_speed *= random_range(.8, 1.2)
				team = other.team
				creator = other.creator
			}
		}
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
            	motion_set(other.direction,irandom_range(1, 3))
            }
        }
    }
    image_yscale = 1 * random_range(.9,1.1)
}
else instance_destroy()

#define beam_wall

#define beam_square
with other{
    motion_add(other.direction, 4*current_time_scale)
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
    with other motion_set(other.direction,2 + skill_get(mut_laser_brain))
    view_shake_max_at(other.x,other.y,min(other.size,4))
    projectile_hit(other,6 + skill_get(mut_laser_brain)*3, 1, direction)
    if other.my_health <= 0{
        sleep(min(other.size, 4) * 20)
        view_shake_max_at(creator.x,creator.y,5*min(4, other.size))
    }
}
#define beam_draw
draw_sprite_ext(sprite_index, image_index, xstart + lengthdir_x(12, image_angle), ystart + lengthdir_y(12, image_angle), image_xscale - 16, image_yscale, image_angle, image_blend, 1.0);
	if x != xstart draw_sprite_ext(spr_tail, 0, xstart, ystart, 1, image_yscale, image_angle, image_blend, 1.0);
	if x != xstart draw_sprite_ext(spr_head, 0, x, y, 1, image_yscale*1, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, xstart + lengthdir_x(12, image_angle), ystart + lengthdir_y(12, image_angle), image_xscale - 27, 1.5*image_yscale, image_angle, image_blend, 0.15+brain_active*.05);
	if x != xstart draw_sprite_ext(spr_tail, 0, xstart, ystart, 1, image_yscale*1.5, image_angle, image_blend, .15+brain_active*.05);
	if x != xstart draw_sprite_ext(spr_head, 0, x, y, 1.5, image_yscale*1.5, image_angle, image_blend, .15+brain_active*.05);
draw_set_blend_mode(bm_normal);



#define sphere_draw
var _v = random_range(.95,1.05)
draw_self();
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, 0, x, y, image_xscale*1.5*_v, image_yscale*1.5*_v, image_angle, image_blend, .15+brain_active*.05);
draw_set_blend_mode(bm_normal);


#define sound_play_charge(_snd, _vol, _time)
with instance_create(x,y,CustomObject){
	creator = other
    pitch = .4 * choose(.8,1.2) * brain_active
    decel = random_range(.05,.06) * (.6 + brain_active * .2)
    p = random_range(.9,1.1)
    lifetime = 27
    vol = _vol
    snd = _snd
    time = _time
    sound = -1
    on_step    = sound_step
    on_destroy = sound_destroy
    return id
}

#define sound_step
if current_frame_active{
    if instance_exists(creator){
        with creator weapon_post((24-other.lifetime)/4,(24-other.lifetime)/4,0)
        view_shake_at(x,y,(24-lifetime)/3)
    }
    pitch += decel
    audio_stop_sound(sound)
    var q = audio_play_sound(snd, 1, 0)
    audio_sound_set_track_position(q, time)
    audio_sound_pitch(q, pitch * p)
    audio_sound_gain(q, vol, 0)
    sound = q
    //sound_play_pitchvol(snd,pitch*p,vol)
}
lifetime -= current_time_scale
if lifetime <= 0 instance_destroy()

#define sound_destroy
audio_stop_sound(sound)
//sound_play_pitch(snd,random_range(.8,1.2))

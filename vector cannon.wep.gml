#define init
global.sprGeysir 		      = sprite_add_weapon("sprites/weapons/sprVectorCannon.png", 7, 7);
global.sprWaterBeam       = sprite_add("sprites/projectiles/sprWaterBeam.png",1,0,6);
global.mskWaterBeam       = sprite_add("sprites/projectiles/mskWaterBeam.png",1,2,6);
global.sprVectorBeamEnd   = sprite_add("sprites/projectiles/sprVectorBeamEnd.png",5,5,5);
global.sprVectorBeamStart = sprite_add("sprites/projectiles/sprVectorBeamStart.png",0,8,8);
global.sprVectorHead 	    = sprite_add("sprites/projectiles/sprVectorHead.png",0,8,2)

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_name
return "VECTOR CANNON";

#define weapon_sprt
return global.sprGeysir;

#define weapon_type
return 5;

#define weapon_auto
return true;

#define weapon_load
return 12;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 13;

#define weapon_reloaded
if !button_check(index,"fire") || (race = "steroids" and bwep = mod_current and !button_check(index,"spec")){
	sound_play_pitchvol(sndIDPDNadeAlmost,.5,.2)
	sound_play_pitchvol(sndPlasmaReload,1.4,.4)
}
#define weapon_text
return "BEAMING";

#define nts_weapon_examine
return{
    "d": "Continuous vectors aren't as good at pulling enemies #but great in dealing damage. ",
}

#define weapon_fire
if !skill_get(17){
	sound_set_track_position(sndLaser,.09)
	sound_play_pitch(sndLaser,.2*random_range(.8,1.2))
}
else{
	sound_set_track_position(sndLaserUpg,.2)
	sound_play_pitch(sndLaserUpg,.4*random_range(.8,1.2))
}
if !array_length(instances_matching(instances_matching(CustomProjectile, "name", "vector beam"), "creator", id)) sound_play_pitch(sndPlasmaRifle,.2*random_range(.8,1.2))
with instance_create(x,y,CustomProjectile){
    name = "vector beam"
    creator = other
    team = other.team
    direction = creator.gunangle
    image_angle = direction
    created = false
	sprite_index = global.sprWaterBeam
	mask_index   = global.mskWaterBeam
	spr_tail     = global.sprVectorBeamStart
	spr_head     = global.sprVectorHead

    on_step = beam_step
    on_wall = beam_wall
	on_draw = beam_draw
	on_hit  = beam_hit
	on_cleanup = beam_cleanup

    time = weapon_load() + current_time_scale
    image_speed = 0
}


#define beam_cleanup
sound_set_track_position(sndEnergyHammerUpg,0)
sound_set_track_position(sndLaserUpg,0)
sound_set_track_position(sndLaser,0)
sound_stop(sndEnergyHammerUpg)

#define beam_step
if instance_exists(creator){
    with creator weapon_post(5,5*current_time_scale,0)
	if created = false{
		created = true
		sound_set_track_position(sndEnergyHammerUpg,.3)
		sound_pitch(sndEnergyHammerUpg,0)
		sound_play_pitchvol(sndEnergyHammerUpg,.4 * random_range(.9, 1.1), .35)
		sound_set_track_position(sndEnergyHammerUpg,0)
	}

    time -= current_time_scale
    if time <= 0 {instance_destroy(); exit}
    x = creator.x + creator.hspeed_raw + lengthdir_x(16,creator.gunangle)
    y = creator.y + creator.vspeed_raw + lengthdir_y(16,creator.gunangle)
    xstart = x
    ystart = y
    image_xscale = 1
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

    image_xscale = dir/2
    if current_frame_active{
        var _r = random_range(0,image_xscale*2+12)
        with instance_create(x-lengthdir_x(_r,direction)+random_range(-5,5),y-lengthdir_y(_r,direction)+random_range(-5,5),BulletHit)
				{
        	sprite_index = global.sprVectorBeamEnd
        	image_angle = other.direction
					image_speed = .4 - (skill_get(mut_laser_brain) > 0 ? .2 : 0);
        	motion_set(other.direction,choose(1,2))
        }
    }
    image_yscale = 1 * random_range(.9,1.1)
    sound_set_track_position(sndEnergyHammerUpg,0)
    sound_set_track_position(sndLaserUpg,0)
    sound_set_track_position(sndLaser,0)
}
else instance_destroy()

#define beam_wall

#define beam_hit
if current_frame_active{
    with other motion_set(other.direction,max((4+skill_get(17)*2-size/2),1))
    view_shake_max_at(other.x,other.y,min(other.size,4))
    projectile_hit(other,1,1,direction)
    with other{
        if place_meeting(x+lengthdir_x(speed+1,other.direction)+hspeed,y+lengthdir_y(speed+1,other.direction)+vspeed,Wall){
    	    with other projectile_hit(other,other.speed ,1,direction)
    		view_shake_max_at(x,y,4*min(size,4))
    	}
    }
    if other.my_health <= 0{
        sleep(min(other.size, 4) * 10)
    }
}
#define beam_draw
draw_sprite_ext(sprite_index, image_index, xstart, ystart, image_xscale, image_yscale, image_angle, image_blend, 1.0);
	if x != xstart draw_sprite_ext(spr_tail, 0, xstart, ystart, 1, image_yscale, image_angle, image_blend, 1.0);
	if x != xstart draw_sprite_ext(spr_head, 0, x, y, image_yscale*2, image_yscale*2, image_angle-45, image_blend, 1.0);

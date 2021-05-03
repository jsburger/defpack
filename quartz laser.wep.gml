#define init
global.sprQuartzLaser  = sprite_add_weapon("sprites/weapons/sprQuartzLaser.png" , 6, 4);
global.sprQuartzLaser1 = sprite_add_weapon("sprites/weapons/sprQuartzLaser1.png", 6, 4);
global.sprQuartzLaser2 = sprite_add_weapon("sprites/weapons/sprQuartzLaser2.png", 6, 4);
global.sprBeam      = sprite_add("sprites/projectiles/sprQuartzBeam.png",1,0,5)
global.sprBeamStart = sprite_add("sprites/projectiles/sprQuartzBeamStart.png",1,-7,5)
global.sprBeamEnd   = sprite_add("sprites/projectiles/sprQuartzBeamEnd.png",1,4,5)
global.mskBeam      = sprite_add("sprites/projectiles/mskQuartzBeam.png",1,1,10);
global.sprHud  = sprite_add("sprites/interface/sprQuartzLaserHud.png" , 1, 6, 4);
global.sprHud1 = sprite_add("sprites/interface/sprQuartzLaserHud1.png", 1, 6, 4);
global.sprHud2 = sprite_add("sprites/interface/sprQuartzLaserHud2.png", 1, 6, 4);

#define weapon_name
return "QUARTZ LASER"
#define weapon_type
return 5
#define weapon_cost
return 1
#define weapon_area
return 15
#define weapon_load
return 12
#define weapon_swap(w)
if instance_is(self, Player) if is_object(w){w.prevhealth = my_health}
sound_play_pitchvol(sndHyperCrystalHurt, 1.3, .6)
return sndSwapEnergy
#define weapon_auto
return true
#define weapon_melee
return 0
#define weapon_sprt_hud(wep)
	if is_object(wep){
	  switch wep.health{
	    default: return global.sprHud;
	    case 1: return global.sprHud1;
	    case 0: return global.sprHud2;
	  }
	}
	return global.sprHud;

#define weapon_laser_sight
	return 0

#define weapon_sprt(wep)
	if is_object(wep){
	  switch wep.health{
	    default: return global.sprQuartzLaser;
	    case 1: return global.sprQuartzLaser1;
	    case 0: return global.sprQuartzLaser2;
	  }
	}
	return global.sprQuartzLaser;

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_text
return choose("FRAGILE APPARATUS","BE CAREFUL WITH IT")

#define nts_weapon_examine
return{
    "d": "A shiny and frail laser gun. #Firing the weapon makes you feel tingly. ",
}

#define step(p)
  if p && is_object(wep){
    mod_script_call_self("mod","defpack tools","quartz_penalty",mod_current, wep, p)
    mod_script_call_self("mod","defpack tools","quartz_step", self, wep);
  }
  if !p && is_object(bwep) && race = "steroids"{
    mod_script_call_self("mod","defpack tools","quartz_penalty",mod_current, bwep, p)
    mod_script_call_self("mod","defpack tools","quartz_step", self, bwep);
  }

#define weapon_fire(w)
  if !is_object(w){
      w = {
          wep: w,
          prevhealth: other.my_health,
          maxhealth: 2,
          health: 2,
          is_quartz: true,
          shinebonus:0
      }
      wep = w
  }
with instance_create(x,y,CustomProjectile){
       name = "quartz beam"
        creator = other
        team = other.team
        direction = creator.gunangle
        image_angle = direction
    	sprite_index = global.sprBeam
    	spr_head     = global.sprBeamEnd
    	spr_tail     = global.sprBeamStart
    	mask_index   = global.mskBeam

        on_step    = beam_step
        on_wall    = beam_wall
    	on_draw    = beam_draw
    	on_hit     = beam_hit
    	on_destroy = beam_destroy

        sound = -1
        time = weapon_get_load(mod_current) + 1
        image_speed = 0
}
if button_pressed(index, "fire") = true{
	var _p = random_range(.8, 1.2);
	sound_play_pitch(skill_get(mut_laser_brain) > 0 ? sndUltraLaserUpg : sndUltraLaser, 1.4 * _p);
	sound_play_pitch(skill_get(mut_laser_brain) > 0 ? sndLaserUpg : sndLaser, 2 * _p);
	sound_play_pitchvol(sndHyperCrystalSearch, 2 * _p, .4);
}else if button_check(index, "fire"){
	//cool awesome stuff goes here
}

#define beam_step
if instance_exists(creator){
	var _o = 0;
    with creator{
        if other.time > current_time_scale weapon_post(5, -7, 0)
        if current_frame mod 8 <= current_time_scale{
        	var _p = random_range(.9, 1.1);
					sound_play_pitchvol(sndHyperCrystalHurt, 3 * _p, .2);
					weapon_post(4,  1, 0)
					_o = 1;
        }
    }
    time -= current_time_scale
    if time <= 0 {instance_destroy(); exit}
    x = creator.x + creator.hspeed_raw + lengthdir_x(8 + _o,creator.gunangle)
    y = creator.y + creator.vspeed_raw + lengthdir_y(8 + _o,creator.gunangle)
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
    	if time <= current_time_scale && !button_check(creator.index, "fire"){
    	if irandom(4) = 0 with instance_create(x, y, Smoke){
				sprite_index = sprExtraFeetDust;
				motion_add(other.image_angle, random_range(1, 3))
			}
		}
    }
    until dir >= 1800 || place_meeting(x,y,Wall)

    if time <= current_time_scale && !button_check(creator.index, "fire"){
    	with instance_create(x - lengthdir_x(8, image_angle), y - lengthdir_y(8, image_angle), WepSwap){
			image_xscale = 1.35;
			image_yscale = 1.35;
			image_speed = .6;
		}
	}

	with instance_create(x, y, Dust){
		sprite_index = sprExtraFeetDust;
		motion_add(other.image_angle - 180 + random_range(-32, 32), random_range(0, 2))
	}

    xprevious = x
    yprevious = y

    image_xscale = dir
    if current_frame_active && irandom(1) = 0{
        repeat(1)
        {
            var _r = random_range(0,image_xscale)
            with instance_create(xstart+lengthdir_x(_r,direction)+random_range(-8,8),ystart+lengthdir_y(_r,direction)+random_range(-8,8),WepSwap)
            {
            	motion_set(other.direction,irandom_range(0, 1))
            	image_speed = random_range(.7,.9)
            	depth = other.depth - 1

            }
        }
    }
    image_yscale = .9 * random_range(.9,1.1)
}
else instance_destroy()

#define beam_wall

#define beam_hit
	var _h = max(1, 4 - skill_get(mut_laser_brain));
	if current_frame mod _h <= current_time_scale{
	    view_shake_max_at(creator.x,creator.y, 3);
	    projectile_hit(other,3,other.friction + .31,direction)
	    repeat(choose(2, 2, 3)) with instance_create(other.x, other.y, choose(Smoke, Dust, Dust)){
			sprite_index = sprExtraFeetDust;
			motion_add(random(360), random_range(2, 5))
		}

		if other.my_health <= 0{
			projectile_hit(other, 0, 10, direction);
			view_shake_max_at(creator.x,creator.y, 6 + 6 * clamp(other.size, 1, 3));
			sleep(24 + clamp(other.size, 1, 3) * 16)
		}
		instance_create(other.x + random_range(-15, 15), other.y + random_range(-15, 15), WepSwap)
	}

#define beam_destroy

#define beam_draw
	draw_sprite_ext(sprite_index, image_index, xstart + lengthdir_x(12, image_angle), ystart + lengthdir_y(12, image_angle), image_xscale - 16, image_yscale, image_angle, image_blend, 1.0);
	if x != xstart draw_sprite_ext(spr_tail, 0, xstart, ystart, 1, image_yscale, image_angle, image_blend, 1.0);
	if x != xstart draw_sprite_ext(spr_head, 0, x, y, 1, image_yscale*1, image_angle, image_blend, 1.0);
	draw_set_blend_mode(bm_add);
	draw_sprite_ext(sprite_index, image_index, xstart + lengthdir_x(12, image_angle), ystart + lengthdir_y(12, image_angle), image_xscale - 18, 1.5*image_yscale, image_angle, image_blend, 0.1+skill_get(17)*.05);
	if x != xstart draw_sprite_ext(spr_tail, 0, xstart, ystart, 1, image_yscale*1.5, image_angle, image_blend, 0.15+skill_get(17)*.05);
	if x != xstart draw_sprite_ext(spr_head, 0, x, y, 1.5, image_yscale*1.5, image_angle, image_blend, 0.1+skill_get(17)*.05);
	draw_set_blend_mode(bm_normal);

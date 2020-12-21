#define init
global.sprQuartzLaser  = sprite_add_weapon("sprites/weapons/sprQuartzLaser.png" , 6, 4);
global.sprQuartzLaser1 = sprite_add_weapon("sprites/weapons/sprQuartzLaser1.png", 6, 4);
global.sprQuartzLaser2 = sprite_add_weapon("sprites/weapons/sprQuartzLaser2.png", 6, 4);
global.sprBeam = sprite_add("sprites/projectiles/sprQuartzBeam.png",1,2,5)
global.sprBeamStart = sprite_add("sprites/projectiles/sprQuartzBeamStart.png",1,4,5)
global.sprBeamEnd   = sprite_add("sprites/projectiles/sprQuartzBeamEnd.png",1,4,5)
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
return 18
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
	with instance_create(x, y, CustomProjectile){
		sprite_start = global.sprBeamEnd;
		sprite_mid   = global.sprBeam;
		sprite_end   = global.sprBeamStart;
		mask_index   = mskDisc;

		creator = other;
		team = other.team;

		hyperspeed = 4;
		bounce = 3;
		damage = 4;
		force  = 4;
		xprev = x;
		yprev = y;
		image_yscale = 1;

		direction = creator.gunangle
		on_step = laser_step;
		on_draw = laser_draw;
		on_hit  = void;
	}

#define void

#define laser_step
	var _d = 0,
			_h = 0;

			xprev = x;
			yprev = y;
	do{
		var _hspd = lengthdir_x(hyperspeed / 2, direction),
		    _vspd = lengthdir_y(hyperspeed / 2, direction);

		_d += hyperspeed
		if _h <= 0 && place_meeting(x + _hspd, y, Wall){
			_hspd *= -1;
			bounce--;
			_h++;

			repeat(4) with instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust){sprite_index = sprExtraFeetDust}
			with instance_create(x, y, ImpactWrists) {image_speed = .7}
		}
		if _h <= 0 && place_meeting(x, y + _vspd, Wall){
			_vspd *= -1;
			bounce--;
			_h++;

			repeat(4) with instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust){sprite_index = sprExtraFeetDust}
			with instance_create(x, y, ImpactWrists) {image_speed = .7}
		}
		if _h <= 0 && place_meeting(x + _hspd, y + _vspd, Wall){
			_hspd *= -1;
			_vspd *= -1;
			bounce--;
			_h++;
			repeat(4) with instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust){sprite_index = sprExtraFeetDust}
			with instance_create(x, y, ImpactWrists) {image_speed = .7}
		}
		direction = point_direction(0, 0, _hspd, _vspd);

		if current_frame_active{
			with instances_matching_ne(hitme, "team", team){
				var _xx = lengthdir_x(sprite_get_width(other.sprite_start) * image_xscale, direction + 90),
				    _yy = lengthdir_y(sprite_get_width(other.sprite_start) * image_xscale, direction + 90),
						 _h = false;
				if collision_line(other.xprev + _xx, other.yprev + _yy, other.x + _xx, other.y + _yy, self, false, false) = self{
					_h = true;
				}
				var _xx = lengthdir_x(sprite_get_width(other.sprite_start) * image_xscale, direction - 90),
				    _yy = lengthdir_y(sprite_get_width(other.sprite_start) * image_xscale, direction - 90);
				if collision_line(other.xprev + _xx, other.yprev + _yy, other.x + _xx, other.y + _yy, self, false, false) = self{
					_h = true;
				}
			if _h = true{
				if current_frame mod 2 = current_time_scale with other{
					projectile_hit(other, damage, force, direction)
					_d += hyperspeed * other.size;
					}
				}
			}
		}

		 x += _hspd;
		 y += _vspd;

	}until _d >= 60 || bounce < 0
	if bounce <= 0 instance_destroy();

#define laser_draw
	draw_sprite_ext(sprite_mid  , 0, x, y, point_distance(x, y, xprev, yprev)/2, image_yscale, direction, image_blend, image_alpha);
	draw_sprite_ext(sprite_start, 0, x - lengthdir_x(point_distance(x, y, xprev, yprev)/2, direction), y - lengthdir_y(point_distance(x, y, xprev, yprev)/2, direction), 1, image_yscale, direction, image_blend, image_alpha);
	draw_sprite_ext(sprite_end  , 0, x - lengthdir_x(point_distance(x, y, xprev, yprev), direction), y - lengthdir_y(point_distance(x, y, xprev, yprev), direction), 1, image_yscale, direction, image_blend, image_alpha);

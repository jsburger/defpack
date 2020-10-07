#define init
  global.sprSmartSword = sprite_add_weapon("sprites/weapons/sprSmartSword.png", 3, 4);
  global.sprSmartAim 	 = sprite_add("sprites/interface/sprSmartAim.png", 0, 9, 9);
#define weapon_name
  return "SMART SWORD";
#define weapon_type
 return 0;
#define weapon_cost
  return 0;
#define weapon_area
  return -1;
#define weapon_load
  return 24;
#define weapon_swap
  return sndSwapSword;
#define weapon_auto
  return false;
#define weapon_melee
  return true;
#define weapon_laser_sight
  return false;
#define weapon_sprt
  return global.sprSmartSword;
#define weapon_text
  return "yea";

#define weapon_fire

  var _t = noone;

  with instances_matching(CustomObject, "name", "smart target handler"){
    if creator = other && _closeboy > -4{
      _t = _closeboy;
    }
  }

  with instance_create(x, y, CustomSlash){
    sprite_index = sprSlash;
    mask_index   = mskSlash;
    image_speed  = .5;

    var _a = other.gunangle;
    if _t > -4{
      _a = point_direction(x, y, _t.x, _t.y);
    }

    motion_add(_a, 2 + skill_get(mut_long_arms) * 2);
    image_angle = direction;

    team = other.team;
    creator = other;
    damage = 6;
    can_fix = false;

    //on_hit        = smart_hit;
    //on_projectile = smart_projectile;
  }

#define step
  with Player{
    if wep = mod_current || bwep = mod_current{
      var _hashandler = false;
      with instances_matching(CustomObject, "name", "smart target handler"){
        _hashandler = true;
      }
      if _hashandler = false{
        with instance_create(x, y, CustomObject){
          name = "smart target handler";
          creator = Player;
          depth = -9;

          aimoffset = 60;
          _closeboy = 0;
          has_target = false;

          on_step = targethandler_step;
          on_draw = targethandler_draw;
        }
      }
    }
  }

#define targethandler_step
  if !instance_exists(creator) || (creator.wep != mod_current && creator.bwep != mod_current){
    instance_delete(self);
    exit;
  }

  x = creator.x + creator.hspeed;
  y = creator.y + creator.vspeed;

  if creator.wep = mod_current || (creator.race = "steroids" && creator.bwep = mod_current){
    if instance_exists(enemy){
    	var closeboy = instance_nearest(mouse_x[creator.index],mouse_y[creator.index],enemy);
    	if _closeboy != closeboy{
        aimoffset = 60
        if collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) = noone{sound_play_pitch(sndSniperTarget,2)}
        _closeboy = closeboy
      }

    	var _x = _closeboy.x,
    	    _y = _closeboy.y;
      has_target = false;
      if !collision_line(x,y,_x,_y,Wall,0,0){
        aimoffset /= 1.3;
        has_target = true;
      }
    }
  }else{
    _closeboy = noone;
  }

#define targethandler_draw
  if _closeboy > noone{
    var _x = _closeboy.x,
        _y = _closeboy.y;

    if has_target = true{
    	draw_sprite_ext(global.sprSmartAim,image_index,_closeboy.bbox_left-aimoffset,  _closeboy.bbox_top-aimoffset,1,1,0,c_white,0.2+(60-aimoffset)/60)
    	draw_sprite_ext(global.sprSmartAim,image_index,_closeboy.bbox_left-aimoffset,  _closeboy.bbox_bottom+aimoffset,1,1,90,c_white,0.2+(60-aimoffset)/60)
    	draw_sprite_ext(global.sprSmartAim,image_index,_closeboy.bbox_right+aimoffset, _closeboy.bbox_top-aimoffset,1,1,270,c_white,0.2+(60-aimoffset)/60)
    	draw_sprite_ext(global.sprSmartAim,image_index,_closeboy.bbox_right+aimoffset, _closeboy.bbox_bottom+aimoffset,1,1,180,c_white,0.2+(60-aimoffset)/60)
    }
  }

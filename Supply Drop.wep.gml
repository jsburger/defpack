#define init
global.sprSupplyDrop = sprite_add_weapon("sprites/weapons/sprSupplyDrop.png", -1, 3);
global.area = sprite_add("sprites/projectiles/sprSupplyDropArea.png", 1, 8, 8);
global.ChestPool   = [WeaponChest, AmmoChest, HealthChest, "TankChest", "ThemedChest"];
global.ChestWeight = [          1,         1,           2,       .0001,            10];

#macro abris_mouse 0
#macro abris_manual 1
#macro abris_gunangle 2

#define weapon_rads
return 32;

#define weapon_name
return "SUPPLY DROP";

#define weapon_sprt
return global.sprSupplyDrop;

#define weapon_type
return 0;

#define weapon_auto
return 1;

#define weapon_load
return 48;

#define weapon_cost
return 6;

#define weapon_chrg
return true;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 8;

#define weapon_melee
return false;

#define nts_weapon_examine
return{
    "d": "Summons a weapon from a place far away in the past. ",
}

#define weapon_reloaded
weapon_post(-1,-3,0)
sound_play_pitchvol(sndNadeReload,1.4,.6)

#define weapon_text
return choose("FROM ANOTHER DIMENSION");

#define weapon_fire
var _strtsize = 14;
var _endsize  = 13;
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
	accspeed = 10
	damage = 0
	maxdamage = 12
  lockon = -1;
	name = mod_current
	payload = script_ref_create(pop)
  on_draw = pop_draw;
}
sound_play_pitch(sndSniperTarget,2.5)

#define pop
  with instance_create(x, y, CustomObject){
  	creator = other.creator
  	team    = other.team
  	damage = 20
    force  = 12

    var _chest = determine_chest();
    switch _chest{
      /*case "TankChest":
        trace("tank chest")
        chest = mod_script_call("mod", "tank", "crate_create", -1000, -1000);
        break;*/
      case "ThemedChest":
        trace("themed chest")
        var _q = mod_script_call("mod", "chest", "get_chests", 0, GameCont.hard);
        if array_length(_q){
            chest = mod_script_call("mod", "chest", "customchest_create", x, y, _q[irandom(array_length(_q) - 7)])
        }
        break;
      default:
        chest = instance_create(-1000, -1000, _chest);
        break;
    }
    zspeed = 64;
    z = 30 * 2 * zspeed;
    sprite_index = chest.sprite_index;
    image_speed = 0;
    image_alpha = 0;

    on_step = chestdrop_step;
    on_draw = chestdrop_draw;
  }

#define chestdrop_step
  z -= zspeed * current_time_scale;
  if z <= 0{
    z = 0;
    with create_sonic_explosion(x, y){
      team = other.team;
      creator = other.creator;
      force = 24;
      image_xscale = .5;
      image_yscale = .5;
    }
    sleep(20);
    view_shake_max_at(x, y, 32);
    repeat(24){
      with instance_create(x, y, Dust){
        motion_add(random(360), 3 + irandom(7));
      }
    }
    repeat(12){
      with Wall{
        if distance_to_object(other) <= 28{
          instance_create(x, y, FloorExplo);
          instance_destroy();
        }
      }
    }

    chest.x = x;
    chest.y = y;
    chest.image_index = 1;
    instance_delete(self);
  }

#define chestdrop_draw
  draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, 1);

#define pop_draw
if instance_exists(creator){
    var _x, _y, c = creator, ang;
    if targeting == abris_mouse{
        _x = c.x + lengthdir_x(point_distance(c.x, c.y, mouse_x[index], mouse_y[index]), c.gunangle)
        _y = c.y + lengthdir_y(point_distance(c.x, c.y, mouse_x[index], mouse_y[index]), c.gunangle)
        ang = c.gunangle
    }
    else if targeting == abris_manual{
        _x = c.y + lengthdir_x(length, angle)
        _y = c.x + lengthdir_y(length, angle)
        ang = angle
    }else if targeting == abris_gunangle{
        _x = c.y + lengthdir_x(length, c.gunangle + angle)
        _y = c.x + lengthdir_y(length, c.gunangle + angle)
        ang = c.gunangle + angle
    }

		//experimental autoaim
		if lockon >= 0 {
			var _e = mod_script_call("mod", "defpack tools", "instance_nearest_matching_los_ne", _x, _y, hitme, "team", creator.team),
			    _dis = _e > -4 ? point_distance(creator.x, creator.y, _e.x, _e.y) : 0,
				_dir = _e > -4 ? point_direction(creator.x, creator.y, _e.x, _e.y) : 0;
			if _e > -4 && collision_line(creator.x, creator.y, _e.x ,_e.y, Wall, 0, 0) = noone && point_distance(mouse_x[index], mouse_y[index], _e.x, _e.y) <= (margin + ((6 + (20 * lockon / max(creator.accuracy, 0.1))) * !lq_get(defcharge, "blinked"))){
				_x = c.x + lengthdir_x(_dis + _e.hspeed, _dir);
				_y = c.y + lengthdir_y(_dis + _e.vspeed, _dir);
				lockon = true
			}
			else {
				lockon = false
			}
		}

    var w =  mod_script_call("mod", "defpack tools", "collision_line_first", creator.x, creator.y, _x, _y, Wall, 0, 0);
    x = w[0]
    y = w[1]

    var kick = hand ? creator.bwkick : creator.wkick, yoff = -4 * hand;
    var r = acc+accmin, sides = 4, a = 1 - acc/accbase,
    	_c = (mod_variable_get("mod", "defpack tools", "AbrisCustomColor") = true && instance_is(creator, Player)) ? player_get_color(creator.index) : lasercolour,
		_c2 = defcharge.charge > 0.99 && defcharge.charge < 1 && lq_get(defcharge, "blinked") = 0 ? c_white : _c;

    //Glow on gun
    draw_sprite_ext(sprHeavyGrenadeBlink, 0, c.x + lengthdir_x(14 - kick, ang), c.y + lengthdir_y(14 - kick, ang) + 1 + yoff, 1, 1, ang, _c, 1)
    //Actual boundary
    draw_sprite_ext(global.area, image_index, x, y, image_xscale, image_yscale, 0, _c2, image_alpha);
    //Laser pointer
    draw_line_width_color(c.x + lengthdir_x(16 - kick, ang), c.y + lengthdir_y(16 - kick, ang) + yoff, x, y, 1, _c, _c)
    //Fill the circle with stripes
    mod_script_call_nc("mod", "defpack tools", "draw_polygon_striped", sides, 13, 45, x, y, _c2, .1 + .3*a, scroll)

		with instances_matching_ne(hitme, "team", creator.team) {
			if !instance_is(self, prop) && point_distance(x, y, other.x, other.y) <= r {
				draw_set_fog(true, _c2, 0, 0)
				var _xscale = image_xscale * ("right" in self ? right : sign(hspeed))
				draw_sprite_ext(sprite_index, image_index, x - 1, y - 1, _xscale, image_yscale, image_angle, c_white, 1)
				draw_sprite_ext(sprite_index, image_index, x + 1, y - 1, _xscale, image_yscale, image_angle, c_white, 1)
				draw_sprite_ext(sprite_index, image_index, x - 1, y + 1, _xscale, image_yscale, image_angle, c_white, 1)
				draw_sprite_ext(sprite_index, image_index, x + 1, y + 1, _xscale, image_yscale, image_angle, c_white, 1)
				draw_set_fog(false, c_white, 0, 0)
			}
	 }
}

#define make_trail(range,direction)
var num = random_range(20,40)
var _x = lengthdir_x(range,direction), _y = lengthdir_y(range,direction)
with instance_create(x-random(_x),y-random(_y),Dust){
    motion_set(direction + num*choose(-1,1),3+random(1))
    x+=hspeed
    y+=vspeed
}

#define determine_chest()
  var _weight_total = 0;
  for(var _i = 0; _i < array_length(global.ChestPool); _i++){
    _weight_total += global.ChestWeight[_i];
  }

  var _round = random(_weight_total);
  for(_i = 0; _i < array_length(global.ChestPool); _i++){
    if(_round < global.ChestWeight[_i]){
      return global.ChestPool[_i];
    }
    _round -= global.ChestWeight[_i];
  }

#define create_sonic_explosion(_x, _y) return mod_script_call("mod", "defpack tools", "create_sonic_explosion", _x, _y);

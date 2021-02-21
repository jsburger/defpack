#define init
global.new_level = (instance_exists(GenCont) || instance_exists(Menu));
global.generated = false;

global.sprShrineBouncer = sprite_add("../sprites/shrine/sprShrineBouncer.png", 1, 9, 9);
global.sprShrinePest    = sprite_add("../sprites/shrine/sprShrinePest.png",    1, 9, 9);
global.sprShrineThunder = sprite_add("../sprites/shrine/sprShrineThunder.png", 1, 9, 9);
global.sprShrineFire    = sprite_add("../sprites/shrine/sprShrineFire.png",    1, 9, 9);
global.sprShrinePsy     = sprite_add("../sprites/shrine/sprShrinePsy.png",     1, 9, 9);

global.binds = [
	[noone, CustomStep, 0, script_ref_create(prompt_step)]
];

with(instances_matching(CustomObject, mod_current + " controller", true)){
	global.binds = binds;
	instance_delete(self);
}

#define cleanup
with(instance_create(0, 0, CustomObject)){
	variable_instance_set(self, mod_current + " controller", true);
	binds = global.binds;
}

#macro infinity 1 / 0
#macro negative_infinity -1 / 0

#macro bbox_center_x (bbox_right + bbox_left + 1) * 0.5
#macro bbox_center_y (bbox_bottom + bbox_top + 1) * 0.5
#macro bbox_width bbox_right - bbox_left + 1
#macro bbox_height bbox_bottom - bbox_top + 1

#macro area_campfire 0
#macro area_desert 1
#macro area_sewers 2
#macro area_scrapyards 3
#macro area_caves 4
#macro area_city 5
#macro area_labs 6
#macro area_palace 7

#macro area_vault 100
#macro area_oasis 101
#macro area_pizza_sewers 102
#macro area_mansion 103
#macro area_cursed_caves 104
#macro area_jungle 105
#macro area_hq 106
#macro area_crib 107

// distance to room, from spawn/first player
#macro SAFE_DIST 128

// how much the room should be separated from the level
#macro MAX_HALLWAY_DIST 256
#macro MIN_HALLWAY_DIST 64

// width and height of room, in floor tiles (32x32)
#macro ROOM_WIDTH 3
#macro ROOM_HEIGHT 3

// area that the room should look like
#macro ROOM_AREA area_vault

#define game_start


#define level_start
if (!global.generated && !instance_exists(Menu) && variable_instance_get(GameCont, "area", ROOM_AREA) == 100) && skill_get("prismaticiris") > 0{
	global.generated = true;
	
	var _x = 10016;
	var _y = 10016;
	
	with(instances_matching([Player, Revive], "", null)){
		_x = x;
		_y = y;
		break;
	}
	
	var _normal = instances_matching(Floor, "object_index", Floor);
	var _floors = instances_random_min_distance(_x, _y, SAFE_DIST, _normal);
	var _found = [];
	
	with(_floors){
		var _sides = [];
		
		if (array_length(instance_rectangle_bbox(bbox_left - bbox_width - 1, bbox_top, bbox_left - 1, bbox_bottom, [Wall, InvisiWall])) <= 0){
			array_push(_sides, 180);
		}
		
		if (array_length(instance_rectangle_bbox(bbox_left, bbox_top - bbox_height - 1, bbox_right, bbox_top - 1, [Wall, InvisiWall])) <= 0){
			array_push(_sides, 90);
		}
		
		if (array_length(instance_rectangle_bbox(bbox_right + 1, bbox_top, bbox_right + bbox_width + 1, bbox_bottom, [Wall, InvisiWall])) <= 0){
			array_push(_sides, 0);
		}
		
		if (array_length(instance_rectangle_bbox(bbox_left, bbox_bottom + 1, bbox_right, bbox_bottom + bbox_height + 1, [Wall, InvisiWall])) <= 0){
			array_push(_sides, 270);
		}
		
		array_push(_found, [self, _sides]);
	}
	
	if (array_length(_found) <= 0){
		with(instance_furthest_bbox(_x, _y, _normal)){
			array_push(_found, [self, [round(point_direction(_x, _y, clamp(_x, bbox_left, bbox_right), clamp(_y, bbox_top, bbox_bottom)) / 90) * 90]]);
		}
	}
	
	var absolute_width = ROOM_WIDTH * 32;
	var absolute_height = ROOM_HEIGHT * 32;
	var _max = max(floor((absolute_width / 2) / 32) * 32, floor((absolute_height / 2) / 32) * 32);
	
	var max_dist = MAX_HALLWAY_DIST + _max;
	var min_dist = MIN_HALLWAY_DIST + _max;
	
	var walls_and_floors = instances_matching([Wall, InvisiWall], "", null);
	array_copy(walls_and_floors, array_length(walls_and_floors), _normal, 0, array_length(_normal));
	
	var half_width = absolute_width / 2;
	var half_height = absolute_height / 2;
	var _created = false;
	
	with(_found){
		if (array_length(self) >= 2){
			var _floor = self[0];
			
			with(self[1]){
				with(_floor){
					var _sx = x;
					var _sy = y;
					var _fx = _sx;
					var _fy = _sy;
					
					var _width = bbox_width;
					var _height = bbox_height;
					
					var _dist = 0;
					var _extended = 0;
					
					// travel in direction from starting floor
					while (_dist < max_dist){
						var min_i = floor((_fx - half_width) / _width) * _width + 16;
						var max_i = min_i + absolute_width;
						var min_j = floor((_fy - half_height) / _height) * _height + 16;
						var max_j = min_j + absolute_height;
						
						// there's space for the room, make it
						if (_dist > min_dist && array_length(instance_rectangle_bbox(min_i, min_j, max_i, max_j, walls_and_floors)) <= 0/* && array_length(build_path("jps", "octile", false, "octile", "none", [Wall, InvisiWall], 16, _x, _y, _sx, _sy)) > 0*/){
							_created = true;
							
							// easy
							var _pos = room_create(_fx, _fy, other, _extended, _width, _height, min_i, min_j, max_i, max_j, ROOM_AREA);
							
							Dummy_create(_pos[0], _pos[1]);
							
							break;
						}
						
						_fx += lengthdir_x(_width, other);
						_fy += lengthdir_y(_height, other);
						
						_dist = point_distance(_sx, _sy, _fx, _fy);
						_extended += 1;
					}
				}
				
				if (_created){
					break;
				}
			}
		}
		
		if (_created){
			break;
		}
	}
}

#define room_create(hall_x, hall_y, hall_dir, hall_count, _width, _height, _x1, _y1, _x2, _y2, _area)
var room_floors = [];

// room construction
for (var i = _x1; _x2 > i; i += _width){
	for (var j = _y1; _y2 > j; j += _height){
		with(instance_create(i, j, Floor)){
			array_push(room_floors, self);
		}
	}
}

var _nfx = hall_x;
var _nfy = hall_y;

// build the hallway
for (var i = 0; hall_count >= i; i ++){
	_nfx -= lengthdir_x(_width, hall_dir);
	_nfy -= lengthdir_y(_height, hall_dir);
	
	if (!position_meeting(_nfx, _nfy, Floor)){
		with(instance_create(_nfx, _nfy, Floor)){
			array_push(room_floors, self);
			
			with(instances_meeting(x, y, Wall)){
				instance_delete(self);
			}
		}	
	}
	
	else{
		var _floors = instances_at(_nfx, _nfy, Floor);
		array_copy(room_floors, array_length(room_floors), _floors, 0, array_length(_floors));
	}
}

var room_walls = [];

with(room_floors){
	for (var i = bbox_left - 16; bbox_right + 16 >= i; i += 16){
		for (var j = bbox_top - 16; bbox_bottom + 16 >= j; j += 16){
			if (!position_meeting(i, j, Floor)){
				if (!position_meeting(i, j, Wall)){
					array_push(room_walls, instance_create(i, j, Wall));
				}
				
				else{
					var _walls = instances_at(i, j, Wall);
					array_copy(room_walls, array_length(room_walls), _walls, 0, array_length(_walls));
				}
			}
		}
	}
}

var room_smalls = [];

with(room_walls){
	for (var i = x - 16; x + 16 >= i; i += 16){
		for (var j = y - 16; y + 16 >= j; j += 16){
			if (!position_meeting(i, j, Floor)){
				if (!position_meeting(i, j, Wall)){
					if (!position_meeting(i, j, TopSmall)){
						array_push(room_smalls, instance_create(i, j, TopSmall));
					}
					
					else{
						var _smalls = instances_at(i, j, TopSmall);
						array_copy(room_smalls, array_length(room_smalls), _smalls, 0, array_length(_smalls));
					}
				}
				
				else{
					var _walls = instances_at(i, j, Wall);
					array_copy(room_walls, array_length(room_walls), _walls, 0, array_length(_walls));
				}
			}
		}
	}
}

var room_objects = room_floors;
array_copy(room_objects, array_length(room_objects), room_walls, 0, array_length(room_walls));
array_copy(room_objects, array_length(room_objects), room_smalls, 0, array_length(room_smalls));

var _sprite = {
	sprFloor1: -1,
	sprFloor1B: -1,
	sprFloor1Explo: -1,
	sprWall1Trans: -1,
	sprWall1Bot: -1,
	sprWall1Out: -1,
	sprWall1Top: -1,
	sprDebris1: -1
};

var sprite_count = lq_size(_sprite);

if (is_string(_area)){
	if (!mod_script_exists("area", _area, "area_sprite")){
		_area = area_vault;
	}
	
	else{
		for (var i = 0; sprite_count > i; i ++){
			var _key = lq_get_key(_sprite, i);
			var new_sprite = mod_script_call("area", _area, "area_sprite", asset_get_index(_key));
			
			if (is_real(new_sprite) && floor(new_sprite) == new_sprite && sprite_exists(new_sprite)){
				lq_set(_sprite, _key, new_sprite);
			}
			
			else{
				lq_set(_sprite, _key, asset_get_index(string_replace(_key, "1", string_auto(area_vault))));
			}
		}
	}
}

if (is_real(_area)){
	for (var i = 0; sprite_count > i; i ++){
		var _key = lq_get_key(_sprite, i);
		lq_set(_sprite, _key, asset_get_index(string_replace(_key, "1", string_auto(_area))));
	}
}

with(room_objects){
	switch(object_index){
		case Floor: sprite_index = (styleb ? lq_get(_sprite, "sprFloor1B") : lq_get(_sprite, "sprFloor1")); break;
		
		case Wall:{
			sprite_index = lq_get(_sprite, "sprWall1Bot");
			outspr = lq_get(_sprite, "sprWall1Out");
			topspr = lq_get(_sprite, "sprWall1Top");
			
			break;
		}
		
		case TopSmall: sprite_index = lq_get(_sprite, "sprWall1Trans"); break;
	}
	
	if (bbox_left < _x1){
		_x1 = bbox_left;
	}
	
	if (bbox_top < _y1){
		_y1 = bbox_top;
	}
	
	if (bbox_right > _x2){
		_x2 = bbox_right;
	}
	
	if (bbox_bottom > _y2){
		_y2 = bbox_bottom;
	}
}

with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, [Bones, TopPot])){
	instance_delete(self);
}

return [hall_x + 16, hall_y + 16];

#define step
if (instance_exists(GenCont) || instance_exists(Menu)){
	global.new_level = true;
}

else if (global.new_level){
	global.new_level = false;
	level_start();
	global.generated = false;
}

var bind_count = array_length(global.binds);

for (var i = 0; bind_count > i; i ++){
	var _bind = global.binds[i];
	
	if (array_length(_bind) >= 4 && !instance_exists(_bind[0])){
		with(instance_create(0, 0, _bind[1])){
			persistent = true;
			depth = _bind[2];
			mod_source = mod_current;
			script = _bind[3];
			
			global.binds[i][@0] = self;
		}
	}
}

#define Dummy_create(_x, _y)
with(instance_create(_x, _y, CustomEnemy)){
	team = 1;
	
	name = "Iris Shrine";
	
	sprite_index = sprTargetIdle;
	mask_index = mskNone;
	spr_shadow = shd32;
	spr_shadow_y = -2;
	
	spr_idle = sprite_index;
	spr_walk = spr_idle;
	spr_hurt = sprTargetHurt;
	spr_dead = sprTargetDead;
	
	maxhealth = 500;
	my_health = maxhealth;
	
	candie = false;
	
	startx = x;
	starty = y;
	
	pool = ["quiveringsight", "blazingvisage", "pestilentgaze", "cloudedstare", "allseeingeye"];
	for( var _i = 0; _i < 3; _i++){
		with _i{
			if race = "horror"{
				array_push(other.pool, "warpedperspective");
			}
		}
	}
	
	skill = 0;
	textcol = "@w";
	color = pool[irandom(array_length_1d(pool) - 1)];
	_i = 0;
	do{
		_i++;
		if mod_variable_get("skill", "prismaticiris", "color") = color{
			color = pool[irandom(array_length_1d(pool) - 1)];	
		}
	}until (mod_variable_get("skill", "prismaticiris", "color") != color || _i = 29)
		switch color{
		case "quiveringsight":		 skill = "bouncer"; textcol = "@y"; sprite_index = global.sprShrineBouncer; break;
		case "blazingvisage":		 skill = "fire";    textcol = "@r"; sprite_index = global.sprShrineFire;    break;
		case "pestilentgaze":   	 skill = "pest";    textcol = "@g"; sprite_index = global.sprShrinePest;    break;
		case "cloudedstare":         skill = "thunder"; textcol = "@b"; sprite_index = global.sprShrineThunder; break;
		case "allseeingeye":         skill = "psy";     textcol = "@p"; sprite_index = global.sprShrinePsy;		break;
		case "warpedperspective":    skill = "gamma";   textcol = "@g"; sprite_index = global.sprShrineGamma;	break;
	}
	
	
	my_prompt = prompt_create("Change" + textcol + " Iris");
	
	on_step = script_ref_create(Dummy_step);
	
	return self;
}

#define Dummy_step
if (!instance_exists(my_prompt)){
	my_prompt = prompt_create("Change" + textcol + " Iris");
}

x = startx;
y = starty;

if (player_is_active(my_prompt.pick)){
	

	if(mod_exists("skill", "prismaticiris")) {
		if(skill_get("prismaticiris") = 0) skill_set("prismaticiris", 1); // apply iris if it exists but isnt applied, just for weird cases with skill_set
		mod_variable_set("skill", "prismaticiris", "color", color);
	}
	
	sleep(5);
	view_shake_at(x, y, 8);
	sound_play(instance_nearest(x, y, Player).snd_chst);
	
	skill_set(color, 0); // Remove the skill
	player_convert(skill);
	
	
	candie = true;
	projectile_hit_raw(self, my_health, 0);
}

#define array_shuffle(_array)
	var _list = ds_list_create();
	ds_list_add_array(_list, _array);
	ds_list_shuffle(_list);
	var _a = ds_list_to_array(_list);
	ds_list_destroy(_list);
	return _a;

#define instances_random_min_distance(_x, _y, _distance, _obj)
	var _search = array_shuffle(instances_matching(_obj, "", null));
	var _found = [];
	
	with(_search){
		if (distance_to_point(_x, _y) > _distance){
			array_push(_found, self);
		}
	}
	
	return _found;

#define instance_furthest_bbox(_x, _y, _obj)
	var min_dist = negative_infinity;
	var _found = noone;
	
	with(instances_matching(_obj, "", null)){
		var _dist = point_distance(_x, _y, clamp(_x, bbox_left, bbox_right), clamp(_y, bbox_top, bbox_bottom));
		
		if (_dist > min_dist){
			min_dist = _dist;
			_found = self;
		}
	}
	
	return _found;

#define build_path(_algorithm, _cost, _smooth, _heuristic, _diagonal, _wall, _dist, _x1, _y1, _x2, _y2)
	return mod_script_call("mod", "pathfinding 3", "build_path", _algorithm, _cost, _smooth, _heuristic, _diagonal, _wall, _dist, _x1, _y1, _x2, _y2);

#define path_furthest_visible(_x, _y, _path, _wall)
	return mod_script_call("mod", "pathfinding 3", "path_furthest_visible", _x, _y, _path, _wall);

// YokinScript:tm:
#define instances_at(_x, _y, _obj)
	return instances_matching_le(instances_matching_le(instances_matching_ge(instances_matching_ge(_obj, "bbox_right", _x), "bbox_bottom", _y), "bbox_left", _x), "bbox_top", _y);

#define instances_meeting(_x, _y, _obj)
	var _ox = x;
	var _oy = y;
	
	x = _x;
	y = _y;
	
	var _found = instances_matching_le(instances_matching_le(instances_matching_ge(instances_matching_ge(_obj, "bbox_right", bbox_left), "bbox_bottom", bbox_top), "bbox_left", bbox_right), "bbox_top", bbox_bottom);
	
	x = _ox;
	y = _oy;
	
	return _found;

#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)
	return instances_matching_le(instances_matching_le(instances_matching_ge(instances_matching_ge(_obj, "bbox_right", _x1), "bbox_bottom", _y1), "bbox_left", _x2), "bbox_top", _y2);

#define prompt_step
var _prompts = instances_matching(CustomObject, "name", "CustomPrompt");

if (array_length(_prompts) > 0){
	with(instances_matching_ne(_prompts, "pick", -1)){
		pick = -1;
	}
	
	if (instance_exists(Player)){
		_prompts = instances_matching(_prompts, "visible", true);
		
		if (array_length(_prompts) > 0){
			with(instances_matching(Player, "visible", true)){
				if (place_meeting(x, y, CustomObject) && !place_meeting(x, y, IceFlower) && !place_meeting(x, y, CarVenusFixed)){
					var no_van = true;
					
					if (instance_exists(Van) && place_meeting(x, y, Van)){
						with(instances_meeting(x, y, instances_matching(Van, "drawspr", sprVanOpenIdle))){
							if (place_meeting(x, y, other)){
								no_van = false;
								break;
							}
						}
					}
					
					if (no_van){
						var _nearest = noone;
						var max_dist = infinity;
						var max_depth = infinity;
						
						with(nearwep){
							max_dist = distance_to_object(other);
							max_depth = depth;
						}
						
						with(instances_meeting(x, y, _prompts)){
							if (place_meeting(x, y, other)){
								if (!instance_exists(creator) || creator.visible){
									if (array_length(on_meet) < 3 || mod_script_call(on_meet[0], on_meet[1], on_meet[2])){
										if (depth < max_depth){
											max_depth = depth;
											max_dist = infinity;
										}
										
										if (depth == max_depth){
											var _dist = distance_to_object(other);
											
											if (_dist < max_dist){
												max_dist = _dist;
												_nearest = self;
											}
										}
									}
								}
							}
						}
						
						with(_nearest){
							nearwep = instance_create(x + x_offset, y + y_offset, IceFlower);
							var _text = text;
							var the_prompt = nearwep;
							
							with(nearwep){
								name = _text;
								x = xstart;
								y = ystart;
								xprevious = x;
								yprevious = y;
								visible = false;
								mask_index = mskNone;
								sprite_index = mskNone;
								spr_idle = mskNone;
								spr_walk = mskNone;
								spr_hurt = mskNone;
								spr_dead = mskNone;
								spr_shadow = -1;
								snd_hurt = -1;
								snd_dead = -1;
								size = 0;
								team = 0;
								my_health = 99999;
								nexthurt = current_frame + 99999;
							}
							
							with(other){
								nearwep = the_prompt;
								
								if (button_pressed(index, "pick")){
									other.pick = index;
								}
							}
						}
					}
				}
			}
		}
	}
}

#define prompt_create(_text)
	var _depth = depth;
	
	with(CustomPrompt_create(x, y)){
		text = _text;
		creator = other;
		depth = _depth;
		
		return self;
	}
	
	return noone;

#define CustomPrompt_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		name = "CustomPrompt";
		
		mask_index = mskWepPickup;
		persistent = true;
		creator = noone;
		nearwep = noone;
		depth = object_get_depth(WepPickup);
		pick = -1;
		x_offset = 0;
		y_offset = 0;
		
		on_meet = null;
		
		on_begin_step = script_ref_create(CustomPrompt_begin_step);
		on_end_step = script_ref_create(CustomPrompt_end_step);
		on_cleanup = script_ref_create(CustomPrompt_cleanup);
		
		return self;
	}

#define CustomPrompt_begin_step
	with(nearwep){
		instance_delete(self);
	}

#define CustomPrompt_end_step
	var _nearwep = nearwep;
	var _x = x;
	var _y = y;
	
	with(creator){
		var _cx = x;
		var _cy = y;
		
		with(_nearwep){
			x += (_cx - _x);
			y += (_cy - _y);
			visible = true;
		}
		
		with(other){
			x = _cx;
			y = _cy;
		}
		
		exit;
	}
	
	instance_destroy();

#define CustomPrompt_cleanup
	with(nearwep){
		instance_delete(self);
	}
	
#define draw_dark()
	with instances_matching(CustomEnemy,"name","Iris Shrine"){
			draw_circle_color(x, y, 52 + random(3), c_gray, c_gray,0)
			draw_circle_color(x, y, 26 + random(3), c_black, c_black,0)
		}
	
#define player_convert(c)
	return mod_script_call_nc("skill", "prismaticiris", "player_convert", c);
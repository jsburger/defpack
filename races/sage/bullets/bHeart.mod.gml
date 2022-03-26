#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletHeart.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconHeart.png", 2, 5, 5);
  global.sHeartBase    = sprite_add("../../../sprites/sage/fx/HeartHudBase.png", 1, 12, 12);
  global.sHeartTop     = sprite_add("../../../sprites/sage/fx/HeartHudTop.png", 1, 12, 12);
  global.sHeartSurface = sprite_add("../../../sprites/sage/fx/HeartHudSurface.png", 1, 12, 12);
  global.sHeartOutline = sprite_add("../../../sprites/sage/fx/HeartHudOutline.png", 1, 12, 12);
  global.sprColorPickup[0] = sprite_add_weapon("../../../sprites/sage/fx/sprColorPickup1.png", 7, 7);
  global.sprColorPickup[1] = sprite_add_weapon("../../../sprites/sage/fx/sprColorPickup2.png", 7, 7);
  global.sprColorPickup[2] = sprite_add_weapon("../../../sprites/sage/fx/sprColorPickup3.png", 7, 7);
  
#macro c mod_variable_get("race", "sage", "colormap");
#macro maxcolor 100

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $5D8E25;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "SPELL HEART";

#define bullet_description
  return `@(color:${c.neutral})GATHER @(color:${c.spell})COLOR @(color:${c.neutral})FROM @wENEMIES#@(color:${c.neutral})USE @(color:${c.spell})COLOR @(color:${c.neutral})TO INCREASE @(color:${c.spell})SPELL POWER`

#define bullet_ttip
  return ["GATHER THE COLOR"];

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define on_take(power)
	if "sage_extra_spellpower" not in self sage_extra_spellpower = 0;
	sage_spellheart_hud = 40 / current_time_scale;

#define on_lose(power)

#define color_pickup_create(_x, _y)
	with instance_create(_x, _y, Pickup){

		sprite_index = global.sprColorPickup[irandom(2)];
		mask_index   = mskPickup;
		image_speed  = 0;
		image_angle  = random(360);

		name = "spellpower pickup";
		num = 1 + irandom(3);
		dontmove = 8 / current_time_scale;
		anim = 20 + irandom(30);
		lifetime = room_speed * 3;
		friction = 1;
		maxspeed = 6;

		on_pickup = color_pickup_open;

		return self;
	}


#define on_step
	// Create heart HUD if recently picked up color:
	if sage_spellheart_hud-- > 0{
	
		with instance_create(0, 0, CustomObject){
			
			creator = other;
			depth = -100;
		
			on_draw = shud_draw;
		}
	}

	// Drop color pickups:
	with instances_matching_le(enemy, "my_health", 0){
	
		repeat(max(1, size + 1)) if (irandom(floor(other.sage_extra_spellpower / 10)) == 0){
		
			with color_pickup_create(x, y){
			
				motion_add(random(360), 3 + irandom(2));
			}
		}
	}

#define step
	// Color pickup step:
	with instances_matching(Pickup, "name", "spellpower pickup"){
		
		// Eyes stuff:
		with instances_matching(Player, "race", "eyes") {
		if (canspec && button_check(index, "spec")) {
			var _vx = view_xview[index],
				_vy = view_yview[index];
			with instances_in_bbox(_vx, _vy, _vx + game_width, _vy + game_height, instances_matching(Pickup, "name", "QuartzPickup")) {
				var l = (1 + skill_get(mut_throne_butt)) * current_time_scale,
					d = point_direction(x, y, other.x, other.y),
					_x = x + lengthdir_x(l, d),
					_y = y + lengthdir_y(l, d);

					if(place_free(_x, y)) x = _x;
					if(place_free(x, _y)) y = _y;
				}
			}
		}
		
		// Collision:
		if(mask_index == mskPickup && place_meeting(x, y, Pickup)) {
			with(instances_meeting(x, y, instances_matching(Pickup, "mask_index", mskPickup))) {
				if(place_meeting(x, y, other)) {
					if(object_index == AmmoPickup || object_index == HPPickup || object_index == RoguePickup) {
						motion_add_ct(point_direction(other.x, other.y, x, y) + random_range(-10, 10), 0.8);
					}
					with(other) {
						motion_add_ct(point_direction(other.x, other.y, x, y) + random_range(-10, 10), 0.8);
					}
				}
			}
		}
		if place_meeting(x + hspeed, y + vspeed, Wall){move_bounce_solid(false)}
		
		// Choose closest sage with a spellheart:
		var _target = noone,
		    _colour = self;
		with instances_matching(Player, "race", "sage"){
			
			// Check if Player has Spell heart:
			var _has_heart = false;
			for(var _i = 0; _i < array_length(spellBullets) - 1; _i++){
			
				if (spell_call_nc(spellBullets[_i], "bullet_name", spellBullets[_i]) == "SPELL HEART"){
				
					_i = array_length(spellBullets);
					_has_heart = true;
					
				}
			}
			// Check if in los && close enough:
			if (collision_line(x, y, _colour.x, _colour.y, Wall, false, false) = -4 && _has_heart){
				
				if (_target == noone){
				
					_target = self;
				}else if (_target != self){
				
					if (point_distance(x, y, _colour.x, _colour.y) < point_distance(_target.x, _target.y, _colour.x, _colour.y)){
					
						_target = self;
					}
				}
			}
		}
		
		if (_target != noone && dontmove-- <= 0 && point_distance(x, y, _target.x, _target.y) <= (64 + skill_get(mut_plutonium_hunger) * 32)){
		
			motion_add(point_direction(x, y, _target.x + _target.hspeed_raw, _target.y + _target.vspeed_raw), 3);
			if speed > maxspeed speed = maxspeed;
			friction = .2;
		}
		
		// Get picked up
		if (!dontmove && place_meeting(x, y, Player)) || place_meeting(x, y, PortalShock) || instance_exists(BigPortal) {
			 // run open code
			script_execute(on_pickup, instance_nearest(x, y, Player))

			 // fx
			 var _p = random_range(.8, 1.2);
			sound_play_pitchvol(sndHyperCrystalSearch, 5 * _p, .4);
			instance_create(x, y,SmallChestPickup)
			instance_delete(id);
			exit;
		}

		// Animations:
		if anim > 0
			anim -= current_time_scale
		else {
			if image_index = 0 && image_speed = .5 {
				image_speed = 0
				anim = 70 + irandom(20)
			}
			else{image_speed = .5}
		}

		// Blink:
		if lifetime <= room_speed {
			if current_frame mod 2 < current_time_scale
				image_alpha++;
			if image_alpha > 1
				image_alpha = 0
		}

		// Disappear after a while:
		if lifetime > 0 {lifetime -= current_time_scale} else{sound_play_pitch(sndPickupDisappear, random_range(.8, 1.2)); instance_create(x, y,SmallChestFade); instance_destroy()}
	}
	

#define color_pickup_open(inst)
	if "sage_extra_spellpower" in inst{
		inst.sage_extra_spellpower = clamp(0, inst.sage_extra_spellpower + num, maxcolor);
		inst.sage_spellheart_hud = max(inst.sage_spellheart_hud, 40 / current_time_scale);
	}	

#define instances_meeting(_x, _y, _obj)
		var _tx = x,
		    _ty = y;

		    x = _x;
		    y = _y;
		    var r = instances_matching_ne(instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", bbox_left), "bbox_left", bbox_right), "bbox_bottom", bbox_top), "bbox_top", bbox_bottom), "id", id);
		    x = _tx;
		    y = _ty;
				return r;

#define shud_draw
	if !instance_exists(creator){instance_delete(self); exit}

	draw_set_visible_all(false);
	draw_set_visible(creator.index, true);

	draw_set_alpha(min(3, creator.sage_spellheart_hud) / 3);
	draw_sprite(global.sHeartBase, 0, creator.x + creator.hspeed_raw - 24, creator.y + creator.vspeed_raw);
	var _p = creator.sage_extra_spellpower / maxcolor;

	draw_sprite_part(global.sHeartOutline, 0, 0, (1 - _p) * 26, 26, 26,creator.x + creator.hspeed_raw - 39 + 2, creator.y + creator.vspeed_raw - 13 + (1 - _p) * 26);
	draw_sprite_part(global.sHeartTop,     0, 0, (1 - _p) * 24, 24, 24,creator.x + creator.hspeed_raw - 36, creator.y + creator.vspeed_raw - 12 + (1 - _p) * 24);
	draw_set_alpha(.7);
	draw_sprite_part(global.sHeartSurface, 0, 0, (1 - _p) * 24, 24, 1,creator.x + creator.hspeed_raw - 36, creator.y + creator.vspeed_raw - 12 + (1 - _p) * 24);
	
	draw_set_font(fntSmall);
	draw_set_alpha(min(3, creator.sage_spellheart_hud) / 3);
	draw_text_shadow(creator.x + creator.hspeed_raw - 24, creator.y + creator.vspeed_raw - 6, string(round(_p * 100)) + "%");
	draw_set_alpha(1);
	instance_destroy();

#define instances_in_bbox(left,top,right,bottom,obj) return instances_matching_gt(instances_matching_lt(instances_matching_gt(instances_matching_lt(obj,"bbox_top",bottom),"bbox_bottom",top),"bbox_left",right),"bbox_right",left)
#define spell_call_nc(spell, script, spelll) return mod_script_call("race", "sage", "spell_call_nc", spell, script, spelll);
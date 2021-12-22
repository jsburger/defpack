#define init
  global.sprBullet = sprite_add_weapon("../../../sprites/sage/bullets/sprBulletWarp.png", 7, 7);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconWarp.png", 0, 4, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $FF721F;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "HYPER";

#define bullet_ttip
  return ["@yBULLETS @sRIPPLE IN AIR", "CAPTIVE SPACIAL CAVITIES EX-8826:#TEMPORAL STABILITY ACHIEVED."];

#define bullet_area
  return 1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(2 + ceil(3 * power)) + ` @(color:${c.speed})HYPERSPEED#@(color:${c.neutral})+25% @(color:${c.accuracy})ACCURACY`;

#define on_take(power)
  sage_projectile_speed *= 1 - .35; // this one is hidden pssst
  if "sage_hitscan_strength" not in self {
    sage_hitscan_strength = 2 + ceil(3 * power);
  }else {

    sage_hitscan_strength += 2 + ceil(3 * power);
  }
  accuracy *= .75;

#define on_lose(power)
  sage_projectile_speed /= 1 - .35; // this one is hidden pssst
  sage_hitscan_strength -= 2 + ceil(3 * power);
  accuracy /= .75;

#define on_step(spellPower)
  with instances_matching_gt(instances_matching(Player, "race", "sage"), "sage_hitscan_strength", 0) {

      var _s = id;
	//trace(array_length(instances_matching_ne(instances_matching(projectile, "creator", _s), "sage_no_hitscan", 1)));
      with instances_matching_ne(instances_matching(projectile, "creator", _s), "sage_no_hitscan", 1) {


        sage_check_hitscan = true;

        // Flames are laggy if you hyperseed them so they get extra speed instead
        if instance_is(self, Flame) {

          if "sage_flame_epic" not in self {

            sage_flame_epic = true;
            speed += 4 + 2 * spellPower;
          }
        }

        // define sage_no_hitscan to exclude this from running hitscan
        else if !instance_is(self, Laser) && !instance_is(self, Lightning) {
          sageHitscan = creator.sage_hitscan_strength;
          run_hitscan(self, sageHitscan);
        }
      }
  }

#define on_fire
	var _p = random_range(.8, 1.2);
	var _s = sound_play_pitchvol(sndUltraCrossbow, 1.5 * _p, .5);
	audio_sound_set_track_position(_s, .3);

#define run_hitscan(_proj, _mod)
	with(_proj){
		var size = 0.8;
		trace_time();
		repeat(_mod){
			if(!instance_exists(self)){continue;}
			event_perform(ev_step, ev_step_begin);
			if(!instance_exists(self)){continue;}
			event_perform(ev_step, ev_step_normal);
			if(!instance_exists(self)){continue;}
			if(image_index >= image_number){
				event_perform(ev_other, ev_animation_end)
			}
			if(!instance_exists(self)){continue;}
			image_index += image_speed_raw;
			if(!instance_exists(self)){continue;}
			with(instance_create(x,y,Effect)){
				sprite_index = other.sprite_index;
				image_index = other.image_index;
				image_speed = 0;
				image_xscale = other.image_xscale// * size;
				image_yscale = other.image_yscale// * size;
				image_alpha = other.image_alpha * size;
				image_angle = other.image_angle;
				if(fork()){
					if(instance_exists(self)){
						image_alpha *= 0.5;
						//image_xscale *= 0.8;
						//image_yscale *= 0.8;
					}
					wait(1);
					if(instance_exists(self)){
						image_alpha *= 0.5;
						//image_xscale *= 0.8;
						//image_yscale *= 0.8;
					}
					wait(1);
					if(instance_exists(self)){
						image_alpha *= 0.5;
						//image_xscale *= 0.8;
						//image_yscale *= 0.8;
					}
					wait(1);
					if(instance_exists(self)){
						instance_destroy();
					}
					exit;
				}
			}
			if(!instance_exists(self)){continue;}
			var _obj = noone;
			if("sage_hitbounce" in self && sage_hitbounce > 0){
				_obj = mod_script_call("mod", "SageMod", "hitbounce", self, 16);
				if(!instance_exists(self)){continue;}
			}
			xprevious = x;
			yprevious = y;
			x += hspeed_raw;
			y += vspeed_raw;
			if(!instance_exists(self)){continue;}
			if("sage_bounce" in self && sage_bounce > 0){
				mod_script_call("mod", "SageMod", "bounce", self);
				if(!instance_exists(self)){continue;}
			}
			var _inst = instances_meeting(x, y, [projectile, hitme, Wall]);
			with(_inst){
				if(!instance_exists(_proj)){continue;}
				if("nexthurt" in self){nexthurt -= current_time_scale;}
				with(_proj){
					event_perform(ev_collision, other.object_index);
					if(!instance_exists(self)){
						if("sage_hitbounce" in self && sage_hitbounce > 0){
							 // Anti-Duplicate Insurance:
							if(_obj != noone && is_array(_obj)){
								with(_obj[0]){
									 // Delete:
									if(instance_exists(_obj[1])){
										instance_delete(id);
									}

									 // Activate:
									else{
										mask_index = _obj[2];

										 // Sound:
										sound_play_hit(sndShotgunHitWall, 0.2);

										 // Reset Bonus:
										bonus  = true;
										alarm2 = 2;
									}
								}
							}
						}
						continue;
					}
				}
			}
			if(!instance_exists(self)){continue;}
			event_perform(ev_step, ev_step_end);
			if(!instance_exists(self)){continue;}
			if("sage_hitbounce" in self && sage_hitbounce > 0){
				 // Anti-Duplicate Insurance:
				if(_obj != noone && is_array(_obj)){
					with(_obj[0]){
						 // Delete:
						if(instance_exists(_obj[1])){
							instance_delete(id);
						}

						 // Activate:
						else{
							mask_index = _obj[2];

							 // Sound:
							sound_play_hit(sndShotgunHitWall, 0.2);

							 // Reset Bonus:
							bonus  = true;
							alarm2 = 2;
						}
					}
				}
			}
			if(!instance_exists(self)){continue;}
			size += 0.2/_mod
		}
		//trace_time("");
		if(!instance_exists(self)){continue;}
		with(instance_create(x,y,Effect)){
			sprite_index = other.sprite_index;
			image_index = other.image_index;
			image_speed = 0;
			image_xscale = other.image_xscale// * size;
			image_yscale = other.image_yscale// * size;
			image_alpha = other.image_alpha * size;
			image_angle = other.image_angle;
			if(fork()){
				if(instance_exists(self)){
					image_alpha *= 0.5;
					//image_xscale *= 0.8;
					//image_yscale *= 0.8;
				}
				wait(1);
				if(instance_exists(self)){
					image_alpha *= 0.5;
					//image_xscale *= 0.8;
					//image_yscale *= 0.8;
				}
				wait(1);
				if(instance_exists(self)){
					image_alpha *= 0.5;
					//image_xscale *= 0.8;
					//image_yscale *= 0.8;
				}
				wait(1);
				if(instance_exists(self)){
					instance_destroy();
				}
				exit;
			}
		}
	}

#define instances_meeting(_x, _y, _obj)
	/*
		Returns all instances whose bounding boxes overlap the calling instance's bounding box at the given position
		Much better performance than manually performing 'place_meeting(x, y, other)' on every instance
	*/

	var	_tx = x,
		_ty = y;

	x = _x;
	y = _y;

	var _inst = instances_matching_ne(instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", bbox_left), "bbox_left", bbox_right), "bbox_bottom", bbox_top), "bbox_top", bbox_bottom), "id", id);

	x = _tx;
	y = _ty;

	return _inst;
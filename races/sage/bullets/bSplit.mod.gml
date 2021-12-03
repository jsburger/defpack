#define init
  global.sprBullet = sprite_add_weapon("../../../sprites/sage/bullets/sprBulletSplit.png", 7, 7);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconSplit.png", 0, 5, 5);
  
  player_fire_at_init()

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $59A819;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "SPLIT";

#define bullet_ttip
  return ["DUPLICATION TECHNOLOGY"];

#define bullet_area
  return 1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(spellPower)
  return `@(color:${c.neutral})+` + string(ceil(1 + 1 * spellPower)) + ` @(color:${c.projectile})PROJECTILE` + (ceil(1 + 1 * spellPower) = 1 ? "" : "S") + ` @(color:${c.neutral})fired#+` + string(round(100 + 100 * spellPower)) +  `% @(color:${c.ammo})AMMO COST`;

#define on_take(spellPower)
    if "sage_projectiles" not in self {
        sage_projectiles = ceil(1 + 1 * spellPower);
    }
    else {
        sage_projectiles += ceil(1 + 1 * spellPower);
    }
    sage_ammo_cost += ceil(1 + 1 * spellPower);
  
    reloadspeed += get_split_shots(spellPower) - 1
  
    canaim = false


#define on_lose(spellPower)
    canaim = true
    
    reloadspeed -= get_split_shots(spellPower) - 1

    sage_projectiles -= ceil(1 + 1 * spellPower);
    sage_ammo_cost -= ceil(1 + 1 * spellPower);


#define on_pre_fire(spellPower)

	var base_gun = get_base_gun_index(spellPower),
		offset = get_angle_offset(accuracy, spellPower),
		shots = get_split_shots(spellPower),
		base_angle = gunangle - base_gun * offset;
		
	for (var i = 0; i < shots; i++) {
		if i != base_gun {
			var angoff = (i - base_gun) * offset;
			var event = {
				cancelled: false,
				angle_offset: angoff
			}
			var shootEvent = mod_script_call_self("race", "sage", "before_sage_shoot");
		    player_fire_at(undefined, undefined, undefined, event.angle_offset)
		    mod_script_call_self("race", "sage", "mid_firing", event)
		    mod_script_call_self("race", "sage", "post_sage_shoot", shootEvent)
		}
	}
	
	
/*
potential ammo cost system

each bullet (that matters) has ammo_priority and ammo_multiplier

when sage's fire script is called, make an array and iterate through all bullets.
	push the priority of the bullet + the index of the bullet divided by 10000 to the array
	sort the array
	iterate through the array in order, using frac to get the indexes of the bullets (in spellBullets) back
	push the bullets into an array in order using those indexes
	iterate through now priority sorted array
		multiply base cost of gun by results in order
		each cost script can accept a bool for if its multipier applies during subtraction or only during calculation (ultra has 0 in the latter and one in the former)
		if calculated cost passes, continue with fire script, else dont even call fire.
*/
    
#define get_base_gun_index(spellPower)
	return floor(get_split_shots(spellPower-1)/2);

#define get_split_angle_range(acc, spellPower)
	return (get_split_shots(spellPower) - 1 ) * get_angle_offset(acc, spellPower)

#define get_angle_offset(acc, spellPower)
    return (20 - 3 * spellPower) * acc;
    
#define get_split_shots(spellPower)
	return ceil(2 + spellPower)

#define on_step(spellPower)
    gunangle = point_direction(x, y, mouse_x[index], mouse_y[index]) - get_split_angle_range(accuracy, spellPower)/2 + get_angle_offset(accuracy, spellPower) * get_base_gun_index(spellPower)
    

#define balls

  with instances_matching_ge(Player, "sage_projectiles", 1) {
  var     a = sage_spell_power,
      angle = (27 + 7 * a) * accuracy,
     amount = ceil(2 + a);

  for(var _i = 0; _i < amount; _i++) {

    with instances_matching(instances_matching_ne(projectile, "sage_no_split", amount), "creator", self) {

      if "sage_no_split" not in self {

        sage_no_split = 1;
      }else {

        sage_no_split++;
      }

      // Special split case for lasers because they dont want to cooperate on their own:
      if instance_is(self, Laser) {

        with instance_create(xstart, ystart, Laser) {

          alarm0 = 1;
          team = other.team;
          creator = other.creator;
          image_angle = other.image_angle -angle + _i * angle + angle / 2 * (1 - a);
          direction = image_angle;
          sageCheck = other.sageCheck
          sage_no_split = amount;
        }
      }else with(instance_copy(false)) {

        sage_no_split = amount;
        if !instance_is(self, Lightning) {

          image_angle += -angle + _i * angle + angle / 2 * (1 - a);
          direction   += -angle + _i * angle + angle / 2 * (1 - a);
        }
      }

      if sage_no_split = amount instance_delete(self);
    }
  }
}






//All of this is written by YOKIN

#macro epsilon
	0.00001
	
#macro instance_max
	instance_create(0, 0, DramaCamera)
	
#macro current_frame_active
	((current_frame + epsilon) % 1) < current_time_scale
	
#define player_fire_at_init
	 // Lists of Object Event Variables:
	global.object_event_varname_list_map = ds_map_create();
	with([CustomObject, CustomHitme, CustomProp, CustomProjectile, CustomSlash, CustomEnemy, CustomScript, CustomBeginStep, CustomStep, CustomEndStep, CustomDraw]){
		var _eventVarNameList = [];
		with(instance_create(0, 0, self)){
			with(["on_step", "on_begin_step", "on_end_step", "on_draw", "on_destroy", "on_cleanup", "on_anim", "on_death", "on_hurt", "on_hit", "on_wall", "on_projectile", "on_grenade", "script"]){
				if(self in other){
					array_push(_eventVarNameList, self);
				}
			}
			instance_delete(self);
		}
		global.object_event_varname_list_map[? self] = _eventVarNameList;
	}
	
#define player_fire_raw // ?wep
	/*
		Called from a Player or FireCont instance to fire a given weapon from them without using ammo, adding reload, creating effects, etc.
		
		Args:
			wep - The weapon to shoot (defaults to the firing instance's held weapon)
	*/
	
	var	_wep    = ((argument_count > 0) ? argument[0] : (("wep" in self) ? wep : wep_none)),
		_rawWep = _wep;
		
	 // Find Base Weapon:
	while(is_object(_rawWep) && "wep" in _rawWep){
		_rawWep = _rawWep.wep;
	}
	
	 // Modded Firing:
	if(is_string(_rawWep) && mod_script_exists("weapon", _rawWep, "weapon_fire")){
		if(fork()){
			mod_script_call("weapon", _rawWep, "weapon_fire", _wep);
			exit;
		}
	}
	
	 // Normal Firing:
	else{
		var	_minID        = instance_max,
			_lastLoad     = reload,
			_lastRads     = GameCont.rad,
			_lastCanShoot = can_shoot;
			
		 // Fire:
		if(instance_is(self, Player)){
			var	_lastAmmo = array_clone(ammo),
				_lastDraw = drawempty;
				
			player_fire();
			
			 // Revert Values:
			array_copy(ammo, 0, _lastAmmo, 0, array_length(_lastAmmo));
			drawempty = _lastDraw;
		}
		else{
			player_fire_ext(gunangle, _wep, x, y, team, (("creator" in self) ? creator : self), accuracy);
		}
		
		 // Revert Values:
		reload       = _lastLoad;
		GameCont.rad = _lastRads;
		can_shoot    = _lastCanShoot;
		
		 // Delete Effects:
		if(instance_exists(LaserBrain) || instance_exists(SteroidsTB)){
			for(var _id = instance_max - 1; _id >= _minID; _id--){
				if("object_index" in _id){
					switch(_id.object_index){
						case LaserBrain:
							instance_delete(_id);
							break;
							
						case SteroidsTB:
							if(instance_is(_id + 1, PopupText)){
								instance_delete(_id + 1);
							}
							instance_delete(_id);
							break;
					}
				}
			}
		}
	}
	
#define player_fire_at // ?x, ?y, ?direction, directionOffset=0, directionLength=0, ?accuracy, ?wep, ?team, creator=self, isBasic=false
	/*
		Fires a given weapon from a given instance at a given position, direction, accuracy, and team
		Firing that occurs over time will reference these values over the firing instance's values
		Returns a LWO containing the firing values that can be updated at any time
		!!! Will not work properly with custom weapons that use 'wait'
		
		Args:
			x, y            - The firing position  (leave undefined to reference the firing instance's position)
			direction       - The firing direction (leave undefined to reference the firing instance's gunangle)
			directionOffset - The firing direction's angular offset (defaults to 0)
			directionLength - The firing direction's spatial offset (defaults to 0)
			accuracy        - The firing accuracy  (leave undefined to reference the firing instance's accuracy)
			wep             - The firing weapon    (leave undefined to reference the firing instance's weapon)
			team            - The firing team      (leave undefined to reference the firing instance's team)
			creator         - The firing instance  (defaults to 'self')
			isBasic         - Is a basic/raw shot? (defaults to 'false' - takes ammo, adds reload, creates effects, etc.)
			
		Vars:
			x, y             - The firing position
			direction        - The firing direction
			direction_offset - The firing direction's angular offset
			direction_length - The firing direction's spatial offset
			wep              - The firing weapon
			creator          - The firing instance
			creator_wep      - The firing instance's weapon (the value to override with the firing weapon)
			is_active        - Firing that occurs over time will reference these values over the firing instance's values?
			instance_list    - An array of instances that may actively reference the firing values
			
		Ex:
			var _fire = player_fire_at(x, y, undefined, 180);
			_fire.x += hspeed;
			_fire.y += vspeed;
	*/
	
	var	_at = {
			"x"                : ((argument_count > 0) ? argument[0] : undefined),
			"y"                : ((argument_count > 1) ? argument[1] : undefined),
			"direction"        : ((argument_count > 2) ? argument[2] : undefined),
			"direction_offset" : ((argument_count > 3) ? argument[3] : undefined),
			"direction_length" : ((argument_count > 4) ? argument[4] : undefined),
			"wep"              : ((argument_count > 6) ? argument[6] : undefined),
			"creator"          : ((argument_count > 8) ? argument[8] : undefined),
			"creator_wep"      : undefined,
			"is_active"        : true,
			"instance_list"    : []
		},
		_accuracy = ((argument_count > 5) ? argument[5] : undefined),
		_team     = ((argument_count > 7) ? argument[7] : undefined),
		_isBasic  = ((argument_count > 9) ? argument[9] : undefined);
		
	with(_at){
		 // Default Values:
		if(is_undefined(direction_offset)) direction_offset = 0;
		if(is_undefined(direction_length)) direction_length = 0;
		if(is_undefined(creator)){
			creator = other;
		}
		if("wep" in creator){
			creator_wep = creator.wep;
		}
		
		 // Player Firing:
		if(instance_is(creator, Player)){
			with(creator){
				 // Set Vars:
				switch(_accuracy){ case undefined: break; default: var _lastAccuracy = accuracy; accuracy = _accuracy; }
				switch(_team    ){ case undefined: break; default: var _lastTeam     = team;     team     = _team;     }
				
				 // Fire Weapon:
				player_fire_at_call(
					_at,
					script_ref_create(player_fire_at_call_player_fire, self, _isBasic, wep_none),
					true,
					"",
					undefined
				);
				
				 // Revert Vars:
				switch(_accuracy){ case undefined: break; default: accuracy = _lastAccuracy * (accuracy / _accuracy); }
				switch(_team    ){ case undefined: break; default: if(team == _team) team = _lastTeam;                }
			}
		}
		
		 // Non-Player Firing:
		else{
			var	_direction = direction,
				_wep       = wep,
				_x         = x,
				_y         = y,
				_creator   = creator;
				
			 // Default Values:
			if(is_undefined(_direction)) _direction = (("gunangle" in _creator) ? _creator.gunangle : 0);
			if(is_undefined(_wep      )) _wep       = (("wep"      in _creator) ? _creator.wep      : wep_none);
			if(is_undefined(_x        )) _x         = (("x"        in _creator) ? _creator.x        : 0);
			if(is_undefined(_y        )) _y         = (("x"        in _creator) ? _creator.y        : 0);
			if(is_undefined(_team     )) _team      = (("team"     in _creator) ? _creator.team     : 0);
			if(is_undefined(_accuracy )) _accuracy  = (("accuracy" in _creator) ? _creator.accuracy : 1);
			
			 // Directional Offsets:
			_direction += direction_offset;
			_x         += lengthdir_x(direction_length, _direction);
			_y         += lengthdir_y(direction_length, _direction);
			
			 // Fire Weapon:
			with(other){
				with(player_fire_ext(_direction, wep_none, _x, _y, _team, _creator, _accuracy)){
					player_fire_at_call(_at, script_ref_create(player_fire_at_call_player_fire, self, _isBasic, _wep), true, "", undefined);
				}
			}
		}
	}
	
	return _at;
	
#define player_fire_at_call(_at, _scriptCallRef, _canWrapEvents, _wrapEventVarName, _wrapEventRef)
	/*
		Modifies an instance while calling a script, then optionally wraps the events of any instances this created
		
		Args:
			at               - A LWO containing values for modifying an instance
			scriptCallRef    - The script reference to call after modifying an instance
			canWrapEvents    - Can wrap the events of instances created by the script call?
			wrapEventVarName - This event's variable name, or a blank string if not a wrapped event
			wrapEventRef     - This event's script reference, or 'undefined' if not a wrapped event
	*/
	
	var _atCreator = _at.creator;
	
	 // Set Event Reference:
	if(_wrapEventVarName in self){
		variable_instance_set(self, _wrapEventVarName, _scriptCallRef);
	}
	
	 // Set Vars, Call Script, & Capture Instances:
	if(_at.is_active && instance_exists(_atCreator)){
		var	_atX               = _at.x,
			_atY               = _at.y,
			_atDirection       = _at.direction,
			_atDirectionOffset = _at.direction_offset,
			_atDirectionLength = _at.direction_length,
			_atWep             = _at.wep,
			_atCreatorWep      = _at.creator_wep,
			_minID             = (_canWrapEvents ? instance_max : undefined);
			
		 // Set Creator Vars:
		with(_atCreator){
			var	_hasGunAngle   = ("gunangle" in self),
				_lastXPrevious = xprevious,
				_lastYPrevious = yprevious;
				
			 // Set Position:
			switch(_atX){ case undefined: break; default: var _lastX = x, _lastHSpeed = hspeed; x = _atX; }
			switch(_atY){ case undefined: break; default: var _lastY = y, _lastVSpeed = vspeed; y = _atY; }
			
			 // Set Aim Direction:
			if(_hasGunAngle){
				switch(_atDirection){
					case undefined: break;
					default:
						var _lastDirection = gunangle;
						gunangle = _atDirection;
				}
				gunangle += _atDirectionOffset;
			}
			
			 // Offset Position:
			switch(_atDirectionLength){
				case 0: break;
				default:
					var	_aimDirection = (_hasGunAngle ? gunangle : ((is_undefined(_atDirection) ? 0 : _atDirection) + _atDirectionOffset)),
						_atXOffset    = lengthdir_x(_atDirectionLength, _aimDirection),
						_atYOffset    = lengthdir_y(_atDirectionLength, _aimDirection);
						
					x += _atXOffset;
					y += _atYOffset;
			}
			
			 // Set Weapon:
			switch(_atWep){
				case undefined: break;
				default:
					var	_hasWep  = ("wep"  in self),
						_hasBWep = ("bwep" in self);
						
					if(_hasWep ){ var _lastWep  = wep;  if(wep  == _atCreatorWep) wep  = _atWep; }
					if(_hasBWep){ var _lastBWep = bwep; if(bwep == _atCreatorWep) bwep = _atWep; }
			}
		}
		
		 // Call Script Reference:
		_at.is_active = false;
		if(fork()){
			script_ref_call(_scriptCallRef);
			exit;
		}
		_at.is_active = true;
		
		 // Revert Creator Vars:
		with(_atCreator){
			 // Revert Position:
			if(xprevious == _lastXPrevious && yprevious == _lastYPrevious){
				switch(_atX){ case undefined: switch(_atDirectionLength){ case 0: break; default: x -= _atXOffset; } break; default: x = _lastX; hspeed = _lastHSpeed; }
				switch(_atY){ case undefined: switch(_atDirectionLength){ case 0: break; default: y -= _atYOffset; } break; default: y = _lastY; vspeed = _lastVSpeed; }
			}
			
			 // Revert Aim Direction:
			if(_hasGunAngle){
				switch(_atDirection){
					case undefined : gunangle -= _atDirectionOffset; break;
					default        : gunangle  = _lastDirection;
				}
			}
			
			 // Revert Weapon:
			switch(_atWep){
				case undefined: break;
				default:
					if(_hasBWep && _lastBWep == _atCreatorWep){ if(bwep != _atWep){ _at.wep = bwep; } bwep = _lastBWep; }
					if(_hasWep  && _lastWep  == _atCreatorWep){ if(wep  != _atWep){ _at.wep = wep;  } wep  = _lastWep;  }
			}
		}
		
		 // Wrap Events of New Instances:
		if(_canWrapEvents){
			for(var _inst = instance_max - 1; _inst >= _minID; _inst--){
				if("object_index" in _inst){
					var _instObject = _inst.object_index;
					
					 // Wrap Event Scripts:
					if(ds_map_exists(global.object_event_varname_list_map, _instObject)){
						with(global.object_event_varname_list_map[? _instObject]){
							var _instEventRef = variable_instance_get(_inst, self);
							if(is_array(_instEventRef) && array_length(_instEventRef) >= 3){
								var _instEventWrapRef = script_ref_create(
									player_fire_at_call,
									_at,
									_instEventRef,
									(instance_is(_instObject, CustomObject) || instance_is(_instObject, CustomScript)), // Causes slight inconsistencies, but significantly reduces lag
									self
								);
								array_push(_instEventWrapRef, _instEventWrapRef);
								variable_instance_set(_inst, self, _instEventWrapRef);
							}
						}
					}
					
					 // Intercept Burst Controller Events:
					switch(_instObject){
					
						case Burst:
						case GoldBurst:
						case HeavyBurst:
						case HyperBurst:
						case RogueBurst:
						case SawBurst:
						case SplinterBurst:
						case NadeBurst:
						case DragonBurst:
						case ToxicBurst:
						case FlameBurst:
						case WaveBurst:
						case SlugBurst:
						case PopBurst:
						case IonBurst:
						case LaserCannon:
						
							with(_inst){
								 // Store Vars:
								player_fire_at_vars = _at;
								
								 // Bind Scripts & Store Instance:
								if("player_fire_at_burst_list" not in GameCont){
									GameCont.player_fire_at_burst_list = [];
									GameCont.player_fire_at_burst_bind = undefined;
								}
								if(is_undefined(GameCont.player_fire_at_burst_bind)){
									GameCont.player_fire_at_burst_bind = [
										script_bind_begin_step(player_fire_at_burst_begin_step, 0),
										script_bind_step(player_fire_at_burst_step, 0)
									];
									with(GameCont.player_fire_at_burst_bind){
										persistent = true; // sure
									}
								}
								array_push(GameCont.player_fire_at_burst_list, self);
								
								 // Increase Firing Delay:
								if(alarm0 > 0){
									alarm0++;
								}
								if("delay" in self){
									delay = max(delay, current_time_scale) + (2 * current_time_scale);
								}
							}
							
							break;
							
					}
					
					 // Add to Instance List:
					array_push(_at.instance_list, _inst);
				}
			}
		}
	}
	
	 // Call Script Reference:
	else if(fork()){
		script_ref_call(_scriptCallRef);
		exit;
	}
	
	 // Revert Event Reference:
	if(_wrapEventVarName in self){
		var _scriptRef = variable_instance_get(self, _wrapEventVarName);
		if(_scriptRef != _scriptCallRef){
			if(array_length(_scriptRef) >= 3){
				_wrapEventRef[@ array_find_index(_wrapEventRef, _scriptCallRef)] = _scriptRef;
			}
			else _wrapEventRef = _scriptRef;
		}
		variable_instance_set(self, _wrapEventVarName, _wrapEventRef);
	}
	
#define player_fire_at_call_player_fire(_inst, _isBasic, _wep)
	/*
		Used to call weapon firing code from a Player or FireCont during 'player_fire_at_call'
	*/
	
	with(_inst){
		var _fireInst = self;
		
		 // Fire:
		if(_isBasic){
			with(self){
				_fireInst = player_fire_raw(instance_is(self, Player) ? wep : _wep);
			}
		}
		else if(instance_is(self, Player)){
			player_fire();
		}
		else{
			_fireInst = player_fire_ext(gunangle, _wep, x, y, team, (("creator" in self) ? creator : self), accuracy);
		}
		
		 // Transfer Variables:
		if(instance_is(_fireInst, FireCont)){
			with(("creator" in self)? creator : self){
				if(friction != 0){
					hspeed += _fireInst.hspeed;
					vspeed += _fireInst.vspeed;
				}
				if("wkick"    in self) wkick    = _fireInst.wkick;
				if("wepangle" in self) wepangle = _fireInst.wepangle * ((abs(_fireInst.wepangle) > 1) ? sign(wepangle) : wepangle);
				if("reload"   in self) reload  += _fireInst.reload;
			}
		}
	}
	
#define player_fire_at_call_event_perform(_inst, _eventType, _eventValue)
	/*
		Used to call 'event_perform' during 'player_fire_at_call'
	*/
	
	with(_inst){
		event_perform(_eventType, _eventValue);
	}
	
#define player_fire_at_burst_begin_step
	/*
		Begin step event for intercepting burst controller alarm events
	*/
	
	if("player_fire_at_burst_list" in GameCont && array_length(GameCont.player_fire_at_burst_list)){
		GameCont.player_fire_at_burst_list = instances_matching_ne(GameCont.player_fire_at_burst_list, "id");
		
		 // Intercept Burst Controller Alarm Events:
		if(current_frame_active){
			var _inst = instances_matching_le(instances_matching_gt(GameCont.player_fire_at_burst_list, "alarm0", 0), "alarm0", 2);
			if(array_length(_inst)){
				with(_inst){
					alarm0 = 0;
					player_fire_at_call(player_fire_at_vars, script_ref_create(player_fire_at_call_event_perform, self, ev_alarm, 0), true, "", undefined);
					if(instance_exists(self)){
						if(alarm0 > 0){
							alarm0 += 2;
						}
						if("delay" in self){
							delay = max(delay, current_time_scale) + current_time_scale;
						}
					}
				}
			}
		}
	}
	
	 // Done:
	else{
		with(instances_matching_ne(GameCont.player_fire_at_burst_bind, "id")){
			instance_destroy();
		}
		GameCont.player_fire_at_burst_bind = undefined;
	}
	
#define player_fire_at_burst_step
	/*
		Step event for intercepting burst controller step events
	*/
	
	if("player_fire_at_burst_list" in GameCont && array_length(GameCont.player_fire_at_burst_list)){
		GameCont.player_fire_at_burst_list = instances_matching_ne(GameCont.player_fire_at_burst_list, "id");
		
		 // Set Laser Cannon Variables:
		if(instance_exists(LaserCannon)){
			var _inst = instances_matching(GameCont.player_fire_at_burst_list, "object_index", LaserCannon);
			if(array_length(_inst)){
				with(_inst){
					var _fireInst = player_fire_at_vars.creator;
					if(instance_exists(_fireInst)){
						var	_len = player_fire_at_vars.direction_length + 16,
							_dir = player_fire_at_vars.direction,
							_x   = player_fire_at_vars.x,
							_y   = player_fire_at_vars.y;
							
						if(is_undefined(_dir)) _dir = _fireInst.gunangle;
						if(is_undefined(_x  )) _x   = _fireInst.x;
						if(is_undefined(_y  )) _y   = _fireInst.y;
						
						_dir += player_fire_at_vars.direction_offset;
						
						x = _x + lengthdir_x(_len, _dir);
						y = _y + lengthdir_y(_len, _dir);
					}
				}
			}
		}
		
		 // Intercept Burst Controller Step Events:
		var _inst = instances_matching_le(GameCont.player_fire_at_burst_list, "delay", 2 * current_time_scale);
		if(array_length(_inst)){
			with(_inst){
				delay = current_time_scale;
				player_fire_at_call(player_fire_at_vars, script_ref_create(player_fire_at_call_event_perform, self, ev_step, ev_step_normal), true, "", undefined);
				if(instance_exists(self)){
					delay = max(delay, current_time_scale) + (2 * current_time_scale);
				}
			}
		}
	}
	
	 // Done:
	else{
		with(instances_matching_ne(GameCont.player_fire_at_burst_bind, "id")){
			instance_destroy();
		}
		GameCont.player_fire_at_burst_bind = undefined;
	}

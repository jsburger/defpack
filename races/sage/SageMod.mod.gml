#define init
	global.bind_step = noone;
	
	global.lastProjectileId = 0;
	global.normalStep = noone;
	
#macro player_firing

	//thanks brokin
	//please note: brokin is like hes our bro and not that hes broke please be nice to yokin
	//ill keep that in mind for next time
    canfire
    && can_shoot == true
    && (ammo[weapon_get_type(wep)] >= weapon_get_cost(wep) || infammo != 0)
    && (GameCont.rad >= weapon_get_rads(wep) || infammo != 0)
    && (
        weapon_get_auto(wep)
        ? button_check(index, "fire")
        : (clicked == true || (button_pressed(index, "fire") && reload < 15))
    )
    && visible
    && !instance_exists(GenCont)
    && !instance_exists(LevCont)
    && !instance_exists(PlayerSit)
    && !array_length(instances_matching(CrystalShield, "creator", self))


#define draw_gui
    if(!instance_exists(PopoScene) && ((instance_exists(TopCont) && TopCont.gameovertime = 0) || instance_exists(SpiralCont)) && !instance_exists(CampChar)){
    	
        if(instance_exists(TopCont) || instance_exists(GenCont) || instance_exists(LevCont)){
            var _hudFade  = 0,
                _hudIndex = 0,
                _lastSeed = random_get_seed();

             // Game Win Fade Out:
            if(array_length(instances_matching(TopCont, "fadeout", true))){
                with(TopCont){
                    _hudFade = clamp(fade, 0, 1);
                }
            }
            if(_hudFade > 0){
                 // GMS1 Partial Fix:
                try if(!null){}
                catch(_error){
                    _hudFade = min(_hudFade, round(_hudFade));
                }

                 // Dim Drawing:
                if(_hudFade > 0){
                    draw_set_fog(true, c_black, 0, 16000 / _hudFade);
                }
            }

             // Draw Player HUD:
            for(var _isOnline = 0; _isOnline <= 1; _isOnline++){
                for(var _index = 0; _index < maxp; _index++){
                    if(
                        player_is_active(_index)
                        && (_hudIndex < 2 || !instance_exists(LevCont))
                        && (player_is_local_nonsync(_index) ^^ _isOnline)
                    ){
                        var _hudVisible = false;

                         // HUD Visibility:
                        for(var i = 0; true; i++){
                            var _local = player_find_local_nonsync(i);
                            if(!player_is_active(_local)){
                                break;
                            }
                            if(player_get_show_hud(_index, _local)){
                                _hudVisible = true;
                                break;
                            }
                        }

                         // Draw HUD:
                        if(_hudVisible || _isOnline == 0){
                            if(_hudVisible){

                                     // Rad Canister / Co-op Offsets:
                                    var _playerNum = 0;
                                    for(var i = 0; i < maxp; i++){
                                        _playerNum += player_is_active(i);
                                    }
                                    if(_playerNum <= 1){
                                        d3d_set_projection_ortho(
                                            view_xview_nonsync - 17,
                                            view_yview_nonsync,
                                            game_width,
                                            game_height,
                                            0
                                        );
                                    }
                                    else draw_set_projection(2, _index);

                                     // Draw:
                                    if(player_get_race(_index) == "sage"){
										mod_script_call("race", "sage", "player_hud", _index, _hudIndex, _hudIndex % 2, 0, 0);
									}

                                    draw_reset_projection();
                                }

                            _hudIndex++;
                        }
                    }
                }
            }
            if(_hudFade > 0){
                draw_set_fog(false, 0, 0, 0);
            }
            random_set_seed(_lastSeed);
        }
    }

#define draw_pause
	if(!instance_exists(ControlMenuButton) && !instance_exists(GameMenuButton) && !instance_exists(VisualsMenuButton) && !instance_exists(AudioMenuButton) && !instance_exists(OptionMenuButton) && !instance_exists(PopoScene) && !(instance_exists(PopoScene) && TopCont.gameovertime = 0) && !instance_exists(CampChar)){ 
    	
        if(true/*instance_exists(TopCont) || instance_exists(GenCont) || instance_exists(LevCont)// im too lazy to ident this properly*/){
            var _hudFade  = 0,
                _hudIndex = 0,
                _lastSeed = random_get_seed();

             // Game Win Fade Out:
            if(array_length(instances_matching(TopCont, "fadeout", true))){
                with(TopCont){
                    _hudFade = clamp(fade, 0, 1);
                }
            }
            if(_hudFade > 0){
                 // GMS1 Partial Fix:
                try if(!null){}
                catch(_error){
                    _hudFade = min(_hudFade, round(_hudFade));
                }

                 // Dim Drawing:
                if(_hudFade > 0){
                    draw_set_fog(true, c_black, 0, 16000 / _hudFade);
                }
            }

             // Draw Player HUD:
            for(var _isOnline = 0; _isOnline <= 1; _isOnline++){
                for(var _index = 0; _index < maxp; _index++){
                	if(!player_is_local_nonsync(_index)) {
                		
                		continue;
                	}
                    if(
                        player_is_active(_index)
                        && (_hudIndex < 2 || !instance_exists(LevCont))
                        && (player_is_local_nonsync(_index) ^^ _isOnline)
                    ){
                        var _hudVisible = false;

                         // HUD Visibility:
                        for(var i = 0; true; i++){
                            var _local = player_find_local_nonsync(i);
                            if(!player_is_active(_local)){
                                break;
                            }
                            if(player_get_show_hud(_index, _local)){
                                _hudVisible = true;
                                break;
                            }
                        }

                         // Draw HUD:
                        if(_hudVisible || _isOnline == 0){
                            if(_hudVisible){

                                     // Rad Canister / Co-op Offsets:
                                    var _playerNum = 0;
                                    for(var i = 0; i < maxp; i++){
                                        _playerNum += player_is_active(i);
                                    }
                                    if(_playerNum <= 1){
                                        d3d_set_projection_ortho(
                                            view_xview_nonsync - 17,
                                            view_yview_nonsync,
                                            game_width,
                                            game_height,
                                            0
                                        );
                                    }
                                    else draw_set_projection(2, _index);

                                     // Draw:
                                    if(player_get_race(_index) == "sage"){

                                        mod_script_call("race", "sage", "player_hud", _index, _hudIndex, _hudIndex % 2, view_xview_nonsync, view_yview_nonsync);
									}

                                    draw_reset_projection();
                                }

                            _hudIndex++;
                        }
                    }
                }
            }
            if(_hudFade > 0){
                draw_set_fog(false, 0, 0, 0);
            }
            random_set_seed(_lastSeed);
        }
    }
#define step
	var sages = instances_matching(Player, "race", "sage");
	 // Bind a step for getting new instances:
	if array_length(sages) > 0 {
		if(!instance_exists(global.normalStep)) {
			global.normalStep = script_bind_step(normal_step, 0);
		}
	}
	with sages {
		if player_firing {
			var event = mod_script_call_self("race", "sage", "before_sage_shoot");
			script_bind_step(call_sage_shit_idc, 0, self, event)
		}
	}
	

#define normal_step
	if !array_length(instances_matching(Player, "race", "sage")) {
		instance_destroy()
		exit
	}
	if (instance_exists(projectile) && projectile.id > global.lastProjectileId) {
		var newProjectiles = instances_matching_gt(projectile, "id", global.lastProjectileId);
		
		with instances_matching(Player, "race", "sage") {
			mod_script_call_self("race", race, "on_new_projectiles", newProjectiles)
		}
		//instances_matching sorts by descending id
		global.lastProjectileId = newProjectiles[0]
	} 

#define call_sage_shit_idc(sage, event)
	instance_destroy()
	var f = current_frame;
	with sage mod_script_call_self("race", "sage", "fire", event)
	if f != current_frame trace_color("Something in sage's firing pipeline is wait()ing without a fork()! Fix that!", c_red)


#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)
	/*
		Returns all given instances with their bounding box touching a given rectangle
		Much better performance than manually performing 'place_meeting()' on every instance
	*/

	return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _x1), "bbox_left", _x2), "bbox_bottom", _y1), "bbox_top", _y2);

#define motion_step(_mult)
	/*
		Performs the calling instance's basic movement code, scaled by a given number
	*/

	if(_mult > 0){
		if(friction_raw != 0 && speed_raw != 0){
			speed_raw -= min(abs(speed_raw), friction_raw * _mult) * sign(speed_raw);
		}
		if(gravity_raw != 0){
			hspeed_raw += lengthdir_x(gravity_raw, gravity_direction) * _mult;
			vspeed_raw += lengthdir_y(gravity_raw, gravity_direction) * _mult;
		}
		if(speed_raw != 0){
			x += hspeed_raw * _mult;
			y += vspeed_raw * _mult;
		}
	}
	else{
		if(speed_raw != 0){
			y += vspeed_raw * _mult;
			x += hspeed_raw * _mult;
		}
		if(gravity_raw != 0){
			vspeed_raw += lengthdir_y(gravity_raw, gravity_direction) * _mult;
			hspeed_raw += lengthdir_x(gravity_raw, gravity_direction) * _mult;
		}
		if(friction_raw != 0 && speed_raw != 0){
			speed_raw -= min(abs(speed_raw), friction_raw * _mult) * sign(speed_raw);
		}
	}

#define cleanup
	 // Destroy Script Bindings:
	with(global.bind_step){
		instance_destroy();
	}

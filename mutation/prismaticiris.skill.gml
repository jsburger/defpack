#define init
	global.color  = mod_current;
	global.button = sprite_add("../sprites/mutation/sprMutPrismaticIris0.png", 1, 12, 16);
	global.icon   = sprite_add("../sprites/mutation/sprMutPrismaticIcon0.png", 1, 8, 7);
	global.effect = sprite_add("../sprites/mutation/sprIrisEffect.png", 8, 16, 11);
	global.arrow  = sprite_add("../sprites/mutation/sprIrisArrow.png", 1, 3, 10);
	global.sprRandomGun = sprite_add("../sprites/mutation/sprLensRandomGun.png", 5, 2, 3);
	global.gammaFix = false

 // im picky and also lazy
#macro color_current global.color

#define skill_wepspec
return 1;

#define skill_type
return 1;

#define game_start
	global.color = mod_current;

#define skill_name
	return "PRISMATIC IRIS";

#define skill_text
	if(color_current != mod_current and mod_exists("skill", color_current)) {
		return mod_script_call("skill", color_current, "skill_text");
	}
	else return "@wREIMAGINE@s YOUR @yBULLETS";

#define skill_button
	sprite_index = global.button;

#define skill_icon
	if(color_current != mod_current and mod_exists("skill", color_current)) {
		return mod_script_call("skill", color_current, "skill_icon");
	}
	else return global.icon;

#define skill_tip
	var colortip = mod_script_call("skill", color_current, "skill_tip");
	if(color_current != "prismaticiris" and colortip != undefined) {
		return colortip;
	}
	else return "BELIEVE";

#define skill_take(_num)
	if(_num > 0 && instance_exists(LevCont)){
		 // Sound:
		sound_play_iris();

		 // Increase important GameCont variables to account for a new selection of mutations
		GameCont.skillpoints++;
		GameCont.endpoints++;

		if(fork()){
		    wait(0); // Very miniscule pause so the game can catch up
		    GameCont.endpoints--; // Fix what we did before
		    with(SkillIcon) instance_destroy(); // Obliterate all leftover skill icons

		    if(crown_current = 8) { // Crown of Destiny stuff
		    	LevCont.maxselect++;

		    	skill_create("fantasticrefractions", 0.5);
		    	if(array_length(instances_matching(Player, "race", "horror")) > 0) || GameCont.horror >= 1 {
		    		skill_create("warpedperspective", 1.5);
		    	}
		    }

		    else {
	            var s = mod_get_names("skill"); // Store all skills

	             // Find all skills that have something to do with this
	            for(var f = 0; f < array_length(s); f++) {
	            	 // Checks for if a modded skill happens to have a script for being an iris mutation,
	            	if(mod_exists("skill", s[f]) and
	            	   mod_script_exists("skill", s[f], "skill_iris") and
	            	   mod_script_call("skill", s[f], "skill_iris") != false) {
	            		LevCont.maxselect++;
	            		skill_create(s[f], instance_number(mutbutton) + 2);
	            	}
	            }

	             // For uneven amount of muts
	            var n = instance_number(mutbutton)/2;
	            if(n != round(n)) with(SkillIcon) num += 0.5;
		    }

		    exit;
		}

		  // reset existing iris weapons
		 with(instances_matching_ne(WepPickup, "prismatic", null)){
		 	prismatic = null;
		 }
	}

	else global.color = "fantasticrefractions"; // for those who would cheat prismatic iris in

#define step
	if(color_current = mod_current and !instance_exists(LevCont)) global.color = "fantasticrefractions"; // Make sure that if you reload the mod you still have some form of color
	else if(instance_exists(Player) and !instance_exists(LevCont)) {
		with(instances_matching(WepPickup, "prismatic", null)) {
			if(distance_to_object(Player) < 128) {
				if(roll and mod_exists("skill", color_current) and mod_script_exists("skill", color_current, "skill_iris")) {
					prismatic = mod_script_call("skill", color_current, "skill_iris");
				}
				else prismatic = false;

				 // Make sure it's able to be changed
				if(prismatic != false and weapon_get_type(wep) == 1) {
					if(prismatic = "") {
						var w = [];
						with(instance_nearest(x, y, Player)) if(race != "steroids") {
							array_push(w, wep)
							array_push(w, bwep)
						}

						scrGimmeWep(x, y, 6 * ultra_get("robot", 1), GameCont.hard + array_length(instances_matching(Player, "race", "robot")) + (2 * curse), curse, w);

						 // Visuals
						with instance_create(x, y, ImpactWrists){
		                    sprite_index = global.effect;
		                    sound_play_pitchvol(sndStatueXP, 0.5 * random_range(0.8, 1.2), 0.4);
		                    image_angle = 0;
		                }

		                instance_destroy();
					}

					else {
						var prismwep = convert(wep, prismatic);
						if(prismwep != false) {
							wep = prismwep; //FIX
							chargecheck = 0;
							sprite_index = weapon_get_sprt(wep);
							name = weapon_get_name(wep);

							 // Visuals
							with instance_create(x, y, ImpactWrists){
		                		sprite_index = global.effect;
		                    	sound_play_pitchvol(sndStatueXP, 0.5 * random_range(0.8, 1.2), 0.4);
		                    	image_angle = 0;
		                	}
						}
					}
				}
			}
		}
	}

	 // Fantastic Refractions needs a bit of extra code for its text + tips to work. bad ass
	with(instances_matching(SkillIcon, "name", "FANTASTIC REFRACTIONS")) {
		text = "@yBULLET@s WEAPONS BECOME " + `@(color:${make_colour_hsv(current_frame mod 255, 220, 255)})ANYTHING@s`;
	}

	with(GenCont) {
		if(tip = "fantasticrefractions") {
			refract_tip = "true";
		}
		if("refract_tip" in self) tip = `IT'S SO @(color:${make_colour_hsv(current_frame mod 255, 220, 255)})BEAUTIFUL`;
	}

 // MISCELLANEOUS SCRIPTS //
#define get_colors()
	var _colors = [];

	with(mod_get_names("skill")){
		if (mod_script_exists("skill", self, "skill_iris")){
			var _color = mod_script_call("skill", self, "skill_iris");

			if (_color != false){
				array_push(_colors, _color);
			}
		}
	}

	return _colors;

#define convert(w, c)
	var _baseWep = weapon_get(w);
	 // Converts the given (w)eapon to the given (c)olor
	w = (is_object(w) ? lq_defget(w, "wep", wep_none) : w);
	var _wep = w;
	 // Modded weapons
	if(is_string(w)) {
		if(mod_exists("weapon", w)) {
			if(mod_script_exists("weapon", w, "weapon_iris")) {
				_wep = mod_script_call("weapon", w, "weapon_iris");
			}
			else {
				 // if it's a modded weapon with an iris prefix but no weapon_iris, scan for the non-iris version
				var wep_lower = string_lower(w);

				global.gammaFix = true;
				var colors = get_colors();
				global.gammaFix = false;

				with(colors) if self != "" {
					var color_lower = string_lower(self);
					var _pos = string_pos(color_lower + " ", wep_lower);

					if (_pos >= 1) {
						var _search = string_lower(string_delete(w, _pos, string_length(self + " ")));

						var _found = false;

						 // combat inconsistent capitalization
						with(mod_get_names("weapon")){
							if (string_lower(self) == _search){
								if (mod_script_exists("weapon", self, "weapon_iris")){
									_wep = mod_script_call("weapon", self, "weapon_iris");
									_found = true;
									break;
								}
							}
						}

						 // if weapon is an iris variant of a vanilla weapon
						if (!_found) {
							switch(_search) {
								case "revolver": _wep = "x revolver"; break;
								case "golden revolver": _wep = "golden x revolver"; break;
								case "rusty revolver": _wep = "rusty x revolver"; break;
								case "golden machinegun": _wep = "golden x machinegun"; break;
								case "golden assault rifle": _wep = "golden assault x rifle"; break;
								case "rogue rifle": _wep = "x rogue rifle"; break;
								case "machinegun": _wep = "x machinegun"; break;
								case "assault rifle": _wep = "assault x rifle"; break;
								case "double minigun": _wep = "double x minigun"; break;
								case "minigun": _wep = "x minigun"; break;
								case "smg": _wep = "x smg"; break;
								case "triple machinegun": _wep = "triple x machinegun"; break;
								case "quad machinegun": _wep = "quad x machinegun"; break;
								case "smart gun": _wep = "smart x gun"; break;
								case "shotgun": _wep = "x shotgun"; break;
								case "hyper rifle": _wep = "hyper x rifle"; break;
								case "heavy assault rifle": _wep = "heavy assault x rifle"; break;
								case "heavy machinegun": _wep = "heavy x machinegun"; break;
								case "heavy revolver": _wep = "heavy x revolver"; break;
							}
						}

						break;
					}
				}
			}
		}

		else {
			_wep = wep_none;
		}
	}

	 // Base game weapons
	else switch(w) {
		case wep_revolver: _wep = "x revolver"; break;
	    case wep_golden_revolver: _wep = "golden x revolver"; break;
	    case wep_rusty_revolver: _wep = "rusty x revolver"; break;
	    case wep_golden_machinegun: _wep = "golden x machinegun"; break;
	    case wep_golden_assault_rifle: _wep = "golden assault x rifle"; break;
	    case wep_rogue_rifle: _wep = "x rogue rifle"; break;
	    case wep_machinegun: _wep = "x machinegun"; break;
	    case wep_assault_rifle: _wep = "assault x rifle"; break;
	    case wep_double_minigun: _wep = "double x minigun"; break;
	    case wep_minigun: _wep = "x minigun"; break;
	    case wep_smg: _wep =  "x smg"; break;
	    case wep_bouncer_smg: _wep = "x smg"; break;
	    case wep_triple_machinegun: _wep = "triple x machinegun"; break;
	    case wep_quadruple_machinegun: _wep = "quad x machinegun"; break;
	    case wep_smart_gun: _wep = "smart x gun"; break;
	    case wep_bouncer_shotgun: _wep = "x shotgun"; break;
	    case wep_hyper_rifle: _wep = "hyper x rifle"; break;
	    case wep_heavy_assault_rifle: _wep = "heavy assault x rifle"; break;
	    case wep_heavy_machinegun: _wep = "heavy x machinegun"; break;
	    case wep_heavy_revolver: _wep = "heavy x revolver"; break;
	}

	if(is_string(_wep)) _wep = string_replace(_wep, "x ", c + " ");
	if(_wep = "bouncer smg") return wep_bouncer_smg;
	else if(_wep = "bouncer shotgun") return wep_bouncer_shotgun;
	else if(_wep != wep_none and (!is_string(_wep) or mod_exists("weapon", _wep)) && _wep != _baseWep) return _wep;
	else return false;

#define weapon_get(_w)
	if is_object(_w) {
		return _w.wep;
	}
	return _w;

//thanks YOKIN you are truly my greatest ally
// Spawns a Random WepPickup & Takes Into Account More Spawn Conditions: `with(Player) scrGimmeWep(x, y, 0, GameCont.hard, curse, [wep, bwep]);`
#define scrGimmeWep(_x, _y, _minhard, _maxhard, _curse, _nowep)
    var _list = ds_list_create(),
		s = weapon_get_list(_list, _minhard, _maxhard);

	ds_list_shuffle(_list);

	with(instance_create(_x, _y, WepPickup)){
		curse = _curse;
		ammo = 1;

        for(var i = 0; i < s; i++) {
            var	w = ds_list_find_value(_list, i),
            	c = 0;

			 // Weapon Exceptions:
			if(is_array(_nowep) && array_find_index(_nowep, w) >= 0) c = 1;
			if(w == _nowep) c = 1;

            //Prismatic Iris Denounces Bullet Weapons
            if weapon_get_type(w) = 1 c = 1

			 // Specific Weapon Spawn Conditions:
			if(!is_string(w)) switch(w){
				case wep_super_disc_gun:        if(curse <= 0)			c = 1; break;
                case wep_golden_nuke_launcher:  if(!UberCont.hardmode)	c = 1; break;
                case wep_golden_disc_gun:       if(!UberCont.hardmode)	c = 1; break;
                case wep_gun_gun:               if(GameCont.crown != 5)	c = 1; break;
            }

            if(c) continue;
            break;
        }

		 // Set Weapon:
        if(!c) wep = w;
        else wep = wep_screwdriver; // Default

		ds_list_destroy(_list);

        return id;
	}

#define player_convert(c)
	with(Player) {
		if(c = "") {
			var w = [];
			with(instance_nearest(x, y, Player)) if(race != "steroids") {
				array_push(w, wep)
				array_push(w, bwep)
			}

			if(weapon_get_type(wep) = 1) {
				with(scrGimmeWep(x, y, 6 * ultra_get("robot", 1), GameCont.hard + array_length(instances_matching(Player, "race", "robot")) + (2 * curse), curse, w)) {
					other.wep = wep;
					instance_delete(self);
				}
			}

			if(weapon_get_type(bwep) = 1) {
				with(scrGimmeWep(x, y, 6 * ultra_get("robot", 1), GameCont.hard + array_length(instances_matching(Player, "race", "robot")) + (2 * curse), curse, w)) {
					other.bwep = wep;
					instance_delete(self);
				}
			}
		}
		else {
			if(convert(wep, c) != false) wep = convert(wep, c);
			if(convert(bwep, c) != false) bwep = convert(bwep, c);
			if(convert(wep, c) != false) || (convert(bwep, c) != false) with Player with instance_create(x, y, ImpactWrists){
		        sprite_index = global.effect;
		        sound_play_pitchvol(sndStatueXP, 0.5 * random_range(0.8, 1.2), 0.4);
		        image_angle = 0;
		        depth = other.depth-1;
		    }
		}
	}

#define skill_create(_skill, _num)
	with(instance_create(0, 0, SkillIcon)) {
		creator = LevCont;
		num     = _num;
		alarm0  = num + 3;
		skill   = _skill;

		 // Apply relevant scripts
        mod_script_call("skill", _skill, "skill_button");
        name = mod_script_call("skill", _skill, "skill_name");
        text = mod_script_call("skill", _skill, "skill_text");

        var c = mod_script_call("skill", skill, "skill_iris");
        if(instance_exists(Player) and mod_exists("skill", skill) and c != false){
	    	if(c != "") { //not filtered lens
	    		 //smartest code youll ever see
		    	var prismwep = convert(Player.wep, c);
		    	if(prismwep != false and prismwep != Player.wep){
		    		text += `#@0(${weapon_get_sprite(Player.wep)}:0)   @0(${global.arrow}:0)   @0(${weapon_get_sprite(prismwep)}:0)`
		    	}

		    	prismwep = convert(Player.bwep, c);
		    	if(prismwep != false and prismwep != Player.bwep){
		    		text += `#@0(${weapon_get_sprite(Player.bwep)}:0)   @0(${global.arrow}:0)   @0(${weapon_get_sprite(prismwep)}:0)`
		    	}
	    	}
	    	else {
	    		if(weapon_get_type(Player.wep) == 1){
	    			text += `#@0(${weapon_get_sprite(Player.wep)}:0)   @0(${global.arrow}:0)   @0(${global.sprRandomGun}:-1)`
	    		}
	    		if(weapon_get_type(Player.bwep) == 1){
	    			text += `#@0(${weapon_get_sprite(Player.bwep)}:0)   @0(${global.arrow}:0)   @0(${global.sprRandomGun}:-1)`
	    		}
	    	}
	    }
	}

#define sound_play_iris
	with(instance_create(0, 0, CustomObject)) {
		sound_play_pitch(sndStatueDead, 2);
		sound_play_pitchvol(sndStatueCharge, 0.8, 0.4);
		sound_play_pitch(sndHeavyRevoler, 0.6);
		on_step = sound_step;
		maxsound = 1;
		timer  = 30;
		timer2 = 53;
		amount = 0;
		on_step = sound_step;
		return self;
	}

#define sound_step
	timer -= current_time_scale;
	if(timer <= 0 && amount <= 3) {
		amount++;
		timer = 8 - amount;
		sound_play_pitchvol(sndHeavyRevoler, 0.8 + (amount/10), 0.5 - (amount/20));
	}
	if(amount = 2){
		sound_play_pitchvol(sndMutant2Cptn, 1.1, 0.5);
	}
	if(amount >= 2) {
		if(timer2 > 0) {
			timer2 -= current_time_scale;
		}
		else {
			sound_stop(sndMutant2Cptn);
			instance_destroy();
		}
	}

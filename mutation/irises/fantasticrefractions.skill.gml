#define init
	global.button = sprite_add("../../sprites/mutation/sprMutPrismaticIris7.png", 1, 12, 16);
	global.icon   = sprite_add("../../sprites/mutation/sprMutPrismaticIcon7.png", 1, 8, 7);
	global.brush  = sprite_add_weapon("../../sprites/weapons/sprToothbrushInvert.png", 0, 0);
	
#define skill_name
	return "FANTASTIC REFRACTIONS";

#define skill_text
return "@yBULLETS @sBECOME " + `@(color:${make_colour_hsv(current_frame mod 255, 220, 255)})ANYTHING@s`;

#define skill_tip
	return mod_current;

#define skill_type
	return 1;

#define skill_iris

		var s = mod_get_names("skill");
		var i = [];

		for(var f = 0; f < array_length(s); f++) {
	    	 // Checks for if a modded skill happens to have a script for being an iris mutation,
	    	if(s[f] != mod_current and
	    	   mod_exists("skill", s[f]) and
	    	   mod_script_exists("skill", s[f], "skill_iris") and
	    	   mod_script_call("skill", s[f], "skill_iris") != false and
	    	   mod_script_call("skill", s[f], "skill_iris") != "") {
	    	   	array_push(i, mod_script_call("skill", s[f], "skill_iris")); // Add iris prefix to array
	    	}
		}

		if(array_length(s) > 0) return i[irandom(array_length(i) - 1)]; // Return random prefix
		else return ""; // Return nothing if there were no iris skills found, SUPER weird case but still worth checking for

#define skill_toothbrush_sprite
	return global.brush;

#define skill_button
	sprite_index = global.button;

#define skill_icon
	return global.icon;

#define skill_wepspec
	return 1; // Make sure it increments Heavy Heart

#define skill_avail
	return 0; // Make sure it doesn't appear in normal pools

#define skill_take(_num)
	 // Sounds
	if(_num > 0 and instance_exists(LevCont)) {
		sound_play_pitchvol(sndBasicUltra, 2, 0.5);
		sound_play_pitchvol(sndShielderDeflect, 0.6, 0.5);
		sound_play_pitchvol(sndBouncerBounce, 0.7, 1);
		sound_play_pitchvol(sndHitWall, 0.6, 1);
	}

	if(mod_exists("skill", "prismaticiris")) {
		if(skill_get("prismaticiris") = 0) skill_set("prismaticiris", _num); // apply iris if it exists but isnt applied, just for weird cases with skill_set
		mod_variable_set("skill", "prismaticiris", "color", mod_current);
	}

	skill_set(mod_current, 0); // Remove the skill

	player_convert(skill_iris());

#define player_convert(c) return mod_script_call_nc("skill", "prismaticiris", "player_convert", c);

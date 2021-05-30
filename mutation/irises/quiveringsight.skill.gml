#define init
	global.button = sprite_add("../../sprites/mutation/sprMutPrismaticIris6.png", 1, 12, 16);
	global.icon   = sprite_add("../../sprites/mutation/sprMutPrismaticIcon6.png", 1, 8, 7);

#define skill_name
	return "QUIVERING SIGHT";

#define skill_text
	return "@yBULLET@s WEAPONS BECOME @yBOUNCY";

#define skill_tip
	return "@sTHE @ySTARS @sHAVE ALIGNED";

#define skill_iris
	return "bouncer"; // Return prefix of weapon variants

#define skill_button
	sprite_index = global.button;

#define skill_type
	return 1;

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

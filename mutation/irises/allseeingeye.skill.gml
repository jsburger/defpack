#define init
	global.button = sprite_add("../../sprites/mutation/sprMutPrismaticIris3.png", 1, 12, 16);
	global.icon   = sprite_add("../../sprites/mutation/sprMutPrismaticIcon3.png", 1, 8, 7);
	global.brush  = sprite_add_weapon("../../sprites/weapons/sprToothbrushPurple.png", 0, 0);
	global.prism  = sprite_add_weapon("../../iris weps/prismaticannon/sprites/sprIrisWeaponPsy.png",6,12);

#define skill_name
	return "ALL-SEEING EYE";

#define skill_text
	return "@yBULLETS @sBECOME @pHOMING";

#define skill_tip
	return ["@pPSY BULLETS @sARE @wSTRONG @sBUT @wSLOW", "THEY KNOW"];

#define skill_iris
	return "psy"; // Return prefix of weapon variants

#define skill_toothbrush_sprite
	return global.brush;

#define skill_prismaticannon_sprite
	return global.prism;

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
		sound_play_pitch(sndCursedReminder, 0.4);
		sound_play_pitch(sndSwapCursed, 0.8);
		sound_play_pitchvol(sndCursedPickup, 0.6, 0.5);
		sound_play_pitchvol(sndBigCursedChest, 0.7, 0.2);
	}

	if(mod_exists("skill", "prismaticiris")) {
		if(skill_get("prismaticiris") = 0) skill_set("prismaticiris", _num); // apply iris if it exists but isnt applied, just for weird cases with skill_set
		mod_variable_set("skill", "prismaticiris", "color", mod_current);
	}

	skill_set(mod_current, 0); // Remove the skill

	player_convert(skill_iris());

#define player_convert(c) return mod_script_call_nc("skill", "prismaticiris", "player_convert", c);

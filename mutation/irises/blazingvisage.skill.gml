#define init
	global.button = sprite_add("../../sprites/mutation/sprMutPrismaticIris2.png", 1, 12, 16);
	global.icon   = sprite_add("../../sprites/mutation/sprMutPrismaticIcon2.png", 1, 8, 7);
	global.brush  = sprite_add_weapon("../../sprites/weapons/sprToothbrushRed.png", 0, 0);
	global.prism  = sprite_add_weapon("../../iris weps/prismaticannon/sprites/sprIrisWeaponFire.png",6,12);
	global.sprFireFlash = sprite_add("../../iris weps/prismaticannon/sprites/sprFlameMuzzleflash.png", 1, 8, 8);
	mod_script_call("skill", "fantasticrefractions", "add_color", mod_current);

#define skill_name
	return "BLAZING VISAGE";

#define skill_text
	return "@yBULLETS @sBECOME @rFLAMING";

#define skill_tip
	return ["@rBURN @sTHE WORLD DOWN", "@rFIRE BULLETS @sARE @wSTRONGER @sUP CLOSE", "@rFIRE BULLETS @sARE VERY @wINACCURATE"] ;

#define skill_iris
	return "fire"; // Return prefix of weapon variants

#define skill_toothbrush_sprite
	return global.brush;

#define skill_prismaticannon_sprite
	return global.prism;
	
#define skill_prismaticannon_fire
	sound_play_pitchvol(sndPlasma,random_range(0.75,0.85),1);
    sound_play_pitchvol(sndBurn,random_range(0.95,1),1);

    with mod_script_call("mod","PrismaticannonProjectiles","FlameBullet_Create",(x+lengthdir_x(13,gunangle)),y+lengthdir_y(13,gunangle)){
    	creator = other
    	team = other.team
    	image_angle = direction
    }
    
    mod_script_call("wep", "Prismaticannon","muzzle_create", global.sprFireFlash);

#define skill_prismaticannon_text
	return "@rSMELTER";

#define skill_type
    return 1;

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
		sound_play_pitchvol(sndIncinerator, 0.7, 1);
		sound_play_pitchvol(sndBurn, 2, 0.4);
		sound_play_pitchvol(sndRocketFly, 2, 0.4);
		sound_play_pitchvol(sndSwapFlame, 0.5, 0.4);
	}

	if(mod_exists("skill", "prismaticiris")) {
		if(skill_get("prismaticiris") = 0) skill_set("prismaticiris", _num); // apply iris if it exists but isnt applied, just for weird cases with skill_set
		mod_variable_set("skill", "prismaticiris", "color", mod_current);
	}

	skill_set(mod_current, 0); // Remove the skill

	player_convert(skill_iris());

#define player_convert(c) return mod_script_call_nc("skill", "prismaticiris", "player_convert", c);

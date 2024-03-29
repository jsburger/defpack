#define init
	global.button = sprite_add("../../sprites/mutation/sprMutPrismaticIris6.png", 1, 12, 16);
	global.icon   = sprite_add("../../sprites/mutation/sprMutPrismaticIcon6.png", 1, 8, 7);
	global.brush  = sprite_add_weapon("../../sprites/weapons/sprToothbrushYellow.png", 0, 0);
	global.prism  = sprite_add_weapon("../../iris weps/prismaticannon/sprites/sprIrisWeaponBouncer.png",6,12);
	global.sprBouncyFlash = sprite_add("../../iris weps/prismaticannon/sprites/sprBouncyMuzzleflash.png", 1, 8, 8);
	mod_script_call("skill", "fantasticrefractions", "add_color", mod_current);

#define skill_name
	return "QUIVERING SIGHT";

#define skill_text
	return "@yBULLETS @sBECOME @yBOUNCY";

#define skill_tip
	return "@yBOUNCE @sFOREVER";

#define skill_iris
	return "bouncer"; // Return prefix of weapon variants
	
#define skill_toothbrush_sprite
	return global.brush;

#define skill_prismaticannon_sprite
	return global.prism;
	
#define skill_prismaticannon_text
	return "@yREFRACTIONS";
	
#define skill_prismaticannon_fire
	sound_play_pitchvol(sndPlasma,random_range(0.75,0.85),1);
    sound_play_pitchvol(sndBouncerShotgun,random_range(0.7,0.8),0.8)

    with mod_script_call("mod","PrismaticannonProjectiles","BouncyBullet_Create",(x+lengthdir_x(13,gunangle)),y+lengthdir_y(13,gunangle)){
    	creator = other
    	team = other.team
    	image_angle = direction
    }
    mod_script_call("wep", "Prismaticannon","muzzle_create", global.sprBouncyFlash);
	
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

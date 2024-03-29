/*TODO:
* Bounce code for:
  * Mega Laser Cannon
  * Quartz Laser
  * All Vector guns
  * Sniper Rifle & Shotgun
* Split code for:
  * all charge weps actually
  * Mega Laser does split but dont change Angle
* Kaboomerang and LWheel dont work well in general
* Non sage players should not be able to pick up spell bullets
* "LOW HP" text overlaps with bullet hud
* sage b skin
* Throne Butt is cringe rn (its awkward to use), please change
*/

/*
	Possible extra effect list:
	Default: + Spellpower
	Gold: + Spellpower when using golden weapons
	Melee:
	Turret:
	Infammo:
	Precision:
	Bounce: + Hitbounce
	Hyper:
	Burst:
	Ultra: + Auto weapons when using rads
	Cursed: + Upside & Downside

*/

/*
NOTES FROM JSBURG:
- Passive: Undecided and unimportant to sage's core gameplay, could have been more weapon chests.
- Active: Swap active spell

- Spells:
	- Whenever sage opens an ammo chest(? The idea is that he just gets them over time) a spell bullet pops out as well. Spell bullets can be picked up and fill one of two slots
	- spells act as additional passives for sage, which are tuned to actively change gameplay instead of being slight like other passives
	- only the spell in the first slot is active, the idea is to let people carry sidegrade abilities freely
	- spells aim to modify gunplay, to make exploring options even more interesting.

- Spell ideas:
	- Twin shot: shoot in a v in front of you with your current gunangle
	- Haste: move and reload faster
	- Warp: megahyper but only for your projectiles
	- unnamed accuracy mods: give you perfect/worse accuracy
	- ideally there are more of these by the time he's complete
	- (GEpsi note: bouncing projectiles would be a good fit)

- Other:
	- Thronebutt makes spells more impactful in non intuitive ways, ie twinshot becomes quadshot, quadruple machinegun style (GEpsi note: I honestly don't know how that example's not intuitive...)
	- Ultra A makes spells strictly better, ex: haste is faster (GEpsi note: I think making this a pure doubling would be most balanced)
	- Ultra B makes both spells be active at the same time (GEpsi note: order mattering would be really cool, since the active would still matter then)
	- (GEpsi note: if I do ultra C/D/etc more spell slots is a must)
*/
// On Mod Load:
#define init
	global.newLevel = instance_exists(GenCont);

	/// Define Sprites : sprite_add("path/to/sprite/starting/from/mod/location.png", frames, x-offset, y-offset) \\\
	 // A-Skin:
	 var _i = "../../sprites/sage/"
	global.spr_idle[0] = sprite_add(_i + "sprGunIdle.png",	6, 12, 12);
	global.spr_walk[0] = sprite_add(_i + "sprGunWalk.png",	6, 12, 12);
	global.spr_hurt[0] = sprite_add(_i + "sprGunHurt.png",	3, 12, 12);
	global.spr_dead[0] = sprite_add(_i + "sprGunDie.png",  	6, 12, 12);
	global.spr_sit1[0] = sprite_add(_i + "sprGunGoSit.png",	3, 12, 12);
	global.spr_sit2[0] = sprite_add(_i + "sprGunSit.png",	1, 12, 12);

	 // B-Skin:
	global.spr_idle[1] = sprite_add(_i + "sprGunIdle.png",	6, 12, 12);
	global.spr_walk[1] = sprite_add(_i + "sprGunWalk.png",	6, 12, 12);
	global.spr_hurt[1] = sprite_add(_i + "sprGunHurt.png",	3, 12, 12);
	global.spr_dead[1] = sprite_add(_i + "sprGunDie.png",	6, 12, 12);
	global.spr_sit1[1] = sprite_add(_i + "sprGunGoSit.png",	3, 12, 12);
	global.spr_sit2[1] = sprite_add(_i + "sprGunSit.png",	1, 12, 12);

	 // Character Selection / Loading Screen:
	global.spr_slct = sprite_add(_i + "sprGunSlct.png", 1, 0,  0);
	global.spr_port = sprite_add(_i + "sprGunPortrait.png",	1,	40, 243);
	global.spr_skin = sprite_add(_i + "sprGunSkin.png",		race_skins(),	13, 13);
	global.spr_icon = sprite_add(_i + "sprGunMapIcon.png",	race_skins(),	10, 8);

	 // Ultras:
	global.spr_ult_slct = sprite_add(_i + "sprGunUltras.png", ultra_count(mod_current), 12, 16);
	global.spr_ult_icon[1] = sprite_add(_i + "sprGunUltraAIcon.png", 1, 8, 9);
	global.spr_ult_icon[2] = sprite_add(_i + "sprGunMapIcon.png", 1, 8, 9);

	 // FX:
	global.sprSwapFairy = sprite_add(_i + "fx/sprWepSwapL.png", 6, 16, 16);
	
	 // Fairy:
	global.sprFairyIcon	= sprite_add(_i + "/bullet icons/sprFairyIconEmpty.png", 0, 5, 5);
	 
	 // Bullet Shines:
	global.sprShineA	= sprite_add_weapon(_i + "/bullets/sprBulletAShine.png", 7, 11);
	global.sprShineAUpg = sprite_add_weapon(_i + "/bullets/sprBulletAShineUpg.png", 7, 11);
	
	var soundPath = "sounds/"
	
	global.sndSelect  = sound_add(soundPath+"sndSelect.ogg");
	global.sndConfirm = sound_add(soundPath+"sndConfirm.ogg");
	global.sndChest   = sound_add(soundPath+"sndChest.ogg");
	global.sndWrld    = sound_add(soundPath+"sndFlashyn.ogg");
	global.sndHurt    = sound_add(soundPath+"sndHurt.ogg");
	global.sndLowA    = sound_add(soundPath+"sndLowAmmo.ogg");
	global.sndLowH    = sound_add(soundPath+"sndLowHp.ogg");
	global.sndVault   = sound_add(soundPath+"sndVault.ogg");
	global.sndDie     = sound_add(soundPath+"sndDie.ogg");
	
	 // Reapply sprites if the mod is reloaded. //
	with(instances_matching(Player, "race", mod_current)) {
		assign_sprites();
		assign_sounds();
	}

	global.spellHold = sprite_add(_i + "sprSpellBulletEmpty.png", 1, 6, 7);

	global.carryOver = [];

	global.bind_late_step = noone;
	global.prompts = instances_matching(CustomObject, "name", "SagePrompt");
	global.bulletObjects = instances_matching(CustomObject, "name", "spellbullet")

	global.colormap = {
		neutral: 		  $BAB0A9,
		negative:         $474ed1,
		speed:   		  $CE7314,
		friction:   	  merge_color($CE7314, c_aqua, .3),
		projectile_speed: $E5BC16,
		accuracy:         $0067F7,
		spellpower:		  $A83487,
		projectile:       $00ABFA,
		ammo:             $00ABFA,
		bounce:           $00ABFA,
		reload:           $FFFFFF,
		echo:			  $FFD4AA,
		aqua:             c_aqua,
		health:           c_red,
		crit:             /*#*/0x91041e,
		spell:            merge_color(make_color_rgb(28, 98, 85), c_white, .2),
	}

	// Holds all Players spell bullet inventories, spell power and ui roll:
	for(var _i = 0; _i < maxp; _i++) {
		
		global.bulletInventory[_i] = [0];
		global.spellPower[_i] = [0];
		global.uiRoll[_i] = 1;
	}
	
	
	if dev {
		mod_script_call("mod", "defpackloader", "add_post_load_statement", "Sage's race mod has loaded in dev mode", c_yellow)
	}
	
	var _race = [];
	for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
	while(true){
		/// Character Selection Sound:
		for(var i = 0; i < maxp; i++){
			var r = player_get_race(i);
			if(_race[i] != r && r = mod_current){
				sound_play(global.sndSelect); // Select Sound
			}
			_race[i] = r;
		}

		/// Call level_start At The Start Of Every Level:
		if(instance_exists(GenCont)) global.newLevel = 1;
		else if(global.newLevel){
			global.newLevel = 0;
			level_start();
		}
		wait 1;
	}

#define cleanup
	with global.bind_late_step instance_destroy()

 // On Level Start: (Custom Script, Look Above In #define init)
#define level_start
	with(Player){
		for(var i = 0; i < array_length(global.carryOver); i++){
			spellbullet_create(x,y, global.carryOver[i]);
		}
		global.carryOver = [];
		
		if fork(){
			
			wait(14); // this is here so that the fairy doesnt draw over SpiralCont
			if (instance_exists(self) && race == "sage") {
				
				fairy.x = x;
				fairy.y = y;
			}
		}
		break;
	}

 // On Run Start:
#define game_start

	for(var _i = 0; _i < maxp; _i++) {
		
		global.bulletInventory[_i] = [];
		global.spellPower[_i] = 0;
		global.uiRoll[_i] = 1;
	}
	
	with instances_matching(Player, "race", mod_current) {
		
		spell_give(self, "bDefault");
		global.bulletInventory[index] = spellBullets;
	}

	sound_play(global.sndConfirm); // Play Confirm Sound
	
	if fork() {
		
		wait(1)
		with instances_matching(CustomObject, "name", "spellbullet") {
		
			instance_delete(self);
		}
	}

#define draw_outline(_sprIndex, _imgIndex, _x, _y, _scale)
	d3d_set_fog(true, c_white, 0, 0);
	draw_sprite_ext(_sprIndex, _imgIndex, _x -1, _y, _scale, _scale, 0, c_white, 1);
	draw_sprite_ext(_sprIndex, _imgIndex, _x +1, _y, _scale, _scale, 0, c_white, 1);
	draw_sprite_ext(_sprIndex, _imgIndex, _x, _y -1, _scale, _scale, 0, c_white, 1);
	draw_sprite_ext(_sprIndex, _imgIndex, _x -1, _y +1, _scale, _scale, 0, c_white, 1);
	draw_sprite_ext(_sprIndex, _imgIndex, _x +1, _y +1, _scale, _scale, 0, c_white, 1);
	draw_sprite_ext(_sprIndex, _imgIndex, _x, _y +2, _scale, _scale, 0, c_white, 1);
	d3d_set_fog(false, c_white, 0, 0);


 // Name:

#define race_name
	return "SAGE";

 // Description:
#define race_text
	return `GETS @(color:${c.spell})SPELL BULLETS@s#@wSWAP @(color:${c.spell})SPELLS@s`;


 // Starting Weapon:
#define race_swep
	return 1; // Revolver


 // Throne Butt Description:
#define race_tb_text
	return `SWAPPING @(color:${c.spell})SPELLS @sBOOSTS @wSPELLPOWER@s`


 // On Taking Throne Butt:
#define race_tb_take
	/*with instances_matching(Player, "race", "sage"){
		spellpower_change(spellBullets[0], self, 1/3);
	}*/

 // Character Selection Icon:
#define race_menu_button
	sprite_index = global.spr_slct;


 // Portrait:
#define race_portrait
	return global.spr_port;


 // Loading Screen Map Icon:
#define race_mapicon
	return global.spr_icon;


 // Skin Count:
#define race_skins
	return 2; // 2 Skins, A + B


 // Skin Icons:
#define race_skin_button
	sprite_index = global.spr_skin;
	image_index = argument0;


 // Ultra Names:
#define race_ultra_name
	switch(argument0){
		case 1: return "HIGH CALIBER";
		case 2: return "DOUBLE BARRELED";
	}

 // Ultra Descriptions:
#define race_ultra_text
	switch(argument0){
		case 1: return `@(color:${c.spell})SPELLS @sBECOME @sA LOT MORE @wPOWERFUL@s`;
		case 2: return `@wCOMBINE @sYOUR @(color:${c.spell})SPELLS@s`;
		/// Add more cases if you have more ultras!
	}


 // On Taking An Ultra:
#define race_ultra_take
	switch(argument0){
		 // Play Ultra Sounds:
		case 1:
			sound_play(sndFishUltraA);
			with instances_matching(Player, "race", "sage") {
				//Take is called on ultras changing, so if the player has it here, they just got it.
				if has_ultra_a {
					//Double current spellpower
					sage_spell_power *= 2
					//Add ultra A's one spellpower
					sage_spell_power += 1
				}
				//Removing ultra a, reverse of above
				else {
					sage_spell_power -= 1
					sage_spell_power /= 2
				}
				//Update effects with spellpower
				refresh_effects()
			}
			break;
		case 2:
			sound_play(sndFishUltraB);
			with instances_matching(Player, "race", "sage") {
				refresh_effects()
			}
			break;
		/// Add more cases if you have more ultras!
	}



 // Ultra Button Portraits:
#define race_ultra_button
	sprite_index = global.spr_ult_slct;
	image_index = argument0 + 1;


 // Ultra HUD Icons:
#define race_ultra_icon
	return global.spr_ult_icon[argument0];


 // Loading Screen Tips:
#define race_ttip
	var tips = ["FIELD TESTING IN PROGRESS", "FASCINATING @wWEAPONRY@s", `SAGE CAN CAST @(color:${c.spell})SPELLS`, "TWO IN THE CHAMBER"];


	if instance_exists(GameCont){
	    array_push(tips, "SEARCHING FOR SUBJECT " + string(GameCont.kills + 1) + "...")
	    if GameCont.loops > 0 {
	    	array_push(tips, "IT ALL REVOLVES AROUND") //not sure if keeping
	    	array_push(tips, "THE CYLINDER KEEPS TURNING, TURNING")
	    	array_push(tips, "PERFORMANCE EXCEEDING ALL EXPECTATIONS")
	    }
	    if GameCont.area == 103 array_push(tips, "PRIMITIVE, BUT VERY EFFECTIVE ENCAPSULATION...")
	    if GameCont.area == 104 array_push(tips, "SO THIS IS WHERE @pIT@s COMES FROM")
	}

	//Get bullet tips instead of flavor text
	if (irandom(2) == 1) {
		if dev trace("bullet tip")
		tips = []
		var bulletTips = [];

		with instances_matching(Player, "race", mod_current) {
			with spellBullets {
				array_push(bulletTips, bullets[? self.type].ttip)
			}
		}

		unpack(tips, bulletTips)

	}

	if array_length(tips) > 0 {
		return tips[irandom(array_length(tips) - 1)]
	}
	return "SAGE CAN DO COOL TRICKS"

#define fairy_draw(player)
	with player if visible {

		var h = fairy;
		var a = .25;
		var gsize = 1/64;

		var iconIndex = clamp(ultra_get("sage", 2), 0, 1),
			iconSprites = [],
			drawColor = c_white,
			outlineColor = c_white,
			iconColor = c_white,
			colHue,
			colSat,
			colVal,
			maxBullets = bulletLoopMax;
			
		if array_length(spellBullets) == 0 {
			drawColor = c_gray
			iconSprites = [global.sprFairyIcon]
		}
		else {
			for (var i = 0; i < maxBullets; i++) {
				array_push(iconSprites, spell_call_self(spellBullets[i], "fairy_sprite"))
				var fairyColor = spell_call_self(spellBullets[i], "fairy_color");
				colHue += color_get_hue(fairyColor)
				colSat += color_get_saturation(fairyColor)
				colVal += color_get_value(fairyColor)
			}
			drawColor = make_color_hsv(colHue / max(1, i), colSat / max(1, i), colVal / max(1, i))
		}
		
		var w = sprite_get_width(iconSprites[0]) + 12, l = sprite_get_height(iconSprites[0]) + 16;
		
		if (tbBoostTime > 0) {
			var cooldownProgress = tbBoostTime/maxTBBoostTime;
			drawColor = merge_color(drawColor, c_white, .6 * (cooldownProgress))
		}
		
		outlineColor = make_colour_hsv(color_get_hue(drawColor), color_get_saturation(drawColor) / 1.2, 255);
		iconColor = merge_color(merge_color(drawColor, c_black, .7), c_white, clamp(h.swap / fairy_swap_time, 0, 1))
		drawColor = merge_color(drawColor, c_white, clamp(h.swap / fairy_swap_time, 0, 1))
		
		
		//Thronebutt orbital when off cooldown
		var drawOrbitalLater = false;
		if (tbCooldown <= 0 && tbBoostTime <= 0 && has_thronebutt) {
			var orbitalAngle = (instance_exists(GameCont) ? GameCont.timer : current_frame) * 3,
				orbitalPoint = point_on_rotated_ellipse(8, 2, 45, orbitalAngle),
				orbitalDepth = dsin(orbitalAngle),
				orbitalScale = .8 + .2 * orbitalDepth,
				orbitalAlpha = .6 + .2 * orbitalDepth;
				
			if (sign(orbitalDepth)) < 0 {
				draw_sprite_ext(sprCaveSparkle, 2, h.x + orbitalPoint.x, h.y + orbitalPoint.y - 1, orbitalScale, orbitalScale, -2 * orbitalAngle, c_white, orbitalAlpha)
			}
			else {
				drawOrbitalLater = true
			}
		}
		
		// Back draw:
		d3d_set_fog(1, drawColor, 1, 1)
		h.swap = max(0, h.swap - current_time_scale * 1.2)
		draw_sprite_ext(h.sprite_back, -1, h.x + 1, h.y + 1, w * gsize, l * gsize, 0, c_white, .4 * a);
		draw_sprite_ext(h.sprite_back, -1, h.x + 1, h.y - 1, w * gsize, l * gsize, 0, c_white, .4 * a);
		draw_sprite_ext(h.sprite_back, -1, h.x - 1, h.y + 1, w * gsize, l * gsize, 0, c_white, .4 * a);
		draw_set_blend_mode(bm_add);
		draw_sprite_ext(h.sprite_back, -1, h.x - 1, h.y - 1, w * gsize, l * gsize, 0, c_white, .4 * a);
		draw_sprite_ext(h.sprite_back, -1, h.x, h.y, w * gsize, l * gsize, 0, c_white, 1 * a)
		draw_set_blend_mode(bm_normal);
		d3d_set_fog(0, c_black, 0, 0)
		
		//Thronebutt beam effect
		if (tbBoostTime > 0) {
			draw_set_blend_mode(bm_add)
			var beamStrength = tbBoostTime/maxTBBoostTime,
				beamWave = sin(sqrt(1 - beamStrength) * pi);
			draw_line_width_color(h.x - 1, h.y, h.x - 1, h.y - 30 * beamWave, 2 + beamWave * 4, merge_color(drawColor, c_black, .6), c_black)
			draw_line_width_color(h.x - 1, h.y, h.x - 1, h.y + 15 * beamWave, 2 + beamWave * 4, merge_color(drawColor, c_black, .6), c_black)
			draw_set_blend_mode(bm_normal)
		}

		
		// Draw the fairy icon outline:
		for (var i = 0; i < array_length(iconSprites); i++) {
			draw_sprite_ext(iconSprites[i], iconIndex, h.x - 1, h.y, 1, 1, 0, outlineColor, 1);
			draw_sprite_ext(iconSprites[i], iconIndex, h.x + 1, h.y, 1, 1, 0, outlineColor, 1);
			draw_sprite_ext(iconSprites[i], iconIndex, h.x, h.y + 1, 1, 1, 0, outlineColor, 1);
			draw_sprite_ext(iconSprites[i], iconIndex, h.x, h.y - 1, 1, 1, 0, outlineColor, 1);
		}
		// Draw the icon:
		for (var i = 0; i < array_length(iconSprites); i++) {
			draw_sprite_ext(iconSprites[i], iconIndex, h.x, h.y, 1, 1, 0, iconColor, 1);
		}
		
		if (drawOrbitalLater) {
			draw_sprite_ext(sprCaveSparkle, 2, h.x + orbitalPoint.x, h.y + orbitalPoint.y - 1, orbitalScale, orbitalScale, -2 * orbitalAngle, c_white, orbitalAlpha)
		}
		
		if h.swapframes > 0 draw_sprite(global.sprSwapFairy, (6 - h.swapframes), h.x, h.y);

	}
	if !instance_exists(player) {
		instance_destroy()
	}


#define point_on_rotated_ellipse(width, height, ellipseAngle, sampleAngle)
	var cosTheta = dcos(ellipseAngle),
		sinTheta = dsin(ellipseAngle),
		cosT = dcos(sampleAngle),
		sinT = dsin(sampleAngle),
		a = width,
		b = height;
	
	return {
		x:   a * cosTheta * cosT - b * sinTheta * sinT,
		y: -(a * sinTheta * cosT + b * cosTheta * sinT)
	}

#define player_hud(_playerindex, _hudIndex, _hudSide, _xOffset, _yOffset)
     // Spell Bullets:

	var _x = (_hudSide ? 8 : 99) + _xOffset,
		_w = sprite_get_width(global.spellHold) / 2,
		_y = 12 + _yOffset,
		_h = sprite_get_height(global.spellHold) / 2,
		_p = player_find(_playerindex),
		_v = ultra_get("sage", 1) > 0;

	var _playerNum = 0;
	for(var i = 0; i < maxp; i++){
		
		_playerNum += player_is_active(i);
	}
	
	// if instance_exists(_p) {
	// 	var d = mod_script_call("mod", effectMod, "effects_descriptions", _p.activeEffects, _p.sage_spell_power);
	// 	draw_set_font(fntSmall);
	// 	draw_text_nt(-13, 46, "Active Effects:#" + d)
	// 	draw_set_font(fntM);
	// }

	if dev && instance_exists(_p) {

		var d = mod_script_call("mod", effectMod, "effects_descriptions", _p.activeEffects, _p.sage_spell_power);
		draw_set_font(fntSmall);
		draw_text_nt(-13, 46, "Active Effects:#" + d)
		draw_set_font(fntM);
	}

	for(var i = 0; i < max(array_length(global.bulletInventory[_playerindex]), max_spellbullets); i++) {

		var _hudx = (_hudSide ? -10 : 0), // x offset for multiplayer hud
			_hudy = (ceil(global.uiRoll[_playerindex]) = i) - (ceil(global.uiRoll[_playerindex] + 1) = i);
		
		//Draw big fat white line in the back so its more obvious that for Ultra B the effects are combined:
		if(ultra_get("sage", 2) && i < array_length(global.bulletInventory[_playerindex]) - 1){
				
			draw_rectangle_color(_x + 1, _y + _hudy - 2, _x + (_hudSide ? -4 : 4), _y + _hudy, c_white, c_white, c_white, c_white, false);
		}
		
		if i < array_length(global.bulletInventory[_playerindex]){

			var _sprt = spell_call_nc(global.bulletInventory[_playerindex][i], "bullet_sprite", global.spellPower[_playerindex]);

			//Draw Outline for bullets in active slots:
			if (i == 0 || ultra_get("sage", 2)){

				draw_outline(_sprt, _v, _x + _hudx, _y + _hudy, 1)
			}

			//Draw Bullet:
			draw_sprite_ext(_sprt, _v, _x + _hudx, _y + _hudy + 1, 1, 1, 0, c_white, 1);
			draw_sprite_ext(_sprt, _v, _x + _hudx, _y + _hudy, 1, 1, 0, c_white, 1);

			//Darken in secondary Slots:
			if (i > 0 && !ultra_get("sage", 2)) {

				draw_sprite_ext(_sprt, _v, _x + _hudx, _y + _hudy + 1, 1, 1, 0, c_black, .2);
				draw_sprite_ext(_sprt, _v, _x + _hudx, _y + _hudy, 1, 1, 0, c_black, .2);
			}

			var _mpwidth = _playerNum > 1 ? 18 * (_hudSide ? -1 : 1) : 0;
			if point_in_rectangle(mouse_x[_playerindex] - view_xview[_playerindex] - 16 + _xOffset + _mpwidth, mouse_y[_playerindex] - view_yview[_playerindex] + _yOffset, _x - _w, _y - _h - 2, _x + 3, _y + _h) {
				

				var _name = spell_call_nc(global.bulletInventory[_playerindex][i], "bullet_name", global.bulletInventory[_playerindex][i]),
					// _desc = spell_call_nc(global.bulletInventory[_playerindex][i], "bullet_description", global.spellPower[_playerindex], global.bulletInventory[_playerindex][i]);
					_desc = mod_script_call("mod", effectMod, "bullet_get_description", global.bulletInventory[_playerindex][i], global.spellPower[_playerindex])
				draw_set_font(fntM);
			    draw_text_nt(_x - 4 - (10 * i - i) * (_hudSide ? -1 : 1), _y + _h + 3, _name);
			    draw_set_font(fntSmall);
			    draw_text_nt(_x - 2 - (10 * i - i) * (_hudSide ? -1 : 1), _y + _h + 12, _desc);
			}

		}
		else if(player_is_local_nonsync(_playerindex)){
			
			//Draw empty bullet spaces:
			draw_sprite_ext(global.spellHold, 0, _x + _hudx, _y + _hudy, 1, 1, 0, c_white, 1);
		}

		//var _c = make_colour_hsv(_x * 1.5 mod 255, 255, 255);
		//draw_rectangle_color(_x - _w, _y - _h - 2, _x + 2, _y + _h, _c, _c, _c, _c, true);

		_x += _hudSide ? -9 : 9;
	}

	if instance_exists(_p) && (_p.uiroll < (array_length(_p.spellBullets))) {

		_p.uiroll += 0.7 * current_time_scale;
		
	}

#macro bullets mod_variable_get("mod", "SageBullets", "BulletDirectory")
#macro max_spellbullets 2 + dev * 18// + skill_get(5)
#macro fairy_swap_time 6
#macro dev false
#macro c global.colormap
#macro c_fairy $AFA79A
#macro effectMod "sageeffects"

#macro maxTBBoostTime 150
#macro maxTBCooldown 90
#macro TBBoostValue 1

#macro ultra_a ultra_get(mod_current, 1)
#macro ultra_b ultra_get(mod_current, 2)
#macro has_ultra_a ultra_get(mod_current, 1) > 0
#macro has_ultra_b ultra_get(mod_current, 2) > 0
#macro thronebutt skill_get(mut_throne_butt)
#macro has_thronebutt skill_get(mut_throne_butt) > 0

#define create
	hurted = false;
	
	uiroll = 0;

	sage_spell_power = 0;      // Sage spellpower multiplier
	sage_uitimer = 20; // how long to wait on mouse hover before the draw
	spellBullets = [];
	activeEffects = [];
	fairyDrawer = noone
	
	tbBoostTime = 0
	tbCooldown = 0

	if dev {
		spell_give(self, "bGold");
		spell_give(self, "bMelee");
		spell_give(self, "bTurret");
		spell_give(self, "bInfammo");
		spell_give(self, "bPrecision");
		spell_give(self, "bGadget");
		spell_give(self, "bUltra");
		spell_give(self, "bBurst");
		spell_give(self, "bSplit");
		spell_give(self, "bReflective");
		spell_give(self, "bWarp");
		spell_give(self, "bEcho");
		spell_give(self, "bMaggot");
		spell_give(self, "bLove");
		//spell_give(self, "bRust");
		//spell_give(self, "bCursed");
		//spell_give(self, "bQuartz");
		//spell_give(self, "bHeart");
	}

	fairy = {

		creator : self,
		swap : 0,
	    goalX : x,
	    goalY : y,
	    x : x,
	    y : y,
	    right : 0,
	    xoff : 0,
	    yoff : 0,
	    dir : 0,
	    spd : 0,
	    move: 0,
		sprite_back: sprGhostGuardianIdle,
	    curve : 0,
	    resettime : 0,
		swapframes : 0,
	    col : c_fairy,
	    sprite : global.sprFairyIcon,
	    angle : 0
	}

	footkind = 0;

	assign_sprites();
	assign_sounds();

 // Every Frame While Character Exists:
#define step

	global.bulletInventory[index] = spellBullets;
	global.spellPower[index] = sage_spell_power;
	global.uiRoll[index] = uiroll;

	// Fairy code;
	var h = fairy;

	if(array_length(spellBullets) > 0) {
		
		h.sprite = spell_call_self(spellBullets[0], "fairy_sprite");
		h.col = spell_call_self(spellBullets[0], "fairy_color");
	}
	
	with fairy {
		if resettime <= 0 {
			x += approach(x, goalX, 4, current_time_scale)
			y += approach(y, goalY, 4, current_time_scale)

			right = -sign(x - other.x)
			angle = 90 - (90 * right)
			
			//h.col = merge_colour(c_purblue, c_black, .7)

			goalX = other.x + xoff * 1.2
			goalY = other.y + yoff - 16

			if random(100) < 2 * current_time_scale{
				dir = random(360)
				move = irandom_range(4, 10)
				spd = random(2)
				curve = random_range(-10, 10)
				curve += sign(curve) * 3
			}
			if move > 0 {
				move -= current_time_scale
				xoff += lengthdir_x(spd * current_time_scale, dir)
				yoff += lengthdir_y(spd * current_time_scale, dir)
				dir += curve * current_time_scale
				curve += sign(curve) * current_time_scale
				if point_distance(xoff, yoff, 0, 0) > 11 {
					dir -= angle_approach(dir, point_direction(xoff, yoff, 0, 0), 3, current_time_scale)
					spd += current_time_scale/10
				}
			}
			swapframes = max(0, swapframes - current_time_scale * .5);

		}
		else resettime -= current_time_scale;
	}

	 if dev && button_pressed(0, "horn"){
	 	with spellbullet_create(0.x, 0.y, "bCursed") {
			//lmao
	 	}
	 }

	if (tbCooldown > 0) {
		tbCooldown -= current_time_scale
	}
	
	if (tbBoostTime > 0) {
		tbBoostTime -= current_time_scale
		
		if tbBoostTime <= 0 {
			spellpower_change(self, -TBBoostValue)
			tbCooldown = maxTBCooldown
		}
	}

	if(!instance_exists(global.bind_late_step)) {
		global.bind_late_step = script_bind_step(late_step, 0);
	}
	
	if (!instance_exists(fairyDrawer)) {
		fairyDrawer = script_bind_draw(fairy_draw, -11, self);
	}

	//Call bullet step events
	//Bullet steps are for like, particle effects
	for (var i = 0, l = bulletLoopMax; i < l; i++) {
		spell_call_self(spellBullets[i], "on_step");
	}
	//Effects do shit
	effects_call(activeEffects, "on_step");
	
	//Effects when taking damage:
	if(my_health < lsthealth && hurted = false && sprite_index == spr_hurt){
		
			effects_call(activeEffects, "on_hurt");
			hurted = true;
	}
	
	if my_health == lsthealth hurted = false;

	///  ACTIVE : Swap Spells  \\\

	// Player effects:
	if(canspec && button_pressed(index, "spec") && array_length(spellBullets) > 1) {

		fairy.swap = fairy_swap_time + 2;
		fairy.swapframes = 6;
		sleep(5);
		weapon_post(1, 4, 0);
		
		// This is only for playing the swap sound of the bullet youre swapping into
		spell_call_self(spellBullets[1], "bullet_swap");

		var _temp = spellBullets[0];
		for(var i = 1; i < array_length(spellBullets); i++) {
			spellBullets[i-1] = spellBullets[i];
		}
		spellBullets[array_length(spellBullets) - 1] = _temp;
		
		//Don't refresh on swap if you have ultra B
		var shouldRefresh = !(has_ultra_b);
		
		if (has_thronebutt) {
			//Deactivate boost if active
			if (tbBoostTime > 0) {
				tbBoostTime = 0
				tbCooldown = maxTBCooldown
				spellpower_change_no_refresh(self, -TBBoostValue)
				shouldRefresh = true
			}
			//Activate boost if possible
			if (tbCooldown <= 0) {
				
				//sound_play_pitchvol();
				
				tbBoostTime = maxTBBoostTime
				spellpower_change_no_refresh(self, TBBoostValue)
				shouldRefresh = true
			}
		}
		
		if (shouldRefresh) {
			refresh_effects()
		}
		
		uiroll = -1;
	}

	// Drop bullets when dead:
	if(fork()){
		var _b = spellBullets,
			_x = x,
			_y = y;
		wait(0);
		if !instance_exists(self) {
			with _b {
				with spellbullet_create(_x, _y, self) {
					motion_add(random(360), 5);
				}
			}
		}
		exit;
	}

	///  PASSIVE : Spawn Spellbullets on weapon chest open \\\
	with(instances_matching(WeaponChest, "object_index", WeaponChest)){
		if(fork()){
			var _x = x;
			var _y = y;
			var _c = curse;
			wait(0);
			if(!instance_exists(self) && instance_exists(other)){
				wait(0);
				//the player is passed in as an optional variable specifically for ""
				//it makes it so the player gets spellbullets they don't have already from normal chests
				with spellbullet_create(_x,_y, _c == true ? "bCursed" : "", other){
					
					motion_add(random(360), 5);
				}
			}
			exit;
		}
	}
	with(GoldChest){
		if(fork()){
			var _x = x;
			var _y = y;
			wait(0);
			if(!instance_exists(self)){
				wait(0);
				with spellbullet_create(_x,_y, "bGold"){
					
					motion_add(random(360), 5);
				}
			}
			exit;
		}
	}
	// with(ProtoChest) {
	// 	if sprite_index == sprProtoChestOpen {
	// 		if "sage_ultra_bullet_drop" not in self {
	// 			with spellbullet_create(x, y, "bRust"){
					
	// 				motion_add(random(360), 5);
	// 			}
	// 			sage_ultra_bullet_drop = true
	// 		}
	// 	}
	// }
	with(BigWeaponChest){
		if(fork()){
			var _x = x;
			var _y = y;
			wait(0);
			if(!instance_exists(self)){
				wait(0);
				repeat(3) with spellbullet_create(_x,_y, "", other){
					
					motion_add(random(360), 6);
				}
			}
			exit;
		}
	}
	with(BigCursedChest){
		if(fork()){
			var _x = x;
			var _y = y;
			wait(0);
			if(!instance_exists(self)){
				wait(0);
				repeat(3) with spellbullet_create(_x,_y, "bCursed", other){
					
					motion_add(random(360), 6);
					
					var posEffects = mod_variable_get("mod", "bCursed", "positiveEffects"),
						negEffects = mod_variable_get("mod", "bCursed", "negativeEffects");
					array_push(spell.effects, posEffects[irandom(array_length(posEffects) - 1)]);
					array_push(spell.effects, negEffects[irandom(array_length(negEffects) - 1)]);
				}
			}
			exit;
		}
	}
	with(GiantWeaponChest){
		if(fork()){
			var _x = x;
			var _y = y;
			wait(0);
			if(!instance_exists(self)){
				wait(0);
				repeat(12) with spellbullet_create(_x,_y, "", other){
					
					motion_add(random(360), 12);
				}
			}
			exit;
		}
	}
	with instances_matching(chestprop, "name", "DefCustomChest"){
		if(fork()){
			var _x = x;
			var _y = y;
			wait(0);
			if(!instance_exists(self)){
				wait(0);
				repeat(2) with spellbullet_create(_x,_y, "", other){
					
					motion_add(random(360), 5);
				}
			}
			exit;
		}
	}


#define before_sage_shoot()

	var shootEvent = {
		radPrevious: GameCont.rad,
		cancelled: false
	};

	// for (var i = 0, l = bulletLoopMax; i < l; i++) {
	// 	spell_call_self(spellBullets[i], "on_pre_shoot", shootEvent);
	// }
	
	//"Shooting" is when the gun itself is fired, "Firing" is when sage goes to fire.
	//Ex: The secondary shots of Burst are Shooting, and the two shots for Split are both Firing.

	effects_call(activeEffects, "on_pre_shoot", shootEvent)

	return shootEvent


#define post_sage_shoot(shootEvent)

	effects_call(activeEffects, "on_post_shoot", shootEvent)

	
	if (GameCont.rad < shootEvent.radPrevious) {
		effects_call(activeEffects, "on_rads_use", shootEvent.radPrevious - GameCont.rad)
	}

	if (GameCont.rad <= 0 && shootEvent.radPrevious > 0) {
		effects_call(activeEffects, "on_rads_out")
	}


	//Firing effects don't actually check for Sage having enough ammo for things like Burst and Split.
	//So he could go negative if he used Burst at low ammo. This 'prevents' that.
	//Sage can have a little free ammo, as a treat.
	for (var i = 1; i < array_length(ammo); i++) {
		ammo[i] = max(0, ammo[i])
	}


#define sage_has_hook(script)
	for (var i = 0, l = array_length(activeEffects); i < l; i++) {
		if (lq_exists(activeEffects[i].type, script)) return true
	}
	return false

//Called by SageMod
#define on_new_projectiles(newProjectiles)
	if sage_has_hook("on_new_projectiles") {
		var myProjectiles = instances_matching(newProjectiles, "creator", self);
		if (array_length(myProjectiles) > 0) {
			effects_call(activeEffects, "on_new_projectiles", myProjectiles)
		}
	}
	if sage_has_hook("on_enemy_projectiles") {
		var enemyProjectiles = instances_matching_ne(newProjectiles, "team", team);
		if (array_length(myProjectiles) > 0) {
			effects_call(activeEffects, "on_enemy_projectiles", enemyProjectiles)
		}
	}


#define sage_fire(fireEvent, effectStack)

	var shootEvent = before_sage_shoot();
	
	if (fireEvent.angle_offset != 0) {
		mod_script_call_self("mod", "bSplit", "player_fire_at", undefined, undefined, undefined, fireEvent.angle_offset)
	}
	else {
		player_fire()
	}
	call_fire_filtered(activeEffects, fireEvent, effectStack)
	post_sage_shoot(shootEvent)

	
#define call_fire_filtered(effectList, fireEvent, effectStack)
	for(var i = 0; i < array_length(effectList); i++) {
		if (array_find_index(effectStack, effectList[i].type.name) >= 0) continue
		
		var ref = lq_get(effectList[i].type, "on_fire");
		
        if (ref != undefined) {
            script_ref_call(ref, effectList[i].working_value, effectList[i], fireEvent, effectStack);
        }
    }


#define fire(shootEvent)

	var event = {
		cancelled: false,
		angle_offset: 0
	}
	
	//Used for things like firing sounds, specific to bullets, not effects
	for (var i = 0, l = bulletLoopMax; i < l; i++) {
		spell_call_self(spellBullets[i], "on_fire", event)
	}


	if !event.cancelled {

		if !shootEvent.cancelled {
			call_fire_filtered(activeEffects, event, [])
			post_sage_shoot(shootEvent)
		}

	}

	if event.cancelled {trace("Fire Event was cancelled. Please make sure its working")}
	
#define sage_fire_default()
	var fireEvent = {
		cancelled: false,
		angle_offset: 0
	}
	
	sage_fire(fireEvent, [])


#macro bulletLoopMax ultra_b ? array_length(spellBullets) : min(array_length(spellBullets), 1)

#define effects_call
var effectsList = argument[0], script = argument[1];
var args1 = argument_count > 2 ? argument[2] : undefined;
var args2 = argument_count > 3 ? argument[3] : undefined;
	mod_script_call_self("mod", effectMod, "effects_call", effectsList, script, args1, args2)
	
#define effects_call_reverse
var effectsList = argument[0], script = argument[1];
var args1 = argument_count > 2 ? argument[2] : undefined;
var args2 = argument_count > 3 ? argument[3] : undefined;
	mod_script_call_self("mod", effectMod, "effects_call_reverse", effectsList, script, args1, args2)
	

#define get_active_bullets()
	return has_ultra_b ? spellBullets : array_length(spellBullets) > 0 ? [spellBullets[0]] : []

//Call after making changes to bullets to revert current effects and apply new ones
#define refresh_effects()

	// trace("refreshing!")
	//Deactivate old effects, called in reverse to resolve stacks properly
	effects_call_reverse(activeEffects, "on_deactivate")
	//Compile new effects from active bullets
	activeEffects = bullets_compose(get_active_bullets())
	//Activate new effects
	effects_call(activeEffects, "on_activate")


#define bullets_compose(bulletList)
	var effectList = [], temp = [];
	with bulletList {
		array_push(temp, effects)
	}
	unpack(effectList, temp)
	return mod_script_call("mod", effectMod, "effects_compose_all", effectList, sage_spell_power);


#define spellpower_change(inst, spellpower)
	with inst {
		sage_spell_power += spellpower * (1 + ultra_a)
		refresh_effects()
	}

#define spellpower_change_no_refresh(inst, spellpower)
	inst.sage_spell_power += spellpower * (1 + ultra_a)
	
#define spell_init(_spell)
	
	if (is_object(_spell)) {
		return _spell;
	}
	
	var spell = {
		type: _spell,
		effects: []
	};
	
	mod_script_call("mod", spell.type, "on_init", spell);
	spell.effects = mod_script_call("mod", effectMod, "bullet_get_effects", spell);
	mod_script_call("mod", spell.type, "post_init", spell);
	return spell;
	
#define spell_give(_player, _spell)
	var spell = spell_init(_spell),
		spellBullets = _player.spellBullets,
		bulletCount = array_length(spellBullets);
		
	_player.uiroll = -1;
		
	if bulletCount == 0 { // Gain stats when you have no bullets:
		
		array_push(spellBullets, spell);		
		// stat_gain(spell, _player);
		refresh_effects()
		return undefined;
	}
	
	if (bulletCount < max_spellbullets) { //If the player has space to hold it.
		
		// if (!ultra_b) {
		
		// 	stat_lose(spellBullets[0], _player);	
		// }
		
		array_push(spellBullets, "a");
		for(var i = bulletCount - 1; i >= 0; i--) {
			
			spellBullets[i + 1] = spellBullets[i];
		}
		spellBullets[0] = spell;
		// stat_gain(spell, _player);
		refresh_effects()
		return undefined;
	}
	
	//If the player must drop a bullet to hold this
	var oldSpell = spellBullets[0];
	
	// stat_lose(oldSpell, _player);
	spellBullets[0] = spell;
	// stat_gain(spellBullets[0], _player);
	refresh_effects()
	
	return oldSpell;


#define spell_call_self
	var spellIn = argument[0],
		script  = argument[1];
	
	switch (argument_count) {
		default:
			trace("too many arguments for spell_call_self. add a case with that many arguments");
		case 1: case 2:
			return (mod_script_call_self("mod", spellIn.type, script, sage_spell_power, spellIn));
		case 3:
			return (mod_script_call_self("mod", spellIn.type, script, sage_spell_power, spellIn, argument[2]));
		case 4:
			return (mod_script_call_self("mod", spellIn.type, script, sage_spell_power, spellIn, argument[2], argument[3]));
		case 5:
			return (mod_script_call_self("mod", spellIn.type, script, sage_spell_power, spellIn, argument[2], argument[3], argument[4]));
	}

#define spell_call_nc
	var spellIn = argument[0],
		script  = argument[1],
		spellPower = argument[2];
	
	switch (argument_count) {
		default:
			trace("too many arguments for spell_call_nc. add a case with that many arguments");
		case 2: case 3:
			return (mod_script_call_nc("mod", spellIn.type, script, spellPower, spellIn));
		case 4:
			return (mod_script_call_nc("mod", spellIn.type, script, spellPower, spellIn, argument[3]));
		case 5:
			return (mod_script_call_nc("mod", spellIn.type, script, spellPower, spellIn, argument[3], argument[4]));
		case 6:
			return (mod_script_call_nc("mod", spellIn.type, script, spellPower, spellIn, argument[3], argument[4], argument[5]));
	}

#define spellbullet_create
  var 	_x = argument[0],
    	_y = argument[1],
	    _type = argument[2];

	with(instance_create(_x, _y, CustomObject)){

		sprite_index = mskNone;
		mask_index   = mskPlayer;
		spr_shine    = ultra_get("sage", 1) > 0 ? global.sprShineAUpg : global.sprShineA;
		image_speed  = 0;
		shine_index  = 0;
		shine_speed  = 0;
		name     = "spellbullet";
		array_push(global.bulletObjects, self)
		friction = 0.5;
		shine = 45;
		spell_ref = "";

		direction = random(360);
		image_angle = direction;

		on_step = spellbullet_step;
		on_pick = script_ref_create(spellbullet_pickup);
		on_draw = spellbullet_draw;

		if(_type == ""){

			spell = "bDefault";
			var availableBullets = get_bullets(0, GameCont.hard),
				results = [];
				
			with availableBullets {
				
				var passed = true;
				if (self != "bCursed") {
					with argument[3].spellBullets {
						if (self.type == other) {
							passed = false;
							break;
						}
					}
				}
				
				if (passed) {
					array_push(results, self);
				}
			}
		
			if (array_length(results) > 0) {
				spell = results[irandom(array_length(results) - 1)];
			}
		}
		else {
			spell = _type;
		}

		//if dev trace(type, bullets[? type])
		spell_ref = spell;
		spell = spell_init(spell);
		my_prompt = prompt_create("");
		sprite_index = spell_call_nc(spell, "bullet_sprite", 0);
		image_index = has_ultra_a;
		
		return self;
	}

#define spellbullet_draw
	draw_self();
	draw_set_blend_mode(bm_add);
	draw_sprite_ext(spr_shine, shine_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);
	draw_set_blend_mode(bm_normal);

#define get_bullets(_min, _max)
	var values = ds_map_values(bullets),
		returnlist = [];

	for (var i = 0; i < array_length(values); i++) {
		if values[i].area >= _min && values[i].area <= _max {
			array_push(returnlist, values[i].key)
		}
	}
	return returnlist;
	
#define move_contact_solid_slide(dir, dist)
	var _x = lengthdir_x(dist, dir),
		_y = lengthdir_y(dist, dir);
	if _x != 0 move_contact_solid(_x > 0 ? 0 : 180, abs(_x))
	if _y != 0 move_contact_solid(_y > 0 ? 270 : 90, abs(_y))
	
#define spellbullet_step

	if "spell_ref" in self && spell_ref == "bCursed" && !irandom(9) instance_create(x + random_range(-4, 4), y + random_range(-4, 4), Curse);
	shine -= current_time_scale;
	if (shine <= 0) {

		shine_speed = .35;
	}
	shine_index += shine_speed * current_time_scale;
	if (shine_index >= 6) {

		shine_speed = 0;
		shine_index = 0;
		shine = 45;
	}

	if place_meeting(x, y, WepPickup) {
		var n = instance_nearest(x, y, WepPickup),
			d = point_direction(x, y, n.x, n.y) + 180;
		move_contact_solid_slide(d, 2 * current_time_scale)
		with n {
			move_contact_solid_slide(d + 180, 2 * current_time_scale)
		}
	}
	
	if place_meeting(x, y, CustomObject) {
		global.bulletObjects = instances_matching_ne(global.bulletObjects, "id", null)
		with instances_meeting(x, y, instances_matching_ne(global.bulletObjects, "id", self)) {
			var d = point_direction(x, y, other.x, other.y);
			move_contact_solid_slide(d + 180, 2 * current_time_scale)
			with other {
				move_contact_solid_slide(d, 2 * current_time_scale)
			}
		}
	}

	var _nearest = instance_nearest(x,y,Portal);
	 // Move:
	if(_nearest != noone && distance_to_object(_nearest) < 50){
		var	_l = 6 * current_time_scale,
			_d = point_direction(x, y, _nearest.x, _nearest.y),
			_x = x + lengthdir_x(_l, _d),
			_y = y + lengthdir_y(_l, _d);

		image_angle += 30 * current_time_scale;

		if(place_free(_x, y)) x = _x;
		if(place_free(x, _y)) y = _y;

		if(distance_to_object(Portal) == 0){
			array_push(global.carryOver, spell);
			instance_destroy();
			exit
		}
	}

	if(distance_to_object(Wall) < 1){
		move_bounce_solid(false);
		if abs(speed) > 0 {
			move_outside_solid(point_direction(x, y, xstart, ystart), 10)
		}
	}

#define spellbullet_pickup(index, spellbullet, prompt)
	with(player_find(index)) {

		if(race == mod_current) {

			var given = spell_give(self, spellbullet.spell),
			    spellSwap = spellbullet.spell;
			    
			if (given != undefined) {
				
				spellbullet_create(spellbullet.x, spellbullet.y, given);
			}
			with (spellbullet) {
				
				instance_destroy();
			}
			
			// Create popup text:
			with instance_create(x, y, PopupText) {
				
				target = index;
				text = spell_call_nc(spellSwap, "bullet_name", spellSwap);
			}
			
			// Play swap sound:
			spell_call_self(spellSwap, "bullet_swap");
			fairy.swap = fairy_swap_time + 2;
			fairy.swapframes = 6;
			sound_play_pitchvol(sndSwapPistol, 1.5, .5);
		}
	}


//'Flattens' stuff (an array), taking any content (even in subarrays) and adding it to the 'box'
#define unpack(box, stuff)
	for (var i = 0; i < array_length(stuff); i++) {
	    if is_array(stuff[i]){
	        unpack(box, stuff[i])
	    }
	    else{
	        array_push(box, stuff[i])
	    }
	}


#define assign_sprites
	if(object_index == Player) {
		 // Set Sprites:
		spr_idle = global.spr_idle[bskin];
		spr_walk = global.spr_walk[bskin];
		spr_hurt = global.spr_hurt[bskin];
		spr_dead = global.spr_dead[bskin];
		spr_sit1 = global.spr_sit1[bskin];
		spr_sit2 = global.spr_sit2[bskin];
	}

#define assign_sounds
	  // Set Sounds:
	snd_wrld = global.sndWrld;	// FLÄSHYN
	snd_hurt = global.sndHurt;	// THE WIND HURTS
	snd_dead = global.sndDie;	// THE STRUGGLE CONTINUES
	snd_lowa = global.sndLowA;	// ALWAYS KEEP ONE EYE ON YOUR AMMO
	snd_lowh = global.sndLowH;	// THIS ISN'T GOING TO END WELL
	snd_chst = global.sndChest;	// TRY NOT OPENING WEAPON CHESTS
	snd_valt = global.sndVault;	// AWWW YES
	snd_crwn = sndMutant1Crwn;	// CROWNS ARE LOYAL
	snd_spch = sndMutant1Spch;	// YOU REACHED THE NUCLEAR THRONE
	snd_idpd = sndMutant1IDPD;	// BEYOND THE PORTAL
	snd_cptn = sndMutant1Cptn;	// THE STRUGGLE IS OVER


#define prompt_create(_text)
	/*
		Creates an E key prompt with the given text that targets the current instance
	*/

	with(Prompt_create(x, y)){
		text    = _text;
		creator = other;
		depth   = other.depth;

		return self;
	}

	return noone;

#define Prompt_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		name	   = "SagePrompt"
		mask_index = mskWepPickup;
		persistent = true;
		creator    = noone;
		nearwep    = noone;
		depth      = 0; // Priority (0==WepPickup)
		pick       = -1;
		xoff       = 0;
		yoff       = 0;

		 // Events:
		on_meet = script_ref_create(spellbullet_prompt_meet);

		on_begin_step = Prompt_begin_step;
		on_step = spellbullet_prompt_step
		on_end_step = Prompt_end_step;
		on_cleanup = Prompt_cleanup;
	
		array_push(global.prompts, self)
	
		return self;
	}

#define spellbullet_prompt_meet
	//For on_meet: other = player, self = prompt, return if the player can interact;
	if (other.race == mod_current) {
		return true
	}
	return false

#define spellbullet_prompt_step
	//'pick' is set to the player that is activating the prompt
	if pick > -1 {
		var p = player_find(pick)
		if instance_exists(p) {
			if instance_exists(creator) {
				if "on_pick" in creator {
					with creator {
						script_ref_call(on_pick, other.pick, self, other);
					}
				}
			}
		}
	}

#define draw_spellbullet_description(x, y, bullet, player)
	instance_destroy()
	
	var halign = draw_get_halign(),
		valign = draw_get_valign();
		
	var spellpower = "sage_spell_power" in player ? player.sage_spell_power : 0,
		d = mod_script_call("mod", effectMod, "bullet_get_description", bullet, spellpower),
		name = spell_call_nc(bullet, "bullet_name", spellpower),
		yoff = (6 * round(string_count("#", d) + 1)) + 16;
		// yoff = string_height(d) + 26;
		
	draw_set_font(fntSmall);
	draw_set_halign(1)
	//fa_top
	draw_set_valign(0)
	draw_text_nt(x, y - yoff, d)
	draw_set_font(fntM);
	//fa_bottom
	draw_set_valign(2)
	draw_text_nt(x, y - yoff - 1, name)
	draw_set_halign(halign)
	draw_set_valign(valign)

#define Prompt_begin_step
	with(nearwep){
		instance_delete(self);
	}

#define Prompt_end_step
	 // Follow Creator:
	if(creator != noone){
		if(instance_exists(creator)){
			if(instance_exists(nearwep)){
				with(nearwep){
					x += other.creator.x - other.x;
					y += other.creator.y - other.y;
					visible = true;
				}
				if instance_exists(creator) && "spell" in creator {
					script_bind_draw(draw_spellbullet_description, -20, creator.x, creator.y, creator.spell, instance_nearest(creator.x, creator.y, Player))
				}
			}
			x = creator.x;
			y = creator.y;
		}
		else instance_destroy();
	}

#define Prompt_cleanup
	with(nearwep){
		instance_delete(self);
	}

#define late_step
	 // Prompts:
	 //This code was originally sourced from NTTE and has recieved some minor alterations.
	 
	if (array_length(global.prompts) == 0) exit;
	
	//Update prompt array
	var _inst = instances_matching_ne(global.prompts, "id", undefined);
	if (array_length(_inst) != array_length(global.prompts)) {
		global.prompts = _inst
	}
	
	//Normal code
	if(array_length(_inst)) {
		 // Reset:
		var _instReset = instances_matching_ne(_inst, "pick", -1);
		if(array_length(_instReset)){
			with(_instReset){
				pick = -1;
			}
		}

		 // Player Collision:
		if(instance_exists(Player)){
			_inst = instances_matching(_inst, "visible", true);
			if(array_length(_inst)){
				with(instances_matching(Player, "visible", true)){
					var _id = id;
					if(
						place_meeting(x, y, CustomObject)
						&& !place_meeting(x, y, IceFlower)
						&& !place_meeting(x, y, CarVenusFixed)
					){
						var _noVan = true;

						 // Van Check:
						if(instance_exists(Van) && place_meeting(x, y, Van)){
							with(instances_meeting(x, y, instances_matching(Van, "drawspr", sprVanOpenIdle))){
								if(place_meeting(x, y, other)){
									_noVan = false;
									break;
								}
							}
						}

						if(_noVan){
							var	_nearest  = noone,
								_maxDis   = null,
								_maxDepth = null;

							// Find Nearest Touching Indicator:
							if(instance_exists(nearwep)){
								_maxDis   = point_distance(x, y, nearwep.x, nearwep.y);
								_maxDepth = nearwep.depth;
							}
							with(instances_meeting(x, y, _inst)){
								if(place_meeting(x, y, other)){
									if(!instance_exists(creator) || creator.visible){
										if(!is_array(on_meet) || mod_script_call(on_meet[0], on_meet[1], on_meet[2])){
											if(_maxDepth == null || depth < _maxDepth){
												_maxDepth = depth;
												_maxDis   = null;
											}
											if(depth == _maxDepth){
												var _dis = point_distance(x, y, other.x, other.y);
												if(_maxDis == null || _dis < _maxDis){
													_maxDis  = _dis;
													_nearest = self;
												}
											}
										}
									}
								}
							}

							 // Secret IceFlower:
							//Run from Prompt
							with(_nearest){
								nearwep = instance_create(x + xoff, y + yoff, IceFlower);
								with(nearwep){
									name         = _nearest.text;
									x            = xstart;
									y            = ystart;
									xprevious    = x;
									yprevious    = y;
									visible      = false;
									mask_index   = mskNone;
									sprite_index = mskNone;
									spr_idle     = mskNone;
									spr_walk     = mskNone;
									spr_hurt     = mskNone;
									spr_dead     = mskNone;
									spr_shadow   = -1;
									snd_hurt     = -1;
									snd_dead     = -1;
									size         = 0;
									team         = 0;
									my_health    = 99999;
									nexthurt     = current_frame + 99999;
								}
								//Run from Player
								with(other){
									nearwep = other.nearwep;
									if(button_pressed(index, "pick")){
										other.pick = index;
									}
								}
							}
						}
					}
				}
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

#define approach(a, b, n, dn)
	return (b - a) * (1 - power((n - 1)/n, dn))

#define angle_approach(a, b, n, dn)
	return angle_difference(a, b) * (1 - power((n - 1)/n, dn))




#define trace_obj_start(obj, fieldname, _x, _y)
	try_trace_object(obj, fieldname, {x: _x, y: _y})


#define get_structure_starter
var obj = argument[0];
var fieldName = argument_count > 1 ? argument[1] : "";
	if (fieldName != "") {
		return fieldName + " @s: " + get_object_bracket(obj) + "@w"
	}
	return get_object_bracket(obj)

#define get_object_bracket(obj)
	if is_object(obj) return "{"
	if is_array(obj) return "["
	if ds_map_valid(obj) return "{ ?"
	if ds_list_valid(obj) return "[ |"
	
	
#define try_trace_object(obj, fieldname, pos)

	var passed = false;
	if is_array(obj) {
		passed = true
		draw_line_pos(pos, get_structure_starter(obj, fieldname))
		for (var i = 0, l = array_length(obj); i < l; i++) {
			try_trace_indented(obj[i], "", pos)
		}
		draw_line_pos(pos, "@s]@w")
	}
	if is_object(obj) {
		passed = true
		draw_line_pos(pos, get_structure_starter(obj, fieldname))
		for (var i = 0, l = lq_size(obj); i < l; i++) {
			var value = lq_get_value(obj, i),
				key =   lq_get_key(obj, i);
				
			try_trace_indented(value, key, pos);
		}
		
		draw_line_pos(pos, "@s}@w")
	}
	if ds_map_valid(obj) {
		passed = true
		draw_line_pos(pos, get_structure_starter(obj, fieldname))
		
		var values = ds_map_values(obj),
			keys = ds_map_keys(obj);
		
		for (var i = 0, l = array_length(values); i < l; i++) {
			try_trace_indented(values[i], keys[i], pos)
		}
			
		draw_line_pos(pos, "@s}@w")
	}
	if ds_list_valid(obj) {
		passed = true
		draw_line_pos(pos, get_structure_starter(obj, fieldname))
		var values = ds_list_to_array(obj);
		for (var i = 0, l = array_length(values); i < l; i++) {
			try_trace_indented(values[i], "", pos)
		}
		draw_line_pos(pos, "@s]@w")
	}
	if is_string(obj) {
		obj = `@(color:${merge_color(c_white, c_lime, .3)})"${obj}"@w`
	}
	
	if (!passed) {
		if (fieldname != "") {
			draw_line_pos(pos, fieldname + " : " + string(obj))
		}
		else {
			draw_line_pos(pos, string(obj))
		}
	}
	
#define try_trace_indented(obj, fieldname, pos)
	pos.x += 6
	try_trace_object(obj, fieldname, pos)
	pos.x -= 6

#define trace_lwo_start(lwo, _x, _y)
	trace_lwo(lwo, {x: _x, y: _y})

#define trace_lwo(lwo, pos)
	for (var i = 0, l = lq_size(lwo); i < l; i++) {
		var value = lq_get_value(lwo, i),
			key =   lq_get_key(lwo, i) + " : ";
		
		if is_object(value) {
			key += "{"
		}
		else {
			key += string(value)
		}
		
		draw_line_pos(pos, key)

		if is_object(value) {
			pos.x += 6
			trace_lwo(value, pos)
			pos.x -= 6
			draw_line_pos(pos, "}")
		}
	}

#define draw_line_pos(pos, text)
	draw_text_nt(pos.x, pos.y, text)
	pos.y += string_height(text) + 1

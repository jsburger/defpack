/*TODO:
* Error for custom sage stats in multiplayer
* Bounce code for:
  * Mega Laser Cannon
  * Quartz Laser
  * All Vector guns
  * Sniper Rifle & Shotgun
* Split code for:
  * Popper (is wierdy rn)
  * Sniper Rifle & Shotgun
  * Mega Disc Gun
  * Abris guns
  * all charge weps actually
  * Plasmite Cannon (also wierdy rn)
  * Mega Laser, Quartz Laser and Ionizer do split but dont change Angle
* Kaboomerang and LWheel dont work well in general
* Brushlikes dont work well
* Secondary Projectiles should not split (its too much bro)
* Non sage players should not be able to pick up spell bullets
* "LOW HP" text overlaps with bullet hud
* bullet hud doesnt draw during pause
* sage b skin
* sage sounds
* Throne Butt is cringe rn (its awkward to use), please change
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
	global.ttip_set = false;

	/// Define Sprites : sprite_add("path/to/sprite/starting/from/mod/location.png", frames, x-offset, y-offset) \\\
	 // A-Skin:
	 var _i = "../../sprites/sage/"
	global.spr_idle[0] = sprite_add(_i + "sprGunIdle.png",	6, 12, 12);
	global.spr_walk[0] = sprite_add(_i + "sprGunWalk.png",	6, 12, 12);
	global.spr_hurt[0] = sprite_add(_i + "sprGunHurt.png",	3, 12, 12);
	global.spr_dead[0] = sprite_add(_i + "sprGunDie.png",  	6, 12, 12);
	global.spr_sit1[0] = sprite_add(_i + "sprGunWalk.png",	6, 12, 12);
	global.spr_sit2[0] = sprite_add(_i + "sprGunIdle.png",	6, 12, 12);

	 // B-Skin:
	global.spr_idle[1] = sprite_add(_i + "sprGunIdle.png",	6, 12, 12);
	global.spr_walk[1] = sprite_add(_i + "sprGunWalk.png",	6, 12, 12);
	global.spr_hurt[1] = sprite_add(_i + "sprGunHurt.png",	3, 12, 12);
	global.spr_dead[1] = sprite_add(_i + "sprGunDie.png",	  6, 12, 12);
	global.spr_sit1[1] = sprite_add(_i + "sprGunWalk.png",	6, 12, 12);
	global.spr_sit2[1] = sprite_add(_i + "sprGunIdle.png",	6, 12, 12);

	 // Character Selection / Loading Screen:
	global.spr_slct = sprite_add(_i + "sprGunSlct.png", 1, 0,  0);
	global.spr_port = sprite_add(_i + "sprGunPortrait.png",	1,	40, 243);
	global.spr_skin = sprite_add(_i + "sprGunSkin.png",		race_skins(),	16, 16);
	global.spr_icon = sprite_add(_i + "sprGunMapIcon.png",	race_skins(),	10, 10);

	 // Ultras:
	global.spr_ult_slct = sprite_add(_i + "sprGunMapIcon.png",	ultra_count(mod_current), 12, 16);
	global.spr_ult_icon[1] = sprite_add(_i + "sprGunMapIcon.png", 1, 8, 9);
	global.spr_ult_icon[2] = sprite_add(_i + "sprGunMapIcon.png", 1, 8, 9);

	 // FX:
	 global.sprSwapFairy = sprite_add(_i + "fx/sprWepSwapL.png", 6, 16, 16);
	 // Reapply sprites if the mod is reloaded. //
	with(instances_matching(Player, "race", mod_current)) {
		assign_sprites();
		assign_sounds();
	}

	global.spellHold = sprite_add(_i + "sprSpellBulletEmpty.png", 1, 6, 7);

	global.carryOver = [];

	global.bind_late_step = noone;

	global.colormap = {

		neutral: 					$BAB0A9,
		speed:   					$CE7314,
		projectile_speed: $E5BC16,
		accuracy:         $0067F7,
		spellpower:				$A83487,
		projectile:       $00ABFA,
		ammo:             $00ABFA,
		bounce:           $00ABFA,
		reload:           $FFFFFF,
		aqua:             c_aqua
	}

	var _race = [];
	for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
	while(true){
		/// Character Selection Sound:
		for(var i = 0; i < maxp; i++){
			var r = player_get_race(i);
			if(_race[i] != r && r = mod_current){
				sound_play(sndMutant1Slct); // Select Sound
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

 // On Level Start: (Custom Script, Look Above In #define init)
#define level_start
	global.ttip_set = false;
	with(Player){
		for(var i = 0; i < array_length(global.carryOver); i++){
			spellbullet_create(x,y, global.carryOver[i]);
		}
		global.carryOver = [];
		break;
	}

 // On Run Start:
#define game_start
	sound_play(sndMutant1Cnfm); // Play Confirm Sound
	global.ttip_set = false;

#define draw_outline(_sprIndex, _imgIndex, _x, _y)
	d3d_set_fog(true, c_white, 0, 0);
	draw_sprite(_sprIndex, _imgIndex, _x -1, _y);
	draw_sprite(_sprIndex, _imgIndex, _x +1, _y);
	draw_sprite(_sprIndex, _imgIndex, _x, _y -1);
	draw_sprite(_sprIndex, _imgIndex, _x, _y +2);
	d3d_set_fog(false, c_white, 0, 0);

#define draw_begin
	if !sign(fairy.y) fairy_draw();

#define draw
	if sign(fairy.y) fairy_draw();

#define fairy_draw
	if visible {

		var h = fairy;
		var a = .25;
		var gsize = 1/64;
		var w = sprite_get_width(h.sprite) + 12, l = sprite_get_height(h.sprite) + 16;


		d3d_set_fog(1, merge_color(h.col, c_white, clamp(h.swap / fairy_swap_time, 0, 1)), 1, 1)
		h.swap = max(0, h.swap - current_time_scale * 1.2)
		draw_sprite_ext(h.sprite_back, -1, h.x + 1, h.y + 1, w * gsize, l * gsize, 0, c_white, .4 * a);
		draw_sprite_ext(h.sprite_back, -1, h.x + 1, h.y - 1, w * gsize, l * gsize, 0, c_white, .4 * a);
		draw_sprite_ext(h.sprite_back, -1, h.x - 1, h.y + 1, w * gsize, l * gsize, 0, c_white, .4 * a);
		draw_set_blend_mode(bm_add);
		draw_sprite_ext(h.sprite_back, -1, h.x - 1, h.y - 1, w * gsize, l * gsize, 0, c_white, .4 * a);
		draw_sprite_ext(h.sprite_back, -1, h.x, h.y, w * gsize, l * gsize, 0, c_white, 1 * a)
		draw_set_blend_mode(bm_normal);
		/*
		draw_sprite_ext(h.sprite_back, -1, h.x, h.y, w * gsize * 1.3, l * gsize * 1.3, 0, c_white, .05)
		*/
		d3d_set_fog(0, 0, 0, 0)

		draw_sprite_ext(h.sprite, 0, h.x, h.y, 1, h.right, h.angle, merge_color(merge_colour(h.col, c_black, .7), c_white, clamp(fairy.swap / fairy_swap_time, 0, 1)), 1);
		if h.swapframes > 0 draw_sprite(global.sprSwapFairy, (6 - h.swapframes), h.x, h.y);
		h.swapframes = max(0, h.swapframes - current_time_scale * .5);

	}

#define player_hud(_player, _hudIndex, _hudSide)
     // Spell Bullets:

	var _x = (_hudSide ? 8 : 99),
		_w = sprite_get_width(global.spellHold) / 2,
		_y = 12+(_player.uiroll == i),
		_h = sprite_get_height(global.spellHold) / 2;

	if dev{
		draw_set_font(fntSmall);
		draw_text_nt(-13, 46, "@wRELOAD_SPEED = " + string(round(_player.reloadspeed * 100)) + "%")
		draw_text_nt(-13, 53, "@yACCURACY     = " + string(round(_player.accuracy * 100)) + "%")
		draw_text_nt(-13, 60, "@gAMMO_COST    = " + string(round(1 + _player.sage_ammo_cost) * 100) + "%")
		draw_text_nt(-13, 67, "@bPROJ_SPEED   = " + string(round(_player.sage_projectile_speed * 100)) + "%")
		draw_text_nt(-13, 74, "@pSPELL_POWER  = " + string(round((1 + _player.sage_spell_power) * 100)) + "%")
		draw_text_nt(-13, 81, "@bSPEED        = " + string(_player.maxspeed))
		draw_set_font(fntM);
	}

	for(var i = 0; i < max(array_length(_player.spellBullets), min_spellbullets); i++){

		if i < array_length(_player.spellBullets){

			var _sprt = mod_script_call("mod", bullet[? _player.spellBullets[i]].key, "bullet_sprite", _player.sage_spell_power);

			//Draw Outline for bullets in active slots:
			if i == 0 || ultra_get("sage", 2){
				draw_outline(_sprt, 0, _x, _y)
			}

			//Draw Bullet:
			draw_sprite_ext(_sprt, 0, _x, _y + 1, (_hudSide ? -1 : 1), 1, 0, c_white, 1);
			draw_sprite_ext(_sprt, 0, _x, _y, (_hudSide ? -1 : 1), 1, 0, c_white, 1);

			//Darken in secondary Slots:
			if i != 0 {

				draw_sprite_ext(_sprt, 0, _x, _y + 1, (_hudSide ? -1 : 1), 1, 0, c_black, .2);
				draw_sprite_ext(_sprt, 0, _x, _y, (_hudSide ? -1 : 1), 1, 0, c_black, .2);
			}

			if !point_in_rectangle(ceil(mouse_x[_player.index] - view_xview[_player.index]) - 16, ceil(mouse_y[_player.index] - view_yview[_player.index]), (_hudSide ? 8 : 99) - _w * 2 * (_hudSide ? -1 : 1), _y - 2 - _h, (_hudSide ? 8 : 99) + _w+ _w * 2 * array_length(_player.spellBullets) * (_hudSide ? -1 : 1), _y - 1 + _h) {

				_player.sage_uitimer = 20;
			}else {

				_player.sage_uitimer = max(_player.sage_uitimer - current_time_scale, 0);
			}

			if point_in_rectangle(mouse_x[_player.index] - view_xview[_player.index] - 16, mouse_y[_player.index] - view_yview[_player.index], _x - _w, _y - _h - 2, _x + 2, _y + _h) { //

				  if _player.sage_uitimer = 0 {

						var _name = mod_script_call("mod", bullet[? _player.spellBullets[i]].key, "bullet_name", _player.sage_spell_power),
						    _desc = mod_script_call("mod", bullet[? _player.spellBullets[i]].key, "bullet_description", _player.sage_spell_power);
						draw_set_font(fntM);
			      draw_text_nt(_x - 4 - (11 * i - i) * (_hudSide ? -1 : 1), _y + _h + 3, _name);
			      draw_set_font(fntSmall);
			      draw_text_nt(_x - 4 - (11 * i - i) * (_hudSide ? -1 : 1), _y + _h + 12, _desc);
			    }
			}

		}else{
			//Draw empty bullet spaces:
			draw_sprite_ext(global.spellHold, 0, _x, 12, (_hudSide ? -1 : 1), 1, 0, c_white, 1);
		}

		//var _c = make_colour_hsv(_x * 1.5 mod 255, 255, 255);
		//draw_rectangle_color(_x - _w, _y - _h - 2, _x + 2, _y + _h, _c, _c, _c, _c, true);

	    _x += _hudSide ? -10 : 10;
		_y = 12 + (_player.uiroll == i);
	}

	if (_player.uiroll < array_length(_player.spellBullets)) {

		_player.uiroll++;
	}

 // On Character's Creation (Starting a run, getting revived in co-op, etc.):
 // Thanks Brokin

#macro bullet mod_variable_get("mod", "SageBullets", "BulletDirectory")
#macro min_spellbullets 2 + skill_get(5)
#macro fairy_swap_time 6
#macro dev true
#macro c_darkteal c_purple
#macro c_purblue c_purple
#macro speed_boost_perma [Rocket, Nuke, PlasmaBall, PlasmaBig, PlasmaHuge, Seeker]

#define create
	uiroll = 0;

	sage_projectile_speed = 1; // Projectile speed multiplier
	sage_spell_power = 0;      // Sage spellpower multiplier
	sage_ammo_cost = 0; 	     // ammo cost multiplier
	sage_ammo_to_rads = 0;     // ammo to rad bool
	sage_uitimer = 20; // how long to wait on mouse hover before the draw
	spellBullets = [];

	if !dev {

		array_push(spellBullets, bullet[? "bDefault"].key);
	}else {

		array_push(spellBullets, bullet[? "bDefault"].key);
		array_push(spellBullets, bullet[? "bGold"].key);
		array_push(spellBullets, bullet[? "bMelee"].key);
		array_push(spellBullets, bullet[? "bTurret"].key);
		array_push(spellBullets, bullet[? "bInfammo"].key);
		array_push(spellBullets, bullet[? "bPrecision"].key);
		array_push(spellBullets, bullet[? "bReflective"].key);
		array_push(spellBullets, bullet[? "bWarp"].key);
		array_push(spellBullets, bullet[? "bBurst"].key);
		array_push(spellBullets, bullet[? "bSplit"].key);
		array_push(spellBullets, bullet[? "bUltra"].key);
	}

	fairy = {

			creator : self,
			swap : 0,
	    gx : x,
	    gy : y,
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
	    col : c_purblue,
	    sprite : sprSnowFlake,
	    angle : 0
	}

	footkind = 0;

	if instance_is(self, Player) stat_gain(spellBullets[0], self); // This check resolves an error with yokins cheat mod

	assign_sprites();
	assign_sounds();

 // Every Frame While Character Exists:
#define step
	// Fairy code;
	var h = fairy;

	h.sprite = mod_script_call("mod", bullet[? spellBullets[0]].key, "fairy_sprite", sage_spell_power);
	h.col = mod_script_call("mod", bullet[? spellBullets[0]].key, "fairy_color", sage_spell_power);

	if h.resettime <= 0{
			h.x += approach(h.x, h.gx, 4, current_time_scale)
			h.y += approach(h.y, h.gy, 4, current_time_scale)

			h.right = -sign(h.x - x)
			h.angle = 90 - (90 * h.right)

			//h.col = merge_colour(c_purblue, c_black, .7)

			h.gx = x + (h.xoff - 10) * right
			h.gy = y + h.yoff - 16

			if random(100) < 2 * current_time_scale{
					h.dir = random(360)
					h.move = irandom_range(4, 10)
					h.spd = random(2)
					h.curve = random_range(-10, 10)
					h.curve += sign(h.curve) * 3
			}
			if h.move > 0{
					h.move -= current_time_scale
					h.xoff += lengthdir_x(h.spd*current_time_scale, h.dir)
					h.yoff += lengthdir_y(h.spd*current_time_scale, h.dir)
					h.dir += h.curve * current_time_scale
					h.curve += sign(h.curve) * current_time_scale
					if point_distance(h.xoff, h.yoff, 0, 0) > 10 {
							h.dir -= angle_approach(h.dir, point_direction(h.xoff, h.yoff, 0, 0), 3, current_time_scale)
					}
			}
	}
	else h.resettime -= current_time_scale;

	if dev && button_pressed(0, "horn"){
		array_push(0.spellBullets, "bTurret")
		if dev trace(0.spellBullets)
	}

  if(!instance_exists(global.bind_late_step)){
      global.bind_late_step = script_bind_step(late_step, 0);
  }

	///  ACTIVE : Swap Spells  \\\

	// Player effects:
	if(canspec && button_pressed(index, "spec") && array_length(spellBullets) > 1){

		fairy.swap = fairy_swap_time + 2;
		fairy.swapframes = 6;

		for (var _i = 0; _i < 1 + ultra_get("sage", 2); _i++) {

			mod_script_call("mod", bullet[? spellBullets[1]].key, "bullet_swap", sage_spell_power);
		}

		var _temp = spellBullets[0];
		if(!ultra_get("sage", 2)){
			stat_lose(spellBullets[0], self);
			stat_gain(spellBullets[1], self);
		}
		for(var i = 1; i < array_length(spellBullets); i++) {

			spellBullets[i-1] = spellBullets[i];
		}
		spellBullets[array_length(spellBullets) - 1] = _temp;
		uiroll = 0;
	}
	///  PASSIVE : Spawn Spellbullets on weapon chest open \\\
	with(WeaponChest){
		if(fork()){
			var _x = x;
			var _y = y;
			wait(0);
			if(!instance_exists(self)){
				wait(0);
				//the player is passed in as an optional variable specifically for ""
				//it makes it so the player gets spellbullets they don't have already from normal chests
				spellbullet_create(_x,_y, "", other);
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
				spellbullet_create(_x,_y, item[? "bGold"]);
			}
			exit;
		}
	}
	with(ProtoChest){
		if(fork()){
			var _x = x;
			var _y = y;
			wait(0);
			if(!instance_exists(self)){
				wait(0);
				spellbullet_create(_x,_y, item[? "bUltra"]);
			}
			exit;
		}
	}
	with(BigWeaponChest){
		if(fork()){
			var _x = x;
			var _y = y;
			wait(0);
			if(!instance_exists(self)){
				wait(0);
				repeat(2) spellbullet_create(_x,_y, item[? choose("bSplit", "bReflective", "bPrecision", "bWarp", "bHaste", "bBurst", "bGold")]);
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
				repeat(12) spellbullet_create(_x,_y, item[? choose("bSplit", "bReflective", "bPrecision", "bWarp", "bHaste", "bBurst", "bGold")]);
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
				repeat(2) spellbullet_create(_x,_y,  item[? choose("bSplit", "bReflective", "bPrecision", "bWarp", "bHaste", "bBurst", "bGold")]);
			}
			exit;
		}
	}

	var sageEffectNum = (ultra_get("sage", 2) ? array_length(other.spellBullets) : 1);

	with instances_matching(projectile, "creator", self) {

		if "sage_speed" not in self {

			sage_speed = creator.sage_projectile_speed;
		}
		var _s = self;
		with speed_boost_perma {

			if instance_is(_s, self) {

				switch object_get_name(_s.object_index) {

					case "Seeker":
						var _n = _s.speed > .1 ? 1 : 0;
						_s.x += lengthdir_x(speed * (_s.sage_speed - 1), direction) / 1.5 * _n;
						_s.y += lengthdir_y(speed * (_s.sage_speed - 1), direction) / 1.5 * _n;
						break;
					default:
						_s.x += lengthdir_x(speed * (_s.sage_speed - 1), direction);
						_s.y += lengthdir_y(speed * (_s.sage_speed - 1), direction);
						break;
				}
			}
		}
	}

	with(instances_matching_ne(instances_matching(projectile, "creator", self), "sageCheck", sageEffectNum)) {
		if("sageCheck" not in self){sageCheck = 0}

		// Increase speed and maxspeed with projectile speed stat:
		speed *= creator.sage_projectile_speed;

		// two vars for better mod compat
		if "maxspeed" in self{
			maxspeed *= creator.sage_projectile_speed;
		}
		if "max_speed" in self{
			max_speed *= creator.sage_projectile_speed;
		}

		// this makes shells not godawful with low projectile speed
		if friction > 0{
			friction *= power(creator.sage_projectile_speed, 1.25);
		}

		for(var i = sageCheck; i < sageEffectNum; i++){
			if(!instance_exists(self)){break}

			sageCheck = i + 1;

			/*switch(other.spellBullets[i]){

				case "precision":

					/*if(skill_get(mut_throne_butt) && instance_exists(enemy)){
						var _e = instance_nearest(x+lengthdir_x(5, direction), y+lengthdir_y(5, direction), enemy);
						var _e2 = instance_nearest(x+lengthdir_x(15, direction), y+lengthdir_y(15, direction), enemy);
						if(abs(angle_difference(point_direction(x,y,_e.x,_e.y), direction)) < 45){
							direction = point_direction(x,y,_e.x,_e.y);
							image_angle = direction;
						}else if(abs(angle_difference(point_direction(x,y,_e2.x,_e2.y), direction)) < 45){
							direction = point_direction(x,y,_e2.x,_e2.y);
							image_angle = direction;
						}else{
							direction = other.gunangle + random(5)-2.5;
							image_angle = direction;
						}
					}else{
						direction = other.gunangle + random(5)-2.5;
						image_angle = direction;
					}
					break;
			}*/
		}
	}

#define fire()

	var _radprev = GameCont.rad;

	for (var _i = 0; _i < 1 + ultra_get("sage", 2); _i++) {

		mod_script_call("mod", bullet[? spellBullets[_i]].key, "on_fire", sage_spell_power);
	}
	// Custom ammo cost handling:
	if infammo = 0 {

	  var _t = min(sage_ammo_to_rads, 1) * (weapon_get_type(wep) = 1 ? 4 : 16) * ceil(1 + sage_ammo_cost) * weapon_get_cost(wep),
		    _a = 1;
		if GameCont.rad < _t || !sage_ammo_to_rads {

			_a = 0;
		}

		var _acost = _a * -weapon_get_cost(wep) + weapon_get_cost(wep) * ceil(sage_ammo_cost),
		    _rcost = max(GameCont.rad - weapon_get_rads(wep) * ceil(sage_ammo_cost) - _t, 0);

		// Split extra cost handling:
		if( "sage_projectiles" in self && _acost * sage_projectiles > ammo[weapon_get_type(wep)] && _rcost * sage_projectiles > GameCont.rads) {


			sound_play(sndEmpty);
			with instance_create(x, y, PopupText) {

				ammo[weapon_get_type(wep)] += _acost;
				mytext = "NOT ENOUGH AMMO";
			}
		}else {

			ammo[weapon_get_type(wep)] -= _acost;
			GameCont.rad = _rcost;
		}
	}

	if (GameCont.rad < _radprev) {

		for (var _i = 0; _i < 1 + ultra_get("sage", 2); _i++) {

			mod_script_call("mod", bullet[? spellBullets[_i]].key, "on_rads_use", sage_spell_power);
		}
	}

	if (GameCont.rad <= 0 && _radprev > 0) {

		for (var _i = 0; _i < 1 + ultra_get("sage", 2); _i++) {

			mod_script_call("mod", bullet[? spellBullets[_i]].key, "on_rads_out", sage_spell_power);
		}
	}

	// Player doesnt have enough ammo:
	/*if (weapon_get_cost(wep) * ceil(sage_ammo_cost + 1) * (_size) > ammo[weapon_get_type(wep)]){
		weapon_post(-5, 0, 0);
		sound_play(sndEmpty);
		with instance_create(x, y, PopupText){
			mytext = "NOT ENOUGH AMMO"
		}
	}else{
	}*/

#define stat_gain(spellbullet, inst)
	with inst mod_script_call("mod", spellbullet, "on_take", sage_spell_power);
	if dev trace("STAT GAINED")

#define stat_lose(spellbullet, inst)
	with inst mod_script_call("mod", spellbullet, "on_lose", sage_spell_power);
	if dev trace("STAT LOST")

#define spellpower_change(spellbullet, inst, spellpower)
	stat_lose(spellbullet, inst);
	if ultra_get("sage", 1) > 0 && array_length(spellbullet) > 1{stat_lose(spellbullet, inst)}
	inst.sage_spell_power += spellpower;
	stat_gain(spellbullet, inst);
	if ultra_get("sage", 1) > 0 && array_length(spellbullet) > 1{stat_gain(spellbullet, inst)}

#define spellbullet_create
  var 	 _x = argument[0],
    		 _y = argument[1],
	    _type = argument[2];

	with(instance_create(_x,_y,CustomObject)){

		sprite_index = mskNone;
		mask_index   = mskBandit;
		image_speed  = 0;
		speed    = 5;
		friction = 0.5;
		shine = 45;

		direction = random(360);
		image_angle = direction;

		on_step = spellbullet_step;
		on_pick = script_ref_create(spellbullet_pickup);

		if(_type == ""){
			type = "bDefault"

			droplist = ds_list_create();
			ds_list_add(droplist, "bSplit", "bReflective", "bPrecision", "bWarp", "bBurst", "bTurret", "bMelee");
			ds_list_shuffle(droplist);

			if argument_count > 3 && instance_exists(argument[3]) for (var _i = 0; _i < ds_list_size(droplist) - 1; _i++){

				for (var _j = 0; _j < array_length(argument[3].spellBullets); _i++){
					if argument[3].spellBullets[_j] = droplist[| _i]{
						continue;
					}else{
						type = droplist[| _i];
						break;
					}
				}
				if type != "bDefault"{
					break;
				}
			}
			ds_list_destroy(droplist);
		}else{
			type = _type
		}

		if dev trace(type, bullet[? type])
		my_prompt = prompt_create(bullet[? type].name);
		sprite_index = bullet[? type].spr_index;
		image_index = 0;
	}

#define spellbullet_examine(name, inst)
	switch(name){
		case "cursed":
			return `@(color:${c_neutral})+@(color:${c_spellpower})RANDOM @wEFFECTS`
	}

#define spellbullet_step
	if(distance_to_object(Wall) < 1){
		move_bounce_solid(false);
	}

	shine -= current_time_scale;
	if (shine <= 0) {

		image_speed = .4;
	}
	if (image_index >= 6) {

		image_speed = 0;
		image_index = 0;
		shine = 45;
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
			array_push(global.carryOver, type);
			instance_destroy();
		}
	}

#define spellbullet_pickup(index, spellbullet, prompt)
	with(player_find(index)) {

		if(race == "sage") {

			if array_length(spellBullets) = 0 { // Gain stats when you have no bullets:
					stat_gain(spellbullet.type, self)
			}

			if(array_length(spellBullets) < 2 + skill_get(5)) {

				array_push(spellBullets, spellbullet.type);
				uiroll = 0;
			}else {

				var temp = spellBullets[0];
				if array_length(spellBullets) >= (2 + skill_get(5)) { // Gain the stats if you have all slots filled:

					stat_lose(spellBullets[0], self)
					stat_gain(spellbullet.type, self)
				}

				spellbullet.name = bullet[? spellBullets[0]].key
				spellbullet.sprite_index = bullet[? spellBullets[0]].spr_index
				spellBullets[0] = spellbullet.type;
				spellbullet.type = temp;
				spellbullet.my_prompt.text = bullet[? temp].name;
				spellbullet.friction = 0.1;
				spellbullet.direction = random(360);
				image_angle = direction;
				uiroll = 0;
				return;
			}
		}
	}
	instance_destroy();

 // Name:

#define race_name
	return "SAGE";

 // Description:
#define race_text
	return "GETS @pSPELL BULLETS@s#@wSWAP @pSPELLS@s";


 // Starting Weapon:
#define race_swep
	return 1; // Revolver


 // Throne Butt Description:
#define race_tb_text
	return "EXTRA @pSPELL BULLET@s SLOT"


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
		case 1: return "SPELLS BECOME @sA LOT MORE POWERFUL@s";
		case 2: return "SPELLS @wCOMBINE@s";
		/// Add more cases if you have more ultras!
	}


 // On Taking An Ultra:
#define race_ultra_take
	switch(argument0){
		 // Play Ultra Sounds:
		case 1:
			sound_play(sndFishUltraA);
			with instances_matching(Player, "race", "sage"){
				spellpower_change(spellBullets[0], self, 1);
			}
		break;
		case 2:
			sound_play(sndFishUltraB);
			with instances_matching(Player, "race", "sage") for(i = 1; i < array_length(spellBullets); i++) {
				stat_gain(spellBullets[i], self);
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
	var tips = ["A NEW WORLD", "WHERE WERE WE?", "FASCINATING @wWEAPONRY@s"];

	if !irandom(1) array_push(tips, "SAGE CAN DO COOL TRICKS")

	if instance_exists(GameCont){
	    if GameCont.loops > 0 array_push(tips, "IT ALL REVOLVES AROUND")
	    if GameCont.area == 103 array_push(tips, "NO, THIS ISN'T IT")
	    if GameCont.area == 104 array_push(tips, "SO THIS IS WHERE @pIT@s COMES FROM")
	}

	return tips[irandom(array_length(tips) - 1)]

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
	snd_wrld = sndMutant1Wrld;	// FLÄSHYN
	snd_hurt = sndMutant1Hurt;	// THE WIND HURTS
	snd_dead = sndMutant1Dead;	// THE STRUGGLE CONTINUES
	snd_lowa = sndMutant1LowA;	// ALWAYS KEEP ONE EYE ON YOUR AMMO
	snd_lowh = sndMutant1LowH;	// THIS ISN'T GOING TO END WELL
	snd_chst = sndMutant1Chst;	// TRY NOT OPENING WEAPON CHESTS
	snd_valt = sndMutant1Valt;	// AWWW YES
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
		name	   = "Prompt"
		mask_index = mskWepPickup;
		persistent = true;
		creator    = noone;
		nearwep    = noone;
		depth      = 0; // Priority (0==WepPickup)
		pick       = -1;
		xoff       = 0;
		yoff       = 0;

		 // Events:
		on_meet = null;

		on_begin_step = Prompt_begin_step;
		on_end_step = Prompt_end_step;
		on_cleanup = Prompt_cleanup;

		return self;
	}

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
	//Note: This code IS basically just taken from TE, but it means that it works alongside TE prompts.
	var _inst = instances_matching(CustomObject, "name", "Prompt");
	if(array_length(_inst)){
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
								with(_id){
									nearwep = _nearest.nearwep;
									if(button_pressed(index, "pick")){
										_nearest.pick = index;
										if(instance_exists(_nearest.creator) && "on_pick" in _nearest.creator){
											with(_nearest.creator){
												if dev trace(type)
												script_ref_call(on_pick, _id.index, _nearest.creator, _nearest);
											}
										}
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


#define run_hitscan(_proj, _mod)
	with(_proj){
		var size = 0.8;
		repeat(_mod){
			if(!instance_exists(self)){continue;}
			event_perform(ev_step, ev_step_begin);
			if(!instance_exists(self)){continue;}
			mod_script_call("mod", "SageMod", "step");
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
			if("sage_bounce" in self && skill_get(mut_throne_butt) && sage_bounce > 0){
				_obj = mod_script_call("mod", "SageMod", "hitbounce", self, 16);
			}
			if(!instance_exists(self)){continue;}
			xprevious = x;
			yprevious = y;
			x += hspeed_raw;
			y += vspeed_raw;
			if(!instance_exists(self)){continue;}
			mod_script_call("mod", "SageMod", "bounce", self);
			if(!instance_exists(self)){continue;}
			var _inst = instances_meeting(x, y, [projectile, hitme, Wall]);
			with(_inst){
				if(!instance_exists(_proj)){continue;}
				if("nexthurt" in self){nexthurt -= current_time_scale;}
				with(_proj){
					event_perform(ev_collision, other.object_index);
					if(!instance_exists(self)){
						if("sage_bounce" in self && skill_get(mut_throne_butt) && sage_bounce > 0){
							 // Anti-Duplicate Insurance:
							if(_obj != noone && is_array(_obj)){
								with(instance_create(0, 0, CustomObject)){
									list        = [_obj];
									mod_script_call("mod", "SageMod", "hitbounce_check_end_step");
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
			if("sage_bounce" in self && skill_get(mut_throne_butt) && sage_bounce > 0){
				 // Anti-Duplicate Insurance:
				if(_obj != noone && is_array(_obj)){
					with(instance_create(0, 0, CustomObject)){
						list        = [_obj];
						mod_script_call("mod", "SageMod", "hitbounce_check_end_step");
					}
				}
			}
			if(!instance_exists(self)){continue;}
			size += 0.2/_mod
		}
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

#define approach(a, b, n, dn)
	return (b - a) * (1 - power((n - 1)/n, dn))

#define angle_approach(a, b, n, dn)
	return angle_difference(a, b) * (1 - power((n - 1)/n, dn))

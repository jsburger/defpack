#define init

	/*
	File Format Overview (WIP)
	Init
		Sprite/Mask adding
		Create Globals, Charge and Abris Color permission registry

	Macros
	Init Relevant Functions (sprite_add_p)
	Cleanup
	Chat Commands
	Drawing
		draw_dark (Crystal Torch, Lightning Bolts, Mega Lightning Bullets)
		draw_gui
			Sniper cursors
			Charge Indicators
		draw_pause (sets Stopwatch variables)
		draw_bloom
			defbloom handling
			Misc bloom (Marker, Vector Cannon)
		draw_shadows (Smarter Gun shadows)

	Game_Start
	Step

	Helper Functions
		drone_shadow (draws smarter gun shadows)
		soda_add soda_get (soda api)
		instance_in type functions
		various homing scripts (instance_nearest_matching_ne)
		object_get_mouse
		...
	*/


	var i = "../sprites/projectiles/";
	global.spr = {};

	//Sprites, sorted by ammo type, misc at the bottom
	with spr {
		msk = {};
		snd = {};

		//Horror Bullets
		GammaBullet         = sprite_add(i + "iris/horror/sprGammaBullet.png",    2, 8, 8);
		GammaBulletHit      = sprite_add(i + "iris/horror/sprGammaBulletHit.png", 4, 8, 8);
		HeavyGammaBullet    = sprite_add(i + "iris/horror/sprHeavyGammaBullet.png",    2, 12, 12);
		HeavyGammaBulletHit = sprite_add(i + "iris/horror/sprHeavyGammaBulletHit.png", 4, 12, 12);
		GammaBulletBounce   = sprite_add(i + "iris/horror/sprGammaBulletBounce.png", 2, 6, 8);
		HeavyGammaBulletBounce = sprite_add(i + "iris/horror/sprHeavyGammaBulletBounce.png", 2, 9, 13);

		//Fire Bullets
		FireBullet         = sprite_add(i + "iris/fire/sprFireBullet.png",    3, 8, 8);
		FireBulletHit      = sprite_add(i + "iris/fire/sprFireBulletHit.png", 4, 8, 8);
		HeavyFireBullet    = sprite_add(i + "iris/fire/sprHeavyFireBullet.png",    3, 12, 12);
		HeavyFireBulletHit = sprite_add(i + "iris/fire/sprHeavyFireBulletHit.png", 4, 12, 12);
		FireBulletBounce   = sprite_add(i + "iris/fire/sprFireBulletBounce.png", 3, 6, 8);
		HeavyFireBulletBounce = sprite_add(i + "iris/fire/sprHeavyFireBulletBounce.png", 3, 9, 13);

		//Bouncers
		HeavyBouncerBullet = sprite_add(i + "iris/bouncer/sprHeavyBouncerBullet.png", 2, 12, 12);

		//Toxic Bullets
		ToxicBullet         = sprite_add(i + "iris/pest/sprPestBullet.png",    2, 8, 8);
		ToxicBulletHit      = sprite_add(i + "iris/pest/sprPestBulletHit.png", 4, 8, 8);
		HeavyToxicBullet    = sprite_add(i + "iris/pest/sprHeavyPestBullet.png",    2, 12, 12);
		HeavyToxicBulletHit = sprite_add(i + "iris/pest/sprHeavyPestBulletHit.png", 4, 12, 12);
		ToxicBulletBounce   = sprite_add(i + "iris/pest/sprPestBulletBounce.png", 2, 6, 8);
		HeavyToxicBulletBounce = sprite_add(i + "iris/pest/sprHeavyPestBulletBounce.png", 2, 9, 13);


		//Lightning Bullets
		LightningBullet         = sprite_add(i + "iris/thunder/sprThunderBullet.png",    2, 8, 8);
		LightningBulletUpg      = sprite_add(i + "iris/thunder/sprThunderBulletUpg.png", 2, 8, 8);
		LightningBulletHit      = sprite_add(i + "iris/thunder/sprThunderBulletHit.png", 4, 8, 8);
		HeavyLightningBullet    = sprite_add(i + "iris/thunder/sprHeavyThunderBullet.png",    2, 12, 12);
		HeavyLightningBulletUpg = sprite_add(i + "iris/thunder/sprHeavyThunderBulletUpg.png", 2, 12, 12);
		HeavyLightningBulletHit = sprite_add(i + "iris/thunder/sprHeavyThunderBulletHit.png", 4, 12, 12);
		LightningBulletBounce   = sprite_add(i + "iris/thunder/sprThunderBulletBounce.png", 2, 6, 8);
		LightningBulletBounceUpg   = sprite_add(i + "iris/thunder/sprThunderBulletUpgBounce.png", 2, 6, 8);
		HeavyLightningBulletBounce = sprite_add(i + "iris/thunder/sprHeavyThunderBulletBounce.png", 2, 9, 13);
		HeavyLightningBulletUpgBounce = sprite_add(i + "iris/thunder/sprHeavyThunderBulletUpgBounce.png", 2, 9, 13);

		//Psy Bullets
		PsyBullet         = sprite_add  (i + "iris/psy/sprPsyBullet.png",    2, 8, 8);
		PsyBulletHit      = sprite_add  (i + "iris/psy/sprPsyBulletHit.png", 4, 8, 8);
		msk.PsyBullet     = sprite_add_p(i + "iris/psy/mskPsyBullet.png",    0, 7, 3);
		HeavyPsyBullet    = sprite_add  (i + "iris/psy/sprHeavyPsyBullet.png",    2, 12, 12);
		HeavyPsyBulletHit = sprite_add  (i + "iris/psy/sprHeavyPsyBulletHit.png", 4, 12, 12);
		PsyBulletBounce   = sprite_add(i + "iris/psy/sprPsyBulletBounce.png", 2, 6, 8);
		HeavyPsyBulletBounce = sprite_add(i + "iris/psy/sprHeavyPsyBulletBounce.png", 2, 9, 13);


		//Dark Bullets
		DarkBullet     = sprite_add  (i + "sprBlackBullet.png",    2, 8, 8);
		DarkBulletHit  = sprite_add  (i + "sprBlackBulletHit.png", 4, 8, 8);
		msk.DarkBullet = sprite_add_p(i + "mskBlackBullet.png",    0, 3, 5);
		DarkBulletBounce = sprite_add(i + "sprBlackBulletBounce.png", 2, 8, 8);

		//Light Bullets
		LightBullet    = sprite_add(i + "sprWhiteBullet.png",    2, 8, 8);
		LightBulletHit = sprite_add(i + "sprWhiteBulletHit.png", 4, 8, 8);
		LightBulletBounce = sprite_add(i + "sprWhiteBulletBounce.png", 2, 8, 8);

		//Iris Casings
		GenShell      = sprite_add("../sprites/other/sprGenShell.png",   8, 2, 2);
		GenShellLong  = sprite_add("../sprites/other/sprGenShellL.png",  8, 2, 3);
		GenShellHeavy = sprite_add("../sprites/other/sprGenShellH.png",  8, 2, 3);
		GenShellBig   = sprite_add("../sprites/other/sprGenShellXL.png", 8, 2, 3);

		//Psy Shells
		PsyPellet          = sprite_add(i + "sprPsyShell.png", 2, 8, 8);
		PsyPelletDisappear = sprite_add(i + "sprPsyShellDisappear.png", 5, 8, 8);

		//Toxic Shells?
		ToxicShell          = sprite_add(i + "iris/pest/sprPestShell.png", 2, 8, 8);
		ToxicShellHit       = sprite_add(i + "iris/pest/sprPestShellDisappear.png", 4, 8, 8);

		//Split Shells
		SplitShell               = sprite_add(i + "sprSplitShell.png",          2, 8, 8);
		SplitShellDisappear      = sprite_add(i + "sprSplitShellDisappear.png", 5, 8, 8);
		HeavySplitShell          = sprite_add(i + "sprSplitSlug.png",           2, 9, 9);
		HeavySplitShellDisappear = sprite_add(i + "sprSplitSlugDisappear.png",  5, 9, 8);

		//Sonic Explosions
		SonicExplosion          = sprite_add(  i + "sprSonicExplosion.png", 8, 61, 59);
		SmallSonicExplosion     = sprite_add(  i + "sprSonicExplosionSmall.png", 8, 20, 20);
		msk.SonicExplosion      = sprite_add_p(i + "mskSonicExplosion.png", 8, 61, 59);
		msk.SmallSonicExplosion = sprite_add_p(i + "mskSonicExplosionSmall.png", 8, 20, 20);
		SonicStreak             = sprite_add(i + "sprSonicStreak.png",7, 24, 8);
		snd.SonicExplosion 		  = sound_add("../sounds/sndSonicExplosion.ogg");

		//Abris Stripes
		Stripes = sprite_add("../sprites/other/sprBigStripes.png", 1, 1, 1);

		//Plasmites
		Plasmite    		  = sprite_add(i + "sprPlasmite.png",    0, 3, 3);
		PlasmiteUpg 		  = sprite_add(i + "sprPlasmiteUpg.png", 0, 3, 3);
		PlasmaImpactSmall     = sprite_add(i + "sprPlasmaImpactSmall.png", 7, 8, 8);
		msk.PlasmaImpactSmall = sprite_add_p(i + "mskPlasmaImpactSmall.png", 7, 8, 8);

		//Squares
		Square     = sprite_add  (i + "sprSquare.png", 0, 7, 7);
		msk.Square = sprite_add_p(i + "mskSquare.png", 0, 5, 5);

		SuperSquare     = sprite_add  (i + "sprSuperSquare.png", 0, 14, 14);
		msk.SuperSquare = sprite_add_p(i + "mskSuperSquare.png", 0, 10, 10);

		//Triangles
		Triangle = sprite_add(i + "sprTriangle.png", 0, 7, 7);

		//Laser Flaks
		LaserFlakBullet = sprite_add(i + "sprLaserFlak.png", 2, 8, 8);

		//Vectors
		VectorHead   		 = sprite_add(i + "sprVectorHead.png", 1, 8, 2);
		Vector	     		 = sprite_add(i + "sprVector.png", 1, 0, 3);
		VectorImpact 		 = sprite_add(i + "sprVectorImpact.png", 14, 20, 20);
		msk.VectorImpact = sprite_add(i + "mskVectorImpact.png", 14, 20, 20);
		VectorEffect 		 = sprite_add(i + "sprVectorBeamEnd.png", 5, 5, 5);

		//Spike Balls
		MiniSpikeball      = sprite_add  (i + "sprMiniSpikeball.png", 0, 6, 5);
		msk.MiniSpikeball  = sprite_add_p(i + "mskMiniSpikeball.png", 0, 6, 5);
		Spikeball          = sprite_add  (i + "sprSpikeball.png", 0, 11, 9);
		msk.Spikeball      = sprite_add_p(i + "mskSpikeball.png", 0, 11, 9);
		HeavySpikeball     = sprite_add  (i + "sprHeavySpikeball.png", 0, 15, 15);
		msk.HeavySpikeball = sprite_add_p(i + "mskHeavySpikeball.png", 0, 15, 15);

		//Discs
		BouncerDisc      = sprite_add  (i + "sprBouncerDisc.png", 2,  6,  6);
		StickyDisc       = sprite_add  (i + "sprStickyDisc.png",  2,  7,  6);
		MegaDisc         = sprite_add_p(i + "sprMegaDisc.png"      , 2, 12, 12);
		MegaDiscHitId    = sprite_add_p(i + "sprMegaDiscHitId.png" , 2, 12, 12);
		MegaDiscDie      = sprite_add  (i + "sprMegaDiscDie.png"   , 6, 12, 12);
		MegaDiscTrail    = sprite_add  (i + "sprMegaDiscTrail.png" , 3, 12, 12);
		MegaDiscBounce   = sprite_add  (i + "sprMegaDiscBounce.png", 4, 12, 12);
		MegaDiscSplat[0] = sprite_add  (i + "sprMegaDiscSplat1.png", 1, 12, 12);
		MegaDiscSplat[1] = sprite_add  (i + "sprMegaDiscSplat2.png", 1, 12, 12);
		MegaDiscSplat[2] = sprite_add  (i + "sprMegaDiscSplat3.png", 1, 12, 12);
		MegaDiscSplat[3] = sprite_add  (i + "sprMegaDiscSplat4.png", 1, 12, 12);
		MegaDiscSplat[4] = sprite_add  (i + "sprMegaDiscSplat5.png", 1, 12, 12);
		MegaDiscSplat[5] = sprite_add  (i + "sprMegaDiscSplat6.png", 1, 12, 12);
		MegaDiscSplat[6] = sprite_add  (i + "sprMegaDiscSplat7.png", 1, 12, 12);


		//Blades
		Sword       = sprite_add  (i + "sprSword.png",      1, 10, 10)
		SwordStick  = sprite_add_p(i + "sprSwordStick.png", 1, 10, 10)
		SwordImpact = sprMeleeHitWall   //sprite_add(i + "sprSwordImpact.png", 8, 16, 16)
		Knife       = sprite_add  (i + "sprKnife.png",      1, 7, 7)
		KnifeStick  = sprite_add_p(i + "sprKnifeStick.png", 1, 4, 7)
		SwordSlash  = sprite_add  (i + "sprSwordSlash.png", 5, 16, 16)

		//Flechettes
		Flechette       = sprBullet1 //sprite_add("..\sprites\projectiles\sprFlechette.png",      0,  6, 4)
		msk.Flechette   = sprBullet1 //sprite_add("..\sprites\projectiles\mskFlechette.png",      0,  6, 2)
		FlechetteBlink  = sprBullet1 //sprite_add("..\sprites\projectiles\sprFlechetteBlink.png", 3, 14, 4)

		//Fire
		GasFire = sprite_add("..\sprites\projectiles\sprGasFire.png", 6, 10, 10);

		//Quartz Shards
		Shard        = sprite_add_weapon("../sprites/weapons/sprShard.png", 0, 3);
		GlassShard   = sprite_add("../sprites/other/sprGlassShard.png", 5, 4, 4)
		QuartzPickup = sprite_add_weapon("../sprites/other/sprQuartzPickup.png", 5, 5);

		//Crits
		Killslash     = sprite_add(i + "sprKillslash.png", 8, 16, 16);
		KillslashL    = sprite_add(i + "sprKillslashL.png", 8, 24, 24);
		KillslashKill = sprite_add(i + "sprKillslashKill.png", 12, 5, 5);

		//Charge Icon
		Charge = sprite_add("../sprites/interface/sprHoldIcon.png", 1, 5, 7);

		//Sniper Sights
		Aim          = sprite_add("../sprites/interface/sprAim.png", 0, 10, 10);
		CursorCentre = sprite_add("../sprites/interface/sprCursorCentre.png", 0, 1, 1);

	}

	//Distribute sprites to other libraries (add mod name to list to expand)
	with ["defhitscan"] {
		if mod_exists("mod", self) {
			mod_variable_set("mod", self, "spr", spr)
		}
	}

	//System for letting weapons draw on the hud
	global.HUDRequests = []

	global.SAKmode = 0
	//mod_script_call("mod","defpermissions","permission_register","mod",mod_current,"SAKmode","SAK Mode")

	//Vertex format used for Lightning Bolts
	vertex_format_begin()
	vertex_format_add_position()
	global.lightningformat = vertex_format_end()

	//Config for abris colors
	global.AbrisCustomColor = false;

	//Configs for chargebars
	global.chargeType = 1
	global.chargeLocation = charge_mouse;
	//Used for sliding new charge bars into place
	global.chargeSmooth = [0, 0]

	mod_script_call("mod","defpermissions","permission_register","mod",mod_current,"AbrisCustomColor","Use Player colors for Abris weapons")

	mod_script_call_nc("mod", "defpermissions", "permission_register_options", "mod", mod_current, "chargeType", "Weapon Charge Indicators", ["Off", "Wep Specific", "Bar Only", "Arc Only"])
	mod_script_call_nc("mod", "defpermissions", "permission_register_options", "mod", mod_current, "chargeLocation", "Charge Indicator Position", ["Around Cursor", "Around Player"])

	global.sodaList = []
	game_start()
	//todo:
	//find out if bolt marrow should be split into step on bolts

#macro spr global.spr
#macro msk global.spr.msk
#macro snd global.spr.snd

//thanks yokin
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#macro prim_offset 1
#macro lasercolor 14074

#macro abris_mouse 0
#macro abris_manual 1
#macro abris_gunangle 2

#macro defcharge_bar 0
#macro defcharge_arc 1
#macro defcharge_lock 2

#macro charge_mouse 0
#macro charge_player 1

#macro default_bloom {
        xscale : 2,
        yscale : 2,
        alpha : .1
    };

//notes on excited neurons
// bullets retain their damage
// bouncers get 2 extra bounces
// base amount of bounces is 4
// bullets lose speed when transformed ( set to 11, from 16 default )
// all bullets gain 1 damage on bounce
#macro neurons skill_get("excitedneurons")

// extra speed ceil clamp
#macro defspeed_max 32

// laser brain effect is active (for toggles rather than scaling like bloom)
#macro brain_active skill_get(mut_laser_brain) > 0

#define sprite_add_d(sprite, subimages, xoffset, yoffset)
	var a = string_split(sprite, "/"),
		name = a[array_length(a) - 1],
		location = string_count("msk", name) > 0 ? msk : spr;
		name = string_replace(string_replace(string_replace(name, "msk", ""), "spr", ""), ".png", "")

		lq_set(location, name, sprite_add(sprite, subimages, xoffset, yoffset))

#define sprite_add_p(sprite, subimages, xoffset, yoffset)
	var q = sprite_add(sprite, subimages, xoffset, yoffset)
	if fork(){
		var t = sprite_get_texture(q, 0),
		    w = 150;

		while(t == sprite_get_texture(q, 0) && w-- > 0){
		    wait 0;
		}
	    sprite_collision_mask(q, 1, 1, 0, 0, 0, 0, 0, 0)
	    exit
	}
	return q

#define chat_command(cmd,arg,ind)
	if cmd = "sakcity"{
	    global.SAKmode = !global.SAKmode
	    if global.SAKmode{
	        trace_color("You just took a one way ticket to SAK CITY, BABY", c_gray)
	        trace_color("(Weapons become randomly generated shotguns)", c_gray)
	    }
	    else{
	        trace_color("Evidently the ticket wasn't one way.", c_gray)
	        trace_color("(Weapon drops are as normal)", c_gray)
	    }
	    return 1
	}

#define draw_dark()
	with Player{
	    var level = 0,blevel = 0, lv;
	    if is_object(wep) && wep.wep = "crystal torch"{
	        level = min(ceil(wep.cursecharge/10),5)
	    }
	    if is_object(bwep) && bwep.wep = "crystal torch"{
	        blevel = min(ceil(bwep.cursecharge/10),5)
	    }
	    lv = max(blevel,level)
	    if lv > 0 {
	        draw_circle_color(x, y, 180 + 20 * lv + random(5), c_gray, c_gray,0)
	        draw_circle_color(x, y, 70  + 20 * lv + random(5), c_black,c_black,0)
	    }
	}
	with instances_matching(CustomProjectile,"name","Lightning Bolt"){
		draw_circle_color(x,y,550 + random(10), c_gray,c_gray,0)
		draw_circle_color(x,y,250 + random(10), c_black,c_black,0)
	}
	with instances_matching(CustomObject,"name","Lightning Wheel"){
		draw_circle_color(x,y,32 + random(4), c_gray,c_gray,0)
		draw_circle_color(x,y,24 + random(4), c_black,c_black,0)
	}
	with instances_matching([Bolt,BoltStick],"name","marker bolt"){
		draw_circle_color(x+lengthdir_x(sprite_width/2+2,direction),y+lengthdir_y(sprite_width/2+2,direction),35 + random(3), c_gray,c_gray,0)
		draw_circle_color(x+lengthdir_x(sprite_width/2+2,direction),y+lengthdir_y(sprite_width/2+2,direction),20 + random(3), c_black,c_black,0)
	}

#define request_hud_draw(scriptRef)
	array_push(global.HUDRequests, scriptRef)

#define draw_gui

	//Take care of hud drawing requests from weapons
	for (var i = 0, l = array_length(global.HUDRequests); i < l; i++) {
		script_ref_call(global.HUDRequests[i])
	}
	//Clear out requests
	if l > 0 {
		global.HUDRequests = []
	}

	//Sniper charge stuff. Could be moved to hud requests
	var q = instances_matching(CustomObject, "parent", "SniperCharge");
	if (array_length(q) > 0) with instances_matching_gt(q, "index", -1) if player_is_local_nonsync(index) {

		var _col = player_get_color(index),
			_h = holdtime <= 60,
			_cyc = _h ? 3 : 5;

		// Flash white
		if current_frame mod _cyc < current_time_scale {
			_col = _col == c_white ? c_gray : c_white
			if _h sound_play_pitch(sndCursedReminder, 5)
		}

	    var _vpf = 3,
	    	_mx  = mouse_x_nonsync - view_xview_nonsync + 1,
	    	_my  = mouse_y_nonsync - view_yview_nonsync + 1;

	    for (var i = -1; i <= 1; i += 2) {
	        for (var o = -1; o <= 1; o += 2) {
	            draw_sprite_ext(spr.Aim, 0, _mx + (_vpf - charge + 100) * i, _my + (_vpf - charge + 100) * o, -i, -o, 0, _col, .1 + .9 * charge/maxcharge)
	        }
	    }
	    draw_sprite_ext(spr.CursorCentre, 0, _mx, _my, 1, 1, 0, _col, 1)
	}

var q = instances_matching_ne([CustomObject, CustomProjectile], "defcharge", undefined);
if global.chargeType with Player if player_is_local_nonsync(index){
    var matches = instances_matching(q, "creator", id)
    if race = "steroids" and is_object(bwep) and "defcharge" in bwep{
        array_push(matches, bwep)
    }
    if is_object(wep) and "defcharge" in wep{
        array_push(matches, wep)
    }
    if array_length(matches){
        var _chargeCounter = array_create(3)
        with matches{
            with defcharge{
                if power(charge/maxcharge, lq_defget(self, "power", 2)) >= .001{
                    var num = global.chargeType == 1 ? style : global.chargeType - 2;
                    _chargeCounter[num]++
                }
            }
        }
        var _x = mouse_x_nonsync - view_xview_nonsync, _y = mouse_y_nonsync - view_yview_nonsync + 1;
        if (global.chargeLocation == charge_player) {
        	var _p = player_find_local_nonsync();
        	if !(instance_exists(_p)) break
        	_x = _p.x - view_xview_nonsync
        	_y = _p.y - view_yview_nonsync
        }
        _y = round(_y)


        var c = player_get_color(index), _col = c;
        //counters
        var _arcCount = 0, _barCount = 0, _lockCount = 0,
        _arcMax = _chargeCounter[defcharge_arc], _barMax = _chargeCounter[defcharge_bar] + _chargeCounter[defcharge_lock];
        //smoothing
        var _scale = global.chargeSmooth, _l = array_length(_scale);
        for var i = 0; i < _l; i++{
        	var total = (i == defcharge_bar) ? _chargeCounter[defcharge_bar] + _chargeCounter[defcharge_lock] : _chargeCounter[i];
            _scale[i] += approach(_scale[i], total, 3, 30/room_speed)
        }
        //arc vars
        if _arcMax{
            var _arcPoint = 90,                              //the angle arcs are centered on
            	_arcPrecision = ceil(10/max(_arcMax/2, 1)),  //amount of segments each arc has
            	_arcThickness = 2,                           //how thick the arcs are, also affects border i think
            	_arcHeight = 2*(_arcThickness + 1) + 6,      //how far the arcs are from the cursor, its a radius
            	_arcTop = _arcThickness + _arcHeight,        //radius + thickness
            	_arcBorder = _arcTop + 2,                    //the radius the borders are drawn to
            	_arcSpan = min(360, 120 * sqrt(_scale[defcharge_arc])), //the total amount of degrees for all arcs
                _arcSpace = _arcSpan/_arcMax,                //each arc's amount of space
                _arcLength = _arcSpace - 8,                  //each arc's length in degrees, the 8 is for giving the borders space
                _arcStart = _arcPoint + (_arcSpan - _arcSpace)/2; //the right side of the first arc drawn
            draw_arc(_x, _y + 1, _arcPoint, _arcHeight - 1, _arcBorder , _arcSpan, _arcPrecision * _arcMax, c_black, 1, 1)
            draw_arc(_x, _y    , _arcPoint, _arcHeight    , _arcTop + 1, _arcSpan, _arcPrecision * _arcMax, 0, 1, 1)
        }
        //bar vars
        var _barHeight = 2, _barInc = 2 * (_barHeight + 1) * (_scale[defcharge_bar]/_barMax);
        //looping through oldest objects to newest objects
        for (var i = array_length(matches) - 1; i >= 0; i--){
            with matches[i]{
                with defcharge{
                    _col = c
                    var cm = power(charge/maxcharge, lq_defget(self, "power", 2)), b = lq_defget(self, "blinked", 0);
                    if cm < .001 continue
                    if cm >= .98 or b > 0{
                        if b < 2 and b > -1{
                            blinked = b + current_time_scale
                            _col = c_white
                        }
                        else blinked = -1
                    }
                    else blinked = 0

                    var num = global.chargeType == 1 ? style : global.chargeType - 2;
                    switch (num){
                        case defcharge_bar:
                            var _dw = lq_defget(self, "width", 12), _w = _dw/2, _yc = _y + _barInc * ++_barCount + 4
                            draw_bar(_x, _yc, _dw, _barHeight, c_white)
                            draw_line_width_color(_x - _w, _yc + .5, _x - _w + cm * _dw, _yc + .5, _barHeight, _col, _col)
                        break
                        case defcharge_lock:
                        	var _barWidth = lq_defget(self, "width", 12),
                        		_boxSize = 4,
                    			_leftEdge = _x - (_barWidth + _boxSize)/2,
                    			_boxCenter = _leftEdge + _barWidth + (_boxSize/2),
                    			_barCenter = _x - (_boxSize/2);
                			_barCount += max(_boxSize - 1, _barHeight)/_barHeight;
                			var _yCenter = _y + _barInc * _barCount + 4;

                			draw_bar(_barCenter, _yCenter, _barWidth, _barHeight, c_white)
                			draw_line_width_color(_leftEdge, _yCenter + .5, _leftEdge + _barWidth * cm, _yCenter + .5, _barHeight, _col, _col)
                			draw_bar(_boxCenter, _yCenter, _boxSize, _boxSize, c_white)
                			if (blinked > 0 || blinked == -1) {
                				draw_line_width_color(_boxCenter - _boxSize/2, _yCenter + .5, _boxCenter + _boxSize/2, _yCenter + .5, _boxSize, _col, _col)
                			}
                    	break
                        case defcharge_arc:
                            var _d = _arcStart - _arcSpace * _arcCount++
                            draw_arc(_x, _y + 1, _d + _arcLength*(1 - cm)/2, _arcHeight, _arcTop + .9, _arcLength * cm, round(_arcPrecision * cm), _col, 1, 1)
                            var _ld = _arcSpace/2 - 2
                            draw_line_width_color(_x + lengthdir_x(_arcHeight-1, _d + _ld), _y + lengthdir_y(_arcHeight-1, _d + _ld), _x + lengthdir_x(_arcBorder, _d + _ld), _y + lengthdir_y(_arcBorder, _d + _ld), 1, c_white, c_white)
                            draw_line_width_color(_x + lengthdir_x(_arcHeight-1, _d - _ld), _y + lengthdir_y(_arcHeight-1, _d - _ld), _x + lengthdir_x(_arcBorder, _d - _ld), _y + lengthdir_y(_arcBorder, _d - _ld), 1, c_white, c_white)
                        break
                    }
                }
            }
        }
        if _arcMax{
            draw_arc(_x, _y, _arcPoint, _arcHeight - 1, _arcHeight, _arcSpan, _arcPrecision * _arcMax, c_white, 1, 1)
            draw_arc(_x, _y, _arcPoint, _arcTop + 1, _arcBorder, _arcSpan, _arcPrecision * _arcMax, c_white, 1, 1)
            var _ld1 = _arcPoint - _arcSpan/2 + 2, _ld2 = _arcPoint + _arcSpan/2 - 2
            draw_line_width_color(_x + lengthdir_x(_arcHeight-1, _ld1), _y + lengthdir_y(_arcHeight-1, _ld1), _x + lengthdir_x(_arcBorder, _ld1), _y + lengthdir_y(_arcBorder, _ld1), 1, c_white, c_white)
            draw_line_width_color(_x + lengthdir_x(_arcHeight-1, _ld2), _y + lengthdir_y(_arcHeight-1, _ld2), _x + lengthdir_x(_arcBorder, _ld2), _y + lengthdir_y(_arcBorder, _ld2), 1, c_white, c_white)
        }
    }
    else global.chargeSmooth = [0, 0]
}

#define draw_pause
mod_variable_set("weapon", "stopwatch", "pausetime", 1)

#define draw_bloom
with instances_matching_ne(CustomProjectile, "defbloom", undefined) {
    draw_sprite_ext(
        lq_defget(defbloom,"sprite",sprite_index), image_index, x, y,
        defbloom.xscale * image_xscale, defbloom.yscale * image_yscale,
        lq_defget(defbloom, "angle", image_angle), image_blend, defbloom.alpha * image_alpha
    )
}
with instances_matching_ne(CustomObject, "defbloom", undefined) {
    draw_sprite_ext(
        lq_defget(defbloom,"sprite",sprite_index), image_index, x, y,
        defbloom.xscale * image_xscale, defbloom.yscale * image_yscale,
        lq_defget(defbloom, "angle", image_angle), image_blend, defbloom.alpha * image_alpha
    )
}
with instances_matching(CustomProjectile,"name","vector beam"){
  draw_sprite_ext(sprite_index, image_index, xstart, ystart, image_xscale, 1.5*image_yscale, image_angle, image_blend, 0.15 + brain_active * .05);
	if x != xstart draw_sprite_ext(spr_tail, 0, xstart, ystart, 1.5, image_yscale*1.5, image_angle, image_blend, .15 + brain_active * .05);
	if x != xstart draw_sprite_ext(spr_head, 0, x, y, image_yscale*2.5, image_yscale*2.5, image_angle-45, image_blend, .15 + brain_active * .05);
}
with instances_matching(CustomProjectile,"name","mega lightning bullet"){
  draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale+(1-image_index)*2, 2*image_yscale+(1-image_index)*2, image_angle, image_blend, 0.2+(1-image_index)*.4);
}


#define draw_shadows
with Player if visible{
    drone_shadow(wep)
    drone_shadow(bwep)
}

#define game_start
	// Finds all sodas available
	var weps = mod_get_names("weapon");
	with weps {
		if mod_script_exists("weapon", self, "soda_avail") add_soda(self)
	}
	// Cleans out sodas that aren't loaded anymore
	for (var i = 0; i < array_length(global.sodaList); i++) {
		if !mod_exists("weapon", global.sodaList[i]) {
			global.sodaList = array_delete(global.sodaList, i)
			i--
		}
	}


#define step
	// Lazy gas fire implementation
	with instances_matching(Flame, "can_ignite", true) {

		var _t = self.team;
		if place_meeting(x, y, ToxicGas) {

			with instance_nearest(x, y, ToxicGas) {

				 repeat(4) with create_gas_fire(x, y){

					 motion_add(random(360), 3 + random(2))
					 team = _t;
					 image_angle = direction;
				}

				sound_play_pitchvol(sndFireShotgun, .7  * random_range(.8, 1.2), .5);
				sound_play_pitchvol(sndBurn, random_range(.8, 1.2), .4);
				instance_destroy();
			}
		}
		if place_meeting(x, y, FrogQueenBall) {

				repeat(32) with create_gas_fire(x, y){

					motion_add(random(360), 4 + irandom(4));
					friction = random(.4)
					team = _t;
					image_angle = direction;
			}

			with instance_nearest(x, y, FrogQueenBall) {

				sound_play_pitchvol(sndDoubleFireShotgun, .7  * random_range(.8, 1.2), .5);
				sound_play_pitchvol(sndBurn, random_range(.8, 1.2), .4);
				sound_play_pitchvol(sndExplosionS, 1.2 * random_range(.8, 1.2), 1.2);
				instance_destroy();
			}
		}
	}

	// Gets rid of dummy weapons, I don't know why vanilla doesn't do this
	with instances_matching(WepPickup, "wep", 0) instance_destroy()

	with instances_matching_ne(Player, "defspeed", undefined) if array_length(defspeed) > 0 && defspeed[1] != 0{
		with instance_create(x - lengthdir_x(defspeed[0] * .5 - 12 * skill_get(13), defspeed[1]), y - lengthdir_y(defspeed[0] * .5 - 12 * skill_get(13), defspeed[1]), CustomSlash){
			mask_index = sprShank;
			sprite_index = mask_index;
			image_alpha = 0;
			depth = other.depth - 1;
			canfix = false;
			damage = 36;
			image_xscale = max(1, other.defspeed[0] / sprite_get_width(mask_index) * 2.5);
			image_yscale = 1.3;
			image_speed = .5;
			creator = other;
			team = other.team;
			motion_add(other.defspeed[1], other.defspeed[0]);
			image_angle = other.defspeed[1];

			on_hit = defspeed_hit;
		}
		if place_free(x + lengthdir_x(min(defspeed[0], defspeed_max), defspeed[1]), y + lengthdir_y(min(defspeed[0], defspeed_max), defspeed[1])) && place_free(x + lengthdir_x(min(defspeed[0], defspeed_max)/2, defspeed[1]), y + lengthdir_y(min(defspeed[0], defspeed_max)/2, defspeed[1])) && place_free(x + lengthdir_x(min(defspeed[0], defspeed_max)/6, defspeed[1]), y + lengthdir_y(min(defspeed[0], defspeed_max)/6, defspeed[1])){
			x += lengthdir_x(min(defspeed[0], defspeed_max), defspeed[1]);
			y += lengthdir_y(min(defspeed[0], defspeed_max), defspeed[1]);
			nexthurt = current_frame + 1;
			if defspeed[0] > 2 repeat(max(1, round(defspeed[0] / 8))) with instance_create(x + random_range(-1, 1) + lengthdir_x(random(defspeed[0]), defspeed[1]), y + random_range(-1, 1) + lengthdir_y(random(defspeed[0]), defspeed[1]), Dust){
				motion_add(other.defspeed[1], choose(2, 2, 3));
			}
			if defspeed[0] >= defspeed_max{
				repeat(1 + 2 * defspeed[0] / defspeed_max) instance_create(x + random_range(-3, 3) + lengthdir_x(random(min(defspeed[0], defspeed_max)), defspeed[1]), y + random_range(-3, 3) + lengthdir_y(random(min(defspeed[0], defspeed_max)), defspeed[1]), GroundFlame)
			}

		}else{
			view_shake_at(x, y, 48);
			sleep(8);
			sound_play_pitchvol(sndWallBreak, .9, 1);
			sound_play_pitchvol(sndMeleeWall, .7, 1.3);
			repeat(3){
				instance_create(x, y, Dust);
				instance_create(x, y, Debris);
			}

			with instances_matching_ne(hitme, "team", team){
				if distance_to_object(other) <= 16{
					projectile_hit(self, 10, 6, point_direction(other.x, other.y, x, y));
				}
			}

			nexthurt = current_frame + 7;

			defspeed[0] = .5;
			defspeed[1] += 180;
			with instance_create(x, y, ImpactWrists){image_speed = .7; depth = other.depth - 1}

		}

		motion_set(defspeed[1], min(defspeed[0], defspeed_max));
		defspeed[0] /= 1.33;

		if defspeed[0] <= .5 && defspeed[1] != 0{
			defspeed[0] = 0;
			defspeed[1] = 0;
			canaim++;
		}
	}

	// Hold Icons for dropped weapons
	with instances_matching_ne(WepPickup, "chargecheck", 1) {
	    chargecheck = 1
	    if weapon_get_chrg(wep) {
	        name += ` @0(${spr.Charge}:0) `//-.35
	    }
	}

	// SAK city rolls
	if global.SAKmode && mod_exists("weapon", "sak"){
	    with instances_matching(instances_matching(WepPickup, "roll", 1), "saked", undefined) {
	        saked = 1
	        wep = mod_script_call_nc("weapon", "sak", "make_gun_random")
	    }
	}

	// Give all explosions a hitid since manually setting them is stupid
	with instances_matching([Explosion, SmallExplosion, GreenExplosion, PopoExplosion], "hitid", -1) {
	    hitid = [sprite_index, string_replace(string_upper(object_get_name(object_index)), "EXPLOSION", " EXPLOSION")]
	}

	// Shot cannon epic troll transformation (why is it called flak canon?)
	with instances_matching(WepPickup, "wep", "shot cannon"){
		if "defcheck" not in self{
			defcheck = true;
			if curse && irandom(4) = 0{
				wep = "flak canon";
				curse = false;
			}
		}
	}

	// Donut Drops
	if mod_exists("weapon", "donut box") {
		with instances_matching_le(instances_matching_ne(instances_matching_ne(enemy, "freeze", null), "object_index", Grunt), "my_health", 0) {
			if !irandom(97) {
				with instance_create(x, y, WepPickup) {
					wep = "donut box"
				}
			}
		}
	}

	// Soda Drops
	if array_length(global.sodaList) > 0 {
		with SodaMachine {
			if fork(){
			    var _x = x, _y = y;
			    wait(0)
			    if !instance_exists(self) && !instance_exists(GenCont){
		    		with instance_create(_x, _y, WepPickup){
		    		    if !irandom(99) and mod_exists("weapon", "soda popper") wep = "soda popper"
		    		    else wep = soda_get()
		    		}
		    	}
		    	exit
			}
		}
	}


	// Custom pickup stuff
	with instances_matching(Player, "race", "eyes") {
		if (canspec && button_check(index, "spec")) {
			var _vx = view_xview[index],
				_vy = view_yview[index];
			with instances_in_bbox(_vx, _vy, _vx + game_width, _vy + game_height, instances_matching(Pickup, "name", "QuartzPickup")) {
				var l = (1 + skill_get(mut_throne_butt)) * current_time_scale,
					d = point_direction(x, y, other.x, other.y),
					_x = x + lengthdir_x(l, d),
					_y = y + lengthdir_y(l, d);

					if(place_free(_x, y)) x = _x;
					if(place_free(x, _y)) y = _y;
			}
		}
	}

	// Pickup step
	with instances_matching(Pickup, "name", "QuartzPickup"){
		//Collision
		if(mask_index == mskPickup && place_meeting(x, y, Pickup)) {
			with(instances_meeting(x, y, instances_matching(Pickup, "mask_index", mskPickup))) {
				if(place_meeting(x, y, other)) {
					if(object_index == AmmoPickup || object_index == HPPickup || object_index == RoguePickup) {
						motion_add_ct(point_direction(other.x, other.y, x, y) + random_range(-10, 10), 0.8);
					}
					with(other) {
						motion_add_ct(point_direction(other.x, other.y, x, y) + random_range(-10, 10), 0.8);
					}
				}
			}
		}

		if place_meeting(x + hspeed, y + vspeed, Wall){move_bounce_solid(false)}

		// Animations
		if anim > 0
			anim -= current_time_scale
		else {
			if image_index = 0 && image_speed = .5 {
				image_speed = 0
				anim = 70 + irandom(20)
			}
			else{image_speed = .5}
		}

		// Close range attraction
		if distance_to_object(Player) <= (20 + 12 * skill_get(mut_plutonium_hunger)) || instance_exists(Portal) motion_set(point_direction(x, y, Player.x, Player.y), 4 + instance_exists(Portal) * 2)

		// Get picked up
		if place_meeting(x, y, Player) || place_meeting(x, y, PortalShock) || instance_exists(BigPortal) {
			 // run open code
			script_execute(on_pickup)

			 // fx
			instance_create(x, y,SmallChestPickup)
			instance_delete(id);
			exit;
		}

		// Blink
		if lifetime <= room_speed * 3 {
			if current_frame mod 2 < current_time_scale
				image_alpha++;
			if image_alpha > 1
				image_alpha = 0
		}

		// Disappear after a while
		if lifetime > 0 {lifetime -= current_time_scale} else{sound_play_pitch(sndPickupDisappear, random_range(.8, 1.2)); instance_create(x, y,SmallChestFade); instance_destroy()}
	}

#define drone_shadow(w)
if !is_object(w) exit
if lq_defget(w, "is_drone", 0){
    draw_sprite(shd16, 0, w.x, w.y + 12)
}

#define add_soda(soda)
var found = false;
with global.sodaList {
	if self = soda {
		found = true
		break
	}
}
if !found array_push(global.sodaList, soda)

#define soda_get()
var available = [], q;
with global.sodaList {
	q = mod_script_call("weapon", self, "soda_avail");
	if q == undefined or q {
		array_push(available, self)
	}
}
if array_length(available) > 0 {
	return available[irandom(array_length(available)-1)]
}
return wep_screwdriver

#define instances_in(left,top,right,bottom,obj)
return instances_matching_gt(instances_matching_lt(instances_matching_gt(instances_matching_lt(obj,"y",bottom),"y",top),"x",right),"x",left)

#define instances_in_bbox(left,top,right,bottom,obj)
return instances_matching_gt(instances_matching_lt(instances_matching_gt(instances_matching_lt(obj,"bbox_top",bottom),"bbox_bottom",top),"bbox_left",right),"bbox_right",left)

#define instances_seen_nonsync(obj)
return instances_in_bbox(view_xview_nonsync,view_yview_nonsync,view_xview_nonsync+game_width,view_yview_nonsync+game_height, obj)

#define instance_nearest_matching_ne(_x,_y,obj,varname,value)
var num = instance_number(obj),
    man = instance_nearest(_x,_y,obj),
    mans = [],
    n = 0,
    found = -4;
if instance_exists(obj){
    while ++n <= num && variable_instance_get(man,varname) = value || (instance_is(man,prop) && !instance_is(man,Generator)){
        man.x += 10000
        array_push(mans,man)
        man = instance_nearest(_x,_y,obj)
    }
    if variable_instance_get(man,varname) != value && (!instance_is(man,prop) || instance_is(man,Generator)) found = man
    with mans x-= 10000
}
return found

#define instance_nearest_matching_los_ne(_x,_y,obj,varname,value)
var num = instance_number(obj),
    man = instance_nearest(_x,_y,obj),
    mans = [],
    n = 0,
    found = -4;
if instance_exists(obj){
    while ++n <= num && (variable_instance_get(man,varname) = value || (instance_is(man,prop) && !instance_is(man,Generator))) && collision_line(_x,_y,man.x,man.y,Wall,0,0) > -4{
        man.x += 10000
        array_push(mans,man)
        man = instance_nearest(_x,_y,obj)
    }
    if variable_instance_get(man,varname) != value && (!instance_is(man,prop) || instance_is(man,Generator)) found = man
    with mans x-= 10000
}
return found

#define get_n_targets(_x, _y, obj, varname, value, amount)
var num = instance_number(obj),
    man = instance_nearest(_x, _y, obj),
    mans = [],
    n = 0,
    found = [];
if instance_exists(obj){
    while ++n <= num and amount > 0{
        if variable_instance_get(man, varname) != value && (!(instance_is(man, prop) || man.team == 0) || instance_is(man, Generator)){
            array_push(found, man)
            amount--
        }
        man.x += 10000
        array_push(mans, man)
        man = instance_nearest(_x, _y, obj)
    }
    with mans x-= 10000
}
return found

#define get_n_targets_chain(_xstart, _ystart, obj, varname, value, amount)
var num = instance_number(obj),
    man = instance_nearest(_xstart, _ystart, obj),
    mans = [],
    n = 0,
    found = [],
    _x = _xstart,
    _y = _ystart;
if instance_exists(obj){
    while ++n <= num and amount > 0{
        if variable_instance_get(man, varname) != value && (!instance_is(man, prop) || instance_is(man, Generator)){
            array_push(found, man)
            amount--
            _x = man.x
		    _y = man.y
        }
        man.x += 10000
        array_push(mans, man)
        man = instance_nearest(_x, _y, obj)
    }
    with mans x-= 10000
}
return found


#define object_get_mouse(inst)
// Returns a LWO with three fields:
//	x and y: world space coordinates.
//	is_input: indicates whether the coordinates should be treated as an active control source.
//		A nuke for example might ignore the coords if they aren't coming from an actual mouse, as enemies don't really aim over time.
// Used for logic and should be syncronous.
// Of note, the format of the LWO and scr_get_mouse integration are what make this important, thats what ought to be standard.
// If you don't like other choices, feel free to replace them.

	//Compat hook. If you need self, be sure to include it in your script ref as an argument.
	//Return a LWO in your script that would match the output of this one.
	//You can return to the default behavior by setting scr_get_mouse to something that isn't a script reference.
	if "scr_get_mouse" in inst && is_array(inst.scr_get_mouse) {
		with inst return script_ref_call(scr_get_mouse)
	}

	//If there is a mouse at play, use it.
	if instance_is(inst, Player) || ("index" in inst && player_is_active(inst.index)) {
		return {x: mouse_x[inst.index], y: mouse_y[inst.index], is_input: true}
	}

	//If there is a target, consider it the mouse position.
	if "target" in inst && instance_exists(inst.target) {
		return {x: target.x, y: target.y, is_input: false}
	}

	//If no real way to find mouse coords is found, then make some assumptions regarding generally intended behavior.
	//In this case, project a point a moderate distance from the source, with direction as the default angle, optionally picking up gunangle.
	var _length = 48, _dir = inst.direction;
	if "gunangle" in inst {
		_dir = inst.gunangle;
	}

	return {x: inst.x + lengthdir_x(_length, _dir), y: inst.y + lengthdir_y(_length, _dir), is_input: false}


#define script_ref_call_self(scr)
return mod_script_call_self(scr[0], scr[1], scr[2])


 //Poor replacement for sound_play_hit stuff, but used by swords, and can stack.
#define get_coords_nonsync()
var _x, _y, p = player_find_local_nonsync();
if instance_exists(p){
    _x = p.x
    _y = p.y
}
else{
    _x = view_xview_nonsync + game_width/2
    _y = view_yview_nonsync + game_height/2
}
return [_x, _y];

#define audio_play_hit_pitch(snd, pitch)
var p = get_coords_nonsync(),
    q = audio_play_sound_at(snd, p[0] - x, 0, p[1] - y, 100, 300, 1, false, 1);
audio_sound_pitch(q, pitch);
return q;

#define audio_play_ext(snd, x, y, pitch, vol, stack)
if !stack sound_stop(snd);
var p = get_coords_nonsync()
var q = audio_play_sound_at(snd, p[0] - x, 0, p[1] - y, 100, 300, 1, false, 1);
audio_sound_pitch(q, pitch);
audio_sound_gain(q, vol, 0);
return q;

 //very good and epic sound stuff
 //thank you yokin for coding ntte really good and also letting me copy from it
#define sound_play_hit_ext(_sound, _pitch, _volume)
	var s = sound_play_hit(_sound, 0);
	sound_pitch(s, _pitch);
	sound_volume(s, audio_sound_get_gain(s) * _volume);
	return s;

#define sound_play_hit_big_ext(_sound, _pitch, _volume)
	var s = sound_play_hit_big(_sound, 0);
	sound_pitch(s, _pitch);
	sound_volume(s, audio_sound_get_gain(s) * _volume);
	return s;


#define chance(percentage)
return random(100) <= percentage * current_time_scale

#define chance_raw(percentage)
return random(100) <= percentage

#define approach(a, b, n, dn)
return (b - a) * (1 - power((n - 1)/n, dn))

#define angle_approach(a, b, n, dn)
return angle_difference(a, b) * (1 - power((n - 1)/n, dn))

#define array_delete(arr, index)
	// Returns an array that holds everything but the indicated index
	var b = [], _l = array_length(arr);
	if index > 0 array_copy(b, 0, arr, 0, index)
	if index != _l - 1 array_copy(b, array_length(b), arr, index + 1, _l - index)
	return b


#define get_reloadspeed(p)
if !instance_is(p, Player) return 1
return (p.reloadspeed + ((p.race == "venuz") * (.2 + .4 * ultra_get("venuz", 1))) + ((1 - p.my_health/p.maxhealth) * skill_get(mut_stress)))

#define weapon_get_chrg(w)
if is_object(w) w = w.wep
if is_string(w){
    var q = mod_script_call_self("weapon", w, "weapon_chrg")
    if q != undefined return q
}
return 0


#define weapon_charged(c, l)
sound_play_pitch(sndSnowTankCooldown, 8);
sound_play_pitchvol(sndShielderDeflect, 4, .5);
sound_play_pitchvol(sndBigCursedChest, 20, .1);
sound_play_pitchvol(sndCursedChest, 12, .2);

with instance_create(c.x + lengthdir_x(l, c.gunangle), c.y + lengthdir_y(l, c.gunangle), WepSwap) {
	creator = c;
	image_xscale = .5;
	image_yscale = .5;
	depth = other.depth -1;
	sprite_index = sprChickenB;

	with instance_create(x, y, WepSwap) {
		creator = c;
		image_speed = .75;
		depth = other.depth;
		sprite_index = sprChickenB;
	}
}


#define abris_weapon_auto(name, creator)
return charge_weapon_auto("name", name, creator)

#define sniper_weapon_auto(creator)
return charge_weapon_auto("parent", "SniperCharge", creator)

#define charge_weapon_auto(varname, value, creator)
var q = instances_matching(instances_matching(CustomObject, varname, value), "creator", creator);
if array_length(q) return -1;
return true;


#define draw_bar(x, y, w, h, col)
var x2 = x - w * .5, y2 = ceil(y + (h + 3)/2);
draw_line_width_color(x2 - 1, y, x2 + w + 1, y, h + 3, col, col)
draw_line_width_color(x2, y, x2 + w, y, h + 1, 0, 0)
var y3 = ceil(y + (h + 3)/2);
draw_line_width_color(x2 - 1, y3, x2 + w + 1, y3, 1, 0, 0)

// PROJECTILES

#define shell_hit
	projectile_hit(other, (current_frame < fallofftime? damage : (damage - falloff)), force, direction);

#define iris_bullet_anim
	bullet_anim()
	if neurons > 0 {
		speed -= speed/4 + 1
		image_angle = random(360)
		// Layers the spinning effect onto bullets with an on_step event
		if on_step != null {
			bouncer_step_wrap = on_step
			on_step = iris_bouncer_step
		}
		else {
			on_step = bouncer_spin
		}
	}
	on_anim = bullet_anim

#define iris_bouncer_step
	bouncer_spin()
	script_ref_call_self(bouncer_step_wrap)

#define bouncer_spin
	image_angle += bouncer_turn_dir * bouncer_turn_speed * current_time_scale

#define bullet_init()
    name = "Bullet"

    sprite_index = sprBullet1
    spr_dead = sprBulletHit
    mask_index = mskBullet1
    image_speed = 1

    defbloom = {
        xscale : 2,
        yscale : 2,
        alpha : .1
    }

    recycle_amount = 1
    force = 8
    damage = 3
    typ = 1

    bounce = 0 + 4 * neurons
    bounce_color = c_orange
    snd_bounce = {
    	snd: sndBouncerBounce,
    	pitch: 1,
    	vol: 1
    }
    bouncer_turn_dir = choose(-1, 1)
    bouncer_turn_speed = 6
    bouncer_step_wrap = null

    on_anim = iris_bullet_anim
    on_wall = bullet_wall
    on_hit = bullet_hit
    on_destroy = bullet_destroy


#define create_bullet(x, y)
with instance_create(x, y, CustomProjectile) {
	bullet_init()

    return id
}

#define create_heavy_bullet(x, y)
with create_bullet(x, y){
    name = "Heavy Bullet"

    sprite_index = sprHeavyBullet
    spr_dead = sprHeavyBulletHit
    mask_index = mskHeavyBullet

    snd_bounce.pitch = .7
    snd_bounce.vol = .7
    bouncer_turn_speed = 6

    recycle_amount = 2
    force = 12
    damage = 7

    return id
}

#define create_slash_bullet(x, y)
with instance_create(x, y, CustomSlash) {
	bullet_init()

	name = "Slash Bullet"
	typ = 0

	return id
}

#define create_heavy_slash_bullet(x, y)
with create_slash_bullet(x, y){
    name = "Heavy Slash Bullet"

    sprite_index = sprHeavyBullet
    spr_dead = sprHeavyBulletHit
    mask_index = mskHeavyBullet

    snd_bounce.pitch = .7
    snd_bounce.vol = .7
    bouncer_turn_speed = 6

    recycle_amount = 2
    force = 12
    damage = 7

    return id
}


#define bullet_hit
	projectile_hit(other, damage, force, direction);
	recycle_gland_roll()
	instance_destroy()

#define bullet_destroy
	with instance_create(x, y, BulletHit) sprite_index = other.spr_dead

#define bullet_anim
	image_index = 1
	image_speed = 0

#define bullet_wall
	instance_create(x, y, Dust)
	if bounce-- > 0 {
		// bouncer_turn_dir = choose(-1, 1)
		move_bounce_solid(false)
		direction += random_range(-bouncer_turn_speed, bouncer_turn_speed)

		if neurons{
			image_blend = merge_color(image_blend, bounce_color, .2)
			instance_create(x + hspeed, y + vspeed, CaveSparkle)
			damage += 1
			speed += .5
		}else{
			image_angle = direction;
		}

		sound_play_hit_ext(snd_bounce.snd, snd_bounce.pitch + random_nonsync(.1), snd_bounce.vol)

		return true
	}
	sound_play_hit(sndHitWall, .2)
	instance_destroy()
	return false


#define recycle_gland_roll
/// recycle_gland_roll(_chance = 60)
var _chance = argument_count > 0 ? argument[0] : 60;

	var _gland = skill_get(mut_recycle_gland) + (10 * skill_get("recycleglandx10"));
	if recycle_amount != 0 {
		if chance_raw(_chance * _gland) {
			instance_create(x, y, RecycleGland)
			sound_play(sndRecGlandProc)
			var num = recycle_amount * _gland
			with creator if instance_is(self, Player) {
				ammo[1] = min(ammo[1] + num, typ_amax[1])
			}
			return true
		}
	}
	return false

#define create_heavy_bouncer_bullet(x, y)
with create_heavy_bullet(x, y){
    name = "Heavy Bouncer Bullet"
    sprite_index = spr.HeavyBouncerBullet

    damage = 9
    bounce += 2

	// Has normal anim because its already being treated as a bouncer,
	// so it doesnt need conversion
	on_anim = bullet_anim
	on_step = bouncer_spin

    return id
}

#define create_psy_bullet(x, y)
with create_bullet(x,y){
    name = "Psy Bullet"
    sprite_index = (neurons > 0) ? spr.PsyBulletBounce : spr.PsyBullet
    mask_index = msk.PsyBullet
    spr_dead = spr.PsyBulletHit
    bounce_color = c_purple

    damage = 4
    typ = 2
    force = -12

    timer = irandom(6) + 4
    range = 70
    turnspeed = .3
    on_step = psy_step
    on_hit = psy_hit

    return id
}

#define create_psy_bullet_new(x, y)
with create_psy_bullet(x, y){
    name = "PsyBullet"
    on_step = psy_step_new
    // on_draw = psy_draw_new
    target = -4

    return id;
};

#define psy_draw_new
with target{
    var _y = y - sprite_get_bbox_top(sprite_index) - 10;
    draw_triangle_color(x, _y, x - 3, _y - 8, x + 3, _y - 8, c_fuchsia, c_fuchsia, c_fuchsia, 0)
}
draw_self();

#define psy_step_new
if timer > 0{
	timer -= current_time_scale
}
if timer <= 0{
    var t = target;
	if instance_exists(t) && collision_line(x, y, t.x, t.y, Wall, 0, 0) < 0{
		var dir, spd, dif;

		dir = point_direction(x, y, t.x, t.y);
		spd = speed_raw * 5
        dif = clamp(angle_approach(direction, dir, 1/turnspeed, current_time_scale), -spd, spd)

		direction -= dif; //Smoothly rotate to aim position.
		image_angle -= dif
	}
}

#define shoot_n_psy_bullets(x, y, n, team)
var _x = x, _y = y;
if instance_is(self, Player){
    _x = mouse_x[index]
    _y = mouse_y[index]
}
else if "gunangle" in self{
    _x = x + lengthdir_x(50, gunangle)
    _y = y + lengthdir_y(50, gunangle)
}
var a = array_create(n), targets = get_n_targets(_x, _y, hitme, "team", team, ceil(n/2)), l = array_length(targets);
for (var i = 0; i < n; i++){
    var q = create_psy_bullet_new(x, y);
    if l with q target = targets[i mod l]
    a[i] = q
}
return a;

#define shoot_psy_random_target(x, y, n, team)
var _x = x, _y = y;
if instance_is(self, Player){
    _x = mouse_x[index]
    _y = mouse_y[index]
}
else if "gunangle" in self{
    _x = x + lengthdir_x(50, gunangle)
    _y = y + lengthdir_y(50, gunangle)
}
var targets = get_n_targets(_x, _y, hitme, "team", team, n), l = array_length(targets);
with create_psy_bullet_new(x, y){
    if l target = targets[irandom(l-1)]
    return id
}

#define create_heavy_psy_bullet(x, y)
with create_heavy_bullet(x, y){
    name = "Heavy Psy Bullet"
    sprite_index = (neurons > 0) ? spr.HeavyPsyBulletBounce : spr.HeavyPsyBullet
    //mask_index = msk.PsyBullet
    spr_dead = spr.HeavyPsyBulletHit
    bounce_color = c_purple

    damage = 9
    typ = 2
    force = -18
    timer = irandom(4) + 3
    range = 130
    turnspeed = .42

    on_step = psy_step
    on_hit = psy_hit

    return id
}

#define psy_hit()
with other
	if my_health - other.damage <= 0{
		other.force = abs(other.force) / 2;
	}
    motion_add(point_direction(x,y,other.x,other.y),5)
bullet_hit()

#define psy_step
if timer > 0{
	timer -= current_time_scale
}
if timer <= 0{
	var closeboy = instance_nearest_matching_ne(x,y,hitme,"team",team)
	if instance_exists(closeboy) && distance_to_object(closeboy) < range && collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0{
		var dir, spd, dif;

		dir = point_direction(x, y, closeboy.x, closeboy.y);
		spd = speed * 5 * current_time_scale
        dif = clamp(angle_approach(direction, dir, 1/turnspeed, current_time_scale), -spd, spd)

		direction -= dif; //Smoothly rotate to aim position.
		image_angle -= dif
	}
}

//shells{

#define create_psy_shell(x, y)
with instance_create(x, y, CustomProjectile){
	name = "Psy Shell"
	sprite_index = spr.PsyPellet
	friction = .6
	image_angle = direction
	mask_index = mskBullet2
	wallbounce = skill_get(15) * 5 + (skill_get("shotgunshouldersx10")*50)
	force = 4
	image_speed = 1
	damage = 4
	defbloom = {
	    xscale : 2,
	    yscale : 2,
	    alpha : .2
	}
	falloff = 1
	fallofftime = current_frame + 2
	timer = 5 + irandom(4)
	on_hit     = psy_shell_hit
	on_step    = psy_shell_step
	on_wall    = psy_shell_wall
	on_destroy = psy_shell_destroy
	on_anim    = bullet_anim

	return id
}

#define psy_shell_hit
shell_hit()
instance_destroy()

#define psy_shell_step
if timer > 0{
	timer -= current_time_scale
}
if timer <= 0{
	var closeboy = instance_nearest_matching_ne(x,y,hitme,"team",team)
	if instance_exists(closeboy) && distance_to_object(closeboy) < 200 && collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0{
		motion_add(point_direction(x,y,closeboy.x,closeboy.y),current_time_scale * (1 + skill_get(15)))
		motion_add(direction,-.03  * (1 + skill_get(15)))
		image_angle = direction
	}
}
if fallofftime < current_frame defbloom.alpha = .1
if speed < 3{
	instance_destroy()
}

#define psy_shell_wall
fallofftime = current_frame + 2
defbloom.alpha = .2
move_bounce_solid(true)
speed /= 1.25
speed = min(speed+wallbounce,14)
wallbounce /= 1.05
instance_create(x,y,Dust)
sound_play_hit(sndShotgunHitWall,.2)
image_angle = direction

#define psy_shell_destroy
with instance_create(x,y,BulletHit){
	sprite_index = spr.PsyPelletDisappear
	speed = other.speed/5
	direction = other.direction
	image_angle = direction
}

#define create_heavy_split_shell(_x,_y)
with create_split_shell(_x,_y){
    sprite_index = spr.HeavySplitShell
    force = 5
    ammo = 2
    damage = 7
    falloff = 2
    return id
}

#define create_split_shell(_x,_y)
var c = instance_create(_x, _y, CustomProjectile)
with (c){
	name = "Split Shell"
	sprite_index = spr.SplitShell
	friction = .55
	mask_index = mskBullet2
	wallbounce = skill_get(15) * 4 + (skill_get("shotgunshouldersx10")*40)
	force = 4
	ammo = 1
	lasthit = -4
	typ = 1
	image_speed = 1
	defbloom = {
	    xscale : 2,
	    yscale : 2,
	    alpha : .2
	}
	damage = 3
	falloff = 1
	fallofftime = current_frame + 2
	on_hit     = mag_hit
	on_step    = mag_shell_step
	on_destroy = mag_shell_destroy
	on_anim    = bullet_anim
	on_wall    = split_wall
}
return c;


#define split_split
ammo--
image_xscale *= .8
image_yscale *= .8
if ammo == 1{
    sprite_index = spr.SplitShell
    image_xscale = 1
    image_yscale = 1
    damage = 3
    falloff = 1
}
var ang = random_range(10, 30) * choose(-1,1)
var a = ammo >= 3 ? "create_heavy_split_shell" : "create_split_shell"
with mod_script_call("mod","defpack tools", a, x, y){
	creator = other.creator
	image_xscale = other.image_xscale
	image_yscale = other.image_yscale
	team = other.team
	ammo = other.ammo
	motion_set(other.direction + ang,random_range(12,14))
	image_angle = direction
	damage = other.damage
	falloff = other.falloff
}
direction -= ang
image_angle = direction
fallofftime = current_frame + 2
defbloom.alpha = .2


#define split_wall
fallofftime = current_frame + 2
defbloom.alpha = .2
move_bounce_solid(true)
speed *= .66
speed = min(speed + wallbounce, 14)
wallbounce /= 1.05
instance_create(x,y,Dust)
sound_play_hit(sndShotgunHitWall, .2)
image_angle = direction
if ammo{
    split_split()
}

#define mag_hit
if lasthit != other.id or projectile_canhit_melee(other) {
    speed *= .66
    lasthit = other.id
	shell_hit();
	if ammo > 0{
		split_split()
	}
	else instance_destroy()
}

#define mag_shell_step
if fallofftime < current_frame {
	defbloom.alpha = .1
}
if speed < 2 {
	instance_destroy()
}

#define mag_shell_destroy
with instance_create(x,y,BulletHit){
	image_xscale = other.image_xscale
	image_yscale = image_xscale
	sprite_index = spr.SplitShellDisappear
	if other.sprite_index = spr.HeavySplitShell {sprite_index = spr.HeavySplitShellDisappear}
	speed = other.speed/5
	direction = other.direction
	image_angle = direction
}

//}




#define create_heavy_gamma_bullet(x, y)
with create_gamma_bullet(x, y) {
    name = "Heavy Gamma Bullet"

	sprite_index = (neurons > 0) ? spr.HeavyGammaBulletBounce : spr.HeavyGammaBullet
	spr_dead = spr.HeavyGammaBulletHit

    force = 7
    damage = 3
    pierce = 2
    recycle_amount = 2

    return id
}

#define create_gamma_bullet(x, y)
with create_slash_bullet(x, y) {
	name = "Gamma Bullet"

    sprite_index = (neurons > 0) ? spr.GammaBulletBounce : spr.GammaBullet
    spr_dead = spr.GammaBulletHit
    bounce_color = c_lime

    force = 4
    damage = 1
	typ = 1
	pierce = 1
	lasthit = -4

	on_hit = gamma_hit
	on_projectile = gamma_projectile
	on_grenade    = nothing

	return id
}


#define gamma_projectile
if (instance_exists(other) && other.typ > 0) {
	with other instance_destroy()
	// sleep(4)
	pierce -= 2;
	if (instance_exists(self) && pierce < 0) instance_destroy()
}

#define gamma_hit
if (lasthit != other) {
	lasthit = other
	sleep(damage * 2 + 3)
	view_shake_max_at(x, y, damage * 2)
	projectile_hit(other, damage, force, direction)
	if (recycle_gland_roll(40)) {
		recycle_amount = 0
	}
	if (--pierce < 0) instance_destroy()
}

#define create_thunder_bullet(x, y)
return create_lightning_bullet(x, y)

#define create_lightning_bullet(x, y)
with create_bullet(x, y){
    name = "Lightning Bullet"

    var s = "LightningBullet";
    if brain_active s += "Upg"
    if neurons > 0 s += "Bounce"
    sprite_index = lq_get(spr, s)

    spr_dead = spr.LightningBulletHit
    bounce_color = c_aqua
    charge = choose(2, 2, 3)

    force = 5
    //Was 2 before new mechanic test
    damage = 3
    typ = 2

    // on_step = thunder_step
    // on_destroy = thunder_destroy

    //Testing new thunder mechanic
    on_hit = new_thunder_hit
	on_destroy = new_thunder_destroy

    return id
}

//Testing new thunder mechanic
#define new_thunder_hit
	if "thunder_charge" not in other {
		other.thunder_charge = 0
	}
	other.thunder_charge += charge
	var _team = team, _c = creator;
	bullet_hit()
	var laserbrain = ceil(skill_get(mut_laser_brain));
	if other.my_health <= 0 {
		var _charge = max(other.thunder_charge, 5);
		while(_charge) > 0 {
			var r = min(irandom(_charge) + 1 + laserbrain, 12 + laserbrain);
			with instance_create(other.x, other.y, Lightning) {
				image_angle = random(360)
				direction = image_angle
				ammo = r + 1
				creator = _c
				team = _team
				alarm0 = irandom(1) + 1
			}
			_charge -= max(r - laserbrain, 1)
		}
		view_shake_at(other.x, other.y, other.thunder_charge/5)
		sound_play_pitchvol(sndLightningCannonEnd, 1 + max(1 - other.thunder_charge/30, -.8), .4)
		if laserbrain {
			sound_play_pitchvol(sndLightningPistolUpg, .8, .4)
		}
	}

#define new_thunder_destroy
	instance_create(x + random_range(-5, 5), y + random_range(-5, 5), LightningHit)
	bullet_destroy()

#define create_heavy_lightning_bullet(x, y)
with create_heavy_bullet(x, y){
    name = "Heavy Lightning Bullet"

    var s = "HeavyLightningBullet";
    if brain_active > 0 s += "Upg"
    if neurons > 0 s += "Bounce"
    sprite_index = lq_get(spr, s)

    spr_dead = spr.HeavyLightningBulletHit
    bounce_color = c_aqua

    typ = 2
    damage = 7
    charge = choose(5, 5, 6)

    on_hit = new_thunder_hit
    on_step = heavy_thunder_step
    // on_destroy = heavy_thunder_destroy
    on_destroy = new_thunder_destroy

    return id
}

#define quick_lightning(a)
with instance_create(x,y,Lightning){
  	image_angle = random(360)
  	team = other.team
	creator = other.creator
  	ammo = a
  	event_perform(ev_alarm, 0)
	visible = 0
	with instances_matching_gt(LightningHit, "id", id) {
		image_index += 1
	}
}

#define heavy_thunder_step
if chance(12){
	instance_create(x + random_range(-5, 5), y + random_range(-5, 5), LightningHit).image_speed += .2
    // quick_lightning(2)
}

#define thunder_step
if chance(5){
    quick_lightning(choose(1,2))
}

#define heavy_thunder_destroy
quick_lightning(4)
thunder_destroy()

#define thunder_destroy
quick_lightning(4)
bullet_destroy()

#define create_pest_bullet(x,y)
return create_toxic_bullet(x,y)

#define create_toxic_bullet(x, y)
with create_bullet(x, y){
    name = "Toxic Bullet"
    sprite_index = (neurons > 0) ? spr.ToxicBulletBounce : spr.ToxicBullet
    spr_dead = spr.ToxicBulletHit
    bounce_color = c_lime

    force = 8
    damage = 4

    on_hit = toxic_hit
    on_destroy = toxic_destroy

    return id
}

#define create_heavy_toxic_bullet(x, y)
with create_heavy_bullet(x, y){
    name = "Heavy Toxic Bullet"
    sprite_index = (neurons > 0) ? spr.HeavyToxicBulletBounce : spr.HeavyToxicBullet
    spr_dead = spr.HeavyToxicBulletHit
    bounce_color = c_lime

    force = 11
    damage = 7

    on_hit = toxic_hit
    on_destroy = heavy_toxic_destroy

    return id
}

#define toxic_hit
poison(other)
bullet_hit()

#define poison(target)
with target{
    if("poisoned" not in self) {
        poisoned = 60;
    }
    else{
        if(poisoned <= 60) {
            poisoned = 100;
        }
        else{
            poisoned += 40 - (poisoned mod 20)
        }
    }
}

#define toxic_destroy

		if (!instance_exists(creator) || point_distance(x, y, creator.x, creator.y) > 32) {

		  repeat(choose(1, 1, 2))with instance_create(x, y, ToxicGas){

		      friction *= 10;
	        growspeed /= 8;
	        move_contact_solid(other.direction, other.speed);
		}
	}
	bullet_destroy()

#define heavy_toxic_destroy
	if (!instance_exists(creator) || point_distance(x, y, creator.x, creator.y) > 32) {

		repeat(3){ with instance_create(x, y, ToxicGas){
		        friction *= 24;
		        growspeed /= 4;
		        move_contact_solid(other.direction, other.speed);
		        motion_add(random(360), random_range(2, 4))
		    }
		}
	}
	bullet_destroy()

#define create_flame_bullet(x,y)
return create_fire_bullet(x,y)

#define create_fire_bullet(x,y)
with create_bullet(x,y){
    name = "Fire Bullet"
    sprite_index = (neurons > 0) ? spr.FireBulletBounce : spr.FireBullet
    spr_dead = spr.FireBulletHit
    bounce_color = c_red
	image_speed = 0;

    damage = 5
	falloff = 2
	fallofftime = current_frame + 4
	defbloom.alpha = .2

    on_step = fire_step
    on_destroy = fire_destroy
    on_hit = fire_bullet_hit

    return id
}

#define create_heavy_fire_bullet(x,y)
with create_heavy_bullet(x, y){
    name = "Heavy Fire Bullet"
    sprite_index = (neurons > 0) ? spr.HeavyFireBulletBounce : spr.HeavyFireBullet
    spr_dead = spr.HeavyFireBulletHit
    bounce_color = c_red
	image_speed = 0;

    damage = 11
	falloff = 6
	fallofftime = current_frame + 4
	defbloom.alpha = .2

    on_step = fire_step
    on_destroy = heavy_fire_destroy
    on_hit = fire_bullet_hit

    return id
}

#define fire_bullet_hit
	shell_hit()
	recycle_gland_roll()
	instance_destroy()


#define fire_step
	if (fallofftime >= current_frame){
		image_index = 1;
	}
	if (fallofftime < current_frame && defbloom.alpha != .1) {
		defbloom.alpha = .1;
		image_index = 2;
		with instance_create(x,y,Flame){
			team = other.team
			creator = other.creator
            damage = 1;
		}
	}

#define fire_destroy
/*with create_miniexplosion(x, y){
    team = other.team
}*/
with instance_create(x,y,BulletHit){
	sprite_index = other.spr_dead
    image_index = 1
}
with instance_create(x, y, Flame){
	team = other.team;
	creator = other.creator;
	motion_add(other.direction, random_range(4,6))
	friction = 2;
    damage = 1;
}

#define heavy_fire_destroy
//instance_create(x,y,SmallExplosion)
repeat(8){
	with instance_create(x, y, Flame){
		team = other.team;
		creator = other.creator;
		motion_add(random(360), random_range(6,8))
		friction = .7;
        damage = 1;
	}
}
sound_play_pitchvol(sndExplosionS,2,.3)
bullet_destroy()

#define create_dark_bullet(x,y)
with create_slash_bullet(x, y) {
	name = "Dark Bullet"
	sprite_index = neurons ? spr.DarkBulletBounce : spr.DarkBullet
	mask_index = msk.DarkBullet
	spr_dead = spr.DarkBulletHit

	typ = 2
	damage = 8
	force = 7

    bounce_color = c_black
    bouncer_turn_speed = 3

	on_projectile = dark_proj
	on_destroy = dark_destroy

	return id
}


#define dark_explo_hit
if projectile_canhit_melee(other) {
	projectile_hit_push(other, damage, force)
}


#define dark_proj
var t = team;
if (other.typ > 0) {
	with create_dark_bullet_explosion(x, y, random_range(.26, .3)) {
		team = other.team
		creator = other.creator
	}
	for (var i = 0, r = random(360); i <= 2; i++) {
		with create_dark_bullet_explosion(x + lengthdir_x(6, r + i * 120), y + lengthdir_y(6, r + i * 120), random_range(.15, .2)) {
			team = other.team
			creator = other.creator
			image_speed = 1
		}
	}
}

#define dark_destroy
with create_dark_bullet_explosion(x, y, random_range(.37, .4)) {
	team = other.team
	creator = other.creator
	damage = 8
	view_shake_at(x, y, 5)
}
bullet_destroy()

#define create_dark_bullet_explosion(x, y, _scale)
with instance_create(x, y, CustomSlash) {
	name = "Dark Bullet Explo"
	sprite_index = spr.SonicExplosion
	mask_index = msk.SonicExplosion

	typ = 0
	damage = 2
	force = 0

	image_xscale = _scale
	image_yscale = _scale
	image_speed = .8

	image_blend = c_black

	on_anim       = sonic_anim
	on_projectile = sonic_projectile
	on_grenade    = sonic_grenade
	on_wall       = nothing
	on_hit        = dark_explo_hit

	return id
}


#define create_light_bullet(x, y)
with create_bullet(x, y){
    name = "Light Bullet"
    typ = 0
    sprite_index = neurons ? spr.LightBulletBounce : spr.LightBullet
    spr_dead = spr.LightBulletHit

    force = 4
    lasthit = -4
    pierces = 6
    bounce_color = c_dkgray

    on_hit = light_hit


    return id
}

#define light_hit
if other != lasthit{
	projectile_hit(other, damage, force, direction);
	lasthit = other
	pierces -= 1
    if recycle_amount != 0{
        with creator{
            var num = (skill_get(mut_recycle_gland) * (irandom(9) < 5)) + 10*skill_get("recycleglandx10")
            if num{
                ammo[1] = min(ammo[1] + other.recycle_amount * num, typ_amax[1])
                instance_create(other.x, other.y, RecycleGland)
                sound_play(sndRecGlandProc)
            }
        }
    }
    if pierces = 0{
    	instance_destroy()
    }
}

#define create_small_sonic_explosion(_x,_y)
	with create_sonic_explosion(_x, _y) {
		name = "Small Sonic Explosion"

		sprite_index = spr.SmallSonicExplosion
		mask_index = msk.SmallSonicExplosion
		hitid = [sprite_index,"Small Sonic Explosion"]

		image_speed = .85
		candeflect = 0
		force = 3
		shake = 2
		canwallhit = false
		can_crown = false;
		play_sound = false;

		return id
	}

#define create_sonic_explosion(_x,_y)
	with instance_create(_x,_y,CustomSlash){
		name = "Sonic Explosion"

		sprite_index = spr.SonicExplosion
		mask_index = msk.SonicExplosion
		hitid = [sprite_index,"Sonic Explosion"]

		typ = 0
		damage = 0
		candeflect = 1
		image_speed = .7
		force = 18
		shake = 10

		superfriction = 1
		dontwait = false
		play_sound = true
		can_crown = true
		canwallhit = true
		synstep = (GameCont.area = 101) //oasis synergy

		sage_no_hitscan = true;

		on_step       = sonic_step
		on_projectile = sonic_projectile
		on_grenade    = sonic_grenade
		on_hit        = sonic_hit
		on_wall       = nothing
		on_anim       = sonic_anim

		return id
	}

#define nothing

#define sonic_anim
	instance_destroy();

#define sonic_step
	if synstep {
		synstep = false
		image_xscale *= 1.25
		image_yscale *= 1.25
		image_speed  *= .8
	}

	if play_sound{
		sound_play_pitchvol(snd.SonicExplosion, random_range(1, 1.3), .8);
		play_sound = false;
	}

	with Pickup{
		if place_meeting(x, y, other){
			motion_set(point_direction(other.x, other.y, x, y), clamp(other.force / 3, 12, 2));
		}
	}
	with chestprop{
		if place_meeting(x, y, other){
			motion_set(point_direction(other.x, other.y, x, y), clamp(other.force / 2, 10, 1));
		}
	}

	if shake {
		view_shake_at(x,y,shake)
		shake = 0
		if crown_current = crwn_death && can_crown{
			var _r = sprite_get_width(sprite_index) / 3,
					_d = random(360);
			repeat(3){
				with create_small_sonic_explosion(x + lengthdir_x(_r * random_range(.6, 1), _d), y + lengthdir_y(_r * random_range(.6, 1), _d)){
					team = 2
					creator = other.creator
					force = other.force
					canwallhit = true
					superdirection = _d
				}
				_d += 360 / 3;
			}
		}
	}

#define sonic_projectile
	with other if typ > 0 {
		instance_destroy();
	}

#define sonic_grenade
	with other if (speed > 0) {
		direction = point_direction(other.x,other.y,x,y);
		image_angle = direction;
	}

#define sonic_hit
	if projectile_canhit_melee(other){
		var _cwh = canwallhit,
		    _dwt = dontwait,
		      _s = self,
					_o = other;

		switch object_get_name(other.object_index) {
			case "MeleeFake":		       projectile_hit(other, 1, force, direction); break;
			case "JungleAssassinHide": projectile_hit(other, 1, force, direction); break;
			case "Mimic":              projectile_hit(other, 100, force, direction); break;
			case "SuperMimic":         projectile_hit(other, 100, force, direction); break;
		}

		if instance_is(other, Car) || instance_is(other, CarVenusFixed) || instance_is(other, CarVenus2) || instance_is(other, CarVenus) {

			with other {

				with instance_create (x, y, CarThrow) {

					if other.sprite_index = sprFrozenCar {

						sprite_index = sprFrozenCarThrown;
					}

					sleep(4);
					//trace(_s.superdirection)
					motion_add("superdirection" in _s ? _s.superdirection : point_direction(_s.x, _s.y, x, y), 32);
				}

				// Sound fx:
				sound_play_pitchvol(sndImpWristKill, .8, 1.4);
				sound_play_pitchvol(sndSawedOffShotgun, .7, .6);
				instance_delete(self);
				exit;
			}

		}	else if instance_is(other, prop) {

			projectile_hit(other, 8, force, direction);
			exit;
		}

		// incredibly lazy approach of me not wanting to copy paste the event into the sonic hammer file
		if "fx_sleep" in self sleep(fx_sleep);
		if "fx_shake" in self view_shake_max_at(x, y, fx_shake);

		var _explo = self,
		       _id = other;
		projectile_hit(other,damage,force,point_direction(x,y,other.x,other.y))
		with other if !instance_is(self, prop) with instance_create(x, y, CustomObject)
		{
			with instances_matching(CustomObject, "name", "SuperForce")
			{
				if creator = other && creator = _id
				{
					instance_delete(self);
					exit;
				}
			}

			// fx:
			var _p = random_range(.8, 1.2);
			sound_play_pitchvol(sndImpWristKill, .8 * _p, 1.4);
			sound_play_pitchvol(sndSawedOffShotgun, .8 * _p, .6);
			sound_play_pitchvol(sndFlakExplode, 1 * _p, 1);
			sleep(4 + 4 * clamp(_id.size, 1, 3));

			// Setting up vars:
			name         = "SuperForce";
			team         = other.team;
			creator      = other;
			or_maxspeed  = "maxspeed" in other ? other.maxspeed : -1
			mask_index   = other.mask_index;
			sprite_index = mskNothing;
			canwallhit   = _cwh
			timer = 4
			dontwait = _dwt
			with _explo
			{
				if "force"          in self other.superforce 	 = force else {other.superforce = 18};
				other.superforce *= (1 + skill_get(mut_impact_wrists) * .25)
				if "superfriction"  in self other.superfriction  = superfriction else other.superfriction = 1;
				if "superdirection" in self other.superdirection = superdirection;
			}
			motion_set("superdirection" in self ? superdirection : other.direction, superforce); // for easier direction manipulation on wall hit

			with instance_create(_o.x, _o.y, ImpactWrists){
				var _fac = 2 + .15 * clamp(_o.size, 0, 3);
				image_xscale = _fac * .5;
				image_yscale = _fac
				image_speed = .75;
				image_alpha = .75;
				image_index = 1;
				motion_add(other.direction, -2);
				friction = .02;
				image_angle = direction
			}
			on_step = superforce_step;
		}
	}



#define superforce_step
	//apply "super force" to enemies
	if timer > 0 && dontwait = false{timer -= current_time_scale; exit}
	if !instance_exists(creator) ||instance_is(creator, Nothing) ||instance_is(creator, TechnoMancer) ||instance_is(creator, Turret) ||instance_is(creator, MaggotSpawn) ||instance_is(creator, Nothing) ||instance_is(creator, LilHunterFly) || instance_is(creator, RavenFly){instance_delete(self); exit}
	with creator
	{
		repeat(2) with instance_create(x, y, Dust){motion_add(other.direction + random_range(-8, 8), choose(1, 2, 2, 3)); sprite_index = sprExtraFeet}
		other.x = x;
		other.y = y;
		if "maxspeed" in self maxspeed = other.superforce
		motion_set(other.direction, other.superforce);
		var _s = "size" in self ? size : 0;
		other.superforce -= other.superfriction * max(1, _s);
		if other.superforce <= 0 {with other {
			if or_maxspeed > -1 {
				other.maxspeed = or_maxspeed
			}
			instance_delete(self)
			exit}
		}
	}
	if superforce >= 3 with instance_create(creator.x, creator.y, ImpactWrists){
		var _fac = .5 + .15 * clamp(other.creator.size, 0, 3);
		image_xscale = _fac * .5;
		image_yscale = _fac
		image_speed = .85 - .10 * clamp(other.creator.size, 0, 3);
		motion_add(other.creator.direction, 2);
		image_angle = direction
	}

	if (place_meeting(x + hspeed, y + vspeed, Wall) || place_meeting(x + hspeed / 2, y + vspeed / 2, Wall)) && canwallhit = true
	{
	  with instance_create(x, y, MeleeHitWall){image_angle = other.direction} move_bounce_solid(false);
		sound_play_pitchvol(sndImpWristKill, 1.2, .8)
		sound_play_pitchvol(sndWallBreak, .7, .8)
		sound_play_pitchvol(sndHitRock, .8, .8)
		sleep(32)
		view_shake_at(x, y, 8 * clamp(creator.size, 1, 3))
		repeat(creator.size) instance_create(x, y, Debris)
		if superforce > 4 with creator
		{
			//trace("wall hit")
			projectile_hit(self,max(3, round(ceil(other.superforce) * 1.5)),1 ,direction)
			if my_health <= 0
			{
				sleep(30)
				view_shake_at(x, y, 16)
				repeat(3) instance_create(x, y, Dust){sprite_index = sprExtraFeet}
			}
		}

		// Visuals:
		with instance_create(x, y, ChickenB) image_speed = .65
		/*repeat(max(1, creator.size)) with instance_create(x, y, ImpactWrists){
			var _fac = random_range(.2, .5)
			image_xscale = _fac
			image_yscale = _fac * 1.5
			image_speed = 1 - _fac
			motion_add(random(360), random_range(1, 3) + 1)
			image_angle = direction
		}*/
		superforce *= .4
	}

	// Enemy Enemy collision:
	if place_meeting(x + hspeed, y + vspeed, hitme)
	{
		var _h = instance_nearest(x + hspeed, y + vspeed, hitme);
		if !instance_is(_h, Player) && _h != creator && projectile_canhit_melee(_h)
		{
			var _d = "meleedamage" in creator ? creator.meleedamage * 2 : 5;
			var _s = (ceil(superforce) + _h.size) + _d;
			sleep(_s / 3 * max(1, _h.size))
			view_shake_at(x, y, _s / 3 * max(1, _h.size))

			// Hit enemy takes damage based on Superforced enemies superforce & melee damage
			projectile_hit(_h,_s, superforce, direction);

			// Superforced enemy takes damage based on superforce
			projectile_hit(creator, round(superforce / 2), 0, direction);

			superforce *= .85 + .15 * min(skill_get(mut_impact_wrists), 1);
		}
	}
	if superforce <= 1 instance_delete(self)

#define extraspeed_add(_player, _speed, _direction)
	if instance_exists(_player) with _player{
		canaim = false;
		if "defspeed" not in self{
			defspeed[0] = _speed;
			defspeed[1] = _direction;
		}else{
			defspeed[0] = max(_speed, defspeed[0]);
			defspeed[1] = _direction;
		}
	}

//ok i guess im stealing stuff from gunlocker too but its a good idea alright
#define shell_yeah(_angle, _spread, _speed, _color)
	with instance_create(x, y, Shell){
		image_speed = 0
		motion_add(other.gunangle + (other.right * _angle) + random_range(-_spread, _spread), _speed);
		sprite_index = spr.GenShell
		switch _color
		{
			case c_yellow: image_index = 0;break
			case c_red   : image_index = 1;break
			case c_purple: image_index = 2;break
			case c_green : image_index = 3;break
			case c_navy  : image_index = 4;break
			case c_white : image_index = 5;break
			case c_black : image_index = 6;break
			case c_lime  : image_index = 7;break
		}
		return id
	}
//im not feeling like rewriting every weapon using shell_yeah
#define shell_yeah_big(_angle, _spread, _speed, _color)
	with shell_yeah(_angle, _spread, _speed, _color){
	    sprite_index = spr.GenShellBig
	}

#define shell_yeah_heavy(_angle, _spread, _speed, _color)
	with shell_yeah(_angle, _spread, _speed, _color){
	    sprite_index = spr.GenShellHeavy
	}

#define shell_yeah_long(_angle, _spread, _speed, _color)
	with shell_yeah(_angle, _spread, _speed, _color){
	    sprite_index = spr.GenShellLong
	}


#define draw_arc(x, y, angle, innerradius, outerradius, degrees, precision, col, inneralpha, outeralpha)
	x += prim_offset
	y += prim_offset
	var r1 = innerradius, r2 = outerradius, ang1 = angle - degrees/2, inc = degrees/precision;
	draw_primitive_begin(pr_trianglestrip)
	for (var i = 0; i <= precision; i++){
	    var xl = lengthdir_x(1, ang1 + inc * i), yl = lengthdir_y(1, ang1 + inc * i)
	    draw_vertex_color(x + xl * r1, y + yl * r1, col, inneralpha)
	    draw_vertex_color(x + xl * r2, y + yl * r2, col, outeralpha)
	}
	draw_primitive_end();

#define anglefy(a)
	return wrap(a, 360)

#define wrap(a, n)
	while a < 0{
	    a += n
	}
	return a mod n

#define draw_arc_broken(x, y, angle, radius, thickness, degrees, pivot, precision, col, inneralpha, outeralpha)
x += prim_offset
y += prim_offset
var r1 = radius, ang1 = anglefy(angle - degrees/2), inc = degrees/precision, pinc = 180/precision, d = anglefy(-angle_difference(ang1, pivot))/inc + precision/2, n = 360*precision/degrees;
draw_primitive_begin(pr_trianglestrip)
for (var i = 0; i <= precision; i++){
    var e = (pinc*wrap(-i + d, n))
    var a = ang1 + inc * i, r = thickness * max(dsin(e), 0)
    var xl = lengthdir_x(1, a), yl = lengthdir_y(1, a)
    draw_vertex_color(x + xl * (r1 - r/2), y + yl * (r1 - r/2), col, inneralpha)
    draw_vertex_color(x + xl * (r1 + r/2), y + yl * (r1 + r/2), col, outeralpha)
}
draw_primitive_end();


#define draw_arc_wave(x, y, angle, radius, thickness, degrees, precision, col, inneralpha, outeralpha, stiff)
x += prim_offset
y += prim_offset
var r1 = radius, ang1 = anglefy(angle - degrees/2), inc = degrees/precision, pinc = 180/precision;
draw_primitive_begin(pr_trianglestrip)
for (var i = 0; i <= precision; i++){
    var a = ang1 + inc * i, r = thickness * max(dsin(pinc * i), 0)
    var xl = lengthdir_x(1, a), yl = lengthdir_y(1, a)
    var ur = (r1 - (r * !stiff + thickness * stiff)/2)
    draw_vertex_color(x + xl * ur, y + yl * ur, col, inneralpha)
    draw_vertex_color(x + xl * (ur + r), y + yl * (ur + r), col, outeralpha)
}
draw_primitive_end();


#define draw_circle_width_colour(precision,radius,width,offset,xcenter,ycenter,col,alpha)
draw_arc(xcenter, ycenter, offset, radius - width, radius, 360, precision, col, alpha, alpha)

//this is basically a fucked up version of the draw_polygon_texture function, but it does something neat i guess
#define draw_polygon_striped(sides,radius,angle,_x,_y,col,alpha,scroll)
draw_set_alpha(alpha)
draw_set_color(col)
_x += prim_offset
_y += prim_offset
texture_set_repeat(1)
var tex, w, scroll, s;
w = 256;
tex = sprite_get_texture(spr.Stripes, 0);
var n = 1.5;
scroll = -floor(scroll mod (16 * n)) * (.004/n);
draw_primitive_begin_texture(pr_trianglefan, tex);
draw_vertex_texture(_x, _y, .50 + scroll, 0)
for (var i = angle; i <= angle+360; i += 360/sides){
    var q = .5 + (1/w) * lengthdir_x(radius, -angle + i) + scroll
    draw_vertex_texture(_x + lengthdir_x(radius, i), _y + lengthdir_y(radius, i), q, 0);
}
draw_primitive_end();
texture_set_repeat(0)
draw_set_color(c_white)
draw_set_alpha(1)

#define draw_polygon_texture(sides,radius,angle,spriteang,_x,_y,xscale,yscale,sprite,frame,col,alpha)
_x += prim_offset
_y += prim_offset
draw_set_alpha(alpha)
draw_set_color(col)
var tex,w,h;
w = sprite_get_width(sprite);
h = sprite_get_height(sprite);
tex = sprite_get_texture(sprite, frame);
draw_primitive_begin_texture(pr_trianglefan, tex);
draw_vertex_texture(_x,_y,.5,.5)
for (var i = angle; i <= angle+360; i += 360/sides){
    draw_vertex_texture(_x+lengthdir_x(radius,i), _y+lengthdir_y(radius,i), .5+(1/(w*xscale))*lengthdir_x(radius,-spriteang+i), .5+(1/(h*yscale))*lengthdir_y(radius,-spriteang+i));
}
draw_primitive_end();
draw_set_color(c_white)
draw_set_alpha(1)

//abris time
#define create_abris(Creator,startsize,endsize,weapon)
with instance_create(0, 0, CustomObject){
    creator = Creator
    name = "Abris Target"
    team = -1
    sprite_index = mskNone
    mask_index   = sprMapDot

    on_step    = abris_step
    on_draw    = abris_draw
    on_cleanup = script_ref_create(abris_cleanup)
    on_destroy = abris_destroy

    index = -1
    accbase = startsize
    acc = accbase
    accmin = endsize
    accspeed = 1.2

    damage = 2
    maxdamage = 8
    wep = weapon
    auto = 0
		margin = 18;
		lockon = false;
		closed = false
		hover  = 3;
		view_factor = 1;
	  chargeblink = 0;

    scroll = random(16)
    scrollang = random(360)
    rotspeed = 3
    offspeed = 4
    lasercolour  = c_red
    ringcolour   = c_red
    stripecolour = c_red
    offset = random(360)
    payload = script_ref_create(nothing)

    defcharge = {
        width : sqrt(3*abs(startsize)),
        charge : 0,
        maxcharge : 1,
        style : defcharge_bar
    }

    isplayer = 1
    targeting = abris_mouse
    btn = "fire"
    hand = 0
    reload = -1
    length = 0
    angle = 0
    if instance_is(creator, FireCont) and "creator" in creator{
        angle = creator.gunangle
        creator = creator.creator
        targeting = abris_manual
        length = startsize * 1.25
        auto = 1
    }
    if !instance_is(creator, Player){
        index = -1
        isplayer = 0
        if "gunangle" in creator{
            targeting = abris_gunangle
            angle = angle_difference(creator.gunangle, angle)
        }
    }
    else{
        index = creator.index
        btn = creator.specfiring ? "spec" : "fire"
        hand = (btn == "spec" and creator.race == "steroids")
    }

    abris_draw()
    return id
}

#define is_player(c)
if instance_is(c, FireCont)
    return is_player(c.creator)
return instance_is(c, Player)

#define abris_cleanup
if isplayer view_pan_factor[index] = undefined

#define abris_refund
if instance_is(creator, Player){
    if creator.infammo = 0{
        var t = weapon_get_type(wep), c = weapon_get_cost(wep);
        creator.ammo[t] = min(creator.ammo[t] + c, creator.typ_amax[t])
    }
}
abris_cleanup()
on_destroy = nothing
instance_destroy()

#define abris_step
if instance_exists(creator){
    var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;

	if (isplayer && (button_check(creator.index, "swap") && (creator.canswap = true || creator.bwep != 0))) {
		abris_refund()
		exit
	}

		chargeblink = false;

    image_angle += rotspeed * timescale
    scroll += timescale
    offset += offspeed * timescale

	if hover > 0 {
		hover = max(0, hover - current_time_scale)
	}

	if (acc > 0 && hover = 0) {
		acc = max(acc/power(accspeed, timescale), 0)
	}

    if isplayer {
        var _a = (hover > 0 ? 0 : 1 - acc/accmin);
        view_pan_factor[index] = 4 - (_a * 1.3 * view_factor)
        defcharge.charge = _a

		if _a > 0.99 && _a < 1 && closed = false {
			weapon_charged(creator, sprite_get_width(weapon_get_sprt(hand ? creator.wep : creator.bwep)) / 2)
			creator.gunshine = 1
			closed = true
			chargeblink = true;
		}

        if reload = -1 {
            reload = hand ? creator.breload : creator.reload
            reload += get_reloadspeed(creator) * timescale
        }
        if hand creator.breload = max(reload, creator.breload)
        else creator.reload = max(reload, creator.reload)

        if !button_check(index, btn) or (auto and acc <= 0.01){
            instance_destroy()
        }
    }
    else {
        if acc <= 0 {
            instance_destroy()
        }
    }
}
else{
    on_destroy = nothing
    instance_destroy()
}

#define abris_destroy
script_ref_call_self(payload)
abris_cleanup()
with instance_create(x, y, CustomProjectile){
    name = "Abris Blast"
    sprite_index = sprGammaBlast
    image_alpha = 0
    team = other.creator.team
    var size = 2 * (other.hover > 0 ? other.accbase+other.accmin : other.acc+other.accmin)/(sprite_width)
    damage = other.defcharge.charge >= other.defcharge.maxcharge *.99 ? other.maxdamage : other.damage
    image_xscale = size
    image_yscale = size
    on_wall = nothing
    on_hit = abris_hit
    if fork(){
        wait(0)
        if instance_exists(self) instance_destroy()
        exit
    }
}

#define abris_draw
if instance_exists(creator){
    var _x, _y, c = creator, ang;
    if targeting == abris_mouse{
        _x = c.x + lengthdir_x(point_distance(c.x, c.y, mouse_x[index], mouse_y[index]), c.gunangle)
        _y = c.y + lengthdir_y(point_distance(c.x, c.y, mouse_x[index], mouse_y[index]), c.gunangle)
        ang = c.gunangle
    }
    else if targeting == abris_manual{
        _x = c.x + lengthdir_x(length, angle)
        _y = c.y + lengthdir_y(length, angle)
        ang = angle
    }else if targeting == abris_gunangle{
        _x = c.x + lengthdir_x(length, c.gunangle + angle)
        _y = c.y + lengthdir_y(length, c.gunangle + angle)
        ang = c.gunangle + angle
    }

		//experimental autoaim
		if lockon >= 0 {
			var _e = instance_nearest_matching_los_ne(_x, _y, hitme, "team", creator.team),
			    _dis = _e > -4 ? point_distance(creator.x, creator.y, _e.x, _e.y) : 0,
				_dir = _e > -4 ? point_direction(creator.x, creator.y, _e.x, _e.y) : 0;
			if instance_exists(_e)
				&& collision_line(creator.x, creator.y, _e.x ,_e.y, Wall, 0, 0) = noone
				&& point_distance(_x, _y, _e.x, _e.y) <= (margin + ((6 + (20 * lockon / max(creator.accuracy, 0.1))) * !closed)) {
					_x = c.x + lengthdir_x(_dis + _e.hspeed, _dir);
					_y = c.y + lengthdir_y(_dis + _e.vspeed, _dir);
					lockon = true
			}
			else {
				lockon = false
			}
		}

    var w = collision_line_first(creator.x, creator.y, _x, _y, Wall, 0, 0);
    x = w[0]
    y = w[1]

    var kick = hand ? creator.bwkick : creator.wkick, yoff = -4 * hand;
    var  r = acc+accmin, sides = 16, a = 1 - acc/accbase,
    	  _c = (global.AbrisCustomColor = true && instance_is(creator, Player)) ? player_get_color(creator.index) : lasercolour,
		   _c2 = chargeblink = true ? c_white : _c;
    //Glow on gun
    draw_sprite_ext(sprHeavyGrenadeBlink, 0, c.x + lengthdir_x(14 - kick, ang), c.y + lengthdir_y(14 - kick, ang) + 1 + yoff, 1, 1, ang, _c, 1)
    //Actual boundary
    mod_script_call_nc("mod", "defpack tools", "draw_circle_width_colour", sides, r, 1, acc + image_angle, x, y, _c2, .5 + a * .5)
    //Minimim boundary (the one its approaching)
    mod_script_call_nc("mod", "defpack tools", "draw_circle_width_colour", sides, accmin, 1, acc + image_angle, x, y, _c2, .2 + a * .2)
    //Laser pointer
    draw_line_width_color(c.x + lengthdir_x(16 - kick, ang), c.y + lengthdir_y(16 - kick, ang) + yoff, x, y, 1, _c, _c)
    //Fill the circle with stripes
    mod_script_call_nc("mod", "defpack tools", "draw_polygon_striped", sides, r, scrollang, x, y, _c2, .1 + .3*a, scroll)
    //Dot in the center
    draw_sprite_ext(sprGrenadeBlink, 0, x, y, 1, 1, image_angle * -.7, _c2, 1)

	draw_set_fog(true, _c2, 0, 0)
	with instances_matching_ne(hitme, "team", creator.team) {
		if !instance_is(self, prop) && point_distance(x, y, other.x, other.y) <= r {
			var _xscale = image_xscale * ("right" in self ? right : sign(hspeed));
			draw_sprite_ext(sprite_index, image_index, x - 1, y - 1, _xscale, image_yscale, image_angle, c_white, 1)
			draw_sprite_ext(sprite_index, image_index, x + 1, y - 1, _xscale, image_yscale, image_angle, c_white, 1)
			draw_sprite_ext(sprite_index, image_index, x - 1, y + 1, _xscale, image_yscale, image_angle, c_white, 1)
			draw_sprite_ext(sprite_index, image_index, x + 1, y + 1, _xscale, image_yscale, image_angle, c_white, 1)
		}
	}
	draw_set_fog(false, c_white, 0, 0)

}

#define abris_hit
projectile_hit(other,damage,0,point_direction(x, y, other.x, other.y))
sleep(min(damage * 3, 20))
other.speed = 0


#define collision_line_first(x1,y1,x2,y2,object,prec,notme)
/// collision_line_first(x1,y1,x2,y2,object,prec,notme)
//
//  Returns the instance id of an object colliding with a given line and
//  closest to the first point, or noone if no instance found.
// yo whats up jsburg here, made this shit return the point of collison as the first two indexes of the array, and the instance as the third
//  The solution is found in log2(range) collision checks.
//
//      x1,y2       first point on collision line, real
//      x2,y2       second point on collision line, real
//      object      which objects to look for (or all), real
//      prec        if true, use precise collision checking, bool
//      notme       if true, ignore the calling instance, bool
//
/// GMLscripts.com/license
{
    var ox,oy,dx,dy,object,prec,notme,sx,sy,inst,i;
    ox = argument0;
    oy = argument1;
    dx = argument2;
    dy = argument3;
    object = argument4;
    prec = argument5;
    notme = argument6;
    sx = dx - ox;
    sy = dy - oy;
    inst = collision_line(ox,oy,dx,dy,object,prec,notme);
    if (inst != noone) {
        while ((abs(sx) >= 1) || (abs(sy) >= 1)) {
            sx *= .5;
            sy *= .5;
            i = collision_line(ox,oy,dx,dy,object,prec,notme);
            if (i) {
                dx -= sx;
                dy -= sy;
                inst = i;
            }else{
                dx += sx;
                dy += sy;
            }
        }
    }
    return [dx, dy, inst];
}

#define draw_curve(x1,y1,x2,y2,direction,detail)
// SOURCE: http://www.gmlscripts.com/script/draw_curve
//  Draws a curve between two points with a given starting angle.
//      x1,y1       position of start of curve, real
//      x2,y2       position of end of curve, real
//      direction   start angle of the curve, real
//      detail      number of segments in the curve, real
//var x1, y1, x2, y2, start_angle, detail, dist, dist_ang, inc, draw_x, draw_y;
var start_angle = direction

var dist = point_distance(x1,y1,x2,y2);
var dist_ang = angle_difference(point_direction(x1,y1,x2,y2),start_angle);
var inc = (1/detail);

draw_primitive_begin(pr_linestrip);
for (var i=0; i<1+inc; i+=inc) {
	var draw_x = x1 + (lengthdir_x(i * dist, i * dist_ang + start_angle));
	var draw_y = y1 + (lengthdir_y(i * dist, i * dist_ang + start_angle));
	draw_vertex(draw_x,draw_y);
}
draw_primitive_end();
return 0;


#define create_lightning(_x,_y)
if instance_exists(GameCont) and GameCont.area = 101{
    sleep(150)
    with Player lasthit = [sprLightningDeath,"ELECTROCUTION"]
    with hitme with other projectile_hit(other,7,0,0)
    exit
}
else{
    with instance_create(_x,_y,CustomProjectile){
        vbuf = vertex_create_buffer()
        lightning_refresh()
        hitid = [sprLightningHit,"Lightning Bolt"]
        name = "Lightning Bolt"
        time = skill_get(17) + 4
        timestart = time
        create_frame = current_frame
        colors = [c_black,c_white,c_white,merge_color(c_blue,c_white,.3),c_white]
        wantdust = 1
        damage = 9 + skill_get(17) * 3
        force = 40
        mask_index   = sprPlasmaBall
        image_xscale = 5
        image_yscale = 5
        on_wall    = lightning_wall
        on_draw    = lightning_draw
        on_destroy = lightning_destroy
        on_cleanup = lightning_cleanup
        on_step    = lightning_step
        on_hit     = lightning_hit
        depth = -8

        return id
    }
}
#define lightning_wall
with other{
	instance_create(x,y,FloorExplo)
	instance_destroy()
}

#define lightning_draw
d3d_set_fog(1,colors[min((current_frame - create_frame),array_length_1d(colors)-1)], 0,0)
vertex_submit(vbuf, pr_trianglestrip)
d3d_set_fog(0,0,0,0)
for (var i = 0; i < array_length(ypoints); i++){
	draw_sprite(sprLightningHit,1+irandom(2),xpoints[i],ypoints[i])
	//draw_line_width(xpoints[i],ypoints[i],xpoints[i-1],ypoints[i-1],i/10)
}
#define lightning_hit
if projectile_canhit(other) && current_frame_active{
	projectile_hit_push(other, damage, force)
}


#define lightning_refresh
ypoints = []
xpoints = []
var mmax = 100;
var mmin = -100;
var xx = x;
var yy = y;

var ang = random_range(70,110)
var width = 0.5, length = 10
var bwidth = .5 + brain_active
var n = 0
vertex_begin(vbuf, global.lightningformat)
vertex_position(vbuf, xx, yy)
while yy > y - 2*game_height{
    vertex_position(vbuf, xx + width * ((n mod 2) ? -1 : 1), yy)
    n++
    xx += lengthdir_x(length,ang)
    yy += lengthdir_y(length,ang)
    length = random(6)
    width = (y - yy)/75 + bwidth
    ang = clamp(ang + random_range(7,30) * choose(-1,1) * (min((y-yy), 20))/20,40,140)
    if ang = 40 or ang = 140 ang -= random_range(5,20)*sign(ang - 90)
    if !irandom(5) {
        array_push(xpoints,xx)
        array_push(ypoints,yy)
    }
}
vertex_end(vbuf)
vertex_freeze(vbuf)

#define slope(x1,x2,y1,y2)
return((y2-y1)/(x2-x1))

#define lightning_destroy
for (var i = 1; i < array_length_1d(ypoints); i++){
	if !irandom(4) with instance_create(xpoints[i],ypoints[i],FireFly){
		depth = other.depth
		image_speed/=1.5
		sprite_index = sprLightning
		hspeed += random_range(-.5,.5)
		vspeed += random_range(-.5,.5)
	}
}
lightning_cleanup()

#define lightning_cleanup
vertex_delete_buffer(vbuf)
sound_set_track_position(sndExplosionL,0)

#define lightning_step
view_shake_max_at(x,y,30)
if wantdust != 0{
    repeat(30){
  		with instance_create(x,y,Dust){
  		  motion_set(random(360),3+random(10))
	    }
  	}
    repeat(8){
        with instance_create(x+random_range(-30,30),y+random_range(-30,30),LightningSpawn){
            image_angle = point_direction(other.x,other.y,x,y) + random_range(-8,8)
        }
    }
  	if instance_exists(Floor){
  	    var closeboy = instance_nearest(x,y,Floor);
      	if point_in_rectangle(x,y,closeboy.x-16,closeboy.y-16,closeboy.x+16,closeboy.y+16){
      	    with instance_create(x,y,Scorchmark){
      	        time = 0;
      	        if fork(){
      	            while instance_exists(self) && time < 45{
      	                time += current_time_scale
      	                image_alpha -= current_time_scale/45
      	                if chance(45 - time){
      	                    with instance_create(x,y,Smoke){
      	                        motion_add(90,random_range(1,2))
      	                        image_xscale = (1-(other.time/45)) * random_range(.5,1)
      	                        image_yscale = image_xscale
      	                        gravity = -friction
      	                    }
      	                }
      	                wait(0)
      	            }
      	            if instance_exists(self) instance_destroy()
      	            exit
      	        }
      	    }
      	}
  	}
  	wantdust = 0
}
time -= current_time_scale
if time <= 0 instance_destroy()



#define create_plasmite(_x,_y)
with instance_create(_x, _y, CustomProjectile){
    name = "Plasmite"
    defbloom = {
        xscale : 2,
        yscale : 2,
        alpha : .1
    }
	image_speed = 0
	damage = 4
	sprite_index = brain_active ? spr.PlasmiteUpg : spr.Plasmite
 	fric = random_range(.2, .3)
    force = 2
	maxspeed = 13
	on_step 	 = plasmite_step
	on_wall 	 = plasmite_wall
	on_destroy   = plasmite_destroy
	on_draw      = plasmite_draw
	on_square    = script_ref_create(plasmite_square)

	return id
}

#define plasmite_step
if chance(8 + (6 * brain_active)) instance_create(x, y, PlasmaTrail)

var closeboy = instance_nearest_matching_ne(x, y, hitme, "team", team);
if instance_exists(closeboy) && distance_to_object(closeboy) <= 16 {
	motion_add_ct(direction + 180, 1)
    motion_add_ct(point_direction(x, y, closeboy.x, closeboy.y), 4)
    maxspeed += .5 * current_time_scale
}
image_angle = direction
if speed > maxspeed {
	speed = maxspeed
}
//Check for projectile style
if (!instance_exists(creator) || !instance_is(creator, Player)) || !(creator.race_id == char_eyes && ultra_get("eyes", 2) && (usespec == true || button_pressed(index, "spec"))) {
	maxspeed /= power(1 + fric, current_time_scale)
	if maxspeed <= 1 + fric instance_destroy();
}

#define plasmite_wall
move_bounce_solid(false)
image_angle = direction
var s = audio_play_sound(sndPlasmaHit, 1, 0);
audio_sound_gain(s, .5, 0)
audio_sound_pitch(s, random_range(3, 6))
var n = irandom_range(2, 6), int = 360/n;
for (var i = 0; i < 360; i += int) {
    with mod_script_call("mod", "defparticles", "create_spark", x, y) {
        motion_set(i + random_range(-int/3, int/3), random(8) + 1)
        friction = 1.2
        age = speed
        color = c_white
        fadecolor = c_lime
        gravity = .8
        gravity_direction = other.direction
    }
}

#define plasmite_draw
var _x = image_xscale
image_xscale = _x + (sqr(speed/(sprite_width * 1.5))) * _x
defbloom.xscale = image_xscale * 2
draw_self()
image_xscale = _x;

#define plasmite_destroy
sound_play_hit_ext(sndPlasmaHit, random_range(1.45, 1.83), 1)
with create_plasma_impact_small(x + lengthdir_x(hspeed, direction), y + lengthdir_y(hspeed, direction)) {
	team = other.team;
}

#define create_plasma_impact_small(_x, _y)
with instance_create(_x, _y, PlasmaImpact){
	sprite_index = spr.PlasmaImpactSmall;
	mask_index = msk.PlasmaImpactSmall;
	image_speed *= random_range(.85, 1.15);
	damage = 4;
	return self;
}

#define create_supersquare(_x,_y)
var _lb = skill_get(mut_laser_brain);
with create_square(_x,_y){
    damage = 2
    force = 12
    bounce = 5 + _lb * 2
    image_xscale = 1 + _lb * .3
	image_yscale = 1 + _lb * .3
	sprite_index = spr.SuperSquare
	mask_index 	 = msk.SuperSquare
	anglefac = random_range(0.6,2)
	lifetime += room_speed
	size = 4

	return id
}

#define create_triangle(_x,_y)
with instance_create(_x,_y,CustomProjectile){
    defbloom = {
        xscale : 2,
        yscale : 2,
        alpha : .1
    }
    typ = 1
    name = "Triangle"
    size = 1
    friction = 1.3
    damage = 5
    image_xscale = 1.2
    image_yscale = 1.2
    sprite_index = spr.Triangle
    image_angle = direction - 45
    on_step    = triangle_step
    on_wall    = triangle_wall
    on_destroy = triangle_destroy
    return id
}

#define triangle_step
if friction > speed{instance_destroy()}

#define triangle_wall
instance_destroy()

#define triangle_destroy
sleep(2)
view_shake_at(x,y,8)
sound_play_pitchvol(sndPlasmaHit,random_range(2,3),.4)
var i = direction - 90;
repeat(3){
    with instance_create(x,y,Laser){
        creator = other.creator
        team = other.team
        image_angle = i
        event_perform(ev_alarm,0)
    }
    i += 90
}

#define create_square(_x,_y)
var a = instance_create(_x,_y,CustomSlash);
with a{
    defbloom = {
        xscale : 2,
        yscale : 2,
        alpha : .1
    }
	typ = 0
	name = "Square"
	size = 1
	pseudoteam = -1
	friction = .3
	bounce = 7+skill_get(17)*3
	damage = 1
	minspeed = 2
	maxspeed = 16
	image_xscale = 1+skill_get(17)*.2
	image_yscale = 1+skill_get(17)*.2
	force = 1
	iframes = 0
	anglefac = random_range(0.8,2.5)
	fac = choose(1,-1)
	sprite_index = spr.Square
	mask_index 	 = msk.Square
	hitframes = 0
	lifetime = room_speed * 6
	on_projectile = square_projectile
	on_grenade = nothing
	on_step    = square_step
	on_hit     = square_hit
	on_wall    = square_wall
	on_destroy = square_destroy
	on_square  = script_ref_create(square_square)
	on_anim    = nothing
}
return a;

#define square_destroy
if size > 1{
	var i = random(360);
	repeat(4){
		with create_square(x,y){
			creator = other.creator
			team    = other.pseudoteam
			pseudoteam = team
			size    = 1
			motion_add(i+random_range(-6,6),6)
		}
		i += 360/size
	}
}
sound_play_hit_ext(sndPlasmaHit, random_range(.9, 1.1), 1)
with instance_create(x, y, PlasmaImpact) {
	team = other.pseudoteam;
}

#define square_hit
if other.team != pseudoteam and current_frame_active {
    with other motion_add(point_direction(other.x, other.y, x, y), other.size)
    if speed > minspeed && projectile_canhit_melee(other) == true {
    	projectile_hit(other, round(2 * damage + speed), force, direction)
    }
    else {
    	projectile_hit(other, damage, force, direction)
    };
}

#define square_projectile
if other.team = pseudoteam || ("pseudoteam" in other and other.pseudoteam == pseudoteam){
    if instance_is(other, CustomProjectile){
        if "on_square" in other{
            with other mod_script_call(on_square[0], on_square[1], on_square[2])
        }
    }
    else if instance_is(other, Laser){
        motion_add(other.direction, (2/size) * current_time_scale)
        if current_frame_active
            with instance_create(x + lengthdir_x(random(sprite_width/2), random(360)), y + lengthdir_y(random(sprite_height/2), random(360)), PlasmaTrail)
                motion_set(other.direction, random_range(3, 8))
    }
    else if iframes <= 0 {
        var melee = [EnergySlash, EnergyShank, EnergyHammerSlash];
        var speeds = [12, 9, 17];
        for var i = 0; i <= 2; i++{
            if instance_is(other, melee[i]){
				with instance_create(other.x,other.y,GunGun) image_index=2
				if speed < 20 {
				    direction = other.direction;
				    speed = speeds[i]
				}
				sound_play_hit_ext(sndPlasmaBigExplode, 1.4, 1)
				sound_play_hit_ext(sndPlasmaHit, 2.2, 1)
				if brain_active {
					sound_play_hit_ext(sndPlasmaBigExplodeUpg, 2.2, 1)
				}
				iframes += 10
                break
            }
        }
    }
    if instance_is(other,PlasmaBall) || instance_is(other,PopoPlasmaBall) || instance_is(other,PlasmaHuge) || instance_is(other,PlasmaBig){
        var num = plasmite_count(other.object_index);
        repeat(num[0]){
            with create_plasmite(x, y){
                creator = other.creator
                team = other.pseudoteam
                motion_add(other.direction + random_range(-140, 140), random_range(12, 16) + 6)
                fric += .08
                image_angle = direction
            }
        }
        repeat(num[1]){
            with create_plasmite(x,y){
                creator = other.creator
                team = other.pseudoteam
                motion_add(other.direction+random_range(-20, 20), random_range(16, 20) + 6)
                fric += .08
                image_angle = direction
            }
        }
        instance_destroy();
        exit
    }
}

#define plasmite_count(object)
    switch object{
        case PlasmaBig: return[10, 5]
        case PlasmaHuge: return[12, 6]
        default: return[8, 4]
    }

#define plasmite_square
    motion_set(point_direction(other.x, other.y, x, y), speed + other.size)
    with other motion_add(point_direction(other.x, other.y, x, y), other.damage/(size * 2))
    sound_play_hit_ext(sndPlasmaHit, random_range(3, 6), .3)
    with instance_create(x, y, PlasmaTrail){
    	image_xscale = 2;
    	image_yscale = 2
    }
    image_angle = direction

#define lflak_square
    sound_play_hit_big_ext(sndPlasmaHit, random_range(3, 6), .3)
    repeat(12) with instance_create(x, y, PlasmaTrail){
    	image_index = 0;
    	image_speed = .5;
    	motion_add(other.direction + random_range(-120, 120), random_range(9, 12))
    }
    with other{
        var i = direction + 90;
        repeat(2){
            with create_triangle(x, y){
                creator = other.creator
                team = other.pseudoteam
                motion_add(i, 12)
                if direction > 180 turn = -1 else turn = 1
                image_angle = direction - 45
            }
            i += 180
        }
        instance_destroy()
        exit
    }

#define square_square
    motion_add(point_direction(other.x, other.y, x, y), 7 * (other.size / size))
    repeat(6) with instance_create(x,y,PlasmaTrail){
    	image_index = 0;
    	image_speed = .5;
    	motion_add(other.direction + random_range(-60, 60), random_range(9, 12))
    }
    sound_play_hit_ext(sndPlasmaHit, random_range(.9, 1.1), 1)
    with instance_create(x,y,PlasmaImpact){
    	team = other.pseudoteam;
    	instance_create(x + random_range(-8, 8), y + random_range(-8, 8), Smoke)
    }

#define square_wall
    move_bounce_solid(1)
    sound_play_hit_ext(sndPlasmaHit, random_range(2, 4), .3)
    repeat(3) with instance_create(x,y,PlasmaTrail){
    	image_index = 0;
    	image_speed = .5;
    	motion_add(other.direction + random_range(-30, 30), random_range(6, 8))
    }
    if speed <= minspeed bounce--
    sleep(size * 5)
    view_shake_at(x,y,size * 5)

#define square_step
if team != id{
    pseudoteam = team
    team = id
}
if speed > 2{
	if current_frame_active with instance_create(x + lengthdir_x(random(sprite_width/2), random(360)), y + lengthdir_y(random(sprite_height/2), random(360)), PlasmaTrail){
	    sprite_index = sprPlasmaImpact
		image_index = 2
		image_speed = 0.3 - brain_active * 0.05
		image_xscale = .25
		image_yscale = .25
	}
}
iframes = max(iframes - current_time_scale, 0)
speed = clamp(speed, minspeed, maxspeed)
image_angle += speed * anglefac * fac * current_time_scale
if current_frame_active with instance_create(x + random_range(-8, 8) + lengthdir_x(sprite_width/2, direction - 180), y + random_range(-8, 8) + lengthdir_y(sprite_width/2, direction - 180), PlasmaTrail){
	image_speed = 0.35 - brain_active * 0.05
}
if bounce <= 0 instance_destroy()


#define determine_gore(_id)
	switch (_id.object_index){
		//FEATHER BLEEDERS
		case Raven : return Feather;

		//CURSED BLEEDERS
		case InvSpider  	   :
		case InvCrystal      :
		case InvLaserCrystal : return Curse;

		//CRYSTAL BLEEDERS
		case LaserCrystal :
		case HyperCrystal :
		case CrystalProp  :
		case Spider		    :
		case RhinoFreak	  : return Hammerhead;

		//WHITE BLEEDERS
		case YVStatue :
		case BigSkull :
		case SnowMan  : return MeleeHitWall;

		//ROBOT BLEEDERS
		case SnowBot       :
		case SnowTank      :
		case GoldSnowTank  :
		case Barrel        :
		case OasisBarrel   :
		case ToxicBarrel   :
		case Wolf          :
		case StreetLight   :
		case SodaMachine   :
		case Hydrant	     :
		case Turret	       :
		case TechnoMancer  :
		case Terminal      :
		case MutantTube    :
		case DogMissile    :
		case Sniper        :
		case Car           :
		case Pipe          :
		case Anchor 	     :
		case WaterMine	   :
		case VenuzTV       :
		case CarVenus	     :
		case CarVenus2	   :
		case CarVenusFixed :
		case Van		       : return BulletHit;

		//LIGHTNING BLEEDERS
		case LightningCrystal : return LightningSpawn;

		// BIG BLEEDERS
		case JungleFly  :
		case BigMaggot  :
		case BanditBoss : return BloodGamble;

		//BIG GREEN BLEEDERS
		case Scorpion 	:
		case GoldScorpion :
		case GoldScorpion : return AcidStreak;

		// ULTRA BOYS
		case EnemyHorror      :
		case CrownGuardianOld :
		case CrownGuardian    :
		case Guardian         :
		case GhostGuardian    :
		case ExploGuardian    :
		case DogGuardian      : return ScorpionBulletHit;

		default : return AllyDamage;
	}

#define laserflak_hit
if projectile_canhit_melee(other) == true{
	projectile_hit(other, damage, ammo, direction)
	repeat(3) with instance_create(x, y, PlasmaTrail){
		view_shake_at(x, y, 3)
		motion_add(random(180), random_range(7, 8))
	}
	sleep(damage * 2)
	if other.my_health > 0 {

		instance_destroy();
	}else {

		with create_plasma_impact_small(x, y) {

			creator = other.creator;
			team = other.team;
		}
	}
}

//SPIKEBALL
#define create_minispikeball(_x,_y)
with create_spikeball(_x, _y){
    name = "Mini Spikeball"
    damage = 1
    force = 3
    size = 2
    sprite_index = spr.MiniSpikeball
    mask_index   = msk.MiniSpikeball

    return id
}

#define create_spikeball(_x,_y)
with instance_create(_x,_y,CustomSlash){
    typ  = 1
    name = "Spikeball"
    damage = 5
    force = 6
    size = 4
    bounce = 0
    hitframes = 0
    sprite_index = spr.Spikeball
    mask_index   = msk.Spikeball

    on_hit        = spike_hit
    on_wall       = spike_wall
    on_step       = spike_step
    on_projectile = spike_projectile
    on_anim       = nothing

    return id
}

#define create_heavyspikeball(x, y)
with create_spikeball(x, y){
    name = "Heavy Spikeball"
    damage = 10
    force = 8
    size = 10
    sprite_index = spr.HeavySpikeball
    mask_index = msk.HeavySpikeball
    return id
}

#define spike_hit
if other.id != creator{
    projectile_hit(other,damage,force,direction)
    if other.size > size{motion_set(point_direction(other.x,other.y,x,y),speed)}
    x -= hspeed
    y -= vspeed
}
else{
    damage += 1
    projectile_hit(other,damage,force,direction)
    instance_destroy()
    exit
}
hitframes++
if hitframes >= 10 instance_destroy()

#define spike_wall
sound_play_pitchvol(sndHitRock,random_range(.6,.8),.3)
//sound_play_pitch(sndHitMetal,random_range(1.3,1.5))
sleep(size*6)
view_shake_at(x,y,4*size)
repeat(size)instance_create(x,y,Dust)
move_bounce_solid(false)
image_speed = speed/10
direction += random_range(-12,12)
if ++bounce >= 5 instance_destroy()

#define spike_step
with instance_create(x-lengthdir_x(speed,direction),y-lengthdir_y(speed,direction),BoltTrail){
    image_angle = other.direction
    image_yscale = other.size / 3
    image_xscale = other.speed
}
#define spike_projectile
//with other if typ > 0 instance_destroy()

//LASER FLAK
#define create_laser_flak(_x,_y)
with instance_create(_x,_y,CustomProjectile) {
    name = "Laser Flak"
	image_speed = 1
	damage = 10
	friction = .5
	ammo = 5 + skill_get(mut_laser_brain) * 3;
	typ = 1
	size = 1
	sprite_index = spr.LaserFlakBullet
	mask_index = mskFlakBullet
	on_hit      = laserflak_hit
	on_step     = laserflak_step
	on_destroy  = laserflak_destroy
	on_square   = script_ref_create(lflak_square)
	defbloom = {
        xscale : 1.5 + brain_active,
        yscale : 1.5 + brain_active,
        alpha : .1 + brain_active * .025
    }

    return id
}

#define laserflak_destroy
with instance_create(x, y, GunGun){image_index = 2; image_angle = random(360)}
sleep(15)
view_shake_max_at(x,y,24)
with instance_create(x, y, PlasmaImpact){
	team = other.team;
	image_speed = .6;
}
sound_play(sndPlasmaHit)
var i = random(360);
var _p = random_range(.8,1.2);
sound_play_pitch(sndBouncerSmg,.4*_p)
sound_play_pitch(sndSlugger,.5*_p)
sound_play_pitch(sndPlasma,.8*_p)
sound_play_pitch(sndPlasmaHit,random_range(.6,.8))
sound_play_pitch(sndLaser,random_range(.5,.6))
sound_play_pitch(sndExplosionS,random_range(1.2,1.5))
repeat(ammo){
	sleep(10)
	repeat(2) with instance_create(x,y,CustomObject){
		motion_add(random(360),random_range(5,12))
		sprite_index = sprPlasmaTrail
		image_speed  = random_range(.3, .4);
		defbloom = {
	        xscale : 1.5 + brain_active,
	        yscale : 1.5 + brain_active,
	        alpha : .1 + brain_active * .025
	    }

		on_step = laserflak_particle_step
	}

	if size > 1{
		with instance_create(x,y,PlasmaImpact){
			creator = other.creator
			team = other.team
			var _scale = random_range(.2,.3);
			motion_add(random(360),12)
			friction = random_range(.3,1.2)
			image_xscale = _scale
			image_yscale = _scale
		}
	}
	with instance_create(x,y,Laser){
	    creator = other.creator
		image_angle = i+random_range(-32,32)*other.accuracy
		direction = image_angle
		team = other.team
		event_perform(ev_alarm,0)
	}
	i += 360/ammo
}

#define laserflak_particle_step
	if !place_meeting(x, y, Floor) || image_index + image_speed >= 3{instance_destroy(); exit}

#define laserflak_step
image_speed = speed * 1.2 / 14
if chance(66){
	with instance_create(x+random_range(-8,8),y+random_range(-8,8),PlasmaTrail){
		image_xscale += brain_active / 3
		image_yscale = image_xscale
	}
	if size > 1{
		with instance_create(x+random_range(-12,12),y+random_range(-12,12),PlasmaImpact){
			creator = other.creator
			team = other.team
			var _scale = random_range(.2,.3);
			with Smoke if place_meeting(x,y,other) instance_destroy()
			depth = other.depth+1
			image_xscale = _scale
			image_yscale = _scale
		}
	}
}
if speed < friction instance_destroy()

#define quartz_pickup_create(_x, _y)
	_obj = instance_create(_x, _y, Pickup);
	with _obj
	{
		name = "QuartzPickup";
		sprite_index = spr.QuartzPickup
		mask_index   = mskPickup
		image_speed  = 0
		friction = .2
		num = 1
		anim = 20 + irandom(30)
		if (irandom(9) + 1) <= skill_get(mut_rabbit_paw) * 4 instance_create(x, y, RabbitPaw)
		lifetime = room_speed * 6 - (crown_current = 4 ? room_speed * 2 : 0) + irandom(15)
		on_pickup = quartz_pickup_open
	}
	return _obj;

#define quartz_pickup_open
	var _pitch = random_range(.9, 1.1);
	sound_play_pitch(skill_get(mut_second_stomach) > 0 ? sndHPPickupBig : sndHPPickup, 1.5 * _pitch);
	sound_play_pitchvol(sndHyperCrystalSearch, 6 * _pitch, .9)

	var _p = instance_nearest(x, y, Player),
	    _q = self;
	with _p{
		if is_object(_p.wep) && "is_quartz" in _p.wep{
			var _val = ((irandom(99) + 1) < frac(_q.num) * 100) + (_q.num - frac(_q.num)) + ((irandom(99) + 1) < frac(skill_get(mut_second_stomach)) * 100) + (skill_get(mut_second_stomach) - frac(skill_get(mut_second_stomach))),
				  _str = `+` + string(_val) + ` @(color:${make_colour_rgb(201, 223, 255)})QUARTZ @wHP`;

			_p.wep.health += _val;

			_p.wep.shinebonus += 20

			if _p.wep.health >= _p.wep.maxhealth{
				_p.wep.health = _p.wep.maxhealth;
				_str = `MAX @(color:${make_colour_rgb(201, 223, 255)})QUARTZ @wHP`;
			}else{
				_p.gunshine = 6;
			}

			with instance_create(_p.x, _p.y, PopupText){
				mytext = _str;
			}
		}
		if is_object(_p.bwep) && "is_quartz" in _p.bwep{
			var _val = ((irandom(99) + 1) < frac(_q.num) * 100) + (_q.num - frac(_q.num)),
				  _str = `+` + string(_val) + ` @(color:${make_colour_rgb(201, 223, 255)})QUARTZ @wHP`;

			_p.bwep.health += _val;
			_p.gunshine = 6;

			if _p.bwep.health >= _p.bwep.maxhealth{
				_p.bwep.health = _p.bwep.maxhealth;
				_str = `MAX @(color:${make_colour_rgb(201, 223, 255)})QUARTZ @wHP`;
			}

			with instance_create(_p.x, _p.y, PopupText){
				mytext = _str;
			}
		}
	}

#define quartz_step(_creator, _w)
	
	if (is_object(_w) && "is_quartz" in _w && _w.is_quartz = true) {
		_w.prevhealth = _creator.my_health;
	
		if (_w.health < _w.maxhealth) {
			
			with AmmoPickup {
				
				var _chance = random(99) < (19 * (1 - _w.health/_w.maxhealth));
				if ("quartz_check" not in self && _chance) {
					quartz_pickup_create(x, y);
					
					instance_delete(self);
					exit;
				}
				quartz_check = true;
			}
		}

	}

#define instances_meeting(_x, _y, _obj)
		var _tx = x,
		    _ty = y;

		    x = _x;
		    y = _y;
		    var r = instances_matching_ne(instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", bbox_left), "bbox_left", bbox_right), "bbox_bottom", bbox_top), "bbox_top", bbox_bottom), "id", id);
		    x = _tx;
		    y = _ty;
				return r;

#define quartz_penalty(_mod, _w, _p) //this is for player step only stupid
	if is_object(_w) && "is_quartz" in _w && _w.is_quartz = true{
		if wep.shinebonus > 0{
			wep.shinebonus -= current_time_scale;
		}
		if chance(6 + (wep.shinebonus > 0 ? 73 : 0)){
			var _spr = weapon_get_sprite(wep),
			    _wth = sprite_get_width(_spr) - sprite_get_xoffset(_spr),
			    _hth = sprite_get_width(_spr) - sprite_get_yoffset(_spr);
		  with instance_create(x + lengthdir_x(random(_wth), wepangle + gunangle) + random_range(-3, 3), y + lengthdir_y(random(_hth), wepangle + gunangle) + random_range(-3, 3),WepSwap){
		    image_xscale = .75
		    image_yscale = .75
		    image_speed = choose(.7,.7,.7,.45)
		  }
		}

		if _w.prevhealth > my_health {
			if _w.wep = _mod{
				_w.health--;
				if _w.health < 0{
		    	quartz_break();
			    with instance_create(x,y,ThrownWep) {

			      wep = "shard"
			      sprite_index = spr.Shard
						roll = false;
			      curse = _p ? other.curse : other.bcurse
			      motion_set(other.gunangle-180-random_range(-2,2),3)
			    }
					if _p {
				    wep = bwep
				    bwep = 0
				    curse = bcurse
				    bcurse = 0
						if is_object(wep) && lq_defget(wep, "is_quartz", false){
							quartz_penalty(_mod, wep, _p);
						}
					}
				}else{
					quartz_hurt();
				}
		  }
		}
	}

#define quartz_hurt()
	var _pitch = random_range(.9,1.1);
	sound_play_pitchvol(sndCrystalTB, 1.8, 2 * _pitch);
	sound_play_pitch(sndLaserCrystalHit, .7 * _pitch);
	sound_play_pitch(sndHyperCrystalHurt, 1.4 * _pitch);
	sleep(250);
	view_shake_at(x,y,8)
	repeat(5) with instance_create(x,y,Feather){
		motion_add(random(360),random_range(2,4))
		sprite_index = spr.GlassShard
		image_speed = random_range(.4,.7)
		image_index = irandom(5)
	}
	repeat(8) with instance_create(x+random_range(-8,8),y+random_range(-8,8),WepSwap){
		image_xscale = .75
		image_yscale = .75
		image_speed = choose(.7,.7,.7,.45)
		motion_add(random(360), random_range(4, 7))
	}

#define quartz_break()
	var _pitch = random_range(.9,1.1)
	sound_play_pitch(sndHyperCrystalHurt,.8*_pitch)
	sound_play_pitch(sndLaserCrystalHit,.7*_pitch)
	sound_play_pitchvol(sndHyperCrystalHalfHP,2*_pitch,.4)
	sound_play_gun(sndLaserCrystalDeath,.1,.0001)//mute action
	sleep(400)
	view_shake_at(x,y,45)
	repeat(14) with instance_create(x,y,Feather) {

		motion_add(random(360),random_range(3,6))
		sprite_index = spr.GlassShard
		image_speed = random_range(.4,.7)
		image_index = irandom(5)
	}
	repeat(12)with instance_create(x+random_range(-8,8),y+random_range(-8,8),WepSwap) {
		image_xscale = .75
		image_yscale = .75
		image_speed = choose(.45,.45,.45,.3)
		motion_add(random(360), random_range(2, 3))
	}

#define crit() //add this to on_hit effects in order to not be stupid
	var _t = team;
	view_shake_max_at(x, y, 90)
	sleep(50)
	sound_play_pitchvol(sndHammerHeadEnd,random_range(1.23,1.33),20)
	sound_play_pitchvol(sndBasicUltra,random_range(0.9,1.1),20)
	sound_play_pitch(sndCoopUltraA,random_range(3.8,4.05))
	sound_play_pitch(sndBasicUltra,random_range(.6,.8))
	sound_play_gun(sndClickBack,1,.5)
	sound_stop(sndClickBack)
	with instance_create(other.x,other.y,CustomObject){
	    with instance_create(x,y,CustomSlash){
	        lifetime = 4
	        team = _t
	        image_xscale = 1
	        image_yscale = 1
	        sprite_index  = sprPortalShock
	        image_blend = c_black
	        image_speed = 0
	        image_alpha = 0
	        damage = 5
	        force  = 10
	        on_projectile = crit_proj
	        on_step       = crit_step
	        on_wall       = nothing
	        on_hit        = crit_hit
	    }
	    image_angle = random(360)
	    depth = other.depth -1
	    image_speed = .7
	    sprite_index = spr.KillslashL
	    on_step = Killslash_step
	    with instance_create(x,y,CustomObject){
	        image_angle = other.image_angle - 90 + random_range(-8,8)
	        depth = other.depth+1
	        image_speed = .45
	        sprite_index = spr.Killslash
	        image_blend = c_black
	        on_step = Killslash_step
	    }
	}

#define Killslash_step
	if image_index = 1.2 sleep(100)
	if image_index >= 7 instance_destroy();

#define crit_proj
	with other if typ != 0{
		var  _s = other,
		    _xx = (_s.bbox_left+_s.bbox_right)/2,
				_yy = (_s.bbox_top+_s.bbox_bottom)/2;
		with instance_create(x, y, PlasmaTrail){
			image_index  = floor(point_distance(_xx, _yy, other.x, other.y) / (sprite_get_width(sprite_index) / 2)) * 5;
			sprite_index = spr.KillslashKill;
			image_alpha  = .8;
			image_xscale = min(.8 + other.damage / 20, 1.5);
			image_yscale = image_xscale;
			image_speed  = random_range(.5, .7);
		}
	  instance_destroy()
	}

#define crit_step
	if lifetime > 0 lifetime -= current_time_scale else instance_destroy()

#define crit_hit
	if projectile_canhit_melee(other){
	    projectile_hit(other, damage, force, point_direction(x, y, other.x, other.y,))
	}

#define create_miniexplosion(_x, _y)
with instance_create(_x, _y, CustomProjectile){
    name = "Mini Explosion"
    sprite_index = sprSmallExplosion
    mask_index   = mskSmallExplosion
    image_xscale = .5
    image_yscale = .5
    image_speed = .4
    damage = 2
    force = 4
    team = other.team
    sound_play_pitchvol(sndExplosion, 2 * random_range(.8, 1.2), .2)
    hitid = [sprite_index, "MINI EXPLOSION"]
    on_anim = explo_anim
    on_hit = explo_hit

    return id
}

#define explo_hit
var dmg = damage;
if instance_is(other, Player) and skill_get(mut_boiling_veins) dmg = max(min(other.my_health - other.boilcap, damage), 0)
projectile_hit(other, dmg, force, point_direction(x, y, other.x, other.y))

#define explo_anim
instance_destroy()


#define disc_init
typ = 1
dist = 0
depth = -2
lastteam = -1
teamset = false;
mask_index = mskDisc
spr_trail = sprDiscTrail
spr_dead = sprDiscDisappear
hitid = [sprite_index, name]
on_destroy = disc_destroy

#define disc_step(dis)
	dist += dis * current_time_scale;
	if speed > 0 and current_frame_active with instance_create(x, y, DiscTrail) {

	        sprite_index = other.spr_trail;
	        depth = -1;
	    }

	if instance_exists(creator) && !teamset && !place_meeting(x,y,creator) {
	    team = -1;
			teamset = true;
	}

#define disc_destroy()
	sound_play_hit(sndDiscDie, .2)
	with instance_create(x, y, DiscTrail)
	    sprite_index = other.spr_dead

#define create_bouncerdisc(_x,_y)
	with instance_create(_x,_y,CustomProjectile) {
	    damage = 2
	    image_speed = .5
	    name = "Bouncer Disc"
	    sprite_index = spr.BouncerDisc

	    disc_init()

	    on_step = bouncerdisc_step
	    on_hit = bouncerdisc_hit
	    on_wall = bouncerdisc_wall

	    return id
	}

#define bouncerdisc_step
	disc_step(speed / 4);
	if skill_get(mut_bolt_marrow) {

	    var q = instance_nearest_matching_ne(x, y, enemy, "team", team);
	    if instance_exists(q) {

	        if distance_to_object(q) < 32 {

							var _s = speed;
			        motion_add(point_direction(x, y, q.x, q.y), 1.2 * current_time_scale);
							speed = _s;

	        }
	    }
	}

#define bouncerdisc_hit
	projectile_hit(other,damage+floor(speed/2),5,direction)
	if other.my_health > 0{
	    direction = point_direction(other.x,other.y,x,y)
	    if speed < 12 speed += .6
	}
	sound_play_pitch(sndDiscBounce,random_range(.8,1.2))
	sound_play_pitch(sndBouncerBounce,random_range(1,1))
	image_angle = direction

#define bouncerdisc_wall
	move_bounce_solid(false)
	direction += random_range(-6,6)
	instance_create(x,y,DiscBounce)
	image_angle = direction
	sound_play_pitch(sndDiscBounce,random_range(.9,1.1)+((speed/4)-1)*.2)
	sound_play_pitch(sndBouncerBounce,random_range(1,1))
	if dist > 250{instance_destroy();exit}
	if speed < 12{speed+=.6}


#define create_stickydisc(_x,_y)
	with instance_create(_x, _y, CustomProjectile){
	    damage = 4
	    image_speed = .4
	    name = "Sticky Disc"
	    sprite_index = spr.StickyDisc

	    disc_init()

	    stuckto = -4
	    orspeed = 0
	    depth = -3
	    on_step    = stickydisc_step
	    on_hit     = stickydisc_hit
	    on_wall    = stickydisc_wall

	    return id
	}

#define stickydisc_step
	disc_step(1)
	if dist > 200{instance_destroy();exit}

if instance_exists(stuckto){
    x = stuckto.x - xoff + stuckto.hspeed_raw
    y = stuckto.y - yoff + stuckto.vspeed_raw
    xprevious = x
    yprevious = y
    if current_frame_active instance_create(x,y,Dust)
}
else if skill_get(mut_bolt_marrow) {

		var q = instance_nearest_matching_ne(x, y, enemy, "team", team);
		if instance_exists(q) {

				if distance_to_object(q) < 32 {

						var _s = speed;
						motion_add(point_direction(x, y, q.x, q.y), .8 * current_time_scale);
						speed = _s;

				}
		}
}

#define stickydisc_hit
var _dmg = instance_is(other, Player) = true ? 1 : damage;
if projectile_canhit_melee(other){
    sound_play_hit(sndDiscHit,.2)
    projectile_hit(other, _dmg, 5, direction)
    if other.my_health > 0{
        if stuckto != other{
            stuckto = other
            xoff = (other.x - x)/2
            yoff = (other.y - y)/2
            sound_play(sndGrenadeStickWall)
            repeat(12){with instance_create(x,y,Smoke){depth = -4}}
        }
    }
    else {
        speed = orspeed
        stuckto = -4
    }
}

#define stickydisc_wall
if !instance_exists(stuckto) sound_play_hit(sndDiscBounce,.2)
move_bounce_solid(true)


#define create_megadisc(_x, _y)
	with instance_create(_x, _y, CustomProjectile){
			name = "Mega Disc";
			disc_init();

			sprite_index = spr.MegaDisc;
			mask_index   = sprite_index
			spr_trail    = spr.MegaDiscTrail;
			spr_dead     = spr.MegaDiscDie;
			spr_splat    = mskNone;

	    damage = 2
	    maxspeed = speed
			turn = irandom(99) < 10 ? -1 : 1; // What direction to turn towards, reflects percentage of left-handed population
			image_yscale *= turn * -1;        // so it always cuts properly
			cansplat = true;                  // If a blood splat has been applied yet
			hitid = [spr.MegaDiscHitId, name];

	    on_step    = md_step;
	    on_wall    = md_wall;
	    on_hit     = md_hit;
	    on_destroy = md_destroy;
			on_draw    = md_draw;

	    return id;
	}

#define md_step
	disc_step(1);

	image_angle += turn * (12 + speed) * current_time_scale;

	if skill_get(21) {

	    var q = instance_nearest_matching_ne(x, y, hitme, "team", team);
	    if instance_exists(q) && distance_to_object(q) <= 40 {

	        motion_add(point_direction(x, y, q.x, q.y), .5 * current_time_scale);
	        speed = maxspeed;
	    }
	}

#define md_wall
	dist += 5;
	view_shake_at(x, y, 2);
	sound_play_pitchvol(sndDiscBounce, random_range(.7, .9), .7);
	move_bounce_solid(false);
	direction += random_range(-4, 4);
	with other {

		instance_create(x, y, FloorExplo);
		instance_destroy();
	}
	with instance_create(x, y, DiscBounce) {

	    sprite_index = spr.MegaDiscBounce;
	}
	if dist >= 200 instance_destroy();

#define md_destroy
	sound_play_pitchvol(sndDiscDie, random_range(.6, .8), .4);
	with instance_create(x, y, DiscDisappear) {

	    sprite_index = spr.MegaDiscDie;
	}

#define md_hit
	if current_frame_active {

	    if place_meeting(x,y,creator) {

	        other.lasthit = hitid;
	        sleep(3 * other.size + 4);
	    }

			x -= hspeed / 2;
	    y -= vspeed / 2;
	    projectile_hit(other, damage, speed / 4, direction);
	    if other.my_health <= 0 {

				sleep( 32 + 12 * clamp(other.size, 1, 3));
				view_shake_at(x, y, 5 + 3 * clamp(other.size, 1, 3));
				with instance_create(x + hspeed, y + vspeed, determine_gore(other)) {

					image_angle = _d + 360 / _a * _i;
				}
				sound_play_pitch(sndDiscHit, .9);
				if cansplat && !instance_is(other, prop) {

					cansplat = false;
					spr_splat = spr.MegaDiscSplat[irandom(max(array_length(spr.MegaDiscSplat) - 1, 0))];
					for(var _i = 0, _a = 3, _d = random(360); _i < _a; _i++) {

						with instance_create(other.x, other.y, determine_gore(other)) {

								image_angle = _d + 360 / _a * _i;
						}
					}
				}
	    }
			image_angle -= turn * 2 * current_time_scale;
	    dist++;
	}

#define md_draw
	draw_self();
	draw_sprite_ext(spr_splat, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

#define create_knife(x, y)
with create_sword(x, y){
    name = "Knife"
    damage = 12
    force = 3
    mask_index   = mskBolt
    sprite_index = spr.Knife
    spr_dead     = spr.KnifeStick
    maxwhoosh = 3
    bounce = round(skill_get("compoundelbow") * 5)
    anglespeed = 120

    defbloom.sprite = sprite_index
    slashrange = 20
    length = 4

    return id
}

#define create_sword(x, y)
var melee = 1;
with instance_create(x, y, melee ? CustomSlash : CustomProjectile){
    name = "Sword"
    damage = 25
    force  = 6
    typ = 1
    sprite_index = spr.Sword
    mask_index   = mskHeavyBolt
    spr_dead     = spr.SwordStick

    defbloom = {
        xscale : 1.5,
        yscale : 1.5,
        alpha : .2,
        sprite : spr.Sword,
        angle : 0
    }
    draw_angle = random(360)
    anglespeed = 90
    slashrange = 32
    length = 6
    whooshtime = 0
    maxwhoosh = 4
    bounce = round(skill_get("compoundelbow") * 5)

    if melee{
        on_anim = nothing
        on_projectile = sword_proj
        on_grenade = sword_proj
    }

    on_wall = sword_wall
    on_hit  = sword_hit
    on_step = sword_step
    on_end_step = sword_end_step
    on_draw = sword_draw

    return id
}

#define sword_proj
with other if typ > 0 instance_destroy()

#define sword_draw
draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, draw_angle + image_angle, image_blend, image_alpha)

#define sword_step
var aspeed = anglespeed * sign(hspeed) * current_time_scale;
draw_angle -= aspeed;
defbloom.angle = draw_angle + image_angle;

if skill_get(mut_bolt_marrow){
    var q = instance_nearest_matching_ne(x, y, hitme, "team", team)
    if instance_exists(q) and q.mask_index != mskNone and point_distance(x, y, q.x, q.y) <= 20 * skill_get(mut_bolt_marrow) * 2 - length/6{
        x = q.x - hspeed_raw
        y = q.y - vspeed_raw
    }
}
whooshtime = (whooshtime + current_time_scale) mod maxwhoosh
if whooshtime < current_time_scale audio_play_ext(sndMeleeFlip, x, y, max(.4, 2 - length/6 + random_range(-.1, .1) + (skill_get("compoundelbow") > 0 ? .3 : 0)), length/8, 0);

#define sword_end_step
var e = 0, w = 1.5;
repeat(2){
    var aspeed = anglespeed * sign(hspeed) * current_time_scale;
    var a = draw_angle + image_angle - 45 * sign(image_yscale) + e, l = length;
    var c = 3;
    var _x2 = x + lengthdir_x(l, a), _y2 = y + lengthdir_y(l, a);
    for var i = 1; i <= c; i++{
        var _x = lerp(x, xprevious, i/c) + lengthdir_x(l, a + aspeed * i/c), _y = lerp(y, yprevious, i/c) + lengthdir_y(l, a + aspeed * i/c);
        with instance_create(_x2, _y2, BoltTrail){
            image_yscale = w - .2*i/c
            image_xscale = point_distance(x, y, _x, _y)
            image_angle = point_direction(x, y, _x, _y)
        }
        _x2 = _x
        _y2 = _y
    }
    w /= 2
    e += 180
}

#define sword_wall
var _p = random_range(.9, 1.2);
if bounce > 0 {
	bounce--
	sleep(1)
	repeat(4){
		instance_create(x, y, Dust)
	}
	sound_play_hit_ext(sndDiscBounce, 2 * _p, .4)
	sound_play_hit_ext(sndChickenSword, 1.5 * _p, .3)
	move_bounce_solid(false)
	speed *= .85 + (skill_get("compoundelbow") > 0 ? .08 : 0);
	length *= 1.1 - (skill_get("compoundelbow") > 0 ? .05 : 0);
	direction += random_range(-7,7)
	with instance_create(x, y, MeleeHitWall) {
		image_angle = other.direction - 180
	}
}
else {
	sound_play_hit_ext(sndChickenSword, 1.3 * _p, .3)
	sound_play_hit_ext(sndBoltHitWall, .8 * _p, .4)
	sleep(4)
	view_shake_at(x, y, 1 + force)
	with instance_create(x, y, CustomObject){
	    sprite_index = other.spr_dead
	    image_angle = other.direction
	    move_contact_solid(image_angle, 0)
	    x += lengthdir_x(other.length, image_angle)
	    y += lengthdir_y(other.length, image_angle)
	    repeat(12){
	        with instance_create(x, y, Dust){
	            direction = other.image_angle + 180 + random_range(-35,35)
	            speed = random(5)+1
	            depth = choose(1,-1)
	        }
	    }
	    if fork(){
	        wait(45)
	        if instance_exists(self) instance_destroy()
	        exit
	    }
	    other.x = x
	    other.y = y
	}
	sword_end_step()
	instance_destroy()
}

#define sword_hit
var d = other.my_health > damage/2;
var a = other;
sleep(force * 5)
view_shake_max_at(x, y, force * 5)
projectile_hit(other, damage, force, direction)
with instance_create(x, y, AcidStreak){sprite_index = spr.SwordImpact; image_angle = other.direction; image_speed = .5}
other.x += 10000
var q = instance_nearest_matching_ne(x, y, hitme, "team", team)
if instance_exists(q) and q != other and q.mask_index != mskNone and distance_to_object(q) < slashrange{
    projectile_hit(q, damage, force, point_direction(x, y, q.x, q.y))
    with instance_create(q.x, q.y, CustomObject){
	    sound_play_hit_ext(sndChickenSword, 1.4*random_range(.9,1.2), .8)
			sound_play_pitchvol(sndDiscDie, 1.5*random_range(.9,1.2), .8)
	    instance_destroy()
    }
    with instance_create(q.x, q.y, CustomObject){
        sprite_index = spr.SwordSlash
        image_angle = point_direction(other.x, other.y, q.x, q.y)
        image_speed = .6
        image_yscale = -2
        depth = -3
        sleep(30)
        view_shake_max_at(x, y, 7)
        on_step = slasheffect_step
    }
}
other.x -= 10000
if d {
    with instance_create(x, y, BoltStick){
        sprite_index = other.spr_dead
        target = a
        image_angle = other.direction
    }
    sword_end_step()
    instance_destroy()
}

#define slasheffect_step
if image_index + image_speed*current_time_scale > image_number instance_destroy()

#define create_gas_fire(x, y)
with instance_create(x, y, Flame) {

	damage += 1;
	can_ignite = true;
	sprite_index = spr.GasFire;
	return self;
}

#define create_charge_obj(x, y)
	with instance_create(x, y, CustomObject) {
		name = "DefpackChargeObject"
		parent = name
		defpackChargeObject = true
		creator = -4

		charge = 0
		charged = 0
		chargeSpeed = 1
		maxCharge = 100

		index = -1
		hand = -1
		btn = "fire"

		reload = -1
		type = 0
		cost = 0

	    defcharge = {
	        style: defcharge_bar,
	        charge: 0,
	        maxcharge: maxcharge,
	        width : 16
	    }

	}

#define get_firing_context(instance)
	// Assumptions in place;
	// - Anything that calls a fire script has gunangle and accuracy (no backup checks on these values)
	// - Firing a weapon from an object with gunangle means that they aim over time, with an offset based on what angle FireCont was firing at
	// - Anything with a valid player index ([0, 4]) is looking to use button inputs over time
	// - FireCont does not continue to be responsible for effects over time, that goes to its creator

	var _isFireCont = instance_is(instance, FireCont),
		_creator = (_isFireCont && "creator" in instance) ? instance.creator : instance,
		_isPlayer = instance_is(_creator, Player),
		_creatorCanAim = "gunangle" in _creator,
		_accuracy = "accuracy" in _creator ? _creator.accuracy : instance.accuracy,
		_aimOffset = (_creatorCanAim && _isFireCont) ? angle_difference(instance.gunangle, _creator.gunangle) : 0;

	return {
		is_firecont : instance_is(self, FireCont)
	}



#define create_sniper_charge(x, y)
with instance_create(x, y, CustomObject){
	name    = "SniperCharge"
	parent  = name
	creator = -4
	charge  = 0
	acc     = .75
	charged = 1
	maxcharge = 100
	chargespeed = 3.2
	holdtime = 150
	amount   = 1;
	deviation = 0;
	is_super = false;
	depth  = TopCont.depth
	index  = -1
	reload = -1
	cost = 0
    spr_flash  = sprBullet1
    defcharge = {
        style: defcharge_bar,
        charge: 0,
        maxcharge: maxcharge,
        width : 16
    }

	on_step    = snipercharge_step
	on_cleanup = snipercharge_delete
	on_destroy = snipercharge_destroy
	on_fire = script_ref_create(snipercharge_fire)
	btn = other.specfiring ? "spec" : "fire"
	hand = -1

    return id
}

#define snipercharge_delete
view_pan_factor[index] = undefined
for (var i=0; i<maxp; i++){player_set_show_cursor(index,i,1)}


#define snipercharge_step
var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
if !instance_exists(creator){instance_destroy();exit}
if hand == -1 {
    if instance_is(creator, Player){
        if creator.race == "steroids" and btn = "spec" hand = 1
        else hand = 0
    }
}
if button_check(index,"swap"){creator.ammo[1] = min(creator.ammo[1] + cost, creator.typ_amax[1]);instance_destroy();exit}
if reload = -1{
    reload = (hand ? creator.breload : creator.reload) + creator.reloadspeed * timescale
}
else{
    if hand creator.breload = max(reload, creator.breload)
    else creator.reload = max(reload, creator.reload)
}

charge += timescale * chargespeed / acc
if charge > maxcharge{
	charge = maxcharge
	if charged > 0{
        sound_play_pitch(sndSniperTarget,1.2)
        weapon_charged(creator, 24)
	}
	charged = 0
}
defcharge.charge = charge

if charged = 0{

	creator.speed *= .9;
	if holdtime >= 60 {var _m = 5}else{var _m = 3}
	if current_frame mod _m < current_time_scale{
	    creator.gunshine = 1
	    defcharge.blinked = 1
	}
	with creator with instance_create(x,y,Dust){
		motion_add(random(360),random_range(2,3))
	}
	holdtime -= timescale
}
view_pan_factor[index] = 2.1+charged/10
sound_play_pitchvol(sndFlameCannonLoop,10-charge/10,1)
x = mouse_x[index]
y = mouse_y[index]
for (var i=0; i<maxp; i++){player_set_show_cursor(index,i,0)}
if button_check(index, btn) = false || holdtime <= 0
{
    sound_stop(sndFlameCannonLoop)
	with instance_create(creator.x,creator.y,CustomObject){
	    time = 1
		move_contact_solid(other.creator.gunangle, 24)
		image_angle = other.creator.gunangle
		depth = -1
		sprite_index = other.spr_flash
		image_speed = 1
		on_step = muzzle_step
		on_draw = muzzle_draw
	}
    script_ref_call_self(on_fire)
    if !instance_exists(self) exit
	instance_destroy()
}
else {
    sound_play_gun(sndFootOrgSand4,1,.00001)
    sound_stop(sndFootOrgSand4)
}

#define snipercharge_destroy
snipercharge_delete()


#define snipercharge_fire
//default sniper shot
if amount <= 1{
var _ptch = random_range(-.5,.5)
	sound_play_pitch(sndHeavyRevoler,.7-_ptch/3)
	sound_play_pitch(sndSawedOffShotgun,1.8-_ptch)
	sound_play_pitch(sndSniperFire,random_range(.6,.8))
	sound_play_pitch(sndHeavySlugger,1.3+_ptch/2)
}else{
	sound_play_pitch(sndHeavySlugger,.55-_ptch/8)
	sound_play_pitch(sndHeavyNader,.4-_ptch/8)
	sound_play_pitch(sndNukeExplosion,5-_ptch*2)
	sound_play_pitch(sndSawedOffShotgun,1.8-_ptch)
	sound_play_pitch(sndSniperFire,random_range(.6,.8))
}
var _c = charge, _cc = charge/maxcharge, _ccc = _cc = 1 ? 1 : 0;
with creator{
	if !other.is_super{
		weapon_post(12,2,158)
		motion_add(gunangle -180,_c / 20)
		sleep(120)
	}else{
		weapon_post(15,40,210)
		if _ccc{
			extraspeed_add(self, 10, gunangle - 180);
		}else{
			motion_add(gunangle -180,_c / 3)
		}
		sleep(200)
	}
	repeat(other.amount){
		var q = sniper_fire(x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), gunangle + random(other.deviation) * choose(-1, 1) * (1 - other.charge/other.maxcharge), team, 1 + _cc, _ccc)
		with q{
		    creator = other
		    damage = 20 + round(20 * _cc)
		    worth = 12
		    instance_create(x, y, BulletHit)
		}
	}
}
sleep(charge*3)


#define sniper_fire(xx, yy, angle, t, width, chrg)
return sniper_fire_r(xx, yy, angle, t, width, 20, -1, chrg)

#define sniper_fire_r(xx, yy, angle, t, width, tries, pierces, chrg)
//FUCK YOU YOKIN FUCK YOU YOKIN FUCK YOU FUCK YOU FUCKYOU
if tries <= 0 return [-4]
var junk = [], _p = pierces;
with instance_create(xx, yy, CustomProjectile){
    mask_index = mskLaser
    image_yscale = 2.5
    image_xscale = 3
    team = t
    image_angle = angle;
    direction = angle;
    hyperspeed = 6
    typ = 0
    recycle = 0
    worth = 12
    damage = 20
    force = 7
    charged = chrg
	c1 = c_white
	c2 = c_yellow
	x1 = xx
	y1 = yy
    name = "Sniper Bullet"
    on_wall = nothing
    on_hit = sniper_hit
    on_end_step = sniper_end_step

    var dir = 0, stop = 0;

    var _x = lengthdir_x(hyperspeed,direction), _y = lengthdir_y(hyperspeed,direction);
    var shields = instances_matching_ne([CrystalShield,PopoShield], "team", team),
        slashes = instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team),
        shanks  = instances_matching_ne([Shank,EnergyShank], "team", team),
        hitmes  = -4, lasthit = -4;
    if _p{
        hitmes = instances_matching_ne(hitme, "team", team);
    }
    var _charged = charged
    do {
        dir += hyperspeed
    	x += _x
    	y += _y
    	with shields if place_meeting(x, y, other) {
    	    var a = point_direction(x, y, other.x, other.y);
    	    array_push(junk, sniper_fire_r(other.x, other.y, a, team, width, tries - 1, _p, _charged))
    	    stop = 1
    	    break
    	}
    	with slashes if place_meeting(x, y, other){
    	    array_push(junk, sniper_fire_r(other.x, other.y, direction, team, width, tries - 1, _p, _charged))
    	    stop = 1
    	    break
    	}
    	with shanks if place_meeting(x, y, other){
    	    stop = 1
    	    break
    	}
    	with hitmes if place_meeting(x, y, other){
    	    if id != lasthit{
    	        if _p != -1{
    	            if --_p <= 0{
    	                stop = 1
    	                break
    	            }
    	        }
    	        lasthit = id
    	    }
    	}
    }
    until stop or place_meeting(x+_x, y+_y, Wall) or dir > 1000
    if !stop{
        var e = collision_line_first(x, y, x+_x, y+_y, Wall, 0, 0);
        dir += point_distance(x, y, e[0], e[1])
        x = e[0]
        y = e[1]
    }
    image_xscale += .5 * dir
    xprevious = x
    yprevious = y
    image_yscale += .5 * width

    var array = [id]
}
unpack(array, junk)
with array friends = array
return array;

#define unpack(box, stuff)
for var i = 0; i < array_length(stuff); i++{
    if is_array(stuff[i]){
        unpack(box, stuff[i])
    }
    else{
        array_push(box, stuff[i])
    }
}

#define sniper_end_step
with sniper_trail(1.7 + .8 * charged, c1, c2){
	fade_speed -= .0225 * other.charged
	image_alpha += .2 * other.charged
}
instance_destroy()

#define sniper_hit
projectile_hit(other, damage, force, direction)
view_shake_at(other.x,other.y,12)
sleep(20)

if skill_get(mut_recycle_gland) and recycle < worth and !irandom(1){
    var e = min(worth - recycle, floor(worth/6));
    instance_create(other.x, other.y, RecycleGland)
    sound_play(sndRecGlandProc)
    with friends if instance_exists(self) recycle += e
    with creator{
        ammo[1] = min(ammo[1] + e, typ_amax[1])
    }
}


#define sniper_trail(width, col1, col2)
with instance_create(x, y, CustomObject){
	col_start = col1;
	col_end   = col2;
	image_xscale = 1;
	image_yscale = width;

	depth = -1;
	creator = other.creator;
	x1 = other.x1;
	y1 = other.y1;
	x2 = x;
	y2 = y;
	image_alpha = 1.2;
	image_blend = col_start;
	fade_speed = .1;
	image_angle = other.direction + 90;

	on_draw = snipertrail_draw;
	return self;
}

#define bolt_line_bulk(dudes, width, col1, col2)
var total = 0, count = array_length(dudes)
with dudes{
    total += image_xscale
}
var w = width
var tc = .05, n = 0, n2 = 0;
with dudes{
    var s = image_xscale/total
    for var i = 0; i < 1; i += tc{
        with instance_create(lerp(xstart, x, i), lerp(ystart, y, i), BoltTrail){
            image_xscale = other.image_xscale * tc * 2
            image_angle = other.image_angle
            image_yscale = n + i * s * w
            image_blend = merge_color(col1, col2, n2 + i*s)
        }
    }
    n2 += s
    n += w*s
}

#define snipertrail_draw
if !instance_exists(creator){instance_delete(self); exit}
image_alpha -= fade_speed * current_time_scale;
image_yscale -= fade_speed * current_time_scale;
var _c = merge_colour(col_start, col_end, image_alpha),
    _l = point_distance(x1, y1, x2, y2) / sprite_get_width(spr.CursorCentre);
if image_alpha <= 0{instance_delete(self); exit}
draw_sprite_ext(spr.CursorCentre, 0, x1 + lengthdir_x(_l, image_angle - 90), y1 + lengthdir_y(_l, image_angle - 90), image_yscale, _l, image_angle, _c, image_alpha);

#define bolt_line(x1, y1, x2, y2, width, col1, col2)
var dis = point_distance(x1, y1, x2, y2) + 1;
var dir = point_direction(x1, y1, x2, y2)
var num = 20;
for var i = 0; i <= num; i++{
    with instance_create(x1 + lengthdir_x(dis/num * i, dir), y1 + lengthdir_y(dis/num * i, dir), BoltTrail){
        image_blend = merge_color(col1, col2, i/num)
        image_angle = dir
        image_yscale = width * (i/num)
        image_xscale = dis/num
    }
}

#define muzzle_step
time -= current_time_scale
if image_index + image_speed*current_time_scale > 1 or time < 0{instance_destroy()}

#define muzzle_draw
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 4*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);


#define smarter_gun_step(p)
var w = p ? wep : bwep;
if !is_object(w) or "is_drone" not in w{
    if p wep = smarter_gun_init(wep)
    else bwep = smarter_gun_init(bwep)
}
smart_step(self, p ? wep : bwep, sign(p - .1))

w = p ? wep : bwep
var name = w.wep, c = weapon_get_cost(w), l = weapon_get_load(w)

if ammo[1] >= c or infammo != 0 {
    if (p and reload <= 0 and !button_check(index, "fire")) or (!p and breload <= 0 and !(button_check(index, "spec") and race = "steroids")){
        if mod_script_call_self("weapon", name, "shoot", w, 0){
            if p reload += l
            else breload += l
            if infammo = 0 ammo[1] -= c
        }
    }
}

if !p && race != "steroids" && breload > 0{
    breload -= get_reloadspeed(self)
}

#define smarter_gun_init(_wep)
if !is_object(_wep) _wep = {
    wep : _wep
}
with _wep {
    x = other.x
    y = other.y
    xgoal = x
    ygoal = y
    yoff = 0
    gunangle = 0
    kick = 0
    is_drone = 1
}
return _wep

#define smart_step(c, w, p)
var timescale = current_time_scale;
with w{
    x += approach(x, xgoal, 4, timescale) - lengthdir_x(kick, gunangle)/2
    y += approach(y, ygoal, 4, timescale) - lengthdir_y(kick, gunangle)/2
    yoff = (sin(current_frame/10) * 3 * p)

    var l = 24, a = c.gunangle + 180 + 50 * p, d = 6;

    var wantx = c.x + 24 * p
    var wanty = c.y - 24

	//with other is to change the scope back to an instance so 9944 doesnt shit down my throat
    with other { var q = collision_line_first(c.x, c.y, wantx, wanty, Wall, 0, 0), a = point_direction(c.x, c.y, wantx, wanty); }
    xgoal = q[0] - lengthdir_x(d, a)
    ygoal = q[1] - lengthdir_y(d, a)

    kick -= clamp(sign(kick) * timescale/2, -kick * timescale, kick * timescale)
}

#define smarter_gun_sprite(spr, w)
if instance_is(self,Player){
    if is_object(w){
        draw_sprite_ext(spr, 0, w.x, w.y + w.yoff, w.kick != 0 ? sign(lengthdir_x(1, w.gunangle)) : right, 1, 0, c_white, 1)
        return mskNothing
    }
}
return spr


#define create_vector(_x, _y)
with instance_create(_x, _y, CustomProjectile) {
	name = "Vector"

	sprite_index = mskNone
	mask_index = mskLaser
	spr_trail = spr.Vector
	spr_head = spr.VectorHead
	image_xscale = 1.5
	image_yscale = 1.5

	typ = 0
	damage = 5 + 2 * skill_get(mut_laser_brain)
	force = 8
	shrinkspeed = .1 - (brain_active * .04)
	basedir = undefined
	lasthit = -4

	trail_x = x
	trail_y = y
	trail_length = 12
	homing_range = 120
	homing_scope = 45
	head_scale = 1

	defbloom = {
		sprite : spr_head,
		xscale : 2,
		yscale : 2,
		alpha : .2,
		angle : 0
	}

	on_draw = vector_head_draw
	on_step = vector_head_step
	on_hit = vector_head_hit
	on_end_step = vector_head_end_step
	on_destroy = vector_head_destroy

	return id
}

#define vector_head_step
var _r = 90 * choose(-1, 1)
if !irandom((2 - brain_active) > 0) with instance_create(x-lengthdir_x(10,direction + _r)+random_range(-2,2),y-lengthdir_y(10,direction + _r)+random_range(-2,2),BulletHit)
        {
        	sprite_index = spr.VectorEffect
        	image_angle = other.direction
					image_speed = .4 - (brain_active ? .2 : 0);
					friction = .2;
        	motion_set(other.direction,choose(1,2))
        }
var _targ = instance_nearest_matching_ne(x, y, hitme, "team", team), _diff = angle_difference(direction, basedir);
if instance_exists(_targ) {
	if distance_to_object(_targ) < homing_range and !collision_line(x, y, _targ.x, _targ.y, Wall, 0, 0) {
		var _diff2 = angle_difference(basedir, point_direction(x, y, _targ.x, _targ.y));
		if abs(_diff2) <= homing_scope {
			_diff = angle_difference(direction, point_direction(x, y, _targ.x, _targ.y))
		}
	}
}
direction -= clamp(_diff, -homing_scope * current_time_scale, homing_scope * current_time_scale)
image_angle = direction
defbloom.angle = direction - 45
var _dist = point_distance(x, y, trail_x, trail_y);
if _dist > 12 {
	with create_vector_trail(trail_x, trail_y) {
		image_xscale = _dist/2
		image_angle = point_direction(x, y, other.x, other.y)
		direction = image_angle
	}
	trail_x = x
	trail_y = y
}

#define vector_head_hit
if other != lasthit {
	projectile_hit(other, damage, 0, direction)
	sound_play_hit_ext(sndPlasmaReload, 3, 1)
	lasthit = other
}

#define vector_head_end_step
if basedir == undefined {
	image_angle = direction
	defbloom.angle = direction - 45
	basedir = direction
}

#define vector_head_destroy
sound_play_hit_big(sndPlasmaHit, .2)

with instance_create(x, y, PlasmaImpact) {

	creator = other.creator;
	team 		= other.team;
	force   = 0;
	image_speed += .1;
	sprite_index = spr.VectorImpact;
	mask_index   = msk.VectorImpact;

	repeat(10) {

		var _d = random(360);

		with instance_create(x + lengthdir_x(28 + random_range(-2, 6), _d), y + lengthdir_y(28 + random_range(-2, 6), _d), BulletHit) {

				sprite_index = spr.VectorEffect;
				image_index  = (brain_active ? 0 : irandom(1));
				image_speed  = .4 - (brain_active ? .2 : 0);
				depth = other.depth - 1;

				motion_set(_d - 180, choose(1, 2));
				image_angle = direction;
			}
		}
	}

#define vector_head_draw
var _dis = point_distance(x, y, trail_x, trail_y), _dir = point_direction(x, y, trail_x, trail_y);
draw_sprite_ext(spr_trail, 0, x, y, _dis/2, image_yscale, _dir, image_blend, image_alpha)
draw_sprite_ext(spr_head, 0, x, y, image_xscale, image_yscale, image_angle - 45, image_blend, image_alpha)


#define create_vector_trail(_x, _y)
with instance_create(_x, _y, CustomProjectile) {
	name = "VectorTrail"
	sprite_index = other.spr_trail
	mask_index = mskLaser
	shrinkspeed = other.shrinkspeed

	defbloom = default_bloom
	defbloom.xscale = 1
	image_yscale = other.image_yscale

	creator = other.creator
	team = other.team
	damage = other.damage
	force = other.force
	hit_list = []

	on_step = vector_trail_step
	on_hit  = vector_trail_hit
	on_wall = nothing

	return id
}

#define vector_trail_step
with instances_in_bbox(bbox_left, bbox_top, bbox_right, bbox_bottom, hit_list) {
	if place_meeting(x, y, other) {
		motion_set(other.direction, vectorspeed)
	}
	with other{
		if place_meeting(x + hspeed, y + vspeed, Wall){
			x = xprevious
			y = yprevious
		}
	}
}
image_yscale -= shrinkspeed * current_time_scale
if image_yscale <= 0 instance_destroy()

#define vector_trail_hit
var _t = other;
if projectile_canhit_melee(other) {
	//projectile_hit(other, damage)
}
if current_frame_active {
	if "vectorspeed" not in other {
		other.vectorspeed = 0
	}
	other.vectorspeed = min((other.vectorspeed + .5/other.size), 12)
	with other if place_meeting(x + lengthdir_x(vectorspeed, direction), y + lengthdir_y(vectorspeed, direction), Wall) vectorspeed /= 2
	var _found;
	with hit_list {
		if self == _t {
			_found = true
			break
		}
	}
	if !_found {
		array_push(hit_list, _t)
	}

}
#define create_flechette(x, y)
var _p = instance_create(x, y, CustomProjectile);
with _p{
	sprite_index = spr.Flechette;
	friction = 1;
	damage   = 4;
	force    = 4;
	on_destroy  = flechette_destroy;
	on_end_step = flechette_end_step;
	on_wall     = flechette_wall;
	on_hit      = flechette_hit;
}
return _p;

#define flechette_end_step
if skill_get(mut_bolt_marrow) > 0 {
    var q = instance_nearest_matching_ne(x, y, hitme, "team", team)
    if instance_exists(q) and point_distance(q.x, q.y, x, y) < 24 * skill_get(mut_bolt_marrow) {
        x = q.x - hspeed_raw
        y = q.y - vspeed_raw
    }
}
with instance_create(x, y, BoltTrail) {
    image_xscale = point_distance(x, y, other.xprevious, other.yprevious)
    image_angle = point_direction(x, y, other.xprevious, other.yprevious)
}
if speed <= .001{instance_destroy()}

#define flechette_wall
move_bounce_solid(false);
direction += random_range(-8,8);
image_angle = direction;

#define flechette_hit
projectile_hit(other, damage, force, direction);
if (other.my_health > 0){
	var _hitme = other;
	with instance_create(x, y, CustomObject){
		sprite_index = spr.FlechetteBlink;
		image_angle  = other.image_angle;
		image_speed  = 0;
		target  = _hitme;
		timer = 16 + 24;
		depth = target.depth - 1;
		on_step = flechette_stick_step;
	}
	instance_destroy();
	exit;
}

#define flechette_destroy
repeat(3){instance_create(x, y, Dust)}

#define flechette_stick_step
if !instance_exists(target){
	flechette_stick_explo();
	exit;
}
if place_meeting(x, y, Explosion){
	flechette_stick_explo();
	exit;
}
x = target.x;
y = target.y;
timer--;
if timer <= 16{
	image_speed  = .5;
	if image_index = 0 image_index++;
	if timer <= 0{
		flechette_stick_explo();
	}
}

#define flechette_stick_explo()
sound_play_hit_big(sndExplosionS, .1);
instance_create(x, y, SmallExplosion);
sleep(5);
view_shake_at(x, y, 2);
instance_destroy();

#define defspeed_hit
if projectile_canhit_melee(other){
	var _e = 0;
	projectile_hit(other, damage, creator.defspeed[0], creator.defspeed[1]);
	_e += (other.my_health <= 0);
	view_shake_at(x, y, 12 + 4 * _e);
	sleep(40 + 20 * _e);
}

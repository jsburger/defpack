#define init

	var i = "../sprites/projectiles/";
	global.spr = {};

	//Sprites, sorted by ammo type, misc at the bottom
	with spr {
		msk = {};

		//Fire Bullets
		FireBullet         = sprite_add(i + "iris/fire/sprFireBullet.png",    2, 8, 8);
		FireBulletHit      = sprite_add(i + "iris/fire/sprFireBulletHit.png", 4, 8, 8);
		HeavyFireBullet    = sprite_add(i + "iris/fire/sprHeavyFireBullet.png",    2, 12, 12);
		HeavyFireBulletHit = sprite_add(i + "iris/fire/sprHeavyFireBulletHit.png", 4, 12, 12);

		//Bouncers
		HeavyBouncerBullet = sprite_add(i + "iris/bouncer/sprHeavyBouncerBullet.png", 2, 12, 12);

		//Toxic Bullets
		ToxicBullet         = sprite_add(i + "iris/pest/sprPestBullet.png",    2, 8, 8);
		ToxicBulletHit      = sprite_add(i + "iris/pest/sprPestBulletHit.png", 4, 8, 8);
		HeavyToxicBullet    = sprite_add(i + "iris/pest/sprHeavyPestBullet.png",    2, 12, 12);
		HeavyToxicBulletHit = sprite_add(i + "iris/pest/sprHeavyPestBulletHit.png", 4, 12, 12);

		//Lightning Bullets
		LightningBullet         = sprite_add(i + "iris/thunder/sprThunderBullet.png",    2, 8, 8);
		LightningBulletUpg      = sprite_add(i + "iris/thunder/sprThunderBulletUpg.png", 2, 8, 8);
		LightningBulletHit      = sprite_add(i + "iris/thunder/sprThunderBulletHit.png", 4, 8, 8);
		HeavyLightningBullet    = sprite_add(i + "iris/thunder/sprHeavyThunderBullet.png",    2, 12, 12);
		HeavyLightningBulletUpg = sprite_add(i + "iris/thunder/sprHeavyThunderBulletUpg.png", 2, 12, 12);
		HeavyLightningBulletHit = sprite_add(i + "iris/thunder/sprHeavyThunderBulletHit.png", 4, 12, 12);

		//Psy Bullets
		PsyBullet         = sprite_add  (i + "iris/psy/sprPsyBullet.png",    2, 8, 8);
		PsyBulletHit      = sprite_add  (i + "iris/psy/sprPsyBulletHit.png", 4, 8, 8);
		msk.PsyBullet     = sprite_add_p(i + "iris/psy/mskPsyBullet.png",    0, 7, 3);
		HeavyPsyBullet    = sprite_add  (i + "iris/psy/sprHeavyPsyBullet.png",    2, 12, 12);
		HeavyPsyBulletHit = sprite_add  (i + "iris/psy/sprHeavyPsyBulletHit.png", 4, 12, 12);

		//Dark Bullets
		DarkBullet     = sprite_add  (i + "sprBlackBullet.png",    2, 8, 8);
		DarkBulletHit  = sprite_add  (i + "sprBlackBulletHit.png", 4, 8, 8);
		msk.DarkBullet = sprite_add_p(i + "mskBlackBullet.png",    0, 3, 5);

		//Light Bullets
		LightBullet    = sprite_add(i + "sprWhiteBullet.png",    2, 8, 8);
		LightBulletHit = sprite_add(i + "sprWhiteBulletHit.png", 4, 8, 8);

		//Iris Casings
		GenShell      = sprite_add("../sprites/other/sprGenShell.png",   7, 2, 2);
		GenShellLong  = sprite_add("../sprites/other/sprGenShellL.png",  7, 2, 3);
		GenShellHeavy = sprite_add("../sprites/other/sprGenShellH.png",  7, 2, 3);
		GenShellBig   = sprite_add("../sprites/other/sprGenShellXL.png", 7, 3, 3);

		//Psy Shells
		PsyPellet          = sprite_add(i + "sprPsyShell.png", 2, 8, 8);
		PsyPelletDisappear = sprite_add(i + "sprPsyShellDisappear.png", 5, 8, 8);

		//Split Shells
		SplitShell               = sprite_add(i + "sprSplitShell.png",          2, 8, 8);
		SplitShellDisappear      = sprite_add(i + "sprSplitShellDisappear.png", 5, 8, 8);
		HeavySplitShell          = sprite_add(i + "sprSplitSlug.png",           2, 9, 9);
		HeavySplitShellDisappear = sprite_add(i + "sprSplitSlugDisappear.png",  5, 9, 8);

		//Rocklets
		Rocklet      = sprite_add(i + "sprRocklet.png", 2, 1, 6);
		RockletFlame = sprite_add(i + "sprRockletFlame.png", 0, 8, 3);

		//Sonic Explosions
		SonicExplosion     = sprite_add(  i + "sprSonicExplosion.png", 8, 61, 59);
		msk.SonicExplosion = sprite_add_p(i + "mskSonicExplosion.png", 9, 61, 59);
		SonicStreak        = sprite_add(i + "sprSonicStreak.png",6,8,32);

		//Abris Stripes
		Stripes = sprite_add("../sprites/other/sprBigStripes.png", 1, 1, 1);

		//Plasmites
		Plasmite    = sprite_add(i + "sprPlasmite.png",    0, 3, 3);
		PlasmiteUpg = sprite_add(i + "sprPlasmiteUpg.png", 0, 3, 3);

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
		VectorHead   = sprite_add(i + "sprVectorHead.png",1,8,2)
		Vector	   = sprite_add(i + "sprVector.png",1,0,3)
		VectorImpact = sprite_add(i + "sprVectorImpact.png",7,16,16)
		VectorEffect = sprite_add(i + "sprVectorBeamEnd.png",3,5,5);

		//Spike Balls
		MiniSpikeball      = sprite_add  (i + "sprMiniSpikeball.png", 0, 6, 5);
		msk.MiniSpikeball  = sprite_add_p(i + "mskMiniSpikeball.png", 0, 6, 5);
		Spikeball          = sprite_add  (i + "sprSpikeball.png", 0, 11, 9);
		msk.Spikeball      = sprite_add_p(i + "mskSpikeball.png", 0, 11, 9);
		HeavySpikeball     = sprite_add  (i + "sprHeavySpikeball.png", 0, 15, 15);
		msk.HeavySpikeball = sprite_add_p(i + "mskHeavySpikeball.png", 0, 15, 15);

		//Discs
		BouncerDisc    = sprite_add  (i + "sprBouncerDisc.png", 2,  6,  6);
		StickyDisc     = sprite_add  (i + "sprStickyDisc.png",  2,  7,  6);
		MegaDisc       = sprite_add_p(i + "sprMegaDisc.png",    2, 12, 12);
		MegaDiscDie    = sprite_add  (i + "sprMegaDiscDie.png",    6, 12, 12);
		MegaDiscTrail  = sprite_add  (i + "sprMegaDiscTrail.png",  3, 12, 12);
		MegaDiscBounce = sprite_add  (i + "sprMegaDiscBounce.png", 4, 12, 12);

		//Blades
		Sword       = sprite_add  (i + "sprSword.png",      1, 10, 10)
		SwordStick  = sprite_add_p(i + "sprSwordStick.png", 1, 10, 10)
		SwordImpact = sprMeleeHitWall   //sprite_add(i + "sprSwordImpact.png", 8, 16, 16)
		Knife       = sprite_add  (i + "sprKnife.png",      1, 7, 7)
		KnifeStick  = sprite_add_p(i + "sprKnifeStick.png", 1, 4, 7)
		SwordSlash  = sprite_add  (i + "sprSwordSlash.png", 5, 16, 16)

		//Flechettes
		Flechette       = sprite_add("..\sprites\projectiles\sprFlechette.png",      0,  6, 4)
		msk.Flechette   = sprite_add("..\sprites\projectiles\mskFlechette.png",      0,  6, 2)
		FlechetteBlink  = sprite_add("..\sprites\projectiles\sprFlechetteBlink.png", 3, 14, 4)


		//Quartz Shards
		Shard      = sprite_add_weapon("../sprites/weapons/sprShard.png", 0, 3);
		GlassShard = sprite_add("../sprites/other/sprGlassShard.png", 5, 4, 4)

		//Crits
		Killslash = sprite_add(i + "sprKillslash.png", 8, 16, 16);

		//Charge Icon
		Charge = sprite_add("../sprites/interface/sprHoldIcon.png", 35, 12, 12);

		//Sniper Sights
		Aim          = sprite_add("../sprites/interface/sprAim.png", 0, 10, 10);
		CursorCentre = sprite_add("../sprites/interface/sprCursorCentre.png", 0, 1, 1);

	}



	global.SAKmode = 0
	//mod_script_call("mod","defpermissions","permission_register","mod",mod_current,"SAKmode","SAK Mode")

	global.traildrawer = -4
	global.trailsf = surface_create(game_width*4,game_height*4)
	surface_set_target(global.trailsf)
	draw_clear_alpha(c_white,0)
	surface_reset_target()

	vertex_format_begin()
	vertex_format_add_position()
	global.lightningformat = vertex_format_end()

	global.chargeType = 1
	global.chargeSmooth = [0, 0]

	mod_script_call_nc("mod", "defpermissions", "permission_register_options", "mod", mod_current, "chargeType", "Weapon Charge Indicators", ["Off", "Wep Specific", "Bar Only", "Arc Only"])

	//todo:
	//find out if bolt marrow should be split into step on bolts

#macro spr global.spr
#macro msk global.spr.msk

//thanks yokin
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#macro prim_offset 1
#macro lasercolor 14074

#macro abris_mouse 0
#macro abris_manual 1
#macro abris_gunangle 2

#macro defcharge_bar 0
#macro defcharge_arc 1

#macro default_bloom {
        xscale : 2,
        yscale : 2,
        alpha : .1
    };


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
	        trace_color("(Weapon drops are restored)", c_gray)
	    }
	    return 1
	}

#define cleanup
	with global.traildrawer instance_destroy()

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
	    if lv > 0{
	        draw_circle_color(x,y,180 + 20*lv + random(5), c_gray,c_gray,0)
	        draw_circle_color(x,y,70  + 20*lv + random(5), c_black,c_black,0)
	    }
	}
	with instances_matching(CustomProjectile,"name","Lightning Bolt"){
		draw_circle_color(x,y,550 + random(10), c_gray,c_gray,0)
		draw_circle_color(x,y,250 + random(10), c_black,c_black,0)
	}
	with instances_matching([Bolt,BoltStick],"name","marker bolt"){
		draw_circle_color(x+lengthdir_x(sprite_width/2+2,direction),y+lengthdir_y(sprite_width/2+2,direction),35 + random(3), c_gray,c_gray,0)
		draw_circle_color(x+lengthdir_x(sprite_width/2+2,direction),y+lengthdir_y(sprite_width/2+2,direction),20 + random(3), c_black,c_black,0)
	}

#define draw_gui
with instances_matching(CustomObject,"name","sniper charge","sniper pest charge","sniper fire charge","sniper thunder charge","sniper psy charge", "sniper bouncer charge"){
    if !instance_exists(creator){draw_set_visible_all(1);instance_destroy();exit}
    draw_set_visible_all(0)
    draw_set_visible(creator.index,1)
    var _pc     = player_get_color(creator.index);
    if holdtime >= 60 {var _m = 5}else{var _m = 3}
    if current_frame mod _m <= current_time_scale && _m = 3{sound_play_pitch(sndCursedReminder,5)}
    if charged = 0{if (current_frame mod _m) <= current_time_scale {if _pc != c_white {_pc = c_white}else{_pc = player_get_color(creator.index)}}}
    var _offset = charge;
    var _vpf    = 3;
    var _mx     = mouse_x_nonsync - view_xview_nonsync + 1;
    var _my     = mouse_y_nonsync - view_yview_nonsync + 1;
    for var i = -1; i <= 1; i += 2{
        for var o = -1; o <= 1; o += 2{
            draw_sprite_ext(spr.Aim, 0, _mx + (_vpf - _offset + 100) * i, _my + (_vpf - _offset + 100) * o, -i, -o, 0, _pc, .1 + .9*charge/100)
        }
    }
    draw_sprite_ext(spr.CursorCentre,0,_mx,_my,1,1,0,_pc,1)
}
draw_set_visible_all(1)

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
        var _chargeCounter = array_create(2)
        with matches{
            with defcharge{
                if power(charge/maxcharge, lq_defget(self, "power", 2)) >= .001{
                    var num = global.chargeType == 1 ? style : global.chargeType - 2;
                    _chargeCounter[num]++
                }
            }
        }
        var _x = mouse_x_nonsync - view_xview_nonsync, _y = mouse_y_nonsync - view_yview_nonsync + 1;
        var c = player_get_color(index), _col = c;
        //counters
        var _arcCount = 0, _barCount = 0, _arcMax = _chargeCounter[defcharge_arc], _barMax = _chargeCounter[defcharge_bar];
        //smoothing
        var _scale = global.chargeSmooth, _l = array_length(_scale);
        for var i = 0; i < _l; i++{
            _scale[i] += approach(_scale[i], _chargeCounter[i], 3, 30/room_speed)
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
with instances_matching(CustomProjectile,"name","vector beam"){
  draw_sprite_ext(sprite_index, image_index, xstart, ystart, image_xscale, 1.5*image_yscale, image_angle, image_blend, 0.15+skill_get(17)*.05);
	if x != xstart draw_sprite_ext(spr_tail, 0, xstart, ystart, 1.5, image_yscale*1.5, image_angle, image_blend, .15+skill_get(17)*.05);
	if x != xstart draw_sprite_ext(spr_head, 0, x, y, 2.5, image_yscale*2.5, image_angle-45, image_blend, .15+skill_get(17)*.05);
}
with instances_matching(CustomProjectile,"name","mega lightning bullet"){
  draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale+(1-image_index)*2, 2*image_yscale+(1-image_index)*2, image_angle, image_blend, 0.2+(1-image_index)*.4);
}


#define draw_shadows
with Player if visible{
    drone_shadow(wep)
    drone_shadow(bwep)
}

#define drone_shadow(w)
if !is_object(w) exit
if lq_defget(w, "is_drone", 0){
    draw_sprite(shd16, 0, w.x, w.y + 12)
}


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

#define get_n_targets(_x, _y, obj, varname, value, amount)
var num = instance_number(obj),
    man = instance_nearest(_x, _y, obj),
    mans = [],
    n = 0,
    found = [];
if instance_exists(obj){
    while ++n <= num and amount > 0{
        if variable_instance_get(man, varname) != value && (!instance_is(man, prop) || instance_is(man, Generator)){
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


#define script_ref_call_self(scr)
return mod_script_call_self(scr[0], scr[1], scr[2])


 //shitty and bad sound stuff
#define get_coords_nonsync()
var _x, _y, i = player_find_local_nonsync(), p = player_find(i);
if !instance_exists(p)
    p = view_object[i]
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
	sound_volume(s, _volume);
	return s;

#define sound_play_hit_big_ext(_sound, _pitch, _volume)
	var s = sound_play_hit_big(_sound, 0);
	sound_pitch(s, _pitch);
	sound_volume(s, _volume);
	return s;



#define chance(percentage)
return random(100) <= percentage * current_time_scale

#define approach(a, b, n, dn)
return (b - a) * (1 - power((n - 1)/n, dn))

#define angle_approach(a, b, n, dn)
return angle_difference(a, b) * (1 - power((n - 1)/n, dn))

#define get_reloadspeed(p)
if !instance_is(p, Player) return 1
return (p.reloadspeed + ((p.race == "venuz") * (.2 + .4 * ultra_get("venuz", 1))) + ((1 - p.my_health/p.maxhealth) * skill_get(mut_stress)))

#define draw_trails
var q = instances_matching(CustomProjectile,"name","Rocklet","big rocklet","huge rocklet")
if array_length(q){
    surface_set_target(global.trailsf)
    draw_clear_alpha(0,0)
    draw_set_blend_mode(bm_normal)
    draw_set_alpha(1)
    draw_set_color_write_enable(1,1,1,1)

    with instances_seen_nonsync(instances_matching(q, "name","big rocklet","huge rocklet")){
        var _x = (x - view_xview_nonsync)*4, _y = (y - view_yview_nonsync)*4, _xp = (lerp(x,xprevious,4*speed/maxspeed) - view_xview_nonsync)*4, _yp = (lerp(y,yprevious,4*speed/maxspeed) - view_yview_nonsync)*4;
        var len = ((random_nonsync(speed)/maxspeed))*16;
        var xoff = lengthdir_x(len,direction + 90), yoff = lengthdir_y(len,direction + 90);
        draw_triangle_color(_x + xoff, _y + yoff, _x - xoff, _y - yoff, _xp, _yp, c_white, c_white, c_black, 0)
    }
    with instances_seen_nonsync(instances_matching(q, "name","Rocklet")){
        var _x = (x - view_xview_nonsync)*4, _y = (y - view_yview_nonsync)*4, _xp = (lerp(x,xprevious,4*speed/maxspeed) - view_xview_nonsync)*4, _yp = (lerp(y,yprevious,4*speed/maxspeed) - view_yview_nonsync)*4;
        var len = (random_nonsync(speed)/maxspeed)*8;
        var xoff = lengthdir_x(len,direction + 90), yoff = lengthdir_y(len,direction + 90);
        draw_triangle_color(_x + xoff, _y + yoff, _x - xoff, _y - yoff, _xp, _yp, c_white, c_white, c_black, 0)
    }

    surface_reset_target()
    draw_set_blend_mode(bm_add)
    draw_surface_ext(global.trailsf,view_xview_nonsync,view_yview_nonsync,0.25,0.25,0,c_white,1)
    draw_set_blend_mode(bm_normal)
}

#define weapon_get_chrg(w)
if is_object(w) w = w.wep
if is_string(w){
    var q = mod_script_call_self("weapon", w, "weapon_chrg")
    if q != undefined return q
}
return 0

#define step
 //gets rid of dummy weapons, i dont know why vanilla doesnt do this
with instances_matching(WepPickup, "wep", 0) instance_destroy()

 //adds the hold icon to charge weapons
with instances_matching_ne(WepPickup, "chargecheck", 1){
    chargecheck = 1
    if weapon_get_chrg(wep) {
        name += ` @0(${spr.Charge}:0) `//-.35
    }
}

 //surface for rocklet trails
if !surface_exists(global.trailsf) {
    global.trailsf = surface_create(game_width * 4, game_height * 4)
    surface_set_target(global.trailsf)
    draw_clear_alpha(c_black, 0)
    surface_reset_target()
}
 //thing that uses said surface
if !instance_exists(global.traildrawer) {
    with script_bind_draw(draw_trails, 1){
        global.traildrawer = id
        persistent = 1
    }
}

if global.SAKmode && mod_exists("weapon", "sak"){
    with instances_matching(instances_matching(WepPickup, "roll", 1), "saked", undefined) {
        saked = 1
        wep = mod_script_call_nc("weapon", "sak", "make_gun_random")
    }
}

with instances_matching([Explosion, SmallExplosion, GreenExplosion, PopoExplosion], "hitid", -1) {
    hitid = [sprite_index, string_replace(string_upper(object_get_name(object_index)), "EXPLOSION", " EXPLOSION")]
}

//drop tables
with instances_matching_le([Inspector, Shielder, EliteGrunt, EliteInspector, EliteShielder], "my_health", 0) {
	if !irandom(97) {
		with instance_create(x, y, WepPickup) {
			wep = "donut box"
		}
	}
}
with SodaMachine{
	if fork(){
	    var _x = x, _y = y;
	    wait(0)
	    if !instance_exists(self) && instance_exists(Wall){
    		with instance_create(_x, _y, WepPickup){
    		    if !irandom(99) wep = "soda popper"
    		    else{
        		    var a = ["lightning blue lifting drink(tm)", "extra double triple coffee", "expresso","saltshake", "munitions mist", "vinegar", "guardian juice"]
        			if skill_get(14) > 0
        			    array_push(a, "sunset mayo")
        			if array_length(instances_matching(Player, "notoxic", 0))
        			    array_push(a, "frog milk")
                    wep = a[irandom(array_length(a) - 1)]
                }
    		}
    	}
    	exit
	}
}

#define weapon_charged(c, l)
sound_play_pitch(sndSnowTankCooldown, 8)
sound_play_pitchvol(sndShielderDeflect, 4, .5)
sound_play_pitchvol(sndBigCursedChest, 20, .1)
sound_play_pitchvol(sndCursedChest, 12, .2)
with instance_create(c.x + lengthdir_x(l, c.gunangle), c.y + lengthdir_y(l, c.gunangle), ChickenB) {
	creator = c
	image_xscale = .5
	image_yscale = .5
	with instance_create(x, y, ChickenB){
		creator = c
		image_speed = .75
	};
};


#define draw_bar(x, y, w, h, col)
var x2 = x - w * .5, y2 = ceil(y + (h + 3)/2);
draw_line_width_color(x2 - 1, y, x2 + w + 1, y, h + 3, col, col)
draw_line_width_color(x2, y, x2 + w, y, h + 1, 0, 0)
var y3 = ceil(y + (h + 3)/2);
draw_line_width_color(x2 - 1, y3, x2 + w + 1, y3, 1, 0, 0)


#define bullet_wall
instance_create(x, y, Dust)
sound_play_hit(sndHitWall, .2)
instance_destroy()

#define bullet_hit
projectile_hit(other, damage, force, direction);
if recycle_amount != 0{
    with creator if instance_is(self, Player){
        var num = (skill_get(mut_recycle_gland) * (irandom(9) < 5)) + 10 * skill_get("recycleglandx10");
        if num {
            ammo[1] = min(ammo[1] + other.recycle_amount * num, typ_amax[1])
            instance_create(other.x, other.y, RecycleGland)
            sound_play(sndRecGlandProc)
        }
    }
}
instance_destroy()

#define bullet_destroy
with instance_create(x, y, BulletHit) sprite_index = other.spr_dead

#define bullet_anim
image_index = 1
image_speed = 0

#define shell_hit
projectile_hit(other, (current_frame < fallofftime? damage : (damage - falloff)), force, direction);

#define create_bullet(x, y)
with instance_create(x, y, CustomProjectile){
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

    on_anim = bullet_anim
    on_wall = bullet_wall
    on_hit = bullet_hit
    on_destroy = bullet_destroy

    return id
}

#define create_heavy_bullet(x, y)
with create_bullet(x, y){
    name = "Heavy Bullet"

    sprite_index = sprHeavyBullet
    spr_dead = sprHeavyBulletHit
    mask_index = mskHeavyBullet

    recycle_amount = 2
    force = 12
    damage = 7

    return id
}

#define create_heavy_bouncer_bullet(x, y)
with create_heavy_bullet(x, y){
    name = "Heavy Bouncer Bullet"
    sprite_index = spr.HeavyBouncerBullet
    damage = 9
    turn = choose(-1, 1)
    bounce = 2

    on_step = bouncer_step
    on_wall = bouncer_wall

    return id
}

#define bouncer_step
image_angle += 6*turn * current_time_scale

#define bouncer_wall
if bounce > 0{
    bounce--
    instance_create(x, y, Dust)
    sound_play_pitchvol(sndBouncerBounce, random_range(.7, .8), .7)
    move_bounce_solid(false)
    direction += random_range(6, 6)
}
else instance_destroy()

#define create_psy_bullet(x, y)
with create_bullet(x,y){
    name = "Psy Bullet"
    sprite_index = spr.PsyBullet
    mask_index = msk.PsyBullet
    spr_dead = spr.PsyBulletHit

    damage = 4
    typ = 2
    force = -10

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
    on_draw = psy_draw_new
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
    sprite_index = spr.HeavyPsyBullet
    //mask_index = msk.PsyBullet
    spr_dead = spr.HeavyPsyBulletHit

    damage = 8
    typ = 2
    force = -20
    timer = irandom(4) + 3
    range = 130
    turnspeed = .42

    on_step = psy_step
    on_hit = psy_hit

    return id
}

#define psy_hit()
with other
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

#define create_thunder_bullet(x, y)
return create_lightning_bullet(x, y)

#define create_lightning_bullet(x, y)
with create_bullet(x, y){
    name = "Lightning Bullet"
    sprite_index = skill_get(mut_laser_brain) ? spr.LightningBulletUpg : spr.LightningBullet
    spr_dead = spr.LightningBulletHit

    force = 7
    damage = 2
    typ = 2

    on_step = thunder_step
    on_destroy = thunder_destroy

    return id
}

#define create_heavy_lightning_bullet(x, y)
with create_heavy_bullet(x, y){
    name = "Heavy Lightning Bullet"
    sprite_index = skill_get(mut_laser_brain) ? spr.HeavyLightningBulletUpg : spr.HeavyLightningBullet
    spr_dead = spr.HeavyLightningBulletHit

    typ = 2
    damage = 4

    on_step = heavy_thunder_step
    on_destroy = heavy_thunder_destroy

    return id
}

#define quick_lightning(a)
with instance_create(x,y,Lightning){
  	image_angle = random(360)
  	team = other.team
	creator = other.creator
  	ammo = a
	alarm0 = 1
	visible = 0
  	with instance_create(x,y,LightningSpawn){
  	   image_angle = other.image_angle
    }
}

#define heavy_thunder_step
if chance(12){
    quick_lightning(2)
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
    sprite_index = spr.ToxicBullet
    spr_dead = spr.ToxicBulletHit

    force = 8
    damage = 2

    on_hit = toxic_hit
    on_destroy = toxic_destroy

    return id
}

#define create_heavy_toxic_bullet(x, y)
with create_heavy_bullet(x, y){
    name = "Heavy Toxic Bullet"
    sprite_index = spr.HeavyToxicBullet
    spr_dead = spr.HeavyToxicBulletHit

    damage = 5
    force = 11

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
repeat(2){
	with instance_create(x,y,ToxicGas){friction *= 4}
}
bullet_destroy()

#define heavy_toxic_destroy
repeat(3){
	with instance_create(x,y,ToxicGas){motion_add(random(360),1)}
}
bullet_destroy()

#define create_flame_bullet(x,y)
return create_fire_bullet(x,y)

#define create_fire_bullet(x,y)
with create_bullet(x,y){
    name = "Fire Bullet"
    sprite_index = spr.FireBullet
    spr_dead = spr.FireBulletHit

    damage = 3

    on_step = fire_step
    on_destroy = fire_destroy

    return id
}

#define create_heavy_fire_bullet(x,y)
with create_heavy_bullet(x, y){
    name = "Heavy Fire Bullet"
    sprite_index = spr.HeavyFireBullet
    spr_dead = spr.HeavyFireBulletHit

    damage = 4

    on_step = fire_step
    on_destroy = heavy_fire_destroy

    return id
}

#define fire_step
if chance(8){
	with instance_create(x,y,Flame){
		team = other.team
		creator = other.creator
	}
}

#define fire_destroy
with create_miniexplosion(x, y){
    team = other.team
}
with instance_create(x,y,BulletHit){
	sprite_index = other.spr_dead
    image_index = 1
}

#define heavy_fire_destroy
instance_create(x,y,SmallExplosion)
sound_play_pitchvol(sndExplosionS,2,.3)
bullet_destroy()


#define create_dark_bullet(x,y)
with instance_create(x, y, CustomSlash){
	name = "Dark Bullet"
	sprite_index = spr.DarkBullet
	mask_index = msk.DarkBullet
	spr_dead = spr.DarkBulletHit

	typ = 0
	damage = 8
	force = 7
	offset = random(360)
	ringang = random(360)
	recycle_amount = 1
	image_speed = 1

	on_projectile = dark_proj
	on_destroy = dark_destroy
    on_wall = bullet_wall
    on_hit = bullet_hit
	on_anim = bullet_anim

	return id
}

#define dark_proj
var t = team;
with other{
	if typ >= 1 {
		var ringang = random(360);
		with create_sonic_explosion(x,y){
			var scalefac = random_range(0.26,0.3);
			image_xscale = scalefac
			image_yscale = scalefac
			damage = 2
			shake = 2
			image_speed = 0.85
			image_blend = c_black
			team = t
			candeflect = 0
		}
		repeat(3){
			with create_sonic_explosion(other.x+lengthdir_x(other.speed*1.3,other.offset+ringang),other.y+lengthdir_y(other.speed*1.3,other.offset+ringang)){
				var scalefac = random_range(0.15,0.2);
				image_xscale = scalefac
				image_yscale = scalefac
				damage = 2
				shake = 2
				image_speed = 1
				image_blend = c_black
				team = t
				candeflect = 0
			}
			ringang += 120
		}
		instance_destroy()
	}
}

#define dark_destroy
with create_sonic_explosion(x,y){
	team = other.team
	var scalefac = random_range(0.37,0.4);
	image_xscale = scalefac
	image_yscale = scalefac
	candeflect = 0
	shake = 5
	damage = 8
	image_speed = 0.8
	image_blend = c_black
}
bullet_destroy()

#define create_light_bullet(x, y)
with create_bullet(x, y){
    name = "Light Bullet"
    typ = 0
    sprite_index = spr.LightBullet
    spr_dead = spr.LightBulletHit

    force = 4
    lasthit = -4
    pierces = 6

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

#define create_sonic_explosion(_x,_y)
	with instance_create(_x,_y,CustomSlash){
		name = "Sonic Explosion"

		sprite_index = spr.SonicExplosion
		mask_index = msk.SonicExplosion

		typ = 0
		damage = 1
		candeflect = 1
		image_speed = .7
		force = 20
		shake = 10
		if GameCont.area = 101{synstep = 0}else{synstep = 1} //oasis synergy
		hitid = [sprite_index,"Sonic Explosion"]
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
	if synstep = 0
	{
		synstep = 1
		image_xscale *= 1.25
		image_yscale *= 1.25
		image_speed  *= .8
	}
	if shake {view_shake_at(x,y,shake);shake = 0}

#define sonic_projectile
	with other{
		instance_destroy();
	}

#define sonic_grenade
	with other{
		direction = point_direction(other.x,other.y,x,y);
		image_angle = direction;
	}

#define sonic_hit
	if projectile_canhit_melee(other){

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
			name         = "SuperForce";
			team         = other.team;
			creator      = other;
			mask_index   = other.mask_index;
			sprite_index = mskNothing;
			with _explo
			{
				if "superforce"     in self other.force 				 = superforce else other.force = 18;
				if "superfriction"  in self other.superfriction  = superfriction else other.superfriction = 1;
				if "superdirection" in self other.superdirection = superdirection;
			}
			motion_set("superdirection" in self ? superdirection : other.direction, force); // for easier direction manipulation on wall hit

			on_step = superforce_step;
		}
	}

#define superforce_step
	//apply "super force" to enemies
	if !instance_exists(creator) ||instance_is(creator, Nothing) ||instance_is(creator, TechnoMancer) ||instance_is(creator, Turret) ||instance_is(creator, MaggotSpawn) ||instance_is(creator, Nothing) ||instance_is(creator, LilHunterFly) || instance_is(creator, RavenFly){instance_delete(self); exit}
	with creator
	{
		repeat(2) with instance_create(x, y, Dust){motion_add(other.direction + random_range(-8, 8), choose(1, 2, 2, 3)); sprite_index = sprExtraFeet}
		other.x = x;
		other.y = y;
		motion_set(other.direction, other.force);
		other.force -= other.superfriction * max(1, size);
		if other.force <= 0 {with other {instance_delete(self);exit}}
	}
	if place_meeting(x + hspeed, y + vspeed, Wall)
	{
	  with instance_create(x, y, MeleeHitWall){image_angle = other.direction}	move_bounce_solid(false);
		sound_play_pitchvol(sndImpWristKill, 1.2, .8)
		sound_play_pitchvol(sndWallBreak, .7, .8)
		sound_play_pitchvol(sndHitRock, .8, .8)
		sleep(32)
		view_shake_max_at(x, y, 8 * clamp(creator.size, 1, 3))
		repeat(creator.size) instance_create(x, y, Debris)
		with creator
		{
			projectile_hit(self,round(ceil(other.force) * 1.5),1	,direction)
			if my_health <= 0
			{
				sleep(30)
				view_shake_at(x, y, 16)
				repeat(3) instance_create(x, y, Dust){sprite_index = sprExtraFeet}
			}
		}
		force *= .7
		repeat(3) with instance_create(x+lengthdir_x(12,direction),y+lengthdir_y(12,direction),AcidStreak){
			sprite_index = spr.SonicStreak
			image_angle = other.direction + random_range(-32, 32) - 90
			motion_add(image_angle+90,12)
			friction = 2.1
		}
	}
	if place_meeting(x + hspeed, y + vspeed, hitme)
	{
		if !instance_is(self, Player) && projectile_canhit_melee(other)
		{
			projectile_hit(other,(ceil(force) + size) * 2, force, direction)
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
    mask_index   = sprGrenade

    on_step    = abris_step
    on_draw    = abris_draw
    on_cleanup = script_ref_create(abris_cleanup)
    on_destroy = abris_destroy

    index = -1
    accbase = startsize * creator.accuracy
    acc = accbase
    accmin = endsize
    accspeed = 1.2

    damage = 2
    maxdamage = 8
    wep = weapon
    auto = 0

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

    image_angle += rotspeed * timescale
    scroll += timescale
    offset += offspeed * timescale

    if isplayer{
        var _a = 1 - acc/accbase;
        view_pan_factor[index] = 4 - (_a * 1.3)
        defcharge.charge = _a
        if button_pressed(index, "swap") and creator.bwep != 0{
            abris_refund()
            exit
        }
        if reload = -1{
            reload = hand ? creator.breload : creator.reload
            reload += get_reloadspeed(creator) * timescale
        }
        if hand creator.breload = max(reload, creator.breload)
        else creator.reload = max(reload, creator.reload)
        if place_meeting(x, y, Wall){
            if acc < accbase{
                acc += abs(creator.accuracy*3) * timescale
            }
            else{
                acc = accbase;
            }
        }
        else{
            acc /= power(accspeed, timescale)
        }
        if !button_check(index, btn) or (auto and acc <= 2){
            instance_destroy()
        }
    }
    else{
        acc /= power(accspeed, timescale)
        if acc <= 2{
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
    var size = 2 * (other.acc+other.accmin)/(sprite_width)
    damage = ceil(other.damage + (other.maxdamage - other.damage)*(1 - (other.acc/other.accbase)))
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
        _x = mouse_x[index]
        _y = mouse_y[index]
        ang = c.gunangle
    }
    else if targeting == abris_manual{
        _x = c.y + lengthdir_x(length, angle)
        _y = c.x + lengthdir_y(length, angle)
        ang = angle
    }else if targeting == abris_gunangle{
        _x = c.y + lengthdir_x(length, c.gunangle + angle)
        _y = c.x + lengthdir_y(length, c.gunangle + angle)
        ang = c.gunangle + angle
    }

    var w = collision_line_first(creator.x, creator.y, _x, _y, Wall, 0, 0);
    x = w[0]
    y = w[1]

    var kick = hand ? creator.bwkick : creator.wkick, yoff = -4 * hand;
    draw_sprite_ext(sprHeavyGrenadeBlink, 0, c.x + lengthdir_x(14 - kick, ang), c.y + lengthdir_y(14 - kick, ang) + 1 + yoff, 1, 1, ang, lasercolour, 1)
    var r = acc + accmin, sides = 16, a = 1 - acc/accbase;
    mod_script_call_nc("mod", "defpack tools", "draw_polygon_striped", sides, r, scrollang, x, y, stripecolour, .1 + .3*a, scroll)
    mod_script_call_nc("mod", "defpack tools", "draw_circle_width_colour", sides, r, 1, acc + image_angle, x, y, ringcolour, .2 + a * .8)
    mod_script_call_nc("mod", "defpack tools", "draw_circle_width_colour", sides, accmin, 1, acc + image_angle, x, y, ringcolour, .2 + a * .2)
    draw_line_width_color(c.x + lengthdir_x(16 - kick, ang), c.y + lengthdir_y(16 - kick, ang) + yoff, x, y, 1, lasercolour, lasercolour)
}

#define abris_hit
projectile_hit(other,damage,0,0)

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
        time = skill_get(17)+4
        timestart = time
        create_frame = current_frame
        colors = [c_black,c_white,c_white,merge_color(c_blue,c_white,.3),c_white]
        wantdust = 1
        damage = 9 + skill_get(17)*3
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
var bwidth = .5 + skill_get(mut_laser_brain)
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
with instance_create(_x, _y, CustomProjectile) {
    name = "Plasmite"
    defbloom = {
        xscale : 2,
        yscale : 2,
        alpha : .1
    }
	image_speed = 0
	damage = 4 + 3*skill_get(mut_laser_brain)
	sprite_index = skill_get(mut_laser_brain) ? spr.PlasmiteUpg : spr.Plasmite
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
if chance(8 + 6 * skill_get(mut_laser_brain)) instance_create(x, y, PlasmaTrail)

var closeboy = instance_nearest_matching_ne(x, y, hitme, "team", team);
if instance_exists(closeboy) && distance_to_object(closeboy) <= 24 {
    motion_add(point_direction(x, y, closeboy.x, closeboy.y), 4 * current_time_scale)
    maxspeed += .5 * current_time_scale
}
image_angle = direction
if speed > maxspeed {
	speed = maxspeed
}
maxspeed /= power(1 + fric, current_time_scale)
if maxspeed <= 1 + fric instance_destroy();

#define plasmite_wall
move_bounce_solid(false)
image_angle = direction
sound_play_pitchvol(sndPlasmaHit, random_range(3, 6), .3)
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
draw_self()
image_xscale = _x;

#define plasmite_destroy
sound_play_hit_ext(sndPlasmaHit, random_range(1.45, 1.83), 1)
with instance_create(x,y,PlasmaImpact) {
	image_xscale = .5;
	image_yscale = .5;
	team = other.team;
	damage = floor(damage/2)
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
				if skill_get(17) {
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
		image_speed = 0.3 - skill_get(17) * 0.05
		image_xscale = .25
		image_yscale = .25
	}
}
iframes = max(iframes - current_time_scale, 0)
speed = clamp(speed, minspeed, maxspeed)
image_angle += speed * anglefac * fac * current_time_scale
if current_frame_active with instance_create(x + random_range(-8, 8) + lengthdir_x(sprite_width/2, direction - 180), y + random_range(-8, 8) + lengthdir_y(sprite_width/2, direction - 180), PlasmaTrail){
	image_speed = 0.35 - skill_get(17) * 0.05
}
if bounce <= 0 instance_destroy()


#define create_rocklet(_x,_y)
with instance_create(_x, _y, CustomProjectile){
    sprite_index = spr.Rocklet
    damage = 3
    name = "Rocklet"
    maxspeed = 14
    immuneToDistortion = 1
    typ = 1
    depth = -1
    direction_goal = 0
    friction = -.6
    on_step = rocket_step
    on_destroy = rocket_destroy
    on_anim = bullet_anim
    on_draw = rocket_draw
    return id
}

#define rocket_step
var _q = instance_nearest(x, y, enemy), _g = direction_goal, _s = 8;
if _q > -4 && distance_to_object(_q) <= 32 {
	_g = point_direction(x, y, _q.x, _q.y)
	_s = 1.5
}

direction -= angle_approach(direction, _g, _s, current_time_scale)
if speed > maxspeed
	speed = maxspeed
image_angle = direction

#define rocket_destroy
sound_play_hit_big_ext(sndExplosionS, 1.5 * random_range(.8, 1.2), .8)
with instance_create(x, y, SmallExplosion)
	damage = 3

#define rocket_draw
draw_self()
draw_sprite_ext(spr.RockletFlame, -1, x, y, 1, 1, image_angle, c_white, image_alpha)

#define laserflak_hit
if projectile_canhit_melee(other) == true{
	var k = other.my_health;
	projectile_hit(other, damage, ammo, direction)
	repeat(3) with instance_create(x, y, PlasmaTrail){
		view_shake_at(x, y, 8)
		motion_add(random(180), random_range(7, 8))
	}
	sleep(damage * 2)
	damage -= floor(k/size)
	if damage <= 0 instance_destroy()
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
	damage = 8 + skill_get(17)*3
	friction = .5
	ammo = 10
	typ = 1
	size = 1
	sprite_index = spr.LaserFlakBullet
	mask_index = mskFlakBullet
	on_hit      = laserflak_hit
	on_step     = laserflak_step
	on_destroy  = laserflak_destroy
	on_square   = script_ref_create(lflak_square)
	defbloom = {
        xscale : 1.5+skill_get(mut_laser_brain),
        yscale : 1.5+skill_get(mut_laser_brain),
        alpha : .1 + skill_get(mut_laser_brain) * .025
    }

    return id
}

#define laserflak_destroy
view_shake_at(x,y,32)
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
	        xscale : 1.5+skill_get(mut_laser_brain),
	        yscale : 1.5+skill_get(mut_laser_brain),
	        alpha : .1 + skill_get(mut_laser_brain) * .025
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
	if !place_meeting(x, y, Floor) || image_index + image_speed >= 3{instance_destroy()}

#define laserflak_step
if chance(66){
	with instance_create(x+random_range(-8,8),y+random_range(-8,8),PlasmaTrail){
		image_xscale += skill_get(17)/3
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


#define quartz_penalty(_mod) //this is for player step only stupid
if chance(4){
  with instance_create(x+random_range(-8,8),y+random_range(-8,8),WepSwap){
    image_xscale = .75
    image_yscale = .75
    image_speed = choose(.7,.7,.7,.45)
  }
}
if lsthealth > my_health {
  if wep  = _mod {
    quartz_break()
    with instance_create(x,y,ThrownWep){
      wep = "shard"
      sprite_index = spr.Shard
      curse = other.curse
      motion_set(other.gunangle-180-random_range(-2,2),3)
    }
    wep = bwep
    bwep = 0
    curse = bcurse
    bcurse = 0
  }
  //steroids hnnnnnnnnnnnng
  if bwep = _mod && race = "steroids"{
    quartz_break()
    with instance_create(x,y,ThrownWep){
      wep = "shard"
      sprite_index = spr.Shard
      curse = other.bcurse
      motion_set(other.gunangle-180-random_range(-2,2),3)
    }
    bcurse = 0
    bwep = 0
  }
}

#define quartz_break()
var _pitch = random_range(.9,1.1)
sound_play_pitch(sndHyperCrystalHurt,.8*_pitch)
sound_play_pitch(sndLaserCrystalHit,.7*_pitch)
sound_play_pitchvol(sndHyperCrystalHalfHP,2*_pitch,.4)
sound_play_gun(sndLaserCrystalDeath,.1,.0001)//mute action
sleep(400)
view_shake_at(x,y,45)
repeat(14) with instance_create(x,y,Feather){
	motion_add(random(360),random_range(3,6))
	sprite_index = spr.GlassShard
	image_speed = random_range(.4,.7)
	image_index = irandom(5)
}


#define crit() //add this to on_hit effects in order to not be stupid
var _t = team;
view_shake_max_at(x, y, 150)
sleep(100)
sound_play_pitchvol(sndHammerHeadEnd,random_range(1.23,1.33),20)
sound_play_pitchvol(sndBasicUltra,random_range(0.9,1.1),20)
sound_play_pitch(sndCoopUltraA,random_range(3.8,4.05))
sound_play_pitch(sndBasicUltra,random_range(.6,.8))
sound_play_gun(sndClickBack,1,.5)
sound_stop(sndClickBack)
with instance_create(x+lengthdir_x(sprite_get_width(sprite_index),image_angle),y+lengthdir_y(sprite_get_width(sprite_index),image_angle),CustomObject){
    with instance_create(x,y,CustomSlash){
        lifetime = 63
        team = _t
        image_xscale = 2.5
        image_yscale = 2.5
        mask_index  = sprPortalShock
        image_blend = c_black
        image_speed = 0
        image_alpha = 0
        damage = 0
        on_projectile = crit_proj
        on_step       = crit_step
        on_wall       = nothing
        on_hit        = crit_hit
    }
    image_angle = random(360)
    depth = other.depth -1
    image_speed = .6
    sprite_index = spr.Killslash
    image_xscale = random_range(1.3,1.5)
    image_yscale = image_xscale
    on_step = Killslash_step
    with instance_create(x,y,CustomObject){
        image_angle = other.image_angle - 90 + random_range(-8,8)
        depth = other.depth
        image_speed = .8
        sprite_index = spr.Killslash
        image_blend = c_black
        image_xscale = other.image_xscale-.5
        image_yscale = image_xscale
        on_step = Killslash_step
    }
}

#define Killslash_step
if image_index = 1.2 sleep(200)
if image_index >= 7 instance_destroy();

#define crit_proj
with other{
    if typ > 0 instance_destroy()
}

#define crit_step
if lifetime > 0
	lifetime -= current_time_scale
else
	instance_destroy()

#define crit_hit
if projectile_canhit_melee(other){
    projectile_hit(other, 2, 10, point_direction(other.x, other.y, x, y,))
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
lastteam = -1
mask_index = mskDisc
spr_trail = sprDiscTrail
spr_dead = sprDiscDisappear
hitid = [sprite_index, name]
on_destroy = disc_destroy

#define disc_step(dis)
dist += dis * current_time_scale
if speed > 0 and current_frame_active
    with instance_create(x, y, DiscTrail){
        sprite_index = other.spr_trail
    }
if instance_exists(creator) && team != -1 && !place_meeting(x,y,creator){
    lastteam = team
    team = -1
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
disc_step(speed/4)
if skill_get(mut_bolt_marrow){
    var q = instance_nearest_matching_ne(x,y,hitme,"team",lastteam)
    if instance_exists(q){
        if distance_to_object(q) < 30{
            var dir = point_direction(x,y,q.x,q.y)
            x += lengthdir_x(current_time_scale,dir)
            y += lengthdir_y(current_time_scale,dir)
        }
    }
};

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
else if skill_get(mut_bolt_marrow){
    var q = instance_nearest_matching_ne(x,y,hitme,"team",lastteam)
    if instance_exists(q) && distance_to_object(q) < 30
        motion_add(point_direction(x,y,q.x,q.y),.25*current_time_scale)
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


#define create_megadisc(_x,_y)
with instance_create(_x,_y,CustomProjectile){
    sprite_index = spr.MegaDisc
    damage = 2
    image_speed = .4
    maxspeed = speed
    name = "Mega Disc"

    disc_init()
    spr_trail = spr.MegaDiscTrail
    mask_index = sprite_index

    on_step    = md_step
    on_wall    = md_wall
    on_hit     = md_hit
    on_destroy = md_destroy

    return id
}

#define md_step
disc_step(1)
if skill_get(21){
    var q = instance_nearest_matching_ne(x,y,hitme,"team",lastteam)
    if instance_exists(q) && distance_to_object(q) <= 40{
        motion_add(point_direction(x,y,q.x,q.y),.5*current_time_scale)
        speed = maxspeed
    }
}

#define md_wall
dist += 5
sleep(20)
view_shake_at(x,y,8)
sound_play_pitchvol(sndDiscBounce,random_range(.6,.8),.4)
move_bounce_solid(false)
direction += random_range(-12,12)
with other{instance_create(x,y,FloorExplo);instance_destroy()}
with instance_create(x,y,DiscBounce){
    sprite_index = spr.MegaDiscBounce
}
if dist >= 200 instance_destroy()

#define md_destroy
sound_play_pitchvol(sndDiscDie,random_range(.6,.8),.4)
with instance_create(x,y,DiscDisappear){
    sprite_index = spr.MegaDiscDie
}

#define md_hit
if current_frame_active{
    if place_meeting(x,y,creator){
        sound_play(sndDiscHit)
        other.lasthit = hitid
        sleep(3*other.size+4)
    }
    x -= hspeed/2
    y -= vspeed/2
    projectile_hit(other,damage,0,direction)
    if other.my_health <= 0{
        sleep (other.size*2)
    }
    view_shake_at(x,y,8)
    dist++
}



#define create_knife(x, y)
with create_sword(x, y){
    name = "Knife"
    damage = 12
    force = 3
    mask_index   = sprHeavyGrenadeBlink
    sprite_index = spr.Knife
    spr_dead     = spr.KnifeStick
    maxwhoosh = 3
    bounce = 1
    anglespeed = 120

    defbloom.sprite = sprite_index
    slashrange = 40
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
    mask_index   = sprEnemyBullet1
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
    slashrange = 40
    length = 6
    whooshtime = 0
    maxwhoosh = 4
    bounce = 1

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
if whooshtime < current_time_scale audio_play_ext(sndMeleeFlip, x, y, 2 - length/6 + random_range(-.1, .1), length/6, 0);

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
	sleep(5)
	repeat(4){
		instance_create(x, y, Dust)
	}
	sound_play_hit_ext(sndDiscBounce, 2 * _p, .8)
	sound_play_hit_ext(sndChickenSword, 1.5 * _p, .5)
	move_bounce_solid(false)
	speed *= .8;
	length *= 1.2;
	direction += random_range(-7,7)
	with instance_create(x, y, MeleeHitWall) {
		image_angle = other.direction - 180
	}
}
else {
  sound_play_hit_ext(sndChickenSword, 1.5 * _p, .8)
  sound_play_hit_ext(sndBoltHitWall, .8 * _p, .8)
  sleep(4)
  view_shake_at(x, y, force * 2)
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
view_shake_at(x, y, force * 6)
projectile_hit(other, damage, force, direction)
with instance_create(x, y, AcidStreak){sprite_index = spr.SwordImpact; image_angle = other.direction; image_speed = .5}
other.x += 10000
var q = instance_nearest_matching_ne(x, y, hitme, "team", team)
if instance_exists(q) and q != other and q.mask_index != mskNone and distance_to_object(q) < slashrange{
    projectile_hit(q, damage, force, point_direction(x, y, q.x, q.y))
    with instance_create(q.x, q.y, CustomObject){
	    sound_play_hit_ext(sndChickenSword, 1.4*random_range(.9,1.2), .8)
	    instance_destroy()
    }
    with instance_create(q.x, q.y, CustomObject){
        sprite_index = spr.SwordSlash
        image_angle = point_direction(other.x, other.y, q.x, q.y)
        image_speed = .6
        image_yscale = -2
        depth = -3
        sleep(30)
        view_shake_at(x, y, 7)
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


#define create_sniper_charge(x, y)
with instance_create(x, y, CustomObject){
	name    = "sniper charge"
	creator = -4
	charge  = 0
	acc     = 1
	charged = 1
	maxcharge = 100
	chargespeed = 3.2
	holdtime = 150
	depth = TopCont.depth
	index = -1
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
var _ptch = random_range(-.5,.5)
sound_play_pitch(sndHeavyRevoler,.7-_ptch/3)
sound_play_pitch(sndSawedOffShotgun,1.8-_ptch)
sound_play_pitch(sndSniperFire,random_range(.6,.8))
sound_play_pitch(sndHeavySlugger,1.3+_ptch/2)
var _c = charge, _cc = charge/maxcharge;
with creator{
	weapon_post(12,2,158)
	motion_add(gunangle -180,_c / 20)
	sleep(120)
	var q = sniper_fire(x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), gunangle, team, 1 + _cc)
	with q{
	    creator = other
	    damage = 12 + round(28 * _cc)
	    worth = 12
	    instance_create(x, y, BulletHit)
	}
	bolt_line_bulk(q, 2 * _cc, c_yellow, c_orange)
}
sleep(charge*3)


#define sniper_fire(xx, yy, angle, t, width)
return sniper_fire_r(xx, yy, angle, t, width, 20, -1)

#define sniper_fire_r(xx, yy, angle, t, width, tries, pierces)
//FUCK YOU YOKIN FUCK YOU YOKIN FUCK YOU FUCK YOU FUCKYOU
if tries <= 0 return [-4]
var junk = [], _p = pierces;
with instance_create(xx, yy, CustomProjectile){
    mask_index = mskLaser
    image_yscale = 2
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
    do {
        dir += hyperspeed
    	x += _x
    	y += _y
    	with shields if place_meeting(x, y, other) {
    	    var a = point_direction(x, y, other.x, other.y);
    	    array_push(junk, sniper_fire_r(other.x, other.y, a, team, width, tries - 1, _p))
    	    stop = 1
    	    break
    	}
    	with slashes if place_meeting(x, y, other){
    	    array_push(junk, sniper_fire_r(other.x, other.y, direction, team, width, tries - 1, _p))
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
        var e = collision_line_first(x, y, x+_x, y+_y, Wall, 0, 0)
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

    var q = collision_line_first(c.x, c.y, wantx, wanty, Wall, 0, 0), a = point_direction(c.x, c.y, wantx, wanty);
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
	shrinkspeed = .1 - (skill_get(mut_laser_brain) * .04)
	basedir = undefined
	lasthit = -4

	trail_x = x
	trail_y = y
	trail_length = 12
	homing_range = 120
	homing_scope = 45

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
	projectile_hit(other, damage, force, direction)
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
	creator = other.creator
	team = other.team
	sprite_index = spr.VectorImpact
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
	other.vectorspeed = min(other.vectorspeed + .5/other.size, 12)
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
var hitem = 0
if skill_get(mut_bolt_marrow){
    var q = instance_nearest_matching_ne(x, y, hitme, "team", team)
    if instance_exists(q) and point_distance(q.x, q.y, x, y) < 24 {
        x = q.x - hspeed_raw
        y = q.y - vspeed_raw
        hitem = 1
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

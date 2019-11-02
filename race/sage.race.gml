#define init

global.spr = {}
    with spr{
        var i = "../sprites/sage/";
        
        GunIdle = sprite_add(i + "sprGunIdle.png", 6, 12, 12)
        GunWalk = sprite_add(i + "sprGunWalk.png", 6, 12, 12)
        GunHurt = sprite_add(i + "sprGunHurt.png", 3, 12, 12)
        GunDead = sprite_add(i + "sprGunDie.png", 6, 12, 12)
        GunSlct = sprite_add(i + "sprGunSlct.png", 1, 0, 0)
        GunIcon = sprite_add(i + "sprGunMapIcon.png", 2, 10, 8)
        GunLoad = sprite_add(i + "sprGunSkin.png", 2, 10, 8)
        GunPort = sprite_add(i + "sprGunPortrait.png", 1, 20, 250)
    }

    global.purblue = make_color_rgb(72, 61, 135)
    global.darkteal = make_color_rgb(1, 68, 65)
    
    with Player if race = mod_current create()

    
#macro spr global.spr
#macro c_purblue global.purblue
#macro c_darkteal global.darkteal

global.spells = ds_map_create();
#macro spell_doubleshot global.spells[? "doubleshot"]
	spell_doubleshot = {
		name : "DOUBLE SHOT",
		on_fire : script_ref_create(doubleshot_fire),
		on_wep_draw : script_ref_create(doubleshot_wep_draw),
		gunangle_offset : 20
	}

#define race_name
    return "SAGE"

#define race_text
    return "2 BULLET CHAMBER#SPECIAL AMMO"

#define race_mapicon
    return spr.GunIcon
    
#define race_tb_text
	return `ADVANCED @(color:${c_purblue})MAGICS@s`;

#define race_skin_button(skin)
    sprite_index = spr.GunLoad
    image_index = 0

#define race_skins
    return 1

#define race_skin_avail
    return 1

#define race_portrait
    return spr.GunPort;

#define race_menu_button
    sprite_index = spr.GunSlct;

#define race_ultra_button
    sprite_index = spr.GunSlct;

#define race_ultra_name
switch(argument0){
	case 1: return "HIGH CALIBER";
	case 2: return "DOUBLE BARRELED";
}

#define race_ultra_text
switch (argument0){
	case 1: return `@(color:${c_purblue})SPELLS@s ARE EMPOWERED`;
	case 2: return `BOTH @(color:${c_purblue})SPELLS@s ARE ACTIVE`;
}

#define race_ttip
var tips = ["A NEW WORLD", "WHERE WERE WE?", "FASCINATING @wWEAPONRY@s"];

if !irandom(1) array_push(tips, "SAGE CAN DO COOL TRICKS")

if instance_exists(GameCont){
    if GameCont.loops > 0 array_push(tips, "IT ALL REVOLVES AROUND")
    if GameCont.area == 103 array_push(tips, "NO, THIS ISN'T IT")
    if GameCont.area == 104 array_push(tips, "SO THIS IS WHERE @pIT@s COMES FROM")
}

return tips[irandom(array_length(tips) - 1)]


#define create()
	spr_idle = spr.GunIdle;
	spr_walk = spr.GunWalk;
	spr_hurt = spr.GunHurt;
	spr_dead = spr.GunDead;

	snd_hurt = sndStreetLightBreak;
	snd_dead = sndStreetLightBreak;
	snd_lowh = sndHyperRifle;
	snd_lowa = sndShotReload;

	snd_cptn = sndGoldUnlock;
	snd_spch = sndWaveGun;

	snd_wrld = sndGoldUnlock;
	snd_chst = sndFishWarrantEnd;
	snd_thrn = sndGoldChest;
	snd_crwn = sndCrownGuns;
	snd_valt = sndGoldChest;
	snd_idpd = snd_cptn;

	var _x = x,
	    _y = y;

	sageblob = {
	    gx : _x,
	    gy : _y,
	    x : _x,
	    y : _y,
	    right : 0,
	    xoff : 0,
	    yoff : 0,
	    dir : 0,
	    spd : 0,
	    move: 0,
	    curve : 0,
	    resettime : 0,
	    col : c_purblue,
	    sprite : sprSnowFlake,
	    angle : 0
	}
	
	sagespellinfo = {
		couldaim  : 0,
		couldfire : 0,
		couldspec : 0,
		swapoffset: 0
	}
	
	sagespells = []
	

#define draw_begin
    if !sign(sageblob.y) blob_draw()
    
#define draw
    if sign(sageblob.y) blob_draw()


#define step
    var h = sageblob;

    if h.resettime <= 0{
        h.x += approach(h.x, h.gx, 4, current_time_scale)
        h.y += approach(h.y, h.gy, 4, current_time_scale)
        
        h.right = -sign(h.x - x)
        h.angle = 90 - (90 * h.right)

        h.col = merge_colour(c_purblue, c_black, .7)

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
    else h.resettime -= current_time_scale
    
    if canspec and (button_pressed(index, "spec") or usespec == 0) {
    	if ultra_get(mod_current, 2) {
    		//wtf does right click do with ultra b
    	}
    	else {
    		spell_disable(sagespells[0])
    		spell_swap()
    		spell_enable(sagespells[0])
    	}
    }
    
    
    var _needfire = false, _scripts = [];
	with sagespells {
		if on_fire != undefined {
			_needfire = true
			array_push(_scripts, on_fire)
		}
	}
    
	if _needfire {
		while (reload <= 0 and ((button_pressed(index, "fire") or (weapon_get_auto(wep) and button_check(index, "fire"))) or clicked)) {
			script_ref_call_self(_spell.on_fire)
		}
	}

    
    
#define spell_step(_spell)
	if _spell.gunangle_offset != 0 {
		gunangle = point_direction(x, y, mouse_x[index], mouse_y[index]) + _spell.gunangle_offset
	}

    
#define spell_enable(_spell)
    if _spell.gunangle_offset != 0 {
    	sagespellinfo.couldaim = max(canaim, sagespellinfo.couldaim)
    	canaim = 0
    }
    
#define spell_disable(_spell)
	if _spell.gunangle_offset != 0 {
		var _a = canaim;
		canaim = sagespellinfo.couldaim
		sagespellinfo.couldaim = _a;
	}

#define spell_swap
	sound_play_pitchvol(sndExploGuardianCharge, 1.4, .5)
	sagespellinfo.swapoffset = 1
	sagespells = [sagespells[1], sagespells[0]]


#define approach(a, b, n, dn)
	return (b - a) * (1 - power((n - 1)/n, dn))

#define angle_approach(a, b, n, dn)
	return angle_difference(a, b) * (1 - power((n - 1)/n, dn))
	
#define script_ref_call_self(scr)
	return mod_script_call_self(scr[0], scr[1], scr[2])
	
#define blob_draw
	if visible {
	    var h = sageblob;
	    d3d_set_fog(1, h.col, 1, 1)
	    draw_sprite_ext(h.sprite, 0, h.x, h.y, 1, h.right, h.angle, h.col, 1)
	    d3d_set_fog(1, c_purblue, 1, 1)
	    draw_set_blend_mode(bm_add)
	    var gsize = 1/64;
	    var w = sprite_get_width(h.sprite) + 12, l = sprite_get_height(h.sprite) + 16;
	    draw_sprite_ext(sprGhostGuardianIdle, -1, h.x, h.y, w * gsize, l * gsize, 0, c_white, .5)
	    d3d_set_fog(0, 0, 0, 0)
	    draw_set_blend_mode(bm_normal)
	}

#define weapon_can_fire
/// weapon_can_fire(_wep, _times = 1)
var _wep = argument[0];
var _times = argument_count > 1 ? argument[1] : 1;
return (infammo != 0) or ((weapon_get_cost(_wep) * _times) <= ammo[weapon_get_type(_wep)])


#define doubleshot_fire


#define doubleshot_wep_draw











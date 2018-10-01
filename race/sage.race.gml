#define init

global.handbotroll = sprite_add("handbotwalk2.png",6,10,5)
global.handbotslct = sprite_add("handbotslct.png",1,0,0)

global.gunIdle = sprite_add("sprGunIdle.png",6,12,12)
global.gunWalk = sprite_add("sprGunWalk.png",6,12,12)
global.gunHurt = sprite_add("sprGunHurt.png",3,12,12)
global.gunDie  = sprite_add("sprGunHurt.png",6,12,12)
global.gunSlct = sprite_add("sprGunSlct.png",1,0,0)
global.gunMap  =  sprite_add("sprGunMapIcon.png",2,10,8)
global.gunLoad =  sprite_add("sprGunSkin.png",2,10,8)

global.purblue = make_color_rgb(72,61,135)
global.darkteal = make_color_rgb(1,68,65)

global.hands = sprite_add("magichands.png",3,3,6)

global.skintone = make_color_rgb(253,210,169)

with instances_matching(CustomDraw,"name",mod_current) instance_destroy()
global.drawers = [noone,noone]
global.scripts = [script_ref_create(spellpicker),script_ref_create(draw_hud)]
global.depths = [-14, -20]

with Player if race = mod_current create()

global.protowep = wep_rusty_revolver

global.spells = ds_map_create()
global.spellnames = []

global.sprReflect = sprite_add("sprReflect.png",3,90,90)
global.mskReflect = sprite_add("mskReflect.png",3,90,90)

//dev spells
//add_spell("Drain Mana",NA,scr(cheat1),NA,NA,1,sprite_add("sprShield.png",2,8,7),sprite_add("ShieldBlob.png",1,3,3))
//add_spell("Gimme Mana",NA,scr(cheat2),NA,NA,1,sprite_add("sprShield.png",2,8,7),sprite_add("ShieldBlob.png",1,3,3))

//add_spell("No Spell", NA,scr(none_channel),scr(none_release),NA,1,global.hands)

add_spell("Merge", scr(merge_cast),NA,NA,NA,1,sprite_add("sprMerge.png",2,8,7),sprite_add("MergeBlob.png",1,4,4))
add_spell("Rapid Fire",NA,scr(rapid_channel),NA,NA,1,sprite_add("sprBlast.png",2,8,7),sprite_add("RapidFireBlob.png",1,4,3))
add_spell("Proto Swap",scr(proto_cast),NA,NA,NA,1,sprite_add("sprProto.png",2,7,7),sprite_add("ProtoChestBlob.png",1,4,3))

//ultra spells
add_spell("Haste",scr(haste_cast),NA,NA,NA,ultraspell,sprite_add("sprHaste.png",2,7,7),sprite_add("HasteBlob.png",1,4,3))
add_spell("Shield",scr(shield_cast),NA,NA,NA,ultraspell,sprite_add("sprShield.png",2,8,7),sprite_add("ShieldBlob.png",1,3,3))

#macro maxmana 200

#macro ultraspell scr(ultra_avail)

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define cleanup
with instances_matching(CustomDraw,"name",mod_current) instance_destroy()

#define scr(script)
return script_ref_create(script)

#macro NA script_ref_create(nothing)
#define nothing

#define ultra_avail
return ultra_get(mod_current,2)

#define add_spell(name,on_cast,on_channel,on_release,on_step,avail,icon,blob)
global.spells[? name] = [name,on_cast,on_channel,on_release,on_step,avail,icon,blob]
array_push(global.spellnames,name)

#define draw_hud
with Player if race = mod_current && player_is_local_nonsync(index){
    var _x = view_xview_nonsync + 20;
    var _y = view_yview_nonsync + 4;
    var width = 86;
    if curp() > 1 _x -= 17
    draw_line_width_color(_x-1,_y-.5,_x+width+1,_y-.5,5,c_black,c_black)
    draw_line_width_color(_x,_y-1,_x+width,_y-1,2,c_white,c_white)
    draw_line_width_color(_x+.5,_y-2,_x+.5,_y+3,1,c_white,c_white)
    draw_line_width_color(_x+ width-.5,_y-2,_x+ width-.5,_y+3,1,c_white,c_white)
    draw_line_width_color(_x+1, _y, _x + width-1, _y, 2, c_dkgray, c_dkgray)
    draw_line_width_color(_x+1, _y, _x+max((hand.mana/maxmana) * (width-1),1), _y, 2, shinetime > 0 ? c_white : global.purblue, shinetime > 0 ? c_white : merge_color(c_aqua,global.purblue,1-hand.mana/maxmana))
    //draw_line_width_color(_x+1,_y-.5,_x+width-1,_y-.5,1,c_black,c_black)//you could leave that one out i guess
}

#define game_start
global.protowep = wep_rusty_revolver

#define race_name
    return "SAGE";

#define race_text
	return `ACCURATE#@(color:${global.purblue})SPELLCASTING`;

#define race_tb_text
	return `EMPOWERED @(color:${global.purblue})SPELLS`;

#define race_mapicon
return global.gunMap;

#define race_skin_button(skin)
sprite_index = global.gunLoad
image_index = skin

/*
#define race_portrait
return global.spr_port;

*/
#define race_menu_button
sprite_index = global.gunSlct;

/*
#define race_ultra_button
sprite_index = global.spr_ult[argument0];
*/
#define race_ultra_name
switch(argument0){
	case 1: return "uuuuuhhhhhhhhhhhhh";
	case 2: return "EXPANDED CHAMBER";
}

#define race_ultra_text
switch (argument0){
	case 1: return "This isn't implemented yet";
	case 2: return `MORE @(color:${global.purblue})SPELLS`;
}


#define race_ttip
return choose("A NEW WORLD", `COLLECTING @yPICKUPS@s GIVES YOU @(color:${global.purblue})MANA@s`, "FASCINATING @wWEAPONRY@s")

#define create
	spr_idle = global.gunIdle;
	spr_walk = global.gunWalk;
	spr_hurt = global.gunHurt;
	spr_dead = global.gunDie;

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

	controlprompted = 0
	hastetime = 0
	shinetime = 0

	var _x = x,
	    _y = y;

	hand = {
	    mana : maxmana,
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
	    spell : "No Spell",
	    resettime : 0,
	    index : 0,
	    col : global.purblue,
	    animcol : global.skintone,
	    sprite : sprSnowFlake,
	    angle : 0,
	    menulength : 0,
	    cancast : 1
	}

#define instances_in(left,top,right,bottom,obj)
return instances_matching_gt(instances_matching_lt(instances_matching_gt(instances_matching_lt(obj,"y",bottom),"y",top),"x",right),"x",left)

#define step
for var i = 0; i< array_length_1d(global.drawers); i++{
    if !instance_exists(global.drawers[i])
        with script_bind_draw(nothing,global.depths[i]){
            persistent = 1
            global.drawers[i] = id
            name = mod_current
            script = global.scripts[i]
        }
}

    var size = 15
    var wantmana = 0;
    with instances_in(bbox_left-size,bbox_top-size,bbox_right+size,bbox_bottom+size,[HPPickup,AmmoPickup,Rad,BigRad]){
        mask_index = mskNone
        if point_distance(x,y,other.x,other.y) <= 10{
            if instance_is(self,Rad) wantmana += 1.5
            else wantmana += 5
            if instance_is(self,HPPickup) && skill_get(mut_second_stomach) wantmana += 5
            wantmana += (GameCont.crown = crwn_haste)
            event_perform(ev_collision,Player)
        }
    }
    hand.mana = min(hand.mana + wantmana,maxmana)

    if shinetime > 0{
        shinetime = max(shinetime-current_time_scale,0)
    }
    if wantmana > 0 shinetime = 5


    if hastetime > 0{
        hastetime = max(hastetime-current_time_scale,0)
        if hastetime = 0{
            maxspeed -= 1 + skill_get(mut_throne_butt)*.5
            accuracy *= (1.25+skill_get(mut_throne_butt)*.15)
        }
        if current_frame_active with instance_create(x,y,CustomObject){
            sprite_index = other.sprite_index
            image_index = other.image_index
            image_speed = 0
            image_alpha = 0
            right = other.right
            gravity = -.5
            color = merge_color(merge_color(c_black,c_white,random(1)),global.purblue,random(1))
            on_draw = flash_draw
            if fork(){
                wait(4)
                if instance_exists(self) instance_destroy()
                exit
            }
        }
    }

    var h = hand;
    var click = button_check(index,"spec") * canspec;

    if h.resettime <= 0{
        var ang = point_direction(h.x,h.y,h.gx,h.gy);
        var dis = point_distance(h.gx,h.gy,h.x,h.y);

        h.x += lengthdir_x((dis/4)*current_time_scale,ang)
        h.y += lengthdir_y((dis/4)*current_time_scale,ang)
        h.right = -sign(h.x-x)
        h.angle = 90 - 90*h.right

        h.col = merge_colour(global.purblue,c_black,.7)

        h.gx = x + (h.xoff - 10)*right
        h.gy = y + h.yoff - 16

        if random(100) < 2*current_time_scale{
            h.dir = random(360)
            h.move = irandom_range(4,10)
            h.spd = random(2)
            h.curve = random_range(-10,10)
            h.curve += sign(h.curve)*3
        }
        if h.move > 0{
            h.move -= current_time_scale
            h.xoff += lengthdir_x(h.spd*current_time_scale,h.dir)
            h.yoff += lengthdir_y(h.spd*current_time_scale,h.dir)
            h.dir += h.curve * current_time_scale
            h.curve += sign(h.curve) * current_time_scale
            if point_distance(h.xoff,h.yoff,0,0) > 10{
                h.dir -= angle_difference(h.dir,point_direction(h.xoff,h.yoff,0,0))*current_time_scale/3
            }
        }

        h.index = 0
    }
    else h.resettime -= current_time_scale

    hand = h

    if canspec && hand.spell != "No Spell"{
        if button_pressed(index,"spec"){
            var array = global.spells[? h.spell][1];
            mod_script_call(array[0],array[1],array[2])
        }
        else if click{
            var array = global.spells[? h.spell][2];
            mod_script_call(array[0],array[1],array[2])

        }
        else if button_released(index,"spec"){
            var array = global.spells[? h.spell][3];
            mod_script_call(array[0],array[1],array[2])
        }
    }


#define draw_begin
if !sign(hand.y) hand_draw()
#define draw
if sign(hand.y) hand_draw()

#define hand_draw
if visible{
    var h = hand;
    d3d_set_fog(1,h.col,1,1)
    draw_sprite_ext(h.sprite,-1,h.x ,h.y ,1,h.right,h.angle,h.col,1)
    d3d_set_fog(1,global.purblue,1,1)
    draw_set_blend_mode(bm_add)
    var gsize = 1/64;
    var w = sprite_get_width(h.sprite) + 12, l = sprite_get_height(h.sprite) + 16;
    draw_sprite_ext(sprGhostGuardianIdle,-1,h.x,h.y,w*gsize,l*gsize,0,c_white,.5)
    d3d_set_fog(0,0,0,0)
    draw_set_blend_mode(bm_normal)
}

#define textdraw
if alphatime > 0 and alpha < 1{
    alpha = min(alpha + .1*current_time_scale, 1)
}
if alpha = 1 and alphatime > 0{
    alphatime = max(alphatime - current_time_scale, 0)
}
if alphatime = 0 and alpha > 0{
    alpha -= .1*current_time_scale
}
var sf = surface_create(100,20);
surface_set_target(sf)
draw_set_halign(1)
draw_set_font(fntSmall)
draw_clear_alpha(0,0)
draw_text_shadow(50,0,"HOLD KEYS 1-4 TO# SWITCH SPELLS")
surface_reset_target()
if instance_exists(creator){
    draw_surface_ext(sf,creator.x - 50,creator.y + 20,1,1,0,c_white,alpha)
}
surface_destroy(sf)
if alphatime = 0 and alpha < 0 instance_destroy()

#macro view_xc view_xview[index] + game_width/2
#macro view_yc view_yview[index] + game_height/2

#define spellpicker
with instances_matching(Player,"race",mod_current){
    var btn = "key4"
    if hand.spell = "No Spell" btn = "spec"
    var btns = ["key1","key2","key3","key4"]
    for var i = 0; i < array_length(btns); i++{
        if button_pressed(index,btns[i]) || button_check(index,btns[i]) || button_released(index,btns[i]){
            btn = btns[i]
            break
        }
    }

    if button_pressed(index,btn){
        hand.menulength = .1
        if controlprompted = 0 {
            controlprompted = 1
            with instance_create(x,y,CustomObject){
                creator = other
                on_draw = textdraw
                alpha = 0
                alphatime = 90
            }
        }
    }
    if visible && (button_check(index,btn) || button_released(index,btn)){
        draw_set_visible_all(0)
        draw_set_visible(index,1)
        var picks = [];
        for var i = 0; i< array_length_1d(global.spellnames); i++{
            var avail = global.spells[? global.spellnames[i]][5];
            if is_array(avail){
                avail = mod_script_call(avail[0],avail[1],avail[2])
            }
            if avail == true array_push(picks,global.spellnames[i])
        }
        var int = 360/array_length_1d(picks);
        var num = 0;
        var l = hand.menulength;
        var startang = 0;
        var xc = game_width/2;
        var yc = game_height/2;
        draw_set_projection(0)
        for var a = startang; a<startang+360; a+=int{
            var pointed = abs(angle_difference(point_direction(view_xc,view_yc,mouse_x[index],mouse_y[index]),a)) < int/2;
            var col = pointed? c_white : c_gray;
            var _x = xc + lengthdir_x(40,a), _y = yc + lengthdir_y(40,a);
            var size = 1

            var ang = (a + int/2)
            draw_line_width_color(xc + lengthdir_x(50, ang),yc + lengthdir_y(50, ang),xc + lengthdir_x(10, ang),yc + lengthdir_y(10, ang),1,c_white,c_white)

            draw_sprite_ext(global.spells[? picks[num]][6], pointed, _x, _y, size, size, 0, col, l)

            draw_set_font(fntSmall)
            draw_set_halign(1)
            draw_set_color(col)
            draw_text_shadow(_x,_y + 10,picks[num])

            if pointed && button_released(index,btn){
                hand.spell = picks[num]
                hand.sprite = global.spells[? picks[num]][7]
            }
            num++
        }
        draw_reset_projection()
        hand.menulength = min(hand.menulength + hand.menulength * current_time_scale,1)
        draw_set_color(c_white)
    }
    draw_set_visible_all(1)
}

#define flash_draw
d3d_set_fog(1,color,0,0)
draw_sprite_ext(sprite_index,image_index,x,y,(.9+random(.2))*right,.9+random(.2),0,0,.3+random(.2))
d3d_set_fog(0,0,0,0)

#define instance_random(obj)
var a = instances_matching(obj,"",null);
var b = array_length_1d(a)
if b return a[irandom(b-1)]
return -4

#define instance_random_matching(obj,vari,val)
var a = instances_matching(obj,vari,val);
var b = array_length_1d(a)
if b return a[irandom(b-1)]
return -4

#define curp()
var n = 0;
for (var i=0; i<maxp; i++){
	if player_is_active(i) n++
}
return n

#define merge_cast
if hand.mana >= maxmana{
    hand.x = x + 8*right
    hand.y = y + -12
    hand.col = c_white
    hand.resettime = 6
    repeat(12){
        with instance_create(hand.x ,hand.y,FireFly){
            sprite_index = sprLightning
            hspeed = random_range(-2,2)
            gravity = -random(.2)
        }
    }
    if mergable(wep) && mergable(bwep) && bwep != 0 && wep != 0{
        wep = mod_script_call("mod","merging","wep_combine",wep,bwep)
        hand.mana -= maxmana
        bwep = 0
    }
}

#define mergable(wep)
if is_real(wep) return 1
if is_string(wep) return is_undefined(mod_script_call("wep",wep,"weapon_mergable"))
if is_object(wep){
    if wep.wep = "merged weapon"{
        if skill_get(5) and wep.merged == 0 return 1
        return 0
    }
    return mergable(wep.wep)
}

#define cheat1
hand.mana = max(hand.mana - current_time_scale*2,0)

#define cheat2
hand.mana = min(hand.mana + current_time_scale*2, maxmana)

#define rapid_channel
if hand.mana >= 1.5*current_time_scale && weapon_get_type(wep) != 0{
    hand.gx = x + lengthdir_x(15,gunangle+30*right) + hspeed
    hand.gy = y + lengthdir_y(15,gunangle+30*right) - 5 + vspeed
    hand.col = c_white
    hand.angle = gunangle
    hand.mana -= 1.5*current_time_scale
    if reload >= 0 reload -= (1+skill_get(mut_throne_butt))*current_time_scale
    var _t = weapon_get_type(wep), _c = weapon_get_cost(wep), n = 0, _a = weapon_get_auto(wep) + 1;
    while ammo[_t] >= _c && reload <= 0 && _a && ++n < 100 {
        specfiring = 1
        player_fire()
        if mod_exists("mod","defparticles") && array_length_1d(instances_matching(CustomObject,"name","spark")) < 30 repeat(random(weapon_get_load(wep))*(1+skill_get(mut_throne_butt)/2)){
            with mod_script_call("mod","defparticles","create_spark",x,y){
                gravity_direction = other.gunangle
                gravity = 2+random(1)
                friction = 1
                motion_set(other.gunangle+random_range(-20,20)+180,random_range(6,16))
                var colorset = choose([c_aqua,c_purple],[c_purple,c_white])
                fadecolor = colorset[0]
                color = colorset[1]
                fadespeed = 1/10
                age = 8 + irandom(4)
            }
        }
    }
    specfiring = 0
}

#define proto_cast
var cost = 50 - 25*skill_get(mut_throne_butt)
if hand.mana >= cost{
    //hand.mana -= cost
    hand.col = c_white
    instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),WepSwap)
    if mod_exists("mod","defparticles") && array_length_1d(instances_matching(CustomObject,"name","spark")) < 30 repeat(24){
         with mod_script_call("mod","defparticles","create_spark",hand.x,hand.y){
            motion_add(choose(random_range(60,0),random_range(120,180)),3)
            gravity_direction = 90 + 90*sign(hspeed)
            gravity = .5
            friction = 1
            color = c_lime
            fadecolor = c_yellow
            fadespeed = .2
            age = 6
         }
    }
    sound_play(sndChest)
    sound_play(sndCrystalRicochet)
    var we = wep;
    wep = global.protowep;
    global.protowep = we;
}

#define haste_cast
if hand.mana >= 50{
    hand.mana -= 50
    if hastetime = 0{
        maxspeed += 1 + skill_get(mut_throne_butt)*.5
        accuracy /= (1.25+skill_get(mut_throne_butt)*.15)
    }
    hastetime += 300
    hand.resettime = 10
    if fork(){
        var time = 10, starttime = time;
        while time > 0 && instance_exists(self){
            time-= current_time_scale
            hand.col = merge_color(global.purblue,c_white,time/starttime)
            wait(0)
        }
        exit
    }
}


#define shield_cast
if hand.mana >= 6{
    hand.mana -= 0//6
    speed = 0
    with instance_create(x,y,CustomSlash){
        on_projectile = shine_proj
        on_grenade = shine_grenade
        on_hit = shine_hit
        on_anim = shine_anim
        team = other.team
        image_speed = 1
        image_xscale = .5
        image_yscale = .5
        //image_blend  = global.purblue
        sprite_index = global.sprReflect
        mask_index   = global.mskReflect
    }
}

#define shine_proj
with other{
	if typ = 1{
		team = other.team
		direction = point_direction(other.x,other.y,x,y)
		image_angle = direction
		with instance_create(x,y,Deflect) image_angle = other.image_angle
		sound_play_pitch(sndShielderDeflect,1.5*random_range(.8,1.2))
	}
	if typ = 2 || typ = 3{
		instance_destroy()
	}
}

#define shine_anim
instance_destroy()

#define shine_grenade
with other{
	direction = point_direction(other.x,other.y,x,y)
	image_angle = direction
}

#define shine_hit


#define none_channel
hand.gx = x + lengthdir_x(16,gunangle)
hand.gy = y + lengthdir_y(16,gunangle)
hand.index = 2
var hold = 0
if instance_exists(projectile) with instance_nearest(hand.x,hand.y,projectile) if distance_to_point(other.hand.x+other.x,other.hand.y+other.y) < 5{
    x = other.hand.x - hspeed_raw
    y = other.hand.y - vspeed_raw
    team = other.team
    hold = 1
}

if !hold && instance_exists(enemy) with instance_nearest(hand.x,hand.y,enemy) if size < 2  && distance_to_point(other.hand.x,other.hand.y) < 5{
    x = other.hand.x - hspeed_raw
    y = other.hand.y - vspeed_raw
    team = other.team
}


#define none_release
var hold = 0;
if instance_exists(projectile) with instance_nearest(hand.x,hand.y,projectile) if distance_to_point(other.hand.x,other.hand.y) < 5{
    instance_create(x,y,Dust)
    instance_destroy()
    sound_play_pitch(sndWallBreak,3)
    hold = 1
}

if !hold && instance_exists(enemy) with instance_nearest(hand.x,hand.y,enemy) if size < 2 && distance_to_point(other.hand.x,other.hand.y) < 5{
    my_health = 0
    instance_create(x,y,BloodStreak)
    sound_play(sndMaggotSpawnDie)
}

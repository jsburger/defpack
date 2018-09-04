#define init

global.handbotroll = sprite_add("handbotwalk2.png",6,10,5)
global.handbotslct = sprite_add("handbotslct.png",1,0,0)

global.gunIdle = sprite_add("sprGunIdle.png",6,12,12)
global.gunWalk = sprite_add("sprGunWalk.png",6,12,12)
global.gunSlct = sprite_add("sprGunSlct.png",1,0,0)


global.purblue = make_color_rgb(72,61,135)
global.darkteal = make_color_rgb(1,68,65)

global.hands = sprite_add("magichands.png",3,3,6)

global.skintone = make_color_rgb(253,210,169)

with instances_matching(CustomDraw,"name",mod_current) instance_destroy()
global.drawers = [noone,noone]
global.scripts = [script_ref_create(spellpicker),script_ref_create(draw_hud)]
global.depths = [-14, -20]

with Player if race = mod_current create()

global.spells = ds_map_create()
global.spellnames = []

add_spell("No Spell", NA,scr(none_channel),scr(none_release),NA,1,global.hands)
add_spell("Merge", scr(merge_cast),NA,NA,NA,1,sprite_add("sprMerge.png",1,8,7))
add_spell("Drain Mana",NA,scr(cheat1),NA,NA,1,sprite_add("sprShield.png",1,8,7))
add_spell("Gimme Mana",NA,scr(cheat2),NA,NA,1,sprite_add("sprShield.png",1,8,7))
add_spell("Rapid Fire",NA,scr(rapid_channel),NA,NA,1,sprite_add("sprBlast.png",1,8,7))

trace("karm if youre reading this, try to come up with an alternative to the hand, or at least some way to make it look cool. thanks")


#define scr(script)
return script_ref_create(script)

#macro NA script_ref_create(nothing)
#define nothing

#define add_spell(name,on_cast,on_channel,on_release,on_step,avail,icon)
global.spells[? name] = [name,on_cast,on_channel,on_release,on_step,avail,icon]
array_push(global.spellnames,name)

#define draw_hud
with Player if race = mod_current{
    draw_set_visible_all(0)
    draw_set_visible(index,1)
    var _x = view_xview_nonsync + 20;
    var _y = view_yview_nonsync + 16;
    var width = 86;
    if curp() > 1 _x -= 19
    draw_line_width_color(_x-1,_y+.5,_x+1+width,_y+.5,5,c_black,c_black)
    draw_line_width_color(_x, _y, _x + width, _y, 2, c_dkgray, c_dkgray)
    draw_line_width_color(_x, _y, _x+(hand.mana/100) * width, _y, 2, global.purblue, merge_color(c_aqua,global.purblue,1-hand.mana/100))
}
draw_set_visible_all(1)

#define race_name
    return "SAGE";

#define race_text
	return `ACCURATE#@(color:${global.purblue})SPELLCASTING`;

#define race_tb_text
	return `EMPOWERED @(color:${global.purblue})SPELLS`;

#define race_mapicon
return sprHeavyRevolver;

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
	case 1: return "X";
	case 2: return "D";
}

#define race_ultra_text
switch (argument0){
	case 1: return "haha";
	case 2: return "yes";
}


#define race_ttip
return("A NEW WORLD")

#define create
	spr_idle = global.gunIdle
	spr_walk = global.gunWalk;
	spr_hurt = sprLilHunterHurt;
	spr_dead = sprLilHunterDead;

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
	
	hand = {
	    mana : 100,
	    gx : 0,
	    gy : 0,
	    x : 0,
	    y : 0,
	    spell : "No Spell",
	    resettime : 0,
	    index : 0,
	    col : global.skintone,
	    animcol : global.skintone,
	    angle : 0,
	    menulength : 0,
	    cancast : 1
	}

	maxhealth = 8;

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


    var h = hand;
    var click = button_check(index,"spec") * canspec;
    var ang = point_direction(h.x,h.y,h.gx,h.gy);
    var dis = point_distance(h.gx,h.gy,h.x,h.y);

    if h.resettime <= 0{
        h.x += lengthdir_x((dis/3)*current_time_scale,ang)
        h.y += lengthdir_y((dis/3)*current_time_scale,ang)
        h.angle = point_direction(0,0,h.x,h.y)
    
        h.gx =lengthdir_x(8,gunangle)
        h.gy =lengthdir_y(5,gunangle)
    
        h.index = 0
    }
    else h.resettime -= current_time_scale
    
    hand = h
    
    if canspec{
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
    var hright = sign(h.x);
    draw_sprite_ext(global.hands,h.index,x+h.x ,y+h.y ,1,hright,h.angle,h.col,1)
}

#macro view_xc view_xview[index] + game_width/2
#macro view_yc view_yview[index] + game_height/2


#define spellpicker
with instances_matching(Player,"race",mod_current){
    var btn = "key4"
    if button_pressed(index,btn){
        hand.menulength = .1
    }
    if visible && (button_check(index,btn) || button_released(index,btn)){
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
            var size = 1 + .2*pointed
            
            var ang = (a + int/2)
            draw_line_width_color(xc + lengthdir_x(50, ang),yc + lengthdir_y(50, ang),xc + lengthdir_x(10, ang),yc + lengthdir_y(10, ang),1,c_white,c_white)
            
            draw_sprite_ext(global.spells[? picks[num]][6], 0, _x, _y, size, size, 0, col, l)
            
            draw_set_font(fntSmall)
            draw_set_halign(1)
            draw_set_color(col)
            draw_text_shadow(_x,_y + 10,picks[num])
            
            if pointed && button_released(index,btn){
                hand.spell = picks[num]
            }
            num++
        }
        draw_reset_projection()
        hand.menulength = min(hand.menulength + hand.menulength * current_time_scale,1)
        draw_set_color(c_white)
    }
}
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
if hand.mana >= 100{
    hand.x = 8*right
    hand.y = -12
    hand.index = 1
    hand.angle = 90 - 90*right
    hand.resettime = 6
    repeat(12){
            with instance_create(x+hand.x ,y+hand.y,FireFly){
                sprite_index = sprLightning
                hspeed = random_range(-2,2)
                gravity = -random(.2)
            }
        }
    if mergable(wep) && mergable(bwep) && bwep != 0 && wep != 0{
        wep = mod_script_call("mod","merging","wep_combine",wep,bwep)
        bwep = 0
    }
}

#define mergable(wep)
if is_real(wep) return 1
if is_string(wep) return is_undefined(mod_script_call("wep",wep,"weapon_mergable"))
if is_object(wep){
    if wep.wep = "merged weapon"{
        return (wep.merged * skill_get(mut_throne_butt)) == 1
    }
    return mergable(wep.wep)
}

#define cheat1
hand.mana = max(hand.mana - current_time_scale*2,0)

#define cheat2
hand.mana = min(hand.mana + current_time_scale*2, 100)

#define rapid_channel
if hand.mana >= current_time_scale{
    hand.hx = lengthdir_x(10,gunangle+45*right)
    hand.gy = lengthdir_y(10,gunangle+45*right)
    hand.index = 2
    hand.angle = gunangle
    hand.mana -= current_time_scale
    if reload >= 0 reload -= (1+skill_get(mut_throne_butt)/2)*current_time_scale
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
                fadecolor = c_aqua
                color = c_purple
                fadespeed = 1/10
                age = 8 + irandom(4)
            }
        }
    }
    specfiring = 0
}

#define none_channel
hand.gx = lengthdir_x(16,gunangle)
hand.gy = lengthdir_y(16,gunangle)
hand.index = 2
var hold = 0
if instance_exists(projectile) with instance_nearest(x+hand.x,y+hand.y,projectile) if distance_to_point(other.hand.x+other.x,other.hand.y+other.y) < 5{
    x = other.x + other.hand.x - hspeed_raw
    y = other.y + other.hand.y - vspeed_raw
    team = other.team
    hold = 1
}

if !hold && instance_exists(enemy) with instance_nearest(x+hand.x,y+hand.y,enemy) if size < 2  && distance_to_point(other.hand.x+other.x,other.hand.y+other.y) < 5{
    x = other.x + other.hand.x - hspeed_raw
    y = other.y + other.hand.y - vspeed_raw
    team = other.team
}


#define none_release
var hold = 0;
if instance_exists(projectile) with instance_nearest(x+hand.x,y+hand.y,projectile) if distance_to_point(other.hand.x+other.x,other.hand.y+other.y) < 5{
    instance_create(x,y,Dust)
    instance_destroy()
    sound_play_pitch(sndWallBreak,3)
    hold = 1
}

if !hold && instance_exists(enemy) with instance_nearest(x+hand.x,y+hand.y,enemy) if size < 2 && distance_to_point(other.hand.x+other.x,other.hand.y+other.y) < 5{
    my_health = 0
    instance_create(x,y,BloodStreak)
    sound_play(sndMaggotSpawnDie)
}


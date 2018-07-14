#define init

global.handbotroll = sprite_add("handbotwalk2.png",6,10,5)
global.handbotslct = sprite_add("handbotslct.png",1,0,0)


global.hands = sprite_add("magichands.png",3,6,6)
global.col = make_color_rgb(6,191,0)
global.lightningcol = make_color_rgb(120,190,255)
global.firecol = make_color_rgb(255,53,53)

global.skincolors = [c_black,global.col,make_color_rgb(173,80,185),make_color_rgb(0,120,252),make_color_rgb(240,215,190),make_color_rgb(138,183,6),c_dkgray,
make_color_rgb(253,220,179),make_color_rgb(174,185,187),make_color_rgb(248,249,228),make_color_rgb(208,197,180),make_color_rgb(72,253,8),make_color_rgb(201,209,222)]

global.skintone = make_color_rgb(253,210,169)

global.drawer = noone
with instances_matching(CustomDraw,"name",mod_current) instance_destroy()
with script_bind_draw(spellpicker,-14){
    global.drawer = id
    name = mod_current
    persistent = 1
}

global.spells = ds_map_create()
global.spellnames = []

add_spell("Fire","fire",global.firecol,scr(fire_cast),scr(fire_channel),scr(fire_release),NA,1)
add_spell("Lighntning","lightning",global.lightningcol,scr(lightning_cast),scr(lightning_channel),NA,NA,1)
add_spell("No Spell", "none",global.skintone,NA,scr(none_channel),scr(none_release),NA,1)
add_spell("Throne", "tb",scr(tb_col),scr(tb_cast),scr(tb_channel),scr(tb_release),NA,scr(tb_avail))

#define scr(script)
return script_ref_create(script)

#macro NA script_ref_create(nothing)
#define nothing

#define add_spell(name,id,handcol,on_cast,on_channel,on_release,on_step,avail)
global.spells[? id] = [name,handcol,on_cast,on_channel,on_release,on_step,avail]
array_push(global.spellnames,id)

#define race_name
	return "GUN DUDE";

#define race_text
	return "ACCURACY#MAGIC POWERS";

#define race_tb_text
	return "STOMPS DESTROY BULLETS";

#define race_mapicon
return sprLilHunterWalk;

/*
#define race_portrait
return global.spr_port;

#define race_portrait
return global.spr_portrait;
*/
#define race_menu_button
sprite_index = global.handbotslct;

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
return("guns are cool")

#define create
	//Needs spr_idle/walk/hurt/dead/chrg/fire
	spr_idle = global.handbotroll;
	spr_walk = global.handbotroll;
	spr_hurt = sprLilHunterHurt;
	spr_dead = sprLilHunterDead;

	snd_hurt = sndLilHunterHurt;
	snd_dead = sndLilHunterBreak;
	snd_lowh = sndLilHunterHalfHP;
	snd_lowa = sndLilHunterHalfHP;

	snd_cptn = sndLilHunterSummon;
	snd_spch = sndLilHunterTaunt;

	snd_whao = sndLilHunterLaunch;
	snd_haha = sndLilHunterLand;
	snd_wrld = snd_haha;
	snd_chst = snd_whao;
	snd_thrn = snd_whao;
	snd_crwn = snd_whao;
	snd_valt = snd_whao;
	snd_idpd = snd_cptn;
	
	hand = {
	    gx : 0,
	    gy : 0,
	    x : 0,
	    y : 0,
	    spell : "none",
	    spellanim: 0,
	    index : 0,
	    col : global.skintone,
	    animcol : global.skintone,
	    angle : 0,
	    cancast : 1
	}

	maxhealth = 8;

#define step
if sprite_index = spr_walk || sprite_index = spr_idle{
    image_speed = sqrt(speed/10)
}else{
    image_speed = .4
}

if !instance_exists(global.drawer){
    with instances_matching(CustomDraw,"name",mod_current) instance_destroy()
    with script_bind_draw(spellpicker,-14){
        global.drawer = id
        name = mod_current
        persistent = 1
    }
}
    var h = hand;
    var click = button_check(index,"spec") * canspec;
    var ang = point_direction(h.x,h.y,h.gx,h.gy);
    var dis = point_distance(h.gx,h.gy,h.x,h.y);


    h.x += lengthdir_x((dis/3)*current_time_scale,ang)
    h.y += lengthdir_y((dis/3)*current_time_scale,ang)
    h.angle = point_direction(0,0,h.x,h.y)

    h.gx =lengthdir_x(10+4*click,gunangle)
    h.gy =lengthdir_y(5+2*click,gunangle)

    if h.spellanim != 0 h.spellanim = max(0,h.spellanim - h.spellanim/(1+.75*current_time_scale))
    h.index = 0
    
    hand = h
    
    if canspec{
        if click h.index = 2
        if button_pressed(index,"spec"){
            var array = global.spells[? h.spell][2];
            mod_script_call(array[0],array[1],array[2])
        }
        else if click{
            var array = global.spells[? h.spell][3];
            mod_script_call(array[0],array[1],array[2])

        }
        else if button_released(index,"spec"){
            var array = global.spells[? h.spell][4];
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
    
    if h.spellanim != 0 {
        var width = sprite_get_width(global.hands),
            xoff = sprite_get_xoffset(global.hands),
            yoff = sprite_get_yoffset(global.hands),
            x1 = lengthdir_x(xoff,h.angle),
            x2 = lengthdir_x(yoff,h.angle-90*hright),
            y1 = lengthdir_y(xoff,h.angle),
            y2 = lengthdir_y(yoff,h.angle-90*hright);
            
        draw_sprite_general(global.hands,h.index,0,0,width,h.spellanim,x+h.x - x1 - x2 , y + h.y - y1 - y2 ,1,hright,h.angle,h.animcol,h.animcol,h.animcol,h.animcol,1)
    }
}
#define spellpicker
with instances_matching(Player,"race",mod_current)
    if visible && (button_check(index,"swap") || button_released(index,"swap")){
        var picks = []
        for var i = 0; i< array_length_1d(global.spellnames); i++{
            var avail = global.spells[? global.spellnames[i]][6];
            if is_array(avail){
                avail = mod_script_call(avail[0],avail[1],avail[2])
            }
            if avail == true array_push(picks,global.spellnames[i])
        }
        var h = hand;
        var int = 360/array_length_1d(picks);
        var num = 0;
        for var a = 90; a<450; a+=int{
            var pointed = abs(angle_difference(point_direction(x,y,mouse_x[index],mouse_y[index]),a)) < int/2;
            var col = pointed? c_gray : c_dkgray;
            draw_roundrect_color(x+lengthdir_x(50,a) + 10, y+lengthdir_y(50,a) +10, x+lengthdir_x(50,a) -10, y+lengthdir_y(50,a) -10,col,col,0)
            draw_text(x+lengthdir_x(50,a), y+lengthdir_y(50,a),global.spells[? global.spellnames[num]][0])
            if pointed && button_released(index,"swap"){
                h.spell = picks[num]
                h.animcol = h.col
                var clr = global.spells[? global.spellnames[num]][1];
                if is_array(clr){
                    clr = mod_script_call(clr[0],clr[1],clr[2])
                }
                h.col = clr
                h.spellanim = sprite_get_height(global.hands)
            }
            num++
        }
        hand = h
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

#define lightning_cast
with instance_create(x+hand.x,y+hand.y,Lightning){
    team = other.team
    creator = other
    ammo = 16
    image_angle = other.gunangle
    image_speed *= 2
    event_perform(ev_alarm,0)
}

#define lightning_channel
with instance_random_matching(Lightning,"creator",id){
    var imang = image_angle;
    image_angle = creator.gunangle
    image_index = 0
    ammo+=2
    event_perform(ev_alarm,0)
    image_angle = imang
}

#define fire_cast
sound_loop(sndFlamerLoop)
sound_play(sndFlamerStart)
with instance_create(x+hand.x,y+hand.y,Flare){
    team = other.team
    creator = other
    motion_set(other.gunangle+random_range(-15,15),8+random(3))
}
#define fire_channel
with instance_create(x+hand.x,y+hand.y,Flame){
    team = other.team
    creator = other
    motion_set(other.gunangle,8)
}
if random(100) < 15*current_time_scale{
    with instance_create(x+hx,y+hy,Flare){
        team = other.team
        creator = other
        motion_set(other.gunangle+random_range(-15,15),8+random(3))
    }
}

#define fire_release
sound_stop(sndFlamerLoop)
sound_play(sndFlamerStop)

#define tb_cast

#define tb_channel


#define tb_release

#define tb_col
return global.skincolors[race_id]

#define tb_avail
return skill_get(5)

#define none_channel
hand.gx = lengthdir_x(16,gunangle)
hand.gy = lengthdir_y(16,gunangle)
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
hindex = 1
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

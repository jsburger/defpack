#define init
global.hands = sprite_add("magichands.png",3,6,6)
global.col = make_color_rgb(6,191,0)
global.lightningcol = make_color_rgb(120,190,255)
global.firecol = make_color_rgb(255,53,53)

global.skincolors = [c_black,global.col,make_color_rgb(173,80,185),make_color_rgb(0,120,252),make_color_rgb(240,215,190),make_color_rgb(138,183,6),c_dkgray,
make_color_rgb(253,220,179),make_color_rgb(174,185,187),make_color_rgb(248,249,228),make_color_rgb(208,197,180),make_color_rgb(72,253,8),make_color_rgb(201,209,222)]

global.drawer = noone
with instances_matching(CustomDraw,"name",mod_current) instance_destroy()
with script_bind_draw(handdraw,-3){
    global.drawer = id
    name = mod_current
    persistent = 1
}

global.spells = ds_map_create()
global.spellnames = []

add_spell("Fire","fire",global.firecol,scr(fire_cast),scr(fire_channel),scr(fire_release),NA,1)
add_spell("Lighntning","lightning",global.lightningcol,scr(lightning_cast),scr(lightning_channel),NA,NA,1)
add_spell("No Spell", "none",scr(tb_col),NA,scr(none_channel),scr(none_release),NA,1)
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

#define swep
	return 0;

#define race_mapicon
return sprLilHunterWalk;

/*
#define race_portrait
return global.spr_port;

#define race_portrait
return global.spr_portrait;

#define race_menu_button
sprite_index = global.spr_slct;

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
	spr_idle = sprLilHunterWalk;
	spr_walk = sprLilHunterWalk;
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

	maxhealth = 8;
	wep = 0;
	canpick = false;
	visible = false;

#define step
if !instance_exists(global.drawer){
    with instances_matching(CustomDraw,"name",mod_current) instance_destroy()
    with script_bind_draw(handdraw,-3){
        global.drawer = id
        name = mod_current
        persistent = 1
    }
}
    wep = 0
    if "hgoalx" not in self{
        hgoalx = 0
        hgoaly = 0
        hx = 0
        hy = 0
        hspell = "none"
        hspellanim = 0
        hindex = 0
        hcol = global.skincolors[race_id]
        hanimcol = global.col
        hangle = gunangle
        cancast = 1
    }
    var click = button_check(index,"fire");
    var ang = point_direction(hx,hy,hgoalx,hgoaly);
    var dis = point_distance(hgoalx,hgoaly,hx,hy);


    hx += lengthdir_x((dis/3)*current_time_scale,ang)
    hy += lengthdir_y((dis/3)*current_time_scale,ang)
    hangle = point_direction(0,0,hx,hy)

    hgoalx = lengthdir_x(10+4*click,gunangle)
    hgoaly = lengthdir_y(5+2*click,gunangle)

    if hspellanim != 0 hspellanim = max(0,hspellanim - hspellanim/(1+.75*current_time_scale))
    hindex = 0

    if cancast{
        if click hindex = 2
        if button_pressed(index,"fire"){
            var array = global.spells[? hspell][2];
            mod_script_call(array[0],array[1],array[2])
        }
        else if click{
            var array = global.spells[? hspell][3];
            mod_script_call(array[0],array[1],array[2])

        }
        else if button_released(index,"fire"){
            var array = global.spells[? hspell][4];
            mod_script_call(array[0],array[1],array[2])
        }
    }

#define handdraw
    if visible{
    var hright = sign(hx);
    var click = button_check(index,"fire");
    draw_sprite_ext(global.hands,hindex,x+hx,y+hy,1,hright,hangle,hcol,1)
    var width = sprite_get_width(global.hands);
    var xoff = sprite_get_xoffset(global.hands),yoff = sprite_get_yoffset(global.hands)
    if hspellanim != 0 draw_sprite_general(global.hands,hindex,0,0,width,hspellanim,x+hx - lengthdir_x(xoff,hangle)-lengthdir_x(yoff,hangle-90*hright),y+hy - lengthdir_y(xoff,hangle)-lengthdir_y(yoff,hangle-90*hright),1,hright,hangle,hanimcol,hanimcol,hanimcol,hanimcol,1)

#define draw
	  if visible && (button_check(index,"swap") || button_released(index,"swap")){
    var picks = []
    for var i = 0; i< array_length_1d(global.spellnames); i++{
        var avail = global.spells[? global.spellnames[i]][6];
        if is_array(avail){
            avail = mod_script_call(avail[0],avail[1],avail[2])
        }
        if avail == true array_push(picks,global.spellnames[i])
    }
    var int = 360/array_length_1d(picks);
    var num = 0;
    for var a = 90; a<450; a+=int{
        var pointed = abs(angle_difference(point_direction(x,y,mouse_x[index],mouse_y[index]),a)) < int/2;
        var col = pointed? c_gray : c_dkgray;
        draw_roundrect_color(x+lengthdir_x(50,a) + 10, y+lengthdir_y(50,a) +10, x+lengthdir_x(50,a) -10, y+lengthdir_y(50,a) -10,col,col,0)
        draw_text(x+lengthdir_x(50,a), y+lengthdir_y(50,a),global.spells[? global.spellnames[num]][0])
        if pointed && button_released(index,"swap"){
            hspell = picks[num]
            hanimcol = hcol
            var clr = global.spells[? global.spellnames[num]][1];
            if is_array(clr){
                clr = mod_script_call(clr[0],clr[1],clr[2])
            }
            hcol = clr
            hspellanim = sprite_get_height(global.hands)
        }
        num++
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

#define lightning_cast
with instance_create(x+hx,y+hy,Lightning){
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
with instance_create(x+hx,y+hy,Flare){
    team = other.team
    creator = other
    motion_set(other.gunangle+random_range(-15,15),8+random(3))
}
#define fire_channel
with instance_create(x+hx,y+hy,Flame){
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
hgoalx = lengthdir_x(16,gunangle)
hgoaly = lengthdir_y(16,gunangle)
var hold = 0
if instance_exists(projectile) with instance_nearest(x+hx,y+hy,projectile) if distance_to_point(other.hx+other.x,other.hy+other.y) < 5{
    x = other.x + other.hx - hspeed_raw
    y = other.y + other.hy - vspeed_raw
    team = other.team
    hold = 1
}

if !hold && instance_exists(enemy) with instance_nearest(x+hx,y+hy,enemy) if size < 2  && distance_to_point(other.hx+other.x,other.hy+other.y) < 5{
    x = other.x + other.hx - hspeed_raw
    y = other.y + other.hy - vspeed_raw
    team = other.team
}


#define none_release
hindex = 1
var hold = 0;
if instance_exists(projectile) with instance_nearest(x+hx,y+hy,projectile) if distance_to_point(other.hx+other.x,other.hy+other.y) < 5{
    instance_create(x,y,Dust)
    instance_destroy()
    sound_play_pitch(sndWallBreak,3)
    hold = 1
}

if !hold && instance_exists(enemy) with instance_nearest(x+hx,y+hy,enemy) if size < 2 &&distance_to_point(other.hx+other.x,other.hy+other.y) < 5{
    my_health = 0
    instance_create(x,y,BloodStreak)
    sound_play(sndMaggotSpawnDie)
}

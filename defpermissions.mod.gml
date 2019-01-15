#define init
global.stuff = []
global.configopen = [0,0,0,0]
global.scroll = [0,0,0,0]
global.buttonsopen = [0,0,0,0]
global.wantbutton = [0,0,0,0]
global.paletteopen = [0,0,0,0]
global.wasscrolling = [0,0,0,0]
global.maxpalettes = 10
//global.sprSave = sprite_add("sprSave.png",1,5,5)
//global.sprTrash = sprite_add("sprTrash.png",1,5,5)

//burg everytime you add something like this i think less of you as a person
var p1 = {
    name : "Default Palette",
    //bgcolor : merge_color(c_black,c_white,0.2),
    //sideoutline : c_black,
    sidebutton : c_dkgray,
    sidehighlight : c_gray,
    tabcolor : c_white,
    arrowcolor : c_white,
    scrollbg : c_dkgray,
    scrollcolor : c_white,
    scrollpress : c_gray,
    cellcolor : c_gray,
    cellfadetop : c_gray,
    cellfadebottom : c_gray,
    cellhighlight : merge_color(c_white,c_black,.2),
    cellbar : c_dkgray,
    palettebody : c_gray,
    palettebutton : c_gray,
    palettehighlight : c_ltgray,
    //celloutline : c_black,
    togglecolor : c_white,
    toggleon : merge_color(c_blue,c_gray,.4),
    toggleoff : c_dkgray,
    modlabel : c_black,
    barbg : c_dkgray,
    barleft : merge_color(c_blue,c_gray,.4),
    barright : merge_color(c_blue,c_gray,.4),
    bartip : c_white,
    bartext : c_white,
    textcolor : c_white,
}

global.paletteeditor = {
    value : 255,
    hue : 255,
    saturation : 0,
    color : c_white,
    copy : c_white,
    scroll : 0,
    selected : 0
}

global.editingpalette = p1

global.palettes = [1 , lq_clone(p1)]

global.sprButtons = sprite_add("sprites/sprButtons.png",6,5,1);
global.sprButtonX = sprite_add("sprites/sprX.png",0,8,8);
global.sprArrow   = sprite_add("sprites/sprArrow.png",0,3,2);
//trace(global.palettes)

chat_comp_add("defclearcache","Clears out the defpack config of unused variables")
chat_comp_add("palette","Renames the current defpack config palette")
chat_comp_add("pimport","Imports a palette of the given file name")
chat_comp_add("pexport","Exports a palette to an importable text file")

if fork(){
    var b = file_load("data/defpermissions.mod/palettes.txt")
    if b wait(b)
    if !file_exists("data/defpermissions.mod/palettes.txt") string_save(json_encode(global.palettes),"palettes.txt")
    else global.palettes = json_decode(string_load("data/defpermissions.mod/palettes.txt"))
    for var i = 1; i < array_length(global.palettes); i++{
        global.palettes[i] = palette_update(global.palettes[i])
    }
    exit
}

var t = file_load("data/defpermissions.mod/defconfig.txt")
if t wait(t)
if !file_exists("data/defpermissions.mod/defconfig.txt"){
    string_save("[]","defconfig.txt")
    file_load("data/defpermissions.mod/defconfig.txt")
}
else global.stuff = json_decode(string_load("data/defpermissions.mod/defconfig.txt"))

#define palette_update(pal)
var e = lq_clone(global.editingpalette)
for var i = 0; i < lq_size(e); i++{
    var k = lq_get_key(e, i)
    lq_set(e, k, lq_defget(pal, k, lq_get(e, k)))
}
return e

#define save
string_save(json_encode(global.stuff),"defconfig.txt")

#define savepalette
string_save(json_encode(global.palettes),"palettes.txt")

#define cleanup
save()
savepalette()
file_unload("data/defpermissions.mod/palettes.txt")
file_unload("data/defpermissions.mod/defconfig.txt")


#define permission_register(type,name,variable,desc)
while !file_exists("data/defpermissions.mod/defconfig.txt") {wait(0)}
var arr = [type,name,variable,desc,mod_variable_get(type,name,variable),0];
var count = 0;
for var o = 0; o < array_length_1d(global.stuff); o++{
    if name = global.stuff[o][1] && variable = global.stuff[o][2]{
        count = 1
        break
    }
}
if count = 0 array_push(global.stuff,arr)
else{
    mod_variable_set(global.stuff[o][0],global.stuff[o][1],global.stuff[o][2],global.stuff[o][4])
    global.stuff[o,3] = desc
}
save()

#define permission_register_range(type,name,variable,desc,minimum,maximum)
while !file_exists("data/defpermissions.mod/defconfig.txt") {wait(0)}
var arr = [type,name,variable,desc,mod_variable_get(type,name,variable),1,minimum,maximum];
var count = 0;
for var o = 0; o < array_length_1d(global.stuff); o++{
    if name = global.stuff[o][1] && variable = global.stuff[o][2]{
        count = 1
        break
    }
}
if count = 0 array_push(global.stuff,arr)
else{
    mod_variable_set(global.stuff[o][0],global.stuff[o][1],global.stuff[o][2],global.stuff[o][4])
    global.stuff[o,3] = desc
    global.stuff[o,6] = minimum
    global.stuff[o,7] = maximum
}
save()

#define chat_command(cmd,arg,ind)
if cmd = "defconfig"{
    global.configopen[ind] = !global.configopen[ind]
    trace_color("Config menu " + (global.configopen[ind] ? "opened" : "closed"),c_gray)
    return 1
}
if cmd = "defclearcache"{
    clear_cache()
    trace_color("Variable cache cleared",c_gray)
    return 1
}
if cmd = "palette"{
    if global.palettes[0] < array_length_1d(global.palettes) {
        global.palettes[global.palettes[0]].name = arg
        trace_color("Named current palette " + arg + " successfully!",global.palettes[global.palettes[0]].cellcolor)
    }
    else trace_color("Could not rename the current palette because it doesn't exist!", c_red)
    return 1
}
if cmd = "pexport"{
    string_save(json_encode(global.palettes[global.palettes[0]]), global.palettes[global.palettes[0]].name + ".pal.txt")
    trace_color("Exported " + global.palettes[global.palettes[0]].name + " to data/defpermissions.mod", c_lime)
    return 1
}
if cmd = "pimport"{
    if array_length(global.palettes) > global.maxpalettes{
        trace_color("Could not import palette! Not enough room!", c_red)
        return 1
    }
    if fork(){
        wait(file_load("data/defpermissions.mod/" + arg + ".pal.txt")+1)
        if !file_exists("data/defpermissions.mod/" + arg + ".pal.txt") trace_color("Could not import palette! File "+arg+" could not be found!", c_red)
        else{
            array_push(global.palettes, palette_update(json_decode(string_load("data/defpermissions.mod/" + arg + ".pal.txt"))))
            file_unload("data/defpermissions.mod/" + arg + ".pal.txt")
            trace_color("Successfully imported " + arg, c_lime)
        }
        exit
    }
    return 1
}


#define clear_cache()
for var o = 0; o < array_length_1d(global.stuff); o++{
    if !mod_exists(global.stuff[o][0],global.stuff[o][1]) || !mod_variable_exists(global.stuff[o][0],global.stuff[o][1],global.stuff[o][2]){
        var newarray = []
        for var i = 0; i < array_length_1d(global.stuff); i++{
            if i != o array_push(newarray,global.stuff[i])
        }
        global.stuff = array_clone(newarray)
        global.scroll = [0,0,0,0]
        o--
    }
}
save()

#define array_index_delete(array, index)
var newarray = []
for var o = 0; o < array_length_1d(array); o++{
    if o != index{
        array_push(newarray,array[o])
    }
}
return newarray


#define click(n)
sound_play_pitchvol(sndClick,(1 + n/4)*1.5,.5)

#define draw_rectangle_c(x1,y1,x2,y2,color)
draw_rectangle_color(x1,y1,x2,y2,color,color,color,color,0)

#define draw_rectangle_co(x1,y1,x2,y2,color)
draw_rectangle_color(x1,y1,x2,y2,color,color,color,color,1)

#define draw_roundrect_c(x1,y1,x2,y2,color)
draw_roundrect_color(x1,y1,x2,y2,color,color,0)

#define draw_text_c(x,y,str,col)
draw_set_color(col)
draw_text_shadow(x,y,str)
draw_set_color(c_white)

#define draw_tri(x,y,xradius,yradius,angle,color)
draw_primitive_begin(pr_trianglelist)
repeat(3){
    draw_vertex_color(x+1+lengthdir_x(xradius,angle), y+1 + lengthdir_y(yradius, angle), color, 1)
    angle += 120
}
draw_primitive_end()

#define draw_pause
draw_set_projection(0)
draw_menu()
draw_reset_projection()

#define draw_gui
if instance_exists(CharSelect) draw_menu()

#define draw_menu

draw_set_font(fntChat)
draw_set_color(c_white)
var p = global.palettes[global.palettes[0]]
draw_set_halign(0)
for (var i = 0; i < maxp; i++) if player_is_active(i){

    var mousex = mouse_x[i] - view_xview[i], mousey = mouse_y[i] - view_yview[i]
    var press = button_pressed(i, "fire"), check = button_check(i, "fire"), released = button_released(i, "fire")

    if i = 0 and !player_is_active(1){
        mousex = mouse_x_nonsync - view_xview_nonsync
        mousey = mouse_y_nonsync - view_yview_nonsync
        press = button_pressed_nonsync(0,"fire")
        check = button_check_nonsync(0,"fire")
        released = button_released_nonsync(0,"fire")
    }

    draw_set_visible_all(0)
    draw_set_visible(i,1)
    //menu width, menu height, scroll bar width
    var mw = 80, mh = 100, sw = 6, sh = 8;
    var _x =  -mw*global.buttonsopen[i] - 4 - sw + game_width, _y = 40;
    //cell width, cell height
    var cw = mw, ch = 20;
    //maximum displayable cells
    var mc = floor(mh/ch);
    var l = array_length(global.stuff);
    mh = min(l,mc)*ch
    //rectangle padding
    var pad = 2
    var _x2 = _x + mw, _y2 = _y + mh + 2*(min(mc,l)-1);
    //draw_rectangle_c(_x-pad,_y-pad,_x2+pad,_y2+pad,p.bgcolor);
    //draw_rectangle_co(_x-pad,_y-pad,_x2+pad,_y2+pad,p.bgoutline);
    var d = l - mc;
    //if the mouse is in the current box, and if the mouse has ever been in a box
    var mouse = 0, found = global.wasscrolling[i]
    //indicator width, height
    var iw = 10, ih = 6;


    if global.wantbutton[i] != 0{
        global.buttonsopen[i] += global.wantbutton[i]
        global.wantbutton[i] -= sign(global.wantbutton[i])/10
    }
    //button center
    var xx = game_width , xy = 20;
    //button size
    var xw = 10;
    if !found{
        mouse = point_in_rectangle(mousex,mousey,game_width - xw, xy - xw + 4, game_width, xy + xw + 4)
        found = mouse
    }
    else mouse = 0
    draw_roundrect_c(game_width - xw, xy - xw + 4, game_width + 10, xy + xw + 4, mouse ? p.cellhighlight : p.cellfadetop)
    draw_tri(game_width - xw/2 +.5, xy + 5, 3, 5, global.buttonsopen[i] > 0 ? 0 : 180, c_black)
    draw_tri(game_width - xw/2 +.5, xy + 4, 3, 5, global.buttonsopen[i] > 0 ? 0 : 180, p.tabcolor)
    if mouse and released{
        click(.2)
        global.wantbutton[i] = global.buttonsopen[i] > 0 ? -.4 : .4
        global.buttonsopen[i] =  global.buttonsopen[i] > 0
    }
    if global.buttonsopen[i] > 0{
        //drawing config button
        xx -= (1.5 * xw + 2) * global.buttonsopen[i]
        if !found{
            mouse = point_in_rectangle(mousex,mousey,xx-xw,xy,xx,xy+xw)
            found = mouse
        }
        else mouse = 0
        draw_sprite_ext(sprDailyArrowSplat,2,xx-xw/2,xy+5,1,1,0,c_black,1)
        draw_sprite_ext(global.sprButtons,4,xx-xw/2,xy,1,1,0,mouse ? p.textcolor : c_ltgray,1)
        if mouse draw_text_shadow(xx - 34, xy + 10, "Config Menu")
        if mouse && released{
            click(0)
            global.configopen[i] = !global.configopen[i]
        }
        xx -= (1.5 * xw + 2) * global.buttonsopen[i]
        
        //drawing palette button
        if !found{
            mouse = point_in_rectangle(mousex,mousey,xx-xw,xy,xx,xy+xw)
            found = mouse
        }
        else mouse = 0
        draw_sprite_ext(sprDailyArrowSplat,2,xx-xw/2,xy+5,1,1,180,c_black,1)
        draw_sprite_ext(global.sprButtons,1,xx-1-xw/2,xy,1,1,0,mouse ? p.textcolor : c_ltgray,1)
        if mouse draw_text_shadow(xx - 34, xy + 10, "Palette Menu")
        if mouse && released{
            global.paletteopen[i] = !global.paletteopen[i]
            click(0)
        }
        
        //button wrapper
        var bright = xx - xw*3/2, btop = xy - xw + 4.5
        draw_line_width_color(game_width - xw + 3, btop, bright, btop, 1, c_white, c_white)
        draw_line_width_color(bright, btop, bright - 3, btop + 3, 1, c_white, c_white)
        draw_line_width_color(bright - 3, btop + 3, bright - 3, xy + xw,1, c_white, c_white)
    }
    
    
    if global.paletteopen[i] and global.buttonsopen[i] > 0{
        var pmw = 62, pmh = 95
        var pmx = _x - 9
        draw_rectangle_c(pmx - pmw + 1, _y + 1, pmx + 1, _y + pmh + 1,c_black)
        draw_rectangle_c(pmx - pmw, _y, pmx, _y + pmh, p.palettebody)
        //draw_rectangle_co(pmx - pmw, _y, pmx, _y + pmh,c_black)

        var edit = global.paletteeditor

        var radius = 20, cx = pmx + 9 - radius * 2, cy = _y + radius * 1.25
        var sides = 12, inc = 360/sides, hueinc = 255/sides

        var vbx = cx - radius, vbw = radius*2, vby = cy + radius + 10;

        draw_line_width_color(vbx-1, vby, vbx + 1 + vbw, vby, 6, c_black, c_black)
        draw_line_width_color(vbx, vby, vbx + vbw, vby, 4, c_black, c_white)
        draw_tri(vbx + vbw*(edit.value/255), vby + 5, 4, 2, 90, c_black)

        if point_in_rectangle(mousex, mousey, vbx - 4, vby - 4, vbx + vbw + 4, vby + 4) and check{
            var oldval = edit.value
            edit.value = clamp(round(((mousex - vbx)/vbw) * 255), 0, 255)
            if oldval != edit.value click(6)
            edit.color = make_color_hsv(edit.hue,edit.saturation,edit.value)
        }

        draw_circle_color(cx,cy,radius+3,0,c_black,0)
        draw_primitive_begin(pr_trianglefan)
        draw_vertex_color(cx + 1,cy +1,make_color_hsv(0,0,edit.value),1)
        //im running out of easy to use variables
        for var e = 0; e <= sides; e++{
            draw_vertex_color(cx + 1 + lengthdir_x(radius, inc * e), cy+ 1 + lengthdir_y(radius, inc * e), make_color_hsv(hueinc * e, 255, edit.value),1)
        }
        draw_primitive_end()

        draw_set_halign(0)
        draw_text_c(pmx - pmw, _y + pmh, "Use /palette#to name your#palette",c_gray)

        var copyx = cx - 10, copyw = 30, copyy = cy + radius + 20, copyh = 12
        var mouse = point_in_rectangle(mousex,mousey,copyx,copyy,copyx+copyw,copyy+copyh)
        draw_rectangle_c(copyx+6,copyy+1,copyx+copyw+1,copyy+copyh+1,c_black)
        draw_rectangle_c(copyx+5,copyy,copyx+copyw,copyy+copyh,mouse ? p.palettehighlight : p.palettebutton)
        //draw_rectangle_co(copyx,copyy,copyx+copyw,copyy+copyh,c_black)
        draw_text_c(copyx + 8, copyy-1, "copy", p.textcolor)

        if mouse and released{
            edit.copy = edit.color
            click(1)
        }

         var mouse = point_in_rectangle(mousex,mousey,copyx,copyy + copyh + 2,copyx+copyw,copyy+copyh*2 + 2)
         if mouse and released{
             edit.color = edit.copy
             click(0)
         }
        draw_rectangle_c(copyx+6,copyy + copyh + 3,copyx+copyw+1,copyy+copyh*2 + 3,c_black)
        draw_rectangle_c(copyx+5,copyy + copyh + 2,copyx+copyw,copyy+copyh*2 + 2,mouse ? p.palettehighlight : p.palettebutton)
        //draw_rectangle_co(copyx,copyy + copyh + 2,copyx+copyw,copyy+copyh*2 + 2,c_black)
        draw_text_c(copyx + 6, copyy + copyh + 1, "paste", p.textcolor)

        draw_rectangle_c(copyx,copyy+1, copyx - 8,copyy + 2*copyh + 3, c_black)
        draw_rectangle_c(copyx - 1,copyy, copyx - 9,copyy + 2*copyh + 2, edit.copy)
        //draw_rectangle_co(copyx - 1 ,copyy, copyx - 9,copyy + 2 * copyh + 2, 0)


        var color = edit.color

        var dis = point_distance(cx, cy, mousex, mousey)
        if dis <=  radius + 4{
            if check{
                var oldval = color
                var hue = point_direction(cx,cy,mousex,mousey) * 255/360, sat =  min(dis, radius)/radius * 255, val = edit.value, color = make_color_hsv(hue, sat, val)
                if color != oldval click(((1 + dsin(hue * 360/255) + 1 + dsin(sat * 360/255))+ 1)*10)
                edit.color = color
            }
        }

        if edit.selected > 0 lq_set(p, lq_get_key(p,edit.selected), edit.color)

        var s = color_get_saturation(edit.color), hu = color_get_hue(edit.color), value = color_get_value(edit.color)
        edit.saturation = s
        edit.hue = hu
        edit.value = value

        draw_circle_color(cx + lengthdir_x(s/255 * radius, hu/255 * 360), cy + lengthdir_y(s/255 * radius, hu/255 * 360), 1.5, 0, 0 ,1)

        draw_rectangle_c(pmx - pmw + 4 ,copyy + 1, pmx - pmw + 10,copyy + 2*copyh + 3, c_black)
        draw_rectangle_c(pmx - pmw + 3 ,copyy, pmx - pmw + 9,copyy + 2*copyh + 2, edit.color)
        //draw_rectangle_co(pmx - pmw + 3 ,copyy, pmx - pmw + 9,copyy + 2*copyh + 2, 0)


        var tleft = pmx - pmw*2 - 5, tright = pmx - pmw - 2
        var theight = 8, tgap = 2, ttop = _y - (lq_size(p) - 23) * (theight+tgap)

        
        var moused = 0
        if mousex > tleft and mousex < tright moused = ceil((mousey - ttop + tgap)/(theight))

        for var q = 1+edit.scroll; q < lq_size(p); q++{
            var ty = ttop + theight*(q - 1);

            draw_rectangle_c(tleft - 8, ty, tright, ty + theight - tgap + 1, c_black)
            draw_rectangle_c(tright, ty, tleft-4, ty + theight - tgap, q = moused || edit.selected = q ? p.palettehighlight : p.palettebutton)
            draw_rectangle_c(tleft - 9, ty, tleft - 5, ty + theight - tgap, lq_get_value(p,q))
            //draw_rectangle_co(tleft - 4, ty, tleft - 1, ty + theight - tgap, 0)
            draw_text_c(tleft, ty - 3, lq_get_key(p,q), c_white)
            if q = moused and released{
                click(1)
                edit.selected = q
                edit.color = lq_get_value(p,q)
            }
        }

        var found = moused

        var sleft = tleft - 34, sheight = 12, sgap = 4

        for var u = 1; u <= array_length(global.palettes); u++{
            var sy = _y + (sheight + sgap) * (u - .5)
            if u < array_length (global.palettes){
                if !found{
                    mouse = point_in_rectangle(mousex,mousey,sleft - sheight*2, sy, sleft + sheight, sy + sheight)
                    found = mouse
                }
                else mouse = 0
                var pal = global.palettes[u]
                draw_rectangle_c(sleft + 1, sy + 1, sleft + sheight + 1, sy + sheight + 1, global.palettes[0] == u ? c_white : c_black)
                draw_rectangle_c(sleft, sy, sleft + sheight, sy + sheight, mouse and mousex > sleft ? pal.cellhighlight : pal.cellcolor)
                if u != 1 and mouse{
                    //RED X
                    var xcol = (mouse and mousex < sleft - 2) ? c_white : c_ltgray
                    draw_sprite_ext(global.sprButtonX,0,sleft-11,sy +2 + sheight/2,1,1,0,c_black,1)
                    draw_sprite_ext(global.sprButtonX,0,sleft-12,sy +1 + sheight/2,1,1,0,xcol,1)
                    //draw_line_width_color(sleft - 4, sy +sheight - 2, sleft - sheight, sy + 2, 2, xcol, xcol)
                }
                if mouse{
                    if u != 1 and mousex < sleft - 2{
                        draw_tooltip(round(sleft - sheight*3/4), sy, "Delete " + global.palettes[u].name)
                        if released {
                            global.palettes = array_clone(array_index_delete(global.palettes, u))
                            if u == global.palettes[0] global.palettes[0] = 1
                            else if u < global.palettes[0] global.palettes[0]--
                            edit.selected = 0
                            click(1)
                            //break
                        }
                    }
                    /*else if u != 1 and mousex < sleft{
                        draw_tooltip(sleft - sheight*.5, sy, "Save to this slot")
                        if released{
                            click(0)
                            global.palettes[u] = global.editingpalette
                            global.palettes[0] = u
                            edit.selected = 0
                        }
                    }*/
                    else{
                        draw_tooltip(round(sleft + sheight/2), sy, "Load "+pal.name)
                        if released{
                            global.palettes[0] = u
                            edit.selected = 0
                            click(0)
                        }
                    }
                }
            }
            else if u <= global.maxpalettes{
                if !found{
                    mouse = point_in_rectangle(mousex,mousey,sleft, sy, sleft + sheight, sy + sheight)
                    found = mouse
                }
                else mouse = 0
                draw_rectangle_c(sleft+1, sy+1, sleft + sheight+1, sy + sheight+1, c_black)
                draw_rectangle_c(sleft, sy, sleft + sheight, sy + sheight, mouse ? c_ltgray : c_gray)
                draw_text_c(sleft + 7, sy + 2, "+", c_white)
                //draw_rectangle_co(sleft, sy, sleft + sheight, sy + sheight, c_black)
                if mouse{
                    draw_tooltip(round(sleft + sheight/2), sy, "Create new palette")
                    if released{
                        array_push(global.palettes,lq_clone(global.editingpalette))
                        global.palettes[0] = u
                        global.palettes[u].name = "Palette " + string(u)
                        edit.selected = 0
                        click(0)
                    }
                }
            }
        }
    }

    
    if global.configopen[i] and global.buttonsopen[i] > 0{
        var h = global.scroll[i]
        if d > 0{
            //if h > 0{
                if !found{
                    mouse = point_in_rectangle(mousex,mousey,_x2 + 4,_y,_x2+sw + 4,_y+sh)
                    found = mouse
                }
                else mouse = 0
                if h > 0 && mouse && released{
                    h--
                    click(0)
                }
                draw_rectangle_c(_x2 + 5,_y+2,_x2+sw + 5,_y+sh+1,c_black)
                draw_rectangle_c(_x2 + 4,_y+1,_x2+sw + 4,_y+sh,mouse ? p.sidehighlight : p.sidebutton)
                //draw_rectangle_co(_x2 + 4,_y,_x2+sw + 4,_y+sh,p.sideoutline)
                draw_sprite_ext(global.sprArrow,0,_x2 + sw/2 + 5,_y + sh/2,1,1,0,p.arrowcolor,1)
                //draw_tri(_x2 + sw/2 + 3.5, _y + sh/2, 4,3, 90, p.arrowcolor)
            //}
            //if h + mc < l{
                if !found{
                    mouse = point_in_rectangle(mousex,mousey,_x2 + 4,_y2-sh,_x2+sw + 4,_y2)
                    found = mouse
                }
                else mouse = 0
                if h + mc < l && mouse && released{
                    h++
                    click(1)
                }
              
                draw_rectangle_c(_x2 + 5,_y2-sh+1,_x2+sw + 5,_y2,c_black)
                draw_rectangle_c(_x2 + 4,_y2-sh,_x2+sw + 4,_y2-1,mouse ? p.sidehighlight : p.sidebutton)
                //draw_rectangle_co(_x2 + 4,_y2-sh,_x2+sw + 4,_y2,p.sideoutline)d
                draw_sprite_ext(global.sprArrow,0,_x2 + sw/2 + 4,_y2 - sh/2 + 1,1,1,180,p.arrowcolor,1)
                //draw_tri(_x2 + 3.5 + sw/2, _y2 + - sh/2, 4,3, 270,p.arrowcolor)
            //}
            var sbx = _x2 + 4, sbx2 = sbx + sw, sby = _y + sh + 2, sbh = mh - sh - 4, sby2 = sby + sbh
            draw_rectangle_c(sbx+1, sby+1, sbx2+1, sby2+1, c_black)
            draw_rectangle_c(sbx, sby, sbx2, sby2, p.scrollbg)
            //draw_rectangle_co(sbx, sby, sbx2, sby2, p.sideoutline)
            var sbl = sbh * mc/l, sbl2 = h/l * sbh
            if !found{
                mouse = point_in_rectangle(mousex,mousey, sbx, sby, sbx2, sby2)
                found = mouse
            }
            else mouse = 0
            draw_rectangle_c(sbx, sby + sbl2, sbx2, sby + sbl2 + sbl, (mouse || global.wasscrolling[i]) and check ? p.scrollcolor : p.scrollpress)
            if mouse and press global.wasscrolling[i] = 1
            if (mouse || global.wasscrolling[i]) and check{
                global.wasscrolling[i] = 1
                var oldscroll = h
                h = round(clamp((mousey - sby)/(sbh-4) * d,0,d))
                if oldscroll != h{
                    //sound_play_pitchvol(sndBurn,3.5 + sqr((1 - h/(l-mc)) * 2),.35)
                    sound_play_pitchvol(sndClickBack,3 + sqr((1 - h/(l-mc)) * 1.5),.5)
                }
            }
            if released global.wasscrolling[i] = 0
    
            global.scroll[i] = h
    
        }
    
        var n = floor(min(mc,l)/2)
        var o = 0
        while o < min(mc,l){
            var _y3 = _y +ch*o, _y4 = _y3+ch
            if !found{
                mouse = point_in_rectangle(mousex,mousey,_x,_y3,_x2,_y4)
                found = mouse
            }
            else mouse = 0
            var col = merge_color(p.cellfadetop, p.cellcolor, o/n)
            //if o = n + 1 col = p.cellcolor
            if o > n col = merge_color(p.cellcolor, p.cellfadebottom, (o-n)/n)
            draw_rectangle_c(_x+1,_y3+2,_x2+1,_y4,c_black);
            draw_line_width_color(_x+6,_y4+2,_x2-5,_y4+2,1,c_black,c_black)
            draw_line_width_color(_x+6,_y4+1,_x2-5,_y4+1,1,c_black,c_black)
            draw_line_width_color(_x+5,_y4+1,_x2-6,_y4+1,1,p.cellbar,p.cellbar)
            draw_rectangle_c(_x,_y3+1,_x2,_y4-1,mouse ? p.cellhighlight : col);
            //draw_rectangle_co(_x,_y3,_x2,_y4,p.celloutline);
            draw_text_c(_x+2,_y3,global.stuff[h+o][3],p.textcolor);
            var v = global.stuff[h+o][4];
            var typ = global.stuff[h+o][5];
            //toggle style permissions
            if typ = 0{
                //draw indicators
                draw_roundrect_c(_x+3,_y4-ih - 2,_x+3+iw,_y4 - 3,v ? p.toggleon : p.toggleoff);
                draw_circle_color(_x +4 + iw/4 + iw*v/2, _y4 - 2 -ih/2, ih/2, c_black, c_black,0)
                draw_circle_color(_x +3 + iw/4 + iw*v/2, _y4 - 3 -ih/2, ih/2, p.togglecolor, p.togglecolor,0)
                var c = p.modlabel
                //draw mod name
                draw_text_color(_x + 6 + iw, _y4 - 11,string_delete(global.stuff[h+o][1],15,100000),c,c,c,c,.6)
                //making the button work
                if mouse && released{
                    var a = array_clone(global.stuff[h+o]);
                    mod_variable_set(a[0],a[1],a[2],!a[4]);
                    global.stuff[h+o,4] = !a[4];
                    click(1.5 * !a[4])
                    if fork(){
                        //delay is for making sure that if the game crashes from an option change, the option isnt saved
                        wait(3)
                        save()
                        exit
                    }
                }
            }
            //bar style permissions
            else if typ = 1{
                var mn = global.stuff[h+o][6][0], mx = global.stuff[h+o][6][1];
                //bar padding, bar width, bar x start, bar ystart, bar height, bar x end
                var pd = 2, bw = cw - 2*pd - 10, bx = _x + 2, by = _y4 - 6, bh = 7, bxe = bx + bw * ((v - mn)/(mx - mn))
                var r = mx - mn
                //draw_line_width_color(bx-1, by - .5, bx + bw, by - .5, bh+ 1, c_black, c_black)
                draw_line_width_color(bx+1, by+1, bx + bw + 1, by+1, bh, c_black, c_black)
                draw_line_width_color(bx, by, bx + bw, by, bh, p.barbg, p.barbg)
                draw_line_width_color(bx, by, bxe, by, bh, p.barleft, merge_color(p.barleft,p.barright,(v-mn)/r))
                draw_line_width_color(bxe, by+1, bxe+3, by+1, bh + 2, c_black, c_black)
                draw_line_width_color(bxe, by, bxe+2, by, bh + 2, p.bartip, p.bartip)
                draw_set_halign(1)
                var tex = string(v)
                if v == global.stuff[h+o][6][0] tex = global.stuff[h+o][7][0]
                if v == global.stuff[h+o][6][1] tex = global.stuff[h+o][7][1]
                draw_text_c(bx + bw/2, by - 5, tex, p.bartext)
                draw_set_halign(0)
                if mouse && check && !global.wasscrolling[i]{
                    var a = array_clone(global.stuff[h+o]);
                    var num = clamp(round(((mousex - bx)/bw) * r) + mn, mn, mx)
                    mod_variable_set(a[0],a[1],a[2],num);
                    if v != num sound_play_pitchvol(sndClickBack,2 + sqr(1 + 2 * (1 - abs(mx - num)/r)),.75)
                        //sound_play_pitch(sndAmmoPickup,5)
                    global.stuff[h+o,4] = num
                }
                if mouse && released{
                    if fork(){
                        //delay is for making sure that if the game crashes from an option change, the option isnt saved
                        wait(3)
                        save()
                        exit
                    }
                }
            }
            o++
            _y+=2
        }
    }
}
draw_set_visible_all(1)
draw_set_font(fntM)

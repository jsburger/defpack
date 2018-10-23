#define init
global.stuff = []
global.menuopen = 1
global.scroll = [0,0,0,0]

chat_comp_add("defconfig","Toggles the defpack configuration menu")
chat_comp_add("defclearcache","Clears out the defpack config of unused variables")

var t = file_load("data/defpermissions.mod/defconfig.txt")
if t wait(t)
if !file_exists("data/defpermissions.mod/defconfig.txt") string_save("[]","defconfig.txt")
else global.stuff = json_decode(string_load("data/defpermissions.mod/defconfig.txt"))

//huh, this works
permission_register("mod",mod_current,"menuopen","Config on Launch")

#define cleanup
string_save(json_encode(global.stuff),"defconfig.txt")

#define permission_register(type,name,variable,desc)
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
cleanup()

#define permission_register_range(type,name,variable,desc,minimum,maximum)
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
cleanup()

#define chat_command(cmd,arg)
if cmd = "defconfig"{
    global.menuopen = !global.menuopen
    trace_color("Config menu " + (global.menuopen ? "opened" : "closed"),c_gray)
    return 1
}
if cmd = "defclearcache"{
    clear_cache()
    trace_color("Variable cache cleared",c_gray)
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
cleanup()

#define draw_rectangle_c(x1,y1,x2,y2,color)
draw_rectangle_color(x1,y1,x2,y2,color,color,color,color,0)

#define draw_rectangle_co(x1,y1,x2,y2,color)
draw_rectangle_color(x1,y1,x2,y2,color,color,color,color,1)

#define draw_roundrect_c(x1,y1,x2,y2,color)
draw_roundrect_color(x1,y1,x2,y2,color,color,0)

#define draw_pause
draw()

#define draw
if global.menuopen{
    draw_set_font(fntChat)
    draw_set_color(c_white)
    draw_set_halign(0)
    for (var i = 0; i < maxp; i++) if player_is_active(i){
        draw_set_visible_all(0)
        draw_set_visible(i,1)
        //menu width, menu height, scroll bar width
        var mw = 80, mh = 100, sw = 10, sh = 20;
        var _x = view_xview[i] - mw - 5 - sw + game_width, _y = view_yview[i] + 20;
        //cell width, cell height
        var cw = mw, ch = 20;
        //maximum displayable cells
        var mc = floor(mh/ch);
        var l = array_length_1d(global.stuff);
        //rectangle padding
        var p = 2
        var _x2 = _x + mw, _y2 = _y + mh + 2*(min(mc,l)-1);
        draw_rectangle_c(_x-p,_y-p,_x2+p,_y2+p,merge_color(c_black,c_white,0.2));
        draw_rectangle_co(_x-p,_y-p,_x2+p,_y2+p,c_black);
        var d = l - mc;
        //if the mouse is in the current box, and if the mouse has ever been in a box
        var mouse = 0, found = 0
        //indicator width, height
        var iw = 10, ih = 6;
        
        //x button center
        var xx = _x -4, xy = _y-2;
        //x button size
        var xw = 10;
        //drawing x button
        mouse = point_in_rectangle(mouse_x[i],mouse_y[i],xx-xw,xy,xx,xy+xw)
        found = mouse
        draw_rectangle_c(xx-xw,xy,xx,xy+xw,mouse ? c_gray : c_dkgray)
        draw_rectangle_co(xx-xw,xy,xx,xy+xw,c_black)
        draw_text_shadow(xx-1-xw/2,xy-1,"x")
        
        if mouse && button_released(i,"fire"){
            sound_play(sndClick)
            global.menuopen = 0
            trace_color("Closed config menu, use /defconfig to reopen it at any time",c_gray)
            exit
        }
        
        var h = global.scroll[i]
        if d > 0{
            if h > 0{
                if !found{
                    mouse = point_in_rectangle(mouse_x[i],mouse_y[i],_x2 + 4,_y,_x2+sw + 4,_y+sh)
                    found = mouse
                }
                else mouse = 0
                draw_rectangle_c(_x2 + 4,_y,_x2+sw + 4,_y+sh,mouse ? c_gray : c_dkgray)
                draw_rectangle_co(_x2 + 4,_y,_x2+sw + 4,_y+sh,c_black)
                draw_triangle(_x2 + sw/2 + 4, _y + sh/2 - 4,_x2 +sw/2,_y + sh/2, _x2 + sw/2 + 8, _y + sh/2,0)
                if mouse && button_released(i,"fire"){
                    h--
                    sound_play(sndClick)
                }
            }
            else if h + mc < l{
                if !found{
                    mouse = point_in_rectangle(mouse_x[i],mouse_y[i],_x2 + 4,_y2-sh,_x2+sw + 4,_y2)
                    found = mouse
                }
                else mouse = 0
                draw_rectangle_c(_x2 + 4,_y2-sh,_x2+sw + 4,_y2,mouse ? c_gray : c_dkgray)
                draw_rectangle_co(_x2 + 4,_y2-sh,_x2+sw + 4,_y2,c_black)
                draw_triangle(_x2 + sw/2 + 4, _y2 - sh/2 + 4,_x2 +sw/2,_y2 - sh/2, _x2 + sw/2 + 8, _y2 - sh/2,0)
                if mouse && button_released(i,"fire"){
                    h++
                    sound_play(sndClick)
                }
            }
            global.scroll[i] = h
        }
        var o = 0
        while o < min(mc,l){
            var _y3 = _y +ch*o, _y4 = _y3+ch
            if !found{
                mouse = point_in_rectangle(mouse_x[i],mouse_y[i],_x,_y3,_x2,_y4)
                found = mouse
            }
            else mouse = 0
            draw_rectangle_c(_x,_y3,_x2,_y4,mouse ? merge_color(c_white,c_black,.2) : c_gray);
            draw_rectangle_co(_x,_y3,_x2,_y4,c_black);
            draw_text_shadow(_x+2,_y3,global.stuff[h+o][3]);
            var v = global.stuff[h+o][4];
            var typ = global.stuff[h+o][5];
            //toggle style permissions
            if typ = 0{
                //draw indicators
                draw_roundrect_c(_x+3,_y4-ih - 2,_x+3+iw,_y4 - 2,v ? merge_color(c_blue,c_gray,.4) : c_dkgray);
                draw_circle(_x +3 + iw/4 + iw*v/2, _y4 - 2 -ih/2, ih/2,0)
                var c = c_black
                //draw mod name
                draw_text_color(_x + 6 + iw, _y4 - 11,string_delete(global.stuff[h+o][1],15,100000),c,c,c,c,.6)
                //making the button work
                if mouse && button_released(i,"fire"){
                    var a = array_clone(global.stuff[h+o]);
                    mod_variable_set(a[0],a[1],a[2],!a[4]);
                    global.stuff[h+o,4] = !a[4];
                    sound_play(sndClick)
                    if global.menuopen = 0 global.menuopen = 1
                    if fork(){
                        //delay is for making sure that if the game crashes from an option change, the option isnt saved
                        wait(3)
                        cleanup()
                        exit
                    }
                }
            }
            //bar style permissions
            else if typ = 1{
                var mn = global.stuff[h+o][6], mx = global.stuff[h+o][7];
                //bar padding, bar width, bar x start, bar ystart, bar height, bar x end
                var pd = 2, bw = cw - 2*pd - 10, bx = _x + 2, by = _y4 - 4, bh = 7, bxe = bx + bw * (v/(mx - mn))
                by -= bh/4
                var col = merge_color(c_blue,c_gray,.4)
                draw_line_width_color(bx, by, bx + bw, by, bh, c_dkgray, c_dkgray)
                draw_line_width_color(bx, by, bxe, by, bh, col, col)
                var col2 = c_white
                draw_line_width_color(bxe, by, bxe+2, by, bh + 2, c_white, c_white)
                draw_set_halign(1)
                draw_text_shadow(bx + bw/2, by - 5, string(v))
                draw_set_halign(0)
                if mouse && button_check(i,"fire"){
                    var a = array_clone(global.stuff[h+o]);
                    var num = round(clamp((mouse_x[i] - bx)*((mx -mn) / bw), mn, mx))
                    mod_variable_set(a[0],a[1],a[2],num);
                    global.stuff[h+o,4] = num
                }
                if mouse && button_released(i,"fire"){
                    sound_play(sndClick)
                    if fork(){
                        //delay is for making sure that if the game crashes from an option change, the option isnt saved
                        wait(3)
                        cleanup()
                        exit
                    }
                }
            }
            o++
            _y+=2
        }
    }
    draw_set_visible_all(1)
    draw_set_font(fntM)
}
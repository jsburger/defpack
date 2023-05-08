#define init

    #macro paused global.paused
    #macro loading global.loading
    #macro category  global.category 
    #macro maxProgress global.maxProgress
    #macro progress  global.progress
    #macro fade global.fade
    #macro done global.done

    paused = false
    loading = true
    category = "setup"
    maxProgress = 1
    progress = 0
    fade = 0
    done = false


    global.requests = [];
    add_post_load_statement("Defpack has finished loading!", c_gray)
    
    var tries = 0;
    while(!mod_sideload()){
        wait(0)
        tries++
        if tries > 150 {
            trace_color("An error has occurred during loading Defpack! Please try again or report this if the issue persists.", c_red)
            exit
        }
    }
    
    while fade < 1 {
        fade += current_time_scale/20
        wait(0)
    }

    var first = [
        "defpermissions.mod.gml"
        ];
    
    with first {
        mod_load(self)
    }
    progress++
    
    var defpackTools = [];
    wait(file_find_all("../defpack tools", defpackTools))
    
    for (var i = 0, l = array_length(defpackTools); i < l; i++) {
        var n = string_replace(defpackTools[i].name, ".mod.gml", "");
        if (n == mod_current || n == "defpermissions") {
            defpackTools = array_delete(defpackTools, i)
            i--
            l--
        }
    }
    
    set_load_category("defpack tools", array_length(defpackTools))
    load_all(defpackTools)
    
    //Subfolders. These just load their mains
    var subfolders = ["chests", "mutation", "soda", "tank"]
    set_load_category("components", array_length(subfolders))
    with subfolders {
    	wait(mod_loadtext("../" + self + "/main.txt"))
    	wait(3)
    	progress++
    }
    
    var weps = [];
    wait(file_find_all("../", weps, 0))
    
    set_load_category("weapons", array_length(weps))
    load_all(weps)

    var irisWeps = [];
    wait(file_find_all("../iris weps", irisWeps, 2))
    
    set_load_category("iris variants", array_length(irisWeps))
    load_all(irisWeps)



    done = true
    
    wait(10)
    with (global.requests) {
        trace_color(str, col)
        global.requests = []
    }
    
    while fade > 0 {
        fade -= current_time_scale/20
        wait(0)
    }
    
    //Causes the game to error, so much for that
    //mod_unload(mod_current + ".mod.gml")

    
#define load_all(list)
    var pauseCooldown = 0;
    with list {
        progress++
        if ext != ".gml" || is_dir || is_data continue;
        wait(mod_load(string_lower(path)))
        if button_check(0, "horn") && pauseCooldown <= 0 {
            trace_color("Defpack loading paused!", c_yellow)
            paused = true
            wait(0)
            do {
                wait(0)
                if !mod_exists("mod", mod_current) exit
            }
            until button_pressed(0, "horn")
            paused = false
            pauseCooldown = 10
            trace_color("Defpack loading resumed!", c_yellow)
        }
        pauseCooldown--
    }
    
#define array_delete(arr, index)
	// Returns an array that holds everything but the indicated index
	var b = [], _l = array_length(arr);
	if index > 0 array_copy(b, 0, arr, 0, index)
	if index != _l - 1 array_copy(b, array_length(b), arr, index + 1, _l - index)
	return b

#define add_post_load_statement(str, col)
	if !done {
	    array_push(global.requests, {
	        "str": str,
	        "col": col
	    })
	}
    
#define set_load_category(cat, maxprogress)
    category = cat
    maxProgress = maxprogress
    progress = 0
    
#define draw_gui_end
    if fade > 0 {
        
        var x = 4,
            y = 50;
        
        var barWidth = 45 * sqrt(fade),
        	barHeight = 5,
            blockWidth = 90,
            height = 24;
        
        draw_set_alpha(fade * .5)
        draw_rectangle_color(x-2, y - 1, x + (blockWidth + 3) * sqrt(fade), y + height + 1, c_black, c_black, c_black, c_black, false)
        
        draw_set_alpha(fade)
        
        draw_line_width_color(x - 2, y - 1, x - 2, y + height, 1, c_black, c_black)
        draw_line_width_color(x - 3, y - 1, x - 3, y + height, 1, c_white, c_white)
        
        if !done draw_set_font(fntSmall)
        draw_text_nt(x, y + 1, done ? "Done!" : "Defpack is loading")
        
        y += 9
        
        if !done draw_text_nt(x, y, paused ? "loading paused" : "loading " + category + "...")
        
        y += 8
        x += 8
        draw_roundrect_color_ext(x, y, x + barWidth, y + barHeight, 2, 2, c_black, c_black, false)
        draw_roundrect_color_ext(x, y, x + barWidth * power(progress/maxProgress, 1.5), y + barHeight, 2, 2, c_white, c_white, false)
        
        if paused {
            draw_line_width_color(x - 4, y, x - 4, y + barHeight, 1, c_white, c_white)
            draw_line_width_color(x - 2, y, x - 2, y + barHeight, 1, c_white, c_white)
        }
        else {
            for (var i = 0; i < 360; i += 180) {
                draw_circle_color(x - 4 + lengthdir_x(2, current_frame + i), y + 2 + lengthdir_y(2, current_frame + i), 1, c_white, c_white, false)
            }
        }
        
        draw_set_font(fntM)
        draw_set_alpha(1)
    }
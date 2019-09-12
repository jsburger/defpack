#define create_splash(_x,_y,tex)
with instance_create(_x,_y,CustomObject){
	on_draw = text_draw
	text = tex
	subtext = ""
	ys = []
	for (var i = 0; i<= string_length(text); i++){
		array_push(ys,-100*(i+1))
	}
	scrollspeed = 4
	time = 100
	image_angle = 30
	sprite_index = sprScoreSplat
	image_speed = 0
	image_index = 1
	depth = -10
	return id
}

//#define step
//if button_pressed(0, "horn") mod_script_call("mod","sodaeffect","drink",mouse_x_nonsync, mouse_y_nonsync)

#define drink(_x,_y)
var angle = random_range(45,135);
var length = random_range(30,50);
with create_splash(_x+lengthdir_x(length,angle),_y+lengthdir_y(length,angle),choose("DELICIOUS", "NICE", "REFRESHING", "RADICAL", "THIRST QUENCHED", "") + "!"){
    image_angle = random_range(5, 2) * choose(-1, 1)
    subtext = "+ACCURACY"
    return id
}

#define text_draw
time -= current_time_scale
if time > 30 || time mod 3 < 2{
    for (var i = 0; i< array_length_1d(ys); i++){
    	if ys[i] < -10
	    	ys[i] += approach(ys[i], -10, 6, current_time_scale)
    	ys[i] = min(ys[i] + scrollspeed*current_time_scale, -3)
    	draw_set_color(c_black)
    	var l = (i * 7)
    	draw_text_transformed(x+lengthdir_x(l, image_angle), y + -3 + ys[i]+lengthdir_y(l, image_angle),string_char_at(text,i+1),1,1,image_angle)
    	draw_set_color(c_white)
    	draw_text_transformed(x+lengthdir_x(l, image_angle), y + -4 + ys[i]+lengthdir_y(l, image_angle),string_char_at(text,i+1),1,1,image_angle)
    }
}
if time < 70 and (time mod 3 < 2 || time > 30){
	for var i = 0; i < string_length(subtext); i++ {
    	draw_set_color(c_black)
    	var l = ((i - .5) * 7) * clamp(power(2 * (1 - (time - 20)/60), 6), 0, 1)
    	draw_text_transformed(x + lengthdir_x(l, image_angle), y + 4 + lengthdir_y(l, image_angle), string_char_at(subtext,i+1), 1, 1, image_angle)
    	draw_set_color(c_white)
    	draw_text_transformed(x + lengthdir_x(l, image_angle), y + 3 + lengthdir_y(l, image_angle), string_char_at(subtext,i+1), 1, 1, image_angle)
	}
}
if time <= 0 instance_destroy()


#define approach(a, b, n, dn)
return (b - a) * (1 - power((n - 1)/n, dn))

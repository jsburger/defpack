#define create_splash(_x,_y,tex)
with instance_create(_x,_y,CustomObject){
	on_draw = text_draw
	text = tex
	ys = []
	for (var i = 0; i<= string_length(text); i++){
		array_push(ys,-100*(i+1))
	}
	scrollspeed = 50
	time = 120
	image_angle = 30
	sprite_index = sprScoreSplat
	image_speed = 0
	image_index = 1
	depth = -10
	return id
}

//mod_script_call("mod","sodaeffect","drink",x,y)

#define drink(_x,_y)
var angle = random_range(45,135);
var length = random_range(30,50);
with create_splash(_x+lengthdir_x(length,angle),_y+lengthdir_y(length,angle),choose("DELICIOUS", "EXTREME", "REFRESHING", "RADICAL", "WET", "SLURPIN'")){
    image_angle = random_range(-10,30)
}

#define text_draw
time -= current_time_scale
if time > 30 || time mod 2 < 1{
    for (var i = 0; i< array_length_1d(ys); i++){
    	ys[i] = min(ys[i] + scrollspeed*current_time_scale,-2)
    	draw_set_color(c_black)
    	draw_text_transformed(x+lengthdir_x(i*7,image_angle),y +1 + ys[i]+lengthdir_y(i*7,image_angle),string_char_at(text,i+1),1,1,image_angle)
    	draw_set_color(c_white)
    	draw_text_transformed(x+lengthdir_x(i*7,image_angle),y + ys[i]+lengthdir_y(i*7,image_angle),string_char_at(text,i+1),1,1,image_angle)
    }
}
if time <= 0 instance_destroy()

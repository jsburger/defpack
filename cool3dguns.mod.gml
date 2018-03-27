#define init
global.stopwatch = sprite_add("sprites/projectiles/modStopwatch.png",8,4,2)
with instances_matching(CustomDraw,"name",mod_current) instance_destroy()
with script_bind_draw(wepdraw, 0){
	name = mod_current
	global.drawer = id
}
global.surf = surface_create(5000,5000)

#define step
if !instance_exists(global.drawer){
	with script_bind_draw(wepdraw, 0){
		name = mod_current
		global.drawer = id
	}
}
with instances_matching(WepPickup, "wep", "stopwatch"){
	if "cool3d" not in self{
		cool3d = 1
		sprite_index = mskNone
		sprite = mod_variable_get("mod",mod_current,wep)
	}
}

#define draw_shadows
with instances_matching(WepPickup,"cool3d", 1){
	draw_sprite(shd16,0,x,y)
}


#define wepdraw
var xx = 7500, yy = 7500;
surface_set_target(global.surf)
draw_clear_alpha(c_black,0)
with instances_matching(WepPickup,"cool3d", 1){
	var _x = x - xx, _y = y + 1.5*dsin(image_angle*2) - yy - 2;
	image_angle += 4*current_time_scale
	for (var i = 0; i < sprite_get_number(sprite); i++){
		draw_sprite_ext(sprite,i,_x,_y-i,1,1,image_angle,image_blend,image_alpha)
	}
}
surface_reset_target()
d3d_set_fog(1,c_black,1,1)
draw_surface(global.surf, xx+1,yy)
draw_surface(global.surf, xx-1,yy)
draw_surface(global.surf, xx,yy+1)
draw_surface(global.surf, xx,yy-1)
d3d_set_fog(0,0,0,0)
draw_surface(global.surf, xx,yy)
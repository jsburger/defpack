#define init
global.watch = sprite_add_weapon("sprStopwatch.png",0,3)
global.time = current_time_scale
global.slowed = 0
global.users = [0,0,0,0]
global.clock = 1

while 1 {
	if global.slowed{
		var t = ((30 / room_speed) - current_time_scale);
		with(Player) if(visible){
			image_index += image_speed * t;
			if reload > 0{
				reload -= t
				if skill_get(mut_stress) reload -= (1 - my_health/maxhealth) * t
				if race = "venuz" {
					reload -= .2 * t
					if ultra_get(race,1) reload -= .4 * t
				}
			}
			if race = "steroids" && breload > 0 breload -= t
			speed -= min(friction * t, speed);
			x += hspeed * t;
			y += vspeed * t;
			var _moveKeys = ["east", "nort", "west", "sout"];
				for(var i = 0; i < array_length(_moveKeys); i++){
					if(button_check(index, _moveKeys[i])){
						var d = (i * 90);
                        motion_add(d,t)
					}
				}
			
			if roll{
				angle += 40*t
			}
			with script_bind_draw(vignette,-13){
				index = other.index
				x = other.x
				y = other.y
			}
			if infammo > 0 infammo -= t
			var ang = gunangle;
			gunangle = point_direction(view_xview[index], view_yview[index], x-game_width/2, y-game_height/2)
			weapon_post(0,floor(point_distance(view_xview[index], view_yview[index], x-game_width/2, y-game_height/2)/10),0)
			gunangle = ang
			var spr = weapon_get_sprt(wep)
			var bspr = weapon_get_sprt(bwep)
			with(instance_create(x, y, CustomObject)){
				wepsprt = spr
				bwepsprt = bspr
				right = other.right
				back = other.back
				gunangle = ang
				wepangle = other.wepangle
				sprite_index = other.sprite_index;
				image_index = other.image_index;
				image_xscale = other.right * other.image_xscale;
				image_yscale = other.image_yscale;
				image_angle = other.angle + other.sprite_angle;
				image_blend = other.image_blend;
				image_alpha = other.image_alpha;
				image_speed = 0;
				depth = other.depth;
				on_step = blur_step;
				on_draw = blur_draw;
			}
		}
		with instances_matching([WepSwap,CrystalShield,CrystalShieldDisappear],"visible",1){
			image_index += image_speed * t;
		}
		global.clock = ++global.clock mod (4 + skill_get(mut_euphoria));
		if global.user != -1{
			var p = player_find(global.user);
			var stop = 1;
			if instance_exists(p){
				with p if (infammo != 0 || ammo[5] >=1) && (wep = mod_current || bwep = mod_current){
					if infammo = 0  && !global.clock ammo[5]--
					stop = 0;
				}
			}
			if stop {
				global.user = -1
				global.slowed = 0
				current_time_scale = global.time
			}
		}
		if !instance_exists(Player) || instance_exists(GenCont) || instance_exists(button){
			global.user = -1
			global.slowed = 0
			current_time_scale = global.time
		}
	}
	wait(0)
}

#define vignette
draw_set_visible_all(0)
draw_set_visible(index,1)
draw_set_blend_mode(bm_subtract)
draw_ellipse_color(x+game_width,y+game_height,x-game_width,y-game_height,c_black,c_silver,0)
draw_set_visible_all(1)
draw_set_blend_mode(bm_normal)
instance_destroy()

#define weapon_name
return `@(color:${make_color_rgb(31, 114, 255)})STOPWATCH`
#define weapon_type
return 5
#define weapon_cost
return !global.slowed
#define weapon_area
return 18
#define weapon_load
return 0
#define weapon_swap
return sndSwapGold
#define weapon_auto
return -1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
if global.slowed {
	current_time_scale = global.time
	sound_play(sndPlasmaReload)
	global.user = -1
}
else{
	global.user = index
	global.time = current_time_scale
	current_time_scale = .001 * (30 / room_speed)
	sound_play(sndPlasmaReloadUpg)
}
sound_play(sndClick)
global.slowed = !global.slowed
with script_bind_draw(circle,depth,global.slowed){
	x = other.x
	y = other.y
	creator = other
	radius = game_width*abs(global.slowed - 1)
	scaler = (global.slowed * 8 - 4)
}
#define weapon_sprt
return global.watch
#define weapon_text
return "TIME HAS A PRICE"

#define circle
with creator{
	other.x = x
	other.y = y
}
for (var i = 0; i<360;i += 360/16){
	draw_line_width_color(x+lengthdir_x(radius,i), y+lengthdir_y(radius/1.5,i), x+lengthdir_x(radius,i+360/16), y+lengthdir_y(radius/1.5,i+360/16), 8, c_lime, c_lime)
}
radius += scaler * 10
if scaler > 1 && radius >= game_width {instance_destroy(); exit}
if !scaler && radius < 0 {instance_destroy()}

#define blur_step
	depth += 0.01;
	image_alpha *= 0.5;
	if(image_alpha <= 0) instance_destroy();

#define blur_draw
if back draw_sprite_ext(wepsprt, 0, x, y, 1, right, gunangle, image_blend, image_alpha)
draw_sprite_ext(bwepsprt, 0, x-2*right, y, 1, right, 90 + 15*right, merge_color(image_blend,c_gray,.5), image_alpha)
draw_self()	
if !back draw_sprite_ext(wepsprt, 0, x, y, 1, right, gunangle, image_blend, image_alpha)

#define cleanup
current_time_scale = global.time;
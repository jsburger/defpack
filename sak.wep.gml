#define init
global.box = sprite_add_weapon("assemblykit.png",2,3)
global.guys = [0,0,0,0]
with instances_matching(CustomDraw,"customshell",1){
	instance_destroy()
}
with script_bind_draw(makemycoolgun,-15){
	persistent = 1
	customshell = 1
}
global.sprammo = sprite_add("ammoicons.png",8,0,0)
global.shellbods = ["shotgun", "eraser", "flak cannon", "pop gun", "shot cannon"]
global.slugbods = ["shotgun", "eraser", "flak cannon", "slugger", "shot cannon"]

makethechoices()
makethetexts()

#define cleanup
ds_map_destroy(global.textmap)
ds_map_destroy(global.choicemap)

#define makethechoices()
global.choicemap = ds_map_create()
var a = global.choicemap;
var sg = global.slugbods;
var sh = global.shellbods;

//ammo
a[? -1] = ["shell", "slug", "heavy slug", "flame shell", "ultra shell", "psy shell", "split shell", "split slug"]

//bodies
a[? "shell"] = sh
a[? "slug"] = sg
a[? "heavy slug"] = sg
a[? "flame shell"] = sh
a[? "ultra shell"] = sh
a[? "psy shell"] = sh
a[? "split shell"] = sh
a[? "split slug"] = sg

//mods for bodies
a[? "shotgun"] = ["double", "sawed-off", "auto", "assault", "hyper", "none"]
a[? "eraser"] = ["bird", "wave", "auto", "assault", "hyper", "none"]
a[? "flak cannon"] = ["super", "auto", "hyper", "none"]
a[? "pop gun"] = ["quad", "rifle", "hyper", "none"]
a[? "slugger"] = ["super", "gatling", "assault", "hyper", "none"]
a[? "shot cannon"] = ["super", "auto", "hyper", "none"]

#define makethetexts()
global.textmap = ds_map_create()
var a = global.textmap;

//mods
a[? "double"] = "Double gun, slightly better than one."
a[? "sawed-off"] = "Double gun, but faster and inaccurate"
a[? "auto"] = "shoot fast, eat ass"
a[? "assault"] = "shoot three times in a row"
a[? "hyper"] = "instant travel with more damage"
a[? "none"] = "no mod because i respect ammo"
a[? "bird"] = "shoot in a forking pattern"
a[? "wave"] = "shoot in a wave pattern"
a[? "quad"] = "shoot four projectiles in a regular spread"
a[? "rifle"] = "shoot three times, for only two ammo"
a[? "super"] = "five times the projectiles"
a[? "gatling"] = a[? "auto"]

//ammos
a[? "shell"] = "Standard shells"
a[? "slug"] = "Really big, expensive"
a[? "heavy slug"] = "massive, slow, very expensive"
a[? "flame shell"] = "flames for damage, dont bounce well"
a[? "ultra shell"] = "uses rads for more damage"
a[? "psy shell"] = "home in, bounce a lot, expensive"
a[? "split shell"] = "deploys duplicates on bounce"
a[? "split slug"] = "has a lot of dupes to deploy"

//bodies
a[? "shotgun"] = "shoot a random spray"
a[? "eraser"] = "shoot a concentrated line"
a[? "flak cannon"] = "shoot a flak projectile"
a[? "pop gun"] = "rapid fire single shot, uses bullets"
a[? "slugger"] = "shoots a single shot"
a[? "shot cannon"] = "shoot a projectile that disperses others"

 #define weapon_name(w)
if is_object(w){
	if w.done return w.name
}
return "SHOTGUN ASSEMBLY KIT"

#define weapon_type(w)
if is_object(w){
	if w.done return w.type
}
return 2

#define weapon_cost(w)
if is_object(w){
	if w.done return w.ammo
}
return 0

#define weapon_area
return 10

#define weapon_load(w)
if is_object(w){
	if w.done return w.load
}
return 1

#define weapon_swap
return sndSwapShotgun

#define weapon_auto
return 0

#define weapon_melee
return 0

#define weapon_laser_sight
return 0

#define weapon_fire(w)
if is_object(w){
	if w.done{
		if fork(){
			repeat(w.shots){
				var p = w.info[1];
				var m = w.info[3];
				switch w.info[2]{
					case "shotgun":
						repeat(7){
							with proj(p){
								set(20)
								speed += random_range(-2,1)
							}
						}
						break
					case "slugger":
						with proj(p){
							set(5)
						}
						break
					case "eraser":
						switch w.info[3]{
							case "bird":
								break
							case "wave":
								break
							default:
								repeat(17){
									with proj(p){
										set(1)
										speed += random_range(-2,2)
									}
								}
								break
						}
						break
					case "":
						break
					case "":
						break

				}
				if w.time wait(w.time)
			}
		}
	}
}else{
	wep = wep_shotgun
	player_fire()
	wep = w
}

#define proj(thing)
switch thing{
	case "shell":
		var a = instance_create(x,y,Bullet2)
		with a{
			speed = random_range(12,18)
		}
		return a
	case "slug":
		var a = instance_create(x,y,Slug);
		with a{
			speed = 16
		}
		return a
}

#define set(range)
direction = other.gunangle + random_range(-range,range)*other.accuracy
team = other.team
creator = other

#define weapon_sprt(w)
if is_object(w){
	if w.done return sprShotgun
}
return global.box

#define weapon_text
return choose("Gunlocker, eat your heart out", "essence of shell")

#define step(q)
if button_pressed(index,"horn")&&q{
	wep = mod_current
}
if q && !is_object(wep){
	wep = {
		wep: mod_current,
		ammo: 1,
		type: 2,
		load: 1,
		shots: 1,
		time: 0,
		info: [-1,0,0],
		numbers: [0,0,0],
		name: "Custom Shotgun!",
		phase: 0,
		done: 0
	}
}

//this thing is the distance between shit
#macro gx 22

#define makemycoolgun
with Player if is_object(wep) && wep.wep = mod_current && !wep.done{
	var w = wep;
	var tex = global.textmap;
	var cho = global.choicemap;
	var width = array_length_1d(cho[? w.info[w.phase]]);
	var height = 50;
	var _x = view_xview[index]+game_width/2 - width*gx/2;
	var _y = view_yview[index] + 50;
	draw_set_color(make_color_rgb(47, 50, 56))
	draw_rectangle(_x,_y,_x + gx*width, _y + height,0)
	draw_set_color(make_color_rgb(9, 15, 25))
	draw_rectangle(_x+1,_y+5,_x + gx*width -1, _y + 25,0)
	draw_set_color(c_white)
	for (var i = 0; i< width; i++){
		var x1 = _x+gx*i + 2;
		var y1 = _y + 6;
		var x2 = _x+gx*(i+1) - 2;
		var y2 = y1 + 18;
		draw_sprite_ext(global.sprammo,i,x1,y1,1,1,0,c_gray,1)
		if point_in_rectangle(mouse_x[index], mouse_y[index], x1, y1, x2, y2){
			if !button_check(index, "fire"){
				draw_sprite(global.sprammo,i,x1,y1)
			}
			draw_set_font(fntSmall)
			var access = cho[? w.info[w.phase]][i]
			draw_text(_x+1,y2+3,access)
			draw_text_ext(_x+1,y2+9,tex[? access], 6, 22*width)
			if button_released(index, "fire"){
				sound_play(sndClick)
				var n = w.name;
				switch w.phase{
					case 0:
						n = access
						break
					case 1:
						n += " " + access
						break
					case 2:
						n = access + " " + n
						if access = "wave" || access = "bird"{
							n = cho[? w.info[0]][w.numbers[0]] + " " + access
							if access = "wave"{
								n+=" gun"
							}
						}
						n = string_replace_all(n, " shell", "")
						n = string_replace_all(n, "none ", "")
						if string_count("slugger",n) && string_count("slug", n){
							n = string_replace(n, " slug", "")
						}
						break
				}
				w.name = n
				w.info[++w.phase] = access
				w.numbers[w.phase-1] = i
				if w.phase = 3{
					w.done = 1;

				}
			}
		}
	}
}

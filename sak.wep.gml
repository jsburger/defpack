#define init
global.box = sprite_add_weapon("sprites/sprSAK.png",2,3)
global.guys = [0,0,0,0]
with instances_matching([CustomDraw,CustomStep],"customshell",1){
	instance_destroy()
}
with script_bind_draw(makemycoolgun,-15){
	persistent = 1
	customshell = 1
}
with script_bind_step(birdspread, 0){
	persistent = 1
	customshell = 1
}
global.sprammo = sprite_add("sprites/sprSAKammo.png",8,0,0)
global.sprbody = sprite_add("sprites/sprSAKbody.png",6,0,0)
global.sprmods = sprite_add("sprites/sprSAKmods.png",9,0,0)
global.shellbods = ["shotgun", "eraser", "flak cannon", "pop gun", "shot cannon"]
global.slugbods = ["shotgun", "eraser", "flak cannon", "slugger", "shot cannon"]

//epic gunsprite action
///REGULAR///
global.sprShotgun 	     = sprShotgun
global.sprDoubleShotgun  = sprSuperShotgun
global.sprSawnOffShotgun = sprSawnOffShotgun
global.sprAutoShotgun    = sprAutoShotgun
global.sprAssaultShotgun = sprite_add_weapon("sprites/sak/sprAssaultShotgun.png",8,4)
global.sprHyperShotgun   = sprite_add_weapon("sprites/sak/sprHyperShotgun.png",6,6)

global.sprFlakCannon      = sprFlakCannon
global.sprSuperFlakCannon = sprSuperFlakCannon
global.sprAutoFlakCannon  = sprite_add_weapon("sprites/sak/sprAutoFlakCannon.png",3,5)
global.sprHyperFlakCannon = sprite_add_weapon("sprites/sak/sprHyperFlakCannon.png",7,8)

global.sprShotCannon 			= sprite_add_weapon("sprites/sak/sprShotCannon.png",6,6)
global.sprSuperShotCannon = sprite_add_weapon("sprites/sak/sprSuperShotCannon.png",7,7)
global.sprAutoShotCannon  = sprite_add_weapon("sprites/sak/sprAutoShotCannon.png",5,5)
global.sprHyperShotCannon = sprite_add_weapon("sprites/sak/sprHyperShotCannon.png",6,9)

global.sprEraser 		    = sprEraser
global.sprAutoEraser    = sprite_add_weapon("sprites/sak/sprAutoEraser.png",8,5)
global.sprAssaultEraser = sprite_add_weapon("sprites/sak/sprAssaultEraser.png",9,5)
global.sprBird          = sprite_add_weapon("sprites/sak/sprBird.png",8,6)
global.sprWaveGun       = sprWaveGun
global.sprHyperEraser   = sprite_add_weapon("sprites/sak/sprHyperEraser.png",7,7)

global.sprPopGun 			  = sprPopGun
global.sprTriplePopGun  = sprite_add_weapon("sprites/sak/sprTriplePopGun.png",9,7)
global.sprPopRifle      = sprPopRifle
global.sprHyperPopGun   = sprite_add_weapon("sprites/sak/sprHyperPopGun.png",7,6)

///PSY///
global.sprPsyShotgun 	      = sprite_add_weapon("sprites/sak/sprPsyShotgun.png",7,6)
global.sprDoublePsyShotgun  = sprite_add_weapon("sprites/sak/sprDoublePsyShotgun.png",8,6)
global.sprSawnOffPsyShotgun = sprite_add_weapon("sprites/sak/sprSawedOffPsyShotgun.png",8,6)
global.sprAutoPsyShotgun    = sprite_add_weapon("sprites/sak/sprAutoPsyShotgun.png",7,3)
global.sprAssaultPsyShotgun = sprite_add_weapon("sprites/sak/sprAutoPsyShotgun.png",7,5)
global.sprHyperPsyShotgun   = sprite_add_weapon("sprites/sak/sprHyperPsyShotgun.png",7,6)

global.sprPsyFlakCannon  		 = sprite_add_weapon("sprites/sak/sprPsyFlakCannon.png",4,6)
global.sprSuperPsyFlakCannon = sprite_add_weapon("sprites/sak/sprSuperPsyFlakCannon.png",6,7)
global.sprAutoPsyFlakCannon  = sprite_add_weapon("sprites/sak/sprAutoPsyFlakCannon.png",4,6)
global.sprHyperPsyFlakCannon = sprite_add_weapon("sprites/sak/sprHyperPsyFlakCannon.png",8,6)

global.sprPsyShotCannon 		 = sprite_add_weapon("sprites/sak/sprPsyShotCannon.png",8,6)
global.sprSuperPsyShotCannon = sprite_add_weapon("sprites/sak/sprSuperPsyShotCannon.png",7,7)
global.sprAutoPsyShotCannon  = sprite_add_weapon("sprites/sak/sprAutoPsyShotCannon.png",6,8)
global.sprHyperPsyShotCannon = sprite_add_weapon("sprites/sak/sprHyperPsyShotCannon.png",6,8)

global.sprPsyEraser        = sprite_add_weapon("sprites/sak/sprHyperPsyShotCannon.png",6,8)
global.sprAutoPsyEraser    = sprite_add_weapon("sprites/sak/sprAutoPsyEraser.png",6,5)
global.sprAssaultPsyEraser = sprite_add_weapon("sprites/sak/sprAssaultPsyEraser.png",8,6)
global.sprPsyBird					 = sprite_add_weapon("sprites/sak/sprPsyBird.png",6,8)
global.sprPsyWaveGun       = sprite_add_weapon("sprites/sak/sprPsyWaveGun.png",7,6)
global.sprHyperPsyEraser   = sprite_add_weapon("sprites/sak/sprHyperPsyEraser.png",7,7)

global.sprPsyPopGun				 = sprite_add_weapon("sprites/sak/sprPsyPopGun.png",6,3)
global.sprTriplePsyPopGun  = sprite_add_weapon("sprites/sak/sprTriplePsyPopGun.png",6,6)
global.sprAssaultPsyPopGun = sprite_add_weapon("sprites/sak/sprAssaultPsyPopGun.png",6,5)
global.sprPsyPopRifle    	 = sprite_add_weapon("sprites/sak/sprHyperPsyPopGun.png",6,4)

///SPLIT SHELL///
global.sprSplitShotgun 				= sprite_add_weapon("sprites/sak/sprSplitShotgun.png",6,5)
global.sprDoubleSplitShotgun  = sprite_add_weapon("sprites/sak/sprDoubleSplitShotgun.png",6,6)
global.sprSawnOffSplitShotgun = sprite_add_weapon("sprites/sak/sprSawedOffSplitShotgun.png",6,6)
global.sprAutoSplitShotgun    = sprite_add_weapon("sprites/sak/sprAutoSplitShotgun.png",7,4)
global.sprAssaultSplitShotgun = sprite_add_weapon("sprites/sak/sprAssaultSplitShotgun.png",9,4)
global.sprHyperSplitShotgun   = sprite_add_weapon("sprites/sak/sprHyperSplitShotgun.png",7,6)

global.sprSplitFlakCannon			 = sprite_add_weapon("sprites/sak/sprSplitFlakCannon.png",4,86)
global.sprSuperSplitFlakCannon = sprite_add_weapon("sprites/sak/sprSuperSplitFlakCannon.png",5,8)
global.sprAutoSplitFlakCannon  = sprite_add_weapon("sprites/sak/sprAutoSplitFlakCannon.png",5,6)
global.sprHyperSplitFlakCannon = sprite_add_weapon("sprites/sak/sprHyperSplitFlakCannon.png",9,6)

global.sprSplitShotCannon 		 = sprite_add_weapon("sprites/sak/sprSplitShotCannon.png",7,6)
global.sprSuperSplitShotCannon = sprite_add_weapon("sprites/sak/sprSuperSplitShotCannon.png",8,7)
global.sprAutoSplitShotCannon  = sprite_add_weapon("sprites/sak/sprAutoSplitShotCannon.png",5,6)
global.sprHyperSplitShotCannon = sprite_add_weapon("sprites/sak/sprHyperSplitShotCannon.png",5,7)

global.sprSplitEraser 			 = sprite_add_weapon("sprites/sak/sprAutoSplitEraser.png",10,5)
global.sprAutoSplitEraser    = sprite_add_weapon("sprites/sak/sprAutoSplitEraser.png",8,5)
global.sprAssaultSplitEraser = sprite_add_weapon("sprites/sak/sprAssaultSplitEraser.png",8,5)
global.sprSplitBird					 = sprite_add_weapon("sprites/sak/sprSplitBird.png",6,7)
global.sprSplitWaveGun			 = sprite_add_weapon("sprites/sak/sprSplitWaveGun.png",6,7)
global.sprHyperSplitEraser   = sprite_add_weapon("sprites/sak/sprHyperSplitEraser.png",7,7)

global.sprSplitPopGun			 	 = sprite_add_weapon("sprites/sak/sprSplitPopGun.png",6,4)
global.sprTripleSplitPopGun	 = sprite_add_weapon("sprites/sak/sprTripleSplitPopGun.png",8,6)
global.sprSplitPopRifle 		 = sprite_add_weapon("sprites/sak/sprAssaultSplitPopGun.png",7,4)
global.sprHyperSplitPopGun	 = sprite_add_weapon("sprites/sak/sprHyperSplitPopGun.png",6,6)

///FLAME SHELLS///
global.sprFlameShotgun  		  = sprFlameShotgun
global.sprDoubleFlameShotgun  = sprDoubleFlameShotgun
global.sprSawnOffFlameShotgun = sprite_add_weapon("sprites/sak/sprSawedOffFlameShotgun.png",6,5)
global.sprAutoFlameShotgun    = sprAutoFlameShotgun
global.sprAssaultFlameShotgun = sprite_add_weapon("sprites/sak/sprAssaultFlameShotgun.png",6,4)
global.sprHyperFlameShotgun   = sprite_add_weapon("sprites/sak/sprHyperFlameShotgun.png",6,5)

global.sprFlameFlakCannon 		 = sprite_add_weapon("sprites/sak/sprFlameFlakCannon.png",4,6)
global.sprSuperFlameFlakCannon = sprite_add_weapon("sprites/sak/sprSuperFlameFlakCannon.png",5,8)
global.sprAutoFlameFlakCannon  = sprite_add_weapon("sprites/sak/sprAutoFlameFlakCannon.png",4,5)
global.sprHyperFlameFlakCannon = sprite_add_weapon("sprites/sak/sprHyperFlameFlakCannon.png",5,7)

global.sprFlameShotCannon 		 = sprite_add_weapon("sprites/sak/sprFlameShotCannon.png",7,6)
global.sprSuperFlameShotCannon = sprite_add_weapon("sprites/sak/sprSuperFlameShotCannon.png",8,7)
global.sprAutoFlameShotCannon  = sprite_add_weapon("sprites/sak/sprAutoFlameShotCannon.png",7,5)
global.sprHyperFlameShotCannon = sprite_add_weapon("sprites/sak/sprHyperFlameShotCannon.png",7,7)

global.sprFlameEraser 			 = sprite_add_weapon("sprites/sak/sprFlameEraser.png",7,6)
global.sprAutoFlameEraser    = sprite_add_weapon("sprites/sak/sprAutoFlameEraser.png",7,5)
global.sprAssaultFlameEraser = sprite_add_weapon("sprites/sak/sprAssaultFlameEraser.png",7,6)
global.sprPhoenix						 = sprite_add_weapon("sprites/sak/sprPhoenix.png",6,5)
global.sprFlameWaveGun 			 = sprite_add_weapon("sprites/sak/sprFlameWaveGun.png",5,7)
global.sprHyperFlameEraser	 = sprite_add_weapon("sprites/sak/sprHyperFlameEraser.png",8,6)

global.sprFlamePopGun 			 = sprite_add_weapon("sprites/sak/sprFlamePopGun.png",6,5)
global.sprTripleFlamePopGun  = sprite_add_weapon("sprites/sak/sprFlamePopGun.png",8,8)
global.sprFlamePopRifle 	   = sprite_add_weapon("sprites/sak/sprFlamePopRifle.png",9,5)
global.sprHyperFlamePopGun   = sprite_add_weapon("sprites/sak/sprHyperFlamePopGun.png",7,6)

///ULTRA SHELLS///
/*global.
global.
global.
global.
global.
global.
global.
global.
global.
global.
global.
global.
global.
global.
global.
global.
global.
global.
*/

makethechoices()
makethetexts()
makethestats()

#define cleanup
ds_map_destroy(global.textmap)
ds_map_destroy(global.choicemap)
ds_map_destroy(global.stats)

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
a[? "pop gun"] = ["triple", "rifle", "hyper", "none"]
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
a[? "triple"] = "shoot three projectiles in a regular spread"
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

#define makethestats()
global.stats = ds_map_create()
var a = global.stats

//[ammo, reload, sound, rads]
//based off of firing a shotgun of said type (the cost of 7 projectiles)
a[? "shell"] = [1, 1, sndShotgun, 0]
a[? "slug"] = [7, 2, sndSlugger, 0]
a[? "heavy slug"] = [13, 1.8, sndHeavySlugger, 0]
a[? "flame shell"] = [1, 1.2, sndFireShotgun, 0]
a[? "ultra shell"] = [3, .7, sndUltraShotgun, 9]
a[? "psy shell"] = [2, 1.3, sndShotgun, 0]
a[? "split shell"] = [2, 1.2, sndShotgun, 0]
a[? "split slug"] = [4, 1.5, sndSlugger, 0]

//[ammo, reload base, sound]
a[? "shotgun"] = [1, 17, sndShotgun]
a[? "eraser"] = [2, 20, sndEraser]
a[? "flak cannon"] = [2, 26, sndFlakCannon]
a[? "pop gun"] = [1, 2, sndPopgun]
a[? "slugger"] = [1/6, 11, sndSlugger]
a[? "shot cannon"] = [4, 25, sndFlakCannon]

//[ammo, reload, sound]
a[? "double"] = [2, 1.6, sndDoubleShotgun]
a[? "sawed-off"] = [2, 1.6, sndSawedOffShotgun]
a[? "auto"] = [1, .4, sndPopgun]
a[? "assault"] = [3, 2, -1]
a[? "hyper"] = [1, 1, sndHyperSlugger]
a[? "none"] = [1, 1, -1]
a[? "bird"] = [1, 1.2, -1]
a[? "wave"] = [1, 1.2, sndWaveGun]
a[? "triple"] = [3, 1, sndIncinerator]
a[? "rifle"] = [2, 2, -1]
a[? "super"] = [5, 2.3, sndSuperSlugger]
a[? "gatling"] = [1, .3, -1]


#define take_wave(w)
w.sounds = [sndWaveGun]
#define take_pop_gun(w)
w.type = 1
w.auto = 1
#define take_assault(w)
w.shots = 3
w.time = 3
#define take_rifle(w)
w.shots = 3
w.auto = 1
w.time = 2
#define take_auto(w)
w.auto = 1
#define take_gatling(w)
w.auto = 1

#define weapon_name(w)
if is_object(w){
	if w.done return w.name
}
return `@(color:${make_color_rgb(255, 156, 0)})SHOTGUN ASSEMBLY KIT`

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

#define weapon_rads(w)
if is_object(w){
	if w.done return w.rads
}
return 0


#define weapon_area
return 12

#define weapon_load(w)
if is_object(w){
	if w.done return w.load
}
return 1

#define weapon_swap
return sndSwapShotgun

#define weapon_auto(w)
if is_object(w){
	if w.done return w.auto
}

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
				for (var i = 0; i<array_length_1d(w.sounds); i++){
					sound_play(w.sounds[i])
				}
				weapon_post(w.ammo * 2,w.ammo,w.ammo)
				mod_script_call("weapon",mod_current,string_replace(w.info[2]," ","_"),w.info[1],w.info[3])
				if w.time wait(w.time)
			}
			exit
		}
	}
}else{
	wep = wep_shotgun
	player_fire()
	wep = w
}

#define pop_gun(p,m)
switch m{
	case "triple":
		for (var i = -1; i<= 1; i++){
			with proj(p){
				fset(23,3,i,1)
				if "stockspeed" in self speed = stockspeed
			}
		}
		break
	default:
		with proj(p){
			set(4)
			if "stockspeed" in self speed = stockspeed
			if m = "hyper" hyper_travel()
		}
		break
}

#define eraser(p,m)
switch m {
	case "bird":
		if fork(){
			repeat(5){
				for (var i = -1; i<= 1; i++){
					with proj(p){
						fset(13,2*abs(i) + 2,i,1);
						if i != 0 {birdspeed = i* .5* other.accuracy}
					}
				}
				wait(1)
			}
			exit
		}
		break
	case "wave":
		if fork(){
			for (var i = -3/8; i<= 3; i+= 3/8){
				with proj(p){
					direction = other.gunangle + 15*sin(i) *other.accuracy;
					image_angle = direction
					creator = other
					team = other.team
					if "stockspeed" in self speed = stockspeed
				}
				with proj(p){
					direction = other.gunangle - 15*sin(i) *other.accuracy;
					image_angle = direction
					creator = other
					team = other.team
					if "stockspeed" in self speed = stockspeed
				}
				wait(1)
			}
			exit
		}
		break
	case "auto":
		repeat(15){
			with proj(p){
				set(1)
				speed += random_range(-2,2)
			}
		}
		break
	default:
		repeat(17){
			with proj(p){
				set(1)
				speed += random_range(-2,2)
				if m = "hyper" hyper_travel()
			}
		}
		break
}

#define slugger(p,m)
switch m{
	case "super":
		for (var i = -2; i<= 2; i++){
			with proj(p) {
				fset(12,3,i,1)
			}
		}
		break
	default:
		with proj(p){
			set(5)
			if m = "hyper" hyper_travel()
		}
		break
}

#define flak_cannon(p,m)
switch m{
	case "super":
	default:
		with flak(){
			payload = p
			set(3)
			speed = random_range(11,13)
			if m = "hyper"{
				hyper = 1
				hyper_travel()
			}
		}
}



#define shotgun(p,m)
switch m{
	case "double":
		repeat(14){
			with proj(p) {
				set(30)
				speed += random_range(-2,1)
			}
		}
		break
	case "sawed-off":
		repeat(20){
			with proj(p) {
				set(45)
				speed += random_range(-2,1)
			}
		}
		break
	default:
		repeat(7){
			with proj(p){
				set(20)
				if m = "hyper" hyper_travel()
				speed += random_range(-2,1)
			}
		}
		break
}

#define proj(thing)
switch thing{
	case "shell":
		var a = instance_create(x,y,Bullet2)
		with a{
			speed = random_range(12,18)
			stockspeed = 16
		}
		return a
	case "slug":
		var a = instance_create(x,y,Slug);
		with a{
			speed = 16
		}
		return a
	case "heavy slug":
		with instance_create(x,y,HeavySlug){
			speed = 13
			return id
		}
	case "flame shell":
		with instance_create(x,y,FlameShell){
			speed = random_range(12,18)
			stockspeed = 16
			return id
		}
	case "ultra shell":
		with instance_create(x,y,UltraShell){
			speed = random_range(12,18)
			stockspeed = 16
			return id
		}
	case "psy shell":
		with mod_script_call("mod", "defpack tools", "create_psy_shell",x,y){
			speed = random_range(12,18)
			stockspeed = 16
			return id
		}
	case "split shell":
		with mod_script_call("mod", "defpack tools", "create_split_shell",x,y){
			speed = random_range(15,18)
			stockspeed = 17
			ammo = 2
			return id
		}
	case "split slug":
		with mod_script_call("mod", "defpack tools", "create_split_shell",x,y){
			speed = random_range(17,20)
			stockspeed = 19
			ammo = 3
			damage = 7
			falloff = 2
			return id
		}
}

#define flak
with instance_create(x,y,CustomProjectile){
	sprite_index = sprFlakBullet
	mask_index = mskFlakBullet
	on_destroy = flakpop
	on_step = flakstep
	damage = 8
	payload = "shell"
	friction = .4
	ammo = 14
	hyper = 0
	return id
}

#define flakstep
if speed < .01{
	instance_destroy()
}

#define flakpop
sound_play_hit(sndFlakExplode,.1)
if skill_get(mut_eagle_eyes){
	for var i = 0; i< 360; i+=360/ammo{
		with (proj(payload)){
			direction = i
			image_angle = i
			creator = other.creator
			team = other.team
			if other.hyper hyper_travel()
		}
	}
}
else{
	repeat(ammo){
		with proj(payload){
			direction = random(360)
			image_angle = direction
			creator = other.creator
			team = other.team
			if other.hyper hyper_travel()
		}
	}
}

#define hyper_travel
x+=lengthdir_x(sprite_width-sprite_xoffset,direction)
y+=lengthdir_y(sprite_width-sprite_xoffset,direction)
damage = floor(damage*1.1)
var move = 1;
for(var i = 0;i<=100;i++){
	var xx = x+lengthdir_x(8 * i,direction), yy = y+lengthdir_y(8 * i,direction);
	var man = instance_place(xx,yy,hitme);
	if (instance_exists(man) && man.team != team) || place_meeting(xx,yy,Wall){
		var _x = x, _y = y;
		x += lengthdir_x(8 * i, direction);
		y += lengthdir_y(8 * i, direction);
		move = 0
		xprevious += lengthdir_x(8 * (i-1), direction);
		yprevious += lengthdir_y(8 * (i-1), direction);
		for(var o = 0;o <= i;o++){
			if !random(1) instance_create(_x + lengthdir_x(8 * o,direction) + random_range(-4,4), _y + lengthdir_y(8 * o,direction) + random_range(-4,4), Dust);
		}
		break;
	}
}
if move{
	x = xx
	y = yy
}
#define fset(range,subrange,n,acc)
direction = other.gunangle + (range*n)*(acc ? other.accuracy : 1) + random_range(-subrange,subrange)*other.accuracy
team = other.team
creator = other
image_angle = direction

#define set(range)
direction = other.gunangle + random_range(-range,range)*other.accuracy
team = other.team
creator = other
image_angle = direction


#define weapon_sprt(w)
if is_object(w){
	if w.done return sprShotgun
}
return global.box

#define weapon_text
return choose("Gunlocker, eat your heart out","essence of shell")

#define birdspread
with instances_matching_ne(projectile,"birdspeed",null){
	direction+=birdspeed * current_time_scale * speed
	image_angle = direction
}

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
		sounds: [],
		rads: 0,
		auto: 0,
		time: 0,
		info: [-1,0,0],
		numbers: [0,0,0],
		name: "Custom Shotgun!",
		phase: 0,
		done: 0
	}
}

#define stats(w)
var sts = global.stats;
w.load = floor(sts[? w.info[2]][1] * sts[? w.info[1]][1] * sts[? w.info[3]][1])
w.ammo = floor(sts[? w.info[2]][0] * sts[? w.info[1]][0] * sts[? w.info[3]][0])
w.rads = sts[? w.info[1]][3]
for (var i = 1; i<= 3; i++){
	array_push(w.sounds,sts[? w.info[i]][2])
	if mod_script_exists("weapon", mod_current, "take_"+string_replace(w.info[i]," ","_")) mod_script_call("weapon", mod_current, "take_"+string_replace(w.info[i]," ","_"),w)
}

//this thing is the distance between shit
#macro gx 22

#define makemycoolgun
draw_set_halign(0)
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
		var push = button_pressed(index,"key"+string(i+1));
		if point_in_rectangle(mouse_x[index], mouse_y[index], x1, y1, x2, y2) || push{
			if !button_check(index, "fire"){
				draw_sprite(global.sprammo,i,x1,y1)
			}
			draw_set_font(fntSmall)
			var access = cho[? w.info[w.phase]][i]
			draw_text(_x+1,y2+3,access)
			draw_text_ext(_x+1,y2+9,tex[? access], 6, 22*width)
			if button_released(index, "fire") || push{
				sound_play(sndClick)
				w.info[++w.phase] = access
				w.numbers[w.phase-1] = i
				if w.phase = 3{
					w.done = 1;
					stats(w)
					name(w)
				}
			}
		}
	}
}
draw_set_halign(1)


#define make_gun_random
var w = {
		wep: mod_current,
		ammo: 1,
		type: 2,
		load: 1,
		shots: 1,
		sounds: [],
		rads: 0,
		auto: 0,
		time: 0,
		info: [-1,0,0],
		numbers: [0,0,0],
		name: "Custom Shotgun!",
		phase: 0,
		done: 0
	}
var cho = global.choicemap;
for (var i = 0; i< 3; i+=0){
	var n = irandom(array_length_1d(cho[? w.info[i]]) -1);
	w.numbers[i] = n
	w.info[++i] = cho[? w.info[i-1]][n]
}
w.done = 1
stats(w)
name(w)
return w

#define name(w)
w.name = `${w.info[3]} ${w.info[1]} ${w.info[2]}`
if w.info[3] = "wave" || w.info[3] = "bird"{
	w.name = `${w.info[1]} ${w.info[3]}`
	if w.info[3] = "wave" w.name += " gun"
}
w.name = string_replace(w.name, "none ", "")
w.name = string_replace(w.name, "shell ", "")
if w.info[2] = "slugger" w.name = string_replace(w.name, "slug ", "")

#define weapon_reloaded
return-4;

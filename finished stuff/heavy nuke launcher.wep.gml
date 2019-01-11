#define init
global.sprHeavyNuke 				  = sprite_add("sprHeavyNuke.png",0, 8, 6);
global.sprHeavyNukeLauncher   = sprite_add_weapon("sprHeavyNukeLauncher.png", 20, 8);
global.sprSmallGreenExplosion = sprite_add("GreenExplosionS.png",7,12,12)
global.sprHeavyNukeFlame 			= sprite_add("sprHeavyNukeFlame.png",3,36,12)
global.sprUltraFire 					= sprite_add("sprUltraFire.png",7,8,8);
#define weapon_name
return "HEAVY NUKE LAUNCHER";

#define weapon_sprt
return global.sprHeavyNukeLauncher;

#define weapon_type
return 4;

#define weapon_chrg
return 1;

#define weapon_auto
return false;

#define weapon_load
return 60;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 12;

#define weapon_text
return choose("STANDING, ON THE EDGE","WHAT A MESS WE MADE","A HEART OF BROKEN GLASS","DESOLATION","DEVASTATION");

#define weapon_fire
sound_play_pitch(sndRocket,.8)
sound_play_pitch(sndHeavyNader,1)
sound_play_pitch(sndHeavySlugger,.6)
weapon_post(15,-146,82)
sleep(40)
motion_add(gunangle,-5)
with instance_create(x,y,CustomProjectile){
	friction = .18
	motion_set(other.gunangle, 7)
	team = other.team
	creator = other
	name = "Heavy Nuke"
	sprite_index = global.sprHeavyNuke
	index = other.index
	accuracy = other.accuracy
	typ = 2
	timer = 30
	damage = 100
	fimage_index = 0
	soundcheck = 0
	btn = other.specfiring ? "spec" : "fire"
	on_step = script_ref_create(nuke_step)
	on_destroy = script_ref_create(nuke_pop)
	on_draw = script_ref_create(nuke_draw)
	repeat(12)
    	with instance_create(x+lengthdir_x(speed,direction),y+lengthdir_y(speed,direction),Smoke){
    		motion_add(other.direction+random_range(-30,30)*other.creator.accuracy,2+random(2))
    	}
}
sleep(70)

#define nuke_step
if instance_exists(creator){
    if btn = "fire" creator.reload = weapon_get_load(creator.wep)
    if btn = "spec"{
        if creator.race = "steroids"
            creator.breload = weapon_get_load(creator.bwep)
        else
            creator.reload = max(weapon_get_load(creator.wep) * array_length_1d(instances_matching(instances_matching(instances_matching(CustomProjectile, "name", name),"creator",creator),"btn",btn)), creator.reload)
    }
}
if soundcheck = 1{
	if !instance_exists(creator){instance_destroy();exit}
	if !button_check(creator.index,btn){
		instance_destroy()
		exit
	}
}
if timer > 0{timer -= current_time_scale}
else{
	if fimage_index < 2{fimage_index += .5*current_time_scale}
	else{
		fimage_index = 0
	}
}
var _x = mouse_x[index]
var _y = mouse_y[index]
if instance_exists(creator) {
	if timer <= 0 && speed >= 3{motion_add(point_direction(x,y,_x,_y),.6*current_time_scale)}
	image_angle = direction
}
if timer <= 0{
	if !soundcheck{
		soundcheck = 1
		view_shake_at(x,y,32)
		sound_play(sndNukeFire)
		repeat(22)
		with instance_create(x- hspeed*2, y - vspeed*2, Flame){
			team = other.team
			sprite_index = global.sprUltraFire
			motion_add(other.direction-180+random_range(-4,4),random_range(1,5))
			image_xscale /= speed
			image_yscale = image_xscale
			damage = 8
		}
	}
	if speed < 6{friction = -.35}
	else{speed = 6}
	if random(100) <= 80*current_time_scale with instance_create(x- hspeed*2, y - vspeed*2, Smoke) {
		motion_set(other.direction+random_range(-8,8)-180,2+random(2))
	}
}
if place_meeting(x, y, Explosion){
	instance_destroy()
}

#define nuke_pop
var i = random(360);
//with instance_create(x + random_range(-10,10) * accuracy, y + random_range(-10,10) * accuracy, GreenExplosion){hitid = [sprite_index,"green#Explosion"]}
repeat(8){
	repeat(22) with instance_create(x,y,Smoke){motion_add(i+random_range(-5,5),random_range(4,	12))}
	with instance_create(x + lengthdir_x(17,i) + random_range(-10,10) * accuracy, y  + lengthdir_y(17,i) + random_range(-10,10) * accuracy, GreenExplosion){hitid = [sprite_index,"green#Explosion"]}
	i += 360/8
}
repeat(16){
	repeat(16) with instance_create(x,y,Smoke){motion_add(i+random_range(-16,16),random_range(4,																																																																																																																																																																																																																																																																																																																																																													7))}
	with instance_create(x + lengthdir_x(80,i) + random_range(-40,40), y + lengthdir_y(80,i) + random_range(-10,10) * accuracy, SmallExplosion){
		damage = 12
		image_speed = .3
		sprite_index = global.sprSmallGreenExplosion
		hitid = [sprite_index,"Small green#Explosion"]
	}
	i += 360/16
}
with instance_create(x,y,CustomObject){timer = 1;on_step = freeze_step}
sleep(100)
sound_play_pitchvol(sndHyperCrystalTaunt,11,.4)
sound_play_pitch(sndSniperTarget,.8)
sound_play_pitch(sndHitMetal,.4)
sound_play_pitch(sndDoubleShotgun,.6)
sound_play_pitch(sndSuperSlugger,.7)
sound_play_pitch(sndStatueXP,.09) //sound_play_pitch(sndStatueCharge,.2) for the gunsoleum, statue sound in general
#define nuke_draw
if timer <= 0{draw_sprite_ext(global.sprHeavyNukeFlame,fimage_index,x,y,.75,.75,direction,c_white,1)}
draw_self()

#define freeze_step
if timer > 0 timer -= current_time_scale else{
	sleep(300)
	sound_play(sndNukeExplosion)
	sound_play_pitch(sndExplosionL,.7)
	sound_play_pitch(sndExplosionXL,.9)
	view_shake_max_at(x,y,1500)
	instance_destroy()
}

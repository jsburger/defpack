#define init
global.sprSmartNukeLauncher = sprite_add_weapon("sprSmartNukeLauncher.png", 5, 5);
global.sprSmartNuke 				= sprite_add("sprSmartNuke.png",0, 7, 5);
global.sprBlueExplosion 		= sprite_add("sprSmartExplosionS.png",7,12,12)
global.sprSmartNukeFlame 		= sprite_add("sprSmartNukeFlame.png",3,32,12)
global.sprSmartAim 					= sprite_add("sprSmartAim.png",0,9,9)
#define weapon_name
return "SMART NUKE LAUNCHER";

#define weapon_sprt
return global.sprSmartNukeLauncher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 28;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 11;

#define weapon_text
return "AT ITS MERCY";

#define weapon_fire
sound_play_pitch(sndNukeFire,random_range(1.1,1.3))
sound_play_pitch(sndSmartgun,random_range(.5,.7))
weapon_post(10,-56,46)
with instance_create(x,y,CustomProjectile){
	move_contact_solid(other.gunangle,8)
	motion_set(other.gunangle, 2)
	team = other.team
	creator = other
	maxspeed = speed
	damage = 60
	ang = random(359)
	sprite_index = global.sprSmartNuke
	index = other.index
	fimage_index = 0
	timer = 20
	dinged = 0
	_closeboy = 0
	aimoffset = 40
	typ = 2
	on_step = script_ref_create(nuke_step)
	on_destroy = script_ref_create(nuke_pop)
	on_draw = rocket_draw
}
sound_play(sndRocketFly)

#define nuke_step
if fimage_index <= 2{fimage_index += 1}else{fimage_index = 0}
if !timer
{
	maxspeed = 5
	if random(100) <= 100*current_time_scale with instance_create(x- hspeed, y - vspeed, Flame){
    	image_xscale *= .75
    	image_yscale = image_xscale
    	sprite_index = sprFireLilHunter
    	team = other.team
    }
}
else{if random(100) <= 100*current_time_scale instance_create(x- hspeed, y - vspeed, Smoke)}
var aa = 1;
if timer {timer -= current_time_scale}
if timer = 1{repeat(12){with instance_create(x+random_range(-12,12),y+random_range(-12,12),Smoke){depth = other.depth -3}}}
if instance_exists(enemy) && !timer and instance_exists(creator){
	friction = -.3
	var closeboy = instance_nearest(mouse_x[creator.index],mouse_y[creator.index],enemy)
	if _closeboy != closeboy{aimoffset = 60;if collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) = noone{sound_play_pitch(sndSniperTarget,2)}}
	_closeboy = closeboy
	var _x = closeboy.x;
	var _y = closeboy.y;
	if !collision_line(x,y,_x,_y,Wall,0,0){
		if !dinged {instance_create(x,y,AssassinNotice);dinged = 1}
		motion_add(point_direction(x,y,_x,_y),1.4*current_time_scale)
		image_angle = direction
		maxspeed = 7
		aa = 0
	}
}
if speed > maxspeed{speed = maxspeed}
if aa && instance_exists(creator){
	var _x = mouse_x[index];
	var _y = mouse_y[index];
	motion_add(point_direction(x,y,_x,_y),.4*current_time_scale)
	image_angle = direction
	speed = 4
}

#define nuke_pop
with instance_create(x,y,Explosion){
	sprite_index = global.sprBlueExplosion
	hitid = [sprite_index, "Blue Explosion"]
	repeat(40){
			with instance_create(x,y,Dust) {motion_set(random(359),random(4))}
	}
}
repeat(4){
	with instance_create(x+lengthdir_x(22,ang),y+lengthdir_y(22,ang),SmallExplosion){
		sprite_index = global.sprBlueExplosion
		hitid = [sprite_index, "Small
		Blue Explosion"]
		repeat(20){
			with instance_create(x,y,Dust){motion_set(random(359),random(4))}
		}
	}
	ang += 360/8
	repeat(10)
	{
	with instance_create(x+lengthdir_x(5,ang), y+lengthdir_x(5,ang), Flame){
		image_xscale *= .75
		image_yscale = image_xscale
		sprite_index = sprFireLilHunter
		motion_add(other.ang+random_range(-2,2),random_range(1,6))
		team = other.team
	}
}
	ang += 360/8
}
sound_play(sndNukeExplosion)

#define rocket_draw
if timer <= 0{draw_sprite_ext(global.sprSmartNukeFlame,fimage_index*current_time_scale,x,y,.75,.75,direction,c_white,1)}
if friction != 0 && instance_exists(enemy)
{
	var closeboy = instance_nearest(mouse_x[creator.index],mouse_y[creator.index],enemy)
	var _x = closeboy.x;
	var _y = closeboy.y;
	aimoffset /= 1.3
	depth = -3
	if !collision_line(x,y,_x,_y,Wall,0,0){
		draw_sprite_ext(global.sprSmartAim,image_index,closeboy.bbox_left-aimoffset,closeboy.bbox_top-aimoffset,1,1,0,c_white,0.2+(60-aimoffset)/60)
		draw_sprite_ext(global.sprSmartAim,image_index,closeboy.bbox_left-aimoffset,closeboy.bbox_bottom+aimoffset,1,1,90,c_white,0.2+(60-aimoffset)/60)
		draw_sprite_ext(global.sprSmartAim,image_index,closeboy.bbox_right+aimoffset,closeboy.bbox_top-aimoffset,1,1,270,c_white,0.2+(60-aimoffset)/60)
		draw_sprite_ext(global.sprSmartAim,image_index,closeboy.bbox_right+aimoffset,closeboy.bbox_bottom+aimoffset,1,1,180,c_white,0.2+(60-aimoffset)/60)
	}
}
draw_self()

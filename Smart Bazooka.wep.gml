#define init
global.sprSmartBazooka = sprite_add_weapon("Hot Bazooka.png", 8, 3);
global.sprBlueExplosion = sprite_add("Blue Explosion_strip9.png",9,24,24)
global.sprSmallBlueExplosion = sprite_add("Small Blue Explosion_strip7.png",7,12,12)
global.sprSmartRocketFlame = sprite_add("smart rocket flame.png",3,24,6)
global.sprSmartRocket = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAAsAAAAGCAYAAAAVMmT4AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABHSURBVChTY4CC/1BMEIAV+nnHwjTgwwz/dbXN/kuJq/0X9F7zX77oP5yGYRAfQzG3YQFYAkbDMIgPVwzCxDoDBFA42AEDAwCBKEMDhOCIHwAAAABJRU5ErkJgggAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",0, -2, 3);
#define weapon_name
return "SMART BAZOOKA";

#define weapon_sprt
return global.sprSmartBazooka;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 20;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 9;

#define weapon_text
return "WHAT DO THESE ROCKETS THINK?";

#define weapon_fire
weapon_post(6,-3,3)
sound_play(sndGrenade)
sound_play_pitch(sndSmartgun,random_range(1.2,1.3))
with instance_create(x,y,CustomProjectile){
	creator = other
	team = other.team
	motion_set(other.gunangle, 2)
	fimage_index = 0
	timer = 18
	sprite_index = global.sprSmartRocket
	image_angle = direction
	on_step = script_ref_create(rocket_step)
	on_destroy = script_ref_create(rocket_destroy)
	on_draw = rocket_draw
}

#define rocket_step
if timer >= 0 {
	timer -= 1;
	speed = 2
	with instance_create(x,y,Flame){
		team = other.team
		sprite_index = sprFireLilHunter
		image_speed = random_range(.8,1)
		image_xscale = .5
		image_yscale = .5
	}
}
if timer = 0 {
	sound_play(sndRocket)
	sound_play(sndRocketFly)
	repeat(7){
		instance_create(x -hspeed +random_range(-30,30),y - vspeed +random_range(-30,30),Smoke)
	}
	instance_create(x,y,AssassinNotice)
}
if timer <= 0 {
	if fimage_index < 2{fimage_index += .5}
	else
	{
		fimage_index = 0
	}
	with instance_create(x,y,Flame){
		team = other.team
		sprite_index = sprFireLilHunter
		image_speed = random_range(.8,1)
	}
	var closeboy = instance_nearest(x,y,enemy)
	if instance_exists(enemy) && collision_line(x,y, closeboy.x, closeboy.y, Wall, 0,0) < 0{
		motion_add(point_direction(x,y, closeboy.x, closeboy.y),1.33)
		image_angle = direction
	}
	speed = 9
}

#define rocket_destroy
with instance_create(x ,y, Explosion){
	sprite_index = global.sprBlueExplosion
	hitid = [sprite_index,"Blue Explosion"]
}
repeat(3){
	with instance_create(x, y, SmallExplosion){
		sprite_index = global.sprSmallBlueExplosion
		hitid = [sprite_index,"Small Blue
		Explosion"]
	}
}

#define rocket_draw
if timer <= 0{draw_sprite_ext(global.sprSmartRocketFlame,fimage_index,x,y,.75,.75,direction,c_white,1)}
draw_self()

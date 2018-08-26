#define init
global.sprSmartBazooka 		   = sprite_add_weapon("sprites/Hot Bazooka.png", 18, 5);
global.sprBlueExplosion 		 = sprite_add("sprites/projectiles/Blue Explosion_strip9.png",9,24,24)
global.sprSmallBlueExplosion = sprite_add("sprites/projectiles/Small Blue Explosion_strip7.png",7,12,12)
global.sprSmartRocketFlame   = sprite_add("sprites/projectiles/smart rocket flame.png",3,24,6)
global.sprSmartRocket 		   = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAAsAAAAGCAYAAAAVMmT4AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABHSURBVChTY4CC/1BMEIAV+nnHwjTgwwz/dbXN/kuJq/0X9F7zX77oP5yGYRAfQzG3YQFYAkbDMIgPVwzCxDoDBFA42AEDAwCBKEMDhOCIHwAAAABJRU5ErkJgggAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",0, -2, 3);
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
return 10;

#define weapon_text
return "WHAT DO ROCKETS THINK ABOUT?";

#define weapon_fire
weapon_post(7,-20,4)
sound_play_pitch(sndRocket,random_range(.6,.8))
sound_play_pitch(sndExplosionS,random_range(.6,.8))
sound_play_pitch(sndSmartgun,random_range(.4,.6))
sound_play_pitch(sndTurretFire,random_range(.6,.8))
with instance_create(x,y,CustomProjectile){
	creator = other
	team = other.team
	sound_play_pitch(sndRocketFly,random_range(.6,.8))
	motion_set(other.gunangle+random_range(-8,8)*other.accuracy,0)
	friction = -.4
	fimage_index = 0
	timer = 0
	damage = 5
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
	if instance_exists(enemy) && collision_line(x,y, closeboy.x, closeboy.y, Wall, 0,0) < 0 && point_distance(x,y,closeboy.x,closeboy.y) <= 60{
		motion_add(point_direction(x,y, closeboy.x, closeboy.y),3)
		motion_add(direction,2)
		image_angle = direction
	}
}
if speed > 12 speed = 12

#define rocket_destroy
sound_play(sndExplosion)
sleep(20)
view_shake_at(x,y,12)
with instance_create(x ,y, Explosion){
	sprite_index = global.sprBlueExplosion
	hitid = [sprite_index,"Blue Explosion"]
}
repeat(1){
	with instance_create(x, y, SmallExplosion){
		sprite_index = global.sprSmallBlueExplosion
		hitid = [sprite_index,"Small Blue
		Explosion"]
	}
}

#define rocket_draw
if timer <= 0{draw_sprite_ext(global.sprSmartRocketFlame,fimage_index,x,y,.75,.75,direction,c_white,1)}
draw_self()

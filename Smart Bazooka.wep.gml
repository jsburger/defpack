#define init
global.sprSmartBazooka 		   = sprite_add_weapon("sprites/Hot Bazooka.png", 14, 4);
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
return 17;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 10;

#define weapon_text
return "WHAT DO ROCKETS THINK ABOUT?";

#define weapon_fire
weapon_post(15,-20,4)
sound_play_pitch(sndRocket,random_range(.6,.8))
sound_play_pitch(sndExplosionS,random_range(.6,.8))
sound_play_pitch(sndSmartgun,random_range(.6,.8))
sound_play_pitch(sndTurretFire,random_range(.6,.8))
with instance_create(x,y,CustomProjectile){
	creator = other
	team = other.team
	sound_play_pitch(sndRocketFly,random_range(1.2,1.4))
	motion_set(other.gunangle+random_range(-8,8)*other.accuracy,5)
	friction = -.4
	timer = 5
	damage = 10
	sprite_index = global.sprSmartRocket
	image_angle = direction
	on_step = script_ref_create(rocket_step)
	on_destroy = script_ref_create(rocket_destroy)
	on_draw = rocket_draw
}

#define rocket_step
if timer > 0{
    timer -= current_time_scale
}
if timer <= 0 {
    var closeboy;
    if mod_exists("mod","defpack tools") closeboy = mod_script_call("mod","defpack tools","instance_nearest_matching_ne",x,y,hitme,"team",team)
	else closeboy = instance_nearest(x,y,enemy)
	if instance_exists(closeboy) && collision_line(xprevious,yprevious, closeboy.x, closeboy.y, Wall, 0,0) < 0{
	    var num = 45/2
		direction += angle_difference(floor(point_direction(x,y,closeboy.x,closeboy.y)/num)*num, direction)/3*current_time_scale
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
repeat(3){
	with instance_create(x, y, SmallExplosion){
		sprite_index = global.sprSmallBlueExplosion
		hitid = [sprite_index,"Small Blue
		Explosion"]
	}
}

#define rocket_draw
if timer <= 0{draw_sprite_ext(global.sprSmartRocketFlame,current_frame * .4,x,y,1,1,direction,c_white,1)}
draw_self()

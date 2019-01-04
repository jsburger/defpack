#define init
global.sprSonicLauncher = sprite_add_weapon("sprites/sprSonicLauncher.png", 2, 2);
global.sprSonicNade = sprite_add("sprites/projectiles/Sonic Nade.png",1,2.5,2.5);
#define weapon_name
return "SONIC LAUNCHER"

#define weapon_sprt
return global.sprSonicLauncher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 19;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 5;

#define weapon_text
return "340 KM/H";

#define weapon_fire
with instance_create(x+lengthdir_x(3,gunangle),y+lengthdir_y(3,gunangle),CustomProjectile)
{
	sprite_index = global.sprSonicNade
	team = other.team
	creator = other
	friction = 0.5
	damage = 5
	force = 5
	bounce = 2
	typ = 1
	anglefac = choose(1,-1)
	dt = 4
	if other.object_index = Player{
		var _x = mouse_x[other.index]+random_range(-16,16)*other.accuracy;
		var _y = mouse_y[other.index]+random_range(-16,16)*other.accuracy;
		motion_add(point_direction(x,y,_x,_y),max(sqrt(point_distance(_x,_y,x,y)),10,sqrt(point_distance(_x,_y,x,y))))
	}else{
		motion_add(other.gunangle,10)
	}
	sound_play_pitch(sndHyperLauncher,1.3+(speed-10)/20)
	on_step = script_ref_create(sonic_launcher_step)
	on_wall = nothing
	on_destroy = script_ref_create(sonic_launcher_destroy)
}
sound_play_pitch(sndHeavyNader,1.8)
sound_play_pitch(sndNothingFire,.7)
weapon_post(6,-6,4)

#define nothing

#define sonic_launcher_step
if dt > -1 dt--
if dt = 0 repeat(4)with instance_create(x,y,Dust){motion_add(random(359),random_range(0,2))}
image_angle += anglefac * speed/1.5 * current_time_scale
if place_meeting(x + hspeed,y,Wall){
	instance_create(x,y,Dust)
	hspeed *= -1
	bounce -= 1
	sound_play_pitch(sndBouncerBounce,random_range(1.6,1.8))
}
if place_meeting(x,y +vspeed,Wall){
	instance_create(x,y,Dust)
	vspeed *= -1
	bounce -= 1
	sound_play_pitch(sndBouncerBounce,random_range(1.6,1.8))
}
if place_meeting(x +hspeed,y +vspeed,Wall){
	instance_create(x,y,Dust)
	vspeed *= -1
	hspeed *= -1
	bounce -= 1
	sound_play_pitch(sndBouncerBounce,random_range(1.6,1.8))
}
if speed <= 0 || bounce <= 0
{
	instance_destroy()
}

#define sonic_launcher_destroy
with mod_script_call("mod","defpack tools","create_sonic_explosion",x,y)
{
	var scalefac = random_range(0.6,0.75);
	image_xscale = scalefac
	image_yscale = scalefac
	damage = 11
	image_speed = 0.75
	team = other.team
	creator = other.creator
	sound_play(sndExplosion)
	repeat(round(scalefac*10)){ with instance_create(x,y,Dust) {motion_add(random(360),3)}}
}

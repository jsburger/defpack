#define init
global.sprSonicLauncher = sprite_add_weapon("Sonic Launcher.png", 2, 2);
global.sprSonicNade = sprite_add("Sonic Nade.png",1,2.5,2.5);
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
return 7;

#define weapon_text
return "340 KM/H";

#define weapon_fire
with instance_create(x+lengthdir_x(3,gunangle),y+lengthdir_y(3,gunangle),CustomProjectile)
{
	sprite_index = global.sprSonicNade
	team = other.team
	creator = other
	friction = 0.5
	bounce = 2
	typ = 1
	anglefac = choose(1,-1)
	dt = 4
	if other.object_index = Player{
		var _x = mouse_x[other.index]+random_range(-16,16);
		var _y = mouse_y[other.index]+random_range(-16,16);
		motion_add(point_direction(x,y,_x,_y),sqrt(point_distance(_x,_y,x,y)))
	}else{
		motion_add(other.gunangle,10)
	}
	on_step = script_ref_create(sonic_launcher_step)
	on_wall = nothing
	on_destroy = script_ref_create(sonic_launcher_destroy)
}
sound_play(sndHyperLauncher)
weapon_post(5,-6,1)

#define nothing

#define sonic_launcher_step
if dt > -1 dt--
if dt = 0 repeat(4)with instance_create(x,y,Dust){motion_add(random(359),random_range(0,2))}
image_angle += anglefac * speed/1.5
if place_meeting(x + hspeed,y,Wall){
	hspeed *= -1
	bounce -= 1
}
if place_meeting(x,y +vspeed,Wall){
	vspeed *= -1
	bounce -= 1
}
if speed <= 0 || place_meeting(x,y,hitme) || bounce <= 0
{
	instance_destroy()
}

#define sonic_launcher_destroy
with mod_script_call("mod","defpack tools","create_sonic_explosion",x,y)
{
	var scalefac = random_range(0.6,0.75);
	image_xscale = scalefac
	image_yscale = scalefac
	damage = 15
	image_speed = 0.7
	team = other.team
	creator = other.creator
	sound_play(sndExplosion)
	repeat(round(scalefac*10)){ with instance_create(x,y,Dust) {motion_add(random(360),3)}}
}

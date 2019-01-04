#define init
global.sprAssaultSonicLauncher = sprite_add_weapon("sprites/sprAssaultSonicLauncher.png", 4, 1);
global.sprTripleSonicNade = sprite_add("sprites/projectiles/Triple Sonic Nade.png",1,2.5,2.5);
#define weapon_name
return "ASSAULT SONIC LAUNCHER"

#define weapon_sprt
return global.sprAssaultSonicLauncher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 34;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 9;

#define weapon_text
return "340 KM/H";

#define weapon_fire

repeat(3)
if instance_exists(self){
	with instance_create(x,y,CustomProjectile)
	{
		move_contact_solid(other.gunangle,6)
		sprite_index = global.sprTripleSonicNade
		team = other.team
		creator = other
		friction = 0.5
		damage = 6
		force = 5
		bounce = 3
		typ = 1
		dt = 4
		anglefac = choose(1,-1)
		if other.object_index = Player{
			var _x = mouse_x[other.index]+random_range(-22,22)*other.accuracy;
			var _y = mouse_y[other.index]+random_range(-22,22)*other.accuracy;
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
	weapon_post(7,-6,7)
	wait(4)
}

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
	scalefac = random_range(0.6,0.75)
	image_xscale = scalefac
	image_yscale = scalefac
	damage = 10
	image_speed = 0.75
	team = other.team
	creator = other.creator
	sound_play(sndExplosion)
	repeat(round(scalefac*10)){ with instance_create(x,y,Dust) {motion_add(random(360),3)}}
}
repeat(3)
{
	with mod_script_call("mod", "defpack tools", "create_sonic_explosion", x+random_range(-20,20),y+random_range(-20,20))
	{

		scalefac = random_range(0.24,0.4)
		image_xscale = scalefac
		image_yscale = scalefac
		damage = 10
		image_speed = 0.82
		team = other.team
		creator = other.creator
		repeat(round(scalefac*10)){ with instance_create(x,y,Dust) {motion_add(random(360),3)}}
	}
}

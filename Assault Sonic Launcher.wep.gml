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
return 3;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 13;

#define weapon_text
return "340 KM/H";

#define weapon_fire

repeat(3)
if instance_exists(self){
	with instance_create(x+lengthdir_x(6,gunangle),y+lengthdir_y(6,gunangle),CustomProjectile)
	{
		sprite_index = global.sprTripleSonicNade
		team = other.team
		creator = other
		friction = 0.5
		bounce = 3
		typ = 1
		dt = 4
		anglefac = choose(1,-1)
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
	sound_play_pitch(sndHyperLauncher,1.3+point_distance(_x,_y,x,y)/1000)
	sound_play_pitch(sndHeavyNader,1.8)
	sound_play_pitch(sndNothingFire,.7)
	weapon_post(7,-6,7)
	wait(4)
}

#define nothing

#define sonic_launcher_step
if dt > -1 dt--
if dt = 0 repeat(4)with instance_create(x,y,Dust){motion_add(random(359),random_range(0,2))}
image_angle += anglefac * speed/1.5
if place_meeting(x + hspeed,y,Wall){
	hspeed *= -1
	bounce -= 1
	sound_play_pitch(sndBouncerBounce,random_range(1.6,1.8))
}
if place_meeting(x,y +vspeed,Wall){
	vspeed *= -1
	bounce -= 1
}
if speed <= 0 || place_meeting(x,y,enemy) || bounce <= 0
{
	instance_destroy()
}

#define sonic_launcher_destroy
with mod_script_call("mod","defpack tools","create_sonic_explosion",x,y)
{
	scalefac = random_range(0.6,0.75)
	image_xscale = scalefac
	image_yscale = scalefac
	damage = 11
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
		damage = 9
		image_speed = 0.82
		team = other.team
		creator = other.creator
		repeat(round(scalefac*10)){ with instance_create(x,y,Dust) {motion_add(random(360),3)}}
	}
}

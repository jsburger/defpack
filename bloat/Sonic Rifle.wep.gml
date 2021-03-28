#define init
global.sprSonicLauncher = sprite_add_weapon("../sprites/weapons/sprGrenadeRifle.png", 2, 2);
global.sprSonicStreak   = sprite_add("../sprites/projectiles/sprSonicStreak.png",6,8,32);
global.sprSonicNade     = sprite_add("../sprites/projectiles/sprTripleSonicGrenade.png",1,2,2);
#define weapon_name
return "SONIC RIFLE"

#define weapon_sprt
return global.sprSonicLauncher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 7;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 5;

#define weapon_text
return "SHATTER THEIR EARS";

#define weapon_fire
	var _e = crown_current = crwn_death ? 1 : 0;
	repeat(3 + _e) with instance_create(x+lengthdir_x(3,gunangle),y+lengthdir_y(3,gunangle),CustomProjectile){
		sprite_index = global.sprSonicNade
		team = other.team
		creator = other
		friction = .5 * random_range(.9, 1)
		damage = 5
		lifetime = 15 + irandom(2)
		force = 8
		bounce = 3
		typ = 1
		anglefac = choose(1,-1)
		dt = 4
		if other.object_index = Player{
			var _x = mouse_x[other.index];
			var _y = mouse_y[other.index];
			motion_add(point_direction(x,y,_x,_y) + random_range(-4, 4) * creator.accuracy,max(sqrt(point_distance(_x,_y,x,y)),irandom_range(9, 11)))
		}else{
			motion_add(other.gunangle,10)
		}
		sound_play_pitch(sndHyperLauncher,1.7+(speed-10)/20)
		on_step    = sonic_launcher_step
		on_wall    = sonic_wall
		on_destroy = sonic_launcher_destroy
		wait(1)
		if !instance_exists(self)exit
	}
	sound_play_pitch(sndGrenadeRifle,random_range(3.2, 3.4))
	sound_play_pitch(sndNothingFire,.7)
	weapon_post(6,-6,4)

	#define sonic_wall
		with instance_create(x,y,Dust){sprite_index = sprExtraFeet}
		move_bounce_solid(false)
		bounce -= 1
		sound_play_pitch(sndBouncerBounce,random_range(1.6,1.8))
		with instance_create(x+lengthdir_x(12,direction),y+lengthdir_y(12,direction),AcidStreak){
			sprite_index = global.sprSonicStreak
			image_angle = other.direction - 90
			motion_add(image_angle+90,12)
			friction = 2.1
		}

#define sonic_launcher_step
	if dt > 0 dt -= current_time_scale
	else if dt > -1{
	    dt = -1
		with instance_create(x,y,Dust){
			motion_add(random(359),random_range(0,2))
			sprite_index = sprExtraFeet
		}
	}
	image_angle += anglefac * speed/1.5 * current_time_scale
	if speed <= 0 || bounce <= 0{
		instance_destroy()
		exit
	}
	if lifetime > 0{
		lifetime -= current_time_scale
	}else{
		instance_destroy()
	}

#define sonic_launcher_destroy
	with mod_script_call("mod","defpack tools","create_small_sonic_explosion",x - lengthdir_x(2, direction),y - lengthdir_y(2, direction)){
		var scalefac = random_range(0.6,0.75);
		image_xscale = scalefac
		image_yscale = scalefac
		image_speed = 0.6
		team = other.team
		creator = other.creator
		sound_play_pitchvol(sndExplosionS, random_range(1.3, 1.6), .6)
		repeat(round(scalefac*5)){ with instance_create(x,y,Dust) {sprite_index = sprExtraFeet; motion_add(random(360),3)}}
	}

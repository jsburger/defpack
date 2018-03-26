#define init
global.sprHotFlareGun = sprite_add_weapon("sprHotFlareGun.png", 3, 4);
global.sprHotFlare = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAAYAAAAGCAYAAADgzO9IAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAZSURBVBhXYwCB/2gAqyAMUFMCmz0MDAwMAF1Bf4E5znJ3AAAAAElFTkSuQmCCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==/2gYDP4zy9eiYJAYWIKl8iwKJiyByygQgHGgmIEBAJ/NLykggvB1AAAAAElFTkSuQmCCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==", 1, 3, 3);
#define weapon_name
return "HOT FLARE GUN";

#define weapon_sprt
return global.sprHotFlareGun;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 19;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapFlame;

#define weapon_area
return 8;

#define weapon_text
return choose("TFW YOU REALLY LIKE A WEAPON
BUT ALMOST NOBODY ELSE DOES
SO YOU ADD A BETTER VERSION OF IT
AND ALL YOU DID
WAS JUST TRIPLING THE DPS
AND MAKE IT AUTOMATIC",
"Whitness my power");


#define weapon_fire
weapon_post(6,-6,4)
sound_play_pitch(sndFlare,.7)
with instance_create(x,y,CustomProjectile){
	sprite_index = global.sprHotFlare
	team = other.team
	creator = other
	motion_set(other.gunangle + random_range(-7,7), 11 + random(2))
	typ = 2
	friction = .3
	bounce = 0
	damage = 15
	on_destroy = script_ref_create(flare_destroy)
	on_step = script_ref_create(flare_step)
}

#define flare_destroy
sound_play(sndFlareExplode)
repeat(35){
	with instance_create(x,y,Flame){
		motion_add(random(360),random_range(5,6))
		team = other.team
		damage = 5
		sprite_index = sprFireLilHunter
	}
}

#define flare_step
if place_meeting(x + hspeed,y,Wall){
	hspeed *= -1
	repeat(irandom_range(2,4)){
		with instance_create(x,y,Flame){
			motion_add(random(360),random_range(5,6))
			team = other.team
			damage = 5
			sprite_index = sprFireLilHunter
			sound_play_pitch(sndBurn,1-.04*other.bounce)
		}
	}
	bounce++
}
if place_meeting(x,y +vspeed,Wall){
	vspeed *= -1
	repeat(irandom_range(2,4)){
		with instance_create(x,y,Flame){
			motion_add(random(360),random_range(5,6))
			team = other.team
			damage = 5
			sprite_index = sprFireLilHunter
			sound_play_pitch(sndBurn,1-.04*other.bounce)
		}
	}
	bounce++
}
repeat(1){
	with instance_create(x,y,Flame){
		team = other.team
		damage = 2
		sprite_index = sprFireLilHunter
	}
}
if bounce>= 7{instance_destroy();exit}
if speed = 0{instance_destroy()}

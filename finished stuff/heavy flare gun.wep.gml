#define init
global.sprHotFlareGun = sprite_add_weapon("sprHotFlareGun.png", 3, 4);
global.sprHotFlare = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAAYAAAAGCAYAAADgzO9IAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAZSURBVBhXYwCB/2gAqyAMUFMCmz0MDAwMAF1Bf4E5znJ3AAAAAElFTkSuQmCCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==/2gYDP4zy9eiYJAYWIKl8iwKJiyByygQgHGgmIEBAJ/NLykggvB1AAAAAElFTkSuQmCCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==", 1, 3, 3);
#define weapon_name
return "HEAVY FLARE GUN";

#define weapon_sprt
return global.sprHotFlareGun;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 28;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapFlame;

#define weapon_area
return 8;

#define weapon_text
return choose("look at me",
"Whitness my power");


#define weapon_fire
weapon_post(6,-6,16)
sound_play_pitch(sndFlare,.7)
with instance_create(x,y,CustomProjectile){
	sprite_index = global.sprHotFlare
	team = other.team
	creator = other
	motion_set(other.gunangle + random_range(-7,7), 11 + random(2))
	typ = 2
	friction = .3
	bounce = 0
	damage = 18
	on_destroy = script_ref_create(flare_destroy)
	on_step = script_ref_create(flare_step)
	on_wall = script_ref_create(flare_wall)
}

#define flare_wall
move_bounce_solid(false)

#define flare_destroy
sound_play_pitch(sndFlareExplode,.8)
sound_play_pitchvol(sndFlareExplode,1,.4)
instance_create(x,y,SmallExplosion)
repeat(12){
var _dir = random(360)
with instance_create(x+lengthdir_x(15,_dir),y+lengthdir_y(15,_dir),SmallExplosion){
		image_xscale = .5
		image_yscale = .5
		damage = 1
		team = other.team
		sound_play_pitchvol(sndExplosionS,2,.3)
		hitid = [sprite_index,"MINI EXPLOSION"]
		motion_add(_dir,random_range(3,4))
	}
}

#define flare_step
if current_frame mod (2/current_time_scale) = 0
with instance_create(x+random_range(-1,1),y+random_range(-1,1),SmallExplosion){
    image_xscale = .5
    image_yscale = .5
    damage = 1
    team = other.team
    sound_play_pitchvol(sndExplosionS,2,.04)
    hitid = [sprite_index,"MINI EXPLOSION"]
}
if bounce>= 7{instance_destroy();exit}
if speed = 0{instance_destroy()}

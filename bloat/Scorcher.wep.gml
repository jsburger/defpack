#define init
global.sprScorcher = sprite_add_weapon("sprites/Scorcher.png", 3, 2);
global.sprScorcherOff = sprite_add_weapon("sprites/Scorcher Off.png", 3, 2);
global.sprUltraFlare = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAAYAAAAGCAYAAADgzO9IAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAZSURBVBhXYwCB/2gAqyAMUFMCmz0MDAwMAF1Bf4E5znJ3AAAAAElFTkSuQmCCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==/2gYDP4zy9eiYJAYWIKl8iwKJiyByygQgHGgmIEBAJ/NLykggvB1AAAAAElFTkSuQmCCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==", 1, 3, 3);

global.UltraFire = sprite_add("Ultra Fire_strip7.png",7,8,8);
#define weapon_name
with(GameCont)
{
	if "rad" in self && rad >= 7 {return global.sprScorcher};
	else {return global.sprScorcherOff};
}

#define weapon_sprt
return global.sprScorcher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 9;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapFlame;

#define weapon_area
return 19;

#define weapon_text
return choose("@rBURN @sTHE WORLD DOWN","LA! LA!","A GAME OF @gTHRONE");

#define weapon_rads
return 7

#define weapon_fire
weapon_post(6,-6,3)
sound_play(sndFlare)
with instance_create(x,y,CustomProjectile){
	sprite_index = global.sprUltraFlare
	team = other.team
	creator = other
	motion_set(other.gunangle + random_range(-7,7), 11 + random(2))
	typ = 2
	friction = .3
	damage = 20
	on_destroy = script_ref_create(flare_destroy)
	on_step = script_ref_create(flare_step)
}

#define flare_destroy
sound_play(sndFlareExplode)
repeat(50){
	with instance_create(x,y,Flame){
		motion_add(random(360),random_range(5,6))
		team = other.team
		damage = 12
		sprite_index = global.UltraFire
	}
}

#define flare_step
if place_meeting(x + hspeed,y,Wall){
	hspeed *= -1
}
if place_meeting(x,y +vspeed,Wall){
	vspeed *= -1
}
repeat(3){
	with instance_create(x,y,Flame){
		team = other.team
		damage = 6
		sprite_index = global.UltraFire
	}
}
if speed = 0{
	instance_destroy()
}

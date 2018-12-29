#define init//This weapon replaces Psy-V
global.Psybird = sprite_add_weapon("sprites/Psybird.png", 4, 4);

#define weapon_name
return "PSYBIRD";

#define weapon_sprt
return global.Psybird;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 20;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 13;

#define weapon_text
return choose("STRAFE FROM","QUETZAL STOMP","@p\|/","K'AW");

#define weapon_fire
with instance_create(x,y,CustomObject)
{
	creator = other.id
	ammo = 5
	time = 0
	team = other.team
	on_step = Psybird_step
}

#define Psybird_step
if instance_exists(creator)
{
	gunangle = creator.gunangle
	accuracy = creator.accuracy
	x = creator.x+lengthdir_x(1,gunangle)
	y = creator.y+lengthdir_y(1,gunangle)
time -= current_time_scale
if time <= 0
{
    	with creator weapon_post(6,-5,25)
	sound_play_pitch(sndDoubleShotgun,random_range(.6,.8))
	sound_play_pitch(sndWaveGun,random_range(.6,.8))

	time = 1
		with mod_script_call("mod", "defpack tools", "create_psy_shell",x+lengthdir_x(5,gunangle),y+lengthdir_y(5,gunangle)){
			creator = other
			team = other.team
			motion_set(other.gunangle + random_range(7,16) * other.accuracy,random_range(9,14))
			image_angle = direction
			friction = random_range(.5,.6)
			birdspeed = friction
	    }
		with mod_script_call("mod", "defpack tools", "create_psy_shell",x+lengthdir_x(5,gunangle),y+lengthdir_y(5,gunangle)){
			creator = other
			team = other.team
			motion_set(other.gunangle + random_range(-1,1) * other.accuracy,random_range(7,15))
			image_angle = direction
			friction = random_range(.5,.6)
    	}
		with mod_script_call("mod", "defpack tools", "create_psy_shell",x+lengthdir_x(5,gunangle),y+lengthdir_y(5,gunangle)){
			creator = other
			team = other.team
			motion_set(other.gunangle + random_range(-16,-7) * other.accuracy,random_range(9,14))
			image_angle = direction
			friction = random_range(.5,.6)
			birdspeed = -friction
		 }
	ammo -= 1
}
if ammo = 0
instance_destroy()
}


#define init
global.sprUndulator = sprite_add_weapon("sprites/sprUndulator.png", 7, 3);
global.sprDual = sprite_add("sprites/projectiles/sprDual.png",9,4,4)

#define weapon_name
return "UNDULATOR";

#define weapon_sprt
return global.sprUndulator;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 14;

#define weapon_cost
return 5;

#define weapon_laser_sight
return 1

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 20;

#define weapon_text
return choose("@wWAVE @sOF DESTRUCTION","NO BOB, ONLY WEAVE");

#define weapon_fire
motion_add(gunangle+180,1.7)
repeat(5)
{
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_white)
}
with instance_create(x,y,CustomObject)
{
	creator = other.id
	ammo_origin = 3
	ammo = ammo_origin
	time = 1
	team = other.team
	on_step = Undulator_step
}

#define Undulator_step
sound_play_pitch(sndUltraCrossbow,2.2)
sound_play_pitch(sndHeavyRevoler,2)
sound_play_pitch(sndIcicleBreak,2)
sound_play_pitch(sndComputerBreak,random_range(.8,1.2))
if instance_exists(creator)
{
	gunangle = creator.gunangle
	accuracy = creator.accuracy
	x = creator.x+lengthdir_x(15,gunangle)
	y = creator.y+lengthdir_y(15,gunangle)
	with creator weapon_post(7,-6,16)
time -= current_time_scale
if time = 0
{
	time = 2

	with mod_script_call("mod", "defpack tools", "create_light_bullet",x+lengthdir_x(-10,gunangle),y+lengthdir_y(-10,gunangle)){
	    creator = other.creator
	    team = other.team
	    motion_set(other.gunangle-4*(other.ammo_origin-other.ammo)+random_range(-2,2)*other.accuracy,13+other.ammo)
		image_angle = direction
		damage = 6
	}
	with mod_script_call("mod", "defpack tools", "create_light_bullet",x+lengthdir_x(-10,gunangle),y+lengthdir_y(-10,gunangle)){
	    creator = other.creator
	    team = other.team
	    motion_set(other.gunangle+4*(other.ammo_origin-other.ammo)+random_range(-2,2)*other.accuracy,13+other.ammo)
		image_angle = direction
		damage = 6
	}
	ammo -= 1
}
if ammo = 0
instance_destroy()
wait(3)
}

#define init
global.sprScreecher = sprite_add_weapon("sprites/Screecher.png", 0, 2);

#define weapon_name
return "SCREECHER"

#define weapon_sprt
return global.sprScreecher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 47;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 14;

#define weapon_text
return "AAAAAAAAAAHHHHHHHH";

#define weapon_fire
sound_play(sndDevastator)
sound_play(sndVenuz)
weapon_post(3,-13,0)
with instance_create(x+lengthdir_x(18,gunangle),y+lengthdir_y(18,gunangle),CustomObject)
{
	mask_index = sprGrenade
	team = other.team
	image_xscale = 0.5
	image_yscale = 0.5
	bounce = 2
	motion_add(other.gunangle+random_range(-5,5)*other.accuracy,12)
	on_step = script_ref_create(sonic_launcher_step)
}

#define sonic_launcher_step
repeat(irandom(1))
with mod_script_call("mod","defpack tools","create_sonic_explosion",x+random_range(-32,32),y+random_range(-32,32)){
	var scalefac = random_range(0.2,0.3);
	image_xscale = scalefac
	image_yscale = scalefac
	damage = 3
	shake = 2
	image_speed = random_range(0.6,0.72)
	team = other.team
	repeat(round(scalefac*10)){ with instance_create(x,y,Dust) {motion_add(random(360),3)}}
}
repeat(irandom(2))
with mod_script_call("mod","defpack tools","create_sonic_explosion",x+random_range(-10,10),y+random_range(-10,10)){
	var scalefac = random_range(0.3,0.36);
	image_xscale = scalefac
	image_yscale = scalefac
	damage = 6
	shake = 4
	image_speed = random_range(0.34,0.4)
	team = other.team
	repeat(round(scalefac*10)){ with instance_create(x,y,Dust) {motion_add(random(360),3)}}
}
if place_meeting(x + hspeed,y,Wall){
	hspeed *= -1
	bounce -= 1
}
if place_meeting(x,y +vspeed,Wall){
	vspeed *= -1
	bounce -= 1
}
if speed <= 0 || bounce <= 0
{
	instance_destroy()
}

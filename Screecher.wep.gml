#define init
global.sprScreecher = sprite_add_weapon("sprites/sprScreecher.png", 2, 4);

#define weapon_name
return "SCREECHER"

#define weapon_sprt
return global.sprScreecher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 22;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 14;

#define weapon_melee
return 0;

#define weapon_text
return "MAGIC REFLECTION";

#define weapon_fire
weapon_post(6,0,1)
with mod_script_call("mod","defpack tools","create_sonic_explosion",x+lengthdir_x(16,gunangle),y+lengthdir_y(16,gunangle))
{
	image_xscale = .1
	image_yscale = .1
	damage = 14
	image_speed = 0.75
	team = other.team
	creator = other
}
wait(2)
if !instance_exists(self){exit}
with mod_script_call("mod","defpack tools","create_sonic_explosion",x+lengthdir_x(32,gunangle),y+lengthdir_y(32,gunangle))
{
	image_xscale = .2
	image_yscale = .2
	damage = 10
	image_speed = 0.75
	team = other.team
	creator = other
}
wait(2)
if !instance_exists(self){exit}
with mod_script_call("mod","defpack tools","create_sonic_explosion",x+lengthdir_x(72,gunangle),y+lengthdir_y(72,gunangle))
{
	image_xscale = .5
	image_yscale = .5
	damage = 6
	image_speed = 0.75
	team = other.team
	creator = other
}

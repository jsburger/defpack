#define init
global.sprQuartzLaser = sprite_add_weapon("sprites/sprQuartzLaser.png", 6, 5);

#define weapon_name
return "QUARTZ LASER"
#define weapon_type
return 5
#define weapon_cost
return 1
#define weapon_area
return -1
#define weapon_load
return 1
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return true
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt
return global.sprQuartzLaser
#define weapon_text
return "cool"
#define weapon_fire

with instance_create(x,y,Laser){
	creator = other
	image_angle = creator.gunangle
	team = other.team
	event_perform(ev_alarm,0)
	image_yscale = 2
	ymax = image_yscale
	beam = 1
	with instances_matching(Laser,"beam",1) if creator = other.creator{
		if id != other {instance_destroy()}
	}
}

#define init
global.sprTempestBlade = sprite_add_weapon("sprites/sprTempestBlade.png",-5,7)
global.sprAirSlash 	   = sprite_add("sprites/projectiles/sprAirSlash.png",4,0,24)
global.mskAirSlash     = sprite_add("comboweps/rapiermask.png",3,3,28)
#define weapon_name
return "TEMPEST BLADE"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return -1
#define weapon_load
return 10
#define weapon_swap
return sndSwapSword
#define weapon_auto
return 1
#define weapon_melee
return 1
#define weapon_laser_sight
return 0
#define weapon_fire
if "tempest" not in self {tempest = 1}
tempest = ++tempest mod 3
sound_play_pitch(sndBlackSword,random_range(1.4,1.7))
motion_add(gunangle,2)
if tempest != 3
{
	weapon_post(12,0,5)
	with instance_create(x,y,Slash)
	{
		move_contact_solid(other.gunangle,6*skill_get(13))
		team = other.team
		motion_add(other.gunangle,1)
		sprite_index = global.sprAirSlash
		image_yscale = -other.wepflip
		image_angle = direction
		image_speed = .4
	}
}
else
{

}
//if rapiers != 2{reload+=6}
wepangle*=-1

#define weapon_sprt
return global.sprTempestBlade
#define weapon_text
return choose("A sorcerous @wblade @simbued#with the power of gale-force @wwinds","Can strike from near or far")

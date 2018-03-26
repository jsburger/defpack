#define init
global.sword = sprite_add_weapon("rapier.png",0,3)
global.slash = sprite_add("rapierslash.png",3,3,28)
global.mask = sprite_add("rapiermask.png",3,3,28)
#define weapon_name
return "RAPIER"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return 1
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
if "rapiers" not in self {rapiers = 0}
rapiers = ++rapiers mod 3
sound_play_gun(sndChickenSword,.2,.8)
motion_add(gunangle,4)
if rapiers != 1{
	wepangle = 20*wepflip
	weapon_post(-5 - 20*skill_get(13),12,0)
	with instance_create(x+lengthdir_x(5+20*skill_get(13),gunangle),y+lengthdir_y(5+20*skill_get(13),gunangle),Slash){
		damage = 6
		team = other.team
		creator = other
		motion_add(other.gunangle,2)
		image_angle = direction -other.wepangle
		sprite_index = global.slash
		image_yscale = other.wepflip
		mask_index = global.mask
	}
}else{
	wepangle = .1
	weapon_post(-10 - 20*skill_get(13),15,2)
	move_contact_solid(gunangle,6)
	with instance_create(x+lengthdir_x(5+20*skill_get(13),gunangle),y+lengthdir_y(5+20*skill_get(13),gunangle),Shank){
		damage = 8
		team = other.team
		creator = other
		motion_add(other.gunangle,5)
		image_angle = direction
	}
	reload+=4
}
wepangle*=-1
#define weapon_sprt
return global.sword
#define weapon_text
return "hon hon hon"
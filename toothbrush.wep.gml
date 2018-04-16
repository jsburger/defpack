#define init
global.brush = sprite_add_weapon("sprites/toothbrush.png",0,0)
#define weapon_name
return "TOOTHBRUSH"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
if !irandom(2) return 1;
else return -1;
#define weapon_load
return 10
#define weapon_swap
return sndSwapHammer
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
sound_play(sndScrewdriver)
weapon_post(-6 - (20*skill_get(13)),6,0)
with instance_create(x+lengthdir_x(6+(20*skill_get(13)),gunangle),y+lengthdir_y(6+(20*skill_get(13)),gunangle),Shank){
	sprite_index = mskNone
	mask_index = global.brush
	creator = other
	team = other.team
	image_angle = other.gunangle
}
#define weapon_sprt
return global.brush
#define weapon_text
return "no toothpaste"

#define init
global.brush[0] = sprite_add_weapon("sprites/toothbrush.png",0,0)
global.brush[1] = sprite_add_weapon("sprites/greentoothbrush.png",0,0)
global.brush[2] = sprite_add_weapon("sprites/redtoothbrush.png",0,0)
global.brush[3] = sprite_add_weapon("sprites/purpletoothbrush.png",0,0)
global.brush[4] = sprite_add_weapon("sprites/bluetoothbrush.png",0,0)
global.brush[5] = sprite_add_weapon("sprites/boothtrush.png",0,0)
global.brush[6] = sprite_add_weapon("sprites/yellowtoothbrush.png",0,0)
global.mskbrush = sprite_add_weapon("sprites/mskToothbrushUpg.png",20,0)
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
	canfix = false
	if skill_get(13) mask_index = global.mskbrush else mask_index = global.brush
	creator = other
	team = other.team
	image_angle = other.gunangle
}
#define weapon_sprt
if mod_exists("skill", "prismatic iris") return global.brush[mod_variable_get("skill", "prismatic iris", "color")]
return global.brush[0]
#define weapon_text
return "no toothpaste"

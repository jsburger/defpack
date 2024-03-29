#define init
global.brush			  = sprite_add_weapon("sprites/weapons/sprToothbrush.png", 0, 0);
global.mskbrush 		  = sprite_add_weapon("sprites/projectiles/mskToothbrush.png", 20, 0);
global.sprToothbrushShank = sprite_add("sprites/projectiles/sprHexNeedleShank.png", 4, -6, 4);

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
	direction = image_angle
	with instance_create(x, y, Wind){
		sprite_index = global.sprToothbrushShank;
		image_angle = other.image_angle;
		depth -= 1;
	}
}
#define weapon_sprt
if (mod_exists("skill", "prismaticiris") && skill_get("prismaticiris") > 0) return mod_script_call("skill", mod_variable_get("skill", "prismaticiris", "color"), "skill_toothbrush_sprite")
return global.brush
#define weapon_text
return "no toothpaste"
#define nts_weapon_examine
return{
	"eyes" : "But you dont have any use for this, or do you? ",
	"plant": "Keep them pearly whites nice and shiny. ",
    "d": "Keep your enemies clean. ",
}

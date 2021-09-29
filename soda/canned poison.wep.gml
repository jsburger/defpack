#define init
global.sprCannedPosion = sprite_add_weapon("../sprites/weapons/sprCannedPoison.png",-2,1)
#define weapon_sprt
return global.sprCannedPosion
#define weapon_name
return "CANNED POISON"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return -1
#define soda_avail
return mod_exists("mod", "yokinLightning")
#define weapon_load
return 0
#define weapon_swap
return mod_script_call_nc("mod", "sodaeffect", "sound_play_soda")
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
mod_script_call_self("mod", "sodaeffect", "sound_play_drink")
mod_script_call_self("mod", "sodaeffect", "soda_swap")

sound_play_pitchvol(sndMutRhinoSkin, 1.5, .02)
poisoned = 120;
my_health = min(my_health + 1 * round(skill_get(mut_second_stomach)), maxhealth);

with mod_script_call("mod", "sodaeffect", "drink", x, y){
	subtext = "OOPS!"
}

#define weapon_text
return choose("Frogs favourite", "TASTES LIKE SEWAGE");

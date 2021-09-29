#define init
global.sprCocaineumCola = sprite_add_weapon("../sprites/weapons/sprCocaineumCola.png",-2,1)
mod_script_call("mod", "defpack tools", "add_soda", mod_current)
#define weapon_sprt
return global.sprCocaineumCola
#define weapon_name
return "COCAINEUM COLA"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return -1
#define soda_avail
return mod_exists("mod", "metamorphosis");
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

sound_play_pitchvol(sndMutPatience, 1.5, .1)
if infammo >= 0 infammo += 240;
mod_script_call("mod", "metamorphosis", "haste", 240, 0.4);
my_health = min(my_health + 1 * round(skill_get(mut_second_stomach)), maxhealth);
with mod_script_call("mod", "sodaeffect", "drink", x, y){
	subtext = "GET IN THERE!"
}

#define weapon_text
return choose("GO GO GO GO", "TASTES LIKE SUGAR")

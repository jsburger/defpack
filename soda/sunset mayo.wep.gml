#define init
global.sprSunsetMayo = sprite_add_weapon("../sprites/weapons/sprSunsetMayo.png",-2,1)
mod_script_call("mod", "defpack tools", "add_soda", mod_current)
#define weapon_sprt
return global.sprSunsetMayo
#define weapon_name
return "SUNSET MAYO"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return -1
#define soda_avail
return skill_get(mut_boiling_veins) > 0
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

sound_play_pitchvol(sndMutBoilingVeins, 1.5, .1)
boilcap++;
my_health = min(my_health + 1 * round(skill_get(mut_second_stomach)), maxhealth);
with mod_script_call("mod", "sodaeffect", "drink", x, y){
	subtext = "FIRE RESISTANCE UP!"
}

#define weapon_text
return choose("CAREFUL, @rITS SPICY@s", "TASTES LIKE A CREAMY DAWN")

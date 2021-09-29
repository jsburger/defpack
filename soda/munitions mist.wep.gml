#define init
global.sprMunitionsMist = sprite_add_weapon("../sprites/weapons/sprMunitionsMist.png",-2,1)
mod_script_call("mod", "defpack tools", "add_soda", mod_current)
#define weapon_sprt
return global.sprMunitionsMist
#define weapon_name
return "MUNITIONS MIST"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return -1
#define soda_avail
return 1
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

sound_play_pitchvol(sndMutBackMuscle, 1.5, .1)
typ_ammo[1] += 2 //more boolet
my_health = min(my_health + 1 * round(skill_get(mut_second_stomach)), maxhealth);
for (var i = 1; i < array_length(ammo); i++){
	typ_ammo[i]++
}
with mod_script_call("mod", "sodaeffect", "drink", x, y){
	subtext = "AMMO GAIN UP!"
}

#define weapon_text
return choose("A WONDERFUL @yGRAPEFRUIT-BULLET@s BLEND", "TASTES LIKE GRAPESHOTS")

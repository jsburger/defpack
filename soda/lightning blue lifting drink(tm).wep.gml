#define init
global.sprLightningBlueLiftingDrink = sprite_add_weapon("../sprites/weapons/sprLightningBlueLiftingDrink(TM).png",-2,1)
mod_script_call("mod", "defpack tools", "add_soda", mod_current)
#define weapon_sprt
return global.sprLightningBlueLiftingDrink
#define weapon_name
return "LIGHTNING BLUE LIFTING DRINK(TM)"
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

sound_play_pitchvol(sndFishUltraB, 1.5, .1)
if infammo >= 0 infammo += 30 * 12
with mod_script_call("mod", "sodaeffect", "drink", x, y){
	text = "INFINITE AMMO!"
	subtext = "GO! GO! GO!"
}

#define weapon_text
return "HIGH IN @yOMEGA-3"

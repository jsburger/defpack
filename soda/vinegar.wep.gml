#define init
global.sprVinegar = sprite_add_weapon("../sprites/weapons/sprVinegar.png",-2,1)
mod_script_call("mod", "defpack tools", "add_soda", mod_current)
#define weapon_sprt
return global.sprVinegar
#define weapon_name
return "VINEGAR"
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

sound_play_pitchvol(sndMutEagleEyes, 1.5, .02)
accuracy /= 1.2
with mod_script_call("mod", "sodaeffect", "drink", x, y){
	subtext = "ACCURACY UP!"
}

#define weapon_text
return "YOU'RE @wREALLY@s NOT SUPPOSED TO DRINK THIS"

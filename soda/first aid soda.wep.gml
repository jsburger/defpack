#define init
global.sprFirstAidSoda = sprite_add_weapon("../sprites/weapons/sprFirstAidSoda.png",-2,1)
mod_script_call("mod", "defpack tools", "add_soda", mod_current)
#define weapon_sprt
return global.sprFirstAidSoda
#define weapon_name
return "FIRST AID SODA"
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
sound_play_pitch(sndToxicBoltGas,random_range(2.3,2.4))
sound_play_pitch(sndOasisCrabAttack,random_range(.5,.6))
return -1
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
mod_script_call_self("mod", "sodaeffect", "sound_play_drink")
mod_script_call_self("mod", "sodaeffect", "soda_swap")

sound_play_pitch(sndHealthChest, 1.3)
my_health = maxhealth);

#define weapon_text
return "IN CASE OF @rEMERGENCY@s"

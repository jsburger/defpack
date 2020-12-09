#define init
global.sprCannedPosion = sprite_add_weapon("sprites/weapons/sprCannedPoison.png",-2,1)
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
#define weapon_load
return 0
#define weapon_swap
sound_play_pitch(sndToxicBoltGas, random_range(2.3, 2.4))
sound_play_pitch(sndOasisCrabAttack, random_range(.5, .6))
return -1
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
wep = 0
sound_play_pitch(sndHPPickup, 1.4)
sound_play_pitch(sndOasisCrabAttack, random_range(.6,.8))
sound_play_pitch(sndToxicBoltGas, random_range(1.2,1.4))
sound_play_pitchvol(sndMutRhinoSkin, 1.5, .02)
repeat(7){
	with instance_create(x, y, Bubble){
		image_speed *= 1.6
	}
}
poisoned = 120
wep = bwep
bwep = 0
curse = bcurse
with mod_script_call("mod", "sodaeffect", "drink", x, y){
	subtitle = "OOPS!"
}
reload = max(breload, 10)

#define weapon_text
return "Frogs favourite"

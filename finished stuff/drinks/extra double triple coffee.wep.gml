#define init
with instances_matching(CustomStep,"name","juicegod") instance_destroy()
with script_bind_step(juiceyboy,1){
	persistent = 1
	name = "juicegod"
}
global.sprExtraDoubleTripleCoffee = sprite_add_weapon("sprExtraDoubleTripleCoffee.png",-2,1)
#define weapon_sprt
return global.sprExtraDoubleTripleCoffee
#define weapon_name
return "EXTRA DOUBLE TRIPLE COFFEE"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return -1
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
wep = 0
sound_play_pitch(sndHPPickup,1.4)
sound_play_pitch(sndOasisCrabAttack,random_range(.6,.8))
sound_play_pitch(sndToxicBoltGas,random_range(1.2,1.4))
sound_play_pitchvol(sndMutStress,1.5,.02)
repeat(7)with instance_create(x,y,Bubble){image_speed*=1.6}
if "shootquick" not in self{
	shootquick = 0
}
shootquick += .1
with instance_create(x,y,PopupText){
	target = other.index
	text = "+1 FIRE RATE"
}
wep = bwep;bwep = 0
#define weapon_text
return "drinkz on me boiz"

#define juiceyboy
with instances_matching_gt(Player,"shootquick",0){
	if reload > 0 { reload -= shootquick }
	if race = "steroids" && breload > 0{ breload -= shootquick }
}

#define step
if instance_exists(WepPickup){with WepPickup{if wep = 0{instance_destroy()}}}

#define init
global.sprVinegar = sprite_add_weapon("sprVinegar.png",-2,1)
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
#define weapon_load
return 0
#define weapon_swap
return sndSwapGold
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
wep = 0
sound_play(sndHPPickup)
accuracy /= 2
with instance_create(x,y,PopupText){
	target = other.index
	text = "+ACCURACY"
}
wep = bwep;bwep = 0
#define weapon_text
return "you're not supposed to drink these"

#define step
if instance_exists(WepPickup){with WepPickup{if wep = 0{instance_destroy()}}}

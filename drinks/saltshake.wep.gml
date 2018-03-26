#define init
global.sprSaltshake = sprite_add_weapon("sprSaltshake.png",-2,1)
#define weapon_sprt
return global.sprSaltshake
#define weapon_name
return "SALTSHAKE"
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
maxhealth++
my_health++
with instance_create(x,y,PopupText){
	target = other.index
	text = "+1 MAX HEALTH"
}
wep = bwep;bwep = 0
#define weapon_text
return "Tastes like grapes"

#define step
if instance_exists(WepPickup){with WepPickup{if wep = 0{instance_destroy()}}}

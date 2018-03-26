#define init
global.sprLightningBlueLiftingDrink = sprite_add_weapon("sprLightningBlueLiftingDrink(TM).png",-2,1)
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
infammo += 30 * 4
with instance_create(x,y,PopupText){
	target = other.index
	text = "INFINITE AMMO"
}
wep = bwep;bwep = 0
#define weapon_text
return "finely aged police leaves"

#define step
if instance_exists(WepPickup){with WepPickup{if wep = 0{instance_destroy()}}}

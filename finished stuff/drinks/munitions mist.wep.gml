#define init
global.sprMunitionsMist = sprite_add_weapon("sprMunitionsMist.png",-2,1)
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
typ_ammo[1]+=2 //more boolet
for (var i=1;i<=5;i++){
	typ_ammo[i]++
}
with instance_create(x,y,PopupText){
	target = other.index
	text = "+AMMO GAIN"
}
wep = bwep;bwep = 0
#define weapon_text
return "smells a bit off"

#define step
if instance_exists(WepPickup){with WepPickup{if wep = 0{instance_destroy()}}}

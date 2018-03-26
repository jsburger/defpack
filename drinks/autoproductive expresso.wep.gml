#define init
global.sprAutoproductiveExpresso = sprite_add_weapon("sprAutoproductiveExpresso.png",-2,1)
#define weapon_sprt
return global.sprAutoproductiveExpresso
#define weapon_name
return "AUTOPRODUCTIVE EXPRESSO"
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
maxspeed += .25
with instance_create(x,y,PopupText){
	target = other.index
	text = "+MAX SPEED"
}
wep = bwep;bwep = 0
#define weapon_text
return "a rare substance, usually greener"

#define step
if instance_exists(WepPickup){with WepPickup{if wep = 0{instance_destroy()}}}

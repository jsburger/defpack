#define init
global.sprKunai = sprite_add_weapon("sprKunai.png",-2,1)
#define weapon_name
return "KUNAI"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return -1
#define weapon_load
return 1
#define weapon_swap
return sndSwapSword
#define weapon_auto
return 0
#define weapon_melee
return 1
#define weapon_laser_sight
return 0
#define weapon_sprt
return global.sprKunai
#define weapon_text
return "NO CHAIN"
#define weapon_fire
with instance_create(x,y,ThrownWep)
{
  sprite_index = global.sprKunai
  speed =16
  wep = other.wep
  creator = other
  team = other.team
  pet = other.index
  direction = other.gunangle
  other.wep = other.bwep
  other.bwep = 0
}

#define step
if instance_exists(WepPickup){with WepPickup{if wep = 0{instance_destroy()}}}

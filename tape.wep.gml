#define init
global.sprTape = sprite_add_weapon("sprites/sprTape.png", 4, 4);

#define weapon_name
return "TAPE"

#define weapon_sprt
return global.sprTape;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 0;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return choose("ENGINEERING AT ITS BEST");

#define weapon_fire
mod_script_call("mod","merging","wep_combine",wep,bwep)

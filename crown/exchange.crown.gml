// Define Sprites
#define init
	global.spr_idle = sprite_add("../sprites/crown/sprCrownIdle.png",1,8,8);
	global.spr_walk = sprite_add("../sprites/crown/sprCrownWalk.png",6,8,8);
	global.spr_icon = sprite_add("../sprites/crown/sprCrownSelect.png",1,12,16);

	global.exchange_ban_list = [wep_super_disc_gun, wep_golden_nuke_launcher, wep_golden_disc_gun, "wondersword", "mega hammer", "rapier", "infinipistol", "push piston", "flak canon", "spam disc gun"];

  for(var _i = 0; _i < maxp; _i++){
		global.nextwep[_i, 0] = 0; // weapon index
		global.nextwep[_i, 1] = 0; // fancy var for animating the hud
		global.killammo = irandom_range(3, 5 + round(GameCont.hard /3))
		global.nextwep[_i, 2] = global.killammo; // how many weapons have been swapped
	}

#define store_wep()
	for(var _i = 0; _i < maxp; _i++){
		global.nextwep[_i, 0] = get_wep();
		global.nextwep[_i, 2] = 0;
	}

#define game_start
	store_wep()
	global.killammo = irandom_range(3, 5 + round(GameCont.hard /3))
	for(var _i = 0; _i < maxp; _i++){
		global.nextwep[_i, 2] = global.killammo; // how many weapons have been swapped
	}

#define crown_object
	spr_idle = global.spr_idle;
	spr_walk = global.spr_walk;

#define crown_button
	sprite_index = global.spr_icon;

#define step
with AmmoChest{
	instance_create(x, y, WeaponChest);
	instance_delete(self);
}
with AmmoChestMystery{
	instance_create(x, y, WeaponChest);
	instance_delete(self);
}
with AmmoPickup{
	instance_delete(self);
}

for(var _i = 0; _i < maxp; _i++){
	with _i{
		var _j = 0;
		repeat(5)
		{
			_j++
			ammo[_j] = 1/0 // set to infinity
		}
	}
}

with instances_matching_ne(Player, "driving", 1)
{
	//detect run start
	if "HasEx" not in self
	{
		var i = 0;
		repeat(5)
		{
			i++
			//typ_ammo[i] = ceil(typ_ammo[i]/4)
			ammo[i] = 1/0 // set to infinity
		}
		global.nextwep[index, 0] = get_wep()

		HasEx = "
		_____\    _______
       /      \  |      /\
      /_______/  |_____/  \
     |   \   /        /   /
      \   \         \/   /
       \  /          \__/_
        \/ ____    /\
          /  \    /  \
         /\   \  /   /
           \   \/   /
            \___\__/
		"
	}
	//if wep != 0 wep = wep_check(wep)
	//if bwep != 0 bwep = wep_check(bwep)
	var re = reload, be = breload
	wait(0)
	if !instance_exists(self) continue
	if "meleeammo" not in self meleeammo = 4
	var _w = weapon_get_type(wep);
	var _c = weapon_get_cost(wep);
	if global.killammo <= 0//ammo[_w] < _c || (_w = 0 && global.killammo <= 0) || (_c == 0 and ammo[_w] == 0) or GameCont.rad < weapon_get_rads(wep)
	{
		global.killammo = clamp(irandom_range(3, 5 + round(GameCont.hard /3)), 3, 24)
		for (var _i = 0; _i < maxp; _i++){
				global.nextwep[_i, 2] = global.killammo;
		}
		wep = determine_wep(index)
		if skill_get("prismatic iris") > 0 mod_script_call_self("skill", "prismatic iris", "color", wep, mod_variable_get("skill", "prismatic iris", "color"))
		reload = 1
		if weapon_get_type(wep) != 0
		{
			meleeammo = 12
			//ammo[weapon_get_type(wep)] += max(2*typ_ammo[weapon_get_type(wep)], 2*weapon_get_cost(wep))
		}
		else
		{
			if meleeammo <= 0
			{
				meleeammo = 12
				wep = determine_wep(index)
			}
		}
	}
	if weapon_get_type(wep) = 0
	{
		if reload > re
			meleeammo--
	}
	//atcive shooters
	if race = ("steroids")
	{
    	if "bmeleeammo" not in self bmeleeammo = 4
    	var _w = weapon_get_type(bwep);
    	var _c = weapon_get_cost(bwep);
    	if global.killammo <= 0//ammo[_w] < _c || (_w = 0 && bmeleeammo <= 0) || (_c == 0 and ammo[_w] == 0) or GameCont.rad < weapon_get_rads(bwep)
    	{
				global.killammo = irandom_range(3, 5 + round(GameCont.hard /3))
				for (var _i = 0; _i < maxp; _i++){
						global.nextwep[_i, 2] = global.killammo;
				}
    		bwep = determine_wep(index)
    		breload = 1
			if skill_get("prismatic iris") > 0{
			    var w = wep
			    var q = mod_script_call_self("skill", "prismatic iris", "color", bwep, mod_variable_get("skill", "prismatic iris", "color"))
			    if q{
			        bwep = wep;
			        wep = w
			    }
			}

    		if weapon_get_type(bwep) != 0
    		{
    			bmeleeammo = 12
    			//ammo[weapon_get_type(bwep)] += max(typ_ammo[weapon_get_type(bwep)], 2*weapon_get_cost(bwep))
    		}
    		else
    		{
    			if bmeleeammo <= 0
    			{
    				bmeleeammo = 12
    				bwep = determine_wep(index)
    			}
    		}
    	}
    	if weapon_get_type(bwep) = 0{
    		if breload > be
    		    bmeleeammo--
    	}
	}
	/*if bwep != 0
	{
		with instance_create(x,y,WepPickup)
		{
			wep = other.bwep
			curse = other.bcurse
		}
		bwep = 0
	}*/
}
with instances_matching_le(enemy, "my_health", 0){
	global.killammo--;
	for (var _i = 0; _i < maxp; _i++){
			global.nextwep[_i, 2] = global.killammo;
	}
}

#define wrap(w)
return {
    wep : "wrapper",
    wrapped : w,
    meleeammo : 90
}

#define wep_check(w)
if !is_object(w) or w.wep != "wrapper" return wrap(w)
if w.meleeammo <= 0 or ammo[weapon_get_type(w)] < weapon_get_cost(w.wrapped) or GameCont.rad < weapon_get_rads(w.wrapped) or (weapon_get_cost(w.wrapped) == 0 and ammo[weapon_get_type(w.wrapped)] == 0){
    var q = get_wep()
    if q == w.wrapped w = get_wep()
    var e = wrap(q)
    var t = weapon_get_type(q)
    if t != 0 ammo[t] += max(2*typ_ammo[t], 2*weapon_get_cost(q))
    sound_play( weapon_get_swap(q));
    instance_create(x,y,WepSwap)
    with instance_create(x,y,PopupText)
    {
    	text   = weapon_get_name(q) + "!";
    	target = other.index
    	with instance_create(x,y,CustomObject)
    	{
    		if fork()
    		{
    			wait(2)
    			if !instance_exists(self) exit
    			target  = other.target
    			on_step = text_step
    			exit
    		}
    	}
    }
    return e
}
return w

#define crown_name // Crown Name
return "CROWN OF EXCHANGE";

#define crown_text // Description
return "CHANGE YOUR @wWEAPON@s#AFTER KILLING ENOUGH @wENEMIES@s#no @yammo @wdrops @sand @wchests";

#define crown_tip // Loading Tip
return "A FAIR DEAL";

#define crown_avail // L1+
if(GameCont.loops <= 0) return 1;

#define get_wep()
var _i = 0
var _l = ds_list_create();
var dif = GameCont.areanum + 2*array_length(instances_matching(Player,"race","robot"))
weapon_get_list(_l, clamp(dif - 2, 0, 8), dif + 1);

// weapon ban list
for(var _m = 0; _m < ds_list_size(_l); _m++){
	for(var _n = 0; _n < array_length(global.exchange_ban_list); _n++){
		if ds_list_find_value(_l, _m) = global.exchange_ban_list[_n]{
			ds_list_delete(_l, _m);
		}
	}
}
ds_list_shuffle(_l);
_i = ds_list_find_value(_l, 1);

if mod_variable_get("skill", "prismaticiris", "color") == "filteredlens"{
    var n = 0
    ds_list_shuffle(_l);
    _i = ds_list_find_value(_l,1);
    while ds_list_size(_l) > 1 and weapon_get_type(_i) == 1{
        ds_list_delete(_l, 1);
        _i = ds_list_find_value(_l,1);
    }
}

ds_list_destroy(_l);
return _i

#define determine_wep(INDEX)
var _i = global.nextwep[INDEX, 0]
sound_play( weapon_get_swap(_i));
instance_create(x,y,WepSwap)
with instance_create(x,y,PopupText)
{
	text   = weapon_get_name(_i) + "!";
	target = other.index
	with instance_create(x,y,CustomObject)
	{
		if fork()
		{
			wait(2)
			target  = other.target
			on_step = text_step
		}
	}
}
global.nextwep[INDEX, 0] = get_wep()
for(var _j = 0; _j < maxp; _j++){
	global.nextwep[_j, 2] += .5;
}
return _i

#define text_step
with instances_matching(PopupText,"target",target)
{
	if text = "EMPTY" {instance_destroy();exit}
	if text = "NOT ENOUGH BULLETS" {instance_destroy();exit}
	if text = "NOT ENOUGH SHELLS" {instance_destroy();exit}
	if text = "NOT ENOUGH BOLTS" {instance_destroy();exit}
	if text = "NOT ENOUGH EXPLOSIVES" {instance_destroy();exit}
	if text = "NOT ENOUGH ENERGY" {instance_destroy();exit}
}
instance_destroy()

#define crown_take
sound_play_crown()
store_wep()
global.killammo = irandom_range(3, 5 + round(GameCont.hard /3))
for(var _i = 0; _i < maxp; _i++){
	global.nextwep[_i, 2] = global.killammo; // how many weapons have been swapped
}

#define crown_lose
with Player
{
	var i = 0;
	repeat(5)
	{
		i++
		ammo[i] = typ_amax[i]
		//typ_ammo[i] *= 4
	}
}

#define sound_play_crown()
with instance_create(0,0,CustomObject)// /gml mod_script_call("crown","exchange","sound_play_crown")
{
sound_play_pitchvol(sndStatueDead,2,.4)
sound_play_pitchvol(sndStatueCharge,.8,.2)
	timer = 0
	on_step = snd_step
	on_cleanup = snd_destroy
}

#define snd_step
timer += current_time_scale
// /gml mod_script_call("crown","exchange","sound_play_crown")
if timer = 1  sound_play_pitchvol(sndCrownLife,1,1)
if timer = 23
{
	sound_set_track_position(sndCrownLife,2)
	sound_play_pitchvol(sndCrownLife,1,1)
}
if timer = 9 sound_play_pitchvol(sndSwapShotgun,.96,1)
if timer = 20 sound_play_pitchvol(sndSwapPistol,.96,1)
if timer = 24 sound_play_pitchvol(sndSwapExplosive,.96,1)
if timer = 30 sound_play_pitchvol(sndSwapEnergy,.96,1)
if timer = 34 sound_play_pitchvol(sndSwapShotgun,.96,1)
if timer = 42 sound_play_pitchvol(sndSwapMachinegun,.96,1)
if timer = 45 sound_play_pitchvol(sndSwapSword,1,1)
if timer >= 100 instance_destroy()

#define snd_destroy
sound_set_track_position(sndCrownLife,0)

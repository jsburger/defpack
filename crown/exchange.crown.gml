// Define Sprites
#define init
global.spr_idle = sprite_add("sprCrownIdle.png",1,8,8);
global.spr_walk = sprite_add("sprCrownWalk.png",6,8,8);
global.spr_icon = sprite_add("sprCrownSelect.png",1,12,16);
//Set Sprites
#define crown_object
spr_idle = global.spr_idle;
spr_walk = global.spr_walk;

#define crown_button
sprite_index = global.spr_icon;

#define step

with Player
{
	//detect run start
	if  "HasEx" not in self
	{
		var i = 0;
		repeat(5)
		{
			i++
			typ_ammo[i] = ceil(typ_ammo[i]/2)
		}
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
	if "meleeammo" not in self meleeammo = 4
	var _w = weapon_get_type(wep);
	var _c = weapon_get_cost(wep);
	if ammo[_w] < _c || (_w = 0 && meleeammo <= 0)
	{
		wep = determine_wep()
		reload = 1
		if weapon_is_melee(wep) != 0
		{
			meleeammo = 6
			ammo[_w] += max(typ_ammo[_w], 2*weapon_get_cost(_c))
		}
		else
		{
			if meleeammo <= 0
			{
				meleeammo = 6
				wep = determine_wep()
			}
		}
	}
	if weapon_get_type(wep) = 0
	{
		if reload <= 0
		{
			if button_pressed(index,"fire") || ((race == "skeleton" || race = "venuz") and button_check(index,"spec"))
			{
				meleeammo--
			}
		}
	}
	//atcive shooters
	if race = ("steroids")
	{
    	if "bmeleeammo" not in self bmeleeammo = 4
    	var _w = weapon_get_type(bwep);
    	var _c = weapon_get_cost(bwep);
    	if ammo[_w] < _c || (_w = 0 && bmeleeammo <= 0)
    	{
    		bwep = determine_wep()
    		breload = 1
    		if weapon_get_type(bwep) != 0
    		{
    			bmeleeammo = 6
    			ammo[_w] += max(typ_ammo[_w], 2*weapon_get_cost(_c))
    		}
    		else
    		{
    			if bmeleeammo <= 0
    			{
    				bmeleeammo = 6
    				bwep = determine_wep()
    			}
    		}
    	}
    	if weapon_get_type(bwep) = 0
    	{
    		if breload <= 0
    		{
    			if button_pressed(index,"spec")
    			{
    				bmeleeammo--
    			}
    		}
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

#define wep_check(w)
if !is_object(w) or w.wep != "wrapper" return {
    wep : "wrapper",
    wrapped : w,
    meleeammo : 60
}
if w.meleeammo <= 0 or ammo[weapon_get_type(w)] < weapon_get_cost(w){
    var e = {
        wep : w.wep,
        wrapped : determine_wep(),
        meleeammo : 60
    }
    var t = weapon_get_type(e)
    if t != 0 ammo[t] += max(typ_ammo[t], 2*weapon_get_cost(e))
    return e
}
return w

#define game_start

#define crown_name // Crown Name
return "CROWN OF EXCHANGE";

#define crown_text // Description
return "CHANGE YOUR @wWEAPON@s#WHEN RUNNING OUT OF @yAMMO@s#halved @yammo @sincome";

#define crown_tip // Loading Tip
return "A FAIR DEAL";

#define crown_avail // L1+
if(GameCont.loops <= 0) return 1;

#define determine_wep()
var _i = 0
var _l = ds_list_create();
weapon_get_list(_l, clamp(GameCont.areanum,2, 10), GameCont.areanum+1);
ds_list_shuffle(_l);
_i = ds_list_find_value(_l,1);
sound_play( weapon_get_swap(_i));
instance_create(x,y,WepSwap)
ds_list_destroy(_l);
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

#define crown_lose
with Player
{
	var i = 0;
	repeat(5)
	{
		i++
		typ_ammo[i] *= 2
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

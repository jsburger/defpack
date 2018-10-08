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
	if "meleeammo" not in self meleeammo = 4
	var _w = weapon_get_type(wep);
	var _c = weapon_get_cost(wep);
	if ammo[_w] < _c || (_w = 0 && meleeammo <= 0)
	{
		wep = determine_wep()
		reload = 1
		if weapon_get_type(wep) != 0
		{
			meleeammo = 4
			instance_create(x,y,AmmoPickup)
		}
		else
		{
			if meleeammo <= 0
			{
				meleeammo = 4
				wep = determine_wep()
			}
		}
	}
	if weapon_get_type(wep) = 0
	{
		if reload <= 0
		{
			var _t = button_check(index,"fire");
			if race = ("skeleton"||"venuz"){var _t = button_check(index,"spec")}
			if button_pressed(index,"fire")
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
			bmeleeammo = 4
			instance_create(x,y,AmmoPickup)
		}
		else
		{
			if bmeleeammo <= 0
			{
				bmeleeammo = 4
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
	if bwep != 0 bwep = 0
}

#define crown_name // Crown Name
return "CROWN OF EXCHANGE";

#define crown_text // Description
return "CHANGE YOUR @wWEAPON@s#WHEN RUNNING OUT OF @yAMMO@w#no @wsecondary @sweapon";

#define crown_tip // Loading Tip
return "ALL THESE GUNS";

#define crown_avail // L1+
if(GameCont.loops <= 0) return 1;

#define determine_wep()
var _i = 0
var _l = ds_list_create();
weapon_get_list(_l, max(GameCont.areanum,2), GameCont.areanum+1);
ds_list_shuffle(_l);
_i = ds_list_find_value(_l,1);
ds_list_destroy(_l);
return _i

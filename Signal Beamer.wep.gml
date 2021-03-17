#define init
global.sprSignalBeamer = sprite_add_weapon("sprites/weapons/sprSignalBeamer.png", 2, 2);
global.sprSignalBeamerG = sprite_add_weapon("sprites/weapons/sprSignalBeamerG.png", 2, 2);
global.sprSignalBeamerY = sprite_add_weapon("sprites/weapons/sprSignalBeamerY.png", 2, 2);
global.sprSignalBeamerR = sprite_add_weapon("sprites/weapons/sprSignalBeamerR.png", 2, 2);
global.sprSignalBeamerE = sprite_add_weapon("sprites/weapons/sprSignalBeamerE.png", 2, 2);
global.sprSignalBeamerGHUD = sprite_add("sprites/interface/sprSignalBeamerHUD1.png", 0, 2, 2);
global.sprSignalBeamerYHUD = sprite_add("sprites/interface/sprSignalBeamerHUD2.png", 0, 2, 2);
global.sprSignalBeamerRHUD = sprite_add("sprites/interface/sprSignalBeamerHUD3.png", 0, 2, 2);

#macro margin_yellow 1;
#macro margin_red    .5;

#define weapon_name
return "SIGNAL BEAMER"

#define weapon_sprt_hud
if "ammo" in self
{
	//if !is_array(ammo){return global.sprSignalBeamerHUD;exit}
	if my_health/maxhealth >= (margin_yellow){return global.sprSignalBeamerGHUD}
	else
	{
		if my_health/maxhealth > (margin_red){return global.sprSignalBeamerYHUD}
		else
		{
			return global.sprSignalBeamerRHUD
			//else{return global.sprSignalBeamerE}
		}
	}
}
else{return global.sprSignalBeamer}

#define weapon_sprt
if "ammo" in self
{
	//if !is_array(ammo){return global.sprSignalBeamer;exit}
	if my_health/maxhealth >= (margin_yellow){return global.sprSignalBeamerG}
	else
	{
		if my_health/maxhealth > (margin_red){return global.sprSignalBeamerY}
		else
		{
			return global.sprSignalBeamerR
			//else{return global.sprSignalBeamerE}
		}
	}
}
else{return global.sprSignalBeamer}

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 10;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 7;

#define weapon_text
if irandom(4)<3 and instance_is(self,Player)
{
	if my_health >= (margin_yellow){return "BEWARE OF @gGREEN"}
	else
	{
		if my_health/maxhealth > (margin_red){return "PREPARE FOR @yYELLOW"}
		else{return "@rRED"}
	}
}
else return "BULLET TRAFFICKING";
#define nts_weapon_examine
return{
    "d": "Freshly harvested from the elusive street light tree in Frozen City. #Changes bullet color depending on how many bullets you have. ",
}
#define weapon_fire
motion_add(gunangle+180,1)
repeat(3)
{
	if !instance_exists(self){exit}
	var _P = random_range(.8,1.2), _v = .7;
	sound_play_pitchvol(sndMachinegun,.8*_P, _v)
	sound_play_pitchvol(sndFlareExplode,2*_P, _v)
	sound_play_pitchvol(sndBloodLauncherExplo,1*_P,.12)
	weapon_post(6,-10, 2)
	if my_health/maxhealth >= (margin_yellow)
	{
		mod_script_call("mod","defpack tools", "shell_yeah", 100, 35, random_range(3,5), c_green)
		sound_play_pitch(sndUltraEmpty,.6)
		with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y)
		{
			team = other.team
			creator = other
			motion_set(other.gunangle + random_range(-1,1) * other.accuracy,16)
			image_angle = direction
		}
	}
	else
	{
		sound_play_pitchvol(sndUltraEmpty,.5, _v)
		if my_health/maxhealth > (margin_red)
		{
			mod_script_call("mod","defpack tools", "shell_yeah", 100, 35, random_range(3,5), c_yellow)
			with instance_create(x,y,Bullet1)
			{
				motion_set(other.gunangle + random_range(-2,2) * other.accuracy, 18)
				image_angle = direction
				team = other.team
				creator = other
			}
		}
		else
		{
			mod_script_call("mod","defpack tools", "shell_yeah", 100, 35, random_range(3,5), c_red)
			sound_play_pitchvol(sndUltraEmpty,.4, _v)
			with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y)
			{
				team = other.team
				creator = other
				motion_set(other.gunangle + random_range(-7,7) * other.accuracy,20)
				image_angle = direction
			}
		}
	}
	wait(2)
}

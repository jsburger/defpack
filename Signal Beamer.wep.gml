#define init
global.sprSignalBeamer = sprite_add_weapon("sprites/sprSignalBeamer.png", 2, 2);
global.sprSignalBeamerG = sprite_add_weapon("sprites/sprSignalBeamerG.png", 2, 2);
global.sprSignalBeamerY = sprite_add_weapon("sprites/sprSignalBeamerY.png", 2, 2);
global.sprSignalBeamerR = sprite_add_weapon("sprites/sprSignalBeamerR.png", 2, 2);
global.sprSignalBeamerE = sprite_add_weapon("sprites/sprSignalBeamerE.png", 2, 2);

#define weapon_name
return "SIGNAL BEAMER"

#define weapon_sprt
if "ammo" in self
{
	if !is_array(ammo){return global.sprSignalBeamer;exit}
	if ammo[1]/typ_amax[1] >= (2/3){return global.sprSignalBeamerG}
	else
	{
		if ammo[1]/typ_amax[1] >= (1/3){return global.sprSignalBeamerY}
		else
		{
			if ammo[1]>=3{return global.sprSignalBeamerR}
			else{return global.sprSignalBeamerE}
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
return 12;

#define weapon_text
if irandom(4)<3 and instance_is(self,Player)
{
	if ammo[1]/typ_amax[1] >= (2/3){return "BEWARE OF @gGREEN"}
	else
	{
		if ammo[1]/typ_amax[1] >= (2/3){return "PREPARE FOR @yYELLOW"}
		else{return "@rRED"}
	}
}
else return "BULLET TRAFFICKING";

#define weapon_fire
motion_add(gunangle+180,1)
repeat(3)
{
	if !instance_exists(self){exit}
	var _P = random_range(.8,1.2);
	sound_play_pitch(sndMachinegun,.8*_P)
	sound_play_pitch(sndFlareExplode,2*_P)
	sound_play_pitchvol(sndBloodLauncherExplo,1*_P,.12)
	weapon_post(6,-4,16)
	if ammo[1]/typ_amax[1] >= (2/3)
	{
		mod_script_call("mod","defpack tools", "shell_yeah", 100, 35, random_range(3,5), c_green)
		sound_play_pitch(sndUltraEmpty,.6)
		with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y)
		{
			move_contact_solid(other.gunangle,4)
			team = other.team
			creator = other
			motion_set(other.gunangle + random_range(-3,3) * other.accuracy,14)
			image_angle = direction
		}
	}
	else
	{
		sound_play_pitch(sndUltraEmpty,.5)
		if ammo[1]/typ_amax[1] >= (1/3)
		{
			mod_script_call("mod","defpack tools", "shell_yeah", 100, 35, random_range(3,5), c_yellow)
			with instance_create(x,y,Bullet1)
			{
				move_contact_solid(other.gunangle,4)
				motion_set(other.gunangle + random_range(-3,3) * other.accuracy, 14)
				image_angle = direction
				team = other.team
				creator = other
			}
		}
		else
		{
			mod_script_call("mod","defpack tools", "shell_yeah", 100, 35, random_range(3,5), c_red)
			sound_play_pitch(sndUltraEmpty,.4)
			with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y)
			{
				move_contact_solid(other.gunangle,4)
				team = other.team
				creator = other
				motion_set(other.gunangle + random_range(-3,3) * other.accuracy,14)
				image_angle = direction
			}
		}
	}
	wait(2)
}

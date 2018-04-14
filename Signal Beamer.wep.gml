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
return 9;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 12;

#define weapon_text
return choose("GUMMY BEEEEAAARS","BEWARE OF @gGREEN","PREPARE FOR @yYELLOW","@rRED")

#define weapon_fire
motion_add(gunangle+180,1)
repeat(3)
{
	sound_play_pitch(sndMachinegun,.8)
	sound_play_pitch(sndFlareExplode,2)
	sound_play_pitchvol(sndBloodLauncherExplo,1,.12)
	weapon_post(6,-4,2)
	if ammo[1]/typ_amax[1] >= (2/3)
	{
		sound_play_pitch(sndUltraEmpty,.6)
		with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y)
		{
			move_contact_solid(other.gunangle,4)
			team = other.team
			motion_set(other.gunangle + random_range(-3,3) * other.accuracy,14)
			image_angle = direction
		}
	}
	else
	{
		sound_play_pitch(sndUltraEmpty,.5)
		if ammo[1]/typ_amax[1] >= (1/3)
		{
			with instance_create(x,y,Bullet1)
			{
				move_contact_solid(other.gunangle,4)
				motion_set(other.gunangle + random_range(-3,3), 14)
				image_angle = direction
				team = other.team
			}
		}
		else
		{
			sound_play_pitch(sndUltraEmpty,.4)
			with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y)
			{
				move_contact_solid(other.gunangle,4)
				team = other.team
				motion_set(other.gunangle + random_range(-3,3) * other.accuracy,14)
				image_angle = direction
			}
		}
	}
	wait(2)
}

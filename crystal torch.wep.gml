#define init
global.sprCrystalTorch5 = sprite_add_weapon("sprites/sprCrystalTorch5.png",6,10)
global.sprCrystalTorch4 = sprite_add_weapon("sprites/sprCrystalTorch4.png",6,10)
global.sprCrystalTorch3 = sprite_add_weapon("sprites/sprCrystalTorch3.png",6,10)
global.sprCrystalTorch2 = sprite_add_weapon("sprites/sprCrystalTorch2.png",6,10)
global.sprCrystalTorch1 = sprite_add_weapon("sprites/sprCrystalTorch1.png",6,10)

#define weapon_sprt
if "ammo" in self
{
	if "CrystalTorchCharge" not in self
	{
		return global.sprCrystalTorch1;
	}
	else
	{
		if CrystalTorchCharge <= 10{return global.sprCrystalTorch1}
		if CrystalTorchCharge <= 20{return global.sprCrystalTorch2}
		if CrystalTorchCharge <= 30{return global.sprCrystalTorch3}
		if CrystalTorchCharge <= 40{return global.sprCrystalTorch4}
		if CrystalTorchCharge <= 60{return global.sprCrystalTorch5}
	}
}
else return global.sprCrystalTorch1
#define weapon_text
return choose("ILLUMINATE","PURGE")
#define weapon_name
return "CRYSTAL TORCH"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return -1;
#define weapon_load
if "CrystalTorchCharge" not in self
{
	return 16
}
else
{
	if CrystalTorchCharge <= 10{return 16}
	if CrystalTorchCharge <= 20{return 18}
	if CrystalTorchCharge <= 30{return 20}
	if CrystalTorchCharge <= 40{return 22}
	if CrystalTorchCharge <= 60{return 24}
}
#define weapon_swap
return sndSwapHammer
#define weapon_auto
return 0
#define weapon_melee
return 1
#define weapon_laser_sight
return 0

#define weapon_fire
sound_play_pitch(sndLaserCrystalHit,random_range(.6,.8))
sound_play_pitch(sndWrench,random_range(.8,1.2))
weapon_post(-7,0,28)
if "CrystalTorchCharge" not in self{CrystalTorchCharge = 0}
with instance_create(x,y,Slash)
{
	creator = other
	team = other.team
	if other.CrystalTorchCharge <= 10{lv = 1}
	if other.CrystalTorchCharge <= 20{lv = 2}
	if other.CrystalTorchCharge <= 30{lv = 3}
	if other.CrystalTorchCharge <= 40{lv = 4}
	if other.CrystalTorchCharge <= 60{lv = 5}
	damage = lv * 4
	if lv >= 3
	{
		sprite_index = sprHeavySlash
	}
	if lv = 5
	{
		sprite_index = sprMegaSlash
		mask_indedx  = mskMegaSlash
	}
	name = "crystal slash"
	motion_add(other.gunangle+random_range(-12,12), 1 + (skill_get(13) * 2))
	image_angle = direction
	on_hit = ct_hit
}
wepangle *= -1

#define ct_hit
if team != other.team
{
	if projectile_canhit_melee(other)
	{
			projectile_hit(other,damage,direction,lv)
			if instance_exists(creator)
			{
				with creator
				{
					CrystalTorchCharge -= 3
					trace(CrystalTorchCharge)
				}
			}
	}
}
#define step
with instances_matching(Slash,"name","crystal slash")
{
	with InvLaserCrystal
	{
		if distance_to_object(other) <= 0
		{
			with instance_create(x,y,LaserCrystal){my_health = other.my_health}
			instance_delete(self)
			with other.creator{CrystalTorchCharge = clamp(CrystalTorchCharge+6,0,60)}
		}
	}
	with InvSpider
	{
		if distance_to_object(other) <= 0
		{
			with instance_create(x,y,Spider){my_health = other.my_health}
			instance_delete(self)
			with other.creator{CrystalTorchCharge = clamp(CrystalTorchCharge+5,0,60)}
		}
	}
	with InvCrystal
	{
		if distance_to_object(other) <= 0
		{
			with instance_create(x,y,CrystalProp){my_health = other.my_health}
			instance_delete(self)
			with other.creator{CrystalTorchCharge = clamp(CrystalTorchCharge+2,0,60)}
		}
	}
	with BigCursedChest
	{
		if distance_to_object(other) <= 0
		{
			instance_create(x,y,BigWeaponChest)
			instance_delete(self)
			with other.creator{CrystalTorchCharge = clamp(CrystalTorchCharge+2,0,60)}
		}
	}
	with WepPickup
	{
		if distance_to_object(other) <= 0
		{
			if curse != false
			{
				curse = false
				with other.creator{CrystalTorchCharge = clamp(CrystalTorchCharge+2,0,60)}
			}
		}
	}
}

#define init
global.sprFirstAidSoda = sprite_add_weapon("sprFirstAidSoda.png",-2,1)
#define weapon_sprt
return global.sprFirstAidSoda
#define weapon_name
return "FIRST AID SODA"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return -1
#define weapon_load
return 0
#define weapon_swap
sound_play_pitch(sndToxicBoltGas,random_range(2.3,2.4))
sound_play_pitch(sndOasisCrabAttack,random_range(.5,.6))
return -1
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
wep = 0
sound_play_pitch(sndHPPickup,1.4)
sound_play_pitch(sndOasisCrabAttack,random_range(.6,.8))
sound_play_pitch(sndToxicBoltGas,random_range(1.2,1.4))
repeat(7)with instance_create(x,y,Bubble){image_speed*=1.6}
if skill_get(9) = true{var _hp = 2}else{var _hp = 1}//second stomach synergy
if my_health <= maxhealth - _hp
{
	my_health+=_hp
	if _hp = 1
	{
		with instance_create(x,y,PopupText){target = other.index;text = "+1 HEALTH"}
		sound_play_pitch(sndHPPickup,random_range(.8,1.2)+.2)
	}
	else
	{
		with instance_create(x,y,PopupText){target = other.index;text = "+2 HEALTH"}
		sound_play_pitch(sndHPPickupBig,random_range(.8,1.2)+.2)
	}
	wep = bwep;bwep = 0
	curse = bcurse
	mod_script_call("mod","sodaeffect","drink",x,y)
	reload = max(breload,10)
}
else{with instance_create(x,y,PopupText){target = other.index;text = "MAX HEALTH"}}


#define weapon_text
return "IN CASE OF EMERGENCY"

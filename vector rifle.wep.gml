#define init
global.sprVectorRifle   = sprite_add_weapon("sprites/weapons/sprVectorRifle.png",2,2)

#define weapon_name
return "VECTOR RIFLE"
#define weapon_type
return 5
#define weapon_cost
return 2
#define weapon_area
return 11
#define weapon_load
return 23
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_reloaded(p)
if !button_check(index, (!p and race == "steroids") ? "spec" : "fire"){
	sound_play_pitchvol(sndIDPDNadeAlmost,.5,.2)
	sound_play_pitchvol(sndPlasmaReload,1.4,.4)
}
#define weapon_sprt
return global.sprVectorRifle
#define weapon_text
return "pointy"

#define weapon_fire
motion_add(gunangle-180,3)
repeat(3)instance_create(x,y,Smoke)
weapon_post(7,0,23)
if skill_get(17) = true
{
	var _pitch = random_range(.85,1.15)
	sound_play_pitchvol(sndDevastatorUpg,3*_pitch,.7)
	sound_play_pitch(sndEnergyHammerUpg,1.2*_pitch)
	sound_play_pitch(sndLaser,.5*_pitch)
}
else
{
	var _pitch = random_range(.85,1.15)
	sound_play_pitchvol(sndDevastator,3*_pitch,.6)
	sound_play_pitch(sndEnergyHammerUpg,1.2*_pitch)
	sound_play_pitch(sndLaser,.7*_pitch)
}
with mod_script_call_nc("mod", "defpack tools", "create_vector", x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle)){
	pierce = 25+skill_get(17)*15
	lspeed = 12
	team = other.team
	creator = other
	image_angle = other.gunangle+random_range(-1,1)*creator.accuracy
	langle = image_angle
	image_xscale = lspeed/2
}

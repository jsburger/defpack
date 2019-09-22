#define init
global.sprVectorShotgun = sprite_add_weapon("sprites/weapons/sprVectorShotgun.png",4,5)

#define weapon_name
return "VECTOR SHOTGUN"
#define weapon_type
return 5
#define weapon_cost
return 3
#define weapon_area
return 11
#define weapon_load
return 32
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
return global.sprVectorShotgun
#define weapon_text
return "pointy"

#define weapon_fire
motion_add(gunangle - 180, 4)
repeat(3) instance_create(x, y, Smoke)
weapon_post(11, 0, 17)
var _pitch = random_range(.85, 1.15)
if skill_get(17) = true {
	sound_play_pitchvol(sndEnergyHammerUpg,.8*_pitch,2)
	//sound_play_pitch(sndPlasmaMinigunUpg,random_range(.5,.6))
	sound_play_pitch(sndEnergyScrewdriverUpg,random_range(.5,.7)*_pitch)
	sound_play_pitch(sndPlasmaHit,random_range(1.4,1.6)*_pitch)
}
else {
	sound_play_pitchvol(sndDevastator,3*_pitch,.6)
	sound_play_pitchvol(sndEnergyHammerUpg,1.2*_pitch,2)
	sound_play_pitch(sndEnergyScrewdriverUpg,1.5*_pitch)
	sound_play_pitch(sndPlasmaHit,random_range(1.4,1.6)*_pitch)
}
var ang = gunangle + random_range(-9,9) * accuracy;
for var i = -1; i <= 1; i++ {
	with mod_script_call("mod", "defpack tools", "create_vector", x, y) {
		shrinkspeed += .05
		motion_set(ang - 40 * i * other.accuracy, random_range(7, 9))
		projectile_init(other.team, other)
	}
}

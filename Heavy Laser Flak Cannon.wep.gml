#define init
global.sprHeavyLaserFlakCannon = sprite_add_weapon("sprites/sprHeavyLaserFlakCannon.png", 8, 6);
global.sprHeavyLaserFlakBullet = sprite_add("defpack tools/sprHeavyLaserFlak.png",2, 12, 12);

#define weapon_name
return "HEAVY LASER FLAK CANNON";

#define weapon_sprt
return global.sprHeavyLaserFlakCannon;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 44;

#define weapon_cost
return 12;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 13;

#define weapon_text
return "OH JOY HAS COME";

#define weapon_fire
weapon_post(15,-13,113)
motion_add(gunangle-180,5)
if !skill_get(17)
{
	sound_play_pitch(sndFlakCannon,random_range(.6,.8))
	sound_play_pitch(sndLaser,random_range(.6,.8))
	sound_play_pitch(sndPlasma,random_range(.6,.8))
	sound_play_pitch(sndPlasmaBigExplodeUpg,random_range(.6,.8))
	sound_play_pitch(sndPlasmaBigUpg,random_range(.6,.8))
	sound_play_pitch(sndPlasmaRifle,random_range(.6,.8))
	sound_play_pitch(sndDevastator,random_range(1.2,1.4))
}
else
{
	sound_play_pitch(sndFlakCannon,random_range(.6,.8))
	sound_play_pitch(sndLaserUpg,random_range(.6,.8))
	sound_play_pitch(sndPlasmaUpg,random_range(.6,.8))
	sound_play_pitch(sndPlasmaRifleUpg,random_range(.6,.8))
	sound_play_pitch(sndDevastatorUpg,random_range(1.2,1.4))
	sound_play_pitch(sndPlasmaBigExplodeUpg,random_range(.6,.8))
}
with mod_script_call("mod","defpack tools","create_laser_flak",x,y)
{
	name = "Heavy Laser Flak"
	creator = other
	move_contact_solid(other.gunangle,8)
	motion_add(other.gunangle+random_range(-14,14)*other.accuracy,16)
	sprite_index = global.sprHeavyLaserFlakBullet
	image_angle = direction
	team = other.team
	accuracy = other.accuracy
	size  = 2
	ammo = 24
	if skill_get(17)
	{
		image_xscale += .3
		image_yscale += .3
	}
}

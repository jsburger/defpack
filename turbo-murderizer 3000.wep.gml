#define init
global.sprTurboMurderizer3000 = sprite_add_weapon("sprites/weapons/sprTurboMurderizer3000.png",12,5)
#define weapon_name
return "TURBO-MURDERIZER 3000"
#define weapon_type
return 5
#define weapon_cost
return 1
#define weapon_area
return 23
#define weapon_load
return 2
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return 1
#define weapon_melee
return false
#define weapon_laser_sight
return false
#define weapon_sprt
return global.sprTurboMurderizer3000
#define weapon_text
return "COMEDY GREEN"
#define weapon_fire
motion_add(gunangle-180,4)
var i = wepflip, flip = wepflip
repeat(3)
{
  weapon_post(9,5,12)
  var _p = random_range(.8,1.2)
  if !skill_get(17)
	{
		sound_play_pitch(sndPlasma,1.3*_p)
        sound_play_pitch(sndTripleMachinegun,1.7*_p)
		sound_play_pitch(sndPlasmaMinigun,.6*_p)
	}
	else
	{
		sound_play_pitch(sndPlasmaUpg,1.3*_p)
		sound_play_pitch(sndPlasmaMinigunUpg,.6*_p)
	}
	with mod_script_call_nc("mod","defpack tools","create_plasmite",x,y)
	{
		fric = random_range(.02,.2) + .08
		motion_set(other.gunangle+(i)*25+random_range(-7,7)*other.accuracy,18)
		projectile_init(other.team,other)
        move_contact_solid(other.gunangle,6)
        image_angle = direction
        maxspeed = 18
	}
	i -= flip
  wait(1)
  if !instance_exists(self) exit
}

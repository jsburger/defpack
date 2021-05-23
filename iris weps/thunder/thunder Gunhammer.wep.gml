#define init
global.sprThunderGunhammer 		  = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprThunderGunhammer.png", 2,8);
global.sprThunderGunhammerHUD   = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprThunderGunhammer.png", 11, 5);
global.sprThunderGunhammerSlash = sprite_add("../../sprites/projectiles/iris/thunder/sprThunderGunhammerSlash.png",3,0,24);

#define weapon_name
return "THUNDER GUNHAMMER";

#define weapon_sprt
return global.sprThunderGunhammer;

#define weapon_sprt_hud
return global.sprThunderGunhammerHUD;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 32;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return -1;

#define weapon_text
return "THUNDERWAVE";

#define weapon_melee
return 1;

#define weapon_fire

//player_fire_ext my behated
var r = 0, inf = false
if "ammo" in self {
	r = min(8, ammo[1])
}
if "infammo" in self
	if infammo != 0 {
		inf = true
		r = 8
	}

if !inf and r != 0{
	ammo[1] -= r
}

var p = random_range(.8,1.2)
sound_play_pitchvol(sndHammer, p, .7)
sound_play_pitch(sndShovel, .5 * p)
sound_play_pitch(sndHitMetal, .8 * p)
sound_play_pitch(sndAssassinAttack, 1.2 * p)

weapon_post(8, 20, 12 * ((r > 0) * 2 + 1))
motion_add(gunangle, 4)

var shells = 0,
	l = 20* skill_get(mut_long_arms);
	
with instance_create(x + lengthdir_x(l, gunangle), y + lengthdir_y(l, gunangle), Slash) {
	creator = other
	team = other.team
	sprite_index = sprHeavySlash
	damage = 10
	force = 7
	motion_set(other.gunangle, 2 + (skill_get(mut_long_arms) * 3))
	if r {
		sound_play_pitchvol(sndSawedOffShotgun, .9*p, .7)
		sound_play_pitchvol(sndDoubleShotgun, .8*p, .7)
		sound_play_pitchvol(sndTripleMachinegun, .8*p, .7)
		sound_play_pitchvol(sndLightningHammer, .8*p, .7)
		sound_play_gun(sndClickBack, 1, .6)
		sound_stop(sndClickBack)

		sprite_index = global.sprThunderGunhammerSlash
		damage = 15
		force = 15
	}
	else{sound_play_pitch(sndHammer,random_range(.97,1.03))}
	image_angle = direction
	if r {
    	repeat(r){
			with mod_script_call("mod","defpack tools","create_lightning_bullet",x,y){
				motion_set(other.direction + random_range(-32,32)*other.creator.accuracy, 10)
				image_angle = direction
				creator = other.creator
				team = other.team
			}
			shells++
    	}
	}
}
//i like the -180 here. its funny because it could just be 180
//do you agree?
if shells repeat(shells) mod_script_call("mod","defpack tools", "shell_yeah", -180, 35, random_range(3,5), c_navy)
wepangle = -wepangle

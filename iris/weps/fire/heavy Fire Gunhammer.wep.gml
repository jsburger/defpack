#define init
global.sprHeavyFireGunhammer 		  = sprite_add_weapon("sprites/sprHeavyFireGunhammer.png", 1, 6); //SHOULD BE THE NORM, LOOKING GOOD
global.sprHeavyFireGunhammerHUD 	= sprite_add_weapon("sprites/sprHeavyFireGunhammer.png", 12, 5);
global.sprHeavyFireGunhammerSlash = sprite_add("sprites/projectiles/sprFireGunhammerSlash.png",3,0,24)

#define weapon_name
return "HEAVY FIRE GUNHAMMER";

#define weapon_sprt
return global.sprHeavyFireGunhammer;

#define weapon_sprt_hud
return global.sprHeavyFireGunhammerHUD;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 22;

#define weapon_cost
return 0;

#define weapon_melee
return 1

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return -1;

#define weapon_text
return "TAKE YOUR TORCH AND BURN IT";

#define weapon_fire

if ammo[1] >=1 var r = 1 else var r = 0
var p = random_range(.8,1.2)
sound_play_pitchvol(sndHammer,p,.7)
sound_play_pitch(sndShovel,.5*p)
sound_play_pitch(sndHitMetal,.8*p)
sound_play_pitch(sndAssassinAttack,1.2*p)
sleep(20)
weapon_post(8,20,12	*(r*2+1))

with instance_create(x,y,Slash){
	damage = 15
	force = 7
	motion_add(other.gunangle+random_range(-8,8*other.accuracy), 2 + (skill_get(13) * 3))
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	gunangle = other.gunangle
	sprite_index = sprHeavySlash
	image_angle = direction
	team = other.team
	creator = other
	right = other.right
	if other.ammo[1] >=2 {
		damage = 22
		force = 15
		image_xscale *= 1.3
		image_yscale *= 1.3
	repeat(4){
			sound_play_pitchvol(sndSawedOffShotgun,.7*p,.7)
			sound_play_pitchvol(sndDoubleShotgun,.6*p,.7)
			sound_play_pitchvol(sndQuadMachinegun,.7*p,.7)
			sound_play_pitchvol(sndFlakExplode,.5*p,.4)
			sound_play_pitchvol(sndFlameCannon,3.5*p,.4)
			sound_play_pitchvol(sndIncinerator,.7*p,1)
			sound_play_pitchvol(sndFlameCannonEnd,3.5*p,.4)
			sound_play_pitch(sndHeavyRevoler,random_range(0.8,1.2))
			 mod_script_call("mod","defpack tools", "shell_yeah_heavy", -180, 35, random_range(3,5), c_red)
			sprite_index = global.sprHeavyFireGunhammerSlash
			repeat(2)with instance_create(x+lengthdir_x(sprite_width,direction)+random_range(-2,2),y+lengthdir_y(sprite_width,direction)+random_range(-2,2),Smoke)motion_set(other.direction + random_range(-8,8), 1+random(3))
			with mod_script_call("mod","defpack tools","create_heavy_fire_bullet",x,y){
				motion_set(other.direction + random_range(-30,30)*other.creator.accuracy, 16)
				image_angle = direction
				creator = other.creator
				team = other.team
			}
			if other.infammo = 0 {other.ammo[1] -= 2}
		}
		sound_play_gun(sndClickBack,1,.3)
		sound_stop(sndClickBack)
	}
}
wepangle = -wepangle
motion_add(gunangle,4)

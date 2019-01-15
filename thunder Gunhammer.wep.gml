#define init
global.sprThunderGunhammer = sprite_add_weapon("sprites/sprThunderGunhammer.png", 2,8);
global.sprThunderGunhammerSlash = sprite_add("sprites/projectiles/sprThunderGunhammerSlash.png",3,0,24);

#define weapon_name
return "THUNDER GUNHAMMER";

#define weapon_sprt
return global.sprThunderGunhammer;

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

if ammo[1] >=2 var r = 1 else var r = 0
var p = random_range(.8,1.2)
sound_play_pitchvol(sndHammer,p,.7)
sound_play_pitch(sndShovel,.5*p)
sound_play_pitch(sndHitMetal,.8*p)
sound_play_pitch(sndAssassinAttack,1.2*p)
weapon_post(8,20,12	*(r*2+1))
var shell = 0;
with instance_create(x,y,Slash)
{
	creator = other
	sprite_index = sprHeavySlash
	damage = 10
	force = 7
	if other.ammo[1] >=3
	{
		sound_play_pitchvol(sndSawedOffShotgun,.9*p,.7)
		sound_play_pitchvol(sndDoubleShotgun,.8*p,.7)
		sound_play_pitchvol(sndTripleMachinegun,.8*p,.7)
		sound_play_pitchvol(sndLightningHammer,.8*p,.7)
		sprite_index = global.sprThunderGunhammerSlash
		damage = 15
		force = 15
	}
	else{sound_play_pitch(sndHammer,random_range(.97,1.03))}
	direction = other.gunangle
	if instance_exists(Player)
	motion_add(other.gunangle,2+(skill_get(13)*3))
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	image_angle = direction
	team = other.team
	damage = 16
	if other.ammo[1] >=2{
		if other.infammo = 0 {other.ammo[1] -= 4}
		with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x+lengthdir_x(5,other.gunangle),y+lengthdir_y(5,other.gunangle)){
				creator = other.creator
				team = other.team
				motion_set(other.creator.gunangle +random_range(12,20)* other.creator.accuracy,10)
				image_angle = direction
		}with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x+lengthdir_x(5,other.gunangle),y+lengthdir_y(5,other.gunangle)){
				creator = other.creator
				team = other.team
				motion_set(other.creator.gunangle -random_range(12,20)* other.creator.accuracy,10)
				image_angle = direction
		}with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x+lengthdir_x(5,other.gunangle),y+lengthdir_y(5,other.gunangle)){
				creator = other.creator
				team = other.team
				motion_set(other.creator.gunangle +random_range(24,40)* other.creator.accuracy,10)
				image_angle = direction
		}with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x+lengthdir_x(5,other.gunangle),y+lengthdir_y(5,other.gunangle)){
				creator = other.creator
				team = other.team
				motion_set(other.creator.gunangle -random_range(24,40)* other.creator.accuracy,10)
				image_angle = direction
		}
		shell = 1
	}
}
if shell repeat(4){
	mod_script_call("mod","defpack tools", "shell_yeah", -180, 35, random_range(3,5), c_navy)
}
wepangle = -wepangle

#define init
global.sprPestGunhammer = sprite_add_weapon("sprites/sprPestGunhammer.png", 0, 10);
global.slash = sprite_add("sprites/projectiles/sprHeavyPestSlash.png",3,0,24);

#define weapon_name
return "PEST GUNHAMMER";

#define weapon_sprt
return global.sprPestGunhammer;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 21;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return -1;

#define weapon_text
return "SEWAGE SLASHER";

#define weapon_melee
return 1

#define weapon_fire

sound_play_pitchvol(sndHammer,random_range(.5,.6),.7)
sound_play_pitch(sndShovel,random_range(1.4,1.5))
weapon_post(8,8,8)//xd
var shell = 0;
with instance_create(x,y,Slash){
	damage = 7
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	sprite_index = sprHeavySlash
	image_angle = direction
	team = other.team
	creator = other
	repeat(3){
		if other.ammo[1] >=1 {
			sound_play_pitch(sndMinigun,random_range(1.2,1.6))
			sound_play_pitch(sndToxicBoltGas,1.3)
			sprite_index = global.slash
			instance_create(x+lengthdir_x(sprite_width,direction),y+lengthdir_y(sprite_width,direction),Smoke)
			with mod_script_call("mod","defpack tools","create_toxic_bullet",x,y){
				motion_set(other.direction + random_range(-9,9)*other.creator.accuracy, 10)
				image_angle = direction
				creator = other.creator
				team = other.team
			}
			if other.infammo = 0 {other.ammo[1] -= 1}
			shell += 1
		}
	}
}
if shell repeat(shell) mod_script_call("mod","defpack tools", "shell_yeah", -180, 18, random_range(3,5), c_green)
wepangle = -wepangle
motion_add(gunangle,4)

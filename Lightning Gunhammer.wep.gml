#define init
global.sprLightningGunhammer = sprite_add_weapon("Lightning Gunhammer.png", 3,6);
global.sprLightningGunhammerSlash = sprite_add("Heavy Lightning Slash.png",3,0,24);

#define weapon_name
return "LIGHTNING GUNHAMMER";

#define weapon_sprt
return global.sprLightningGunhammer;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 19;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return 10;

#define weapon_text
return "THUNDERWAVE";

#define weapon_melee
return 1;

#define weapon_fire

weapon_post(8,8,8)
var shell = 0;
with instance_create(x,y,Slash)
{
	creator = other
	sprite_index = sprHeavySlash
	if other.ammo[1] >=2
	{
		sound_play_pitch(sndLightningHammer,random_range(.97,1.03))
		sound_play_pitch(sndPistol,1.2)
		sprite_index = global.sprLightningGunhammerSlash
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
	if other.ammo[1] >=4{
		if other.infammo = 0 {other.ammo[1] -= 4}
		with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x+lengthdir_x(5,other.gunangle),y+lengthdir_y(5,other.gunangle)){
				creator = other.creator
				team = other.team
				motion_set(other.creator.gunangle +random_range(12,20)* other.creator.accuracy,8)
				image_angle = direction
		}with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x+lengthdir_x(5,other.gunangle),y+lengthdir_y(5,other.gunangle)){
				creator = other.creator
				team = other.team
				motion_set(other.creator.gunangle -random_range(12,20)* other.creator.accuracy,8)
				image_angle = direction
		}with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x+lengthdir_x(5,other.gunangle),y+lengthdir_y(5,other.gunangle)){
				creator = other.creator
				team = other.team
				motion_set(other.creator.gunangle +random_range(24,40)* other.creator.accuracy,8)
				image_angle = direction
		}with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x+lengthdir_x(5,other.gunangle),y+lengthdir_y(5,other.gunangle)){
				creator = other.creator
				team = other.team
				motion_set(other.creator.gunangle -random_range(24,40)* other.creator.accuracy,8)
				image_angle = direction
		}
		shell = 1
	}
}
if shell repeat(4){
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random(7), c_blue)
}
wepangle = -wepangle

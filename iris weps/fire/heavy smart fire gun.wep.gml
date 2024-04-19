#define init
global.sprHeavySmartFireGun = sprite_add_weapon("../../sprites/weapons/iris/fire/sprHeavySmartFireGun.png",7, 4);

#define weapon_name
return "HEAVY SMART FIRE GUN"

#define weapon_sprt
return global.sprHeavySmartFireGun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 2.6;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "BRINGIN' THE HEAT"

#define weapon_fire
var ang = point_direction(x,y,mouse_x[index],mouse_y[index]);
if instance_exists(enemy)
{
	var mydude = instance_nearest(mouse_x[index],mouse_y[index],enemy);
	ang = point_direction(x,y,mydude.x,mydude.y)
}
gunangle = ang;
aimDirection = ang;
if fork(){
    wait(0)
    if !instance_exists(self) exit
    gunangle = ang;
    aimDirection = ang;
    exit
}
sound_play_pitch(sndSmartgun,random_range(.6,.8))
var _p = random_range(.8,1.2),
	vol = .6;
sound_play_pitchvol(sndPistol, .7 * _p, vol)
sound_play_pitchvol(sndDoubleFireShotgun, .8 * _p, vol)
sound_play_pitchvol(sndIncinerator, .8 * _p, vol)
sound_play_pitchvol(sndHeavyMachinegun, .9 * _p, .7 * vol)
sound_play_pitchvol(sndHeavyNader ,1 * _p, .8 * vol)
motion_add(ang + 180, 1)
weapon_post(7, -9, 24)
mod_script_call("mod", "defpack tools", "shell_yeah_heavy", 100, 25, random_range(3,10), c_red)
if fork(){
    var time = 8;
    while time > 0 && instance_exists(self){
        canaim = 0
        time -= current_time_scale
        wait(0)
    }
    if instance_exists(self) canaim = 1
    exit
}

with mod_script_call("mod", "defpack tools", "create_heavy_fire_bullet",x,y){
	motion_set(ang+random_range(-7,7)*other.accuracy,16)
	projectile_init(other.team,other)
	image_angle = direction
	repeat(2) with instance_create(x+lengthdir_x(speed,direction),y+lengthdir_y(speed,direction),Dust)
	{
		motion_set(other.direction+random_range(-24,24),3+random(6))
	}
	with instance_create(x+lengthdir_x(speed,direction),y+lengthdir_y(speed,direction),Dust)
	{
		motion_set(other.direction+random_range(-44,44),2+random(2))
	}
}

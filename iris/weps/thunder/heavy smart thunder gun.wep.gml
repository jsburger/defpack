#define init
global.sprHeavySmartThunderGun = sprite_add_weapon("sprites/sprHeavySmartThunderGun.png",7, 4);

#define weapon_name
return "HEAVY SMART THUNDER GUN"

#define weapon_sprt
return global.sprHeavySmartThunderGun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 9;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "LIGHTNING"

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

repeat(2)
{
	var _p = random_range(.8,1.2)
	sound_play_pitchvol(sndGammaGutsKill,1.4,.3+skill_get(17)*.2)
	if !skill_get(17)sound_play_pitch(sndLightningRifle,1.2*_p)else sound_play_pitch(sndLightningRifleUpg,1.2*_p)
	sound_play_pitch(sndSmartgun,random_range(.6,.8))
	sound_play_pitch(sndPistol,.7*p)
	sound_play_pitchvol(sndHeavyNader,1*_p,.8)
	motion_add(ang+180,1)
	weapon_post(7,-9,24)
	mod_script_call("mod","defpack tools", "shell_yeah_heavy", 100, 25, random_range(3,10), c_navy)
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

	with mod_script_call("mod", "defpack tools", "create_heavy_lightning_bullet",x,y){
		motion_set(ang+random_range(-7,7)*other.accuracy,10)
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
	wait 3
	if !instance_exists(self) exit
}

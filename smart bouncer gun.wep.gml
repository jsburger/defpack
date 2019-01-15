#define init
global.sprSmartBouncerGun = sprite_add_weapon("sprites/sprSmartBouncerGun.png",6, 4);

#define weapon_name
return "SMART BOUNCER GUN"

#define weapon_sprt
return global.sprSmartBouncerGun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 4;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "DIVERGENCY IS NOT PERMITTED";

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
sound_play_pitch(sndSmartgun,random_range(.8,1.2))
sound_play_pitchvol(sndBouncerSmg,1.6,.8)
weapon_post(5,-2,6)
with instance_create(x,y,Shell){motion_add(other.gunangle+other.right*100+random(80)-40,2+random(2))}
	if fork()
	{
	    var time = 5;
	    while time > 0 && instance_exists(self){
	        canaim = 0
	        time -= current_time_scale
	        wait(0)
	    }
	    if instance_exists(self) canaim = 1
	    exit
	}

	with instance_create(x,y,BouncerBullet)
	{
		team = other.team
		creator = other
		motion_add(other.gunangle+(random(14)-7)*other.accuracy,6)
	}

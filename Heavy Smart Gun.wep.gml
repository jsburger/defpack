#define init
global.sprHeavySmartGun = sprite_add_weapon("sprites/sprHeavySmartGun.png", 10, 4);
//global.sprSmartAim = sprite_add("Smart aim.png",0,9,9)

#define weapon_name
return "HEAVY SMART GUN"

#define weapon_sprt
return global.sprHeavySmartGun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 3;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 13;

#define weapon_text
return choose("PERFECTION","TRUE BEAUTY","A SIGHT TO BEHOLD","SMARTER THAN ITS SIBLING");

#define weapon_fire
var ang = point_direction(x,y,mouse_x[index],mouse_y[index]);
if instance_exists(enemy){
	if "index" in self{
		var mydude = instance_nearest(mouse_x[index],mouse_y[index],enemy);
	}else{
		var mydude = instance_nearest(x,y,enemy)
	}
	if collision_line(x,y,mydude.x,mydude.y,Wall,0,0) = noone
	{
		ang = point_direction(x,y,mydude.x,mydude.y)
	}
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

motion_add(ang+180,1)
sound_play_pitchvol(sndHeavyMachinegun,.9,.7)
sound_play_pitchvol(sndHeavyNader,1,.8)
sound_play_pitch(sndSmartgun,random_range(0.8,0.9))
weapon_post(7,-9,24)

with instance_create(x,y,Shell)
{
	motion_add(other.gunangle+other.right*100+random_range(-12,12),3+random(7))
	sprite_index = sprHeavyShell
}

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

with instance_create(x,y,HeavyBullet){
	motion_set(ang,16)
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

#define init
global.sprToxicCarronader = sprite_add_weapon("sprToxicCarronader.png",2,4)
#define weapon_sprt
return global.sprToxicCarronader
#define weapon_text
return "shotfun"
#define weapon_name
return "TOXIC CARRONADER"
#define weapon_type
return 4
#define weapon_cost
return 2
#define weapon_area
return 4
#define weapon_load
return 23
#define weapon_swap
return sndSwapExplosive
#define weapon_auto
return true
#define weapon_melee
return 0
#define weapon_laser_sight
return 0

#define weapon_reloaded
wkick = -2
sound_play_pitch(sndToxicBoltGas,1.2)
repeat(4) with instance_create(x+2,y+4,Dust){
	motion_set(other.gunangle+180+random_range(-30,30),1+random(3))
	image_xscale = .2+random(.5)
	image_yscale = image_xscale
	depth = -3
}

#define weapon_fire
weapon_post(6,60,22)
sound_play_pitch(sndToxicBoltGas,.7)
sound_play_pitch(sndToxicBarrelGas,1.4)
sound_play_pitch(sndToxicLauncher,random_range(.46,.54))

var _x = x+lengthdir_x(18+speed,gunangle);
var _y = y+lengthdir_y(18+speed,gunangle);
motion_set(gunangle-180,5)//se kuritee

with instances_matching_ne(hitme,"team",team)
{
	if point_distance(_x,_y,x,y)<=18
	{
		if instance_is(self,SuperFrog){instance_destroy(); continue}
		if projectile_canhit_melee(other)
		{
			view_shake_max_at(x,y,200)
			sleep(150)
			sound_play_pitchvol(sndHammerHeadEnd,random_range(1.23,1.33),20)
			sound_play_pitchvol(sndBasicUltra,random_range(0.9,1.1),20)
			sound_play_pitch(sndCoopUltraA,random_range(3.8,4.05))
			if "my_health" in self my_health -= 25
		}
		motion_add(-point_direction(x,y,other.x,other.y),speed*2)
		with instance_create(x,y,CaveSparkle){image_xscale=2;image_yscale=2;image_angle=random(359);depth=-3}
	}
}
with Wall if point_distance(_x,_y,x,y)<=18 {
    instance_create(x,y,FloorExplo)
    instance_destroy()
}
repeat(6)
{
	with instance_create(x+lengthdir_x(8+speed,gunangle),y+lengthdir_y(8+speed,gunangle),Dust){motion_add(other.gunangle+random_range(-2,2),random_range(2,8))}
}
sleep(1)
repeat(40)
{
	with instance_create(_x,_y,ToxicGas)
	{
		motion_add(other.gunangle+random_range(-50,50)*other.accuracy,random_range(1.34,1.43))
		if place_meeting(x,y,Wall) instance_destroy()
	}
}

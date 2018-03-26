//god this is so stupid but i like the polish
//add some indicator for the sweetspot stupid
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
return 3
#define weapon_area
return 11
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
#define weapon_fire
weapon_post(6,0,32)
motion_set(gunangle-180,5)//se kuritee
sound_play_pitch(sndToxicBoltGas,.7)
sound_play_pitch(sndToxicBarrelGas,1.4)
sound_play_pitch(sndToxicLauncher,random_range(.46,.54))
with instance_create(x+lengthdir_x(18,gunangle),other.y+lengthdir_y(18,gunangle),CustomObject){image_xscale=2;image_yscale=image_xscale;sprite_index=mskNone;depth=-3;on_draw = blast_draw}
with enemy
{
	if point_in_circle(x,y,other.x+lengthdir_x(18,other.gunangle),other.y+lengthdir_y(18,other.gunangle),18)
	{
		if self = SuperFrog{instance_destroy()}
		if self = Exploder{instance_destroy()}
		projectile_hit(self,25,20,other.gunangle)
		motion_add(-point_direction(x,y,other.x,other.y),speed*2)
		sleep(40)
		sound_play_pitchvol(sndHammerHeadEnd,random_range(1.23,1.33),20)
		sound_play_pitchvol(sndBasicUltra,random_range(0.9,1.1),20)
		view_shake_max_at(x,y,64)
		with instance_create(x,y,CaveSparkle){image_xscale=2;image_yscale=2;image_angle=random(359);depth=-3}
	}
}
with projectile
{
	if team != other.team && team > -10
	if self != ToxicGas
	if point_in_circle(x,y,other.x+lengthdir_x(24,other.gunangle),other.y+lengthdir_y(24,other.gunangle),24)
	{
		view_shake_max_at(x,y,20)
		with instance_create(x,y,CaveSparkle){image_xscale=2;image_yscale=2;image_angle=random(359);depth=-3}
		instance_destroy()
		sleep(5)
	}
}
with prop
{
	if point_in_circle(x,y,other.x+lengthdir_x(18,other.gunangle),other.y+lengthdir_y(18,other.gunangle),18)
	{
		projectile_hit(self,25,20,other.gunangle)
		sleep(10)
		sound_play_pitchvol(sndHammerHeadEnd,random_range(1.23,1.33),20)
		view_shake_max_at(x,y,20)
		with instance_create(x,y,CaveSparkle){image_xscale=2;image_yscale=2;image_angle=random(359);depth=-3}
	}
}
with Wall
{
	if point_in_circle(x,y,other.x+lengthdir_x(16,other.gunangle),other.y+lengthdir_y(16,other.gunangle),16)
	{
		instance_create(x,y,FloorExplo)
		instance_destroy()
	}
}
/*repeat(6)
{
	with instance_create(x+lengthdir_x(8+speed,gunangle),y+lengthdir_y(8+speed,gunangle),Dust){motion_add(other.gunangle+random_range(-2,2),random_range(2,8))}
}*/
sleep(1)
repeat(40)
{
	with instance_create(x,y,ToxicGas)
	{
		team = -10
		move_contact_solid(other.gunangle,(sprite_width+sprite_height)/2+other.speed+speed+4)
		motion_add(other.gunangle+random_range(-12,12)*other.accuracy,random_range(1.34,1.52))
	}
}

#define blast_draw
draw_set_blend_mode(bm_add);
draw_set_alpha(.2);
//draw_self()
draw_circle_colour(x,y,18*image_xscale,c_white,c_white,false)
draw_set_blend_mode(bm_normal);
draw_set_alpha(1);
image_xscale/=1.5
image_alpha = 0
image_yscale=image_xscale
if image_xscale<= .05{instance_destroy()}

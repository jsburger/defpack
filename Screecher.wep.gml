#define init
global.sprScreecher = sprite_add_weapon("sprites/sprScreecher.png", 9, 5);

#define weapon_name
return "SCREECHER"

#define weapon_sprt
return global.sprScreecher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 16;

#define weapon_cost
return 5;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 14;

#define weapon_melee
return 0;

#define weapon_text
return "AAAAAAAAAAHHHHHHHH";

#define weapon_fire
sound_play_pitch(sndScorpionFireStart,1.5)
sound_play_pitch(sndToxicBoltGas,1.7)
sound_play_pitch(sndUltraGrenade,1.6)
sound_play_pitch(sndUltraShotgun,.6)
sound_play_pitch(sndHyperLauncher,random_range(.1,.2))
weapon_post(6,0,1)
repeat(8){with instance_create(x,y,Dust){motion_add(other.gunangle+random_range(-4,4),random_range(4,10));flag = "true";team = other.team;mask_index = mskBullet1}}
with instance_create(x,y,CustomObject)
{
	team = other.team
	move_contact_solid(other.gunangle,16)
	motion_add(other.gunangle+random_range(-8,8)*other.accuracy,9)
	mask_index = sprGrenade
	sprite_index = sprTrapFire
	image_speed = 0
	image_xscale = 2
	image_yscale = 2
	bounce = 6
	timer = 4
	on_step = bounce_step
}

#define bounce_step
image_angle += 7
if bounce <= 0{instance_destroy();exit}
with instance_create(x,y,BoltTrail)
{
	image_blend = c_white
	image_angle = other.direction
	image_yscale = 2
	image_xscale = other.speed
}
timer -= current_time_scale
if timer <= 0
{
	timer = 4
	with mod_script_call("mod","defpack tools","create_sonic_explosion",x,y)
	{
		damage = 8
		image_speed = 0.4
		image_xscale = .2
		image_yscale = .2
		team = other.team
		repeat(10){ with instance_create(x,y,Dust) {motion_add(random(360),7)}}
	}
}
if place_meeting(x+hspeed,y,Wall)
{
	bounce--
	hspeed*=-1
	with mod_script_call("mod","defpack tools","create_sonic_explosion",x,y)
	{
		damage = 8
		image_speed = 0.4
		image_xscale = .4
		image_yscale = .4
		team = other.team
		repeat(10){ with instance_create(x,y,Dust) {motion_add(random(360),7)}}
		sound_play_pitch(sndPlasmaBigExplodeUpg,.6)
	}
}
if place_meeting(x,y+vspeed,Wall)
{
	bounce--
	vspeed*=-1
	with mod_script_call("mod","defpack tools","create_sonic_explosion",x,y)
	{
		damage = 8
		image_speed = 0.4
		image_xscale = .4
		image_yscale = .4
		team = other.team
		repeat(10){ with instance_create(x,y,Dust) {motion_add(random(360),7)}}
		sound_play_pitch(sndPlasmaBigExplodeUpg,.6)
	}
}
with enemy
{
	if point_in_circle(x,y,other.x,other.y,16)
	{
		if projectile_canhit_melee(self)
		with other
		{
			with mod_script_call("mod","defpack tools","create_sonic_explosion",x,y)
			{
				damage = 8
				image_speed = 0.4
				image_xscale = .4
				image_yscale = .4
				team = other.team
				repeat(10){ with instance_create(x,y,Dust) {motion_add(random(360),7)}}
				sound_play_pitch(sndPlasmaBigExplodeUpg,.6)
			}
		}
	}
}

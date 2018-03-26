#define init
global.sprDefender = sprite_add_weapon("sprDefender.png", 9, 4);
global.sprDefenderOff = sprite_add_weapon("sprDefenderOff.png", 9, 4);

#define weapon_name
return "DEFENDER"

#define weapon_sprt
with(GameCont)
{
	if "rad" in self && rad >= 3 {return global.sprDefender};
	else {return global.sprDefenderOff};
}
#define weapon_melee
return false;

#define weapon_type
return 0;

#define weapon_rads
return  6;

#define weapon_auto
return true;

#define weapon_load
return 9;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 15;

#define weapon_text
return "KEEP YOUR DISTANCE";

#define weapon_fire


with instance_create(x,y,GuardianDeflect)
{
	creator = other
	damage = 5
	team = other.team
	image_index = 0
	iamge_speed = .75
	on_step = def_step
}
repeat(3)
{
	sound_play_pitch(sndDogGuardianLand,random_range(.3,.5))
	sound_play_pitch(sndGuardianFire,random_range(.6,.7))
	weapon_post(6,-5,3)
	with instance_create(x,y,HorrorBullet)
	{
		if instance_exists(other){creator = other}else{instance_destroy();exit}
		dir = choose(-1,1)
		timer = room_speed * 4
		team = other.team
		image_index = 0
		damage *= 2
		speed = random_range(15,17)
		direction = (other.gunangle+(random_range(-10,10)* other.accuracy))
		image_angle = direction
	}
wait(3)
}

#define def_step
if !instance_exists(creator){instance_destroy();exit}
if image_index >= 6{instance_destroy()}

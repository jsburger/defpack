#define init
global.sprUltraClaymore = sprite_add_weapon("sprites/Ultra Claymore.png", 2, 6);
global.sprUltraClaymoreOff = sprite_add_weapon("sprites/Ultra Claymore Off.png", 2, 6);
global.sprUltraMegaSlash = sprite_add("sprites/projectiles/Ultra Mega Slash.png",3,36,36)
global.sprNotsoMegaSlash = sprite_add("sprites/projectiles/Not so Mega Slash.png",3,36,36)

#define weapon_name
return "ULTRA CLAYMORE";

#define weapon_sprt
with(GameCont)
{
	if "rad" in self && rad >= 7 {return global.sprUltraClaymore};
	else {return global.sprUltraClaymoreOff};
}
#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 17;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return -1;

#define weapon_text
return "MASTER OF CLAYMORES";

#define weapon_melee
return 1;

#define weapon_fire

sound_play(sndBlackSword)
weapon_post(10,17,8)
with instance_create(x+lengthdir_x(15,gunangle),y+lengthdir_y(15,gunangle),Slash)
{
	damage = 30
	mask_index = mskMegaSlash
	creator = other
	team = other.team
	motion_add(creator.gunangle, 2 + (skill_get(13) * 3))
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	if GameCont.rad >= 7{
		sound_play(sndUltraShovel)
		on_wall = muslash_wall
		GameCont.rad -= 7
		damage += 20
		sprite_index = global.sprUltraMegaSlash
		if other.ammo[4] >=2 {
			sound_play(sndUltraGrenade)
			with instance_create(x+lengthdir_x(10,creator.gunangle),y+lengthdir_y(10,creator.gunangle),CustomObject)
			{
				creator = other.creator
				team = other.team
				motion_add(other.direction,22)
				on_step = UClaymore_step
				mask_index = sprGrenade
				image_alpha = 0
				explosive = GreenExplosion
			}
			sound_play(sndExplosion)
			if other.infammo <= 0 {other.ammo[4] -= 2}
		}
	}
	else
	{
		direction = creator.gunangle
		sprite_index = global.sprNotsoMegaSlash
		if other.ammo[4] >=2 {
			with instance_create(x+lengthdir_x(10,creator.gunangle),y+lengthdir_y(10,creator.gunangle),CustomObject)
			{
				creator = other.creator
				team = other.team
				mask_index = sprGrenade
				image_alpha = 0
				explosive = Explosion
				on_step = UClaymore_step
			}
			sound_play(sndExplosion)
			if other.infammo <= 0 {other.ammo[4] -= 2}
		}
	}
	image_angle = direction
  }
wepangle = -wepangle
motion_add(gunangle,5)

#define UClaymore_step
dir = 0
timer = 42
do
{
	dir += 1 x += lengthdir_x(1,direction) y += lengthdir_y(1,direction)
	if timer > 0 timer--
	else
	{
		timer = 42
		if !place_meeting(x,y,Explosion)
		{
			instance_create(x+random_range(-7,7),y+random_range(-7,7),explosive)
		}
	}
}
while instance_exists(self) and !place_meeting(x,y,Wall) and !place_meeting(x,y,enemy) and dir < 1000
instance_destroy()

#define muslash_wall
with other{instance_create(x,y,FloorExplo);instance_destroy()};

#define init
global.sprHeavyToxicCrossbow = sprite_add_weapon("sprites/Heavy Toxic Crossbow.png", 3, 4);
global.sprHeavyToxicBolt = sprite_add("sprites/projectiles/heavy toxic bolt.png",2, 8, 8);

#define weapon_name
return "HEAVY TOXIC CROSSBOW"

#define weapon_sprt
return global.sprHeavyToxicCrossbow;

#define weapon_type
return 3;

#define weapon_auto
return false;

#define weapon_load
return 42;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 10;

#define weapon_text
return choose("FILL THE AIR WITH GREEN GOODNESS","PROBABLY NOT A GOOD IDEA");

#define weapon_fire
weapon_post(10,-25,6)
sound_play(sndHeavyCrossbow)
with instance_create(x,y,HeavyBolt)
{
	team = other.team
	creator = other
	damage = 35
	timer = 7
	timer2 = 11
	image_xscale *= 1
	image_yscale *= 1
	motion_add(other.gunangle,11)
	sprite_index = global.sprHeavyToxicBolt
	image_angle = direction
	do
	{
		if image_index = 1{image_speed = 0}
		timer -= 1
		if timer <= 0 && speed > 0
		{
			repeat(2)
			{
				instance_create(x,y,ToxicGas)
			}
		}
		if speed <= 0
		{
			timer2 -= 1
			if timer2 <= 0
			{
				sound_play(sndToxicBoltGas)
				repeat(35)
				{
					with instance_create(x,y,ToxicGas)
					{
						direction = random(359)
						speed += random_range(0.3,1)
					}
				}
			instance_destroy()
			}
		}
		wait(1)
	}while(instance_exists(self))
}

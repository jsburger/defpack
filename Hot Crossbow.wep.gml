#define init
global.sprFireCrossbow = sprite_add_weapon("Fire Crossbow.png", 2, 3);
global.sprFireBolt = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABUAAAAFCAYAAACqwacNAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABISURBVChTY3BoYKAIQ8F/KIaI/f8PZsMEycb/366FscHgvzcPExwf0mLAwH8sMPH/JfwIfBqKYQbTxKXoYUQqhgK4gQ4NDAwALrZ6eop9sYUAAAAASUVORK5CYIIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",0, -2, 3);

#define weapon_name
return "HOT CROSSBOW"

#define weapon_sprt
return global.sprFireCrossbow;

#define weapon_type
return 3;

#define weapon_auto
return false;

#define weapon_load
return 28;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 6;

#define weapon_text
return "SUPER HOT";

#define weapon_fire

	sound_play(sndCrossbow)
	weapon_post(7,-13,5)
	repeat(8)
	{
		with instance_create(x+lengthdir_x(20,gunangle),y+lengthdir_y(20,gunangle),Flame)
		{
			motion_add(other.gunangle+random_range(-80,80),random_range(1,1.7))
			team = other.team
			image_xscale *=.8
			image_yscale *=.8
		}
	}
	with instance_create(x,y,Bolt)
	{
		sprite_index = global.sprFireBolt
		team = other.team
		check = 0
		creator = other
		motion_add(other.gunangle,19)
		damage = 12
		image_angle = direction
		if fork(){
			while(instance_exists(self)){
				image_angle = direction
					if speed <= 0 || place_meeting(x + hspeed,y + vspeed,enemy)
					{
						sprite_index = mskNothing
						if check = 0
						{
							check = 1
							sound_play(sndFlareExplode)
							instance_create(x+lengthdir_x(10,direction),y+lengthdir_y(10,direction),SmallExplosion)
							with instance_create(x + hspeed,y + vspeed,Flare)
							{
								team = other.team
								instance_destroy()
							}
						}
					}
					else
					{
						repeat(5)
						{
							with instance_create(x+lengthdir_x(random_range(0,10),direction-180),y+lengthdir_y(random_range(0,10),direction-180),Flame)
							{
								team = other.team
								image_xscale *=.8
								image_yscale *=.8
							}
						}
					}
				wait(1)
			}
			exit
		}
	}

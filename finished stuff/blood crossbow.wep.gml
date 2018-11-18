#define init
global.sprBloodCrossbow = sprite_add_weapon("sprBloodCrossbow.png", 6, 3);
global.sprBloodBolt = sprite_add("sprBloodBolt.png",0, -2, 3);

#define weapon_name
return "BLOOD CROSSBOW"

#define weapon_sprt
return global.sprBloodCrossbow;

#define weapon_type
return 3;

#define weapon_auto
return true;

#define weapon_load
return 21;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 7;

#define weapon_text
return choose("BONE LAUNCHER","THE BONE ZONE");

#define weapon_fire
if infammo <= 0{
	if ammo[3] - 1 < 0{
		ammo[3] = 0;
		sprite_index = spr_hurt;
		image_index = 0;
		my_health --;
		sound_play(sndBloodHurt);
		lasthit = [global.sprBloodCrossbow,"Blood Crossbow"]
		sound_play(snd_hurt);
	}
	else
	{
		ammo[3] -= 1
		var _p = random_range(.8,1.2)
		sound_play_pitchvol(sndHeavyCrossbow,.8*_p,.6)
		sound_play_pitchvol(sndBloodHammer,1.2*_p,.6)
	}
}
weapon_post(5,-40,0)
with instance_create(x,y,Bolt)
{
	team = other.team
	check = 0
	creator = other
	motion_add(other.gunangle,24)
	sprite_index = global.sprBloodBolt
	damage = 17
	with instance_create(x,y,BoltTrail)
	{
		image_blend = c_red
		image_angle = other.direction
		image_yscale = 1.4
		image_xscale = other.speed
	}
	with instance_create(x+hspeed*1.5,y+vspeed*1.5,BloodStreak)
	{
		image_angle = other.direction
	}
	if fork(){
		do
		{
			with instance_create(x,y,BoltTrail)
			{
				image_blend = c_red
				y += other.vspeed
				x += other.hspeed
				image_angle = point_direction(xprevious,yprevious,x,y)
				image_xscale = point_distance(xprevious,yprevious,x,y)
				image_yscale = 1.4
			}
			image_angle = direction
				if speed <= 0 || place_meeting(x+hspeed,y+vspeed,enemy)
				{
					if check = 0
					{
						check = 1
						sound_play(sndBloodLauncherExplo)
						instance_create(x +hspeed,y +vspeed,MeatExplosion)
						if !instance_exists(other){exit}
						team = other.team
					}
				}
			wait(1)
		}while(instance_exists(self))
	}
}

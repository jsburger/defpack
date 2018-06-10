#define init
global.sprBulletFlakCannon = sprite_add_weapon("sprites/Bullet Flak Cannon.png", 3, 3);

#define weapon_name
return "BULLAK CANNON"

#define weapon_sprt
return global.sprBulletFlakCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 36;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 5;

#define weapon_text
return " 90/100";

#define weapon_fire

repeat(5)
{
	with instance_create(x,y,Shell)
	{
		motion_add(point_direction(x,y,mouse_x,mouse_y)+other.right*100+random(50)-25,2+random(5))
	}
}
sound_play_pitch(sndPistol,random_range(0.7,0.8))
sound_play_pitch(sndGrenadeRifle,random_range(1.1,1.3))
sound_play_pitch(sndFlakCannon,random_range(1.1,1.3))
weapon_post(6,-4,5)
mod_script_call("mod", "defpack tools 2","create_flak",0,22,13,0,Bullet1,10,id) //not gonna lie this shit spooks the fuck outta me, i swear somethings gonna go wrong

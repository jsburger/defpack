#define init
global.sprGoldenBullakCannon = sprite_add_weapon("sprites/sprGoldenBullakCannon.png", 3, 3);

#define weapon_gold
return 1;

#define weapon_name
return "GOLDEN BULLAK CANNON"

#define weapon_sprt
return global.sprGoldenBullakCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 28;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 17;

#define weapon_text
return "@yAU VULKANADER";

#define weapon_fire

repeat(6){
	with instance_create(x,y,Shell){
		motion_add(other.gunangle+other.right*100+random(50)-25,2+random(5))
	}
}
sound_play_pitch(sndGoldGrenade,random_range(1.1,1.3))
sound_play_pitch(sndFlakCannon,random_range(1.1,1.3))
weapon_post(6,4,5)
mod_script_call("mod", "defpack tools 2","create_flak",0,9,13,0,Bullet1,10,id)

#define init
global.sprLuckyMachinegun = sprite_add_weapon("Lucky Machinegun.png", 3, 1);
global.sprLuckyBullet = sprite_add("Lucky Bullet.png",2,8,8)

#define weapon_name
return "LUCKY MACHINEGUN";

#define weapon_sprt
return global.sprLuckyMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 3;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 11;

#define weapon_text
return choose("7...7....","THE RICH GET RICHER");

#define weapon_fire

with instance_create(x,y,Shell)
	{
		motion_add(other.gunangle+other.right*100+random(50)-25,2+random(5))
	}
weapon_post(5,-6,6)
sound_play_pitch(sndGoldMachinegun,random_range(0.9,1.1))
sound_play_pitch(sndSnowTankShoot,random_range(1.2,1.3))
with instance_create(x,y,Bullet1)
{
	if !irandom(14){lucky = 1;sprite_index = global.sprLuckyBullet}else{lucky = 0}
	team = other.team
	creator = other
	motion_add(other.gunangle + (random_range(-6,6) * other.accuracy),20)
	image_angle = direction
	if fork(){
		while(instance_exists(self)){

			if lucky = 1 {if irandom(1) = 0{with instance_create(x,y,CaveSparkle){image_angle = random(359)}}}
			if place_meeting(x+ hspeed,y+ vspeed,enemy) && instance_exists(creator) && lucky = 1
			{
				with creator
				{
					sound_play(sndLuckyShotProc)
					instance_create(x,y,SteroidsTB)
					var type = choose(1,2,3,4,5)
					ammo[type] += round(typ_ammo[type]/2)
					if ammo[type] > typ_amax[type]
					{
						ammo[type] = typ_amax[type]
					}
					var dir = instance_create(x,y,PopupText)
					dir.mytext = "+"+string(round(typ_ammo[type]/2))+" "+string(typ_name[type])
					dir.target = index
					if ammo[type] = typ_amax[type]
					{
						dir.mytext = "MAX "+string(typ_name[type])
					}
				}
			}
			wait(1)
		}
		exit
	}
}

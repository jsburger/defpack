#define init
global.sprHeavyAbrisLauncher  = sprite_add_weapon("sprites/sprHeavyAbrisLauncher.png", 1, 3);
global.stripes 								= sprite_add("defpack tools/BIGstripes.png",1,1,1)
global.sprSmallGreenExplosion = sprite_add("sprites/projectiles/Small Green Explosion_strip7.png",7,12,12)
#define weapon_name
return "HEAVY ABRIS LAUNCHER"

#define weapon_sprt
return global.sprHeavyAbrisLauncher;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 29;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 11;

#define weapon_text
return "THEY WON'T SEE THAT ONE COMIN'";

#define weapon_fire
var _strtsize = 50-skill_get(13)*7;
var _endsize  = 44;
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
accspeed = 1.05
payload = script_ref_create(pop)
lasercolour1 = c_lime
lasercolour = lasercolour1
lasercolour2 = c_green
}
sound_play_pitch(sndSniperTarget,exp((_strtsize-_endsize)/room_speed/current_time_scale/accuracy*(1.05)))

#define pop
sound_play_pitch(sndGrenadeRifle,random_range(.5,.7))
sound_play(sndExplosion)
creator.wkick = 8
repeat(3)
{
	with instance_create(mouse_x[index]+lengthdir_x(acc+12,offset),mouse_y[index]+lengthdir_y(acc+12,offset),GreenExplosion)
	{
		hitid = [sprite_index,"Green Explosion"]
	}
	offset += 120
}
repeat(3)
{
	with instance_create(mouse_x[index]+lengthdir_x(acc+4,offset+45),mouse_y[index]+lengthdir_y(acc+4,offset+45),SmallExplosion)
	{
		sprite_index = global.sprSmallGreenExplosion
		hitid = [sprite_index,"Small Green
		Explosion"]
	}
	offset += 120
}

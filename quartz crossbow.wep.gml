#define init
global.sprQuartzCrossbow = sprite_add_weapon("sprites/sprQuartzCrossbow.png", 11, 6);
global.sprQuartzBolt 	   = sprite_add("sprites/projectiles/sprQuartzBolt.png",0, 13, 4);
global.mskQuartzBolt 	   = sprite_add("sprites/projectiles/mskQuartzBolt.png",0, 6, 8);
global.sprHud = sprite_add("sprites/sprQuartzCrossbowHud.png", 1, 11, 4)

#define weapon_name
return "QUARTZ CROSSBOW"

#define weapon_sprt_hud
return global.sprHud

#define weapon_sprt
return global.sprQuartzCrossbow;

#define weapon_type
return 3;

#define weapon_auto
return false;

#define weapon_load
return 27;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 14;

#define weapon_text
return choose("BREAKTHROUGH","BE CAREFUL WITH IT");

#define weapon_fire
weapon_post(12,-150,16)
sleep(50)
sound_play_pitch(sndHeavyCrossbow,random_range(.6,.8))
sound_play_pitch(sndLaserCrystalHit,random_range(1.5,1.6))
sound_play_pitch(sndHyperCrystalHurt,random_range(1.5,1.6))
sound_play_pitchvol(sndLaserCrystalDeath,random_range(1.6,2),.5)
with instance_create(x+lengthdir_x(6,gunangle),y+lengthdir_y(6,gunangle),HeavyBolt)
{
	team = other.team
	creator = other
	sprite_index = global.sprQuartzBolt
	mask_index   = global.mskQuartzBolt
	damage = 60
	motion_add(other.gunangle,30)
	image_angle = direction
	repeat(3) with instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust){sprite_index = sprExtraFeetDust}
}

#define step
mod_script_call("mod","defpack tools","quartz_penalty",mod_current)

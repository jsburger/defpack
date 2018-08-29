#define init
global.sprQuartzCrossbow = sprite_add_weapon("sprites/sprQuartzCrossbow.png", 11, 6);
global.sprQuartzBolt 	   = sprite_add("sprites/projectiles/sprQuartzBolt.png",0, 13, 4);
global.mskQuartzBolt 	   = sprite_add("sprites/projectiles/mskQuartzBolt.png",0, 6, 8);

#define weapon_name
return "QUARTZ CROSSBOW"

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
return choose("BREAKTHROUGH");

#define weapon_fire
weapon_post(10,-25,6)
sound_play_pitch(sndHeavyCrossbow,random_range(.6,.8))
sound_play_pitch(sndLaserCrystalHit,random_range(1.5,1.6))
sound_play_pitch(sndHyperCrystalHurt,random_range(1.5,1.6))
sound_play_pitchvol(sndLaserCrystalDeath,random_range(1.6,2),.5)
with instance_create(x+lengthdir_x(6,gunangle),y+lengthdir_y(6,gunangle),HeavyBolt)
{
	sprite_index = global.sprQuartzBolt
	mask_index   = global.mskQuartzBolt
	damage = 60
	motion_add(other.gunangle + random_range(-1,1)*other.accuracy,30)
	image_angle = direction
	repeat(3) with instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust){sprite_index = sprExtraFeetDust}
}

#define step
if lsthealth > my_health
{
  if wep  = mod_current{sound_play_pitch(sndHyperCrystalHurt,.8);sound_play_pitch(sndLaserCrystalHit,.7);sleep(50);view_shake_at(x,y,12);wep = 0}
  if bwep = mod_current{sound_play_pitch(sndHyperCrystalHurt,.8);sound_play_pitch(sndLaserCrystalHit,.7);sleep(50);view_shake_at(x,y,12);bwep = 0}
}

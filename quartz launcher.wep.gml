#define init
global.sprQuartzLauncher = sprite_add_weapon("sprites/sprQuartzLauncher.png", 7, 4);
global.sprQuartzGrenade  = sprite_add("sprites/projectiles/sprQuartzGrenade.png",0,4,4);

#define weapon_name
return "QUARTZ LAUNCHER";

#define weapon_sprt
return global.sprQuartzLauncher;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 22;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return -1;

#define weapon_reloaded
sound_play(sndNadeReload)

#define weapon_text
return "replace me please";

#define weapon_fire
sound_play_pitch(sndHeavyNader,random_range(1.3,1.5))
sound_play_pitch(sndLaserCrystalHit,random_range(1.2,1.3))
sound_play_pitchvol(sndLaserCrystalDeath,random_range(1.6,2),.5)
weapon_post(8,-4,22)
with instance_create(x,y,CustomProjectile)
{
	sprite_index = global.sprQuartzGrenade
	damage = 12
	force = 3
	friction = 1
	motion_add(other.gunangle+random_range(-4,4)*other.accuracy,24)
	image_angle = direction
	lifetime = 20
	pierce = 1
	image_speed = .5
	lasthit = -4
	team = other.team
	creator = other
	repeat(round(12)){ with instance_create(x,y,Dust) {motion_add(other.creator.gunangle,random_range(4,7));sprite_index = sprExtraFeetDust}}
	on_hit  	 = quartznade_hit
	on_wall 	 = quartznade_wall
	on_step 	 = quartznade_step
	on_destroy = quartznade_destroy
}

#define quartznade_hit
if projectile_canhit_melee(other) = true && lasthit != other
{
  sleep(10)
  view_shake_at(x,y,10)
  projectile_hit(other,damage,force,direction)
  pierce-= other.size
  lasthit = other
	with mod_script_call("mod","defpack tools","create_sonic_explosion",x,y)
	{
		var scalefac = .25
		image_xscale = scalefac
		image_yscale = scalefac
		damage = 6
		image_speed = 1
		team = other.team
		creator = other.creator
		repeat(5){ with instance_create(x,y,Dust) {motion_add(random(360),3);sprite_index = sprExtraFeetDust}}
	}
	if other.my_health-6 > 0 {instance_destroy();exit}
}
if pierce < 0{instance_destroy()}

#define quartznade_wall
with instance_create(x,y,Dust){motion_add(direction+random_range(-8,8)-180,3);sprite_index = sprExtraFeetDust}
move_bounce_solid(false)
direction += random_range(-5,5)
speed *= .6
with mod_script_call("mod","defpack tools","create_sonic_explosion",x,y)
{
	var scalefac = .25
	image_xscale = scalefac
	image_yscale = scalefac
	damage = 3
	image_speed = 1
	team = other.team
	creator = other.creator
	repeat(5){ with instance_create(x,y,Dust) {motion_add(random(360),3);sprite_index = sprExtraFeetDust}}
}
image_angle = direction
sound_play_pitchvol(sndGrenadeHitWall,random_range(.8,1.2),.5)
sound_play_pitch(sndLaserCrystalHit,random_range(1.2,1.4))
with instance_create(x,y,Dust){motion_add(direction+random_range(-8,8)-180,3);sprite_index = sprExtraFeetDust}
instance_create(x,y,WepSwap){image_angle = random(360)}

#define quartznade_step
if speed <= 0{lifetime -= current_time_scale}
if lifetime <= 10 sprite_index = sprHeavyGrenadeBlink
if lifetime <= 0{instance_destroy()}

#define quartznade_destroy
var i = random(360);
sleep(20)
view_shake_at(x,y,15)
repeat(3)
{
	with mod_script_call("mod","defpack tools","create_sonic_explosion",x+lengthdir_x(16,i),y+lengthdir_y(20,i))
	{
		instance_create(x,y,WepSwap){image_angle = random(360)}
		var scalefac = .75
		image_xscale = scalefac
		image_yscale = scalefac
		damage = 8
		image_speed = 0.75
		team = other.team
		creator = other.creator
		sound_play(sndExplosion)
		repeat(round(scalefac*10)){ with instance_create(x,y,Dust) {motion_add(random(360),3);sprite_index = sprExtraFeetDust}}
	}
	i += 120
}

#define step
if lsthealth > my_health
{
  if wep  = mod_current{sound_play_pitch(sndHyperCrystalHurt,.8);sound_play_pitch(sndLaserCrystalHit,.7);sleep(50);view_shake_at(x,y,12);wep = 0}
  if bwep = mod_current{sound_play_pitch(sndHyperCrystalHurt,.8);sound_play_pitch(sndLaserCrystalHit,.7);sleep(50);view_shake_at(x,y,12);bwep = 0}
}

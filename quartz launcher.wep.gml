#define init
global.sprQuartzLauncher  = sprite_add_weapon("sprites/weapons/sprQuartzLauncher.png" , 7, 4);
global.sprQuartzLauncher1 = sprite_add_weapon("sprites/weapons/sprQuartzLauncher1.png", 7, 4);
global.sprQuartzLauncher2 = sprite_add_weapon("sprites/weapons/sprQuartzLauncher2.png", 7, 4);
global.sprQuartzGrenade  = sprite_add("sprites/projectiles/sprQuartzGrenade.png",0,4,4);
global.sprHud 			  = sprite_add("sprites/interface/sprQuartzLauncherHud.png" , 1, 7, 4);
global.sprHud1 			  = sprite_add("sprites/interface/sprQuartzLauncherHud1.png", 1, 7, 4);
global.sprHud2 			  = sprite_add("sprites/interface/sprQuartzLauncherHud2.png", 1, 7, 4);
global.sprGlassShard  = sprite_add("sprites/other/sprGlassShard.png",5,4,4)
global.sprSonicStreak = sprite_add("sprites/projectiles/sprSonicStreak.png",6,8,32);

#define weapon_name
return "QUARTZ LAUNCHER";

#define weapon_sprt(wep)
	if is_object(wep){
	  switch wep.health{
	    default: return global.sprQuartzLauncher;
	    case 1: return global.sprQuartzLauncher1;
	    case 0: return global.sprQuartzLauncher2;
	  }
	}
	return global.sprQuartzLauncher;

#define weapon_sprt_hud(wep)
	if is_object(wep){
	  switch wep.health{
	    default: return global.sprHud;
	    case 1: return global.sprHud1;
	    case 0: return global.sprHud2;
	  }
	}
	return global.sprHud;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 22;

#define weapon_cost
return 1;

#define weapon_swap(w)
if is_object(w) w.prevhealth = my_health
sound_play_pitchvol(sndHyperCrystalHurt, 1.3, .6)
return sndSwapExplosive;

#define weapon_area
return 14;

#define weapon_reloaded
sound_play(sndNadeReload)

#define weapon_text
return choose("BE CAREFUL WITH IT","ENERGIC FORTUNE TELLING");

#define weapon_fire(w)
  if !is_object(w){
      w = {
          wep: w,
          prevhealth: other.my_health,
          maxhealth: 2,
          health: 2,
          is_quartz: true
      }
      wep = w
  }
sound_play_pitch(sndHeavyNader,random_range(1.3,1.5))
sound_play_pitch(sndLaserCrystalHit,random_range(1.2,1.3))
sound_play_pitchvol(sndLaserCrystalDeath,random_range(1.6,2),.5)
weapon_post(8,-20,22)
with instance_create(x,y,CustomProjectile)
{
	typ = 1
	sprite_index = global.sprQuartzGrenade
	damage = 14
	force = 3
	friction = 1
	motion_add(other.gunangle+random_range(-4,4) * (other.accuracy + (2 - 2 * w.health/w.maxhealth)),24)
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
	if other.my_health > 0 {instance_destroy();exit}
}
if pierce < 0{instance_destroy()}

#define quartznade_wall
with instance_create(x,y,Dust){motion_add(direction+random_range(-8,8)-180,3);sprite_index = sprExtraFeetDust}
move_bounce_solid(false)
direction += random_range(-5,5)
speed *= .6
with instance_create(x, y, ImpactWrists) {image_speed = .7}
repeat(5){ with instance_create(x,y,Dust) {motion_add(random(360),3);sprite_index = sprExtraFeetDust}}

image_angle = direction
sound_play_pitchvol(sndGrenadeHitWall,random_range(.8,1.2),.5)
sound_play_pitch(sndLaserCrystalHit,random_range(1.2,1.4))
with instance_create(x,y,Dust){motion_add(direction+random_range(-8,8)-180,3);sprite_index = sprExtraFeetDust}
instance_create(x,y,WepSwap){image_angle = random(360)}

#define quartznade_step
if speed <= 0{lifetime -= current_time_scale}
if lifetime <= 10 sprite_index = sprHeavyGrenadeBlink
with Slash
{
	if place_meeting(x,y,other)
	{
		with other
		{
			view_shake_at(x,y,15)
			sleep(7)
			motion_set(other.direction,22)
			with instance_create(x,y,Deflect)
			{
				image_angle = other.direction
			}
		}
	}
}
if place_meeting(x,y,Shank){instance_destroy()}
if lifetime <= 0{instance_destroy();exit}

#define quartznade_destroy
sound_play_pitchvol(sndLaserCrystalHit,1.4,.2)
repeat(8) with instance_create(x,y,Feather)
{
	motion_add(random(360),random_range(3,6))
	sprite_index = global.sprGlassShard
	image_speed = random_range(.4,.7)
	image_index = irandom(5)
}
var i = random(360);
sleep(20)
view_shake_at(x,y,15)
repeat(3)
{
	with instance_create(x - lengthdir_x(4, i), y - lengthdir_y(4, i), Slash)
	{
		team 		= other.team;
		creator = other.creator;
		sprite_index = sprHeavySlash
		damage = 30;
		motion_set(i, 0);
		friction = 2
		image_angle = direction;
	}
	with instance_create(x+lengthdir_x(48,i+60),y+lengthdir_y(48,i+60),AcidStreak)
	{
		sprite_index = global.sprSonicStreak
		image_angle = i + 60 - 90
	}
	i += 120
}
sound_play(sndExplosion)

#define step(p)
  if p && is_object(wep){
    mod_script_call_self("mod","defpack tools","quartz_penalty",mod_current, wep, p)
    mod_script_call_self("mod","defpack tools","quartz_step", self, wep);
  }
  if !p && is_object(bwep) && race = "steroids"{
    mod_script_call_self("mod","defpack tools","quartz_penalty",mod_current, bwep, p)
    mod_script_call_self("mod","defpack tools","quartz_step", self, bwep);
  }

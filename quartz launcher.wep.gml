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
return 28;

#define weapon_cost
return 2;

#define weapon_swap(w)
if instance_is(self, Player) if is_object(w){w.prevhealth = my_health}
sound_play_pitchvol(sndHyperCrystalHurt, 1.3, .6)
return sndSwapExplosive;

#define weapon_area
return 14;

#define weapon_reloaded
sound_play(sndNadeReload)

#define weapon_text
return choose("BE CAREFUL WITH IT","ENERGIC FORTUNE TELLING");

#define nts_weapon_examine
return{
    "d": "A shiny and frail grenade launcher. #You can see a long hallway in the grenades reflections. ",
}

#define weapon_fire(w)
  if !is_object(w){
      w = {
          wep: w,
          prevhealth: other.my_health,
          maxhealth: 2,
          health: 2,
          is_quartz: true,
          shinebonus:0
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
	damage = 8
	force = 24
	friction = 1
	motion_add(other.gunangle+random_range(-4,4) * (other.accuracy + (2 - 2 * w.health/w.maxhealth)),20)
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
	if chance(speed * 2 + 10)with instance_create(x + random_range(-5, 5), y + random_range(-5, 5), WepSwap){
		image_xscale = .75
	    image_yscale = .75
	    image_speed = choose(.7,.7,.7,.45)
	}
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
		motion_add(random(360),random_range(4,7))
		sprite_index = global.sprGlassShard
		image_speed = random_range(.4,.7)
		image_index = irandom(5)
	}
	var i = random(360);
	sleep(20)
	view_shake_at(x,y,15)
	repeat(3){
		instance_create(x + lengthdir_x(24, i), y + lengthdir_y(24, i), Explosion)
		instance_create(x + lengthdir_x(48, i), y + lengthdir_y(48, i), SmallExplosion)
		i += 60
		instance_create(x + lengthdir_x(48, i), y + lengthdir_y(48, i), SmallExplosion)

		with instance_create(x+lengthdir_x(48,i+60),y+lengthdir_y(48,i+60),MeleeHitWall){
			image_angle = i + 60 - 90
		}
		i += 60
	}
	with mod_script_call("mod","defpack tools","create_sonic_explosion",x - lengthdir_x(2, direction),y - lengthdir_y(2, direction)){
		image_xscale = 1
		image_yscale = 1
		image_speed = 0.8
		team = other.team
		creator = other.creator
		repeat(12){ with instance_create(x,y,Dust) {sprite_index = sprExtraFeet; motion_add(random(360),3)}}
	}
	instance_create(x, y, SmallExplosion)
	sound_play(sndExplosion)
	sound_play_pitchvol(sndExplosionL, 1.6 * random_range(.8, 1.2), .6)

#define step(p)
  if p && is_object(wep){
    mod_script_call_self("mod","defpack tools","quartz_penalty",mod_current, wep, p)
    mod_script_call_self("mod","defpack tools","quartz_step", self, wep);
  }
  if !p && is_object(bwep) && race = "steroids"{
    mod_script_call_self("mod","defpack tools","quartz_penalty",mod_current, bwep, p)
    mod_script_call_self("mod","defpack tools","quartz_step", self, bwep);
  }

#define chance(_v) return mod_script_call("mod", "defpack tools", "chance", _v);
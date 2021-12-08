#define init
global.sprQuartzCrossbow  = sprite_add_weapon("sprites/weapons/sprQuartzCrossbow.png" , 11, 6);
global.sprQuartzCrossbow1 = sprite_add_weapon("sprites/weapons/sprQuartzCrossbow1.png", 11, 6);
global.sprQuartzCrossbow2 = sprite_add_weapon("sprites/weapons/sprQuartzCrossbow2.png", 11, 6);
global.sprQuartzBolt 	   = sprite_add("sprites/projectiles/sprQuartzBolt.png",0, 13, 4);
global.mskQuartzBolt 	   = sprite_add("sprites/projectiles/mskQuartzBolt.png",0, 6, 8);
global.sprHud  = sprite_add("sprites/interface/sprQuartzCrossbowHud.png" , 1, 11, 4);
global.sprHud1 = sprite_add("sprites/interface/sprQuartzCrossbowHud1.png", 1, 11, 4);
global.sprHud2 = sprite_add("sprites/interface/sprQuartzCrossbowHud2.png", 1, 11, 4);

#define weapon_name
return "QUARTZ CROSSBOW"

#define weapon_sprt_hud(wep)
  if is_object(wep){
    switch wep.health{
      default: return global.sprHud;
      case 1: return global.sprHud1;
      case 0: return global.sprHud2;
    }
  }
  return global.sprHud;

#define weapon_sprt(wep)
  if is_object(wep){
    switch wep.health{
      default: return global.sprQuartzCrossbow;
      case 1: return global.sprQuartzCrossbow1;
      case 0: return global.sprQuartzCrossbow2;
    }
  }
  return global.sprQuartzCrossbow;

#define weapon_type
return 3;

#define weapon_auto
return false;

#define weapon_load(w)
var _l = 24;
if is_object(w) return _l - (w.maxhealth - w.health) * 4 else return _l;

#define weapon_cost
return 1;

#define weapon_swap(w)
if instance_is(self, Player) if is_object(w){w.prevhealth = my_health}
//sound_play_pitchvol(sndLaserCrystalHit, .5, .6) really good creaky door sound
sound_play_pitchvol(sndHyperCrystalHurt, 1.3, .6)
return sndSwapBow;

#define weapon_area
return 14;

#define weapon_text
return choose("BREAKTHROUGH","BE CAREFUL WITH IT");

#define nts_weapon_examine
return{
    "d": "A shiny and frail crossbow. #The bolts never shatter. ",
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
	weapon_post(12,-40,16)
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
		damage = 35
		motion_add(other.gunangle, 26)
		image_angle = direction
		repeat(3) with instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust){sprite_index = sprExtraFeetDust}
	}

#define step(p)
  if p && is_object(wep){
    mod_script_call_self("mod","defpack tools","quartz_penalty",mod_current, wep, p)
    mod_script_call_self("mod","defpack tools","quartz_step", self, wep);
  }
  if !p && is_object(bwep) && race = "steroids"{
    mod_script_call_self("mod","defpack tools","quartz_penalty",mod_current, bwep, p)
    mod_script_call_self("mod","defpack tools","quartz_step", self, bwep);
  }
  with instances_matching(HeavyBolt, "sprite_index", global.sprQuartzBolt){
	if chance(speed * 2 + 15)with instance_create(x + random_range(-8, 8), y + random_range(-8, 8), WepSwap){
		image_xscale = .75
	    image_yscale = .75
	    image_speed = choose(.7,.7,.7,.45)
	}
  }
#define chance(_v) return mod_script_call("mod", "defpack tools", "chance", _v);

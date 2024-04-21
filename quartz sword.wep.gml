#define init
global.sprQuartzSword  = sprite_add_weapon("sprites/weapons/sprQuartzSword.png" , 3, 6);
global.sprQuartzSword1 = sprite_add_weapon("sprites/weapons/sprQuartzSword1.png", 5, 6);
global.sprQuartzSword2 = sprite_add_weapon("sprites/weapons/sprQuartzSword2.png", 5, 6);
global.sprHeavyQuartzSlash = sprite_add("sprites/projectiles/sprHeavyQuartzSlash.png", 3, 0, 24);
global.sprQuartzSlash      = sprite_add("sprites/projectiles/sprQuartzSlash.png"     , 3, 0, 24);
global.sprWeakQuartzSlash  = sprite_add("sprites/projectiles/sprWeakQuartzSlash.png" , 3, 0, 12);
global.sprHud  = sprite_add("sprites/interface/sprQuartzSwordHud.png" , 1, 3, 5);
global.sprHud1 = sprite_add("sprites/interface/sprQuartzSwordHud1.png", 1, 3, 5);
global.sprHud2 = sprite_add("sprites/interface/sprQuartzSwordHud2.png", 1, 3, 5);

#define weapon_name
return "QUARTZ SWORD"

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
      default: return global.sprQuartzSword;
      case 1: return global.sprQuartzSword1;
      case 0: return global.sprQuartzSword2;
    }
  }
  return global.sprQuartzSword;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load(wep)
  if is_object(wep){
    switch wep.health{
      case 2: return 17;
      case 1: return 14;
      case 0: return 10;
    }
  }
  return 20;

#define weapon_cost
return 0;

#define weapon_swap(w)
if instance_is(self, Player) if is_object(w){w.prevhealth = my_health}
//sound_play_pitchvol(sndLaserCrystalHit, .5, .6) good creaky door sound
sound_play_pitchvol(sndHyperCrystalHurt, 1.3, .6)
return sndSwapSword;

#define weapon_melee
return true;

#define weapon_area
return 14;

#define weapon_text
return choose("THEIR METHODS REMAIN SECRET","BE CAREFUL WITH IT");

#define nts_weapon_examine
return{
    "d": "A shiny and frail sword. #It's surprisingly light. ",
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
	weapon_post(6,15 + w.health * 7.5,0)
  wepangle = -wepangle
	with instance_create(x+lengthdir_x(6,gunangle),y+lengthdir_y(6,gunangle),w.health > 0 ? Slash : Shank)
	{
    /*switch w.health{
      case 2:
        sprite_index = global.sprHeavyQuartzSlash;
        sound_play_pitch(sndShovel, 1.4*random_range(.8, 1.2));
        sound_play_pitch(sndScrewdriver, random_range(.7, .8));
        sound_play_pitch(sndCrystalRicochet, 3*random_range(.8, 1.2));
      	sound_play_pitch(sndHyperCrystalHurt,random_range(1.8,2));
      	sound_play_pitchvol(sndLaserCrystalDeath,random_range(1.6,2),.5);
        damage = 22
        break;
      case 1:
        sprite_index = global.sprQuartzSlash;
        sound_play_pitch(sndScrewdriver, random_range(.6, .8));
        sound_play_pitch(sndBlackSword, random_range(1.4, 1.6));
        sound_play_pitch(sndHyperCrystalHurt,random_range(1.5,1.6));
        sound_play_pitchvol(sndLaserCrystalDeath,random_range(1.6,2),.5);
        damage = 12;
        break;
      case 0:
      sprite_index = global.sprWeakQuartzSlash;
      sound_play_pitch(sndScrewdriver, random_range(.6, .8));
      sound_play_pitch(sndBlackSword, random_range(1.4, 1.6));
      sound_play_pitch(sndHyperCrystalHurt,random_range(1.5,1.6));
      sound_play_pitchvol(sndLaserCrystalDeath,random_range(1.6,2),.5);
      damage = 6;
      canfix = false;
      break;
    }*/
    sprite_index = global.sprHeavyQuartzSlash;
    sound_play_pitch(sndScrewdriver, random_range(.6, .8));
    sound_play_pitch(sndBlackSword, random_range(1.4, 1.6));
    sound_play_pitch(sndHyperCrystalHurt,random_range(1.5,1.6));
    sound_play_pitchvol(sndLaserCrystalDeath,random_range(1.6,2),.5);
    damage = 18;

		team = other.team
		creator = other
		motion_add(other.gunangle + random_range(-3, 3) * (other.accuracy), 3 + (skill_get(13) * 2))
		image_angle = direction
		repeat(3 + irandom(2)) with instance_create(x + lengthdir_x(sprite_get_width(sprite_index) * (.6 + random(.4)) + speed, direction) + random_range(-12, 12), y + lengthdir_y(sprite_get_width(sprite_index) * (.6 + random(.4)) + speed, direction) + random_range(-12, 12), WepSwap){
			image_xscale = .75
		    image_yscale = .75
		    image_speed = choose(.7,.7,.7,.45)
		}
		repeat(3) with instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust){sprite_index = sprExtraFeetDust}
	}
  //motion_add(gunangle, 4)

#define step(p)
  if p && is_object(wep){
    mod_script_call_self("mod","defpack tools","quartz_penalty",mod_current, wep, p)
    mod_script_call_self("mod","defpack tools","quartz_step", self, wep);
  }
  if !p && is_object(bwep) && race = "steroids"{
    mod_script_call_self("mod","defpack tools","quartz_penalty",mod_current, bwep, p)
    mod_script_call_self("mod","defpack tools","quartz_step", self, bwep);
  }

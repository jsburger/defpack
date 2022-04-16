#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletMaggot.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconMaggot.png", 1, 5, 5);
  
  with effect_type_create("MaggotEffect", `@(color:${c.neutral})Turns @wcorpses @(color:${c.neutral})into @yammo @(color:${c.neutral})and @rhealth#@(color:${c.neutral})so cute!`, scr.describe_whole) {
        on_step = script_ref_create(maggot_step)
    }
    
    global.effects = [
        effect_instance_named("MaggotEffect", 1, 1)
    ]
#define bullet_effects(bullet)
    return global.effects

#macro c mod_variable_get("race", "sage", "colormap");
#macro scr mod_variable_get("mod", "sageeffects", "scr");
#macro maxcorpses 12

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $AFBFD4;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "MAGGOT";

#define bullet_ttip
  if (!irandom(99)) return ":sotrue:";
  return ["*SQUIRM*", "*WRITHE*", "*WIGGLE*"];

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

//#define bullet_description(power)
//  return `@(color:${c.neutral})Turns @wcorpses @(color:${c.neutral})into @yammo @(color:${c.neutral})and @rhealth#@(color:${c.neutral})so cute!#`;
  

//#define on_take(power)
	
//#define on_lose(power)

#define maggot_step(value, effect)
	if value <= 0 exit;
	if "sage_corpses" not in self sage_corpses = 0;
	var _corpse = -4;
	with instances_matching_ne(Corpse, "sage_has_eaten", true){
	
		if (distance_to_object(other) <= 8){
			if _corpse == -4{
			
				_corpse = self;
			}else if (point_distance(_corpse.x, _corpse.y, x, y) < point_distance(_corpse.x, _corpse.y, other.x, other.y)){
			
				_corpse = self;
			}
		}
	}
	
	if(_corpse > -4){
			
			sage_corpses += 1;
			with instance_create(_corpse.x, _corpse.y, RobotEat){ 
			
				image_xscale = other.right ? 1 : -1;
				depth = other.depth + 1;
			}
			with _corpse {
			
				sage_has_eaten = true;
				sprite_index = sprScorchmark;
				image_xscale = choose(-1, 1);
			}
			
			sound_play_pitch(sndMaggotBite, 1.2 + random_range(.7, 1.3));
			sound_play_pitch(sndBigMaggotBite, .8 + random_range(.8, 1.2));
			sound_play_pitch(choose(sndRatkingChargeEnd, sndRatkingCharge), 5 * random_range(.8, 1.2));
	}
	if(sage_corpses > maxcorpses){
		
		sage_corpses -= maxcorpses;
		sound_play(sndBloodlustProc);
		sound_play_pitch(sndBigMaggotBurrow,1.4 * random_range(.8, 1.2));
		repeat(ceil(value)){
			
			instance_create(x, y, AmmoPickup);
		}
		if fork(){
			
			wait(4)
			sound_play_pitch(sndRatKingVomit, 6 * random_range(.6, 1.2));
		}
	}
	
#define effect_instance_named(effectName, value, scaling) return mod_script_call("mod", "sageeffects", "effect_instance_create", value, scaling, effectName)
#define effect_type_create(name, description, describe_script) return mod_script_call("mod", "sageeffects", "effect_type_create", name, description, describe_script)
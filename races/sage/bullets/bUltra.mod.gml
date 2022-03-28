#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletUltra.png", 2, 7, 11);
  global.sprBulletOff = sprite_add("../../../sprites/sage/bullets/sprBulletUltraOff.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconUltra.png", 0, 5, 5);
  global.sprUltraSpark = sprite_add("../../../sprites/sage/fx/sprBulletFXUltraActivate.png", 5, 5, 5);
  global.sprUltraSpark2 = sprite_add("../../../sprites/sage/fx/sprBulletFXUltraNoRads.png", 5, 9, 9);
  
     //Ammo to rads
    with effect_type_create("ammoToRads", `@(color:${c.neutral})+USE @gRADS @(color:${c.neutral})AS @(color:${c.ammo})AMMO`, scr.describe_nothing) {
		on_pre_shoot = script_ref_create(ultra_pre_shoot);
    }
    
    //Reload speed on rad use
    with effect_type_create("reloadspeedOnRadUse", `{} @wRELOAD SPEED @(color:${c.neutral})WHEN USING @gRADS`, scr.describe_percentage) {
        on_deactivate = script_ref_create(ultra_boost_deactivate);
		on_rads_use = script_ref_create(ultra_boost_rads_use);
		on_rads_out = script_ref_create(ultra_boost_rads_out);
    }
    
    global.effects = [
        effect_instance_named("ammoToRads", 1, 0),
        effect_instance_named("reloadspeedOnRadUse", .35, .35)
    ]
      

#define bullet_effects(bullet)
    return global.effects
    
#macro c mod_variable_get("race", "sage", "colormap");
#macro scr mod_variable_get("mod", "sageeffects", "scr")

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $00EA81;

#define bullet_sprite
    // if instance_exists(GameCont) && instance_is(self, Player) {
    //     if (GameCont.rad <= get_rad_ammo_cost(wep)) {
    //         return global.sprBulletOff;
    //     }
    // }
    return global.sprBullet;

#define bullet_name
  return "ULTRA";

#define bullet_ttip
  return ["@sFROM @gRADS @sTO @yAMMO", "::INLINE PROTON ASSIMILATION EX-8809"];

#define bullet_area
  return 20;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);
  
  
#define ultra_pre_shoot(value, effect)
    if (infammo == 0) {
    	if GameCont.rad > 0 {
    	    var radCost = min(value, 1) * (weapon_get_type(wep) == 1 ? 4 : 16) * weapon_get_cost(wep);
    	
    		GameCont.rad = max(GameCont.rad - radCost, 0);
            ammo[weapon_get_type(wep)] += weapon_get_cost(wep)
            
    		with instances_matching(instances_matching(WepSwap, "creator", self), "sprite_index", global.sprUltraSpark) {
                instance_destroy();
            }
        
            with instance_create(x, y, WepSwap) {
                creator = other;
                sprite_index = global.sprUltraSpark;
            }
            sound_play_pitchvol(sndUltraEmpty, .75 * random_range(.8, 1.2), .5);

    	}
    }

#define set_ultra_boost(value)
    if ("sage_ultra_boost" not in self) {
        sage_ultra_boost = 0;
    }
    var diff = value - sage_ultra_boost;
    reloadspeed += diff;
    sage_ultra_boost = value;

#define ultra_boost_deactivate(value, effect)
    //Disable boost (bullet is deactivated)
    set_ultra_boost(0)

#define ultra_boost_rads_use(value, effect)
    //Enable boost
    set_ultra_boost(value)

#define ultra_boost_rads_out(value, effect)
    //Disable boost (out of rads)
    set_ultra_boost(0)

	with instances_matching(instances_matching(WepSwap, "creator", other), "sprite_index", global.sprUltraSpark) {
		instance_destroy();
	}
    
	with instance_create(x, y, WepSwap) {
		creator = other;
    	sprite_index = global.sprUltraSpark2;
	}
	sleep(10)
	sound_play_pitchvol(sndUltraEmpty, 1 * random_range(.9, 1.1), .8);
	sound_play_pitchvol(sndUltraGrenade, .7 * random_range(.9, 1.1), .5);
	sound_play_pitchvol(sndEmpty, 1, .6);


#define simple_stat_effect(variableName, value, scaling) return mod_script_call("mod", "sageeffects", "simple_stat_effect", variableName, value, scaling)
#define effect_instance_named(effectName, value, scaling) return mod_script_call("mod", "sageeffects", "effect_instance_create", value, scaling, effectName)
#define effect_type_create(name, description, describe_script) return mod_script_call("mod", "sageeffects", "effect_type_create", name, description, describe_script)

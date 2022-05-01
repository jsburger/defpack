#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletLove.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconLove.png", 0, 5, 5);
  
  global.effects = [
        effect_instance_named("pizzatime", 3, 2)
      ]
      
  with effect_type_create(+"pizzatime", `@(color:${c.neutral})+FIRE {} @yPIZZAS @(color:${c.neutral})WHEN @wHIT`, scr.describe_whole) {
		on_hurt = script_ref_create(pizza_hurt)
    }

#macro c mod_variable_get("race", "sage", "colormap");
#macro scr mod_variable_get("mod", "sageeffects", "scr")

#define bullet_effects(bullet)
    return global.effects
    
#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $DC00FF;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "PIZZA";

#define bullet_ttip
  return [`PIZZA LOVERS DELIGHT`, "EVERYONE LOVES PIZZA"];

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define pizza_hurt(value, effect)
    var _i = random(360),
        _a = value;
    
    repeat(_a) {
    
        with create_pizzadisc(x, y) {
        
            creator = other;
            motion_add(_i, 5);
        }
    
    _i += 360 / _a;
        }
#define effect_type_create(effectName, desc, desc_type) return mod_script_call("mod", "sageeffects", "effect_type_create", effectName, desc, desc_type);
#define create_pizzadisc(_x, _y) return (mod_script_call("mod", "defpack tools", "create_pizzadisc", _x, _y))
#define effect_instance_named(effectName, value, scaling) return mod_script_call("mod", "sageeffects", "effect_instance_create", value, scaling, effectName)
#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletLove.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconLove.png", 0, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");

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

#define bullet_description(power)
    var _s = string(3 + ceil(2 * power));
    return `@(color:${c.neutral})WHEN @wHIT: @(color:${c.neutral})FIRE ` + string(_s) + ` @y` + (_s == 1 ? `PIZZA` : `PIZZAS`);

#define on_take(power)
    if("sage_pizza_power" not in self) {
        
        sage_pizza_power = 3 + ceil(2 * power);
    }
    else {
        
        sage_pizza_power += 3 + ceil(2 * power);
    }

#define on_lose(power)
    sage_pizza_power -= 3 + ceil(2 * power);
    
#define on_step

    if current_frame % 60 = true{
        
        var _i = random(360),
            _a = sage_pizza_power;
        
        repeat(_a) {
            
            with create_pizzadisc(x, y) {
                
                creator = other;
                motion_add(_i, 5);
            }
            
            _i += 360 / _a;
        }
    }
    
#define create_pizzadisc(_x, _y) return (mod_script_call("mod", "defpack tools", "create_pizzadisc", _x, _y))
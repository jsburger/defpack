#define init
    global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletDefault.png", 2, 7, 11);
    global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconDefault.png", 0, 5, 5);

    global.sizeEffect = effect_instance_create("size", .3, 1);

#define effect_instance_create(effectName, value, scaling)
    return mod_script_call("mod", "sageeffects", "effect_instance_create", value, scaling, effectName)

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return c_red;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "TEST1";

#define bullet_ttip
  return `SWAP @(color:${c.spell})SPELLS @sFREQUENTLY`;

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_effects(bullet)
    return [
        mod_variable_get("mod", "sageeffects", "testEffect1"),
        global.sizeEffect
    ]
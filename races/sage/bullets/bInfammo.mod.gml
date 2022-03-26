#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletInfammo.png", 2, 7, 11);
  global.sprFairy  = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconInfammo.png", 2, 5, 5);
  global.sprEffect = sprite_add("../../../sprites/sage/fx/sprBulletFXInfammoProc.png", 8, 5, 5);


    with effect_type_create("sustainChance", `{} CHANCE TO NOT USE @(color:${c.ammo})AMMO`, scr.describe_percentage) {
        on_pre_shoot = script_ref_create(sustain_pre_shoot)
        on_post_shoot = script_ref_create(sustain_post_shoot)
    }
    
    global.effects = [
        effect_instance_named("sustainChance", .25, .25),
        simple_stat_effect("maxspeed", .5, 0),
        effect_instance_named("projectileSpeed", -.3, 0)
        ]
    
    
#macro c mod_variable_get("race", "sage", "colormap");
#macro scr mod_variable_get("mod", "sageeffects", "scr")

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $FFFF00;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "SUSTAIN";

#define bullet_ttip
  return ["SHOOT FOREVER", "DECREASE IN POWDER QUALITY DETECTED.#FURTHER WORK REQUIRED."];

#define bullet_area
  return 4;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_effects(bullet)
    return global.effects;

// #define bullet_description(spellPower)
//   return `@(color:${c.neutral})+${get_save_chance(spellPower) * 100}% TO NOT USE @(color:${c.ammo})AMMO#@(color:${c.neutral})+0.5 @(color:${c.speed})SPEED#@(color:${c.negative})-30% @(color:${c.projectile_speed})PROJECTILE SPEED`

// #define on_take(spellPower)
//   maxspeed += .5;
//   sage_projectile_speed -= .3;
//   if "sage_sustain_chance" not in self sage_sustain_chance = 0
//   sage_sustain_chance += get_save_chance(spellPower)

// #define on_lose(spellPower)
//   maxspeed -= .5;
//   sage_projectile_speed += .3;
//   sage_sustain_chance -= get_save_chance(spellPower)

// #define get_save_chance(spellPower)
//     return .25 * (1 + spellPower)
    
#define sustain_pre_shoot(value, effect, shootEvent)
    if (random(1) <= value) {
        if !lq_exists(shootEvent, "infammo_restore") {
            shootEvent.infammo_restore = infammo
            shootEvent.infammo_restore_valid = true
        }
        infammo = -1
        repeat(weapon_get_cost(wep)) with instance_create(x + lengthdir_x(7, gunangle), y + lengthdir_y(7, gunangle), CaveSparkle) {
            
            sprite_index = global.sprEffect;
            depth = other.depth -1
            image_speed += .15;
            image_angle = random(360)
            x += random_range(-3, 3)
            y += random_range(-3, 3)
            
            motion_add(other.gunangle, 3 + irandom(3));
            friction = .5;
        }
        var _p = random_range(.9, 1.1);
        sound_play_pitchvol(sndRecGlandProc, 1.4 * _p, 1.3);
        sound_play_pitchvol(sndLuckyShotProc, .8 * _p, 1.3);
    }

#define sustain_post_shoot(value, effect, shootEvent)
    if lq_exists(shootEvent, "infammo_restore") {
        if shootEvent.infammo_restore_valid {
            infammo = shootEvent.infammo_restore
            shootEvent.infammo_restore_valid = false
        }
        else {
            infammo = 0
        }
    }
    
#define simple_stat_effect(variableName, value, scaling)
    return mod_script_call("mod", "sageeffects", "simple_stat_effect", variableName, value, scaling)

#define effect_instance_named(effectName, value, scaling)
    return mod_script_call("mod", "sageeffects", "effect_instance_create", value, scaling, effectName)

#define effect_type_create(name, description, describe_script)
    return mod_script_call("mod", "sageeffects", "effect_type_create", name, description, describe_script)



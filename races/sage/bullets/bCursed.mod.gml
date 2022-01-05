#define init
    global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletCursed.png", 2, 7, 11);
    global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconCursed.png", 0, 5, 5);
    effects_init();

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $FF3DAE;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "CURSED";

#define bullet_ttip
  return `A FOREIGN POWER`;

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  // why is this soudn so quiet compared to the others
  sound_play_pitch(sndSwapCursed,  1.2 * _p);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(power)
  return `@(color:${c.neutral})NYI`;

#define on_init(bullet)
    with bullet {
        
        bullet_power = random_range(.85, 1.4);
        effects = [global.positiveEffects[irandom(array_length(global.positiveEffects) - 1)],
                   global.negativeEffects[irandom(array_length(global.negativeEffects) - 1)]];
    
        based = true;
    }

#define on_take(power, bullet)
    effects_call(power, bullet, "takescript");
    
#define on_lose(power, bullet)
    effects_call(power, bullet, "losescript");
    
#define on_fire
    var _p = random_range(.9, 1.1);
    var _s = sound_play_pitchvol(sndCursedPickup, 1 * _p, 1);
    audio_sound_set_track_position(_s, .25);

#define on_step
    if (random(6) < current_time_scale) {

        with instance_create(fairy.x + random_range(-sprite_get_width(fairy.sprite_back), sprite_get_width(fairy.sprite_back)) / 16 + fairy.creator.hspeed, fairy.y - sprite_get_height(fairy.sprite_back) / 32 * random_range(.8, 1), Curse) {depth = -12}
    }
    
// Positive effect array negative effect array function that adds stat bonuses to both

enum operators {
            
        add,
        multiply
    }
#define effects_init
    global.positiveEffects = [];
    global.negativeEffects = [];
    
    stat_effect_create({
        
        variable   : "maxhealth",
        value      : 2,
        descriptor : "@rMAX HP",
        scr_value_descriptor : script_ref_create(describe_whole),
        operator   : operators.add,
        spellpower_scaling : 2,
        scr_finalize : script_ref_create(finalize_ceil)
    }, true);
    
    stat_effect_create({
        
        variable   : "sage_projectile_speed",
        value      : .25,
        descriptor : `@(color:${c.projectile_speed})PROJECTILE SPEED`,
        scr_value_descriptor : script_ref_create(describe_percentage),
        operator   : operators.add,
        spellpower_scaling : .25,
        scr_finalize : script_ref_create(finalize_nothing)
    }, true);
    
    stat_effect_create({
        
        variable   : "reloadspeed",
        value      : .2,
        descriptor : `@(color:${c.reload})RELOAD SPEED`,
        scr_value_descriptor : script_ref_create(describe_percentage),
        operator   : operators.add,
        spellpower_scaling : .2,
        scr_finalize : script_ref_create(finalize_nothing)
    }, true);
    
    stat_effect_create({
        
        variable   : "maxspeed",
        value      : .5,
        descriptor : `@(color:${c.speed})SPEED`,
        scr_value_descriptor : script_ref_create(describe_percentage),
        operator   : operators.add,
        spellpower_scaling : .5,
        scr_finalize : script_ref_create(finalize_nothing)
    }, true);

#define effects_call(_spellpower, _spellbullet, _script)
    for(var i = 0; i < array_length(_spellbullet.effects); i++) {
        
        script_ref_call(lq_get(_spellbullet.effects[i], _script), _spellbullet.effects[i], _spellpower, _spellbullet);
    }
    
#define stat_effect_create(_stat_effect, _reversible)
    var copy = lq_clone(_stat_effect);
    var e = {
        
        takescript : script_ref_create(stat_effect_take),
        losescript : script_ref_create(stat_effect_lose),
        stateffect : _stat_effect
    };
    
    array_push(global.positiveEffects, e);
    if (_reversible) {
        
        var f = {
        
            takescript : script_ref_create(stat_effect_take),
            losescript : script_ref_create(stat_effect_lose),
            stateffect : copy
        };
        
        if (copy.operator == operators.add) {
            
            copy.value *= -1;
            copy.spellpower_scaling *= 0;
        }
        if (copy.operator == operators.multiply) {
            
            copy.value = 1/copy.value;
            copy.spellpower_scaling *= 0;
        }
        
        array_push(global.negativeEffects, f);
    }
    
#define stat_effect_take(_effect, _spellpower, _spellbullet)
    var n = stat_effect_calculate(_effect.stateffect, _spellpower, _spellbullet),
        value = variable_instance_get(self, _effect.stateffect.variable);
    
    if (_effect.stateffect.operator == operators.add) {
        
        value += n;
    }
    if (_effect.stateffect.operator == operators.multiply) {
        
        value *= n;
    }
    
    variable_instance_set(self, _effect.stateffect.variable, value);
    

#define stat_effect_lose(_effect, _spellpower, _spellbullet)
    var n = stat_effect_calculate(_effect.stateffect, _spellpower, _spellbullet),
        value = variable_instance_get(self, _effect.stateffect.variable);
    
    if (_effect.stateffect.operator == operators.add) {
        
        value -= n;
    }
    if (_effect.stateffect.operator == operators.multiply) {
        
        value /= n;
    }
    
    variable_instance_set(self, _effect.stateffect.variable, value);
    
#define stat_effect_calculate(_effect, _spellpower, _spellbullet)
    return script_ref_call(_effect.scr_finalize, (_effect.value + _effect.spellpower_scaling * _spellpower) * _spellbullet.bullet_power);

#define finalize_ceil(_var)
    return (ceil(_var));

#define finalize_nothing(_var)
    return (_var); // so cool
    
#define describe_whole(_var)
    return (string(ceil(_var)));
    
#define describe_percentage(_var)
    return (string(_var * 100) + "%");
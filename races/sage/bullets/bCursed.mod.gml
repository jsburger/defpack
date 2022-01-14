#define init
    global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletCursed.png", 2, 7, 11);
    global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconCursed.png", 0, 5, 5);
    global.sprEmote = sprite_add("../../../sprites/sage/sprBulletEmoji.png", 1, 6, 0);
    effects_init();
    names_init();

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $FF3DAE;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name(bullet)
    if (bullet != undefined) {
        
        return bullet.name;
    }
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

#define bullet_description(power, bullet)
    if (bullet != undefined) {
        
        return stat_effect_describe(power, bullet);
    }
    
#define on_init(bullet)
    
    with bullet {
        
        // Set effects and bullet power:
        var bulletPower = random_range(.8, 1.2);
        effects = [global.positiveEffects[irandom(array_length(global.positiveEffects) - 1)],
                   global.positiveEffects[irandom(array_length(global.positiveEffects) - 1)],
                   global.negativeEffects[irandom(array_length(global.negativeEffects) - 1)]];
        
        // Name the bullet:
        var adjective = irandom(14) == 0 ? global.special_adjectives[irandom(array_length(global.special_adjectives) - 1)] : global.adjectives[irandom(array_length(global.adjectives) - 1)],
            noun = irandom(14) == 0 ? global.special_nouns[irandom(array_length(global.special_nouns) - 1)] : global.nouns[irandom(array_length(global.nouns) - 1)];

        // Do wacky name effects:
        switch (adjective) {
            
            case "GOATED ": // Increase bullet power by 20%:
                bulletPower += .2;
                break;
            case "NORMAL ": // Remove random bullet power spread:
                bulletPower = 1;
                break;
            case "SOMEONE'S ": // Every version of cursed bullets is personalized
                var player = instance_nearest(1016, 1016, Player),
                    str_name = "SOMEONE";
                if (instance_exists(player)){            
                    str_name = string_upper(player_get_alias(player.index));
                  
                    // Seed setup so you always get the same ups/downs based on your alias:  
                    var seed = 0,
                        i = 0;
                    repeat(string_length(str_name)){
                        
                        seed += ord(string_char_at(str_name, i++));
                    }
                    
                    effects[0] = global.positiveEffects[seed          % (array_length(global.positiveEffects) - 1)]
                    effects[1] = global.positiveEffects[(seed * .43)  % (array_length(global.positiveEffects) - 1)]
                    effects[2] = global.negativeEffects[(seed * 1.78) % (array_length(global.negativeEffects) - 1)]
                    
                    adjective = str_name + "'S ";
                }
                break;
            case "MANIFOLD ": // +1 up +1 down
                effects[2] = global.positiveEffects[irandom(array_length(global.positiveEffects) - 1)];
                effects[3] = global.negativeEffects[irandom(array_length(global.negativeEffects) - 1)];
                effects[4] = global.negativeEffects[irandom(array_length(global.negativeEffects) - 1)];
                break;
            case "HORRENDOUS ": // Add 3 downsides:
                repeat(3) {
                    
                    array_push(effects, global.negativeEffects[irandom(array_length(global.negativeEffects) - 1)]);
                }
                break;
            case "THE WORST ": // Make this bullet contain all possible downsides and nothing else, then increase bullet power by 100%:
                for(var i = 0; i < array_length(global.negativeEffects); i++) {
                    
                    effects[i] = global.negativeEffects[i];
                }
                bulletPower += 1;
                break;
            case "TEST ": // For testing
                effects[0] = global.positiveEffects[1];
                effects[1] = global.positiveEffects[1];
                effects[2] = global.positiveEffects[2];
                effects[3] = global.positiveEffects[1];
                effects[4] = global.positiveEffects[1];
                effects[5] = global.negativeEffects[2];
                break;
        }
        
        name = adjective + noun; 
        if (name == "") {
            
            bulletPower += 3;
            name = "idk";
        }
        var endchar = string_char_at(name, string_length(name));
        if ( endchar == " " || endchar == "-"){
            
                name = string_delete(name, string_length(name), 1);
        }
        
        bullet_power = bulletPower;
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
#define names_init
    global.adjectives = [
        "DUBIOUS ",
        "CHANNELED ",
        "MASTER'S ",
        "VOLATILE ",
        "QUIRKY ",
        "POWERFUL ",
        "ENIGMATIC ",
        "HIGH ",
        "ENCHANTED ",
        "ENERGETIC ",
        "MYSTERIOUS ",
        "HOLLOW POINT ",
        "FULL METAL ",
        "STEEL ",
        "BRASS ",
        "LEAD ",
        "TERMINAL ",
        "CRYSTAL ",
        "CURSED ",
        "SUPER ",
        "MEGA-",
        "POWER-"
        ];
    global.special_adjectives = [ // Rarely used adjectives
        "THE ",
        "HUMOROUS ",
        "", // this is intentional
        "GOATED ",
        "NORMAL ",
        "MANIFOLD ",
        "HORRENDOUS ",
        "THE WORST ",
        `@0(${sprMaggotIdle}:-1) `,
        "SOMEONE'S "
        ];
    global.nouns = [
        "ROUND",
        "EVOCATION",
        "CALIBER",
        "SPELL",
        "SHELL",
        "FUEL",
        "POWDER",
        "BLANK",
        "CAP",
        "CARTRIDGE",
        "PROJECTILE",
        "BULLET",
        "INCANTATION",
        "HEX",
        "BLESSING"
        ];
    global.special_nouns = [ // Rarely used nouns
        "ROCK",
        "BUSTER",
        `@0(${sprMaggotIdle}:-1)`,
        `@0(${global.sprEmote}:0)`,
        "" // also intentional
        ];
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
        value      : 1,
        descriptor : `@(color:${c.speed})SPEED`,
        scr_value_descriptor : script_ref_create(describe_2a),
        operator   : operators.add,
        spellpower_scaling : 1,
        scr_finalize : script_ref_create(finalize_nothing)
    }, true);
    
    stat_effect_create({
        
        variable   : "sage_friction",
        value      : .9,
        descriptor : `@(color:${c.friction})TRACTION`,
        scr_value_descriptor : script_ref_create(describe_percentage),
        operator   : operators.add,
        spellpower_scaling : .9,
        scr_finalize : script_ref_create(finalize_nothing)
    }, true);
    
    stat_effect_create({ // not implemented?
      
        variable   : "sage_auto",
        value      : 1,
        descriptor : "@wAUTOMATIC WEAPONS",
        scr_value_descriptor : script_ref_create(describe_nothing),
        operator   : operators.add,
        spellpower_scaling : 0,
        scr_finalize : script_ref_create(finalize_nothing)
    }, false);    
    
    stat_effect_create({ // not implemented
      
        variable   : "sage_bounce",
        value      : 1,
        descriptor : `@(color:${c.bounce})BOUNCES`,
        scr_value_descriptor : script_ref_create(describe_whole),
        operator   : operators.add,
        spellpower_scaling : 1,
        scr_finalize : script_ref_create(finalize_ceil)
    }, false);    
    
    stat_effect_create({ // not implemented
      
        variable   : "sage_hitscan_strength",
        value      : 2,
        descriptor : `@(color:${c.speed})HYPERSPEED`,
        scr_value_descriptor : script_ref_create(describe_whole),
        operator   : operators.add,
        spellpower_scaling : 3,
        scr_finalize : script_ref_create(finalize_ceil)
    }, false);    
    
    stat_effect_create({
      
        variable   : "notoxic",
        value      : 1,
        descriptor : `@gTOXIC IMMUNITY`,
        scr_value_descriptor : script_ref_create(describe_nothing),
        operator   : operators.add,
        spellpower_scaling : 0,
        scr_finalize : script_ref_create(finalize_nothing)
    }, false);  
    
    /*stat_effect_create({
        
        variable   : "accuracy",
        value      : .6,
        descriptor : `@(color:${c.accuracy})ACCURACY`,
        scr_value_descriptor : script_ref_create(describe_percentage),
        operator   : operators.multiply,
        spellpower_scaling : .6,
        scr_finalize : script_ref_create(finalize_nothing)
    }, true);*/
    
    /*stat_effect_create({ // no dude
        
        variable   : "sage_spell_power",
        value      : .5,
        descriptor : `@(color:${c.spellpower})SPELLPOWER`,
        scr_value_descriptor : script_ref_create(describe_percentage),
        operator   : operators.add,
        spellpower_scaling : 0,
        scr_finalize : script_ref_create(finalize_nothing)
    }, true);*/

#define effects_call(_spellpower, _spellbullet, _script)
    for(var i = 0; i < array_length(_spellbullet.effects); i++) {
        
        script_ref_call(lq_get(_spellbullet.effects[i], _script), _spellbullet.effects[i], _spellpower, _spellbullet);
    }
    
#define stat_effect_describe(_spellpower, _spellbullet)
    var     str = "",
        effects = _spellbullet.effects,
         recall = [],
         recallval = [];
        
    // Combine duplicate effect descriptions:
    for(var i = 0; i < array_length(effects); i++) {
        
        if (i == 0) {
            
            recall[0] = effects[i];
            recallval[0] = effects[i].stateffect.value + max(sign(effects[i].stateffect.value) * effects[i].stateffect.spellpower_scaling * _spellpower, 0);
        }
        else {
            
            var j = 0;
            var exists = 0;
            with recall {
                
                // Entry exists already:
                if (self.stateffect.descriptor == effects[i].stateffect.descriptor) {
                    recallval[j] += effects[i].stateffect.value + max(sign(effects[i].stateffect.value) * effects[i].stateffect.spellpower_scaling * _spellpower, 0);
                    exists = 1;
                }
                j++;
            }
            
            if (!exists) {
                
                var length = array_length(recall);
                recall[length] = effects[i];
                recallval[length] = effects[i].stateffect.value + max(sign(effects[i].stateffect.value) * effects[i].stateffect.spellpower_scaling * _spellpower, 0);
            }   
        }
    }
    
    // Get all the text:
    var i = 0;
    with recall {
        
        if (recallval[i] != 0) {
            // Add newline:
            if (string_length(str) > 0) {
                
                str += "#";
            }
            
            // Add the operator at the beginning:
            if (recallval[i] < 0) {
                    
                str += `@(color:${c.negative})`;
            }
            else if (recallval[i] > 0){
                    
                str += `@(color:${c.neutral})+`;
            }
        
            
            // Add the value:
            str += script_ref_call(self.stateffect.scr_value_descriptor, (recallval[i]) * _spellbullet.bullet_power) + (self.stateffect.scr_value_descriptor[2] == "describe_nothing" ? "" : " ");
        
            // Add the name of the stat changed:
            str += recall[i].stateffect.descriptor;
        }
        i++;
    }
    
    // Just in case you get nothing out of a bullet:
    if (str == "") {
        
        str = `@(color:${c.neutral})DOES NOTHING`;
    }
    return(str);
    
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
        
    if (value == undefined) {
        
        value = 0;
    }
    
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
    var v = ceil(abs(_var)) * sign(_var);
    return (v);

#define finalize_nothing(_var)
    return (_var); // so cool
    
#define describe_whole(_var)
    var v = ceil(abs(_var)) * sign(_var);
    return string(v);
    
#define describe_percentage(_var)
    var v = (round(abs(_var * 100)) * sign(_var));
    return string(v) + "%";
    
#define describe_2a(_var) // 2a = accuracy of 2, 2 digits after the comma (1,xx)
    var v = string(round(_var * 100) / 100);
    
    for(var i = string_length(v); i < (sign(_var) == -1 ? 5 : 4); i++){
        
        if (i == 1) {
            
            v += ".";
        }
        else {
            
            v += "0";
        }
    }

    return(v);
#define describe_nothing
    return "";
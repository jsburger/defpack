#define init
    global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletBurst.png", 2, 7, 11);
    global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconBurst.png", 1, 5, 5);

    with effect_type_create("burstCount", `{} @(color:${c.ammo})BURST SIZE`, scr.describe_floor) {
        on_fire = script_ref_create(burst_fire)
    }

    global.effects = [
        effect_instance_named("burstCount", 3, 2),
        simple_stat_effect("reloadspeed", -.6, 0)
    ]

#macro c mod_variable_get("race", "sage", "colormap");
#macro scr mod_variable_get("mod", "sageeffects", "scr")

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $0038FC;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "BURST";

#define bullet_ttip
  return ["FIRE IN WAVES", "::WEAPON OPTIMIZATION EX-8837", "::PART DAMAGE MINIMIZED"];

#define bullet_area
  return 4;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_effects
    return global.effects

// #define bullet_description(power)
//   return `@(color:${c.neutral})+` + string(ceil(3 + 1 * power)) + ` @(color:${c.ammo})BURST SIZE#@(color:${c.negative})+` + string(round(200 + 200 * power)) + `% @(color:${c.ammo})AMMO COST#@(color:${c.negative})-60% @(color:${c.reload})RELOAD SPEED`;

// #define on_take(power)
//   if "sage_burst_size" not in self {

//     sage_burst_size = 1 + ceil(2 + 1 * power);
//   }else {

//     sage_burst_size += ceil(2 + 1 * power);
//   }
//   reloadspeed -= .6;

// #define on_lose(power)
//   sage_burst_size -= ceil(2 + 1 * power);
//   reloadspeed += .6;

#define burst_fire(value, effect, fireEvent, fireStack)

    array_push(fireStack, effect.type.name)
    var burstStack = array_clone(fireStack);
    // array_push(burstStack, effect.type.name)

    if fork() {
        var w = wep;
        for (var i = 1; i <= value; i++) {
            if(!instance_exists(self) or w != wep) exit;
            //Only need to fire after waiting, since sage will shoot normally otherwise
            if (i != 1) {
                mod_script_call("race", "sage", "sage_fire", lq_clone(fireEvent), array_clone(burstStack))
            }
            if i != value {
                var waitTime = get_burst_delay(wep, value)
                //Add reload time to the player to account for the reloading done between burst shots, prevents overlapping
                reload += waitTime * get_reloadspeed(self);
                wait(waitTime);
            }
        }
        repeat(value - 1) {
            //Reduce reload time to what it would be had the player only fired once
            reload -= weapon_get_load(wep) - get_reloadspeed(self);
        }
        if reload > 0 {
            //Add back the reloading time from between shots now that overlapping has been taken care of
            reload = max(frac(reload) - get_reloadspeed(self), reload - get_burst_delay(wep, value) * get_reloadspeed(self) * (value - 1))
        }
        exit
    }

#define get_burst_delay(wep, sage_burst_size)
return max(2, (ceil(weapon_get_load(wep)) / (sage_burst_size * 3 - 2) + weapon_is_melee(wep) * 2))


#define get_reloadspeed(p)
if !instance_is(p, Player) return 1
return (p.reloadspeed + ((p.race == "venuz") * (.2 + .4 * ultra_get("venuz", 1))) + ((1 - p.my_health/p.maxhealth) * skill_get(mut_stress)))

#define simple_stat_effect(variableName, value, scaling) return mod_script_call("mod", "sageeffects", "simple_stat_effect", variableName, value, scaling)
#define effect_instance_named(effectName, value, scaling) return mod_script_call("mod", "sageeffects", "effect_instance_create", value, scaling, effectName)
#define effect_type_create(name, description, describe_script) return mod_script_call("mod", "sageeffects", "effect_type_create", name, description, describe_script)


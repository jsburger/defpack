#define init
  global.sprBullet = sprite_add_weapon("../../../sprites/sage/bullets/sprBulletBurst.png", 7, 7)
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconBurst.png", 0, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $0038FC;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "BURST";

#define bullet_ttip
  return "FIRE IN WAVES";

#define bullet_area
  return 4;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(ceil(3 + 1 * power)) + ` @(color:${c.ammo})BURST SIZE#@(color:${c.negative})+` + string(round(200 + 200 * power)) + `% @(color:${c.ammo})AMMO COST#@(color:${c.negative})-60% @(color:${c.reload})RELOAD SPEED`;

#define on_take(power)
  if "sage_burst_size" not in self {

    sage_burst_size = 1 + ceil(2 + 1 * power);
  }else {

    sage_burst_size += ceil(2 + 1 * power);
  }
  reloadspeed -= .6;

#define on_lose(power)
  sage_burst_size -= ceil(2 + 1 * power);
  reloadspeed += .6;

#define on_fire(spellPower, event)

    if fork() {
        var w = wep;
        for (var i = 1; i <= sage_burst_size; i++) {
            if(!instance_exists(self) or w != wep)exit;
            //Only need to fire after waiting, since sage will shoot normally otherwise
            if (i != 1) {
                if event.angle_offset == 0 {
                    mod_script_call_self("race", "sage", "sage_shoot", gunangle)
                }
                else {
                    mod_script_call_self("race", "sage", "sage_shoot_offset", gunangle, event.angle_offset)
                }
            }
            if i != sage_burst_size {
                var waitTime = get_burst_delay(wep, sage_burst_size)
                //Add reload time to the player to account for the reloading done between burst shots, prevents overlapping
                reload += waitTime * get_reloadspeed(self);
                wait(waitTime);
            }
        }
        repeat(sage_burst_size - 1) {
            //Reduce reload time to what it would be had the player only fired once
            reload -= weapon_get_load(wep) - get_reloadspeed(self);
        }
        if reload > 0 {
            //Add back the reloading time from between shots now that overlapping has been taken care of
            reload = max(frac(reload) - get_reloadspeed(self), reload - get_burst_delay(wep, sage_burst_size) * get_reloadspeed(self) * (sage_burst_size - 1))
        }
        exit
    }

#define get_burst_delay(wep, sage_burst_size)
return max(2, (ceil(weapon_get_load(wep)) / (sage_burst_size * 3 - 2) + weapon_is_melee(wep) * 2))


#define get_reloadspeed(p)
if !instance_is(p, Player) return 1
return (p.reloadspeed + ((p.race == "venuz") * (.2 + .4 * ultra_get("venuz", 1))) + ((1 - p.my_health/p.maxhealth) * skill_get(mut_stress)))

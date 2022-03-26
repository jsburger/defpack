#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletUltra.png", 2, 7, 11);
  global.sprBulletOff = sprite_add("../../../sprites/sage/bullets/sprBulletUltraOff.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconUltra.png", 0, 5, 5);
  global.sprUltraSpark = sprite_add("../../../sprites/sage/fx/sprBulletFXUltraActivate.png", 5, 5, 5);
  global.sprUltraSpark2 = sprite_add("../../../sprites/sage/fx/sprBulletFXUltraNoRads.png", 5, 9, 9);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $00EA81;

#define bullet_sprite
    if instance_exists(GameCont) && instance_is(self, Player) {
        if (GameCont.rad <= get_rad_ammo_cost(wep)) {
            return global.sprBulletOff;
        }
    }
    return global.sprBullet;

#define bullet_name
  return "ULTRA";

#define bullet_ttip
  return ["@sFROM @gRADS @sTO @yAMMO", "INLINE PROTON ASSIMILATION SUCCESSFUL."];

#define bullet_area
  return 20;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(spellPower)
  return `@(color:${c.neutral})+USE @gRADS @(color:${c.neutral})AS @(color:${c.ammo})AMMO#@(color:${c.neutral})+${get_reload_reduction(spellPower) * 100}% @wRELOAD SPEED @(color:${c.neutral})WHEN USING @gRADS`;


#define get_reload_reduction(spellPower)
    return .35 * (1 + spellPower)

#define on_take(power)

    if "sage_ultra_boosted" not in self sage_ultra_boosted = false
    // enable_boost(power)
    
    sage_ammo_to_rads++;

#define on_lose(power)
//   sage_atr_reload_speed -= .5 + .5 * power;

    disable_boost(power)
    
    sage_ammo_to_rads--;

#define on_pre_shoot(power)

    if infammo == 0 {
    	  var radCost = get_rad_ammo_cost(wep);

    	  if GameCont.rad >= radCost {
    	      GameCont.rad -= radCost
    	      ammo[weapon_get_type(wep)] += weapon_get_cost(wep)
    	  }

    }

#define get_rad_ammo_cost(wep)
    return min(sage_ammo_to_rads, 1) * (weapon_get_type(wep) == 1 ? 4 : 16) * weapon_get_cost(wep);

#define disable_boost(spellPower)
    if sage_ultra_boosted {
        reloadspeed -= get_reload_reduction(spellPower)
        sage_ultra_boosted = false
    }
    
#define enable_boost(spellPower)
    if !sage_ultra_boosted {
        reloadspeed += get_reload_reduction(spellPower)
        sage_ultra_boosted = true
    }

#define on_rads_use(spellPower)

    enable_boost(spellPower)

    with instances_matching(instances_matching(WepSwap, "creator", other), "sprite_index", global.sprUltraSpark) {
        instance_destroy();
    }

    with instance_create(x, y, WepSwap) {
        creator = other;
        sprite_index = global.sprUltraSpark;
    }
    sound_play_pitchvol(sndUltraEmpty, .75 * random_range(.8, 1.2), .5);

    if GameCont.rad > 0 && GameCont.rad < get_rad_ammo_cost(wep) {
        on_rads_out(spellPower)
    }

    // if fork() {
    //     // wait(1);
    //     if instance_exists(self) {
    //         trace("reload before: " + string(reload))
    //         reload *= 1 / (1 + sage_atr_reload_speed);
    //         trace("reload after:", reload)
    //     }
    // }

#define on_rads_out(spellPower)

    disable_boost(spellPower)
    
  with instance_create(x, y, WepSwap) {

    with instances_matching(instances_matching(WepSwap, "creator", other), "sprite_index", global.sprUltraSpark) {

      instance_delete(self);
    }
    creator = other;
    sprite_index = global.sprUltraSpark2;
  }
  sleep(10)
  sound_play_pitchvol(sndUltraEmpty, 1 * random_range(.9, 1.1), .8);
  sound_play_pitchvol(sndUltraGrenade, .7 * random_range(.9, 1.1), .5);
  sound_play_pitchvol(sndEmpty, 1, .6);

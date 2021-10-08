#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletBurst.png", 0, 7, 7)

#macro c mod_variable_get("race", "sage", "colormap");

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "BURST";

#define bullet_area
  return 0;

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(ceil(3 + 1 * power)) + ` @(color:${c.ammo})BURST SIZE#@s+` + string(round(200 + 200 * power)) + `% @(color:${c.ammo})AMMO COST#@s-60% @(color:${c.reload})RELOAD SPEED`;

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

#define on_fire

  // Burst firing:
  if sage_burst_size > 1 if(fork()){

    var w = wep;
    repeat(sage_burst_size){
      if(!instance_exists(self) or w != wep or ammo[weapon_get_type(wep)] < weapon_get_cost(wep) * (1 + sage_ammo_cost) or GameCont.rad < weapon_get_rads(wep) * (1 + sage_ammo_cost)) exit;
      player_fire(gunangle);
      wait(max(2, (ceil(weapon_get_load(wep)) / (7 + sage_burst_size * 3 - 9) + weapon_is_melee(wep) * 2)));
    }
    repeat(sage_burst_size - 1){
      reload -= weapon_get_load(wep);
    }
    if weapon_get_type(wep) = 0 || weapon_get_type(wep) = 1 || weapon_is_melee(wep) = true{
      clicked = false;
    }
    exit;
  }

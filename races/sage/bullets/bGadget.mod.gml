#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletGadget.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconGadget.png", 1, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");
#macro sizeUp 1

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $7A7A7A;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "GIGAFIER";

#define bullet_ttip
  return `SWAP @(color:${c.spell})SPELLS @sFREQUENTLY`;

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define damageBoost(spellpower)
	return 1 + (spellpower * .5);
	
#define healthBoost(spellpower)
	return 10 + (spellpower * 5);

#define bullet_description(power)
  return `@(color:${c.neutral})+50% @wSIZE#@(color:${c.neutral})+`+ string(damageBoost(power) * 100) +`% @rDAMAGE#@(color:${c.neutral})+`+ string(healthBoost(power)) + ` @(color:${c.health})MAX HP#@(color:${c.negative})-1.5 @(color:${c.speed})SPEED`;

#define on_take(power)
  image_xscale += sizeUp;
  image_yscale += sizeUp;
  maxhealth += healthBoost(power);
  my_health += healthBoost(power);
  maxspeed -= 1.5;
  sage_projectile_speed -= .15;
  if "sage_damage" not in self sage_damage = damageBoost(power) else sage_damage += damageBoost(power);

#define on_lose(power)
  image_xscale -= sizeUp;
  image_yscale -= sizeUp;
  my_health = max(my_health - healthBoost(power), 1);
  maxhealth -= healthBoost(power);
  maxspeed += 1.5;
  sage_projectile_speed += .15;
  sage_damage -= damageBoost(power);
 
#define on_fire(power)
	view_shake_at(x, y, .5 * weapon_get_load(wep));
 
#define on_step
	var s = self;
	with instances_matching_ne(instances_matching(projectile, "creator", other), "sage_damage_adjust", true){
	
		damage = ceil(damage * (1 + s.sage_damage));
		force  *= 1 + s.sage_damage;
		if !instance_is(self, Laser) && !instance_is(self, Lightning) image_xscale *= 1.5;
		image_yscale *= 1.5;
		sage_damage_adjust = true;
	}
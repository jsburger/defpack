#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletQuartz.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconQuartz.png", 2, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");
#macro infammo_floor room_speed * 1
#macro spellBoost (1 + spellPower)

#define projectileBoost(spellPower)
    return .10 * spellBoost
	
#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $FFDFC9;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "QUARTZ FRAGMENT";

#define bullet_ttip
  return [`BE CAREFUL WITH IT`];

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,        .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun,  	   1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload,  	   1.4 * _p, .9);
  sound_play_pitchvol(sndHyperCrystalHurt, 1.6 * _p, .4);

#define bullet_description(power)
    var _s = string(3 + ceil(2 * power));
    return `@(color:${c.neutral})+@(color:${c.aqua})INFINITE AMMO#@(color:${c.neutral})+${projectileBoost(power) * 100}% @(color:${c.projectile_speed})PROJECTILE SPEED#@wbreaks @(color:${c.negative})when @whit`;

#define on_take(power)
if "sage_infammo_floor" not in self{

	sage_infammo_floor = ceil(infammo_floor);
}else sage_infammo_floor += ceil(infammo_floor);
sage_projectile_speed += projectileBoost(power);

#define on_lose(power)
	sage_infammo_floor -= ceil(infammo_floor);
	sage_projectile_speed -= projectileBoost(power);

#define on_fire
	sound_play_pitchvol(sndHyperCrystalHurt,random_range(1.6,2),.5)

#define on_step
	// Infammo effect:
	infammo = max(infammo, sage_infammo_floor);
	
	// Particles:
	if (random(30) < current_time_scale) {

        with instance_create(fairy.goalX + random_range(-sprite_get_width(fairy.sprite_back), sprite_get_width(fairy.sprite_back)) / 10, fairy.goalY + random_range(-sprite_get_height(fairy.sprite_back), sprite_get_width(fairy.sprite_back)) / 10, WepSwap) {

			depth = -10 - irandom(1)
			image_xscale = .75
			image_yscale = .75
			image_speed = choose(.7,.7,.7,.45)
		}
	}
#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletEcho.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconEcho.png", 2, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $FFD4AA;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "ECHO";

#define bullet_ttip
  return "idk";

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,        .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun,  	   1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload,  	   1.4 * _p, .9);

#define bullet_description(power)
    var _s = string(3 + ceil(2 * power));
    return `@(color:${c.neutral})idk`;
    
#define create_echo_explosion(_x, _y)
    with instance_create(_x, _y, CustomSlash){
     
        damage = 1;
        force  = 2;
        radius = 8;
           
        on_projectile = nothing;
        on_hit = echo_hit;
    }

#define nothing
#define echo_hit
    if projectile_canhit(other){
        
        projectile_hit(other, damage, force, point_direction(x, y, other.x, other.y));
    }
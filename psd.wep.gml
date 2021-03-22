#define init
global.sprEnergyDevice = sprite_add_weapon("sprites/weapons/sprPSD.png", 1, 2);
global.sprSonicExplosion = sprite_add("sprites/projectiles/sprESonicExplosion.png", 8, 59, 56);

#macro c_energy $23D900
#macro e_radius 26 + (skill_get(mut_long_arms) > 0 ? 5 : 0);

#define weapon_name
return "P.S.D";

#define weapon_type
return 5;

#define weapon_cost
return 1;

#define weapon_area
return -1;

#define weapon_load
return 7;

#define weapon_swap
return sndSwapEnergy;

#define weapon_auto
return false;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_sprt
return global.sprEnergyDevice;

#define nts_weapon_examine
return{
    "d": "One of these can replace up to 4.32 bodyguards. ",
}

#define weapon_text
return "PERSONAL SECURITY DEVICE";

#define weapon_fire
  wepangle = -wepangle
  weapon_post(-4, 6, 7);
  sleep(5);

  var _brain = skill_get(mut_laser_brain) > 0;

  repeat(6 + irandom(2)){
    var _dir = random(360)
    with instance_create(x + hspeed + lengthdir_x(e_radius * .7, _dir), y + vspeed + lengthdir_y(e_radius * .7, _dir), PlasmaTrail){
      friction = 1
      motion_add(point_direction(other.x, other.y, x, y), 6)
    }
  }

  var _p = random_range(.8, 1.2);
  if _brain{
    sound_play_pitchvol(sndEnergySword, 1.2 * _p, .6);
    sound_play_pitchvol(sndEnergyScrewdriverUpg, 1.3 * _p, .7);
    sound_play_pitchvol(sndLaserCannonCharge, 2.1 * _p, .4);
    sound_play_pitchvol(sndEnergyHammer, 1.6 * _p, .8);
  }else{
    sound_play_pitchvol(sndEnergySword, 1.2 * _p, .6);
    sound_play_pitchvol(sndEnergyScrewdriver, 1.4 * _p, .7);
    sound_play_pitchvol(sndLaserCannonCharge, 2.4 * _p, .4);
  }

  with instance_create(x, y, CustomSlash){
    sprite_index = global.sprSonicExplosion;
    mask_index   = mskNone;
    image_speed  = .8 - (skill_get(mut_laser_brain) > 0 ? .4 : 0);
    image_index  = 0;
    depth = -2;

    creator = other;
    team    = other.team;
    damage  = 12;
    force   = 5;
    candeflect = true;
    can_fix    = false;

    var _active = ((creator.wep = mod_current) || (creator.race = "steroids" && creator.bwep = mod_current));
    image_xscale = _active * e_radius / sprite_get_width(sprite_index) * 2;
    image_yscale = _active * e_radius / sprite_get_height(sprite_index) * 2;
    radius = e_radius + _active;

    on_wall = nothing;
    on_step = slash_step;
    on_hit  = nothing;
  }

#define slash_hit

#define slash_step
  if instance_exists(creator){
    x = creator.x + creator.hspeed;
    y = creator.y + creator.vspeed;

    with instances_matching_ne(hitme, "team", other.team){
      if distance_to_object(other) <= e_radius && other.image_index <= 3 && sprite_index != spr_hurt with other{
          var _f = !instance_is(other, prop);
          projectile_hit(other, damage, force * _f, point_direction(x, y, other.x, other.y));
          if other.my_health > 0{
            sleep(6 + 12 * clamp(other.size, 1, 2));
            view_shake_max_at(other.x, other.y, 2 + 3 * clamp(other.size, 1, 2));
          }else{
            sleep(20 + 30 * clamp(other.size, 1, 2));
            view_shake_max_at(other.x, other.y, 15 + 5 * clamp(other.size, 1, 2));
          }
      }
    }
    with instances_matching_ne(projectile, "team", other.team){
      if distance_to_object(other) <= (other.radius + 6){
        instance_destroy();
      }
    }
  }

#define step
  var _active = ((wep = mod_current) || (race = "steroids" && bwep = mod_current));

  if _active > 0{
    with instance_create(x + hspeed, y + vspeed, CustomSlash){
          mask_index  = mskNone
          image_speed = 0;

          creator = other;
          team    = other.team;
          radius  = e_radius * _active;

          on_hit  = nothing;
          on_draw = pgd_draw;
        }
    }

#define pgd_draw
  with instances_matching_ne(hitme, "team", other.team){
    if distance_to_object(other) <= other.radius{
      speed /= 3;
    }
  }
  with instances_matching_ne(projectile, "team", other.team){
    if distance_to_object(other) <= (other.radius){
      var _brain = skill_get(mut_laser_brain) > 0;
      x += lengthdir_x(1 + speed * (.2 + .05 * _brain), point_direction(other.x, other.y, x, y));
      y += lengthdir_y(1 + speed * (.2 + .05 * _brain), point_direction(other.x, other.y, x, y));
      if irandom(3) = 0 with instance_create(x + random_range(-2, 2), y + random_range(-2, 2), PlasmaTrail){motion_add(other.direction - 180, .5)}
    }
  }
  draw_circle_width_colour(16, radius + random(1), 1, current_frame mod 360, x, y, c_energy, .5);

#define nothing

#define draw_circle_width_colour(precision,radius,width,offset,xcenter,ycenter,col,alpha) return mod_script_call("mod", "defpack tools", "draw_circle_width_colour" ,precision,radius,width,offset,xcenter,ycenter,col,alpha)

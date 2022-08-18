#define init
  global.sprTeleporter = sprRevolver;
  global.sprExtraCursor = sprite_add("../sprites/interface/sprExtraCursor.png", 1, 8, 8);
  global.sprTeleportFX  = sprite_add("../sprites/projectiles/sprTeleportFx.png", 5, 8, 8);
  global.sprFX          = sprite_add("../sprites/projectiles/sprKaboomerangBounce.png", 3, 12, 12);

#define weapon_name
  return "TELEPORTER";
#define weapon_type
  return 0;
#define weapon_cost
  return 0;
#define weapon_area
  return - 1;
#define weapon_load
  return 32;
#define weapon_swap
  return sndSwapHammer;
#define weapon_auto
  return false;
#define weapon_melee
  return false;
#define weapon_laser_sight
  return false;
#define weapon_sprt
  return global.sprTeleporter;
#define weapon_text
  return "BLINK";
#macro tp_damage 30
#macro tp_kill_range 18
#define weapon_fire
  with instances_matching(instances_matching(CustomObject, "name", "teleport preview"), "creator", other){

      if (can_teleport){ // Valid location for teleporting found:

        var _pitch = random_range(.9, 1.1);
        sound_play_pitchvol(sndCrystalTB, .6 * _pitch, .7);
        sound_play_pitchvol(sndRavenLift, 2 * _pitch, .7);
        sound_play_pitchvol(sndScrewdriver, .6 * _pitch, .7);

        repeat(6){

          with instance_create(creator.x + random_range(-3, 3), creator.y + random_range(-3, 3), CrystTrail){

            depth = -3;
            sprite_index = global.sprTeleportFX;
          }
        }

        creator.x = x;
        creator.y = y;
        creator.nexthurt = current_frame + 14;

        with instance_create(creator.x, creator.y, Wind){sprite_index = sprShieldDisappear; image_index = 2; depth = -3}

        with instance_create(x, y, CustomSlash){

          creator = other.creator;
          team = creator.team;
          can_deflect = false;
          damage = tp_damage;
          mask_index = other.mask_index;

          on_draw = tp_draw;
        }

        with instance_create(x, y, Wind){sprite_index = global.sprFX}
        with mod_script_call("mod","defpack tools","create_sonic_explosion",x ,y){
        	var scalefac = .6;
        	image_xscale = scalefac
        	image_yscale = scalefac
        	image_speed = 0.6
          force = 12;
          play_hitsound = false;
        	team = other.creator.team
        	creator = other.creator
      }

        // Reduce reload when killing something:
        if (target) creator.reload = 12;


      }else{ // Cannot teleport:
        sound_play_pitchvol(sndCursedReminder, 1.5, .7);
        creator.reload = 4;
      }
  }

#define tp_draw
  instance_destroy();

#define step

  var create_preview = true;
  with instances_matching(instances_matching(CustomObject, "name", "teleport preview"), "creator", other){
      create_preview = false;
  }
  if (instance_exists(GenCont)){
    create_preview = false;
  }

  if (create_preview){

    if (wep == mod_current || (race = "steroids" && bwep == mod_current)){

      with instance_create(mouse_x[index], mouse_y[index], CustomObject){

        name = "teleport preview";
        creator = other;
        sprite_index = mskNone;
        mask_index   = other.mask_index;
        image_speed  = 0;
        depth = -20;
        index = creator.index;

        target = -4;
        prev_target = -4;
        can_teleport = true;

        on_step    = tp_preview_step;
        on_draw    = tp_preview_draw;
        on_destroy = tp_preview_destroy;
        on_cleanup = tp_preview_destroy;
      }
    }
  }

#define tp_preview_destroy
  player_set_show_cursor(index, index, 1);

#define tp_preview_step
  if (!instance_exists(creator)){instance_destroy(); exit}

  if (creator.wep != mod_current || (creator.race = "steroids" && creator.bwep != mod_current && creator.wep != mod_current)){

    instance_destroy();
    exit;
  }

  player_set_show_cursor(creator.index, creator.index, 0);

  // Determine if theres something killable nearby and tp on top of it if true:
  var _x = x,
      _y = y,
      _i = creator.index;

  if (prev_target != target && target != -4){

      sound_play_pitchvol(sndSniperTarget, 3, .7);
  }
  prev_target = target;
  target = -4;

  with instances_matching_ne(hitme, "team", other.creator.team){

      if (!instance_is(self, prop) && point_distance(x, y, mouse_x[_i], mouse_y[_i]) <= tp_kill_range && my_health <= tp_damage){

          if (!other.target){

            other.target = self;
          }else{

            if (point_distance(x, y, mouse_x[_i], mouse_y[_i]) < point_distance(other.target.x, other.target.y, mouse_x[_i], mouse_y[_i])){

              other.target = self;
            }
          }
      }
  }

  if (target){

    _x = target.x;
    _y = target.y;
  }else{

    _x = mouse_x[creator.index];
    _y = mouse_y[creator.index];
  }
  x = _x;
  y = _y;

  if (!place_free(x, y) || !place_meeting(x, y, Floor)){

    can_teleport = false;
  }else{

    can_teleport = true;
  }

#define tp_preview_draw
  if (!instance_exists(creator)){instance_destroy(); exit}
  var _c = can_teleport ? c_lime : c_red;

  if (!target){

    draw_set_fog(true, _c, 0, 0);
    draw_sprite(creator.sprite_index, creator.image_index, x, y);
    draw_set_fog(false, _c, 0, 0);
  }else{
    var _xscale = target.image_xscale * ("right" in target ? target.right : 1);
    draw_set_fog(true, _c, 0, 0);
    draw_sprite_ext(target.sprite_index, target.image_index, target.x - 1, target.y, _xscale, target.image_yscale, target.image_angle, target.image_blend, 1);
    draw_sprite_ext(target.sprite_index, target.image_index, target.x + 1, target.y, _xscale, target.image_yscale, target.image_angle, target.image_blend, 1);
    draw_sprite_ext(target.sprite_index, target.image_index, target.x, target.y - 1, _xscale, target.image_yscale, target.image_angle, target.image_blend, 1);
    draw_sprite_ext(target.sprite_index, target.image_index, target.x, target.y + 1, _xscale, target.image_yscale, target.image_angle, target.image_blend, 1);
    draw_set_fog(false, _c, 0, 0);
    draw_sprite_ext(target.sprite_index, target.image_index, target.x, target.y, _xscale, target.image_yscale, target.image_angle, target.image_blend, 1);
  }

  draw_sprite_ext(global.sprExtraCursor, 0, mouse_x[creator.index], mouse_y[creator.index], 1, 1, 0, player_get_color(creator.index), .66);

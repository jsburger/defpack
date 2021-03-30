#define init
  global.sprHUDcTL = sprite_add("../sprites/crown/sprCrownHUDTL.png", 3,  6, 2);
  global.sprHUDcTR = sprite_add("../sprites/crown/sprCrownHUDTR.png", 3, -1, 0);
  global.sprHUDcBL = sprite_add("../sprites/crown/sprCrownHUDBL.png", 3,  3, 4);
  global.sprHUDcBR = sprite_add("../sprites/crown/sprCrownHUDBR.png", 3, -1, 4);
  global.sprHUDbHT = sprite_add("../sprites/crown/sprCrownHUDHborderT.png", 3,  0, 0);
  global.sprHUDbHB = sprite_add("../sprites/crown/sprCrownHUDHborderB.png", 3,  0, 4);
  global.sprHUDbVL = sprite_add("../sprites/crown/sprCrownHUDVborderL.png", 3,  3, 0);
  global.sprHUDbVR = sprite_add("../sprites/crown/sprCrownHUDVborderR.png", 3, -1, 0);
  global.sprHUDp   = sprite_add("../sprites/crown/sprCrownHUDPointer.png",  1,  3, 0);
  global.sprSwap   = sprite_add("../sprites/crown/sprExchangeSwap.png",  5, 10, 32); 

  for(var _i = 0; _i < maxp; _i++){
    // global.anim[player index, variable]
    global.anim[_i, 0] = 0; // hud width
    global.anim[_i, 1] = 0; // hud height
    global.anim[_i, 2] = 20; // no of frames for name hover
  }
#macro out_width  s_w(global.sprHUDcTL);
#macro out_height s_h(global.sprHUDcTL);
#macro hud_width  max(global.min_width,  0);  // not lower than 0
#macro hud_height max(global.min_height, 7); // not lower than 7

#define game_start
  mod_script_call("crown", "exchange", "store_wep");

#define draw_gui
  if !instance_exists(CharSelect) && crown_current = "exchange" && !instance_exists(menubutton) for(var _i = 0; _i < maxp; _i++){
    draw_set_visible_all(false);
    draw_set_visible(_i, true);
    draw_crownhud(6, 54, _i);
    draw_set_visible_all(true);

    if instance_exists(Player){
      var _array  = mod_variable_get("crown", "exchange", "nextwep"),
          _name   = weapon_get_name(_array[_i, 0]),
          _width  = sprite_get_width(weapon_get_sprite(_array[_i, 0])),
          _height = sprite_get_height(weapon_get_sprite(_array[_i, 0]));
      if global.anim[_i, 2] < 0{
        global.anim[_i, 2] = min(global.anim[_i, 2] + current_time_scale, 0)
      }else{
        if point_in_rectangle(mouse_x[_i] - view_xview[_i], mouse_y[_i] - view_yview[_i], 6, 53, 6 + global.anim[_i, 0], 53 + global.anim[_i, 1]){
          global.anim[_i, 2] = max(global.anim[_i, 2] - current_time_scale, 0);
        }else{
          global.anim[_i, 2] = 20;
        }
      }
      if global.anim[_i, 2] <= 0{
        draw_set_font(fntM);
        draw_text_nt(4, 45, weapon_get_name(_array[_i, 0]))
      }
    }
  }

#define draw_pause
  var _e = instance_exists(menubutton);
  with OptionMenuButton  _e = false
  with AudioMenuButton   _e = false
  with VisualsMenuButton _e = false
  with GameMenuButton    _e = false
  with ControlMenuButton _e = false
  if _e = true && crown_current = "exchange"{
    for(var _i = 0; _i < maxp; _i++){
      draw_set_visible_all(false);
      draw_set_visible(_i, true);
      draw_crownhud(6 + view_xview[_i], 54 + view_yview[_i], _i);
      draw_set_visible_all(true);
    }
  }

#define draw_crownhud(X, Y, INDEX)
		var _array  = mod_variable_get("crown", "exchange", "nextwep"),
        _sprite = weapon_get_sprite(_array[INDEX, 0]),
        _w =  3 + s_w(_sprite), // total width
		    _h = 10 + s_h(_sprite), // total height
        _a = frac(_array[INDEX, 2]) = 0 ? 1 + (_array[INDEX, 2] mod 2) : 0,
        _s = global.sprHUDbHT;
        global.anim[INDEX, 0] = _w;
        global.anim[INDEX, 1] = _h;
        Y += max(_a - 1, 0);

    draw_set_alpha(.6);
    draw_rectangle_colour(X, Y, X + _w, Y + _h, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1);

		draw_sprite_ext(_s, _a, X, Y,      _w + 1, 1, 0, c_white, 1);
    _s = global.sprHUDbHB;
    draw_sprite_ext(_s, _a, X, Y + _h, _w + 1, 1, 0, c_white, 1);
    _s = global.sprHUDbVL;
    draw_sprite_ext(_s, _a, X, Y, 1, _h, 0, c_white, 1);
    _s = global.sprHUDbVR;
    draw_sprite_ext(_s, _a, X + _w, Y + 2, 1, _h - 1, 0, c_white, 1);

    _s = global.sprHUDcTL;
    draw_sprite(_s, _a, X, Y);
    _s = global.sprHUDcTR;
    draw_sprite(_s, _a, X + _w, Y);
    _s = global.sprHUDcBL;
    draw_sprite(_s, _a, X, Y + _h);
    _s = global.sprHUDcBR;
    draw_sprite(_s, _a, X + _w, Y + _h);

    var _align = draw_get_halign();
    draw_set_halign(1);
    draw_sprite_outline(_sprite, X + sprite_get_xoffset(_sprite) + 2, Y + sprite_get_yoffset(_sprite) + 5, _a);

    if frac(_array[INDEX, 2]) = 0{
      draw_set_font(fntChat);
      draw_text_nt(X + 2, Y + _h - 1, string(_array[INDEX, 2]));
      draw_set_font(fntM);
    }else{
      sleep(7);
      with instances_matching(Player, "index", INDEX){
        gunshine = 2;
        with instance_create(x, y, BloodLust){
          sprite_index = global.sprSwap;
          creator = other;
          image_speed = .3;
        }
        sound_play_pitch(sndRogueCanister, 2);
      }
      //global.anim[INDEX, 2] = -2;
    }
    draw_set_halign(_align);

  #define draw_sprite_outline(SPRITE, X, Y, ALPHA)
    draw_sprite(SPRITE, 1, X - 1, Y);
    draw_sprite(SPRITE, 1, X + 1, Y);
    draw_sprite(SPRITE, 1, X, Y - 1);
    draw_sprite(SPRITE, 1, X, Y + 1);
    draw_sprite_ext(SPRITE, 1, X, Y, 1, 1, 0, c_black, ALPHA);

#define s_w(SPRITE)
  return sprite_get_width(SPRITE);

#define s_h(SPRITE)
  return sprite_get_height(SPRITE);

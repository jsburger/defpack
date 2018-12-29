#define init
global.sprDonutBox      = sprite_add_weapon("sprDonutBox.png",0,4)
global.sprDonutBoxEmpty = sprite_add_weapon("sprDonutBoxEmpty.png",0,4)
#define weapon_name(w)
return "DONUT BOX"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return -1
#define weapon_load
return 5
#define weapon_swap
return sndSwapHammer
#define weapon_auto
return -1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire(w)
if !is_object(w){
    wep = {
        wep: mod_current,
        ammo: 6
    }
    w = wep
}
if w.ammo > 0{
    if skill_get(9) = true{var _hp = 2}else{var _hp = 1}//second stomach synergy
    if my_health <= maxhealth - _hp
    {
      my_health+=_hp;w.ammo--
      if _hp = 1
      {
        with instance_create(x,y,PopupText){target = other.index;text = "+1 HEALTH"}
        sound_play_pitch(sndHPPickup,random_range(.8,1.2)+.2)
      }
      else
      {
        with instance_create(x,y,PopupText){target = other.index;text = "+2 HEALTH"}
        sound_play_pitch(sndHPPickupBig,random_range(.8,1.2)+.2)
      }
    }
    else{with instance_create(x,y,PopupText){target = other.index;text = "MAX HEALTH"}}
}else
{
    sound_play_pitch(sndEnemySlash,random_range(1,1.3))
    with instance_create(x,y,ThrownWep)
    {
      sprite_index = global.sprDonutBoxEmpty
      speed = 4
      wep = other.wep
      creator = other
      team = other.team
      pet = other.index
      direction = other.gunangle
      other.wep = other.bwep
      other.bwep = 0
    }
}

#define weapon_sprt(w)
if is_object(w){if w.ammo > 0{return global.sprDonutBox}else{return global.sprDonutBoxEmpty}}else{return global.sprDonutBox}
#define weapon_text
return "delicious...."

#define step(p)
    var w = wep;
    if p = 0 w = bwep

    script_bind_draw(ammo_draw, -100, index, p, is_object(w) ? w.ammo : 6, (race == "steroids"));

//thank you yokin, i love you
#define ammo_draw(_index, _primary, _ammo, _steroids)
    instance_destroy();

    var _active = 0;
    for(var i = 0; i < maxp; i++) _active += player_is_active(i);

    draw_set_visible_all(0);
    draw_set_visible(_index, 1);
    draw_set_projection(0);

    var _x = (_primary ? 42 : 86),
        _y = 21;

    if(_active > 1) _x -= 19;

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    if(!_primary && !_steroids) draw_set_color(c_silver);

    draw_text_shadow(_x, _y, string(_ammo));

    draw_reset_projection();
    draw_set_visible_all(1);


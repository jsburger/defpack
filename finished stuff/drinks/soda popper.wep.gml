#define init
global.sprSodaPopper = sprite_add_weapon("sprSodaPopper.png",2,4)
global.sprSodaPopperEmpty = sprite_add_weapon("sprSodaPopperEmpty.png",2,4)
#define weapon_name
return "SODA POPPER"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return -1
#define weapon_swap
return sndSwapExplosive
#define weapon_auto
return false
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_text
return "THE FIZZY REVOLVER"
#define weapon_fire(w)
if is_object(w)
{
  if w.wep = mod_current
  {
    if w.ammo > 0
    {
      w.ammo--
      weapon_post(3,4,0)
      sound_play_pitch(sndSodaMachineBreak,random_range(.85,.95))
      sound_play_pitch(sndGunGun,1.4)
      with instance_create(x+lengthdir_x(4,gunangle),y+lengthdir_y(4,gunangle),ThrownWep)
      {
        var a = ["lightning blue lifting drink(tm)","extra double triple coffee","expresso","saltshake","munitions mist","vinegar","guardian juice"]
		if skill_get(14) > 0
		    array_push(a, "sunset mayo")
		if array_length(instances_matching(Player, "notoxic", 0))
		    array_push(a, "frog milk")
        wep = a[irandom(array_length(a)-1)]
        sprite_index = weapon_get_sprt(wep)
        speed = 12
        creator = other
        team = other.team
        direction = other.gunangle+random_range(-12,12)*other.accuracy
        with instance_create(x,y,MeleeHitWall)
        {
          image_angle = other.direction - 180
        }
      }
    }
    else
    {
      weapon_post(1,0,0)
      sound_play(sndEmpty)
      with instance_create(x,y,PopupText)
      {
        target = other.index
        text = "NO MORE JUICE!"
      }
    }
  }
}
else
{
  wep = {
        wep: mod_current,
        ammo: 6
    }
}

#define weapon_sprt(w)
var gsprite = global.sprSodaPopper
if instance_is(self,WepPickup){
    if !is_object(w){
        wep = {
            wep: mod_current,
            ammo: 6
        }
    }
}
else{
  if is_object(w){
    if w.ammo=0{gsprite = global.sprSodaPopperEmpty}
  }
}
return gsprite

#define weapon_load(w)
if is_object(w){if w.ammo>0{return 32}else{return 2}}

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

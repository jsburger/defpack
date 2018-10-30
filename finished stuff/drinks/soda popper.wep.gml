#define init
global.sprSodaPopper = sprite_add_weapon("sprSodaPopper.png",2,4)
global.sprSodaPopperEmpty = sprite_add_weapon("sprSodaPopperEmpty.png",2,4)
#define weapon_name(w)
if is_object(w) && w.wep = mod_current{
    return "SODA POPPER (" + string(w.ammo) + ")"
}
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
        if skill_get(14){wep = choose("lightning blue lifting drink(tm)","extra double triple coffee","autoproductive expresso","saltshake","munitions mist","vinegar","guardian juice","sunset mayo")}
        else {wep = choose("lightning blue lifting drink(tm)","extra double triple coffee","autoproductive expresso","saltshake","munitions mist","vinegar","guardian juice")}
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
if instance_is(self,WepPickup)
{
  if !is_object(w)
  {
    wep = {
        wep: mod_current,
        ammo: 6
    }
  }
}
else
{
  if is_object(w)
  {
    if w.ammo=0{gsprite = global.sprSodaPopperEmpty}
  }
}
return gsprite

#define weapon_load(w)
if is_object(w){if w.ammo>0{return 32}else{return 2}}
#define step
if instance_exists(WepPickup){with WepPickup{if wep = 0{instance_destroy()}}}

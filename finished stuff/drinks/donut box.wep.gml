#define init
global.sprDonutBox      = sprite_add_weapon("sprDonutBox.png",0,4)
global.sprDonutBoxEmpty = sprite_add_weapon("sprDonutBoxEmpty.png",0,4)
#define weapon_name(w)
if is_object(w) && w.wep = mod_current{
    return "DONUT BOX (" + string(w.ammo) + ")"
}
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
if is_object(w){
    if w.wep = mod_current{
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
    }
}
//i shouldnt need this, but just in case the player cheats and sets their wep to donut
else{
    wep = {
        wep: mod_current,
        ammo: 6
    }
}
#define weapon_sprt(w)
if instance_is(self,WepPickup) && !is_object(w){
    wep = {
        wep: mod_current,
        ammo: 6
    }
}
if is_object(w){if w.ammo > 0{return global.sprDonutBox}else{return global.sprDonutBoxEmpty}}else{return global.sprDonutBox}
#define weapon_text
return "delicious...."

#define step
with instances_matching(WepPickup,"wep",0){instance_destroy()}

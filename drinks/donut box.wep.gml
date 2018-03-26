#define init
global.sprDonutBox = sprite_add_weapon("sprDonutBox.png",0,4)
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
return choose(-1,6)
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
            if my_health < maxhealth  {my_health+=1;w.ammo--;with instance_create(x,y,PopupText){target = other.index;text = "+1 HEALTH"}}else{with instance_create(x,y,PopupText){target = other.index;text = "MAX HEALTH"}}
        }else{
            wep = 0
        }
    }
}
//i shouldnt need this, but just in case the player cheats and sets their wep to donut
else{
    wep = {
        wep: mod_current,
        ammo: 12
    }
}
#define weapon_sprt(w)
if instance_is(self,WepPickup) && !is_object(w){
    wep = {
        wep: mod_current,
        ammo: 12
    }
}
return global.sprDonutBox
#define weapon_text
return "delicious...."

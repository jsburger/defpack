#define init
global.color = 2
global.colors = ["stock", "pest", "fire", "psy", "thunder"]
global.customs = ["sniper rifle", "bullet cannon", "bullak cannon"]

/*
assault x rifle
double x minigun
x bullak cannon
x gunhammer
x bullet cannon
x machinegun
x minigun
x revolver
triple x machinegun
sniper x rifle
quad x machinegun
x smg

use string_replace on the x, swap for the element
*/

#define array_index_exists(array,index)
var o = array_length_1d(array);
for var i = 0; i < o; i++{
    if array[i] = index return 1
}
return 0

#define step
if global.color != 5 && global.color > 0{
    with instances_matching(WepPickup,"irischeck",null){
        if point_seen(x,y,-1){
            irischeck = 1
            color(wep)
            sprite_index = weapon_get_sprt(wep)
            name = weapon_get_name(wep)
        }
    }
}
if global.color = 5{
    
}

#define convert(wep)
switch wep{
    case wep_revolver:
        return "x revolver"
    case wep_machinegun:
        return "x machinegun"
    case wep_assault_rifle:
        return "assault x rifle"
    case wep_double_minigun:
        return "double x minigun"
    case wep_minigun:
        return "x minigun"
    case wep_smg:
        return "x smg"
    case wep_triple_machinegun:
        return "triple x machinegun"
    case wep_quadruple_machinegun:
        return "quad x machinegun"
    case wep_smart_gun:
        return "smart x gun"
    case wep_hyper_rifle:
        return "hyper x rifle"
    case "sniper rifle":
        return "sniper x rifle"
    case "bullet cannon":
        return "x bullet cannon"
    case "bullak cannon":
        return "x bullak cannon"
    default:
        return weapon_get_name(wep)
}

#define color(wp)
var str = wp;
var obj = 0
while is_object(str){
    obj++
    str = str.wep    
}
if is_real(str) || array_index_exists(global.customs,str){
    str = string_replace(convert(str),"x ", `${global.colors[global.color]} `)
}
else{
    for var i = 1; i < array_length_1d(global.colors); i++;{
        str = string_replace(str, global.colors[i], global.colors[global.color])
    }
}
if mod_exists("weapon",str){
   if obj with wep set_nest(str)
   else wep = str
}

#define set_nest(variable)
if is_object(wep){
    with wep set_nest(variable)
}
else wep = variable

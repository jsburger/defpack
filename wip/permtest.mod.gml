#define permission_register(variable,desc)
mod_script_call("mod","defpermissions","permission_register","mod",mod_current,variable,desc)

#define permission_register_options(variable,desc,options)
mod_script_call("mod","defpermissions","permission_register_options","mod",mod_current,variable,desc,options)

#define init
global.test1 = 1
permission_register("test1","Darkness")

global.test2 = 0
permission_register("test2","Funny Circle")

global.slider = 12
mod_script_call("mod","defpermissions","permission_register_range","mod",mod_current,"slider","Cool Slider",[5,40],["5", "40"])

global.shit = 2
permission_register_options("shit", "circle color", ["Player based", "Blue", "Red", "White"])

#define step
with TopCont darkness = global.test1

#define draw_gui
draw_circle_color(200,100,10,global.test2 ? c_lime : c_red,global.test2 ? c_lime : c_red,0)

var c = get_color(global.shit)
draw_circle_color(100, 100, 10, c, c, 0)

#define get_color(n)
switch (n){
    case 0: return player_get_color(0)
    case 1: return c_blue
    case 2: return c_red
    case 3: return c_white
}
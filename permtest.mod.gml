#define permission_register(variable,desc)
mod_script_call("mod","defpermissions","permission_register","mod",mod_current,variable,desc)

#define init
global.test1 = 1
permission_register("test1","Darkness")

global.test2 = 0
permission_register("test2","Funny Circle")

global.test3 = 0
permission_register("test3","Gamer1")
global.test4 = 0
permission_register("test4","Gamer2")
global.test6 = 0
permission_register("test6","Gamer3")
global.test5 = 0
permission_register("test5","Gamer4")

#define step
with TopCont darkness = global.test1

#define draw_gui
draw_circle_color(200,100,10,global.test2 ? c_lime : c_red,global.test2 ? c_lime : c_red,0)
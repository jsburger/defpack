#define init


while 1{
    with instances_matching_ne(UltraShell,"tsunamiturn",null){
        direction+=tsunamiturn *current_time_scale
        image_angle = direction
    }
    wait(0)
}

#define weapon_name
return "TSUNAMI"
#define weapon_type
return 2
#define weapon_cost
return 3
#define weapon_rads
return 32
#define weapon_area
return 24
#define weapon_load
return 10
#define weapon_swap
return sndSwapShotgun
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
var num = 10;
var int = 2*pi/3;
var sint = 2*pi/num
for (var i = -1; i <= 1; i+=2){
    if fork(){
        var h = i;
        for var o = 0; o < num; o++{
            var s = 10*sin((o*sint) + (int*h))
            with instance_create(x+lengthdir_x(s/2,gunangle+90),y+lengthdir_y(s/2,gunangle+90),UltraShell){
                motion_set(other.gunangle + s*2,14)
                projectile_init(other.team,other)
                tsunamiturn = -sign(s) * 3
            }
            wait(1)
        }
        exit
    }
    wait(1)
}


#define weapon_sprt
return sprUltraShotgun
#define weapon_text
return ""
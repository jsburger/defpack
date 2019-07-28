#define init

global.sprTsunami = sprite_add_weapon("sprites/sprTsunami.png", 3, 2);
while 1{
    with instances_matching_ne(UltraShell,"tsunamiturn",null){
        direction+=tsunamiturn *current_time_scale
        image_angle = direction
    }
    wait(0)
}
#define weapon_reloaded
#define weapon_name
return "TSUNAMI"
#define weapon_type
return 2
#define weapon_cost
return 2
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
sound_play_pitch(sndUltraShotgun,2)
sound_play_pitch(sndUltraPistol,.8)
sound_play_pitch(sndUltraShovel,.8)
var num = 10;
var int = 2*pi/3;
var sint = 2*pi/num
for (var i = -1; i <= 1; i+=2){
    if fork(){
        var h = i;
        for var o = 0; o < num; o++{
            var s = 10*sin((o*sint) + (int*h))
            with instance_create(x+lengthdir_x(s/2,gunangle+90),y+lengthdir_y(s/2,gunangle+90),UltraShell){
                move_contact_solid(other.gunangle,12)
                motion_set(other.gunangle + s*2,14)
                projectile_init(other.team,other)
                tsunamiturn = -sign(s) * 3
                sound_play_pitchvol(sndUltraShotgun,2,.4)
                with creator{weapon_post(5,0,2)}
            }
            wait(1)
        }
        exit
    }
    wait(1)
}


#define weapon_sprt
return global.sprTsunami
#define weapon_text
return ""

#define init
global.sprPhlogenitator     = sprite_add_weapon("sprites/sprPhlogenitator.png", 4, 4);
global.sprPhlogenitatorAnim = sprite_add("sprites/sprPhlogenitatorAnim.png", 11, 4, 4);
global.sprFatty 		 = sprite_add("sprites/sprFatShell.png",1,3,5)
global.sprSuperFatty = sprite_add("sprites/sprFatShellUpg.png",1,3,5)
global.gunindex = [0,0,0,0]

#define weapon_name
return "PHLOGENITATOR"

#define weapon_sprt
if instance_is(self,Player){
    if global.gunindex[index] > 0{
        gunshine = global.gunindex[index]
        if global.gunindex[index] = .01 global.gunindex[index] = 0
        return global.sprPhlogenitatorAnim
    }
}
return global.sprPhlogenitator;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 50;

#define weapon_cost
return 16;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 15;

#define weapon_reloaded

#define weapon_text
return "OH @rYEAH";

#define weapon_fire

if fork(){
    var ind = index, load = 0;
    while global.gunindex[ind] <= 11{
        global.gunindex[ind] += current_time_scale*.4
        if instance_exists(self) && floor(global.gunindex[ind]) = 4 && !load{
            repeat(interfacepop) with instance_create(x,y,Shell){
                move_contact_solid(other.gunangle,6)
                motion_set(other.gunangle+random_range(-15,15) + 90*other.right,random_range(3,5))
                if !skill_get(15){sprite_index = global.sprFatty}else{sprite_index = global.sprSuperFatty}
            }
            load = 1;
        }
        wait(0)
    }
    sound_play(sndShotReload)
    global.gunindex[ind] = .01
    wkick = -2
    exit
}

if fork(){
    var ang = gunangle + 180;
    repeat(4){
        if instance_exists(self){
            motion_set(ang,4)
            wait(1)
        }
    }
    exit
}
sound_play_pitch(sndMachinegun,1)
sound_play_pitch(sndCrossbow,1)
sound_play_pitch(sndShotgun,1)
sound_play_pitch(sndSuperFlakCannon,.7)
sound_play_pitch(sndIncinerator,.8)
sound_play_pitch(sndFlameCannonEnd,.6)
weapon_post(10,-30,25)
repeat(6)
{
	mod_script_call("mod", "defpack tools 2","create_flak",0,80,13,random_range(0.4,0.85),FlameShell,25,id)
}

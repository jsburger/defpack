#define init
global.sprFlakShotgun = sprite_add_weapon("sprites/sprFlakShotgun.png", 4, 4);
global.sprFlakShotgunAnim = sprite_add("sprites/sprFlakShotgunAnim.png", 11, 4, 4);
global.sprFatty = sprite_add("sprites/sprFatShell.png",1,3,5)
global.sprSuperFatty = sprite_add("sprites/sprFatShellUpg.png",1,3,5)
global.gunindex = [0,0,0,0]

#define weapon_name
return "FLAK SHOTGUN"

#define weapon_sprt_hud
return global.sprFlakShotgun

#define weapon_sprt
if instance_is(self,Player){
    if global.gunindex[index] > 0{
        gunshine = global.gunindex[index]
        if global.gunindex[index] = .01 global.gunindex[index] = 0
        return global.sprFlakShotgunAnim
    }
}
return global.sprFlakShotgun;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 47;

#define weapon_cost
return 8;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 11;

#define weapon_text
return "540/600";

#define weapon_reloaded
sound_play(sndShotReload)
wkick = -1

#define weapon_fire

if fork(){
    var ind = index, load = 0;
    while global.gunindex[ind] <= 10{
        global.gunindex[ind] += current_time_scale*.4
        if instance_exists(self) && (floor(global.gunindex[ind]) = 4 && !load){
            repeat(interfacepop) with instance_create(x,y,Shell){
                move_contact_solid(other.gunangle,6)
                motion_set(other.gunangle+random_range(-15,15) + 90*other.right,random_range(3,5))
                if !skill_get(15){sprite_index = global.sprFatty}else{sprite_index = global.sprSuperFatty}
            }
            load = 1;
        }
        wait(0)
    }
    sound_play_pitch(sndCrossReload,.6)
    global.gunindex[ind] = .01
    if instance_exists(self) wkick = -2
    exit
}

if fork(){
    var ang = gunangle + 180;
    repeat(4){
        if instance_exists(self){
            motion_set(ang,4)
        }
        wait(1)
    }
    exit
}
sound_play(sndMachinegun)
sound_play(sndCrossbow)
sound_play_pitch(sndShotgun,.7)
sound_play_pitch(sndFlakCannon,1.2)
sound_play_pitch(sndSuperFlakCannon,.7)
weapon_post(8,-90,46)
repeat(5){
	with instance_create(x,y,FlakBullet){
		team = other.team
		creator = other
        move_contact_solid(other.gunangle,10)
		motion_add(other.gunangle+(random_range(-40,40))*other.accuracy,random_range(9,12))
		image_angle = direction
	}
}

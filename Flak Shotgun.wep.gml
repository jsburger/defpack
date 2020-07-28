#define init
global.sprFlakShotgun     = sprite_add_weapon("sprites/weapons/sprFlakShotgun.png", 4, 4);
global.sprFlakShotgunAnim = sprite_add("sprites/weapons/sprFlakShotgunAnim.png", 11, 4, 4);
global.sprFatty      = sprite_add("sprites/other/sprFatShell.png",1,3,5)
global.sprSuperFatty = sprite_add("sprites/other/sprFatShellUpg.png",1,3,5)
global.gunindex = [0,0,0,0]

global.animarray = []
wait(3)
for var i = 0; i < 11; i++{
    array_push(global.animarray, sprite_duplicate_ext(global.sprFlakShotgunAnim, i, 1))
}

wait(60)
global.animarray = []
for var i = 0; i < 11; i++{
    array_push(global.animarray, sprite_duplicate_ext(global.sprFlakShotgunAnim, i, 1))
}


#define weapon_name
return "FLAK SHOTGUN"

#define weapon_sprt_hud
return global.sprFlakShotgun

#define weapon_sprt(w)
if instance_is(self,Player){
    if is_object(w){
        var q = lq_defget(w, "anim_index", 0)
        if q > 0 return global.animarray[floor(q)]
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
return "TOP RATED";

#define weapon_reloaded(p)
sound_play(sndShotReload)
if p wkick = -1
else bwkick = -1

#define weapon_fire(w)
if !is_object(w){
    w = {
        wep : mod_current,
        anim_index : 0,
        image_speed : 0,
        shell : 0
    }
    wep = w
}
w.anim_index = 0
w.image_speed = .4
w.shell = 1

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

var _p = random_range(.9, 1.2);
sound_play_pitch(sndMachinegun, _p)
sound_play_pitch(sndCrossbow, _p)
sound_play_pitch(sndShotgun, .7 * _p)
sound_play_pitch(sndFlakCannon, 1.2 * _p)
sound_play_pitch(sndSuperFlakCannon, .7 * _p)
weapon_post(8,-90,46)
repeat(5){
	with instance_create(x,y,FlakBullet){
        move_contact_solid(other.gunangle,10)
		motion_add(other.gunangle+(random_range(-40,40))*other.accuracy,random_range(9,12))
		projectile_init(other.team, other)
		image_angle = direction
	}
}

#define step(p)
if p goodstep(wep, 1, interfacepop)
else if race == "steroids" goodstep(bwep, -1, binterfacepop)

#define goodstep(w, f, n)
if is_object(w) and lq_defget(w, "image_speed", 0) > 0{
    w.anim_index += w.image_speed * current_time_scale
    if w.shell and floor(w.anim_index) == 7{
        w.shell = 0
        sound_play_pitchvol(sndGrenadeShotgun, 2.5*random_range(.9, 1.2), .8)
        if f wkick = 2
        else bwkick = 2
        repeat(n) with instance_create(x,y,Shell){
            move_contact_solid(other.gunangle, 12)
            motion_set(other.gunangle+random_range(-20, 20) + 90*other.right*f,random_range(6,9))
            image_angle = direction + 90
            friction *= 2.5
            sprite_index = skill_get(mut_shotgun_shoulders) > 0 ? global.sprSuperFatty : global.sprFatty
            repeat(8){
                with instance_create(x, y, Smoke){
                    motion_set(other.direction + random_range(-30, 30), random(3) + 1)
                    image_xscale /= 2
                    image_yscale /= 2
                }
            }
        }
    }
    if w.anim_index + w.image_speed * current_time_scale >= sprite_get_number(global.sprFlakShotgunAnim){
        if f wkick = -2
        else bwkick = -2
        sound_play_pitchvol(sndSwapPistol, 2*random_range(.9,1.2), .8)
        w.image_speed = 0
        w.anim_index = 0
    }
}

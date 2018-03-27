#define init
global.sprApergigTanat = sprite_add_weapon("sprites/Apergig Tanat.png", 0, 3);

#define weapon_name
return "APERGIG TANAT";

#define weapon_sprt
return global.sprApergigTanat;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 30;

#define weapon_cost
return 30;

#define weapon_swap
return sndSwapPistol

#define weapon_area
return 8;

#define weapon_reloaded
motion_add(gunangle,2)
sound_play_pitch(sndShotReload,1.05)
repeat(12){
    with instance_create(x,y,Smoke){
        motion_set(other.gunangle + 160*other.right+random_range(-6,6),random_range(1,4))
        image_xscale = .6
        image_yscale = .6
    }
}
repeat(interfacepop){
    with instance_create(x,y,CustomProjectile){
        team = other.team
        creator = other
        motion_set(other.gunangle + 160*other.right,20)
        on_step = shellstep
        on_wall = nothing
        damage = 10 + 10*skill_get(mut_shotgun_shoulders)
        sprite_index = skill_get(mut_shotgun_shoulders) ? sprShotShellBig : sprShotShell;
    }
}
#define nothing
move_bounce_solid(1)
if skill_get(mut_shotgun_shoulders) speed += 2

#define shellstep
image_angle += 4*speed_raw
speed /= 1 + (.2*current_time_scale)
if speed <= .01 instance_destroy()

#define weapon_text
return choose("MMMMH THATS SOME GOOD SHIT
RIGHT THERE
(RIGHT THERE)","THIS IS THE @yWAY");

#define weapon_fire

sound_play(sndGoldShotgun)
sound_play(sndGoldPistol)
sound_play(sndGoldTankShoot)
sound_play_pitch(sndSlugger,2)
sound_play_pitch(sndFlakCannon,.8)
motion_set(gunangle-180,4)
weapon_post(9,10,0)
with instance_create(x,y,Bullet2)
{
	force = 50
	damage = 1026
	motion_add(other.gunangle,22)
	image_xscale /= 2
	image_yscale /= 2
	team = other.team
	creator = other
	repeat(6){instance_create(x+lengthdir_x(random_range(1,6),direction),y+lengthdir_y(random_range(1,6),direction),Smoke)}
}

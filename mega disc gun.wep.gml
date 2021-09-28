#define init
global.sprMegaDiscGun    = sprite_add_weapon("sprites/weapons/sprMegaDiscGun.png",5,9);
global.sprMegaDiscGunHUD = sprite_add("sprites/interface/sprMegaDiscGunHUD.png",1,5,5);

#define weapon_name
return "MEGA DISC GUN"

#define weapon_type
return 3;

#define weapon_cost
return 4;

#define weapon_area
return 7;

#define weapon_load
return 55;

#define weapon_swap
if instance_is(self, Player){
	view_shake_at(x, y, 20);
	sleep(10);
}
sound_play_pitchvol(sndBasicUltra, 1.2, .6);
sound_play_pitch(sndSwapBow, .9);
return -4;

#define weapon_auto
return true;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_fire
weapon_post(12,-80,25)
sleep(20)
motion_add(gunangle-180,3)
var _p = random_range(.8,1.2);
sound_play_pitch(sndSuperDiscGun,.5*_p)
sound_play_pitch(sndDiscgun,.7*_p)
sound_play_pitch(sndNukeFire,.7*_p)
sound_play_pitchvol(sndDiscHit,.5*_p,.8)
sound_play_pitchvol(sndDiscDie,.4,.8*_p)
with mod_script_call("mod","defpack tools","create_megadisc",x,y)
{
  move_contact_solid(other.gunangle,14)
  team    = -100
  motion_add(other.gunangle+random_range(-6,6),5)
  maxspeed = speed
}
image_angle = direction

#define step
//with instances_matching(Player, "wep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}
//with instances_matching(instances_matching(Player, "race", "steroids"), "bwep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}
#define weapon_sprt
return global.sprMegaDiscGun;

//#define weapon_sprt_hud
//return global.sprMegaDiscGunHUD;

#define weapon_text
return "watch out"

#define nts_weapon_examine
return{
    "d": "Are you really tough enough to wield one of these? ",
}

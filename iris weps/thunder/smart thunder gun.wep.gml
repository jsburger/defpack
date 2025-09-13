#define init
global.sprSmartThunderGun = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprSmartThunderGun.png",8, 4);

#define weapon_name
return "SMART THUNDER GUN"

#define weapon_sprt
return global.sprSmartThunderGun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 4;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1sound_play_pitchvol(sndGammaGutsKill, 1.4, (.3 + .2 * skill_get(mut_laser_brain)) * vol)
if !skill_get(17)sound_play_pitch(sndLightningRifle,random_range(1.3,1.5))else sound_play_pitch(sndLightningRifleUpg,random_range(1.3,1.5))

#define weapon_text
return "ACTIVE NEURONS";

#define weapon_fire
	mod_script_call("mod", "defburst", "burst", 2, 3, self, script_ref_create(fire_burst))
	
#define fire_burst(_burst)
	var c = instance_is(self, FireCont) ? creator : self;
	
var ang = point_direction(x,y,mouse_x[index],mouse_y[index]);
if instance_exists(enemy)
{
	var mydude = instance_nearest(mouse_x[index],mouse_y[index],enemy);
	ang = point_direction(x,y,mydude.x,mydude.y)
}
gunangle = ang;
aimDirection = ang;
if fork(){
    wait(0)
    if !instance_exists(self) exit
    if!instance_exists(self) exit
    gunangle = ang;
    aimDirection = ang;
    exit
}
    if instance_exists(enemy)
    {
    	var mydude = instance_nearest(mouse_x[index],mouse_y[index],enemy);
    	ang = point_direction(x,y,mydude.x,mydude.y)
    }
    var vol = .7;
	sound_play_pitchvol(sndSmartgun,random_range(.8,1.2), vol)
	sound_play_pitchvol(sndGammaGutsKill,1.6,(.3+skill_get(17)*.2) * vol);
	if skill_get(mut_laser_brain) {
		sound_play_pitchvol(sndLightningRifleUpg,random_range(1.6,1.8), vol)
	}
	else {
		sound_play_pitchvol(sndLightningRifle,random_range(1.4,1.6), vol)
	}
	weapon_post(5,-2,6)
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_navy)
	if fork(){
	    var time = 8;
	    while time > 0 && instance_exists(self){
	        canaim = 0
	        time -= current_time_scale
	        wait(0)
	    }
	    if instance_exists(self) canaim = 1
	    exit
	}

	with mod_script_call("mod","defpack tools","create_lightning_bullet",x,y){
		motion_set(ang+random_range(-6,6)*other.accuracy,10)
		projectile_init(other.team,other)
		image_angle = direction
	}

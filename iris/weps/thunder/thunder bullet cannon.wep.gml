#define init
global.sprThunderBulletCannon = sprite_add_weapon("sprites/sprThunderBulletCannon.png", 9, 3);

#define weapon_name
return "THUNDER BULLET CANNON";

#define weapon_sprt
return global.sprThunderBulletCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 32;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "BOTTLED LIGHTNING";

#define weapon_fire
repeat(4)
{
	weapon_post(9,-6,42)
	var _ptch = random_range(-.4,.4);
	sound_play_pitch(sndPistol,.5)
	sound_play_pitch(sndMachinegun,1.6+_ptch)
	sound_play_pitchvol(sndSlugger,2+_ptch,.8)
	if skill_get(17)=0{sound_play_pitchvol(sndLightningCannon,1.4,.7)}else{sound_play_pitchvol(sndLightningCannonUpg,1.4,.7)}
	repeat(3)
	{
		mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(2), c_navy)
		with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x+lengthdir_x(random_range(-7,7)*accuracy,gunangle+90),y+lengthdir_y(random_range(-7,7)*accuracy,gunangle+90)){
			team = other.team
			creator = other
			move_contact_solid(other.gunangle,5)
			motion_add(other.gunangle+random_range(-10,10)*other.accuracy,10+random_range(-2,3)*other.accuracy)
			image_angle = direction
		}
	}
	wait(2)
	if !instance_exists(self) exit
}

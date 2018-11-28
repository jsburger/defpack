#define init
global.sprPrism = sprite_add_weapon("sprites/sprPrism.png", 7, 3);

#define weapon_name
return "PRISM"

#define weapon_sprt
return global.sprPrism;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 21;

#define weapon_cost
return 7;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 8;

#define weapon_text
return choose("DARK SIDE","@rP @yR @gI @bS @pM");

#define weapon_fire

sound_play_pitchvol(sndLaserCannonUpg,random_range(2.2,3),.7)
sound_play_pitch(sndBasicUltra,random_range(2.6,2.7))
weapon_post(7,0,16)
with mod_script_call("mod","defpack tools","create_fire_bullet",x,y){
	motion_add(other.gunangle-14+random_range(-3,3)*other.accuracy,7)
	image_angle = direction
	team = other.team
	creator = other
}
with instance_create(x,y,BouncerBullet){
	motion_add(other.gunangle-7+random_range(-3,3)*other.accuracy,10)
	image_angle = direction
	team = other.team
	creator = other
}
with mod_script_call("mod","defpack tools","create_toxic_bullet",x,y){
	motion_add(other.gunangle+random_range(-3,3),13)
	image_angle = direction
	team = other.team
	creator = other
}
with mod_script_call("mod","defpack tools","create_lightning_bullet",x,y){
	motion_add(other.gunangle+7+random_range(-3,3)*other.accuracy,10)
	image_angle = direction
	team = other.team
	creator = other
}
with mod_script_call("mod","defpack tools","create_psy_bullet",x,y){
	motion_add(other.gunangle+14+random_range(-3,3)*other.accuracy,7)
	image_angle = direction
	team = other.team
	maxspeed = 7
	creator = other
}

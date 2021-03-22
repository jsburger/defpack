#define init
global.sprPrism = sprite_add_weapon("sprites/weapons/sprPrism.png", 3, 9);

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
return 5;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 8;

#define weapon_text
return choose("DARK SIDE","@rP @yR @gI @bS @pM");

#define nts_weapon_examine
return{
	
	"fish"     : "You can see a faint hue in the reflections, #brown like mud. ",
	"crystal"  : "You can see a faint hue in the reflections, #yellow like your family. ",
	"eyes"     : "You can see a faint hue in the reflections, #the purple of indescribable mysteries",
	"plant"    : "You can see a faint hue in the reflections, #red like fresh blood. ",
    "melting"  : "You can see a faint hue in the reflections, #black as your fate. ",
    "venuz"    : "You can see a faint hue in the reflections, #green like endless piles of money. ",
    "robot"    : "You can see a faint hue in the reflections, #blue like those guns you love. ",
    "rebel"    : "You can see a faint hue in the reflections, #orange like the endless desert. ",
    "horror"   : "You can see a faint hue in the reflections, #a pink not from this world. ",
    "rogue"    : "You can see a faint hue in the reflections, #her indigo reflection ingrained in your head. ",
    "chicken"  : "You can see a faint hue in the reflections, #gray like your fondest memories. ",
    "skeleton" : "You can see a faint hue in the reflections, #white like your hope. ",
    "frog"     : "You can see a faint hue in the reflections, #gold as your voice. ",
    "d": "You can see a color shifting in the reflections. ",
}

#define weapon_fire

sound_play_pitchvol(sndLaserCannonUpg,random_range(2.2,3),.7)
sound_play_pitch(sndBasicUltra,random_range(2.6,2.7))
weapon_post(7,0,16)
with mod_script_call("mod","defpack tools","create_fire_bullet",x,y){
	motion_add(other.gunangle-14+random_range(-3,3)*other.accuracy,12)
	image_angle = direction
	team = other.team
	creator = other
}
with instance_create(x,y,BouncerBullet){
	motion_add(other.gunangle-7+random_range(-3,3)*other.accuracy,15)
	image_angle = direction
	team = other.team
	creator = other
}
with mod_script_call("mod","defpack tools","create_toxic_bullet",x,y){
	motion_add(other.gunangle+random_range(-3,3),18)
	image_angle = direction
	team = other.team
	creator = other
}
with mod_script_call("mod","defpack tools","create_lightning_bullet",x,y){
	motion_add(other.gunangle+7+random_range(-3,3)*other.accuracy,15)
	image_angle = direction
	team = other.team
	creator = other
}
with mod_script_call("mod","defpack tools","create_psy_bullet",x,y){
	motion_add(other.gunangle+14+random_range(-3,3)*other.accuracy,12)
	image_angle = direction
	team = other.team
	maxspeed = 7
	creator = other
}

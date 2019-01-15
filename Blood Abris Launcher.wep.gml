#define init
global.sprBloodAbrisLauncher = sprite_add_weapon("sprites/Blood Abris Launcher.png", 2, 4);
global.stripes = sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_name
return "BLOOD ABRIS LAUNCHER"

#define weapon_sprt
return global.sprBloodAbrisLauncher;

#define weapon_type
return 4;

#define weapon_auto
return 1;

#define weapon_load
return 19;

#define weapon_cost
return 0

#define weapon_swap
return sndSwapExplosive;

#define weapon_reloaded
weapon_post(-1,-3,0)
sound_play_pitchvol(sndNadeReload,1.4,.6)

#define weapon_area
return 7;

#define weapon_text
return "PROTECTION AT ALL COSTS";

#define weapon_fire
var _strtsize = 45-skill_get(13)*25
var _endsize  = 30;
sound_play_pitch(sndSniperTarget,1/accuracy+1.5)
if ammo[4] >= 2 || infammo != 0
{
	if infammo = 0 ammo[4] -= 2
}
else
{
	sprite_index = spr_hurt;
	sound_play(snd_hurt)
	image_index = 0;
	sound_play(sndBloodHurt);
	my_health --;
	lasthit = [global.sprBloodAbrisLauncher,"Blood Abris#Launcher"]
	sound_play(snd_hurt);
	sound_play(sndBloodLauncher)
	sound_play(sndBloodLauncherExplo)
}
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
	with creator weapon_post(5,12,45)
	accspeed = 1.33
	cost = 2
	damage = 2
    maxdamage = 6
	payload = script_ref_create(pop)
}


#define pop
with instance_create(x,y,BloodStreak){image_angle = other.creator.gunangle}
sound_play_pitch(sndBloodLauncher,random_range(.8,1.2))
sound_play_pitch(sndBloodLauncherExplo,random_range(.8,1.2))
creator.wkick = 2
repeat(4){
instance_create(explo_x+lengthdir_x(acc+12,offset),explo_y+lengthdir_y(acc+12,offset),MeatExplosion);
with instance_create(explo_x+lengthdir_x(acc+12,offset+90),explo_y+lengthdir_y(acc+12,offset+90),BloodStreak)
{
	image_angle = point_direction(x,y,mouse_x[other.index],mouse_y[other.index])
}
with instance_create(explo_x+lengthdir_x(acc+22,offset+45),explo_y+lengthdir_y(acc+22,offset+45),BloodStreak)
{
	image_angle = point_direction(x,y,mouse_x[other.index],mouse_y[other.index])
}
offset += 90
}

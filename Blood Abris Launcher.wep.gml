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
return 2

#define weapon_swap
return sndSwapExplosive;

#define weapon_reloaded
weapon_post(-1,-3,0)
sound_play_pitchvol(sndNadeReload,1.4,.6)

#define weapon_area
return 10;

#define weapon_text
return "PROTECTION AT ALL COSTS";

#define step(p)
if ammo[weapon_type()] < weapon_cost(){
    if (p and button_pressed(index, "fire")) or (!p and race = "steroids" and button_pressed(index, "spec")){
        projectile_hit(self, 1)
        lasthit = [global.sprBloodAbrisLauncher,"Blood Abris#Launcher"]
        sound_play(sndBloodHurt);
        ammo[weapon_type()] += weapon_cost()
    }
}

#define weapon_fire
var _strtsize = 45-skill_get(13)*25
var _endsize  = 30;
sound_play_pitch(sndSniperTarget,1/accuracy+1.5)
with mod_script_call_self("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
	accspeed = 1.33
	cost = 2
	damage = 2
    maxdamage = 6
	payload = script_ref_create(pop)
}


#define pop
with instance_create((x + creator.x)/2, (y + creator.y)/2, BloodStreak){
    image_angle = point_direction(x, y, other.x, other.y)
}
sound_play_pitch(sndBloodLauncher, random_range(.8, 1.2))
sound_play_pitch(sndBloodLauncherExplo, random_range(.8, 1.2))
if isplayer with creator weapon_post(5,12,45)
var r = acc + accmin - 12
repeat(4){
    with instance_create(x + lengthdir_x(r, offset), y + lengthdir_y(r, offset), MeatExplosion){
        team = other.creator.team
    }
    with instance_create(x + lengthdir_x(r, offset + 90), y + lengthdir_y(r, offset + 90), BloodStreak){
    	image_angle = other.offset + 90
    }
    with instance_create(x + lengthdir_x(r + 10, offset + 45), y + lengthdir_y(r + 10, offset + 45), BloodStreak){
    	image_angle = other.offset + 45
    }
    offset += 90
}

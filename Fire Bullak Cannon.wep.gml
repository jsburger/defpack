#define init
global.sprFireBullakCannon = sprite_add_weapon("sprites/sprFireBullakCannon.png", 3, 3);

#define weapon_name
return "FIRE BULLAK CANNON"

#define weapon_sprt
return global.sprFireBullakCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 14;

#define weapon_cost
return 20;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 7;

#define weapon_text
return choose("HOTTEST SCORE","LIKE SEVEN INCHES#FROM THE MIDDAY SUN");

#define weapon_fire
weapon_post(4,-6,7)
repeat(10)
{
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_red)
}
sound_play_pitch(sndPistol,random_range(0.7,0.8))
sound_play_pitch(sndGrenadeRifle,random_range(1.1,1.3))
sound_play_pitch(sndFlakCannon,random_range(1.1,1.3))
sound_play_pitchvol(sndSwapFlame,random_range(1.4,1.6),.7)
sound_play_pitchvol(sndIncinerator,1,.2)
sound_play_pitchvol(sndFlameCannon,random_range(1.8,2.2),.8)
mod_script_call("mod", "defpack tools 2","create_flak",0,52,13,0,1,8,id)

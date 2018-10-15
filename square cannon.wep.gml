#define init
global.sprSquareCannon = sprite_add_weapon("sprites/sprSquareCannon.png", 0, 2);

#define weapon_name
return "SQUARE CANNON"

#define weapon_sprt
return global.sprSquareCannon;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 73;

#define weapon_cost
return 16;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 16;

#define weapon_text
return choose("THE CUBE","IT HUNTS");

#define weapon_fire
sound_play_pitch(sndSlugger,random_range(1.8,2))
if skill_get(17) = true
{
	sound_play_pitchvol(sndDevastatorUpg,random_range(1.8,2),.4)
		sound_play_pitch(sndPlasmaBigUpg,random_range(1.3,1.5))
}
else
{
	sound_play_pitchvol(sndDevastator,random_range(1.8,2),.4)
	sound_play_pitch(sndPlasmaBig,random_range(1.3,1.5))
}
weapon_post(9,0,68)
with mod_script_call("mod","defpack tools","create_supersquare",x,y)
{
	move_contact_solid(other.gunangle,16)
	creator = other
	team    = other.team
	pseudoteam = team
	size    = 4
	motion_add(other.gunangle+random_range(-6,6)*creator.accuracy,6)
	with Wall
	{
		if distance_to_object(other) <= 16
		{
			instance_create(x,y,FloorExplo)
			instance_destroy()
		}
	}
}

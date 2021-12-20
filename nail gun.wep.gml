#define init
global.sprNailGun = sprite_add_weapon("sprites/weapons/sprNailGun.png", 1, 3);

#define weapon_name
return "NAIL GUN"

#define weapon_sprt
return global.sprNailGun;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 10;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 3;

#define weapon_text
return "TAC TAC TAC";

#define nts_weapon_examine
return{
    "d": "An ex-tool repurposed for combat. #The label on the back says `KEEP AWAY FROM CHILDREN`. ",
}
#define weapon_fire
repeat(2) {
	
	sound_play_pitchvol(sndSplinterGun,random_range(1.3,1.6),.4)
	sound_play_pitchvol(sndRustyRevolver,random_range(1.5,1.8),.4)
	sound_play_pitchvol(sndCrossbow,random_range(1.3,1.6),.7)
	sound_play_pitchvol(sndPopgun,random_range(1.3,1.6),.7)
	weapon_post(2,4,0)

	with instance_create(x,y,Splinter)	{
		
		team = other.team
		motion_add(other.gunangle+random_range(-7,7)*other.accuracy,16)
		image_angle = direction
		creator = other
	}
	wait(2);
}
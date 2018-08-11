#define init
global.sprQuadBouncerMachinegun = sprite_add_weapon("sprites/sprQuadBouncerMachinegun.png", 3, 4);

#define weapon_name
return "QUAD BOUNCER MACHINEGUN"

#define weapon_sprt
return global.sprQuadBouncerMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 5;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return choose("THE POWER");

#define weapon_fire

sound_play_pitch(sndBouncerSmg,random_range(.9,1.1))
sound_play_pitch(sndQuadMachinegun,random_range(.8,1.2))
weapon_post(6,0,16)
repeat(4)with instance_create(x,y,Shell){motion_add(other.gunangle+other.right*100+random(80)-40,2+random(3))}
for var i = -1.5; i <= 1.5; i+= 1{
    with instance_create(x,y,BouncerBullet){
    	team = other.team
    	creator = other
    	motion_add(other.gunangle+i*15+random_range(-9,9)*other.accuracy,6)
    }
}

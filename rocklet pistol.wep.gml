#define init
global.sprRockletPistol = sprite_add_weapon("sprites/sprRockletPistol.png", 0, 2);

#define weapon_name
return "ROCKLET PISTOL";

#define weapon_sprt
return global.sprRockletPistol;

#define weapon_type
return 4;

#define weapon_auto
return 0;

#define weapon_load
return 27;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 3;

#define weapon_text
return "DRIZZLE";

#define weapon_fire
if fork(){
    sound_play_pitch(sndToxicBoltGas,1.2)
    repeat(3) if instance_exists(self){
        weapon_post(4,-7,6)
        sound_play_pitch(sndSlugger,2.2)
        sound_play_pitch(sndServerBreak,random_range(.6,.8))
        sound_play_pitch(sndComputerBreak,random_range(.8,.9))
        sound_play_pitch(sndRocketFly,4)
        sound_play_pitch(sndSodaMachineBreak,3)
        repeat(3)with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),Dust){
            motion_set(other.gunangle+choose(0,60,-60,0,0)+random_range(-15,15),sqr(1.4+random(1)))
        }
        with mod_script_call("mod","defpack tools", "create_rocklet",x,y)
        {
            creator = other
            team = creator.team
            move_contact_solid(other.gunangle,10)
            direction_goal = other.gunangle
            motion_add(other.gunangle+random_range(-45,45)*creator.accuracy,2)
            image_angle = direction
        }
        wait(2)
    }
}

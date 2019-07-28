#define init
global.sprRockletRifle = sprite_add_weapon("sprites/weapons/sprRockletRifle.png", 4, 1);

#define weapon_name
return "ROCKLET RIFLE";

#define weapon_sprt
return global.sprRockletRifle;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 20;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 7;

#define weapon_text
return "STORM";

#define weapon_fire
if fork(){
    sound_play_pitch(sndToxicBoltGas,.85)
    repeat(4 + (1* (GameCont.crown == crwn_death))) if instance_exists(self){
        weapon_post(5,-7,4)
        sound_play_pitch(sndHeavySlugger,1.5)
        sound_play_pitch(sndServerBreak,random_range(.5,.8))
        sound_play_pitch(sndComputerBreak,random_range(.8,.9))
        sound_play_pitch(sndRocketFly,4)
        sound_play_pitch(sndSodaMachineBreak,3)
        sound_play_pitch(sndSuperSplinterGun,2)
        repeat(3)with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),Dust){
            motion_set(other.gunangle+choose(0,60,-60,0,0)+random_range(-15,15),sqr(1.4+random(1)))
        }
        repeat(2){
            with mod_script_call("mod","defpack tools", "create_rocklet",x,y)
            {
                creator = other
                team = creator.team
                move_contact_solid(other.gunangle,10)
                direction_goal = other.gunangle
                motion_add(other.gunangle+random_range(-25,25)*creator.accuracy,3)
                image_angle = direction
            }
        }
        wait(2)
    }
}

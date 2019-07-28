#define init
global.sprRockletShotgun = sprite_add_weapon("sprites/sprRockletShotgun.png", 4, 2);

#define weapon_name
return "ROCKLET SHOTGUN";

#define weapon_sprt
return global.sprRockletShotgun;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 24;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return -1;

#define weapon_text
return "SPRAY";

#define weapon_fire
if fork(){
    repeat(5){
      weapon_post(7,-3,17)
        sound_play_pitch(sndSlugger,2)
        sound_play_pitch(sndDoubleShotgun,.8)
        sound_play_pitch(sndShotgun,1.2)
        sound_play_pitch(sndRocketFly,random_range(2.6,3.2))
        sound_play_pitch(sndGrenadeRifle,random_range(.3,.4))
        sound_play_pitch(sndComputerBreak,random_range(.4,.5))
        sound_play_pitch(sndMachinegun,random_range(.7,.8))
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
}

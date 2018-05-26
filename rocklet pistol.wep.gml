#define init
global.sprRockletPistol = sprite_add_weapon("sprites/sprRockletPistol.png", -1, 1);

#define weapon_name
return "ROCKLET PISTOL";

#define weapon_sprt
return global.sprRockletPistol;

#define weapon_type
return 4;

#define weapon_auto
return 0;

#define weapon_load
return 20;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 3;

#define weapon_text
return "replace me please";

#define weapon_fire
if fork(){
    sound_play_pitch(sndToxicBoltGas,.85)
    repeat(3) if instance_exists(self){
        weapon_post(4,-3,6)
        with instance_create(x,y,Smoke) motion_add(other.gunangle+180,random_range(2,4))
        sound_play_pitch(sndPistol,2)
        sound_play_pitch(sndRocketFly,random_range(2.6,3.2))
        with mod_script_call("mod","defpack tools", "create_rocklet",x,y)
        {
            creator = other
            team = creator.team
            move_contact_solid(other.gunangle,8)
            motion_add(other.gunangle+random_range(-6,6)*creator.accuracy,2)
            image_angle = direction
        }
        wait(2)
    }
}

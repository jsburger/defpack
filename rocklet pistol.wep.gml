#define init
global.sprRockletPistol = sprite_add_weapon("sprites/weapons/sprRockletPistol.png", 0, 3);

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
return 6;

#define nts_weapon_examine
return{
    "d": "A small-arms rocket pistol from the future. #The gun is rather shiny. ",
}

#define weapon_text
return choose("THE FUTURE OF PISTOLS", "ROCKLET EXPLOSIONS DEAL#LESS DAMAGE THAN MOST");

#macro lib "rocklets"

#define weapon_fire
    weapon_post(4,-7,6)
    sound_play_pitch(sndToxicBoltGas,1.2)
    sound_play_pitch(sndRocketFly,4)
    // sound_play_pitch(sndSlugger,2.2)
    // sound_play_pitch(sndServerBreak,random_range(.6,.8))
    // sound_play_pitch(sndComputerBreak,random_range(.8,.9))
    // sound_play_pitch(sndSodaMachineBreak,3)

    repeat(3) with instance_create(x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), Dust){
        motion_set(other.gunangle + choose(0, 60, -60, 0, 0) + random_range(-15, 15), sqr(1.4 + random(1)))
    }

    var _creator = instance_is(self, FireCont) && "creator" in self ? creator : self;
    repeat(3 + (1 * (crown_current == crwn_death))) {
        with mod_script_call("mod", lib, "create_rocklet", x + lengthdir_x(4, gunangle), y + lengthdir_y(4, gunangle)) {
            creator = _creator
            team = creator.team
            move_contact_solid(other.gunangle, 12)

            motion_set(other.gunangle + choose(-90, 90) + random_range(-10, 10), random(.15) + (rocklet_number mod 3)/2 + 1)
        }
    }

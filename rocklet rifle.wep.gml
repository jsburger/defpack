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
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 8;

#define nts_weapon_examine
return{
    "d": "A small-arms rocket rifle from the future. #Easy to reload. ",
}

#define weapon_text
return choose("THE FUTURE OF RIFLES", "ROCKLET EXPLOSIONS DEAL#LESS DAMAGE THAN MOST");

#macro lib "rocklets"

#define weapon_fire
    weapon_post(5,-7,4)
    var volume = .8
    sound_play_pitchvol(sndToxicBoltGas, .85, volume)
    sound_play_pitchvol(sndHeavySlugger, 1.5, volume)
    sound_play_pitchvol(sndRocketFly, 4, volume)
    sound_play_pitchvol(sndServerBreak, random_range(.5, .8), volume)
    sound_play_pitchvol(sndComputerBreak, random_range(.8, .9), volume)
    sound_play_pitchvol(sndSodaMachineBreak, 3, volume)
    sound_play_pitchvol(sndSuperSplinterGun, 2, volume)

    repeat(3) with instance_create(x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), Dust) {
        motion_set(other.gunangle + choose(0,60,-60,0,0)+random_range(-15,15),sqr(1.4+random(1)))
    }
    var _creator = instance_is(self, FireCont) && "creator" in self ? creator : self;
    repeat(8 + (2 * (GameCont.crown == crwn_death))) {
        with mod_script_call("mod", lib, "create_rocklet", x, y) {
            creator = _creator
            team = creator.team
            move_contact_solid(other.gunangle, 10)

            motion_set(other.gunangle + choose(-90, 90) + random_range(-10, 10), random(.5) + (rocklet_number mod 4)/2 + 1)
        }
    }
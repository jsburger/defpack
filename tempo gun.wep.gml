#define init
global.sprTempoGun = sprite_add_weapon("sprites/sprTempoGun.png",2,3);
#macro maxcombo 4

//Credit to Smash Brothers (aka matt on the discord) for this gun

#define weapon_name             return "TEMPO GUN";
#define weapon_text             return ["TO THE RHYTHM"];

#define weapon_sprt             return global.sprTempoGun;
#define weapon_swap             return sndSwapPistol;

#define weapon_auto             return true;
#define weapon_load             return 7;
#define weapon_type             return 1;
#define weapon_cost             return 2;
#define weapon_rads             return 0;

#define weapon_area             return 5;

#define weapon_melee            return false;
#define weapon_gold             return false;
#define weapon_laser_sight      return false;

#define orandom(_n)             return irandom_range(_n, _n);

#define weapon_reloaded(_pwep)

#define step(_pwep)

#define weapon_fire(_pwep)
    if ("tempogun" not in self){
        tempogun = 0;
    }

    for (var i = -1; i <= 1; i += 2){

        var l = 8,
            d = gunangle + 90 * i,
            xx = x + lengthdir_x(l, d),
            yy = y + lengthdir_y(l, d);

         // max combo
        if tempogun mod maxcombo == maxcombo - 1{
            sound_play_gun(sndSlugger, 0.3, 0.6);
            weapon_post(8, 4, 12);

            with instance_create(xx, yy, Slug){
                creator =   other;
                team =      other.team;

                direction = other.gunangle;
                speed =     16;
            }
        }

         // other fire
        else{
            sound_play_gun(sndPopgun, 0.3, -0.3);
            weapon_post(4, 2, 4);

            with instance_create(xx, yy, Bullet2){
                creator =   other;
                team =      other.team;

                direction = other.gunangle;
                speed =     12;
            }
        }
    }

    tempogun++;

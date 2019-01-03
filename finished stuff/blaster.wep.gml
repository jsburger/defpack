#define init
global.sprFireBeamer = sprite_add_weapon("sprFireBeamer.png", 2, 3);

#define weapon_name
return "BLASTER";

#define weapon_sprt
return global.sprFireBeamer;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 34;

#define weapon_cost
return 2;

#define weapon_melee
return 0;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 5;

#define weapon_text
return "HEAT WAVES";

#define weapon_fire
weapon_post(8,8,4)
var things = [SmallExplosion,CustomObject,Explosion],
    lengths = [30,55,100],
    ang = gunangle,
    _x = x, _y = y;

    for (var i = 0; i < array_length(things); i++){
        if instance_exists(self){
            var _pitch = random_range(.8,1.2);
             if i = 2{
                sleep(30)
                _pitch += .1
            }
            sound_play_pitch(sndGrenadeRifle,.8*_pitch)
            sound_play_pitch(sndGrenadeShotgun,1.5*_pitch)
            sound_play_pitch(sndExplosion,_pitch)
            with instance_create(_x+lengthdir_x(lengths[i] + speed,ang),_y+lengthdir_y(lengths[i]+speed,ang),things[i]){
                creator = other
                if i > 0{
                    repeat(2 + (1 * (GameCont.crown == crwn_death)))with instance_create(x,y,SmallExplosion) creator = other.creator
                    if i = 1 instance_destroy()
                }
            }
        }
        wait(2)
    }




/*with instance_create(x+lengthdir_x(26,gunangle),y+lengthdir_y(26,gunangle),SmallExplosion){damage = round(damage/2);team = other.team}
repeat(6)
{
	repeat(2)with instance_create(x+lengthdir_x(2,direction)+random_range(-2,2),y+lengthdir_y(2,direction)+random_range(-2,2),Smoke)motion_set(other.gunangle + random_range(-8,8), 1+random(3))
	repeat(4)with instance_create(x,y,Flame){move_contact_solid(other.gunangle,2)team = other.team;motion_add(other.gunangle+random_range(-14,14)*(1-skill_get(19)),3+random(6))}
}
*/

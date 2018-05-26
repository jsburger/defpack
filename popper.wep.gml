#define init
global.sprPopper = sprite_add_weapon("sprites/sprPopper.png", 4, 1);
#define weapon_name
return "POPPER";

#define weapon_sprt
return global.sprPopper;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 4;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 3;

#define weapon_text
return "POP POP";

#define weapon_fire

weapon_post(4,0,22)
sound_play_pitch(sndPopgun,.7+random_range(-.1,.1))
sound_play_pitch(sndMachinegun,.8+random_range(-.1,.1))
with instance_create(x,y,Bullet2)
{
	creator = other
	team = other.team
	image_xscale = 4/3
	image_yscale = 4/3
	move_contact_solid(other.gunangle,6)
	motion_add(other.gunangle + random_range(-10,10)*other.accuracy,20)
	friction+=1.2
	damage += 4
	image_angle = direction
	if fork(){
	    var _x,_y,_d,_t,_c;
	    _t = team
	    _c = creator
	    while instance_exists(self) && sprite_index != sprBullet2Disappear{
	        _x = x
	        _y = y
	        _d = direction
	        wait(0)
	    }
	    var ang = _d + 30;
	    sound_play_pitch(sndFlakExplode,1.25)
	    repeat(2){
        	with instance_create(_x,_y,Bullet2)
        	{
        		creator = _c
        		team = _t
        		motion_add(ang,12)
        		image_angle = direction
        	}
        	ang -= 60
        }
	    exit
	}
}


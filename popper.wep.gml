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
return 6;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 4;

#define weapon_text
return "POP (POP) POP";

#define weapon_fire

weapon_post(4,0,22)
sound_play_pitch(sndPopgun,.7+random_range(-.1,.1))
sound_play_pitch(sndMachinegun,.8+random_range(-.1,.1))
with instance_create(x, y, Shell){
    motion_set(other.gunangle + 70 * other.right, random_range(2, 5))
    image_xscale = 4/3
    image_yscale = 4/3
}
with instance_create(x + lengthdir_x(4, gunangle),y + lengthdir_y(4, gunangle),Bullet2){
	creator = other
	team = other.team
	image_xscale = 4/3
	image_yscale = 4/3
	accuracy = other.accuracy
	motion_add(other.gunangle + random_range(-10,10)*other.accuracy,14)
	damage += 3
	image_angle = direction
	if fork(){
        var _team = team;
        var _acc  = accuracy;
        var _crtr = creator;
        while instance_exists(self) && sprite_index != sprBullet2Disappear{var _x = x;var _y = y;wait(0)}
		var i = random(360);
		repeat(3){
			with instance_create(_x,_y,Bullet2){
				sound_play_pitchvol(sndFlakExplode,random_range(1.3,1.5),.2)
				instance_create(x,y,Dust)
				creator = _crtr
				team    = _team
				motion_add(i+random_range(-30,30)*_acc,10)
				image_angle = direction
			}
			i += 360/3
		}
		if instance_exists(self) instance_destroy()
    }
}

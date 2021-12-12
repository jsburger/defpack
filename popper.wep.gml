#define init
  global.sprPopper = sprite_add_weapon("sprites/weapons/sprPopper.png", 4, 1);
  global.sprPopperBullet = sprite_add("sprites/projectiles/sprPopperBullet.png", 2, 11, 11);

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

#define nts_weapon_examine
return{
    "d": "A hugely unpopular high caliber pop gun. #The bursts of air used for firing are slowly tearing the gun apart. ",
}
#define weapon_fire

weapon_post(4,5,3)
var _p = random_range(.8, 1.2);
sound_play_pitch(sndPopgun,.7 * _p)
sound_play_pitch(sndMachinegun,.8 * _p)
with instance_create(x, y, Shell){
    motion_set(other.gunangle + (random_range(-20, 20) + 90) * other.right, random_range(2, 5))
}
with instance_create(x + lengthdir_x(4, gunangle),y + lengthdir_y(4, gunangle),Bullet2){
	creator = other
	team = other.team
  sprite_index = global.sprPopperBullet;
	accuracy = other.accuracy
	motion_add(other.gunangle + random_range(-4,4)*other.accuracy,15)
	damage += 3
	image_angle = direction
	if fork(){
        var _team = team;
        var _acc  = accuracy;
        var _crtr = creator;
        while instance_exists(self) && sprite_index != sprBullet2Disappear{var _x = x;var _y = y;wait(0)}
		var i = random(360);
    sleep(1)
    view_shake_at(_x, _y, 5)
		repeat(3){
			with instance_create(_x,_y,Bullet2){
				sound_play_pitchvol(sndFlakExplode,random_range(1.3,1.5),.2)
				instance_create(x,y,Dust)
				creator = _crtr
				team    = _team
				motion_add(i+random_range(-30,30)*_acc,10 + skill_get(mut_shotgun_shoulders) * 2)
				image_angle = direction
			}
			i += 360/3
		}
		if instance_exists(self) instance_destroy()
    }
}

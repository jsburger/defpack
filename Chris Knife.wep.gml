#define init
global.sprKnife 	= sprite_add_weapon("sprites/Knife.png", 0, 2);
global.sprKillslash  = sprite_add("sprites/projectiles/Killslash.png"	,8,16,16);
global.sprKnifeshank  = sprite_add("sprites/projectiles/knifeshank.png"	,2,0,8);
#define weapon_name
return "CHRIS KNIFE";

#define weapon_sprt
return global.sprKnife;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 9;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapSword;

#define weapon_area
return 12;

#define weapon_text
return choose("IS IT STATTRACK","A NICER DICER","CRITICAL");

#define weapon_fire
wepangle = -wepangle
weapon_post(4,0,42)
sleep(70)
motion_add(gunangle,7)
with instance_create(x+lengthdir_x(12,gunangle),y+lengthdir_y(12,gunangle),CustomSlash){
    sound_play(sndScrewdriver)
    sound_play_pitch(sndBlackSword,random_range(1.3,1.45))
    damage = 8
    team = other.team
    image_speed = .491
    creator = other
    can_crit = 1
    on_hit = knife_hit
    image_angle = other.gunangle+random_range(-14,14)
	motion_add(other.gunangle, 2 + (skill_get(13) * 3.5))
    sprite_index = global.sprKnifeshank
    if fork(){
        while instance_exists(self){
          with projectile{if place_meeting(x,y,other)&&image_speed != .491{instance_destroy()}}
            with enemy if place_meeting(x,y,other) && irandom(8-(skill_get(6)*2)) = 0 && other.can_crit = 1{
              view_shake_max_at(x,y,200)
              sleep(150)
              can_crit = 0
				if "hy_health" in self my_health -= 30
                with instance_create(x,y,CustomObject){
					sound_play_pitchvol(sndHammerHeadEnd,random_range(1.23,1.33),20)
          sound_play_pitchvol(sndBasicUltra,random_range(0.9,1.1),20)
          sound_play_pitch(sndCoopUltraA,random_range(3.8,4.05))
                    image_angle = random(359)
					depth = other.depth -1
                    image_speed = .6
                    sprite_index = global.sprKillslash
                    image_xscale = random_range(1.3,1.5)
                    image_yscale = image_xscale
					on_step = Killslash_step
					with instance_create(x,y,CustomObject){
						image_angle = other.image_angle - 90+random_range(-8,8)
						depth = other.depth
						image_speed = .8
						sprite_index = global.sprKillslash
						image_blend = c_black
						image_xscale = other.image_xscale-.5
						image_yscale = image_xscale
						on_step = Killslash_step
					}
                }
            }
            can_crit = 0
            wait(1);
        }
        exit
    }
}

#define knife_hit
if other.sprite_index != other.spr_hurt{projectile_hit(other,damage,5,creator.gunangle)}
#define Killslash_step
if image_index >= 7 instance_destroy();

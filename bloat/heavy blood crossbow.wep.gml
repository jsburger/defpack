#define init
global.sprHeavyBloodCrossbow = sprite_add_weapon("sprHeavyBloodCrossbow.png", 3, 6);
global.sprHeavyBloodBolt = sprite_add("sprHeavyBloodBolt.png",0, 1, 5);

#define weapon_name
return "HEAVY BLOOD CROSSBOW"

#define weapon_sprt
return global.sprHeavyBloodCrossbow;

#define weapon_type
return 3;

#define weapon_auto
return true;

#define weapon_load
return 42;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 13;

#define weapon_text
return choose("HIT: GET A BLOODY REWARD
MISS: GET BONED","THE BONER ZONER");

#define weapon_fire
if infammo <= 0{
	if ammo[3] - 2 < 0{
		ammo[3] = 0;
		projectile_hit(self,1)
		sound_play_pitch(sndBloodHurt,.9);
	}
	else
	{
		ammo[3] -= 2
		sound_play_pitch(sndHeavyCrossbow,.8)
		sound_play_pitch(sndBloodLauncher,.8)
	}
}
weapon_post(10,-70,12)
with instance_create(x,y,HeavyBolt)
{
	team = other.team
	check = 0
	creator = other
	motion_add(other.gunangle,17)
	sprite_index = global.sprHeavyBloodBolt
	damage = 40
	with instance_create(x+hspeed*2.3,y+vspeed*2.3,BloodStreak)
	{
		image_angle = other.direction
	}
	image_angle = direction
  with instance_create(x,y,BoltTrail)
  {
    image_blend = c_red
    image_angle = other.direction
    image_yscale = 1.4
    image_xscale = other.speed
  }
	if fork(){
		while(instance_exists(self)){
			with instance_create(x,y,BoltTrail)
		  {
		    image_blend = c_red
		    image_angle = other.direction
		    image_yscale = 1.4
		    image_xscale = other.speed
		  }
			if place_meeting(x+hspeed,y+vspeed,enemy){
				check = 1
				repeat(4){
					sound_play(sndBloodLauncherExplo)
					with instance_create(x + random_range(-4,4),y +random_range(-4,4),MeatExplosion) {team = other.team}
				}
				if irandom(6) = 1 {
					with creator{
						instance_create (other.x,other.y,BloodLust)
						my_health += 1
						if my_health > maxhealth {my_health = maxhealth}
						with instance_create(other.x,other.y,PopupText){
							target = other.index
							if other.my_health = other.maxhealth - 1 {mytext = "MAX HP"}
							if other.my_health < other.maxhealth - 1 {mytext = "+1 HP"}
						}
					}
				}
			}
			if place_meeting(x+hspeed,y+vspeed,Wall) && check = 0 {
				check = 1
				if irandom(2) = 1 {projectile_hit(creator,1);with creator{lasthit = [global.sprHeavyBloodCrossbow,"Heavy Blood#Crossbow"]}}
				repeat(4){
					sound_play(sndBloodLauncherExplo)
					instance_create(x + random_range(-4,4),y +random_range(-4,4),MeatExplosion)
				}
			}
			wait(1)
		}
	}
}

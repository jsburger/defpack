#define init

#define weapon_name
return "SMARTER GUN"
#define weapon_type
return 1
#define weapon_cost
return 1
#define weapon_area
return 12
#define weapon_load
return 4
#define weapon_swap
return sndSwapMachinegun
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
var ang = gunangle;
if instance_exists(enemy){
	var target = instance_nearest(mouse_x[index],mouse_y[index],enemy);
	ang = point_direction(x,y,target.x+target.hspeed_raw,target.y+target.vspeed_raw);
}
sound_play_gun(sndSmartgun,.1,.7)
with instance_create(x,y,Bullet1){
	creator = other
	team = other.team
	motion_set(ang,16)
	image_angle = direction
}

#define step(w)
if !w && race != "steroids"{
	if breload > 0{
		breload--
		if skill_get(mut_stress) breload -= 1 - my_health/maxhealth
		if race = "venuz" {
			breload -= .2
			if ultra_get(race,1) breload -= .4
		}
	}
	if breload <= 0 && ammo[1]{
		if instance_exists(enemy){
			var target = instance_nearest(x,y,enemy);
			if !collision_line(x,y,target.x,target.y,Wall,0,0){
				var ang = point_direction(x,y,target.x+target.hspeed_raw,target.y+target.vspeed_raw);
				sound_play_gun(sndSmartgun,.1,.7)
				with instance_create(x,y,Bullet1){
					creator = other
					team = other.team
					motion_set(ang,16)
					image_angle = direction
				}
				if infammo = 0 ammo[1]--
				breload = weapon_load()
			}
		}	
	}
}


#define weapon_sprt
return sprSmartGun
#define weapon_text
return "massive brain"
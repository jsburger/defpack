#define init
global.sprQuartzLaser = sprite_add_weapon("sprites/sprQuartzLaser.png", 6, 4);
global.sprBeam = sprite_add("sprites/projectiles/sprQuartzBeam.png",1,2,5)

#define weapon_name
return "QUARTZ LASER"
#define weapon_type
return 5
#define weapon_cost
return 1
#define weapon_area
return 15
#define weapon_load
return 10
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return true
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt
return global.sprQuartzLaser
#define weapon_text
return "FRAGILE APPARATUS"

#define step
if lsthealth > my_health
{
  if wep  = mod_current{sound_play_pitch(sndHyperCrystalHurt,.8);sound_play_pitch(sndLaserCrystalHit,.7);sleep(50);view_shake_at(x,y,12);wep = 0;curse=0}
  if bwep = mod_current{sound_play_pitch(sndHyperCrystalHurt,.8);sound_play_pitch(sndLaserCrystalHit,.7);sleep(50);view_shake_at(x,y,12);bwep = 0;bcurse=0}
}


#define weapon_fire
with instance_create(x,y,Laser){
	creator = other
	image_angle = creator.gunangle
	team = other.team
	event_perform(ev_alarm,0)
	image_yscale = 1 + skill_get(mut_laser_brain)/2
	startscale = image_yscale
	damage += skill_get(mut_laser_brain)
	spec = other.specfiring
	index = other.index
	sprite_index = global.sprBeam
	time = weapon_load()+1
	kicknegate = 1
	race = other.race
	beam = 1
	if fork(){
	    while instance_exists(self){
	        if button_check(index,spec ? "spec" : "fire"){
	            if instance_exists(creator){
	                sound_play(sndLaser)
	                sound_set_track_position(sndLaser,.078)
	                if spec && !kicknegate creator.bwkick = 5
	                else{
	                    creator.wkick = 5
	                    kicknegate = 0
	                }
	                x = creator.x
	                y = creator.y -4*(spec && race = "steroids")
	                image_xscale = 1
	                image_yscale = startscale
	                xstart = x
	                ystart = y
	                image_angle = creator.gunangle
	                with hitme x += 10000
	                event_perform(ev_alarm,0)
	                with hitme x -= 10000
	                with Smoke if distance_to_point(other.x,other.y) < 5 {
	                    with instance_create(x,y,Dust){
	                        sprite_index = sprExtraFeetDust
	                        motion_set(other.direction,other.speed)
	                    }
	                    instance_destroy()
	                }
	                x+=lengthdir_x(4,image_angle)
	                y+=lengthdir_y(4,image_angle)
	                image_xscale += 2
	            }
	        }
	        time -= current_time_scale
	        if time <= 0 instance_destroy()
	        wait(0)
	    }
	    if !array_length(instances_matching(Laser,"beam",1))sound_set_track_position(sndLaser,0)
	    exit
	}
}

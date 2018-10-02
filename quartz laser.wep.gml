#define init
global.sprQuartzLaser = sprite_add_weapon("sprites/sprQuartzLaser.png", 6, 4);
global.sprBeam = sprite_add("sprites/projectiles/sprQuartzBeam.png",1,2,5)
global.sprHud = sprite_add("sprites/sprQuartzLaserHud.png", 1, 6, 4)

#define weapon_name
return "QUARTZ LASER"
#define weapon_type
return 5
#define weapon_cost
return 1
#define weapon_area
return 15
#define weapon_load
return 18
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return true
#define weapon_melee
return 0
#define weapon_sprt_hud
return global.sprHud
#define weapon_laser_sight
return 0
#define weapon_sprt
return global.sprQuartzLaser
#define weapon_text
return choose("FRAGILE APPARATUS","BE CAREFUL WITH IT")

#define step
mod_script_call("mod","defpack tools","quartz_penalty",mod_current)

#define weapon_fire
with instance_create(x,y,Laser){
	creator = other
  xstart = x
  ystart = y
	image_angle = creator.gunangle
	team = other.team
  image_yscale = 1 + skill_get(mut_laser_brain)*.2
  event_perform(ev_alarm,0)
	startscale = image_yscale
	damage = 1
	spec = other.specfiring
	index = other.index
	sprite_index = global.sprBeam
	time = weapon_load()+1
	kicknegate = 1
	race = other.race
	beam = 1
	if fork(){
	    while instance_exists(self){
      if x != xstart and y != ystart
      {
        with instance_create(x+random_range(-2,2),y+random_range(-2,2),Dust)
        {
          sprite_index = sprExtraFeetDust
          motion_set(random(360),random_range(2,3))
        }
      }
	        if button_check(index,spec ? "spec" : "fire"){
	            if instance_exists(creator){
	                sound_play_pitchvol(sndHyperCrystalChargeExplo,4,.16)
                  sound_play_pitch(sndLaser,2)
	                sound_set_track_position(sndLaser,.078)
	                if spec && !kicknegate creator.bwkick = 5
	                else{
	                    creator.wkick = 5
	                    kicknegate = 0
                      image_yscale += .5
	                }
	                x = creator.x
	                y = creator.y -4*(spec && race = "steroids")
	                image_xscale = 1
	                image_yscale = startscale
	                xstart = x
	                ystart = y
	                image_angle = creator.gunangle + random_range(-.2,.2)
	                direction = image_angle
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

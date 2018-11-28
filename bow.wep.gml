#define init
global.sprBow   = sprite_add_weapon("sprites/sprBow.png",2,8)
global.sprArrow = sprite_add("sprites/projectiles/sprArrow.png",0,3,4)

#define weapon_name
//if instance_is(self,WepPickup) return `  BOW @0(${sprEnergyIcon}:0) `
return "BOW"

#define weapon_type
return 3

#define weapon_cost
return 1

#define weapon_area
return 4

#define weapon_chrg
return 1

#define weapon_load
return 5

#define weapon_swap
return sndSwapBow

#define weapon_auto
return 1

#define weapon_melee
return false

#define weapon_laser_sight
return false

#define weapon_reloaded

#define weapon_fire
with instance_create(x,y,CustomObject)
{
    sound = sndAssassinAttack
    sound_set_track_position(sound,.11)
	name    = "bow charge"
	creator = other
	charge    = 0
    maxcharge = 30
	charged = 0
	holdtime = 5 * 30
	depth = TopCont.depth
	index = creator.index
	undef = view_pan_factor[index]
	on_step 	 = bow_step
	on_destroy = bow_destroy
	on_cleanup = bow_cleanup
	btn = other.specfiring ? "spec" : "fire"
}

#define bow_step
if !instance_exists(creator){instance_destroy();exit}
with creator weapon_post(0,other.charge / 2,0)
if button_check(index,"swap"){creator.ammo[3] = min(creator.ammo[3] + weapon_cost(), creator.typ_amax[3]);instance_destroy();exit}
if btn = "fire" creator.reload = weapon_get_load(creator.wep)
if btn = "spec" creator.breload = weapon_get_load(creator.bwep) * array_length_1d(instances_matching(instances_matching(instances_matching(CustomObject, "name", "bow charge"),"creator",creator),"btn",btn))
if button_check(index,btn){
    if charge < maxcharge{
      charge += current_time_scale;
      charged = 0
      sound_play_pitch(sound,sqr((charge/maxcharge) * 1.2) + .2)
      sound_set_track_position(sound,.15)
    }
    else{
        charge = maxcharge;
        if charged = 0{
            instance_create(creator.x,creator.y,WepSwap);
            sound_play_gun(sndClickBack,.1,.5)
            charged = 1
        }
    }
}
else{instance_destroy()}

#define bow_cleanup
sound_set_track_position(sound,0)
sound_stop(sound)

#define bow_destroy
bow_cleanup()
sound_play_pitch(sndSwapGuitar,4)
sound_play_pitch(sndAssassinAttack,2)
if charged = 0
{
  with instance_create(creator.x,creator.y,Bolt)
  {
    sprite_index = global.sprArrow
    mask_index   = mskBullet1
    creator = other.creator
    team    = creator.team
    damage = 10
    move_contact_solid(creator.gunangle,12)
    motion_add(creator.gunangle+random_range(-8,8)*creator.accuracy,18)
    image_angle = direction
  }
}
else
{
    var ang = creator.gunangle + random_range(-5,5) * creator.accuracy
    var i = -12;
    repeat(3){
        with instance_create(creator.x,creator.y,Bolt){
            sprite_index = global.sprArrow
            mask_index   = mskBullet1
            creator = other.creator
            team    = creator.team
            damage = 10
            move_contact_solid(creator.gunangle,12)
            motion_add(ang + i,20)
            image_angle = direction
        }
        i += 12;
    }
}

#define weapon_sprt
return global.sprBow

#define weapon_text
return "CLASSIC"

#define init
global.sprBow      = sprite_add_weapon("sprites/sprBow.png",2,8)
global.sprArrow    = sprite_add("sprites/projectiles/sprArrow.png",0,3,4)
global.sprArrowHUD = sprite_add_weapon("sprites/projectiles/sprArrow.png",5,3)

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
return sndSwapHammer

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
  sound = sndMeleeFlip
	name    = "bow charge"
	creator = other
	charge    = 0
    maxcharge = 25
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
if !instance_exists(creator){instance_delete(self);exit}
var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
with creator weapon_post(0,-(min(other.charge/other.maxcharge*10, point_distance(x,y,mouse_x[index],mouse_y[index]))) * timescale,0)
if button_check(index,"swap"){creator.ammo[3] = min(creator.ammo[3] + weapon_cost(), creator.typ_amax[3]);instance_destroy();exit}
if btn = "fire" creator.reload = weapon_get_load(creator.wep)
if btn = "spec"{
    if creator.race = "steroids"
        creator.breload = weapon_get_load(creator.bwep)
    else
        creator.reload = max(weapon_get_load(creator.wep) * array_length_1d(instances_matching(instances_matching(instances_matching(CustomObject, "name", name),"creator",creator),"btn",btn)), creator.reload)
}
if button_check(index,btn){
    if charge < maxcharge{
        charge += timescale;
        charged = 0
        sound_play_pitchvol(sound,sqr((charge/maxcharge) * 3.5) + 6,1 - charge/maxcharge)
    }
    else{
        if current_frame mod 6 < current_time_scale creator.gunshine = 1
        charge = maxcharge;
        if charged = 0{
            sound_play_pitch(sndSnowTankCooldown,8)
            sound_play_pitchvol(sndShielderDeflect,5,.5)
            with instance_create(creator.x,creator.y,WepSwap){
                creator = other.creator
            };
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
var _p = random_range(.8,1.2)
sound_play_pitchvol(sndSwapGuitar,4*_p,.8)
sound_play_pitchvol(sndAssassinAttack,2*_p,.8)
sound_play_pitchvol(sndClusterOpen,2*_p,.2)
if charged = 0
{
  with creator weapon_post(1,-10,0)
  with instance_create(creator.x,creator.y,Bolt)
  {
    sprite_index = global.sprArrow
    mask_index   = mskBullet1
    creator = other.creator
    team    = creator.team
    damage = 10
    move_contact_solid(creator.gunangle,6)
    motion_add(creator.gunangle+random_range(-8,8)*creator.accuracy*(1-(other.charge/other.maxcharge)),16+6*other.charge/other.maxcharge)
    image_angle = direction
  }
}
else
{
    with creator
    {
      weapon_post(1,-30,0)
      repeat(6) with instance_create(x,y,Dust)
      {
        motion_add(random(360),choose(5,6))
      }
    }
    sound_play_pitchvol(sndShovel,2,.8)
    sound_play_pitchvol(sndUltraCrossbow,3,.8)
    var ang = creator.gunangle + random_range(-5,5) * creator.accuracy
    var i = -12;
    repeat(3){
        with instance_create(creator.x,creator.y,Bolt){
            sprite_index = global.sprArrow
            mask_index   = mskBullet1
            creator = other.creator
            team    = creator.team
            damage = 10
            move_contact_solid(creator.gunangle,6)
            motion_add(ang + i,20)
            image_angle = direction
        }
        i += 12;
    }
}

#define weapon_sprt
if instance_is(self,Player) with instances_matching(instances_matching(CustomObject, "name", "bow charge"),"creator", id){
    var yoff = (creator.race = "steroids" and btn = "spec") ? -1 : 1
    with creator draw_sprite_ext(global.sprArrow, 0, x - lengthdir_x(other.charge/other.maxcharge * 4 - 1, gunangle), y - lengthdir_y(other.charge/other.maxcharge * 4 - 1, gunangle) + yoff, 1, 1, gunangle, c_white, 1)
}
return global.sprBow

#define weapon_sprt_hud
return global.sprArrowHUD

#define weapon_text
return "CLASSIC"

#define init
global.sprBow   = sprite_add("sprites/sprBow.png",0,2,8)
  global.sprArrow = sprite_add("sprites/projectiles/sprArrow.png",0,3,4)

#define weapon_name
return "BOW"

#define weapon_type
return 3

#define weapon_cost
return 1

#define weapon_area
return -1

#define weapon_load
return 5

#define weapon_swap
return sndSwapBow

#define weapon_auto
return false

#define weapon_melee
return false

#define weapon_laser_sight
return false

#define weapon_reloaded
return -4

#define weapon_fire
with instance_create(x,y,CustomObject)
{
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
	btn = other.specfiring ? "spec" : "fire"
}

#define bow_step
if !instance_exists(creator){instance_destroy();exit}
with creator weapon_post(0,other.charge / 2,0)
if button_check(index,"swap"){creator.ammo[3] = min(creator.ammo[3] + weapon_cost(), creator.typ_amax[3]);instance_destroy();exit}
if btn = "fire" creator.reload = weapon_get_load(creator.wep)
if btn = "spec" creator.breload = weapon_get_load(creator.bwep) * array_length_1d(instances_matching(instances_matching(CustomObject, "name", "bow charge"),"creator",creator))
if button_check(index,btn)
{
  if charge < maxcharge{charge += current_time_scale;charged = 0}else {charge = maxcharge;if charged = 0{instance_create(creator.x,creator.y,WepSwap);charged = 1}}
}
else{instance_destroy()}

#define bow_destroy
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
    motion_add(creator.gunangle+random_range(-8,8)*creator.accuracy,16)
    image_angle = direction
  }
}
else
{
  var i = -12;
  repeat(3)
  {
    with instance_create(creator.x,creator.y,Bolt)
    {
      sprite_index = global.sprArrow
      mask_index   = mskBullet1
      creator = other.creator
      team    = creator.team
      damage = 10
      move_contact_solid(creator.gunangle,12)
      motion_add(creator.gunangle+i+random_range(-5,5)*creator.accuracy,18)
      image_angle = direction
    }
    i += 12;
  }

}

#define weapon_sprt
return global.sprBow

#define weapon_text
return "CLASSIC"

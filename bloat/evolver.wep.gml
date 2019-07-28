#define init
global.sprEvolver = sprRevolver
#define weapon_name
return "EVOLVER"
#define weapon_type
return 1
#define weapon_cost
return 6
#define weapon_area
return -1
#define weapon_load
return 26
#define weapon_swap
return sndSwapPistol
#define weapon_auto
return false
#define weapon_melee
return false
#define weapon_laser_sight
return false
#define weapon_fire
repeat(1+skill_get(22)*2)
{
  with create_evolvebullet(x,y)
  {
    creator = other
    team    = other.team
    motion_set(other.gunangle+random_range(-12,12)*other.accuracy*(skill_get(22)+1),12+skill_get(2)*4)
    maxspeed = speed
    image_angle = direction
  }
}

#define create_evolvebullet(_x,_y)
var a = instance_create(_x,_y,CustomSlash);
with a
{
  name    = "evolve bullet"
  can_fix = false
  sprite_index = sprBullet1
  mask_index   = mskBullet1
  image_speed  = 1
  size = 1 + skill_get(23)
  ammo = 0 + skill_get(23) * 3
  bounce = skill_get(15) * 3
  pierce = skill_get(17) * 2
  wallpierce = skill_get(26) * 2 - skill_get(22)
  force  = 2
  damage = round((3 + skill_get(11))/(1-skill_get(22)))
  lasthit = -4
  friction = .8 - skill_get(19) * .8
  maxspeed = 25
  on_hit        = evolve_hit
  on_step       = evolve_step
  on_wall       = evolve_wall
  on_destroy    = evolve_destroy
  on_projectile = evolve_projectile
}
return a

#define evolve_hit
if projectile_canhit(other) = true && lasthit != other
{
  sleep(5)
  view_shake_at(x,y,6)
  projectile_hit(other,damage,force,direction)
  pierce--
  lasthit = other
  if skill_get(20) = true
  {
    with mod_script_call("mod","defpack tools","create_sonic_explosion",x,y)
    {
    	var scalefac = .25;
    	image_xscale = scalefac
    	image_yscale = scalefac
    	damage = 1
    	image_speed = .75
    	team = other.team
    	creator = other.creator
    	repeat(round(scalefac*10)){ with instance_create(x,y,Dust) {motion_add(random(360),3)}}
    }
  }
}
if pierce < 0{instance_destroy()}

#define evolve_step
if image_index = 1 image_speed = 0
if skill_get(21) = true
{
  var closeboy = instance_nearest(x,y,enemy)
  if distance_to_object(closeboy) <= 32
  {
    motion_add(direction,1)
    motion_add(point_direction(x,y,closeboy.x,closeboy.y),3)
  }
  image_angle = direction
}
if speed > maxspeed speed = maxspeed
if speed <= friction{instance_destroy();exit}

#define evolve_wall
if bounce > 0
{
  move_bounce_solid(false)
  direction += random_range(-7,7)
  bounce--
  image_angle = direction
}
else
{
  if wallpierce > 0
  {
    with other{instance_create(x,y,FloorExplo);instance_destroy()}
    wallpierce--
  }
  else instance_destroy()
}

#define evolve_destroy
if skill_get(14) = true
{
  instance_create(x,y,SmallExplosion)
}
if ammo > 0
{
  var i = random(360)
  repeat(ammo)
  {
    with create_evolvebullet(x,y)
    {
      ammo = 0
      image_xscale *= .75
      image_yscale *= .75
      creator = other
      team    = other.team
      motion_set(i+random_range(-5,5),12+skill_get(2)*4)
      maxspeed = speed
      image_angle = direction
    }
    i += 360/ammo
  }
}

#define evolve_projectile

/*thank you vewwy much gmlscripts.com >W<!!!
#define find_hitme()
{
    var ds,selected;
    ds = ds_priority_create();
    ds_priority_add(ds,noone,100000000);
    with (hitme) {
        if team != other.team && self != other.lasthit && self != prop{
            ds_priority_add(ds,id,point_distance(x,y,other.x,other.y));
        }
    }
    selected = ds_priority_find_min(ds);
    ds_priority_destroy(ds);
    return selected;
}*/

#define weapon_sprt
return sprPizzaChest2
#define weapon_text
return "EVOLVE"


/* mutation synergies
+ bolt marrow      : homing
DONE + shotgun shoulders: bouncy
DONE + boiling veins    : explosive/fire trail
DONE + extra feet       : shot speed up
+ open mind        : chest chance on kill
+ bloodlust        : knock out mini hp pack on hit
+ lucky shot       : knock out mini ammo pack on hit
+ heavy heart      : knock out weapon on hit
+ strong spirit    : + iframes on kill
+ long arms        : destroy enemy bullets on hit/bigger projectile
DONE + laser brain      : piercing
+ thronebutt       : mutation stat bonus up
DONE + eagle eyes       : no friction
+ patience         : -
+ euphoria         : slows down enemies hit for a short duration
+ sharp teeth      : hitting an enemy damages the nextbest enemy as well
DONE + stress           : 3 projectiles at half damage
+ trigger fingers  : projectile splits into other projectile on destroy
DONE + scarier face     : +damage
+ gamma guts       : 4 halo projectiles
DONE + impact wrists    : creates a weak sonic explosion on top of the enemy hit
+ plutonium hunger : bullet sucks like ugl
+ prismatic iris   : explodes into the rainbow bullets
+ recycle gland    : chance for ammo refund
+ rhino skin       :
+ back muscle      : reduced ammo cost
+ last wish        :
DONE + hammerhead       : wall pierce

#define init
global.sprSpear     = sprite_add_weapon("sprites/sprSpear.png", 6, 5);
global.sprGoldSlash = sprite_add("sprites/projectiles/Gunhammer Slash.png",3,0,24)

#define weapon_name
return "SPEAR";

#define weapon_sprt
return global.sprSpear;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 6;

#define weapon_cost
return 0;

#define weapon_melee
return false;

#define weapon_swap
return sndSwapSword;

#define weapon_area
return 12;

#define weapon_text
return "@sOwO";

#define weapon_fire
weapon_post(-22,0,12)
sleep(20)
motion_add(gunangle,2)
sound_play_pitch(sndScrewdriver,.8)
sound_play_pitch(sndBlackSword,random_range(1.3,1.5))
with instance_create(x,y,CustomProjectile)
{
    damage = 30
    force = 8
    team = other.team
    creator = other
    name = "spearslash"
    image_speed = 0
    can_crit = 1
    move_contact_solid(other.gunangle,12)
    sprite_index = global.sprGoldSlash
    mask_index = mskNothing
    image_angle = other.gunangle+random_range(-4,4)*other.accuracy
	  motion_add(other.gunangle, 26)
    on_anim = nothing
    on_hit  = spear_hit
    on_step = spear_step
}

#define nothing

#define spear_hit
if projectile_canhit_melee(other){projectile_hit(other,damage,force,direction)}

#define spear_anim
instance_destroy()

#define spear_step
speed /= 1.2 if speed <= 1.0005{instance_destroy();exit}
if point_in_circle(x,y,instance_nearest(x,y,hitme).x,instance_nearest(x,y,hitme).y,18)
{
  if other.team != team
  {
    if projectile_canhit_melee(other)
    {
      projectile_hit(other,damage,force,direction)
    }
  }
}

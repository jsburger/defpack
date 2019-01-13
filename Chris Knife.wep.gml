#define init
global.sprKnife 	    = sprite_add_weapon("sprites/Knife.png", 0, 2);
global.sprKnifeshank  = sprite_add("sprites/projectiles/knifeshank.png",2,0,8);

#define weapon_name
return "CHRIS KNIFE";

#define weapon_sprt
return global.sprKnife;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 7;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapSword;

#define weapon_area
return 12;

#define weapon_text
return choose("IS IT STATTRACK","CRITICAL");

#define weapon_fire
wepangle = -wepangle
weapon_post(-7,0,42)
sleep(20)
motion_add(gunangle,7)
sound_play_pitch(sndScrewdriver,.8)
sound_play_pitch(sndBlackSword,random_range(1.3,1.5))
with instance_create(x,y,CustomSlash)
{
    damage = 8
    force = 5
    team = other.team
    creator = other
    candeflect = 1
    name = "knife shank"
    image_speed = .45
    can_crit = 1
    move_contact_solid(other.gunangle,12)
    sprite_index = global.sprKnifeshank
    image_angle = other.gunangle+random_range(-14,14)*other.accuracy
	  motion_add(other.gunangle, 2 + (skill_get(13) * 3.5))
    on_hit        = knifeshank_hit
    on_projectile = knifeshank_proj
}

#define knifeshank_proj
if team != other.team{with other{instance_destroy()}}

#define knifeshank_hit
if projectile_canhit_melee(other)
{
  if irandom(19-(skill_get(6)*5)) = 0 && can_crit = 1
  {
    can_crit = 0
    mod_script_call("mod","defpack tools","crit")
  }
  projectile_hit(other,damage,force,direction)
}

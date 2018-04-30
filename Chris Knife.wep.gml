#define init
global.sprKnife 	    = sprite_add_weapon("sprites/Knife.png", 0, 2);
global.sprKillslash   = sprite_add("sprites/projectiles/Killslash.png"	,8,16,16);
global.sprKnifeshank  = sprite_add("sprites/projectiles/knifeshank.png"	,2,0,8);
#define weapon_name
return "CHRIS KNIFE";

#define weapon_sprt
return global.sprKnife;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 9;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapSword;

#define weapon_area
return 12;

#define weapon_text
return choose("IS IT STATTRACK","A NICER DICER","CRITICAL");

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
if team != other.team
{
  with other{instance_destroy()}
}

#define knifeshank_hit
if projectile_canhit_melee(other)
{
  if irandom(19-(skill_get(6)*5)) = 0 && can_crit = 1
  {
    view_shake_max_at(x,y,200)
    sleep(150)
    can_crit = 0
    damage += 30
    sound_play_pitchvol(sndHammerHeadEnd,random_range(1.23,1.33),20)
    sound_play_pitchvol(sndBasicUltra,random_range(0.9,1.1),20)
    sound_play_pitch(sndCoopUltraA,random_range(3.8,4.05))
    with instance_create(other.x,other.y,CustomObject)
    {
      image_angle = random(359)
      depth = other.depth -1
      image_speed = .6
      sprite_index = global.sprKillslash
      image_xscale = random_range(1.3,1.5)
      image_yscale = image_xscale
      on_step = Killslash_step
      with instance_create(x,y,CustomObject)
      {
        image_angle = other.image_angle - 90 + random_range(-8,8)
        depth = other.depth
        image_speed = .8
        sprite_index = global.sprKillslash
        image_blend = c_black
        image_xscale = other.image_xscale-.5
        image_yscale = image_xscale
        on_step = Killslash_step
      }
    }
  }
  projectile_hit(other,damage,force,direction)
}
#define Killslash_step
if image_index >= 7 instance_destroy();

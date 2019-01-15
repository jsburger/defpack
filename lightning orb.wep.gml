#define init
global.sprLightningOrb = sprite_add_weapon("sprites/sprLightningOrb.png", 3, 2);
global.sprUmbrellaOrb  = sprite_add("sprites/projectiles/sprRainOrb.png",2,9,9);

#define weapon_name
return "LIGHTNING ORB"

#define weapon_sprt
return global.sprLightningOrb;

#define weapon_type
return 5;

#define weapon_auto
return true;

#define weapon_load
return 5;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 5;

#define weapon_text
return "BUBBLES";

#define weapon_fire
var p = random_range(.8,1.2)
sound_play_pitch(sndLightningCrystalCharge,5*p)
sound_play_pitchvol(sndSwapEnergy,1.6*p,.6)
//sound_play_pitch(sndPlasmaHit,.4*p) epic wobble
weapon_post(3,-5,0)
create_lightningorb()

#define stop_anim
image_speed = 0
image_index = 1

#define fric_step
direction += random_range(-35,35)/speed
if speed <= friction
{
  instance_destroy()
}

#define bounce_wall
move_bounce_solid(false)
with instance_create(x,y,LightningSpawn){image_angle = other.direction}

#define lightningnade_destroy
repeat(3) with instance_create(x,y,Lightning)
{
  image_angle = random(360)
	creator = other.creator
	team = other.team
	ammo = 2
	alarm0 = 1
	visible = 0
	with instance_create(x,y,LightningSpawn)
	{
	   image_angle = other.image_angle
	}
}sound_play_pitchvol(sndLightningCannonEnd,2.5*random_range(.8,1.2),.6)

#define create_lightningorb()
repeat(1)
{
  with instance_create(x+lengthdir_x(4,gunangle),y+lengthdir_y(4,gunangle),CustomProjectile)
  {
    move_contact_solid(other.gunangle,6)
    name = "lightning orb"
    damage = 2
    friction = .08
    sprite_index = global.sprUmbrellaOrb
    image_speed = .5
    mask_index = mskDebris
    image_xscale = .5
    image_yscale = .5
    motion_add(other.gunangle +random_range(-7,7)*other.accuracy,choose(5,6))
    creator = other
    team = other.team
    image_angle = direction
    on_step = fric_step
    on_wall = bounce_wall
    on_draw = bloom_draw_nade
    on_destroy = lightningnade_destroy
  }
}

#define bloom_draw_nade
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.2);
draw_set_blend_mode(bm_normal);

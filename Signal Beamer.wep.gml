#define init
global.sprSignalBeamer = sprite_add_weapon("Signal Beamer.png", 2, 2);

#define weapon_name
return "SIGNAL BEAMER"

#define weapon_sprt
return global.sprSignalBeamer;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 8;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 12;

#define weapon_text
return choose("GUMMY BEEEEAAARS","BEWARE OF @gGREEN","PREPARE FOR @yYELLOW","@rRED")

#define weapon_fire
motion_add(gunangle+180,3)
with instance_create(x,y,CustomObject)
{
	creator = other.id
	ammo = 3
	timer = 1
	accuracy = creator.accuracy
	team = creator.team
	gunangle = creator.gunangle
	on_step = SignalBeamer_step
  //instance_create(x+lengthdir_x(16,gunangle),y+lengthdir_y(16,gunangle),MeatExplosion)
}

#define SignalBeamer_step
if instance_exists(creator)
{
  x = creator.x+lengthdir_x(-4,gunangle)
  y = creator.y+lengthdir_y(-4,gunangle)
  timer -= 1
  if timer = 0
  {
    timer = 2
    with creator weapon_post(6,-4,2)
    if ammo = 3
    {
			sound_play(sndMachinegun)
			sound_play_pitch(sndToxicBoltGas,random_range(3,3.8))
      with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x+lengthdir_x(8,creator.gunangle),y+lengthdir_y(8,creator.gunangle)){
          creator = other.creator
          team = other.team
          motion_set(other.gunangle + random_range(-3,3) * other.accuracy,17)
		  image_angle = direction
      }
    }
    if ammo = 2
    {
			sound_play(sndMachinegun)
      with instance_create(x,y,Bullet1){
      	motion_set(other.gunangle + random_range(-3,3), 17)
      	image_angle = direction
      	creator = other.creator
      	team = other.team
      }
    }
    if ammo = 1
    {
			sound_play(sndMachinegun)
			sound_play_pitchvol(sndSwapFlame,random_range(1.4,1.6),.7)
			sound_play_pitchvol(sndIncinerator,1,.2)
      with mod_script_call("mod", "defpack tools", "create_fire_bullet",x+lengthdir_x(5,creator.gunangle),y+lengthdir_y(5,creator.gunangle)){
          creator = other.creator
          team = other.team
          motion_set(other.gunangle + choose(random_range(2,6),-random_range(2,6)) * other.accuracy,17)
		  image_angle = direction
      }
    }
    ammo -= 1
  }
  if ammo = 0{instance_destroy()}
}
else{instance_destroy()}

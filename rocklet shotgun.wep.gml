#define init
global.sprRockletShotgun = sprite_add_weapon("sprites/sprRockletShotgun.png", 4, 2);
global.sprRocklet = sprite_add("sprites/projectiles/sprRocklet.png",0,0,3)

#define weapon_name
return "ROCKLET SHOTGUN";

#define weapon_sprt
return global.sprRockletShotgun;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 24;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 3;

#define weapon_text
return "replace me please";

#define weapon_fire
if fork(){
    repeat(5){
      weapon_post(7,-3,17)
        sound_play_pitch(sndSlugger,2)
        sound_play_pitch(sndDoubleShotgun,.8)
        sound_play_pitch(sndShotgun,1.2)
        sound_play_pitch(sndRocketFly,random_range(2.6,3.2))
        sound_play_pitch(sndGrenadeRifle,random_range(.3,.4))
        sound_play_pitch(sndMachinegun,random_range(.7,.8))
        with instance_create(x,y,CustomProjectile)
        {
          sprite_index = global.sprRocklet
          creator = other
          damage = 3
          team = creator.team
          move_contact_solid(other.gunangle,8)
          motion_add(other.gunangle+random_range(-17,17)*creator.accuracy,2)
          maxspeed = random_range(10,14)
          timer = 7
          typ = 1
          friction = random_range(-.7,-.5)
          t = 0;
          image_angle = direction
          turn = choose(-1,1)
          increment = random_range(32,36);
          amplitude = random_range(1,7);
          instance_create(x,y,Smoke)
          on_step = rocket_step
          on_destroy = rocket_destroy
        }
    }
}


#define init
global.sprThundercrash    = sprite_add_weapon("sprites/weapons/sprThundercrash.png", 10, 5);
global.sprThundercrashHUD = sprite_add_weapon("sprites/weapons/sprThundercrash.png", 17, 6);
global.sprUmbrella        = sprite_add("sprites/projectiles/sprThundercrashBullet.png",2,14,14);
global.mskUmbrella        = sprite_add("sprites/projectiles/mskThundercrashBullet.png",0,14,14);
global.sprUmbrellaOrb     = sprite_add("sprites/projectiles/sprThundercrashGrenade.png",2,9,9);


#define weapon_name
return "THUNDERCRASH"

#define weapon_sprt
return global.sprThundercrash;

#define weapon_sprt_hud
return global.sprThundercrashHUD;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 50;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 14;

#define nts_weapon_examine
return{
    "d": "Uses the most advanced weather technology #to summon lightning wherever it discharges. ",
}

#define weapon_text
return choose("END OF THE WORLD");

#define weapon_fire
sound_play_pitch(sndDevastatorUpg,1.4)
if skill_get(17){
        sound_play_pitch(sndLightningPistolUpg,.8)

}else{
    sound_play_pitch(sndLightningPistol,.8)
}
weapon_post(16,-190,125)
sleep(45)
motion_add(gunangle-180,5+abs(speed))
with instance_create(x,y,LightningSpawn){
    move_contact_solid(other.gunangle,20);
    image_speed = 1
}
with instance_create(x,y,LightningHit){
    move_contact_solid(other.gunangle,14);
    image_speed = .45
}
with instance_create(x,y,CustomProjectile)
{
	typ  = 1
	name = "mega lightning bullet"
	motion_add(other.gunangle+random_range(-1,1)*other.accuracy,26)
	projectile_init(other.team,other)
	sprite_index = global.sprUmbrella
  mask_index   = global.mskUmbrella

	image_angle = direction
	damage  = 20
	friction = 0
  force = 30
  image_speed = 1

  on_anim = stop_anim
  on_wall = lightningcluster_wall
  on_hit  = lightningcluster_hit
	on_destroy = lightningcluster_destroy

  if GameCont.area = 101 instance_destroy()
}

#define lightningcluster_wall
with other{instance_create(x,y,FloorExplo);instance_destroy()}
instance_destroy()

#define stop_anim
image_speed = 0
image_index = 1

#define lightningcluster_hit
if projectile_canhit(other) = true
{
  sleep(5 + 15 * clamp(other.size, 1, 3))
  with instance_create(x + random_range(-3, 3), y + random_range(-3, 3), LightningHit){image_angle = random(360)}
  view_shake_max_at(x, y, 4 + 7 * clamp(other.size, 1, 3))
  var _dmg = other.my_health
  projectile_hit(other,damage,force,direction)
  if _dmg > damage {sleep(80);instance_destroy()}
}

#define fric_step
direction += random_range(-25,25)*current_time_scale
if speed <= 0
{
  instance_destroy()
}

#define bounce_wall
move_bounce_solid(false)

#define lightningcluster_destroy
if GameCont.area != 101
{
  create_lightningorb()
}
sleep(20)
play_sound_lightning()
with mod_script_call("mod","defpack tools","create_lightning",x+lengthdir_x(sprite_width,direction),y+lengthdir_y(sprite_width,direction)){
    projectile_init(other.team,other)
}

#define lightningnade_destroy
with mod_script_call("mod","defpack tools","create_lightning",x,y){
    projectile_init(other.team,other)
    sleep(30)
}
play_sound_lightning()

#define create_lightningorb()
var ang = random(360);
for var i = 0; i< 3; i++
{
  with instance_create(x+lengthdir_x(sprite_width,direction),y+lengthdir_y(sprite_width,direction),CustomProjectile)
  {
    name = "lightning orb"
    damage = 8
    friction = .075
	defbloom = {
        xscale : 1.5+skill_get(mut_laser_brain),
        yscale : 1.5+skill_get(mut_laser_brain),
        alpha : .1 + skill_get(mut_laser_brain) * .025
    }
    sprite_index = global.sprUmbrellaOrb
    image_speed = .5
    mask_index = mskDebris
    motion_add(ang + 120*i,2+i)
    projectile_init(other.team,other.creator)
    image_angle = direction
    on_step = fric_step
    on_wall = bounce_wall
    on_destroy = lightningnade_destroy
  }
}

#define play_sound_lightning()
var _pitch = random_range(.8,1.2)
sound_play_pitch(sndExplosion,2*_pitch)
sound_play_pitch(sndExplosionS,.7*_pitch)
sound_play_pitchvol(sndExplosionL,.5*_pitch,.6)
sound_set_track_position(sndExplosionL,.3*_pitch)
sound_play_pitch(sndSuperBazooka,.5*_pitch)
if skill_get(17){
	sound_play_pitchvol(sndLightningCannonEnd,.8*_pitch,.7)
	sound_play_pitchvol(sndLightningRifleUpg,.7*_pitch,.6)
}
else{
	sound_play_pitchvol(sndLightningRifle,.7*_pitch,.6)
}

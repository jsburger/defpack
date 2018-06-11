#define init
global.sprThundercrash = sprite_add_weapon("sprites/sprThundercrash.png", 10, 5);
global.sprUmbrella  = sprite_add("defpack tools/sprRainDisk.png",2,14,14);
global.mskUmbrella  = sprite_add("defpack tools/mskRainDisk.png",0,14,14);

#define weapon_name
return "THUNDERCRASH"

#define weapon_sprt
return global.sprThundercrash;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 40;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 14;

#define weapon_text
return choose("MACBETH");

#define weapon_fire
sound_play_pitch(sndDevastatorUpg,1.4)
if skill_get(17){
        sound_play_pitch(sndLightningPistolUpg,.8)

}else{
    sound_play_pitch(sndLightningPistol,.8)
}
weapon_post(16,-90,125)
sleep(35)
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
	name = "lightning cluster grenade"
	motion_add(other.gunangle+random_range(-7,7)*other.accuracy,26)
	projectile_init(other.team,other)
	sprite_index = global.sprUmbrella
  mask_index   = global.mskUmbrella
	image_speed = .45;
	image_angle = direction
	damage  = 20
	friction = 0
  image_speed = .5
	on_draw = bloom_draw
  on_step = stop_anim
	on_destroy = lightningcluster_destroy
}

#define stop_anim
if image_index = 1 image_speed = 0

#define fric_step
var _scale = random_range(.4,.6);
image_xscale = orscale*_scale;
image_yscale = orscale*_scale
direction += random_range(-25,25)
if speed <= 0{instance_destroy()}

#define bounce_wall
move_bounce_solid(false)

#define lightningcluster_destroy
play_sound_lightning()
with mod_script_call("mod","defpack tools","create_lightning",x+lengthdir_x(sprite_width,direction),y+lengthdir_y(sprite_width,direction)){
    projectile_init(other.team,other)
}
var ang = random(360);
for var i = 0; i< 3; i++{
	with instance_create(x+lengthdir_x(sprite_width,direction),y+lengthdir_y(sprite_width,direction),CustomProjectile){
		name = "lightning grenade"
		orscale = random_range(.8,1.2)
		damage = 8
		friction = .075
		sprite_index = sprPopoPlasma
		image_speed = 0
		mask_index = mskDebris
		motion_add(ang + 120*i,2+i)
		projectile_init(other.team,other.creator)
		image_angle = direction
		on_step = fric_step
		on_wall = bounce_wall
		on_draw = bloom_draw_nade
		on_destroy = lightningnade_destroy
	}
}

#define lightningnade_destroy
with mod_script_call("mod","defpack tools","create_lightning",x,y){
    projectile_init(other.team,other)
}
play_sound_lightning()


#define play_sound_lightning()
sound_play_pitch(sndExplosion,2)
sound_play_pitch(sndExplosionS,.7)
sound_play_pitchvol(sndExplosionL,.5,.6)
sound_set_track_position(sndExplosionL,.3)
sound_play_pitch(sndSuperBazooka,.5)
if skill_get(17){
	sound_play_pitchvol(sndLightningCannonEnd,.8,.7)
	sound_play_pitchvol(sndLightningRifleUpg,.7,.6)
}
else{
	sound_play_pitchvol(sndLightningRifle,.7,.6)
}


#define bloom_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale+(1-image_index)*2, 2*image_yscale+(1-image_index)*2, image_angle, image_blend, 0.2+(1-image_index)*.4);
draw_set_blend_mode(bm_normal);

#define bloom_draw_nade
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.2);
draw_set_blend_mode(bm_normal);

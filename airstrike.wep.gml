#define init
global.sprAirstrike = sprite_add_weapon("sprites/sprAirstrike.png", -1, 3);
global.stripes 	    = sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_name
return "AIRSTRIKE"

#define weapon_sprt
return global.sprAirstrike;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 32;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 12;

#define weapon_text
return "CALLING IN A STRIKE";

#define weapon_fire
sound_play(snd_lowa)
sound_play_pitch(sndFreakPopoDead,1.3)
sound_play_pitch(sndFreakPopoReviveArea,1.3)
with instance_create(x,y,CustomObject)
{
	mask_index = sprBullet1
	creator  = other
	team     = other.team
	accuracy = other.accuracy
	j = 0
	direction = other.gunangle + random_range(-7,7)
	speed = 9
	ammo = 9
	on_step = airstrike_step
}

#define airstrike_step
j += speed_raw
if (j % (speed * 4)) < current_time_scale
{
	ammo--
	with instance_create(x + random_range(-8,8) * accuracy,y + random_range(-8,8) * accuracy,CustomProjectile)
	{
		team    = other.team
		acc 		= other.accuracy/1.35
		sprite_index = mskNone
		image_speed = 0
		radiusmin = 12
		radiusmax = 32 + random_range(-12,8)
		radius = radiusmax
		ammo = 3
		on_hit  	 = fakeabris_hit
		on_draw 	 = fakeabris_draw
		on_step 	 = fakeabris_step
		on_destroy = fakeabris_destroy
	}
}
if ammo <= 0 instance_destroy()

#define fakeabris_destroy
var i = random(360)
sleep(20)
view_shake_at(x,y,30)
repeat(ammo)
{
	sound_play_pitch(sndExplosionS,.7)
	instance_create(x+lengthdir_x(radius,i),y+lengthdir_y(radius,i),SmallExplosion)
	i += 360/ammo
}

#define fakeabris_step
image_angle += 7 * current_time_scale * radiusmin/radius
if radiusmin < radius{radius /= (1 + .06/acc*current_time_scale)}
else{instance_destroy()}
#define fakeabris_hit

#define fakeabris_draw
draw_set_alpha(.4*(radiusmin/radius))
draw_circle_color(x,y,radius,c_red,c_red,false)
draw_set_alpha(1)
mod_script_call("mod","defpack tools","draw_circle_width_colour",12,radius,1,image_angle,x,y,c_red,1)
mod_script_call("mod","defpack tools","draw_circle_width_colour",12,radiusmax,1,image_angle*-1,x,y,c_red,.2)
mod_script_call("mod","defpack tools","draw_circle_width_colour",12,radiusmin,1,image_angle*-1,x,y,c_red,.2)
draw_self()

#define init
global.sprPulser = sprite_add_weapon("sprites/sprPulser.png", 5, 3);
global.stripes 	 = sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_name
return "PULSER"

#define weapon_sprt
return global.sprPulser;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 82;

#define weapon_cost
return 12;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 12;

#define weapon_text
return "replace me please";

#define weapon_fire
weapon_post(9,14,20)
motion_add(gunangle -180,5)
sound_play_pitch(sndSuperFlakCannon,.7)
sound_play_pitch(sndHeavyNader,.7)
sound_play_pitch(sndSuperSlugger,.7)
sleep(50)
with instance_create(x,y,CustomProjectile)
{
	creator = other
	team = other.team
	acc = other.accuracy
	move_contact_solid(other.gunangle,24)
	sprite_index = sprPlasmaBall
	image_speed = 0
	radiusmin = 28
	radiusmax = radiusmin * 4
	radius = radiusmax
	ammo = 8
	motion_add(other.gunangle,1)
	on_hit  	 = pulser_hit
	on_draw 	 = pulser_draw
	on_step 	 = pulser_step
	on_destroy = pulser_destroy
}

#define pulser_destroy
var i = random(360)
sleep(200)
view_shake_at(x,y,200)
repeat(ammo)
{
	sound_play_pitch(sndExplosionXL,.7)
	sound_play_pitch(sndExplosionCar,.4)
	sound_play_pitch(sndPlasmaBigUpg,.4)
	instance_create(x+lengthdir_x(radiusmax,i),y+lengthdir_y(radiusmax,i),GreenExplosion)
	i += 360/ammo
}

#define pulser_step
image_angle += 7 * current_time_scale * radiusmin/radius
if radiusmin < radius{radius /= (1 + .02/acc) * current_time_scale}
else
{
	var i = random(360)
	sleep(200)
	view_shake_at(x,y,200)
	repeat(ammo)
	{
		sound_play_pitch(sndExplosionXL,.7)
		sound_play_pitch(sndExplosionCar,.4)
		sound_play_pitch(sndPlasmaBigUpg,.4)
		instance_create(x+lengthdir_x(radius*2.5,i),y+lengthdir_y(radius*2.5,i),GreenExplosion)
		i += 360/ammo
	}
	radius = radiusmax
}
#define pulser_hit

#define pulser_draw
draw_set_alpha(.4*(radiusmin/radius))
draw_circle_color(x,y,radius,c_lime,c_lime,false)
draw_set_alpha(1)
mod_script_call("mod","defpack tools","draw_circle_width_colour",12,radius,1,image_angle,x,y,c_lime,1)
mod_script_call("mod","defpack tools","draw_circle_width_colour",12,radiusmax,1,image_angle*-1,x,y,c_lime,.2)
mod_script_call("mod","defpack tools","draw_circle_width_colour",12,radiusmin,1,image_angle*-1,x,y,c_lime,.2)
draw_self()

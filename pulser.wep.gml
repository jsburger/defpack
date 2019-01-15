#define init
global.sprPulser = sprite_add_weapon("sprites/sprPulser.png", 7, 3);
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
return 500;

#define weapon_cost
return 12;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 12;

#define weapon_text
return choose("SO STRANGE", "SO STRONG", "SO... GREEN");

#define weapon_fire
weapon_post(15,14,20)
extraspeed = 11+gunangle/10000
sound_play_pitch(sndSuperFlakCannon,.7)
sound_play_pitch(sndHeavyNader,.7)
sound_play_pitch(sndSuperSlugger,.7)
sleep(60)
with instance_create(x,y,CustomProjectile)
{
	creator = other
	team = other.team
	acc = other.accuracy
	move_contact_solid(other.gunangle,24)
	sprite_index = sprPlasmaBall
	image_speed = 0
	radiusmin = 28
	lifetime = 360
	life = lifetime
	radiusmax = radiusmin * 4
	radius = radiusmax
	ammo = 8
	mask_index = sprGrenade
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
if radiusmin < radius{radius /= (1 + (.02*current_time_scale)/acc)}
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
life -= current_time_scale
if life <= 0 instance_destroy()

#define pulser_hit

#define pulser_draw
draw_set_alpha(.4*(radiusmin/radius))
draw_circle_color(x,y,radius,c_lime,c_lime,false)
draw_set_alpha(1)
draw_set_alpha(.4)
draw_set_color(c_lime)
draw_pie(x-radiusmin+2,y-radiusmin+2,x+radiusmin,y+radiusmin,x+lengthdir_x(radiusmin,90),y+lengthdir_y(radiusmin,90),x+lengthdir_x(radiusmin,360*(life/lifetime)+90),y+lengthdir_y(radiusmin,360*(life/lifetime)+90),false,16)
draw_set_alpha(1)
draw_line_width(x,y,x+lengthdir_x(radius-1,91),y+lengthdir_y(radius-1,91),1)
draw_line_width(x,y,x+lengthdir_x(radius-1,360*(life/lifetime)+90),y+lengthdir_y(radius-1,360*(life/lifetime)+90),1)
draw_set_color(c_white)
mod_script_call("mod","defpack tools","draw_circle_width_colour",12,radius,1,image_angle,x,y,c_lime,1)
mod_script_call("mod","defpack tools","draw_circle_width_colour",12,radiusmax,1,image_angle*-1,x,y,c_lime,.1+.5/(radius/radiusmin))
mod_script_call("mod","defpack tools","draw_circle_width_colour",12,radiusmin,1,image_angle*-1,x,y,c_lime,.7)

#define draw_pie(_x1,_y1,_x2,_y2,_x3,_y3,_x4,_y4,_outline,_precision)
{
    var x1,y1,x2,y2,x3,y3,x4,y4,outline,precision;
    x1 = argument0;
    y1 = argument1;
    x2 = argument2;
    y2 = argument3;
    x3 = argument4;
    y3 = argument5;
    x4 = argument6;
    y4 = argument7;
    outline = argument8;
    precision = argument9;
    if (precision == 0) precision = 24;
    var res,xm,ym,xr,yr,r,a1,a2,sx,sy,a;
    res = 360 / min(max(4,4*(precision div 4)),64);
    xm = (x1+x2)/2;
    ym = (y1+y2)/2;
    xr = abs(x2-x1)/2;
    yr = abs(y2-y1)/2;
    if (xr > 0) r = yr/xr;
    else r = 0;
    a1 = point_direction(0,0,(x3-xm)*r,y3-ym);
    a2 = point_direction(0,0,(x4-xm)*r,y4-ym);
    if (a2<a1) a2 += 360;
    if (outline) draw_primitive_begin(pr_linestrip);
    else draw_primitive_begin(pr_trianglefan);
    draw_vertex(xm,ym);
    sx = xm+lengthdir_x(xr,a1);
    sy = ym+lengthdir_y(yr,a1);
    draw_vertex(sx,sy);
    for (a=res*(a1 div res + 1); a<a2; a+=res) {
        sx = xm+lengthdir_x(xr,a);
        sy = ym+lengthdir_y(yr,a);
        draw_vertex(sx,sy);
    }
    sx = xm+lengthdir_x(xr,a2);
    sy = ym+lengthdir_y(yr,a2);
    draw_vertex(sx,sy);
    if (outline) draw_vertex(xm,ym);
    draw_primitive_end();
    return 0;
}

#define step
if "extraspeed" in self
{
	if extraspeed > 0
	{
		if irandom(2) != 0{instance_create(x,y,Dust)}
		motion_add(frac(extraspeed)*10000-180,extraspeed-frac(extraspeed))
		extraspeed--
	}
	else{extraspeed = 0}
}

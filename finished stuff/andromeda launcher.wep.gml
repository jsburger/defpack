#define init
global.sprAndromedaLauncher = sprite_add_weapon("sprAndromedaLauncher.png", 0, 5);
global.sprAndromedaBullet = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAACAAAAAQCAYAAAB3AH1ZAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACLSURBVEhL3ZXRCcAgDESzRaEDdI6O1s1tgkmrcK1NFIQevK/gy+GH0rpsXewHXaRkPCXPyzNQ6qFe/jWDC/iWWwYViC23/KNAX6DU4EjHhGaGesKBUsGWt0qoJxwoFaYXEFrLBfWEA6Ue1BMOlHpgRUcJvl8k9TC9wPSnWCT+EoM/o7rEW5E8v88QnexX3Z4Uujk7AAAAAElFTkSuQmCCAAAAAAAAAAAAAA==",2, 8, 8);
global.space = sprite_add("spaceforeground.png",1,0,0);
global.space2 = sprite_add("spacebackground.png",1,0,0);

with CustomObject instance_destroy()
with script_bind_draw(spacedraw,7.9) {
	persistent = 1
	with CustomDraw if script[2] = "spacedraw"{
		if id !=other.id instance_destroy()
	}
}

#define weapon_name
return "ANDROMEDA LAUNCHER"

#define weapon_sprt
return global.sprAndromedaLauncher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 60;

#define weapon_cost
return 12;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 15;

#define weapon_text
return "TAKE IT IN YOUR HEART NOW, LOVER";

/*#define weapon_fire
with instance_create(x+lengthdir_x(14,gunangle),y+lengthdir_y(14,gunangle),CustomObject){
	creator = other
	team = other.team
	xgoal = mouse_x[other.index]
	ygoal = mouse_y[other.index]
	index = other.index
	mask_index = global.sprAndromedaBullet
	if !place_meeting(xgoal,ygoal,Floor){
		var dude = instance_nearest(xgoal,ygoal,Floor);
		xgoal = dude.x
		ygoal = dude.y
	}
	sprite_inde = global.sprAndromedaBullet
	image_speed = 0
	z=0
	depth = -16
	zspeed=16
	canz = 1
	on_step = androstep
	on_draw = androdraw
	mode = 0
	andromeda = 1
	succspeed = 0
	succ = 0
	wallbreak = 15
	succmax = 0
}

#define androstep
var sped = point_distance(x,y,xgoal,ygoal)/10
var dir = point_direction(x,y,xgoal,ygoal)
x+=lengthdir_x(sped,dir)
y+=lengthdir_y(sped,dir)
if canz with instance_create(x,y-z - zspeed,BoltTrail){
	image_angle = point_direction(other.x,other.y-other.z,other.xprevious,other.yprevious-(other.z - other.zspeed))
	image_xscale = point_distance(other.x,other.y-other.z,other.xprevious,other.yprevious-(other.z - other.zspeed))+1
	depth = other.depth
}

if sped < .2{
	xgoal = x
	ygoal = y
}
if mode = 1{
	if succspeed > 0{
		succ += succspeed--
	}
	if succspeed < 0{
		succ += succspeed++
	}
	succspeed-= .05
	succmax = max(succ,succmax)
	if wallbreak{
		with Wall if distance_to_object(other) < other.succ{
			instance_create(x,y,FloorExplo)
			instance_destroy()
		}
		wallbreak--
		succspeed = max(succspeed,0)
	}
	with Corpse if distance_to_object(other)<other.succ{
		motion_add(point_direction(x,y,other.x,other.y),1)
		if distance_to_object(other) <= 5 && instance_exists(enemy){
			other.succ++
			other.wallbreak = 1
			instance_destroy()
		}
	}
	with Player //Prism Interaction
	{
		if point_distance(x,y,other.x,other.y) < 20
		{
			if wep = "prism"
			{
				if button_pressed(index,"pick")
				{
					repeat(30) instance_create(x,y,Dust)
					sound_play_pitch(sndUncurse,.5)
					sound_play_pitch(sndCursedPickup,.5)
					Player.wep = "antiprism"
				}
			}
		}
	}
	if irandom(80) = 0{instance_create(x+random_range(-succ,succ),y+random_range(-succ,succ),CaveSparkle)}
	with Wind if distance_to_object(other)<other.succ {
		instance_destroy()
	}
	with WindNight if distance_to_object(other)<other.succ {
		instance_destroy()
	}
	with RainSplash if distance_to_object(other)<other.succ {
		instance_destroy()
	}
	with Scorch if distance_to_object(other)<other.succ {
		instance_change(CaveSparkle,true)
	}
	with ScorchTop if distance_to_object(other)<other.succ {
		instance_change(CaveSparkle,true)
	}
	with ScorchGreen if distance_to_object(other)<other.succ {
		instance_change(CaveSparkle,true)
	}
	with Scorchmark if distance_to_object(other)<other.succ {
		instance_change(CaveSparkle,true)
	}
	with MeltSplat if distance_to_object(other)<other.succ {
		instance_change(CaveSparkle,true)
	}
	with TrapScorchMark if distance_to_object(other)<other.succ {
		instance_change(CaveSparkle,true)
	}
	with Dust if distance_to_object(other)<other.succ {
		instance_change(CaveSparkle,true)
	}
	with Smoke if distance_to_object(other)<other.succ {
		instance_change(CaveSparkle,true)
	}
	with Shell
	{
		if distance_to_object(other)<other.succ {if "fall" not in self{fall = true}}
		if "fall" in self
		{
			image_xscale -= .04
			image_yscale -= .04
			image_alpha -= .02
			image_angle += (1 - image_xscale)*3
			image_blend = merge_colour(image_blend,c_black,.05)
			if image_xscale <= 0{instance_destroy()}
		}
	}
	with Feather
	{
		if distance_to_object(other)<other.succ {if "fall" not in self{fall = true}}
		if "fall" in self
		{
			image_xscale -= .04
			image_yscale -= .04
			image_alpha -= .02
			image_angle += (1 - image_xscale)*3
			image_blend = merge_colour(image_blend,c_black,.05)
			if image_xscale <= 0{instance_destroy()}
		}
	}
	with Debris
	{
		if distance_to_object(other)<other.succ {if "fall" not in self{fall = true}}
		if "fall" in self
		{
			image_xscale -= .04
			image_yscale -= .04
			image_alpha -= .02
			image_angle += (1 - image_xscale)*3
			image_blend = merge_colour(image_blend,c_black,.05)
			if image_xscale <= 0{instance_destroy()}
		}
	}
	with projectile
		{
			if distance_to_object(other)<other.succ {if "fall" not in self{fall = true}}
			if "fall" in self
			{
				damage = 0
				image_xscale -= .04
				image_yscale -= .04
				image_alpha -= .02
				speed /= 1.01
				image_angle += (1 - image_xscale)*3
				image_blend = merge_colour(image_blend,c_black,.05)
				if image_xscale <= 0{instance_delete(self)}
			}
		}
}
with hitme if distance_to_object(other)<other.succ {
	if team != other.team{
		motion_add(point_direction(other.x,other.y,x,y),other.speed*.8)
	}
}
if succ < 0 instance_destroy()
#define androdraw
if mode = 0{
	if canz {z+=zspeed--}
	if canz && zspeed < 0 && z <= 40{
		canz = 0
		z = 40
		if fork(){
			wait(30)
			mode = 1
			image_index = 1
			sound_play(sndPortalOpen)
			succspeed = 15
			exit
		}
	}
}
if mode = 0
{
draw_sprite_ext(sprite_inde,image_index,x,y,image_xscale,image_yscale/2,0,image_blend,image_alpha/2)
draw_sprite_ext(sprite_inde,image_index,x,y-z,image_xscale,image_yscale,image_angle,image_blend,image_alpha)
}
draw_set_blend_mode(bm_add)
draw_sprite_ext(sprite_inde,image_index,x,y-z,image_xscale*1.5,image_yscale*1.5,image_angle,image_blend,image_alpha/20)
draw_sprite_ext(sprite_inde,image_index,x,y-z,image_xscale*1.7,image_yscale*1.7,image_angle,image_blend,image_alpha/20)
draw_sprite_ext(sprite_inde,image_index,x,y-z,image_xscale*1.9,image_yscale*1.9,image_angle,image_blend,image_alpha/20)
draw_set_blend_mode(bm_normal)
if mode = 1{
	draw_circle_colour(x-1, y-z-1, 7, c_white, c_white, false)//the circle is drawn instead of the andromeda projectile, would probably make sense to change the first image of the animation to a draw_circle tbh
	var a = 2*cos(current_frame/20)
	var b = 2*sin(current_frame/20)
	draw_sprite_ext(sprSlash,0,x,y-z,1/8,.45,a*90,make_color_rgb(55, 252, 91),.81)
	draw_sprite_ext(sprSlash,0,x,y-z,1/8,.45,b*90,make_color_rgb(57, 180, 252),.81)
	draw_sprite_ext(sprSlash,0,x,y-z,1/8,.45,2*a*90,make_color_rgb(252, 248, 55),.81)
	draw_sprite_ext(sprSlash,0,x,y-z,1/8,.45,2*b*90,make_color_rgb(252, 71, 55),.81)
	draw_sprite_ext(sprSlash,0,x,y-z,1/8,.45,a*b*90,make_color_rgb(209, 55, 252),.81)
	with Player //Prism Interaction
	{
		if point_distance(x,y,other.x,other.y) < 20
		{
			if wep = "prism"
			{
				draw_text_nt(x,y-46-string_height("ASCEND")*2,"ASCEND")
				draw_sprite(sprEPickup,0,x,y-38)
			}
		}
	}
}
*/

#define drawmyshit(_x,_y,scale,size,off)
var xref,yref,xn,yn;
xref = _x-view_xview[index]/scale
yref = _y-view_yview[index]/scale
xn = off+xref/size;
yn = off+yref/size;
draw_vertex_texture(_x,_y,xn,yn)


/*
#define spacedraw
var xref,yref,sprite;
sprite = global.space
var tex,tex2,w,h,xn,yn;
tex = sprite_get_texture(sprite, 0);
tex2 = sprite_get_texture(global.space2,0)
texture_set_repeat(1);
var size = 128
with instances_matching(CustomObject,"andromeda",1) if mode = 1{
	if instance_exists(Player){
		var p = instance_nearest(x,y,Player);
		var dir = point_direction(x,y,p.x,p.y)
		if point_seen(x+lengthdir_x(succ,dir),y+lengthdir_y(succ,dir),p.index) || distance_to_object(p)<succ{

			draw_primitive_begin_texture(pr_trianglefan, tex2);
			drawmyshit(x,y,1000,size*4,0)
			for (var i = 0; i<= 360; i+=20){
				drawmyshit(x+lengthdir_x(succ,i),y+lengthdir_y(succ,i),1000,size*4,0)
			}
			draw_primitive_end();

			draw_primitive_begin_texture(pr_trianglefan, tex);
			drawmyshit(x,y,2,size/2,0)
			for (var i = 0; i<= 360; i+=20){
				drawmyshit(x+lengthdir_x(succ,i),y+lengthdir_y(succ,i),2,size/2,0)
			}
			draw_primitive_end();

			draw_primitive_begin_texture(pr_trianglefan, tex);
			drawmyshit(x,y,3,size,.5)
			for (var i = 0; i<= 360; i+=20){
				drawmyshit(x+lengthdir_x(succ,i),y+lengthdir_y(succ,i),3,size,.5)
			}
			draw_primitive_end();

		}
	}
}
draw_set_color(c_white);
draw_set_alpha(1);
texture_set_repeat(false);
*/


/*#define weapon_fire
with instance_create(x,y,CustomObject){
	on_step = medastep
	on_destroy = medadestroy
	on_draw = medadraw
	creator = other
	team = other.team
	sprite_index = global.sprAndromedaBullet
	image_speed = 0
	time = 100
	succ = 0
	stones = 0
	motion_set(other.gunangle,6)
	friction = .3
	depth = other.depth-1
}

#define spacedraw
var xref,yref,sprite;
sprite = global.space
var tex,w,h,xn,yn;
tex = sprite_get_texture(sprite, 0);
texture_set_repeat(1);
with instances_matching_ge(CustomObject,"succ",0){
	draw_primitive_begin_texture(pr_trianglefan, tex);
	drawmyshit(x,y,sprite,2)
	for (var i = 0; i<= 360; i+=10){
		drawmyshit(x+lengthdir_x(succ,i),y+lengthdir_y(succ,i),sprite,2)
	}
	draw_primitive_end();
}
draw_set_color(c_white);
draw_set_alpha(1);
texture_set_repeat(false);

#define drawmyshit(_x,_y,sprite,scale)
w = sprite_get_width(sprite);
h = sprite_get_height(sprite);
xref = _x-view_xview[0]/scale
yref = _y-view_yview[0]/scale
xn = .5+xref/w;
yn = .5+yref/h;
draw_vertex_texture(_x,_y,xn,yn)


#define medadraw
draw_sprite_ext(sprite_index,image_index,x,y,succ/200,succ/200,image_angle,image_blend,image_alpha)
var scale = max(0,current_frame mod 20 - 10);
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale + scale/5,image_yscale + scale/5,image_angle, make_color_hsv(current_frame mod 255,155,255),scale/20)

#define medastep
if speed <= 1{
	speed = 0
}
if !speed && !(current_frame mod 2){
	time-=.5
	if time{
		succ+= 1
		image_index = 1
		with instance_nearest(x,y,Wall) if distance_to_object(other)<other.succ{
			with instance_create(x,y,PortalClear){
				image_xscale = 1/4
				image_yscale = 1/4
			}
		}
		var me = self;
		with Debris if distance_to_object(other)<other.succ{
			with instance_create(x,y,BoltTrail){
				image_xscale = point_distance(other.x,other.y,me.x,me.y)
				image_angle = point_direction(other.x,other.y,me.x,me.y)
				image_blend = make_color_hsv(image_angle*(360/255),225,225)
			}
			x = other.x
			y = other.y
			other.stones++
			instance_destroy()
		}
		image_xscale+=.01
		image_yscale+=.01
	}
	if time = -30 instance_destroy()
}

#define medadestroy
sound_play(sndExplosion)
if fork(){
	var tem = team;
	var stoes = stones;
	var _x = x;
	var _y = y;
	for (var i = 0; i <= stoes; i++){
		with instance_create(_x,_y,CustomProjectile){
			damage = 4
			team = tem
			sprite_index = global.WhiteDebris
			motion_set(i*(360/stoes),18)
			on_step = shrapstep
			hue = 0
		}
		//if !(i mod round(stoes/5)) wait(1)
	}
	exit
}

#define shrapstep
hue+= speed
with instance_create(x,y,BoltTrail){
	image_xscale = other.speed
	image_angle = other.direction
	image_blend = make_color_hsv(other.hue,225,225)
}*/


/*
#define weapon_fire
sound_play(sndGrenadeRifle)
weapon_post(4,-3,5)
with instance_create(x,y,CustomProjectile){
	team = other.team
	creator = other
	sprite_index = global.sprAndromedaBullet
	motion_add(other.gunangle + random_range(-5,5) * other.accuracy,5)
	image_angle = direction
	image_speed = 0
	breaklength = 0
	timer = room_speed * 8
	dc = 0
	typ = 3
	on_step = coolstep
	on_wall = coolwall
	on_hit = nothing
	on_draw = cooldraw
}

#define nothing

#define coolhit
projectile_hit(other,1+GameCont.loops)

#define cooldraw
draw_self()
draw_set_blend_mode(bm_add)
draw_sprite_ext(global.Spiralthing,0,x,y,breaklength/50,breaklength/50,4 * -timer, make_colour_hsv(timer * -4,255,255),.5)
draw_set_blend_mode(bm_normal)

#define coolwall
if speed > 0 move_bounce_solid(false)

#define coolstep
image_xscale = random_range(.8, 1.2)
image_yscale = image_xscale
image_angle += random_range(1,3)

if speed > 0{
	speed -= .1
	if irandom(3) = 3 {instance_create(x,y,Debris)}
}
else{
	if dc = 0 {
		dc = 1
		on_hit = coolhit
		breaklength = 10
		repeat(10){
			instance_create(x+ random_range(-16,16), y + random_range(-16,16),Debris)
		}
	}
	speed = 0
	breaklength += .7
	image_index = 1
	with Wall if distance_to_object(other) < other.breaklength{
		with instance_create(x,y,PortalClear){
			image_xscale = 1/4
			image_yscale = 1/4
		}
	}
	with Debris if distance_to_object(other) < other.breaklength{
		if "core" not in self{core = other; sprite_index = global.WhiteDebris}
		if instance_exists(core){
			if !collision_line(x,y,core.x,core.y,Wall,0,0){
				image_angle -= random_range(2,6)
				motion_set(point_direction(x,y,core.x,core.y)-80*random_range(0.8,1.1),12 - 12/distance_to_object(core))
				image_blend = make_colour_hsv(distance_to_object(core) - distance_to_object(core)/255,255*random_range(0.7,1),250*random_range(0.8,1))
			}
		}
		else core = other
	}
	with Dust if distance_to_object(other) < other.breaklength{
		instance_destroy()
	}
	with enemy if distance_to_object(other) < other.breaklength{
		motion_add(point_direction(x,y,other.x,other.y),1)
	}
	timer -= 1
	if timer <= 0{instance_destroy()}
}

/*#define weapon_fire

sound_play(sndGrenadeRifle)
wkick = 4
with instance_create(x+lengthdir_x(10,point_direction(x,y,mouse_x,mouse_y)),y+lengthdir_y(10,point_direction(x,y,mouse_x,mouse_y)),CustomObject)
{
	team = other.team
	damage = 1
	dc = 0
	breaktimer = 10
	debrischeck = 0
	timer = room_speed*12
	sprite_index = global.sprAndromedaBullet
	motion_add(point_direction(x,y,mouse_x,mouse_y),5)
	image_angle = direction
	image_speed = 0
	typ = 3
	do
	{
		fac = random_range(0.8,1.2)
		image_xscale = fac
		image_yscale = fac
		image_angle -= random_range(1,3)
		if speed > 0
		{
			if place_meeting(x+lengthdir_x(20,direction),y+lengthdir_y(20,direction),Wall)
			{
				with instance_nearest(x,y,Wall)
				{
					instance_create(x,y,FloorExplo)
					instance_destroy()
				}
			}
			if irandom(3) = 3
			{
				instance_create(x+random_range(-4,4),y+random_range(-4,4),Debris)
			}
			speed -= 0.09
			image_index = 0
		}
		else
		{
			speed = 0
			image_speed = 0.7
			image_index = 1
			if breaktimer > 0
			{
				breaktimer -= 1
			}
			else
			{
				with instance_nearest(x,y,Wall)
				{
					instance_create(x,y,FloorExplo)
					instance_destroy()
				}
				breaktimer = 6
			}
			if dc = 0
			{
				repeat(10)
				{
					instance_create(x+random_range(-4,4),y+random_range(-4,4),Debris)
				}
				dc = 1
			}
			if instance_exists(Dust)
			{
				with instance_nearest(x,y,Dust)
				{
					instance_destroy()
				}
			}
			timer -= 1
			if timer > 0
			{
				with Debris
				{
					sprite_index = global.WhiteDebris
					core = instance_nearest(x,y,CustomObject)
					if instance_exists(core)
					{
						if collision_line(x,y,core.x,core.y,Wall,0,0) < 0
						{
							image_angle -= random_range(2,6)
							motion_set(point_direction(x,y,core.x,core.y)-90*random_range(0.8,1.1),random_range(4,7))
							image_blend = make_colour_hsv((12*(id/(id*random_range(0.98,1.02)))*(core.timer/room_speed*12))+1,255*random_range(0.7,1),250*random_range(0.8,1)) //+1 TO BE REPLACED WITH AN INDIVIDUAL HUE OFFSET
						}
					}
				}
			}
			else
			{
				instance_destroy()
			}
		}
		wait(1)
	}while instance_exists(self)
}

#define init
global.sprRainmaker = sprite_add_weapon("sprites/sprRainmaker.png", 10, 5);
global.stripes = sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_name
return "RAINMAKER"

#define weapon_sprt
return global.sprRainmaker;

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
return choose("WHAT A BRIS","A STORM IS COMING");

#define weapon_fire
var _strtsize = 110;
var _endsize  = 26;
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
	accspeed = 1.06
	payload = script_ref_create(pop)
	lasercolour1 = c_blue
	lasercolour = lasercolour1
	lasercolour2 = c_navy
	on_draw = abris_draw_lightning
}
sound_play_pitch(sndSniperTarget,exp((_strtsize-_endsize)/room_speed/current_time_scale/accuracy*(1.06)))

#define pop
with instance_create(x,y,CustomObject)
{
	timer  = room_speed*current_time_scale
	timer2 = room_speed*current_time_scale*7
	with instances_matching(CustomObject,"name","RainMakerRain"){other.timer=0;other.timer2+=timer2;instance_destroy()}
	spr_shadow = shd24
	name = "RainMakerRain"
	on_step = rain_step
}
sound_play_pitch(sndGrenadeRifle,.3)
sound_play_pitch(sndExplosion,2)
sound_play_pitch(sndExplosionS,.7)
sound_play_pitchvol(sndExplosionL,.5,.6)
sound_set_track_position(sndExplosionL,.3)
if skill_get(17)=true
{
	sound_play_pitchvol(sndLightningCannonEnd,.8,.7)
	sound_play_pitchvol(sndLightningRifleUpg,.7,.6)
}
else
{
	sound_play_pitchvol(sndLightningRifle,.7,.6)
}
with creator{weapon_post(9,0,159)}
sleep(300)
with instance_create(mouse_x[index],mouse_y[index],CustomObject)
{
	acc = other.acc
	m = 0
	timer = irandom_range(1,4)
	on_step = lit_step
}

#define abris_draw_lightning
if instance_exists(creator) && check{
	x = creator.x
	y = creator.y
	if button_check(creator.index, (check = 1? "fire":"spec")){
		if !collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0){
			var radi = acc+accmin;
			mod_script_call("mod", "defpack tools","draw_polygon_striped", 4, radi, acc+image_angle, mouse_x[index]+1, mouse_y[index]+1, global.stripes, lasercolour1, 0.1+(accbase-acc)/(accbase*5),(current_frame mod 16)*.004);
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",4,radi,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,1*(accbase-acc))
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",4, accmin,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,.2)
			draw_line_width_colour(x,y,mouse_x[index],mouse_y[index],1,lasercolour1,lasercolour1);
		}
		else{
			var q = instance_create(x,y,CustomObject);
			with q{
				mask_index = sprBulletShell
				image_angle = other.creator.gunangle
				move_contact_solid(image_angle,game_width)
			}
			draw_line_width_colour(x,y,q.x,q.y,1,lasercolour2,lasercolour2)
			with q instance_destroy()
		}
		var comp = (check = 1 ? creator.wep : creator.bwep);
		if popped {comp = wep}
		if wep != comp {instance_destroy()}
	}
}

#define rain_step
if timer > 0{timer--}
else
{
	if timer2 > 0{
		timer2--
		if timer2 > room_speed*current_time_scale*3{var _rainfac = 42}else{var _rainfac = 17}
		if timer2 < room_speed*current_time_scale{var _rainfac = 42}
		with Floor
		{
			if irandom(_rainfac) = 0
			{
				instance_create(x+random_range(-16,16),y+random_range(-16,16),RainDrop)
			}
		}
	}
	else{instance_destroy()}//sndHorrorLoop is good sound but unusable since horror exists
}

#define lit_step
if timer>0{timer-=current_time_scale}
else
{
	timer = 13
	m++
	if instance_exists(enemy)
	{
		var closeboy = instance_nearest(x,y,enemy)
		if distance_to_object(closeboy)<acc{mod_script_call("mod","defpack tools","create_lightning",closeboy.x,closeboy.y)}
		else{mod_script_call("mod","defpack tools","create_lightning",x+lengthdir_x(acc,random(360)),y+lengthdir_y(acc,random(360)))}
	}
	else{mod_script_call("mod","defpack tools","create_lightning",x+lengthdir_x(acc,random(360)),y+lengthdir_y(acc,random(360)))}
}
if m > 3{instance_destroy()}

#define draw_shadows
with CustomObject
{
	trace("c")
	if("name" in self && name = "RainMakerRain")
	{
			trace("g")
			draw_sprite_ext(shd96, 0, x, y, 10000, 10000, 0, c_black,1)
	}
}
/*#define weapon_fire
with instance_create(x,y,CustomObject)
{
	creator = other
	team = other.team
	index = creator.index
	accbase = 110*creator.accuracy
	acc = accbase
	on_step = GoldenAbrisPistol_step
	on_draw = GoldenAbrisPistol_draw
	lasercolour1 = c_blue
	lasercolour = lasercolour1
	lasercolour2 = c_navy
	offset = 0
}

#define GoldenAbrisPistol_step
if instance_exists(creator)
{
	image_angle += 4
	creator.reload = weapon_get_load(creator.wep)
	if skill_get(19) = false{acc /= 1.06}
	else{acc /= 2.3}
	x = creator.x
	y = creator.y
	if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) >= 0
	{
		if acc < accbase{acc += abs(creator.accuracy*3)}else{acc = accbase}
	}
	if button_released(creator.index, "fire")
	{
		if creator.ammo[5] >= 18
		{
			if creator.infammo = 0{creator.ammo[5] -= 18}
			if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) < 0
			{
				sound_play(sndGrenadeRifle)
				sound_play(sndExplosionS)
				creator.wkick = 9
				with instance_create(mouse_x[index],mouse_y[index],LightningBall){team = other.team}
				repeat(4)
				{
					with instance_create(mouse_x[index]+lengthdir_x(acc+10,offset+image_angle),mouse_y[index]+lengthdir_y(acc+10,offset+image_angle),LightningBall){team = other.team}
					offset += 90
				}
			}
			else
			{
				if creator.infammo = 0{creator.ammo[5] += 18}
			}
		}
		instance_destroy()
	}
}
else{instance_destroy()}t

#define GoldenAbrisPistol_draw
if creator.ammo[5] < 18{instance_destroy()}
else
if instance_exists(creator)
{
	if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) < 0
	{
		lasercolour = merge_colour(lasercolour1,lasercolour,.11)
		draw_line_width_colour(x,y,mouse_x[index],mouse_y[index],1,lasercolour,lasercolour);
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",4,acc+26,1,acc-image_angle,mouse_x[index],mouse_y[index],lasercolour1,1)
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",4,26,2,acc-image_angle,mouse_x[index],mouse_y[index],lasercolour1,.2)
		mod_script_call("mod", "defpack tools","draw_polygon_striped", 4, acc+26,acc-image_angle, mouse_x[index]+1, mouse_y[index]+1, global.stripes, lasercolour, 0.1+(accbase-acc)/(accbase*6));
	}
	else
	{
		var hitwall = collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0)//there is currently a bug where this chooses the furthest wall if you aim through multiple walls pls fix
	}
	lasercolour = merge_colour(lasercolour,lasercolour2,.33)
	draw_line_width_colour(x,y,x+lengthdir_x(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),y+lengthdir_y(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),1,lasercolour,lasercolour)
	if weapon_get_name(creator.wep) != "LIGHTNING ABRIS LAUNCHER"{instance_destroy()}
}

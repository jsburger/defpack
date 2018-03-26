#define init
global.sprLightningAbrisLauncher = sprite_add_weapon("Lightning Abris Launcher.png", 3, 5);
global.stripes = sprite_add("BIGstripes.png",1,1,1)

#define weapon_name
return "LIGHTNING ABRIS LAUNCHER"

#define weapon_sprt
return global.sprLightningAbrisLauncher;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 80;

#define weapon_cost
return 18;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 14;

#define weapon_text
return "WHAT A BRIS";

#define weapon_fire
sound_play_pitch(sndSniperTarget,.55)
with mod_script_call("mod","defpack tools","create_abris",self,110,26,argument0){
	accspeed = [1.06,2.3]
	payload = script_ref_create(pop)
	lasercolour1 = c_blue
	lasercolour = lasercolour1
	lasercolour2 = c_navy
	on_draw = abris_draw_lightning
}

#define pop
sound_play(sndGrenadeRifle)
sound_play(sndExplosionS)
creator.wkick = 9
with instance_create(mouse_x[index],mouse_y[index],LightningBall){team = other.team}
repeat(4)
{
	with instance_create(mouse_x[index]+lengthdir_x(acc+10,offset+image_angle),mouse_y[index]+lengthdir_y(acc+10,offset+image_angle),LightningBall){team = other.team}
	offset += 90
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

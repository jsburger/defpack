#define init
global.sprPlasmaAbrisLauncher = sprite_add_weapon("sprites/Plasma Abris Launcher.png", 0, 3);
global.stripes = sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_name
return "PLASMA ABRIS LAUNCHER"

#define weapon_sprt
return global.sprPlasmaAbrisLauncher;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 19;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 6;

#define weapon_text
return "HUMORON";

#define weapon_fire
sound_play_pitch(sndSniperTarget,1.2)
with mod_script_call("mod","defpack tools","create_abris",self,44,22,argument0){
circlemass = 8 + skill_get(17)*6
accspeed = [1.14,2.3]
payload = script_ref_create(pop)
lasercolour1 = $00FF00
lasercolour = lasercolour1
lasercolour2 = $00AF00
offset2 = random(360)
on_draw = abris_draw_plasma
}

#define pop
sound_play(sndPlasma)
creator.wkick = 4
repeat(circlemass)
{
	with instance_create(mouse_x[index]+lengthdir_x(acc+16+6,offset2),mouse_y[index]+lengthdir_y(acc+16+6,offset2),PlasmaImpact)
	{
		image_xscale = .5
		image_yscale = .5
		image_speed = random_range(.3,.7)
		if !place_meeting(x,y,Floor){instance_destroy()}
	}
	offset2 += 360/circlemass
}

#define abris_draw_plasma
if instance_exists(creator) && check{
	x = creator.x
	y = creator.y
	if button_check(creator.index, (check = 1? "fire":"spec")){
		if !collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0){
			var radi = acc+accmin;
			mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, radi, 45, mouse_x[index]+1, mouse_y[index]+1, global.stripes, lasercolour1, 0.1+(accbase-acc)/(accbase*5),(current_frame mod 16)*.004);
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,radi+6,1,acc+(image_angle*-1),mouse_x[index],mouse_y[index],lasercolour1,.8)
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,radi,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,1*(accbase-acc))
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16, accmin,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,.2)
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
/*
#define weapon_fire

with instance_create(x,y,CustomObject)
{
	creator = other
	offset = random(360)
	offset2 = random(360)
	circlemass = 8 + skill_get(17)*6
	index = creator.index
	accbase = 44*creator.accuracy
	acc = accbase
	on_step = Inquisitor_step //ctrl + c & v are my favourite anime characters
	on_draw = Inquisitor_draw
	lasercolour1 = $00FF00
	lasercolour = lasercolour1
	lasercolour2 = $00AF00
}

#define Inquisitor_step
if instance_exists(creator)
{
	offset += 7
	image_angle += 7
	creator.reload = weapon_get_load(creator.wep)
	if skill_get(19) = false{acc /= 1.2}
	else{acc /= 1.6}
	x = creator.x
	y = creator.y
	if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) >= 0
	{
		if acc < accbase{acc += abs(creator.accuracy*3)}else{acc = accbase}
	}
	if !button_check(index, "fire")
	{
		if creator.ammo[5] >= 2
		{
			if creator.infammo <= 0{creator.ammo[5] -= 2}
			if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) < 0
			{
				sound_play(sndPlasma)
				creator.wkick = 4
				repeat(circlemass)
				{
					with instance_create(mouse_x[index]+lengthdir_x(acc+16,offset2),mouse_y[index]+lengthdir_y(acc+16,offset2),PlasmaImpact)
					{
						image_xscale = .5
						image_yscale = .5
						image_speed = random_range(.3,.7)
						if !place_meeting(x,y,Floor){instance_destroy()}
					}
					offset2 += 360/circlemass
				}
			}
			else
			{
				if creator.infammo <= 0{creator.ammo[5] += 2}
			}
		}
	instance_destroy()
	}
}
else{instance_destroy()}

#define Inquisitor_draw
if creator.ammo[5] < 2{instance_destroy();exit}
if instance_exists(creator)
{
	if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) < 0
	{
		lasercolour = merge_colour(lasercolour1,lasercolour,.11)
		draw_line_width_colour(x,y,mouse_x[index],mouse_y[index],1,lasercolour,lasercolour);
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,acc+22,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,(1-skill_get(17)*.7)*(accbase-acc))
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,acc+18,1,acc+image_angle*1.2,mouse_x[index],mouse_y[index],lasercolour1,(1-skill_get(17)*.7)*(accbase-acc))
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,22,1,acc+(image_angle*-1),mouse_x[index],mouse_y[index],lasercolour1,.35)
		mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, (acc+16), 48, mouse_x[index]+1, mouse_y[index]+1,global.stripes, lasercolour, 0.1+(accbase-acc)/(accbase*6));
	}
	else
	{
		var hitwall = collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0);//there is currently a bug where this chooses the furthest wall if you aim through multiple walls pls fix
	lasercolour = merge_colour(lasercolour,lasercolour2,.11)
	draw_line_width_colour(x,y,x+lengthdir_x(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),y+lengthdir_y(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),1,lasercolour,lasercolour)
	if weapon_get_name(creator.wep) != "PLASMA ABRIS LAUNCHER"{instance_destroy()}
	}
}

#define init
global.sprHeavyAbrisLauncher = sprite_add_weapon("sprites/Heavy Abris Launcher.png", 1, 5);
global.stripes = sprite_add("defpack tools/BIGstripes.png",1,1,1)
global.sprSmallGreenExplosion = sprite_add("sprites/projectiles/Small Green Explosion_strip7.png",7,12,12)
#define weapon_name
return "HEAVY ABRIS LAUNCHER"

#define weapon_sprt
return global.sprHeavyAbrisLauncher;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 29;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 13;

#define weapon_text
return "THEY WON'T SEE THAT ONE COMIN'";

#define weapon_fire
sound_play_pitch(sndSniperTarget,1.25)
with mod_script_call("mod","defpack tools","create_abris",self,55,40,argument0){
accspeed = [1.2,2.6]
payload = script_ref_create(pop)
lasercolour1 = c_lime
lasercolour = lasercolour1
lasercolour2 = c_green
}

#define pop
sound_play(sndGrenadeRifle)
sound_play(sndExplosion)
creator.wkick = 8
repeat(3)
{
	with instance_create(mouse_x[index]+lengthdir_x(acc+12,offset),mouse_y[index]+lengthdir_y(acc+12,offset),GreenExplosion)
	{
		hitid = [sprite_index,"Green Explosion"]
	}
	offset += 120
}
repeat(3)
{
	with instance_create(mouse_x[index]+lengthdir_x(acc+4,offset+45),mouse_y[index]+lengthdir_y(acc+4,offset+45),SmallExplosion)
	{
		sprite_index = global.sprSmallGreenExplosion
		hitid = [sprite_index,"Small Green
		Explosion"]
	}
	offset += 120
}

/*
#define weapon_fire
with instance_create(x,y,CustomObject)
{
	creator = other
	index = creator.index
	accbase = 55*creator.accuracy
	acc = accbase
	on_step = GoldenAbrisPistol_step
	on_draw = GoldenAbrisPistol_draw
	lasercolour1 = c_lime
	lasercolour = lasercolour1
	lasercolour2 = c_green
}

#define GoldenAbrisPistol_step
if instance_exists(creator)
{
	image_angle += .8
	creator.reload += 1
	if skill_get(19) = false{acc /= 1.2}
	else{acc /= 3.5}
	x = creator.x
	y = creator.y
	offset = random(359)
	if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) >= 0
	{
		if acc < accbase{acc += abs(creator.accuracy*3)}else{acc = accbase}
	}
	if button_released(creator.index, "fire")
	{
		if creator.ammo[4] >= 3
		{
			if creator.infammo = 0{creator.ammo[4] -= 3}
			if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) < 0
			{
				sound_play(sndGrenadeRifle)
				sound_play(sndExplosion)
				creator.wkick = 8
				repeat(3)
				{
					with instance_create(mouse_x[index]+lengthdir_x(acc+12,offset),mouse_y[index]+lengthdir_y(acc+12,offset),GreenExplosion)
					{
						hitid = [sprite_index,"Green Explosion"]
					}
					offset += 120
				}
				repeat(3)
				{
					with instance_create(mouse_x[index]+lengthdir_x(acc+4,offset+45),mouse_y[index]+lengthdir_y(acc+4,offset+45),SmallExplosion)
					{
						sprite_index = global.sprSmallGreenExplosion
						hitid = [sprite_index,"Small Green
						Explosion"]
					}
					offset += 120
				}
			}
			else
			{
				if creator.infammo = 0{creator.ammo[4] += 3}
			}
		}
		instance_destroy()
	}
}
else{instance_destroy()}

#define GoldenAbrisPistol_draw
if creator.ammo[4] < 1{instance_destroy()}
else
if instance_exists(creator)
{
	if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) < 0
	{
		lasercolour = merge_colour(lasercolour1,lasercolour,.11)
		draw_line_width_colour(x,y,mouse_x[index],mouse_y[index],1,lasercolour,lasercolour);
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,acc+40,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,1*(accbase-acc))
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,40,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,.2)
		mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, acc+40, 45, mouse_x[index]+1, mouse_y[index]+1, global.stripes, lasercolour, 0.1+(accbase-acc)/(accbase*6));
	}
	else
	{
		var hitwall = collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0)//there is currently a bug where this chooses the furthest wall if you aim through multiple walls pls fix
	}
	lasercolour = merge_colour(lasercolour,lasercolour2,.33)
	draw_line_width_colour(x,y,x+lengthdir_x(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),y+lengthdir_y(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),1,lasercolour,lasercolour)
	if weapon_get_name(creator.wep) != "HEAVY ABRIS LAUNCHER"{instance_destroy()}
}

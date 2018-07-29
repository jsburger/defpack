#define init
global.sprBloodAbrisLauncher = sprite_add_weapon("sprites/Blood Abris Launcher.png", 2, 2);
global.stripes = sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_name
return "BLOOD ABRIS LAUNCHER"

#define weapon_sprt
return global.sprBloodAbrisLauncher;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 19;

#define weapon_cost
return 0

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 7;

#define weapon_text
return "PROTECTION AT ALL COSTS";

#define weapon_fire
var _strtsize = 45-skill_get(13)*25
var _endsize  = 30;
sound_play_pitch(sndSniperTarget,1/accuracy+1.5)
if ammo[4] >= 2
{
	ammo[4] -= 2
	cost = 1
	with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
		accspeed = 1.33
		payload = script_ref_create(pop)
	}
}
else
{
	sprite_index = spr_hurt;
	sound_play(snd_hurt)
	image_index = 0;
	sound_play(sndBloodHurt);
	my_health --;
	lasthit = [global.sprBloodAbrisLauncher,"Blood Abris#Launcher"]
	sound_play(snd_hurt);
	sound_play(sndBloodLauncher)
	sound_play(sndBloodLauncherExplo)
	cost = 1
	with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
		accspeed = 1.33
		payload = script_ref_create(pop)
	}
}

#define pop
with instance_create(x,y,BloodStreak){image_angle = other.creator.gunangle}
sound_play_pitch(sndBloodLauncher,random_range(.8,1.2))
sound_play_pitch(sndBloodLauncherExplo,random_range(.8,1.2))
creator.wkick = 2
repeat(4){
instance_create(explo_x+lengthdir_x(acc+12,offset),explo_y+lengthdir_y(acc+12,offset),MeatExplosion);
with instance_create(explo_x+lengthdir_x(acc+12,offset+90),explo_y+lengthdir_y(acc+12,offset+90),BloodStreak)
{
	image_angle = point_direction(x,y,mouse_x[other.index],mouse_y[other.index])
}
with instance_create(explo_x+lengthdir_x(acc+22,offset+45),explo_y+lengthdir_y(acc+22,offset+45),BloodStreak)
{
	image_angle = point_direction(x,y,mouse_x[other.index],mouse_y[other.index])
}
offset += 90
}
/*
with instance_create(x,y,CustomObject)
{
	creator = other
	index = creator.index
	accbase = 44*creator.accuracy
	acc = accbase
	on_step = GoldenAbrisPistol_step
	on_draw = GoldenAbrisPistol_draw
	lasercolour1 = c_red
	lasercolour = lasercolour1
	lasercolour2 = c_maroon
	hitid = [global.sprBloodAbrisLauncher,"Blood Abris
	Launcher"]
}

#define GoldenAbrisPistol_step//wow much golden
if instance_exists(creator)
{
	image_angle += 1.3
	creator.reload = weapon_get_load(creator.wep)
	if skill_get(19) = false{acc /= 1.2}
	else{acc /= 3.5}
	x = creator.x
	y = creator.y
	offset = random(359)
	if collision_line(x,y,explo_x,explo_y,Wall,0,0) >= 0
	{
		if acc < accbase{acc += abs(creator.accuracy*3)}else{acc = accbase}
	}
	if button_released(creator.index, "fire")
	{
		if creator.ammo[4] >= 1
		{
			if creator.infammo <= 0{creator.ammo[4] -= 1}
			if collision_line(x,y,explo_x,explo_y,Wall,0,0) < 0
			{
				sound_play(sndBloodLauncher)
				sound_play(sndBloodLauncherExplo)
				creator.wkick = 5
        repeat(3){
        instance_create(explo_x+random_range(-20,20),explo_y+random_range(-20,20),MeatExplosion);
        }
			}
			else
			{
				if creator.infammo <= 0{creator.ammo[4] += 1}
			}
		}
    else
    {
        if collision_line(x,y,explo_x,explo_y,Wall,0,0) = noone
  			{
					with creator
					{
        		sprite_index = spr_hurt;
            sound_play(snd_hurt)
        		image_index = 0;
        		my_health --;
        		sound_play(snd_hurt);
						sound_play(sndBloodLauncher)
						sound_play(sndBloodLauncherExplo)
					}
  				creator.wkick = 5
          repeat(3){
          instance_create(explo_x+random_range(-20,20),explo_y+random_range(-20,20),MeatExplosion);
          }
  			}
      else
			{
				if creator.infammo <= 0{creator.ammo[4] += 1}
			}
		}
	instance_destroy()
	}
}
else{instance_destroy()}

#define GoldenAbrisPistol_draw
if creator.ammo[4] < 0{instance_destroy()}
else
if instance_exists(creator)
{
	if collision_line(x,y,explo_x,explo_y,Wall,0,0) < 0
	{
		lasercolour = merge_colour(lasercolour1,lasercolour,.11)
		draw_line_width_colour(x,y,explo_x,explo_y,1,lasercolour,lasercolour);
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,acc+30,1,acc+image_angle,explo_x,explo_y,lasercolour1,1*(accbase-acc))
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,30,1,acc+image_angle,explo_x,explo_y,lasercolour1,.2)
		mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, acc+30, 45, explo_x+1, explo_y+1, global.stripes, lasercolour, 0.1+(accbase-acc)/(accbase*6));
	}
	else
	{
		var hitwall = collision_line(x,y,explo_x,explo_y,Wall,0,0)//there is currently a bug where this chooses the furthest wall if you aim through multiple walls pls fix
	}
	lasercolour = merge_colour(lasercolour,lasercolour2,.33)
	draw_line_width_colour(x,y,x+lengthdir_x(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),y+lengthdir_y(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),1,lasercolour,lasercolour)
	if weapon_get_name(creator.wep) != "BLOOD ABRIS LAUNCHER"{instance_destroy()}
}/*

if (place_meeting(explo_x,explo_y,Floor) && collision_line(x,y,explo_x,explo_y,Wall,0,0) < 0) || instance_exists(Nothing2)
{
repeat(3){
instance_create(explo_x+random_range(-20,20),explo_y+random_range(-20,20),MeatExplosion);
}
sound_play(sndBloodLauncher);
sound_play(sndBloodLauncherExplo);
wkick = 4;

// Ammo Consumption/Blood Cost
  if infammo <=0 {
  	if ammo[4] - 1 < 0{
  		ammo[4] = 0;
  		sprite_index = spr_hurt;
      sound_play(snd_hurt)
  		image_index = 0;
  		my_health --;
  		sound_play(snd_hurt);
  	}
  	else ammo[4] -= 1;
  }
}
else
{
  reload = 1
}

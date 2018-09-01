#define init
global.sprInquisitor  = sprite_add_weapon("sprites/Inquisitor.png", 7, 4);

#define weapon_name
return "INQUISITOR"

#define weapon_sprt
return global.sprInquisitor;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 1;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapEnergy;

#define weapon_laser_sight
return true;

#define weapon_area
return 15;

#define weapon_text
return "DEVASTATION++";

#define weapon_fire
sound_play_pitch(sndSewerPipeBreak,.2)
sound_play_pitch(sndUltraLaser,.7)
sound_play_pitch(sndHyperLauncher,.4)
sound_play_pitch(sndPlasmaBig,.6)
sound_play_pitch(sndPlasmaReload,1.4)
sound_play_pitch(sndPlasmaBigUpg,.8)
if skill_get(17)=1{sound_play_pitch(sndLaserCannon,.4)}
sound_play_pitch(sndLaserCannonUpg,1.6)
weapon_post(3,4,1)
with instance_create(x,y,CustomProjectile)
{
	creator = other
	team = other.team
	hyperspeed = 8
	dir = 0
	on_hit = mark_hit
	on_step = mark_step
}

#define mark_hit

#define mark_step
while !collision_line(x,y,x+lengthdir_x(100,direction),y+lengthdir_y(100,direction),Wall,1,1) && !collision_line(x,y,x+lengthdir_x(100,direction),y+lengthdir_y(100,direction),hitme,0,1) && dir <1000{
    x+=lengthdir_x(100,direction)
    y+=lengthdir_y(100,direction)
    dir+=100
}

do
{
	dir += hyperspeed
	x += lengthdir_x(hyperspeed,direction)
	y += lengthdir_y(hyperspeed,direction)
	//redoing reflection code since the collision event of the reflecters doesnt work in substeps (still needs slash reflection)
	with instances_matching_ne([CrystalShield,PopoShield], "team", team){if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction;with instance_create(other.x,other.y,Deflect){image_angle = other.direction;sound_play_pitch(sndCrystalRicochet,random_range(.9,1.1))}}}
	with instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team){if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = direction ;other.image_angle = other.direction}}
	with instances_matching_ne([Shank,EnergyShank], "team", team){if place_meeting(x,y,other){with other{instance_destroy();exit}}}
	with instances_matching_ne(CustomSlash, "team", team){if place_meeting(x,y,other){with other{line()};mod_script_call(on_projectile[0],on_projectile[1],on_projectile[2]);}}
	with instances_matching_ne(hitme, "team", team)
	{
		if place_meeting(x,y,other)
		{
			with other
			{
				if "orbit" not in self orbit = current_time_scale/size
				else orbit += current_time_scale/size
			}
		}

	}
    if place_meeting(x+lengthdir_x(hyperspeed,direction),y+lengthdir_y(hyperspeed,direction),Wall){
        instance_destroy()
        exit
    }
}
while instance_exists(self) and dir < 1000
instance_destroy()

#define step
with hitme
{
	if "orbit" in self
	{
		if orbit >= 20
		{
			with instance_create(x,y,CustomProjectile)
			{
				damage = other.my_health
			}
		}
	}
}

#define line()
var dis = point_distance(x,y,xstart,ystart);
var ang = point_direction(x,y,xstart,ystart)+180;
var num = 20;
for var i = 0; i <= num; i++{
    with instance_create(xstart+lengthdir_x(dis/num * i,direction),ystart + lengthdir_y(dis/num * i,direction),BoltTrail){
        image_angle = other.direction
        image_yscale = other.trailscale * (i/num)
        image_xscale = dis/num
    }
}
xstart = x
ystart = y

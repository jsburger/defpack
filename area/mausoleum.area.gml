#define init
//global.floorb = sprite_add("grass.png",1,2,2)
//global.flor = sprite_add("dirt.png",1,0,0)
//global.florexplo = sprite_add("dirtexplo.png",1,1,1)
//global.wall = sprite_add("wall.png",1,0,-4)
//global.walltop = sprite_add("walltop.png",1,4,4)
game_restart()


#define cleanup

#define area_name
return "GUN MAUSOLEUM"

#define area_secret
return 1

#define area_sprite(q)
switch (q)
{
	case sprFloor1: 		 return sprFloor1;
	case sprFloor1B: 		 return sprFloor1B;
	case sprFloor1Explo: return sprFloor1Explo;
	case sprWall1Trans:  return mskNone;
	case sprWall1Bot: 	 return sprWall1Bot;
	case sprWall1Out: 	 return mskNone;
	case sprWall1Top: 	 return mskNone;
	case sprDebris1: 		 return sprDebris0;
}

#define area_mapdata
return [argument0, 9]

#define area_setup
with BackCont shadcol = merge_color(c_blue,c_black,.8)
GenCont.tip = "GUNS FROM ALL CORNERS#OF REALITY"
GenCont.goal = 1
background_color = make_color_rgb(68,163,24)
GenCont.safespawn = 0


#define area_make_floor

//X = wall
//* = spawn
var level ="
XXXXXXXXXXXXXXXXXXXX
X       ****       X
XXXXXXXXXXXXXXXXXXXX
";

var level2 = level;
level = string_split(level,"
")
height_ =floor((string_length(level2)-2)/string_length(level[1]))-1;
leng_ = string_length(level[1]);
var sp_ = 0//start counting spawn points
for (var col=1; col<height_; col++)
{
	for (var row=0; row<leng_; row++)
	{
		if string_char_at(level[col],row) == "X"//wall
		continue;
		else
		{
			var _x = row*32 + 10000;
			var _y = col*32 + 10000;
			var c = string_char_at(level[col],row);
			if c = "*"//spawnpoint
				with instance_create(_x,_y,CustomObject)
				{
					name = "spawnpoint"
					here = instance_nearest(x+16,y+16,Floor)
					ind_ = sp_//it will place this player here
					sp_++
				}
		}
	}
}

#define area_start
if fork(){
with instances_matching(CustomObject,"name","spawnpoint")
	with(player_find(ind_)){
		var _x = other.here.x+16;
		var _y = other.here.y+16;
		if fork(){
			repeat(20){
				if !instance_exists(self) exit
				x=_x
				y=_y
				with Ally instance_delete(id)
				wait 1
			}
			instance_delete(other.id)
			exit;
		}
	}
exit;
}


#define area_transit
if (lastarea != "mausoleum" && area == 1 && subarea = 1) {
	area = "mausoleum";
}

#define walldraw

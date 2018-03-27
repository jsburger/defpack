#define init
global.toot = sprite_add_weapon("sprites/sprHerald.png",-1,3)
global.bigrune = sprite_add("sprites/projectiles/sprHeraldRuneBig.png",1,12,24)
global.smallrunes = sprite_add("sprites/projectiles/sprHeraldRunesSmall.png",9,3,3)
global.smallrunesbloom = sprite_add("sprites/projectiles/sprHeraldRunesSmall.png",9,3,3)
global.runes = sprite_add("sprites/projectiles/sprHeraldRunes.png",9,4,4)
global.runesbloom = sprite_add("sprites/projectiles/sprHeraldRunesOutlined.png",9,5,5)
with instances_matching(CustomDraw,"name",mod_current) instance_destroy()
with script_bind_draw(vignette,-10){
	global.drawer = id
	persistent = 1
	name = mod_current
}



global.pink = make_color_rgb(252,59,82)

#define weapon_name
if instance_is(self,Player) || instance_is(self,PopupText) || instance_is(self,WepPickup) return `@(color:${merge_color(c_red,c_black,random_range(.2,.5))})THE HERALD`
return "THE HERALD"
#define weapon_type
return 4
#define weapon_cost
return 0
#define weapon_area
return 12
#define weapon_load
return 13
#define weapon_swap
return sndSwapCursed
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
if instance_is(self,Player){
	with create_abris(id,80,70,mod_current){
		accspeed = [0,0]
		alpha = 0
		runealpha = 0
		depth = -11
        runecolor = c_black
        runebloom = c_red
        beamcolor = c_red
        bigrunecolor = c_red
        vigncol1 = c_white
        vigncol2 = c_white
        linecolor = c_black
		check = other.specfiring ? 2 : 1;
		if check = 2 && (other.race = "venuz" || other.race = "skeleton") popped = 1;
		on_destroy = pop
		payload = script_ref_create(pop)
	}
}
else{
	sound_play_pitch(sndVenuz,1.3)
}


#define weapon_sprt
return global.toot
#define weapon_text
return "this is what ends it"

#define step
#define pop
player_set_show_cursor(index,index,1)


#define create_abris(Creator,startsize,endsize,weapon)
var a  = instance_create(0,0,CustomObject)
with a{
	//generic variables
	creator = Creator;
	name = "Herald Circle"
	team = -1
	on_step = abris_step
	on_draw = abris_draw
	index = creator.index
	phase = 0
	//accuarcy things
	accbase = startsize
	acc = accbase
	accmin = endsize
	accspeed = [1.2,3.5]
	//other things
	wep = weapon
	check = 0 //the button it checks, 0 is undecided, 1 is fire, 2 is specs, should only be 0 on creation, never step
	btn = [button_check(index,"fire"),button_check(index,"spec"),creator.swapmove]
	popped = 0
	dropped = 0
	type = weapon_get_type(wep)
	cost = weapon_get_cost(wep)
	auto = weapon_get_auto(wep)
	//visual things
	sides = 6
	subsides = 10
	runes = []
	subrunes= []
	siderunes = 5
	subangle = image_angle
	subsiderunes = 4
	for (var i = 0;i< sides; i++){
		array_push(runes,[])
		for var o = 0; o< siderunes; o++{
			array_push(runes[i],irandom(sprite_get_number(global.smallrunes)-1))
		}
	}
	for (var i = 0;i< subsides; i++){
		array_push(subrunes,[])
		for var o = 0; o< subsiderunes; o++{
			array_push(subrunes[i],irandom(sprite_get_number(global.smallrunes)-1))
		}
	}
	rotspeed = 1.2
	offspeed = 3
	lasercolour1 = c_red
	lasercolour = c_red
	lasercolour2 = c_maroon
	offset = random(359)
}
return a


//gerbai johjoh
#define abris_check()
switch creator.race{
	case "steroids":
		if creator.wep = wep var we = 1;
		if creator.bwep = wep var be = 1;
		if be && !we{
			check = 2
		}
		if we && !be{
			check = 1
		}
		if we && be{
			if btn[2]{
				check = 2
			}
			else check = 1
		}
		break
	case "venuz":
		if btn[1] {
			check = 2;
			++popped
		}
		else {check = 1}
		break
	case "skeleton":
		if btn[1]{
			check = 2
		}else{
			check = 1
		}
		break
	default:
		check = 1
		break
}

#define abris_step
if instance_exists(creator){
	if !dropped{
		alpha = min(alpha + .01*current_time_scale, 1)
		runealpha = min(runealpha + .0035*current_time_scale, 1)
		if runealpha = 1{
            runecolor = merge_color(runecolor,c_white,.03*current_time_scale)
            runebloom = merge_color(runebloom,c_white,.03*current_time_scale)
            bigrunecolor = merge_color(bigrunecolor,c_white,.01*current_time_scale)
        }
		image_angle += rotspeed * current_time_scale;
		subangle -= rotspeed * current_time_scale;
        if phase < 1{
            phase += .0025*current_time_scale
            vigncol1 = merge_color(c_white,c_black,other.alpha/2)
	        vigncol2 = merge_color(c_white,c_red,other.alpha)
        }
        if phase >= 1 and phase < 2{
            phase += .01*current_time_scale
            vigncol2 = merge_color(vigncol2,c_silver,.03*current_time_scale)
            vigncol1 = merge_color(vigncol1,c_black,.03*current_time_scale)
        }
        if phase < 1 rotspeed+=phase*current_time_scale*.025
		if check = 1 || popped{
			if popped{
				var pops = 1;
				with instances_matching(CustomObject,"name","Herald Circle") if creator = other.creator && id != other{
					if popped {pops+=1}
				}
				creator.reload = weapon_get_load(creator.wep) *(pops)
			}else{
				creator.reload = weapon_get_load(creator.wep)
			}
		}else{
			creator.breload = weapon_get_load(creator.bwep)
		}
	}
	if !button_check(creator.index,(check = 1?"fire":"spec")){
		if !collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) &&!dropped{
			dropped = 1
			explo_x = mouse_x[index]
			explo_y = mouse_y[index]
			if fork(){
				on_destroy = payload
				instance_destroy()
				exit
			}
		}
		else if instance_exists(self){
			if !dropped{
				if creator.infammo = 0{creator.ammo[type] += cost}
				instance_destroy()
			}
		};
	}
}
else{instance_destroy()}

#define abris_draw
if instance_exists(creator) && check{
	x = creator.x
	y = creator.y
	if button_check(creator.index, (check = 1? "fire":"spec")){
	    ritual_draw()
		if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0){
			alpha = max(alpha - .1*current_time_scale, 0)
		    runealpha = max(runealpha - .05*current_time_scale, 0)
		    var q = instance_create(x,y,CustomObject);
			with q{
				mask_index = sprBulletShell
				image_angle = other.creator.gunangle
				move_contact_solid(image_angle,game_width)
			}
			lightning_line(x,y,q.x,q.y)
			//draw_line_width_colour(x,y,q.x,q.y,1,lasercolour2,lasercolour2)
			with q instance_destroy()
		}
		var comp = (check = 1 ? creator.wep : creator.bwep);
		if popped {comp = wep}
		if wep != comp {instance_destroy()}
	}
}


#define vignette
draw_set_blend_mode_ext(1,3)
with instances_matching(CustomObject,"name","Herald Circle"){
	var _x = mouse_x[index], _y = mouse_y[index];
	with Player{
		draw_set_visible_all(0)
		draw_set_visible(index,1)
		draw_circle_color((_x + x)/2,(_y + y)/2,point_distance(x,y,_x,_y)+game_width/1.5,other.vigncol1,other.vigncol2,0)
		draw_set_visible_all(1)
	}
}
draw_set_blend_mode(bm_normal)

#define beam_draw(_x,_y,color,alpha)
var col = merge_color(color,c_black,1 - alpha),col2 = c_black;
draw_set_blend_mode(bm_add)
draw_line_width_color(_x, _y, _x, _y - random_range(24,20), 12, col,col2)
draw_line_width_color(_x, _y+1, _x, _y - random_range(34,44), 7, col,col2)
draw_set_blend_mode(bm_normal)


#define ritual_draw
var points = [];
var _x = mouse_x[index], _y = mouse_y[index];

var bloom = 1;
if phase > 1 bloom = 0

//big exterior runes
for (var i = 0; i< sides; i++){
    var ang = image_angle + i * 360/sides, ang2 = image_angle + (i + 1) * 360/sides;
	var x1 = _x + lengthdir_x(accbase,ang), y1 = _y + lengthdir_y(accbase, ang), x2 = _x + lengthdir_x(accbase, ang2), y2 = _y + lengthdir_y(accbase,ang2);
	runeline(x1,y1,x2,y2,runes[i],1,bloom)
	if phase > 1 rune_beam(_x,_y,x1,y1+5,x2,y2+5,c_white,(phase-1)*alpha,2)
    //if !(i mod 2) array_push(points,[x1,y1])
}

//triangle
/*draw_set_alpha(alpha)
for (var i = 0; i < array_length_1d(points); i++){
    var o = (i + 1) mod 3
    draw_line_width_color(points[i][0],points[i][1],points[o][0],points[o][1],2,linecolor,linecolor)
}
draw_set_alpha(1)
*/
//smaller interior runes
for (var i = 0; i< subsides; i++){
    var ang = subangle + i * 360/subsides, ang2 = subangle + (i + 1) * 360/subsides;
	var n = 1.3;
	var x1 = _x + lengthdir_x(accbase/n,ang), y1 = _y + lengthdir_y(accbase/n,ang), x2 = _x + lengthdir_x(accbase/n,ang2), y2 = _y + lengthdir_y(accbase/n,ang2);
	runeline(x1,y1,x2,y2,subrunes[i],0,bloom)
	if phase > 1 rune_beam(_x,_y,x1,y1+3,x2,y2+3,c_white,(phase-1)*alpha,1)

}

//beams
for (var i = 0; i< sides; i++){
    var ang = image_angle + i * 360/sides, ang2 = image_angle + (i + 1) * 360/sides;
	var x1 = _x + lengthdir_x(accbase - 3,ang), y1 = _y + lengthdir_y(accbase- 3, ang);
    beam_draw(x1,y1,beamcolor,alpha/2)
    if random(100) < 75*current_time_scale*alpha with instance_create(x1,y1,Dust){
        image_blend = c_red
        image_alpha = other.alpha
        depth = -12
        if other.phase > 1 depth+=2
        motion_set(90,4+random(3))
        if fork(){
            while instance_exists(self){
                image_blend = merge_color(image_blend,c_black,.1*current_time_scale)
                wait(0)
            }
            exit
        }
    }
    if random(100) < 1.5*current_time_scale*phase lightning(x1, y1,3,10,1,alpha, ang+180, 8)
}

//central rune
draw_sprite_ext(global.bigrune,0,_x,_y,1,1,0,bigrunecolor,runealpha)
draw_set_blend_mode(bm_add)
draw_circle_color(_x,_y,accbase,merge_color(c_black,bigrunecolor,.2*alpha),c_black,0)
repeat(4){
    draw_sprite_ext(global.bigrune,0,_x,_y,1+random_range(-.2,.2),1+random_range(-.2,.2),0,bigrunecolor,runealpha)
}

if phase > 1{
    draw_circle_color(_x,_y,accbase*1.2,merge_color(c_white,c_black,1/min(power(phase,10),accbase*1.5)),c_black,0)
    coolline(_x,_y+20,_x,_y-game_height,min(power(phase,10),accbase*1.5),c_white,c_black)
}
draw_set_blend_mode(bm_normal)




#define lightning_line(x1,y1,x2,y2)
var xs = x1, ys = y1, int = 0; 
var ang = point_direction(x1,y1,x2,y2);
var bdis = point_distance(x1,y1,x2,y2);
while point_distance(x1,y1,x2,y2) > 3 && ++int <= bdis{
    var dis = point_distance(x1,y1,x2,y2);
    ang += random_range(-40,40)*(dis/bdis);
    var _x = x1+lengthdir_x(min(dis,4+random(8)),ang);
    var _y = y1+lengthdir_y(min(dis,4+random(8)),ang);
    //if !random(6) lightning(_x, _y,2,7*dis/bdis,min(2,2* dis/bdis),1, ang, 3)
    ang -= angle_difference(ang,point_direction(_x,_y,x2,y2))*(1.1-dis/bdis);
    draw_line_width_color(x1,y1,_x,_y,1 +  dis/bdis,c_black,c_black);
    y1 = _y;
    x1 = _x;
}

#define runeline(x1,y1,x2,y2,runes,big,bloom)
var dir = point_direction(x1,y1,x2,y2), dist = point_distance(x1,y1,x2,y2);
var len = array_length_1d(runes);
var spr = big ? global.runes : global.smallrunes;
var bloomspr = big ? global.runesbloom : global.smallrunesbloom;
for (var i = 1; i < len; i++){
	if big && random(100) < 4*current_time_scale{
		var n = random(dist);
		draw_sprite_ext(sprLightningHit,1+random(2),x1 + lengthdir_x(n, dir), y1 + lengthdir_y(n, dir),1,1,dir,c_black,other.alpha)
	}
	draw_sprite_ext(spr,runes[i],x1 + lengthdir_x((dist/len) * i, dir), y1 + lengthdir_y((dist/len) * i, dir),1,1, dir, runecolor, alpha)
	if bloom = 1{
    	texture_set_interpolation(1)
    	draw_set_blend_mode(bm_add)
    	var r = random(.1);
    	draw_sprite_ext(bloomspr,runes[i],x1 + lengthdir_x((dist/len) * i, dir), y1 + lengthdir_y((dist/len) * i, dir),1.4+r,1.4+r, dir, runebloom, alpha/2)
    	draw_set_blend_mode(bm_normal)
    	texture_set_interpolation(0)
	}
}

#define rune_beam(xc,yc,x1,y1,x2,y2,color,alpha,pow)
var dir = point_direction(x1,y1,x2,y2), dist = point_distance(x1,y1,x2,y2);
x1 += lengthdir_x(dist/6,dir)
y1 += lengthdir_y(dist/6,dir)
x2 -= lengthdir_x(dist/6,dir)
y2 -= lengthdir_y(dist/6,dir)
var col = merge_color(color,c_black,1 - alpha),col2 = c_black;
var dir = point_direction(xc,yc,x1,y1);
var bdir = point_direction(xc,yc,x2,y2);
draw_set_blend_mode(bm_add)
draw_primitive_begin(pr_trianglestrip)
draw_vertex_color(x1,y1,col,1)
draw_vertex_color(x2,y2,col,1)
draw_vertex_color(x1+lengthdir_x(25,dir),y1-60+lengthdir_y(25,bdir),col2,1)
draw_vertex_color(x2+lengthdir_x(25,bdir),y2-60+lengthdir_y(25,bdir),col2,1)
draw_primitive_end()
/*for (var i = 1; i < len; i++){
    var xx = x1+ lengthdir_x((dist/len) * i, dir), yy = y1+ lengthdir_y((dist/len) * i,dir)
    var bdir = point_direction(xc,yc,xx,yy);
    for var o = 1; o<=pow; o++{
        draw_line_width_color(xx,yy,xx+lengthdir_x(15,bdir),yy+lengthdir_y(15,bdir)-60,7 + o+ pow - floor(pow),col,col2)
    }
}*/
/*
var xx = (x1+x2)/2, yy = (y1+y2)/2;
var bdir = point_direction(xc,yc,xx,yy);
draw_line_width_color(xx,yy,xx+lengthdir_x(30,bdir),yy+lengthdir_y(30,bdir),dist,col,col2)*/
draw_set_blend_mode(bm_normal)


#define lightning(_x,_y,fork,lines,thickness,alpha,dir,chance)
var x1 = _x, y1 = _y;
var ang1 = dir;
if alpha != -1 draw_set_alpha(alpha)
repeat(lines){
	var dist = random_range(3,10), ang2 = ang1 + random_range(-60,60);
	var x2 = x1+lengthdir_x(dist,ang2), y2 = y1+lengthdir_y(dist,ang2)
	draw_line_width_color(x1,y1,x2,y2,thickness,c_black,c_black)
	if fork if !irandom(chance) lightning(x1,y1,fork-1,lines-2,thickness,-1,dir+random_range(-60,60),chance)
	x1 = x2
	y1 = y2
	ang1 = ang2
	thickness -= thickness/lines
}
if alpha != -1 draw_set_alpha(1)

#define coolline(x1,y1,x2,y2,width,col,col2)
var __x = ((x1+x2)/2)
var __y = ((y1+y2)/2)
var dist = point_distance(x1,y1,x2,y2)
var dir = point_direction(x1,y1,x2,y2)
var lx = lengthdir_x(width/2,dir+90)
var ly = lengthdir_y(width/2,dir+90)
draw_line_width_color(__x,__y,__x+lx,__y+ly,dist,col,col2)
draw_line_width_color(__x,__y,__x-lx,__y-ly,dist,col,col2)




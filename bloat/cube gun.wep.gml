#define init

global.sprCube = sprite_add("defpack tools/sprSquare.png", 1, 0, 0)

//big thanks to abstractor for making the draw cube code, this weapon would not exist otherwise

// coming up is GM's default vertex buffer format, used by the default shader
vertex_format_begin();
vertex_format_add_position_3d(); // vertex 3d position
vertex_format_add_color(); // this is what image_blend and image_alpha go into
vertex_format_add_texcoord(); // UV coordinates
global.vertex_format = vertex_format_end();

global.bloom_vertex = make_cube(2, .2)
global.solid_vertex = make_cube(1, 1)



#define make_cube(size, alpha)

// this will be our mesh
var vbuf = vertex_create_buffer();
vertex_begin(vbuf, global.vertex_format);

global.ready = false;

wait(1);
// these functions only work one frame later
var spritetex = sprite_get_texture(global.sprCube, 0);
var texsize = [texture_get_width(spritetex), texture_get_height(spritetex)];
/* 
The point of texture_get_width/height is this:
Graphics cards only work with textures with width and height a power of 2.
Our sprite above is 48x8, so it will actually be assigned to a texture of 64x8.
So on the texture, the sprite only covers UV coordinates (0,0) to (0.75, 1).
The latter numbers are what texture_get_width/height return.
*/

// (x,y,z) of the four points of each of the faces of the cube
// all that follows is pretty ugly and could be done in much better way (e.g. as a trianglestrip), but we're only doing it once so eh
var quads = [-1, -1, -1, 1, -1, -1, -1, 1, -1, 1, 1, -1,
-1, -1, -1, -1, 1, -1, -1, -1, 1, -1, 1, 1,
-1, 1, -1, 1, 1, -1, -1, 1, 1, 1, 1, 1,
1, 1, -1, 1, -1, -1, 1, 1, 1, 1, -1, 1,
1, -1, -1, -1, -1, -1, 1, -1, 1, -1, -1, 1,
-1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1 
];
 // verts are top-left, top-right, bottom-left, bottom-right
var texcoords = [0, 0, 1, 0, 0, 1, 1, 1];

var quadindex = 0;
for(var face = 0; face < 6; face++) {
	var texcoordindex = 0;
	for(var v = 0; v < 3; v++) {
		vertex_position_3d(vbuf, quads[quadindex++] * size, quads[quadindex++] * size, quads[quadindex++] * size);
		vertex_color(vbuf, c_white, alpha);
		vertex_texcoord(vbuf, (texcoords[texcoordindex++]) * texsize[0], texcoords[texcoordindex++] * texsize[1]);
	}
	/*
	A quad consists of two triangles, so we have to go back and add the last two vertices of the first triangle to the second one.
	The order should really be reversed as well so that the vertices are always in counter-clockwise order, since this determines
	the facing of the triangle, but since back-face culling is disabled it doesn't matter in this case and we'll be lazy
	*/
	quadindex -= 6;
	texcoordindex -= 4;
	for(var v = 1; v < 4; v++) {
		vertex_position_3d(vbuf, quads[quadindex++] * size, quads[quadindex++] * size, quads[quadindex++] * size);
		vertex_color(vbuf, c_white, alpha);
		vertex_texcoord(vbuf, (texcoords[texcoordindex++]) * texsize[0], texcoords[texcoordindex++] * texsize[1]);
	}
}
vertex_end(vbuf);
vertex_freeze(vbuf); // the difficult part is over now, we have the mesh with the right texture coordinates
global.ready = true;
return vbuf

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_name
return "CUBE GUN"
#define weapon_type
return 5
#define weapon_cost
return 1
#define weapon_rads
return 8
#define weapon_area
return 24
#define weapon_load
return 10
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt
return sprLaserRifle
#define weapon_text
return "THE POWER OF THE UNKNOWN"
#define weapon_fire
sound_play_pitch(sndClick, 1.4)
if fork(){
    sound_play_pitch(sndStatueCharge, 1.3+random(.2))
    wait(1)
    sound_play_pitch(sndEliteInspectorFire, .7)
    exit
}
with instance_create(x, y, CustomObject){
    btn = other.specfiring ? "spec" : "fire"
    hand = other.specfiring and other.race = "steroids"
    creator = other
    team = other.team
    name = "Cube Charger"
    xrot = 45
    yrot = random(360)
    zrot = random(360)
    xspeed = 0
    depth = -2
    var t = 30;
    yspeed = random_range(1, t)
    zspeed = t - yspeed
    reload = -1
    size = 0
    ammobase = 3
    ammotime = ammobase
    index = other.index
    mask_index = mskPlayer
    linecount = irandom_range(3, 6)
    lines = [[random_range(2, 360/linecount), random_range(1, 5)]]
    for var i = 0; i < linecount; i++{
        array_push(lines, [lines[i][0] + random_range(3, 360/linecount), random_range(1, 5)])
    }

    on_step = cubestep
    on_end_step = cubeendstep
    on_draw = cubedraw
}

#define cubestep
if current_frame_active and size >= 1{
    if !irandom(4){
        repeat(irandom_range(1, 3)){
            with instance_create(x, y, Laser){
                image_angle = random(360)
                direction = image_angle
                alarm0 = 1
                team = other.team
                creator = other.creator
            }
        }
        sound_play_pitch(sndLaserUpg, 2)
    }
    if !irandom(3){
        var q = irandom(2)
        if q repeat(q){
            with instance_create(x, y, EnergyShank){
                team = other.team
                creator = other.creator
                motion_set(random(360), random(15) + 6)
                image_angle = direction
            }
            sound_play_pitch(sndEnergyScrewdriverUpg, 2)
        }
    }
    with instances_matching_ne(hitme, "team", team){
        if distance_to_point(other.x, other.y) < 60 and !collision_line(x, y, other.x, other.y, Wall, 0, 0){
            var _x = x, _y = y;
            with other{
                with instance_create(x, y, Laser){
                    image_angle = point_direction(x, y, _x, _y)
                    direction = image_angle
                    event_perform(ev_alarm, 0)
                    team = other.team
                    creator = other.creator
                }
                sound_play(sndLaser)
            }
            break
        }
    }
}



#define cubeendstep
if !instance_exists(creator) or !button_check(index, btn) or ((creator.ammo[weapon_type()] <= 0 or GameCont.rad < weapon_rads()) and creator.infammo = 0){
    instance_destroy()
    exit
}
if reload = -1{
    reload = (hand ? creator.breload : creator.reload) + creator.reloadspeed * current_time_scale
}
else{
    if hand creator.breload = max(reload, creator.breload)
    else creator.reload = max(reload, creator.reload)
}

size = min(size + current_time_scale/15, 1)

if size >= 1{
    ammotime -= current_time_scale
    if ammotime <= 0{
        ammotime = ammobase
        with creator if infammo = 0{
            ammo[weapon_type()] -= weapon_cost()
            GameCont.rad -= weapon_rads()
        }
    }
}

yrot += current_time_scale * yspeed
zrot += current_time_scale * zspeed
xrot += current_time_scale * xspeed

var l = 55 * size;
x = creator.x + lengthdir_x(l, creator.gunangle)
y = creator.y + lengthdir_y(l, creator.gunangle)


#define cubedraw
draw_cube(x, y, xrot, yrot, zrot, size, global.solid_vertex)
draw_set_blend_mode(bm_add)
var ang = 45*size;
var a = ang, l = 50*size;
draw_triangle_color(creator.x, creator.y, x + lengthdir_x(l, creator.gunangle + a), y + lengthdir_y(l, creator.gunangle + a), x + lengthdir_x(l, creator.gunangle - a), y + lengthdir_y(l, creator.gunangle - a), merge_color(c_lime, c_black, .7), c_black, c_black, 0)
var b = 0
repeat(linecount){
    a = ang * dsin((current_frame + lines[++b][0]) * 5)
    var a2 = ang * dsin((current_frame + lines[b][0] + lines[b][1]) * 5)
    draw_triangle_color(creator.x, creator.y, x + lengthdir_x(l, creator.gunangle + a), y + lengthdir_y(l, creator.gunangle + a), x + lengthdir_x(l, creator.gunangle + a2), y + lengthdir_y(l, creator.gunangle + a2), merge_color(choose(c_white,c_lime), c_black, .8), c_black, c_black, 0)
}
draw_cube(x, y, xrot, yrot, zrot, size, global.bloom_vertex)
draw_set_blend_mode(bm_normal)

#define draw_cube(x, y, xrot, yrot, zrot, scale, vbuf)

if !global.ready exit;

d3d_start();

var q = scale * 7
d3d_transform_set_scaling(q, q, q); // our cube is only 2 pixels wide, from -1 to 1, so we should scale it up
// try different numbers for x,y,z, for a squashed cube (or "hyperrectangle" or "rectangular cuboid" or "3-orthotope")

// now some example rotation
// note that in the default projection the z-axis is the one orthogonal to the screen, and you're looking in the positive z-direction
// (so vertices with negative z-values appear first, just like with depth)
d3d_transform_add_rotation_z(zrot);
d3d_transform_add_rotation_x(xrot);
d3d_transform_add_rotation_y(yrot);

// note that the order in which scaling, rotation, and translation is applied is important
// scaling and rotation are always applied relative to the origin (0,0,0)
// generally speaking you want to scale first, rotate next, translate last

d3d_transform_add_translation(x, y, 0);
vertex_submit(vbuf, pr_trianglelist, sprite_get_texture(global.sprCube, 0)); // draw

d3d_transform_set_identity(); // <-- important

d3d_end();



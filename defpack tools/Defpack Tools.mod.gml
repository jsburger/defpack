#define init
global.sprPsyBullet = sprite_add("Psy Bullet.png", 2, 8, 8);
global.mskPsyBullet = sprite_add("Psy Bullet Mask.png", 0, 7, 3);
global.sprPsyBulletHit = sprite_add("Psy Bullet Hit.png", 4, 8, 8);
global.sprPsyPellet = sprite_add("Psy Pellet.png", 2, 8, 8);
global.sprPsyPelletDisappear = sprite_add("Psy Pellet Disappear.png", 5, 8, 8);
global.sprMagPellet = sprite_add("Magnet Pellet.png", 2, 8, 8);
global.sprMagPelletDisappear = sprite_add("Magnet Pellet Dissapear.png", 5, 8, 8);
global.sprHeavyMagPellet = sprite_add("Heavy Magnet Pellet.png", 2, 9, 9);
global.sprHeavyMagPelletDisappear = sprite_add("Heavy Magnet Pellet Dissapear.png", 5, 9, 8);
global.sprLightningBullet = sprite_add("Lightning Bullet.png", 2, 8, 8);
global.sprLightningBulletUpg = sprite_add("sprThunderBulletUpg.png", 2, 8, 8);
global.sprLightningBulletHit = sprite_add("Lightning Bullet Hit.png", 4, 8, 8);
global.sprToxicBullet = sprite_add("Toxic Bullet.png", 2, 8, 8);
global.sprToxicBulletHit = sprite_add("Toxic Bullet Hit.png", 4, 8, 8);
global.sprFireBullet = sprite_add("Fire Bullet.png", 2, 8, 8);
global.sprFireBulletHit = sprite_add("Fire Bullet Hit.png", 4, 8, 8);
global.sprDarkBullet = sprite_add("Dark Bullet.png", 2, 8, 8);
global.mskDarkBullet = sprite_add("Dark Bullet Mask.png", 0, 2.5, 4.5);
global.sprDarkBulletHit = sprite_add("Dark Bullet Hit.png", 4, 8, 8);
global.sprLightBullet = sprite_add("Light Bullet.png", 2, 8, 8);
global.sprLightBulletHit = sprite_add("Light Bullet Hit.png", 4, 8, 8);

global.sprPlasmite    = sprite_add("sprPlasmite.png",0,3,3);
global.sprPlasmiteUpg = sprite_add("sprPlasmiteUpg.png",0,3,3);

global.sprRocklet      = sprite_add("sprRocklet.png",2,1,6);
global.sprRockletFlame = sprite_add("sprRockletFlame.png",0,8,3);

global.sprSonicExplosion = sprite_add("Soundwave_strip8.png",8,61,59);
global.mskSonicExplosion = sprite_add("mskSonicExplosion_strip9.png",9,32,32);

global.sprGenShell      = sprite_add("sprGenShell.png",7, 2, 2);
global.sprGenShellLong  = sprite_add("sprGenShellL.png",7, 2, 3);
global.sprGenShellBig   = sprite_add("sprGenShellXL.png",7, 3, 3);
global.stripes = sprite_add("BIGstripes.png",1,1,1);

global.sprSquare = sprite_add("sprSquare.png", 0, 7, 7);
global.mskSquare = sprite_add("mskSquare.png",0,5,5);
global.sprSuperSquare = sprite_add("sprSuperSquare.png", 0, 14, 14);
global.mskSuperSquare = sprite_add("mskSuperSquare.png",0,10,10);

global.sprTriangle = sprite_add("sprTriangle.png",0,7,7);

global.sprLaserFlakBullet = sprite_add("sprLaserFlak.png",2, 7, 7);

global.sprMiniSpikeball = sprite_add("sprMiniSpikeball.png",0, 6, 5);
global.mskMiniSpikeball = sprite_add("mskMiniSpikeball.png",0, 6, 5);
global.sprSpikeball     = sprite_add("sprSpikeball.png",0, 11, 9);
global.mskSpikeball     = sprite_add("mskSpikeball.png",0, 11, 9);
global.sprHeavySpikeball  = sprite_add("sprHeavySpikeball.png",0, 15, 15);
global.mskHeavySpikeball  = sprite_add("mskHeavySpikeball.png",0, 15, 15);

global.sprAim          = sprite_add("sprAim.png",0,10,10);
global.sprCursorCentre = sprite_add("sprCursorCentre.png",0,1,1);

global.sprBouncerDisc = sprite_add("sprBouncerDisc.png",2,6,6)
global.sprStickyDisc  = sprite_add("sprStickyDisc.png",2,7,6)
global.sprMegaDisc       = sprite_add("sprMegaDisc.png",2,12,12);
global.sprMegaDiscDie    = sprite_add("sprMegaDiscDie.png",6,12,12);
global.sprMegaDiscTrail  = sprite_add("sprMegaDiscTrail.png",3,12,12);
global.sprMegaDiscBounce = sprite_add("sprMegaDiscBounce.png",4,12,12);

global.sprCharge = sprite_add("sprHoldIcon.png",0,5,5)

global.SAKmode = 0
//mod_script_call("mod","defpermissions","permission_register","mod",mod_current,"SAKmode","SAK Mode")

global.sprShard      = sprite_add_weapon("sprShard.png",0,3);
global.sprGlassShard = sprite_add("sprGlassShard.png",5,4,4)

global.sprKillslash   = sprite_add("sprKillslash.png",8,16,16);

global.traildrawer = -4
global.trailsf = surface_create(game_width*4,game_height*4)
surface_set_target(global.trailsf)
draw_clear_alpha(c_white,0)
surface_reset_target()

vertex_format_begin()
vertex_format_add_position()
global.lightningformat = vertex_format_end()


//thanks yokin
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define chat_command(cmd,arg,ind)
if cmd = "sakcity"{
    global.SAKmode = !global.SAKmode
    if global.SAKmode{
        trace_color("You just took a one way ticket to SAK CITY, BABY", c_gray)
        trace_color("(Weapons become randomly generated shotguns)", c_gray)
    }
    else{
        trace_color("Evidently the ticket wasn't one way.", c_gray)
        trace_color("(Weapon drops are restored)", c_gray)
    }
    return 1
}

#define cleanup
with global.traildrawer instance_destroy()

#define draw_shadows()
with instances_matching(CustomProjectile,"name","volley arrow")
    draw_sprite_ext(shd16,0,x,y,clamp(1/z*10,0,1),clamp(1/z*10,0,1),0,c_white,1)

#define draw_dark()
with Player{
    var level = 0,blevel = 0, lv;
    if is_object(wep) && wep.wep = "crystal torch"{
        level = min(ceil(wep.cursecharge/10),5)
    }
    if is_object(bwep) && bwep.wep = "crystal torch"{
        blevel = min(ceil(bwep.cursecharge/10),5)
    }
    lv = max(blevel,level)
    if lv > 0{
        draw_circle_color(x,y,180 + 20*lv + random(5), c_gray,c_gray,0)
        draw_circle_color(x,y,70  + 20*lv + random(5), c_black,c_black,0)
    }
}
with instances_matching(CustomProjectile,"name","Lightning Bolt"){
	draw_circle_color(x,y,550 + random(10), c_gray,c_gray,0)
	draw_circle_color(x,y,250 + random(10), c_black,c_black,0)
}
with instances_matching([Bolt,BoltStick],"name","marker bolt"){
	draw_circle_color(x+lengthdir_x(sprite_width/2+2,direction),y+lengthdir_y(sprite_width/2+2,direction),35 + random(3), c_gray,c_gray,0)
	draw_circle_color(x+lengthdir_x(sprite_width/2+2,direction),y+lengthdir_y(sprite_width/2+2,direction),20 + random(3), c_black,c_black,0)
}

#define draw_gui
with instances_matching(CustomObject,"name","sniper charge","sniper pest charge","sniper fire charge","sniper thunder charge","sniper psy charge", "sniper bouncer charge")
{
    if !instance_exists(creator){draw_set_visible_all(1);instance_destroy();exit}
    draw_set_visible_all(0)
    draw_set_visible(creator.index,1)
    var _pc     = player_get_color(creator.index);
    if holdtime >= 60 {var _m = 5}else{var _m = 3}
    if current_frame mod _m <= current_time_scale && _m = 3{sound_play_pitch(sndCursedReminder,5)}
    if charged = 0{if (current_frame mod _m) <= current_time_scale {if _pc != c_white {_pc = c_white}else{_pc = player_get_color(creator.index)}}}
    var _offset = charge;
    var _vpf    = 3;
    var _mx     = x - view_xview[creator.index];
    var _my     = y - view_yview[creator.index];
    draw_sprite_ext(global.sprAim,0,_mx-_vpf+_offset-100,_my-_vpf+_offset-100,1,1,0  ,_pc,.1+.9*(charge/100))
    draw_sprite_ext(global.sprAim,0,_mx-_vpf+_offset-100,_my+_vpf-_offset+100,1,1,90 ,_pc,.1+.9*(charge/100))
    draw_sprite_ext(global.sprAim,0,_mx+_vpf-_offset+100,_my+_vpf-_offset+100,1,1,180,_pc,.1+.9*(charge/100))
    draw_sprite_ext(global.sprAim,0,_mx+_vpf-_offset+100,_my-_vpf+_offset-100,1,1,270,_pc,.1+.9*(charge/100))
    draw_sprite_ext(global.sprCursorCentre,0,_mx,_my,1,1,0,_pc,1)
}
draw_set_visible_all(1)

#define draw_pause
mod_variable_set("weapon", "stopwatch", "pausetime", 1)

#define instances_in(left,top,right,bottom,obj)
return instances_matching_gt(instances_matching_lt(instances_matching_gt(instances_matching_lt(obj,"y",bottom),"y",top),"x",right),"x",left)

#define draw_trails
if array_length_1d(instances_matching(CustomProjectile,"name","Rocklet","big rocklet","huge rocklet")){
    surface_set_target(global.trailsf)
    draw_clear_alpha(0,0)
    draw_set_blend_mode(bm_normal)
    draw_set_alpha(1)
    draw_set_color_write_enable(1,1,1,1)

    with instances_in(view_xview_nonsync,view_yview_nonsync,view_xview_nonsync+game_width,view_yview_nonsync+game_height,instances_matching(CustomProjectile,"name","big rocklet","huge rocklet")){
         var _x = (x - view_xview_nonsync)*4, _y = (y - view_yview_nonsync)*4, _xp = (lerp(x,xprevious,4*speed/maxspeed) - view_xview_nonsync)*4, _yp = (lerp(y,yprevious,4*speed/maxspeed) - view_yview_nonsync)*4;
        var len = ((random_nonsync(speed)/maxspeed))*16;
        var xoff = lengthdir_x(len,direction + 90), yoff = lengthdir_y(len,direction + 90);
        draw_triangle_color(_x + xoff, _y + yoff, _x - xoff, _y - yoff, _xp, _yp, c_white, c_white, c_black, 0)
    }
    with instances_in(view_xview_nonsync,view_yview_nonsync,view_xview_nonsync+game_width,view_yview_nonsync+game_height,instances_matching(CustomProjectile,"name","Rocklet")){
        var _x = (x - view_xview_nonsync)*4, _y = (y - view_yview_nonsync)*4, _xp = (lerp(x,xprevious,4*speed/maxspeed) - view_xview_nonsync)*4, _yp = (lerp(y,yprevious,4*speed/maxspeed) - view_yview_nonsync)*4;
        var len = (random_nonsync(speed)/maxspeed)*8;
        var xoff = lengthdir_x(len,direction + 90), yoff = lengthdir_y(len,direction + 90);
        draw_triangle_color(_x + xoff, _y + yoff, _x - xoff, _y - yoff, _xp, _yp, c_white, c_white, c_black, 0)

    }
    surface_reset_target()
    draw_set_blend_mode(bm_add)
    draw_surface_ext(global.trailsf,view_xview_nonsync,view_yview_nonsync,0.25,0.25,0,c_white,1)
    draw_set_blend_mode(bm_normal)

}

#define step
with WepPickup if wep = 0 instance_destroy()

with instances_matching(WepPickup,"chargecheck",null){
    chargecheck = 1
    var w = is_object(wep) ? wep.wep : wep
    if is_string(w) and (mod_script_exists("weapon", w, "weapon_chrg") || string_count("ABRIS ",  string_upper(weapon_get_name(w)))){
        name += ` @0(${global.sprCharge}:0) `
    }
}

if !surface_exists(global.trailsf){
    global.trailsf = surface_create(game_width*4,game_height*4)
    surface_set_target(global.trailsf)
    draw_clear_alpha(c_black,0)
    surface_reset_target()
}
if !instance_exists(global.traildrawer){
    with script_bind_draw(draw_trails,1){
        global.traildrawer = id
        persistent = 1
    }
}
if instance_exists(GenCont){
    surface_set_target(global.trailsf)
    draw_clear_alpha(c_black,0)
    surface_reset_target()
}
with instances_matching(WepPickup,"wep",0){instance_delete(self)}
if global.SAKmode &&  mod_exists("weapon","sak"){
    with instances_matching(instances_matching(WepPickup,"roll",1),"saked",undefined){
        saked = 1
        wep = mod_script_call_nc("weapon","sak","make_gun_random")
    }
}

with instances_matching([Explosion,SmallExplosion,GreenExplosion,PopoExplosion],"hitid",-1){
    hitid = [sprite_index,string_replace(string_upper(object_get_name(object_index)),"EXPLOSION"," EXPLOSION")]
}

//drop tables
with instances_matching_le([Inspector,Shielder,EliteGrunt,EliteInspector,EliteShielder],"my_health",0) if !irandom(97) with instance_create(x,y,WepPickup){wep = "donut box"}

with SodaMachine{
	if fork(){
	    var _x = x, _y = y
	    wait(0)
	    if !instance_exists(self) && instance_exists(Wall){
    		with instance_create(_x,_y,WepPickup){
    		    if !irandom(99) wep = "soda popper"
    		    else{
        		    var a = ["lightning blue lifting drink(tm)","extra double triple coffee","expresso","saltshake","munitions mist","vinegar","guardian juice"]
        			if skill_get(14) > 0
        			    array_push(a, "sunset mayo")
        			if array_length(instances_matching(Player, "notoxic", 0))
        			    array_push(a, "frog milk")
                    wep = a[irandom(array_length(a)-1)]
                }
    		}
    	}
    	exit
	}
}

#define instance_nearest_matching_ne(_x,_y,obj,varname,value)
var num = instance_number(obj),
    man = instance_nearest(_x,_y,obj),
    mans = [],
    n = 0,
    found = -4;
if instance_exists(obj){
    while ++n <= num && variable_instance_get(man,varname) = value || (instance_is(man,prop) && !instance_is(man,Generator)){
        man.x += 10000
        array_push(mans,man)
        man = instance_nearest(_x,_y,obj)
    }
    if variable_instance_get(man,varname) != value && (!instance_is(man,prop) || instance_is(man,Generator)) found = man
    with mans x-= 10000
}
return found


#define bullet_hit
if name = "Psy Bullet"{with other{motion_add(point_direction(x,y,other.x,other.y),5)}}
projectile_hit(other, damage, force, direction);
if instance_exists(creator) if recycle_amount != 0 && irandom(9) <= 5 && skill_get(16){
	creator.ammo[1]+=recycle_amount
	if creator.ammo[1] > creator.typ_amax[1] {creator.ammo[1] = creator.typ_amax[1]}
	sound_play_pitchvol(sndRecGlandProc, 1, 7)
}
if instance_exists(creator) if recycle_amount != 0 && skill_get("recycleglandx10"){
	creator.ammo[1]+= 10*recycle_amount
	if creator.ammo[1] > creator.typ_amax[1] {creator.ammo[1] = creator.typ_amax[1]}
	sound_play_pitchvol(sndRecGlandProc, 1, 7)
}
instance_destroy()

#define bullet_anim
image_index = 1
image_speed = 0

#define shell_hit
projectile_hit(other, (current_frame < fallofftime? damage : (damage - falloff)), force, direction);

#define chance(percentage)
return random(100) <= percentage*current_time_scale

#define bullet_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);

#define bullet_wall
sound_play_hit(sndHitWall,.2)
instance_destroy()

#define create_psy_bullet(_x,_y)
var a = instance_create(_x, _y, CustomProjectile)
with (a) {
	name = "Psy Bullet"
	pattern = false
	sprite_index = global.sprPsyBullet
	typ = 2
	damage = 4
	recycle_amount = 1
	force = -10
	image_speed = 1
	image_angle = direction
	mask_index = global.mskPsyBullet
	timer = irandom(6)+4
    range = 240
	on_step = script_ref_create(psy_step)
	on_destroy = script_ref_create(psy_destroy)
	on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(bullet_draw)
	on_anim = script_ref_create(bullet_anim)
	on_wall = script_ref_create(bullet_wall)
}
return a;

#define psy_step
if timer > 0{
	timer -= current_time_scale
}
if timer <= 0{
	var closeboy = instance_nearest_matching_ne(x,y,hitme,"team",team)
	if instance_exists(closeboy) && distance_to_object(closeboy) < 160 && collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0{
		var dir, spd;

		dir = point_direction(x, y, closeboy.x, closeboy.y);
		spd = speed * 5 * current_time_scale

        var _f = .3;
		direction -= clamp(angle_difference(image_angle, dir) * _f * current_time_scale, -spd, spd); //Smoothly rotate to aim position.
		image_angle = direction
	}
}

#define psy_destroy
with instance_create(x,y,BulletHit){
	sprite_index = global.sprPsyBulletHit
	image_angle = other.direction + 180
}
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_hit(sndHitWall,.2)}


#define create_psy_shell(_x,_y)
var b = instance_create(_x, _y, CustomProjectile)
with (b){
	name = "Psy Shell"
	sprite_index = global.sprPsyPellet
	friction = .6
	image_angle = direction
	mask_index = mskBullet2
	wallbounce = skill_get(15) * 5 + (skill_get("shotgunshouldersx10")*50)
	force = 4
	recycle_amount = 0
	image_speed = 1
	damage = 4
	falloff = 1
	fallofftime = current_frame + 2
	timer = 5 + irandom(4)
	on_hit = script_ref_create(psy_shell_hit)
	on_draw = script_ref_create(psy_shell_draw)
	on_step = script_ref_create(psy_shell_step)
	on_wall = script_ref_create(psy_shell_wall)
	on_destroy = script_ref_create(psy_shell_destroy)
	on_anim = script_ref_create(bullet_anim)
}
return b;

#define psy_shell_hit
shell_hit()
instance_destroy()

#define psy_shell_step
if timer > 0{
	timer -= current_time_scale
}
if timer <= 0{
	var closeboy = instance_nearest_matching_ne(x,y,hitme,"team",team)
	if instance_exists(closeboy) && distance_to_object(closeboy) < 200 && collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0{
		motion_add(point_direction(x,y,closeboy.x,closeboy.y),current_time_scale * (1 + skill_get(15)))
		motion_add(direction,-.03  * (1 + skill_get(15)))
		image_angle = direction
	}
}
if speed < 3{
	instance_destroy()
}

#define psy_shell_wall
fallofftime = current_frame + 2
move_bounce_solid(true)
speed /= 1.25
speed = min(speed+wallbounce,14)
wallbounce /= 1.05
instance_create(x,y,Dust)
sound_play_hit(sndShotgunHitWall,.2)
image_angle = direction

#define psy_shell_destroy
with instance_create(x,y,BulletHit){
	sprite_index = global.sprPsyPelletDisappear
	speed = other.speed/5
	direction = other.direction
	image_angle = direction
}

#define psy_shell_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.2);
draw_set_blend_mode(bm_normal);

#define create_heavy_split_shell(_x,_y)
with create_split_shell(_x,_y){
    sprite_index = global.sprHeavyMagPellet
    force = 5
    ammo = 3
    damage = 7
    falloff = 2
    return id
}

#define create_split_shell(_x,_y)
var c = instance_create(_x, _y, CustomProjectile)
with (c){
	name = "Split Shell"
	sprite_index = global.sprMagPellet
	friction = .55
	mask_index = mskBullet2
	wallbounce = skill_get(15) * 4 + (skill_get("shotgunshouldersx10")*40)
	force = 4
	ammo = 2
	lasthit = -4
	typ = 1
	recycle_amount = 0
	image_speed = 1
	damage = 3
	falloff = 1
	fallofftime = current_frame + 2
	on_hit = script_ref_create(mag_hit)
	on_draw = script_ref_create(mag_shell_draw)
	on_step = script_ref_create(mag_shell_step)
	on_destroy = script_ref_create(mag_shell_destroy)
	on_anim = script_ref_create(bullet_anim)
	on_wall = script_ref_create(split_wall)
}
return c;


#define split_split
ammo--
image_xscale *= .8
image_yscale *= .8
if ammo = 2{
    sprite_index = global.sprMagPellet
    image_xscale = 1
    image_yscale = 1
}
var ang = random_range(10, 30) * choose(-1,1)
var a = ammo >= 3 ? "create_heavy_split_shell" : "create_split_shell"
with mod_script_call("mod","defpack tools", a,x,y){
	creator = other.creator
	image_xscale = other.image_xscale
	image_yscale = other.image_yscale
	team = other.team
	ammo = other.ammo
	motion_set(other.direction + ang,random_range(12,14))
	image_angle = direction
}
direction -= ang
image_angle = direction

#define split_wall
fallofftime = current_frame + 2
move_bounce_solid(true)
speed *= .66
speed = min(speed+wallbounce,14)
wallbounce /= 1.05
instance_create(x,y,Dust)
sound_play_hit(sndShotgunHitWall,.2)
image_angle = direction
if ammo{
    split_split()
}
#define mag_hit
if lasthit != other.id || projectile_canhit_melee(other)
{
    speed *= .66
    lasthit = other.id
	shell_hit();
	if ammo > 0{
		split_split()
	}
	else instance_destroy()
}

#define mag_shell_step
if speed < 2{instance_destroy()}

#define mag_shell_destroy
with instance_create(x,y,BulletHit){
	image_xscale = other.image_xscale
	image_yscale = image_xscale
	sprite_index = global.sprMagPelletDisappear
	if other.sprite_index = global.sprHeavyMagPellet {sprite_index = global.sprHeavyMagPelletDisappear}
	speed = other.speed/5
	direction = other.direction
	image_angle = direction
}

#define mag_shell_draw
draw_self()
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.2);
draw_set_blend_mode(bm_normal);

#define create_thunder_bullet(_x,_y)
return create_lightning_bullet(_x,_y)

#define create_lightning_bullet(_x,_y)
var c =instance_create(_x, _y, CustomProjectile)
with (c){
	name = "Lightning Bullet"
	pattern = false
	if skill_get(17)=0{sprite_index = global.sprLightningBullet}else{sprite_index=global.sprLightningBulletUpg}
	typ = 2
	mask_index = mskBullet1
	force = 7
	damage = 2
	recycle_amount = 1
	image_speed = 1
	image_angle = direction
	on_step = script_ref_create(thunder_step)
	on_destroy = script_ref_create(thunder_destroy)
	on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(bullet_draw)
	on_anim = script_ref_create(bullet_anim)
	on_wall = script_ref_create(bullet_wall)
}
return c;

#define thunder_step
if chance(5){
	with instance_create(x,y,Lightning){
      	image_angle = random(360)
      	team = other.team
		creator = other.creator
      	ammo = choose(1,2)
		alarm0 = 1
		visible = 0
      	with instance_create(x,y,LightningSpawn)
        {
      	   image_angle = other.image_angle
        }
    }
}

#define thunder_destroy
with instance_create(x,y,Lightning){
	image_angle = random(360)
	creator = other.creator
	team = other.team
	ammo = 4
	alarm0 = 1
	visible = 0
	with instance_create(x,y,LightningSpawn)
	{
	   image_angle = other.image_angle
	}
}
with instance_create(x,y,BulletHit){
	direction = other.direction
	sprite_index = global.sprLightningBulletHit
}

#define create_pest_bullet(x,y)
return create_toxic_bullet(x,y)

#define create_toxic_bullet(_x,_y)
var d = instance_create(_x, _y, CustomProjectile)
with (d) {
	name = "Toxic Bullet"
	pattern = false
	sprite_index = global.sprToxicBullet
	typ = 1
	force = 8
	mask_index = mskBullet1
	damage = 2
	recycle_amount = 1
	image_speed = 1
	image_angle = direction
	//on_step = script_ref_create(bullet_step)
	on_destroy = script_ref_create(toxic_destroy)
	on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(bullet_draw)
	on_wall = script_ref_create(bullet_wall)
	on_anim = script_ref_create(bullet_anim)
}
return d;

#define toxic_destroy
repeat(2){
	instance_create(x,y,ToxicGas)
}
with instance_create(x,y,BulletHit){
	sprite_index = global.sprToxicBulletHit
	direction = other.direction
}

#define create_flame_bullet(x,y)
return create_fire_bullet(x,y)

#define create_fire_bullet(_x,_y)
var e = instance_create(_x, _y, CustomProjectile)
with (e){
	name = "Fire Bullet"
	pattern = false
	sprite_index = global.sprFireBullet
	typ = 1
	force = -5
	mask_index = mskBullet1
	damage = 3
	recycle_amount = 1
	image_speed = 1
	on_step = script_ref_create(fire_step)
	on_destroy = script_ref_create(fire_destroy)
	on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(bullet_draw)
	on_anim = script_ref_create(bullet_anim)
	on_wall = script_ref_create(bullet_wall)
}
return e;

#define fire_step
if chance(8){
	with instance_create(x,y,Flame){
		team = other.team
		creator = other.creator
	}
}

#define fire_destroy
create_miniexplosion(x,y)
with instance_create(x,y,BulletHit){
	sprite_index = global.sprFireBulletHit
    direction = other.direction
    image_index = 1
}

#define create_dark_bullet(_x,_y)
var f = instance_create(_x, _y, CustomSlash)
with (f){
	name = "Dark Bullet"
	pattern = false
	sprite_index = global.sprDarkBullet
	typ = 0
	mask_index =global.mskDarkBullet
	damage = 8
	force = 7
	offset = random(360)
	ringang = random(360)
	recycle_amount = 1
	image_speed = 1
	image_angle = direction
	//on_step = script_ref_create(dark_step)
	on_projectile = script_ref_create(dark_proj)
	on_destroy = script_ref_create(dark_destroy)
    on_wall = script_ref_create(bullet_wall)
    on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(bullet_draw)
	on_anim = script_ref_create(bullet_anim)
}
return f;

#define dark_proj
var t = team;
with other{
	if typ >= 1 {
		var ringang = random(360);
		with create_sonic_explosion(x,y){
			var scalefac = random_range(0.26,0.3);
			image_xscale = scalefac
			image_yscale = scalefac
			damage = 2
			shake = 2
			image_speed = 0.85
			image_blend = c_black
			team = t
			candeflect = 0
		}
		repeat(3){
			with create_sonic_explosion(other.x+lengthdir_x(other.speed*1.3,other.offset+ringang),other.y+lengthdir_y(other.speed*1.3,other.offset+ringang)){
				var scalefac = random_range(0.15,0.2);
				image_xscale = scalefac
				image_yscale = scalefac
				damage = 2
				shake = 2
				image_speed = 1
				image_blend = c_black
				team = t
				candeflect = 0
			}
			ringang += 120
		}
		instance_destroy()
	}
}

#define dark_destroy
with instance_create(x,y,BulletHit){
	sprite_index = global.sprDarkBulletHit
	image_angle = other.direction + 180
}
with create_sonic_explosion(x,y){
	team = other.team
	var scalefac = random_range(0.37,0.4);
	image_xscale = scalefac
	image_yscale = scalefac
	candeflect = 0
	shake = 5
	damage = 8
	image_speed = 0.8
	image_blend = c_black
}

#define create_light_bullet(_x,_y)
var g = instance_create(_x, _y, CustomProjectile)
with (g){
	name = "Light Bullet"
	pattern = false
	sprite_index = global.sprLightBullet
	typ = 0
	mask_index = mskBullet1
	force = 2
	damage = 3
	recycle_amount = 1
	lasthit = -4
	pierces = 6
	image_speed = 1
	image_angle = direction
	//on_step = script_ref_create(light_step)
	on_destroy = script_ref_create(light_destroy)
	on_hit = script_ref_create(light_hit)
	on_draw = script_ref_create(bullet_draw)
	on_wall = script_ref_create(bullet_wall)
	on_anim = script_ref_create(bullet_anim)
}
return g;

#define light_hit
if other != lasthit{
	projectile_hit(other, damage, force, direction);
	lasthit = other
	pierces -= 1
	if irandom(5) = 5 && skill_get(16){
    	creator.ammo[1]+=recycle_amount
    	if creator.ammo[1] > creator.typ_amax[1] {creator.ammo[1] = creator.typ_amax[1]}
    	sound_play_pitchvol(sndRecGlandProc, 1, 7)
    }
    if !irandom(1) && skill_get("recycleglandx10"){
    	creator.ammo[1]+=10*recycle_amount
    	if creator.ammo[1] > creator.typ_amax[1] {creator.ammo[1] = creator.typ_amax[1]}
    	sound_play_pitchvol(sndRecGlandProc, 1, 7)
    }
    if pierces = 0{
    	instance_destroy()
    }
}
#define light_destroy
with instance_create(x,y,BulletHit){
	sprite_index = global.sprLightBulletHit
}


#define create_sonic_explosion(_x,_y)
var a = instance_create(_x,_y,CustomSlash)
with(a){
	name = "Sonic Explosion"
	sprite_index = global.sprSonicExplosion
	mask_index = global.mskSonicExplosion
	team = 0
	typ = 0
	damage = 5
	candeflect = 1
	image_speed = .7
	force = 20
	shake = 10
	if GameCont.area = 101{synstep = 0}else{synstep = 1} //oasis synergy
	hitid = [sprite_index,"Sonic Explosion"]
	on_step = script_ref_create(sonic_step)
	on_projectile = script_ref_create(sonic_projectile)
	on_grenade = script_ref_create(sonic_grenade)
	on_hit = script_ref_create(sonic_hit)
	on_wall = script_ref_create(nothing)
	on_anim = script_ref_create(sonic_anim)
}
return a
#define nothing

#define sonic_anim
instance_destroy()

#define sonic_step
if synstep = 0
{
	synstep = 1
		image_xscale *= 1.25
		image_yscale *= 1.25
		image_speed  *= .8
}
if shake {view_shake_at(x,y,shake);shake = 0}

#define sonic_projectile
with other{
	if typ = 1 && other.candeflect{
		team = other.team
		direction = point_direction(other.x,other.y,x,y)
		image_angle = direction
	}
	if typ = 2 || typ = 3 || (typ = 1 && !other.candeflect){
		instance_destroy()
	}
}

#define sonic_grenade
with other{
	direction = point_direction(other.x,other.y,x,y)
	image_angle = direction
}

#define sonic_hit
if projectile_canhit_melee(other){
	projectile_hit(other,damage,force,point_direction(x,y,other.x,other.y))
}

//ok i guess im stealing stuff from gunlocker too but its a good idea alright
#define shell_yeah(_angle, _spread, _speed, _color)
with instance_create(x, y, Shell){
	image_speed = 0
	motion_add(other.gunangle + (other.right * _angle) + random_range(-_spread, _spread), _speed);
	sprite_index = global.sprGenShell
	switch _color
	{
		case c_yellow: image_index = 0;break
		case c_red   : image_index = 1;break
		case c_purple: image_index = 2;break
		case c_green : image_index = 3;break
		case c_navy  : image_index = 4;break
		case c_white : image_index = 5;break
		case c_black : image_index = 6;break
	}
}

//im not feeling like rewriting every weapon using shell_yeah
#define shell_yeah_big(_angle, _spread, _speed, _color)
with instance_create(x, y, Shell){
	image_speed = 0
	motion_add(other.gunangle + (other.right * _angle) + random_range(-_spread, _spread), _speed);
	sprite_index = global.sprGenShellBig
	switch _color
	{
		case c_yellow: image_index = 0;break
		case c_red   : image_index = 1;break
		case c_purple: image_index = 2;break
		case c_green : image_index = 3;break
		case c_navy  : image_index = 4;break
		case c_white : image_index = 5;break
		case c_black : image_index = 6;break
	}
}

#define shell_yeah_long(_angle, _spread, _speed, _color)
with instance_create(x, y, Shell){
	image_speed = 0
	motion_add(other.gunangle + (other.right * _angle) + random_range(-_spread, _spread), _speed);
	sprite_index = global.sprGenShellLong
	switch _color
	{
		case c_yellow: image_index = 0;break
		case c_red   : image_index = 1;break
		case c_purple: image_index = 2;break
		case c_green : image_index = 3;break
		case c_navy  : image_index = 4;break
		case c_white : image_index = 5;break
		case c_black : image_index = 6;break
	}
}

#define draw_circle_width_colour(precision,radius,width,offset,xcenter,ycenter,col,alpha)
var int = 360/precision;
draw_set_alpha(alpha);
draw_set_color(col);
for (var i = 0; i < 360; i+=int){
	draw_line_width(xcenter+lengthdir_x(radius,offset+i),ycenter+lengthdir_y(radius,offset+i),xcenter+lengthdir_x(radius,offset+i+int),ycenter+lengthdir_y(radius,offset+i+int),width)
}
draw_set_color(c_white)
draw_set_alpha(1)

//this is basically a fucked up version of the draw_polygon_texture function, but it does something neat i guess
#define draw_polygon_striped(sides,radius,angle,_x,_y,sprite,col,alpha)
draw_set_alpha(alpha)
draw_set_color(col)
var tex,w;
w = sprite_get_width(sprite);
tex = sprite_get_texture(sprite, 0);
draw_primitive_begin_texture(pr_trianglefan, tex);
draw_vertex_texture(_x,_y,.50,0)
for (var i = angle; i <= angle+360; i += 360/sides){
    draw_vertex_texture(_x+lengthdir_x(radius,i), _y+lengthdir_y(radius,i), .5+(1/w)*lengthdir_x(radius,-angle+i+180),0);
}
draw_primitive_end();
draw_set_color(c_white)
draw_set_alpha(1)

#define draw_polygon_texture(sides,radius,angle,spriteang,_x,_y,xscale,yscale,sprite,frame,col,alpha)
draw_set_alpha(alpha)
draw_set_color(col)
var tex,w,h;
w = sprite_get_width(sprite);
h = sprite_get_height(sprite);
tex = sprite_get_texture(sprite, frame);
draw_primitive_begin_texture(pr_trianglefan, tex);
draw_vertex_texture(_x,_y,.5,.5)
for (var i = angle; i <= angle+360; i += 360/sides){
    draw_vertex_texture(_x+lengthdir_x(radius,i), _y+lengthdir_y(radius,i), .5+(1/(w*xscale))*lengthdir_x(radius,-spriteang+i), .5+(1/(h*yscale))*lengthdir_y(radius,-spriteang+i));
}
draw_primitive_end();
draw_set_color(c_white)
draw_set_alpha(1)

//abris time
#define create_abris(Creator,startsize,endsize,weapon)
var a  = instance_create(0,0,CustomObject);
with a{
	//generic variables
	creator = Creator;
	name = "Abris Target"
	team = -1
	on_step = abris_step
	on_draw = abris_draw
	with creator if "index" in self{other.index = index}else{other.index = id}
	//accuarcy things
	accbase = startsize*creator.accuracy
	acc = accbase
	accmin = endsize
	accspeed = 1.2
	accset = false
	//other things
	damage = 2
	maxdamage = 8
	wep = weapon
	check = 0 //the button it checks, 0 is undecided, 1 is fire, 2 is specs, should only be 0 on creation, never step
	popped = 0
	dropped = 0
	type = weapon_get_type(wep)
	cost = weapon_get_cost(wep)
	auto = 0
	//visual things
	rotspeed = 3
	offspeed = 3
	lasercolour1 = c_red
	lasercolour = c_red
	lasercolour2 = c_maroon
	offset = random(360)

	primary = 1
	//god bless YAL
	if index <= 3
	{
	    btn = "fire"
		check = other.specfiring ? 2 : 1;
		if check = 2{
		    btn = "spec"
		    if other.race = "steroids" primary = 0
		    if other.race = "venuz" popped = 1
		}
	}
	else{
	    btn = "fire"
	}
}
return a;

//hahahahah fuck this
#define abris_check()
if index > 3 return 1;
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
  var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
  var _a = accbase/accmin
  with creator weapon_post(_a,5*_a*current_time_scale,0)
	if check = 0{
		abris_check()
	}
	if !dropped{
		image_angle += rotspeed*timescale;
		offset += offspeed*timescale;
		if primary{
			if popped{
				var pops = 1;
				with instances_matching(CustomObject,"name","Abris Target") if creator = other.creator && id != other{
					if popped {pops+=1}
				}
				creator.reload = max(weapon_get_load(creator.wep) * (pops), creator.reload)
			}
			else{
				creator.reload = weapon_get_load(creator.wep)
			}
		}else{
			creator.breload = weapon_get_load(creator.bwep)
		}
		acc /= 1+((accspeed - 1)*timescale)
		if index <= 3{var _xx = mouse_x[index];var _yy = mouse_y[index]}else{var _xx = index.x;var _yy = index.y}
		if collision_line(x,y,_xx,_yy,Wall,0,0) >= 0{
			if acc < accbase{acc += abs(creator.accuracy*3)}else{acc = accbase;lasercolour=c_white}
		}
	}
	if !button_check(creator.index,btn) || (auto && acc<=accmin){
		if instance_exists(self){
			dropped = 1
			var _wall = collision_line_first(x,y,_xx,_yy,Wall,0,0);
			if _wall > -4
			{
				explo_x = x + lengthdir_x(point_distance(x,y,_wall.x,_wall.y)-accmin,creator.gunangle);
				explo_y = y + lengthdir_y(point_distance(x,y,_wall.x,_wall.y)-accmin,creator.gunangle);
			}
			else
			{
				explo_x = _xx
				explo_y = _yy
			}
			if fork(){
			    with instance_create(explo_x, explo_y, CustomProjectile){
			        sprite_index = sprGammaBlast
			        image_alpha = 0
			        team = other.creator.team
			        var size = 2 * (other.acc+other.accmin)/(sprite_width)
			        damage = ceil(other.damage + (other.maxdamage - other.damage)*(1 - (other.acc/other.accbase)))
			        image_xscale = size
			        image_yscale = size
			        on_wall = nothing
			        on_hit = abris_hit
			        if fork(){
			            wait(0)
			            if !instance_exists(self) exit
			            instance_destroy()
			            exit
			        }
			    }
				on_destroy = payload
				instance_destroy()
				exit
			}
		};
	}
}
else{instance_destroy()}

#define abris_hit
projectile_hit(other,damage,0,0)

#define abris_draw
if instance_exists(creator) && check{
	x = creator.x
	y = creator.y
	var w = collision_line_first(x,y,mouse_x[index],mouse_y[index],Wall,0,0);
	if w > -4
	{
		var _wall = w;
		var _tarx = x + lengthdir_x(point_distance(x,y,_wall.x,_wall.y),creator.gunangle);
		var _tary = y + lengthdir_y(point_distance(x,y,_wall.x,_wall.y),creator.gunangle);
	}
	else
	{
		var _tarx = mouse_x[index];
		var _tary = mouse_y[index];
	}
	if button_check(creator.index,btn){
    var _a = (primary = 1 ? creator.wkick : creator.bwkick)
      draw_sprite_ext(sprHeavyGrenadeBlink,0,x+lengthdir_x(14-_a,creator.gunangle),y+lengthdir_y(14-_a,creator.gunangle)+1,1,1,creator.gunangle,lasercolour1,1)
			var radi = acc+accmin;
			mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, radi, 45, _tarx+1, _tary+1, global.stripes, lasercolour1, 0.1+(accbase-acc)/(accbase*5),(current_frame mod 16)*.004);
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,radi,1,acc+image_angle,_tarx,_tary,lasercolour1,1*(accbase-acc))
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16, accmin,1,acc+image_angle,_tarx,_tary,lasercolour1,.2)
			draw_line_width_colour(x+lengthdir_x(16-_a,creator.gunangle),y+lengthdir_y(16-_a,creator.gunangle),_tarx,_tary,1,lasercolour1,lasercolour1);
		var comp = (primary = 1 ? creator.wep : creator.bwep);
		if popped {comp = creator.wep}
		if wep != comp {instance_destroy()}
	}
}
#define collision_line_first(x1,y1,x2,y2,object,prec,notme)
/// collision_line_first(x1,y1,x2,y2,object,prec,notme)
//
//  Returns the instance id of an object colliding with a given line and
//  closest to the first point, or noone if no instance found.
//  The solution is found in log2(range) collision checks.
//
//      x1,y2       first point on collision line, real
//      x2,y2       second point on collision line, real
//      object      which objects to look for (or all), real
//      prec        if true, use precise collision checking, bool
//      notme       if true, ignore the calling instance, bool
//
/// GMLscripts.com/license
{
    var ox,oy,dx,dy,object,prec,notme,sx,sy,inst,i;
    ox = argument0;
    oy = argument1;
    dx = argument2;
    dy = argument3;
    object = argument4;
    prec = argument5;
    notme = argument6;
    sx = dx - ox;
    sy = dy - oy;
    inst = collision_line(ox,oy,dx,dy,object,prec,notme);
    if (inst != noone) {
        while ((abs(sx) >= 1) || (abs(sy) >= 1)) {
            sx /= 2;
            sy /= 2;
            i = collision_line(ox,oy,dx,dy,object,prec,notme);
            if (i) {
                dx -= sx;
                dy -= sy;
                inst = i;
            }else{
                dx += sx;
                dy += sy;
            }
        }
    }
    return inst;
}

#define draw_curve(x1,y1,x2,y2,direction,detail)
// SOURCE: http://www.gmlscripts.com/script/draw_curve
//  Draws a curve between two points with a given starting angle.
//      x1,y1       position of start of curve, real
//      x2,y2       position of end of curve, real
//      direction   start angle of the curve, real
//      detail      number of segments in the curve, real
//var x1, y1, x2, y2, start_angle, detail, dist, dist_ang, inc, draw_x, draw_y;
var start_angle = direction

var dist = point_distance(x1,y1,x2,y2);
var dist_ang = angle_difference(point_direction(x1,y1,x2,y2),start_angle);
var inc = (1/detail);

draw_primitive_begin(pr_linestrip);
for (var i=0; i<1+inc; i+=inc) {
	var draw_x = x1 + (lengthdir_x(i * dist, i * dist_ang + start_angle));
	var draw_y = y1 + (lengthdir_y(i * dist, i * dist_ang + start_angle));
	draw_vertex(draw_x,draw_y);
}
draw_primitive_end();
return 0;


#define create_lightning(_x,_y)
if instance_exists(GameCont) and GameCont.area = 101
{
  sleep(150)
  with Player lasthit = [sprLightningDeath,"ELECTROCUTION"]
  with hitme with other projectile_hit(other,7,0,0)
  instance_destroy()
  exit
}
else
{
  with instance_create(_x,_y,CustomProjectile){
	vbuf = vertex_create_buffer()
  	lightning_refresh()
  	hitid = [sprLightningHit,"Lightning Bolt"]
  	name = "Lightning Bolt"
  	time = skill_get(17)+4
  	timestart = time
  	create_frame = current_frame
  	colors = [c_black,c_white,c_white,merge_color(c_blue,c_white,.3),c_white]
  	wantdust = 1
  	damage = 9 + skill_get(17)*3
  	force = 40
    mask_index   = sprPlasmaBall
    image_xscale = 5
    image_yscale = 5
  	on_wall    = lightning_wall
  	on_draw    = lightning_draw;
    on_destroy = lightning_destroy
    on_cleanup = lightning_cleanup
  	on_step    = lightning_step
  	on_hit     = lightning_hit
  	depth = -8

  	return id
  }
}
#define lightning_wall
with other{
	instance_create(x,y,FloorExplo)
	instance_destroy()
}

#define lightning_draw
//if random(100) <= 25*current_time_scale lightning_refresh()
//lightning_refresh()
d3d_set_fog(1,colors[min((current_frame - create_frame),array_length_1d(colors)-1)], 0,0)
vertex_submit(vbuf, pr_trianglestrip)
d3d_set_fog(0,0,0,0)
for (var i = 0; i < array_length_1d(ypoints); i++){
	draw_sprite(sprLightningHit,1+irandom(2),xpoints[i],ypoints[i])
	//draw_line_width(xpoints[i],ypoints[i],xpoints[i-1],ypoints[i-1],i/10)
}
//trace(array_length(ypoints))
//var yy = ypoints[array_length_1d(ypoints)-1];
/*draw_set_color(c_white)
draw_set_blend_mode(bm_max)
draw_triangle_color(xmax,yy,xmin,yy,x,y,c_white,c_white,c_black,0)
draw_set_blend_mode(bm_normal)
*/
#define lightning_hit
if projectile_canhit(other) && current_frame_active{
	projectile_hit_push(other,damage,force)
}


#define lightning_refresh
ypoints = []
xpoints = []
var mmax = 100;
var mmin = -100;
var xx = x;
var yy = y;

var ang = random_range(70,110)
var width = 0.5, length = 10
var bwidth = .5 + skill_get(mut_laser_brain)
var n = 0
vertex_begin(vbuf, global.lightningformat)
vertex_position(vbuf, xx, yy)
while yy > y - 2*game_height{
    vertex_position(vbuf, xx + width * ((n mod 2) ? -1 : 1), yy)
    n++
    xx += lengthdir_x(length,ang)
    yy += lengthdir_y(length,ang)
    length = random(6)
    width = (y - yy)/75 + bwidth
    ang = clamp(ang + random_range(7,30) * choose(-1,1) * (min((y-yy), 20))/20,40,140)
    if ang = 40 or ang = 140 ang -= random_range(5,20)*sign(ang - 90)
    if !irandom(5) {
        array_push(xpoints,xx)
        array_push(ypoints,yy)
    }

    //ang = random_range(50,130)


	/*xx += random_range(-6,6)
	yy -= random_range(-2,8)
	array_push(xpoints,xx)
	array_push(ypoints,yy)

	var m = slope(x,xx,y,yy)
	if m < 0.01 && abs(m) < abs(mmin) {mmin = m}
	if  m > 0.01 && m < mmax {mmax = m} */
}
vertex_end(vbuf)
/*var y1 = y - 2*game_height;
xmax = x+(y1 - y)/mmin
xmin = x+(y1 - y)/mmax
*/
#define slope(x1,x2,y1,y2)
return((y2-y1)/(x2-x1))

#define lightning_destroy
for (var i = 1; i < array_length_1d(ypoints); i++){
	if !irandom(4) with instance_create(xpoints[i],ypoints[i],FireFly){
		depth = other.depth
		image_speed/=1.5
		sprite_index = sprLightning
		hspeed += random_range(-.5,.5)
		vspeed += random_range(-.5,.5)
	}
}
lightning_cleanup()

#define lightning_cleanup
vertex_delete_buffer(vbuf)
sound_set_track_position(sndExplosionL,0)

#define lightning_step
view_shake_max_at(x,y,30)
if wantdust != 0{
    repeat(30){
  		with instance_create(x,y,Dust){
  		  motion_set(random(360),3+random(10))
	    }
  	}
      repeat(8){
          with instance_create(x+random_range(-30,30),y+random_range(-30,30),LightningSpawn){
            image_angle = point_direction(other.x,other.y,x,y) + random_range(-8,8)
          }
      }
  	if instance_exists(Floor){
  	    var closeboy = instance_nearest(x,y,Floor);
      	if point_in_rectangle(x,y,closeboy.x-16,closeboy.y-16,closeboy.x+16,closeboy.y+16){
      	    with instance_create(x,y,Scorchmark){
      	        time = 0;
      	        if fork(){
      	            while instance_exists(self) && time < 45{
      	                time += current_time_scale
      	                image_alpha -= current_time_scale/45
      	                if random(100) <= (45-time)*current_time_scale{
      	                    with instance_create(x,y,Smoke){
      	                        motion_add(90,random_range(1,2))
      	                        image_xscale = (1-(other.time/45)) * random_range(.5,1)
      	                        image_yscale = image_xscale
      	                        gravity = -friction
      	                    }
      	                }
      	                wait(0)
      	            }
      	            if instance_exists(self) instance_destroy()
      	            exit
      	        }
      	    }
      	}
  	}
  	wantdust = 0
}
time -= current_time_scale
if time <= 0 instance_destroy()

#define create_plasmite(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with a
{
    name = "Plasmite"
	image_speed = 0
	image_index = 0
	damage = 4+3*skill_get(17)
	if skill_get(17) = false sprite_index = global.sprPlasmite else sprite_index = global.sprPlasmiteUpg
 	fric = random_range(.2,.3)
    force = 2
    basexscale = 1
	maxspeed = 13
	on_step 	 = plasmite_step
	on_wall 	 = plasmite_wall
	on_destroy   = plasmite_destroy
	on_draw      = plasmite_draw
	on_square    = script_ref_create(plasmite_square)
}
return a;

#define plasmite_step
if chance(8 + 6*skill_get(17)) instance_create(x,y,PlasmaTrail)

var closeboy = instance_nearest_matching_ne(x,y,hitme,"team",team)
if instance_exists(closeboy) && distance_to_object(closeboy) <= 24{
	  motion_add(point_direction(x,y,closeboy.x,closeboy.y),4*current_time_scale)
	  maxspeed+=.5*current_time_scale
}
image_angle = direction
if speed > maxspeed{speed = maxspeed}
maxspeed /= 1+(fric*current_time_scale)
if maxspeed <= 1+fric instance_destroy()

#define plasmite_wall
move_bounce_solid(false)
image_angle = direction
sound_play_pitchvol(sndPlasmaHit,random_range(3,6),.3)
var n = irandom_range(2,6), int = 360/n;
for (var i = 0; i < 360; i+= int){
    with mod_script_call("mod","defparticles","create_spark",x,y) {
        motion_set(i + random_range(-int/3,int/3),random(8)+1)
        friction = 1.2
        age = speed
        color = c_white
        fadecolor = c_lime
        gravity = .8
        gravity_direction = other.direction
    }
}

//instance_destroy()

#define plasmite_draw
var _x = image_xscale
image_xscale = _x + (sqr(speed/(sprite_width*1.5)))*_x
draw_self()
image_xscale = _x

#define plasmite_destroy
sound_play_pitch(sndPlasmaHit,random_range(1.45,1.83))
with instance_create(x,y,PlasmaImpact){image_xscale=.5;image_yscale=.5;team = other.team;damage = floor(damage/2)}

#define create_supersquare(_x,_y)
with create_square(_x,_y){
    damage = 2
    force = 12
    bounce = 5+skill_get(17)*2
    image_xscale = 1+skill_get(17)*.3
	image_yscale = 1+skill_get(17)*.3
	sprite_index = global.sprSuperSquare
	mask_index 	 = global.mskSuperSquare
	anglefac = random_range(0.6,2)
	lifetime += room_speed
	size = 4

	return id
}

/*var a = instance_create(_x,_y,CustomProjectile);
with a
{
	typ = 1
	name = "square"
	size = 4
	friction = .3
	bounce = 5+skill_get(17)*2
	damage = 2
	image_xscale = 1+skill_get(17)*.3
	image_yscale = 1+skill_get(17)*.3
	force = 12
	iframes = 0
	minspeed = 2
	anglefac = random_range(0.6,2)
	fac = choose(1,-1)
	sprite_index = global.sprSuperSquare
	mask_index 	 = global.mskSuperSquare
	hitframes = 0
	lifetime = room_speed * 7
	on_step    = square_step
	on_hit     = square_hit
	on_wall    = square_wall
	on_draw    = square_draw
	on_destroy = square_destroy
}
return a;
*/

#define create_triangle(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with a
{
    typ = 1
    name = "triangle"
    size = 1
    friction = 1.3
    damage = 5
    image_xscale = 1.2
    image_yscale = 1.2
    sprite_index = global.sprTriangle
    image_angle = direction - 45
    on_step    = triangle_step
    on_wall    = triangle_wall
    on_destroy = triangle_destroy
}
return a;

#define triangle_step
if friction > speed{instance_destroy()}

#define triangle_wall
instance_destroy()

#define triangle_destroy
sleep(2)
view_shake_at(x,y,8)
sound_play_pitchvol(sndPlasmaHit,random_range(2,3),.4)
var i = direction - 90;
repeat(3){
    with instance_create(x,y,Laser){
        creator = other.creator
        team = other.team
        image_angle = i
        event_perform(ev_alarm,0)
    }
    i += 90
}

#define create_square(_x,_y)
var a = instance_create(_x,_y,CustomSlash);
with a{
    typ = 0
    name = "square"
    size = 1
    pseudoteam = -1
    friction = .3
    bounce = 7+skill_get(17)*3
    damage = 1
    minspeed = 2
    image_xscale = 1+skill_get(17)*.2
    image_yscale = 1+skill_get(17)*.2
    force = 1
    iframes = 0
    anglefac = random_range(0.8,2.5)
    fac = choose(1,-1)
    sprite_index = global.sprSquare
    mask_index 	 = global.mskSquare
    hitframes = 0
    lifetime = room_speed * 6
    on_projectile = square_projectile
    on_grenade = nothing
    on_step    = square_step
    on_hit     = square_hit
    on_wall    = square_wall
    on_draw    = square_draw
    on_destroy = square_destroy
    on_square  = script_ref_create(square_square)
    on_anim    = nothing
}
return a;

#define square_destroy
if size > 1
{
	var i = random(360);
	repeat(4)
	{
		with create_square(x,y)
		{
			creator = other.creator
			team    = other.pseudoteam
			pseudoteam = team
			size    = 1
			motion_add(i+random_range(-6,6),6)
		}
		i += 360/size
	}
}
sound_play_pitch(sndPlasmaHit,random_range(.9,1.1))
with instance_create(x,y,PlasmaImpact){team = other.pseudoteam;}

#define square_hit
if other.team != pseudoteam and current_frame_active{
    with other motion_add(point_direction(other.x,other.y,x,y),other.size)
    if speed > minspeed && projectile_canhit_melee(other) = true{projectile_hit(other, round(2*damage + speed), force, direction)}else{projectile_hit(other, damage, force, direction)};
}

#define square_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);

#define square_projectile
if other.team = pseudoteam || ("pseudoteam" in other and other.pseudoteam == pseudoteam){
    if instance_is(other,CustomProjectile){
        if "on_square" in other{
            with other mod_script_call(on_square[0],on_square[1],on_square[2])
        }
    }
    else if instance_is(other,Laser){
        motion_add(other.direction,(2/size) * current_time_scale)
        if current_frame_active with instance_create(x + lengthdir_x(random(sprite_width/2),random(360)),y+lengthdir_y(random(sprite_height/2),random(360)),PlasmaTrail) motion_set(other.direction, random_range(3,8))
    }
    else if iframes <= 0{
        var melee = [EnergySlash,EnergyShank,EnergyHammerSlash]
        var speeds = [12,9,17]
        for var i = 0; i <= 2; i++{
            if instance_is(other,melee[i]){
				with instance_create(other.x,other.y,GunGun) image_index=2
				if speed < 20 {
				    direction = other.direction;
				    speed = speeds[i]
				}
				sound_play_pitch(sndPlasmaBigExplode,1.4)
				sound_play_pitch(sndPlasmaHit,2.2)
				if skill_get(17){sound_play_pitch(sndPlasmaBigExplodeUpg,2.2)}
				iframes += 10
                break
            }
        }
    }
    if instance_is(other,PlasmaBall) || instance_is(other,PopoPlasmaBall) || instance_is(other,PlasmaHuge) || instance_is(other,PlasmaBig){
        var num = plasmite_count(other.object_index)
        repeat(num[0]){
            with create_plasmite(x,y){
                creator = other.creator
                team = other.pseudoteam
                motion_add(other.direction+random_range(-140,140),random_range(12,16)+6)
                fric += .08
                image_angle = direction
            }
        }
        repeat(num[1]){
            with create_plasmite(x,y){
                creator = other.creator
                team = other.pseudoteam
                motion_add(other.direction+random_range(-20,20),random_range(16,20)+6)
                fric += .08
                image_angle = direction
            }
        }
        instance_destroy();exit
    }
}

#define plasmite_count(object)
    switch object{
        case PlasmaBig: return[10,5]
        case PlasmaHuge: return[12,6]
        default: return[8,4]
    }

#define plasmite_square
    motion_set(point_direction(other.x,other.y,x,y),speed + other.size)
    with other motion_add(point_direction(other.x,other.y,x,y),other.damage/(size*2))
    sound_play_pitchvol(sndPlasmaHit,random_range(3,6),.3)
    with instance_create(x,y,PlasmaTrail){image_xscale = 2;image_yscale = 2}
    image_angle = direction

#define lflak_square
    sound_play_pitchvol(sndPlasmaBigExplode,random_range(3,6),.3)
    repeat(12) with instance_create(x,y,PlasmaTrail){image_index = 0;image_speed = .5;motion_add(other.direction+random_range(-120,120),random_range(9,12))}
    with other{
        var i = direction + 90;
        repeat(2){
            with create_triangle(x,y){
                creator = other.creator
                team = other.pseudoteam
                motion_add(i,12)
                if direction > 180 turn = -1 else turn = 1
                image_angle = direction - 45
            }
            i += 180
        }
        instance_destroy()
        exit
    }

#define square_square
    motion_add(point_direction(other.x,other.y,x,y),7*(other.size/size))
    repeat(6) with instance_create(x,y,PlasmaTrail){image_index = 0;image_speed = .5;motion_add(other.direction+random_range(-60,60),random_range(9,12))}
    sound_play_pitch(sndPlasmaHit,random_range(.9,1.1))
    with instance_create(x,y,PlasmaImpact){team = other.pseudoteam;instance_create(x+random_range(-8,8),y+random_range(-8,8),Smoke)}

#define square_wall
    move_bounce_solid(1)
    sound_play_pitchvol(sndPlasmaHit,random_range(2,4),.3)
    repeat(3) with instance_create(x,y,PlasmaTrail){image_index = 0;image_speed = .5;motion_add(other.direction+random_range(-30,30),random_range(6,8))}
    if speed <= minspeed bounce--
    sleep(size * 5)
    view_shake_at(x,y,size * 5)

#define square_step
if team != id{
    pseudoteam = team
    team = id
}
if speed > 2{
	if current_frame_active with instance_create(x + lengthdir_x(random(sprite_width/2),random(360)),y+lengthdir_y(random(sprite_height/2),random(360)),PlasmaTrail){
	    sprite_index = sprPlasmaImpact
		image_index = 2
		image_speed = 0.3-skill_get(17)*0.05
		image_xscale = .25
		image_yscale = .25
	}
}
iframes = max(iframes - current_time_scale, 0)
if speed < minspeed speed = minspeed
if speed > 16 speed = 16
image_angle += speed * anglefac * fac * current_time_scale
if current_frame_active with instance_create(x+random_range(-8,8)+lengthdir_x(sprite_width/2,direction-180),y+random_range(-8,8)+lengthdir_y(sprite_width/2,direction-180),PlasmaTrail){
	image_speed = 0.35-skill_get(17)*0.05
}
if bounce <= 0 instance_destroy()


#define create_rocklet(_x,_y)
with instance_create(_x,_y,CustomProjectile){
    sprite_index = global.sprRocklet
    damage = 3
    name = "Rocklet"
    maxspeed = 14
    immuneToDistortion = 1
    typ = 1
    depth = -1
    direction_goal = 0
    friction = -.6
    on_step = rocket_step
    on_destroy = rocket_destroy
    on_anim = bullet_anim
    on_draw = rocket_draw
    return id
}

#define rocket_step
direction -= (angle_difference(direction,direction_goal)*current_time_scale)/8
if speed > maxspeed{speed = maxspeed}
image_angle = direction

#define rocket_destroy
sound_play_pitch(sndExplosionS,1.5)
with instance_create(x,y,SmallExplosion){damage -= 2}

#define rocket_draw
draw_self()
draw_sprite_ext(global.sprRockletFlame,-1,x,y,1,1,image_angle,c_white,image_alpha)

#define laserflak_hit
if projectile_canhit_melee(other) = true
{
	var k = other.my_health;
	projectile_hit(other,damage,ammo,direction)
	repeat(3) with instance_create(x,y,PlasmaTrail)
	{
		view_shake_at(x,y,8)
		motion_add(random(180),random_range(7,8))
	}
	sleep(damage*2)
	damage -= floor(k/size)
	if damage <= 0 instance_destroy()
}

//SPIKEBALL
#define create_minispikeball(_x,_y)
var a = instance_create(_x,_y,CustomSlash);
with a
{
  typ  = 1
  name = "Spikeball"
  image_speed = speed/10
  damage = 1
  force = 3
  size = 2
  bounce = 0
  hitframes = 0
  sprite_index = global.sprMiniSpikeball
  mask_index   = global.mskMiniSpikeball
  on_hit        = spike_hit
  on_wall       = spike_wall
  on_step       = spike_step
  on_projectile = spike_projectile
  on_anim       = spike_anim
}
return a;

#define create_spikeball(_x,_y)
var a = instance_create(_x,_y,CustomSlash);
with a
{
  typ  = 1
  name = "Spikeball"
  image_speed = speed/10
  damage = 5
  force = 6
  size = 4
  bounce = 0
  sprite_index = global.sprSpikeball
  mask_index   = global.mskSpikeball
  on_hit        = spike_hit
  on_wall       = spike_wall
  on_step       = spike_step
  on_projectile = spike_projectile
  on_anim       = spike_anim
}
return a;

#define create_heavyspikeball(_x,_y)
var a = instance_create(_x,_y,CustomSlash);
with a
{
  typ  = 1
  name = "Spikeball"
  image_speed = speed/10
  damage = 10
  force = 8
  size = 10
  bounce = 0
  sprite_index = global.sprHeavySpikeball
  mask_index   = global.mskHeavySpikeball
  on_hit        = spike_hit
  on_wall       = spike_wall
  on_step       = spike_step
  on_projectile = spike_projectile
  on_anim       = spike_anim
}
return a;

#define spike_anim

#define spike_hit
if "creator" not in self creator = -4
if other.id != creator
{
  projectile_hit(other,damage,force,direction)
  if other.size > size{motion_set(point_direction(other.x,other.y,x,y),speed)}
  x -= hspeed
  y -= vspeed
}
else
{
    damage += 1
    projectile_hit(other,damage,force,direction)
    instance_destroy()
    exit
}
hitframes++
if hitframes >= 10 instance_destroy()

#define spike_wall
sound_play_pitchvol(sndHitRock,random_range(.6,.8),.3)
//sound_play_pitch(sndHitMetal,random_range(1.3,1.5))
sleep(size*6)
view_shake_at(x,y,4*size)
repeat(size)instance_create(x,y,Dust)
move_bounce_solid(false)
image_speed = speed/10
bounce++
direction += random_range(-12,12)
if bounce >= 5 instance_destroy()

#define spike_step
with instance_create(x-lengthdir_x(speed,direction),y-lengthdir_y(speed,direction),BoltTrail){
    image_angle = other.direction
    image_yscale = other.size / 3
    image_xscale = other.speed
}
/*with instances_matching(CustomSlash,"name","Spikeball")
{
  if bounce>0 and other.bounce>0
  {
    if place_meeting(x,y,other)
    {
      sleep(size*2)
      view_shake_at(x,y,3*size)
      motion_set(point_direction(other.x,other.y,x,y),speed)
      repeat(size)instance_create(x,y,Dust)
      sound_play_pitch(sndHitRock,random_range(.6,.8))
      sound_play_pitch(sndHitMetal,random_range(1.3,1.5))
      sound_play_pitch(sndGrenadeHitWall,random_range(1.7,2.5))
      var _spd = (speed + other.speed)/2;
      speed = _spd
      with other{speed = _spd}
      with instance_create((x+other.x)/2,(y+other.y)/2,MeleeHitWall){image_angle += other.direction+90}
    }
  }
}*/

#define spike_projectile
//with other if typ > 0 instance_destroy()

//LASER FLAK
#define create_laser_flak(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with a
{
    name = "Laser Flak"
	image_speed = 1
	damage = 8 + skill_get(17)*3
	friction = .5
	ammo = 10
	typ = 1
	size = 1
	sprite_index = global.sprLaserFlakBullet
	mask_index = mskFlakBullet
	on_hit      = laserflak_hit
	on_draw     = laserflak_draw
	on_step     = laserflak_step
	on_destroy  = laserflak_destroy
	on_square   = script_ref_create(lflak_square)
}
return a;

#define laserflak_destroy
view_shake_at(x,y,32)
var i = random(360);
var _p = random_range(.8,1.2);
sound_play_pitch(sndBouncerSmg,.4*_p)
sound_play_pitch(sndSlugger,.5*_p)
sound_play_pitch(sndPlasma,.8*_p)
sound_play_pitch(sndPlasmaHit,random_range(.6,.8))
sound_play_pitch(sndLaser,random_range(.5,.6))
sound_play_pitch(sndExplosionS,random_range(1.2,1.5))
repeat(ammo)
{
	sleep(10)
	repeat(2) with instance_create(x,y,PlasmaTrail)
	{
		motion_add(random(360),random_range(5,12))
	}
	if size > 1
	{
		with instance_create(x,y,PlasmaImpact)
		{
			creator = other.creator
			team = other.team
			var _scale = random_range(.2,.3);
			motion_add(random(360),12)
			friction = random_range(.3,1.2)
			image_xscale = _scale
			image_yscale = _scale
		}
	}
	with instance_create(x,y,Laser)
	{
	    creator = other.creator
		image_angle = i+random_range(-32,32)*other.accuracy
		direction = image_angle
		team = other.team
		event_perform(ev_alarm,0)
	}
	i += 360/ammo
}

#define laserflak_step
if chance(66)
{
	with instance_create(x+random_range(-8,8),y+random_range(-8,8),PlasmaTrail)
	{
		image_xscale += skill_get(17)/3
		image_yscale = image_xscale
	}
	if size > 1
	{
		with instance_create(x+random_range(-12,12),y+random_range(-12,12),PlasmaImpact)
		{
			creator = other.creator
			team = other.team
			var _scale = random_range(.2,.3);
			with Smoke if place_meeting(x,y,other) instance_destroy()
			depth = other.depth+1
			image_xscale = _scale
			image_yscale = _scale
		}
	}
}
/*if irandom(1) = 1
{
	instance_create(x+random_range(-4,4),y+random_range(-4,4),Smoke)
}
*/
if speed < friction instance_destroy()

#define laserflak_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.75*image_xscale, 1.75*image_yscale, image_angle, image_blend, 0.25);
draw_set_blend_mode(bm_normal);

#define quartz_penalty(_mod) //this is for player step only stupid
if chance(4)
{
  with instance_create(x+random_range(-8,8),y+random_range(-8,8),WepSwap)
  {
    image_xscale = .75
    image_yscale = .75
    image_speed = choose(.7,.7,.7,.45)
  }
}
if lsthealth > my_health
{
  if wep  = _mod
  {
    var _pitch = random_range(.9,1.1)
    sound_play_pitch(sndHyperCrystalHurt,.8*_pitch)
    sound_play_pitch(sndLaserCrystalHit,.7*_pitch)
    sound_play_pitchvol(sndHyperCrystalHalfHP,2*_pitch,.4)
    sound_play_gun(sndLaserCrystalDeath,.1,.0001)//mute action
    sleep(400)
    view_shake_at(x,y,45)
    repeat(14) with instance_create(x,y,Feather)
    {
      motion_add(random(360),random_range(3,6))
      sprite_index = global.sprGlassShard
      image_speed = random_range(.4,.7)
      image_index = irandom(5)
    }
    with instance_create(x,y,ThrownWep)
    {
      wep = "shard"
      sprite_index = global.sprShard
      curse = other.curse
      motion_set(other.gunangle-180-random_range(-2,2),3)
    }
    wep = bwep
    bwep = 0
  }
  if bwep = _mod && race = "steroids" //steroids hnnnnnnnnnnng
  {
    var _pitch = random_range(.9,1.1)
    sound_play_pitch(sndHyperCrystalHurt,.8*_pitch)
    sound_play_pitch(sndLaserCrystalHit,.7*_pitch)
    sound_play_pitchvol(sndHyperCrystalHalfHP,2*_pitch,.4)
    sound_play_gun(sndLaserCrystalDeath,.1,.0001)//mute action
    sleep(400)
    view_shake_at(x,y,45)
    repeat(14) with instance_create(x,y,Feather)
    {
      motion_add(random(360),random_range(3,6))
      sprite_index = global.sprGlassShard
      image_speed = random_range(.4,.7)
      image_index = irandom(5)
    }
    with instance_create(x,y,ThrownWep)
    {
      wep = "shard"
      sprite_index = global.sprShard
      curse = other.bcurse
      motion_set(other.gunangle-180-random_range(-2,2),3)
    }
    bwep = 0
  }
}

#define crit() //add this to on_hit effects in order to not be stupid
var _t = team;
view_shake_max_at(x,y,200)
sleep(150)
damage += 30
sound_play_pitchvol(sndHammerHeadEnd,random_range(1.23,1.33),20)
sound_play_pitchvol(sndBasicUltra,random_range(0.9,1.1),20)
sound_play_pitch(sndCoopUltraA,random_range(3.8,4.05))
sound_play_pitch(sndBasicUltra,random_range(.6,.8))
sound_play_gun(sndClickBack,1,.5)
sound_stop(sndClickBack)
with instance_create(x+lengthdir_x(sprite_get_width(sprite_index),image_angle),y+lengthdir_y(sprite_get_width(sprite_index),image_angle),CustomObject){
    with instance_create(x,y,CustomSlash){
        lifetime = 63
        team = _t
        image_xscale = 2.5
        image_yscale = 2.5
        mask_index  = sprPortalShock
        image_blend = c_black
        image_speed = 0
        image_alpha = 0
        damage = 0
        on_projectile = crit_proj
        on_step       = crit_step
        on_wall       = nothing
        on_hit        = nothing
    }
    image_angle = random(360)
    depth = other.depth -1
    image_speed = .6
    sprite_index = global.sprKillslash
    image_xscale = random_range(1.3,1.5)
    image_yscale = image_xscale
    on_step = Killslash_step
    with instance_create(x,y,CustomObject){
        image_angle = other.image_angle - 90 + random_range(-8,8)
        depth = other.depth
        image_speed = .8
        sprite_index = global.sprKillslash
        image_blend = c_black
        image_xscale = other.image_xscale-.5
        image_yscale = image_xscale
        on_step = Killslash_step
    }
}

#define Killslash_step
if image_index = 1.2 sleep(200)
if image_index >= 7 instance_destroy();

#define crit_proj
with other{
    if team != other.team instance_destroy()
}

#define crit_step
if lifetime > 0{lifetime -= current_time_scale}else{instance_destroy()}

#define create_miniexplosion(_x,_y)
var  r = instance_create(_x,_y,CustomProjectile);
with r
{
    name = "Mini Explosion"
    sprite_index = sprSmallExplosion
    mask_index   = mskSmallExplosion
    image_xscale = .5
    image_yscale = .5
    image_speed = .4
    damage = 2
    force = 4
    team = other.team
    sound_play_pitchvol(sndExplosion,2*random_range(.8,1.2),.2)
    hitid = [sprite_index,"MINI EXPLOSION"]
    on_anim = explo_anim
    on_hit = explo_hit
}
return r;

#define explo_hit
var dmg = damage
if instance_is(other,Player) and skill_get(mut_boiling_veins) dmg = max(min(other.my_health - other.boilcap, damage), 0)
projectile_hit(other, dmg, force, point_direction(x,y,other.x,other.y))

#define explo_anim
instance_destroy()

#define create_bouncerdisc(_x,_y)
var a = instance_create(_x+lengthdir_x(4,gunangle),_y+lengthdir_y(4,gunangle),CustomProjectile);
with a{
    typ = 1
    dist = 0
    damage = 2
    lastteam = -1
    image_speed = .5
    name = "Bouncer Disc"
    sprite_index = global.sprBouncerDisc
    on_step = bouncerdisc_step
    on_hit = bouncerdisc_hit
    on_wall = bouncerdisc_wall
    on_destroy = bouncerdisc_destroy
    hitid = [sprite_index,name]
}
return a;

#define bouncerdisc_step
if speed > 0 && current_frame_active {instance_create(x,y,DiscTrail)}
dist += current_time_scale
if instance_exists(creator) && team != -1 && !place_meeting(x,y,creator){
    lastteam = team
    team = -1
}
if skill_get(mut_bolt_marrow){
    var q = instance_nearest_matching_ne(x,y,hitme,"team",lastteam)
    if instance_exists(q){
        if distance_to_object(q) < 30{
            var dir = point_direction(x,y,q.x,q.y)
            x += lengthdir_x(current_time_scale,dir)
            y += lengthdir_y(current_time_scale,dir)
        }
    }
}

#define bouncerdisc_hit
projectile_hit(other,damage+floor(speed/2),5,direction)
if other.my_health > 0{
    direction = point_direction(other.x,other.y,x,y)
    if speed < 12 speed += .6
}
sound_play_pitch(sndDiscBounce,random_range(.8,1.2))
sound_play_pitch(sndBouncerBounce,random_range(1,1))
image_angle = direction

#define bouncerdisc_wall
move_bounce_solid(false)
direction += random_range(-6,6)
instance_create(x,y,DiscBounce)
image_angle = direction
sound_play_pitch(sndDiscBounce,random_range(.9,1.1)+((speed/4)-1)*.2)
sound_play_pitch(sndBouncerBounce,random_range(1,1))
if dist > 250{instance_destroy();exit}
if speed < 12{speed+=.6}

#define bouncerdisc_destroy
with instance_create(x,y,DiscTrail){sprite_index=sprDiscDisappear}
sound_play_hit(sndDiscDie, 0.2)

#define create_stickydisc(_x,_y)
var a = instance_create(x,y,CustomProjectile);
with a
{
    typ = 1
    dist = 0
    damage = 4
    team = other.team
    image_speed = .4
    name = "Sticky Disc"
    sprite_index = global.sprStickyDisc
    mask_index = mskDisc
    stuckto = -4
    lastteam = -1
    orspeed = 0
    hitid = [sprite_index,name]
    depth = -3
    on_step    = stickydisc_step
    on_hit     = stickydisc_hit
    on_destroy = stickydisc_destroy
    on_wall    = stickydisc_wall
}
return a;

#define stickydisc_step
if speed > 0 && current_frame_active {instance_create(x,y,DiscTrail)}
dist += current_time_scale
if dist > 200{instance_destroy();exit}
if instance_exists(creator) && team != -1 && !place_meeting(x,y,creator){
    lastteam = team
    team = -1
}

if instance_exists(stuckto){
    x = stuckto.x - xoff + stuckto.hspeed_raw
    y = stuckto.y - yoff + stuckto.vspeed_raw
    xprevious = x
    yprevious = y
    if current_frame_active instance_create(x,y,Dust)
}
else if skill_get(mut_bolt_marrow){
    var q = instance_nearest_matching_ne(x,y,hitme,"team",lastteam)
    if instance_exists(q) && distance_to_object(q) < 30
        motion_add(point_direction(x,y,q.x,q.y),.25*current_time_scale)
}

#define stickydisc_hit
if projectile_canhit_melee(other){
    sound_play_hit(sndDiscHit,.2)
    projectile_hit(other, damage, 5, direction)
    if other.my_health > 0{
        if stuckto != other{
            stuckto = other
            xoff = (other.x - x)/2
            yoff = (other.y - y)/2
            sound_play(sndGrenadeStickWall)
            repeat(12){with instance_create(x,y,Smoke){depth = -4}}
        }
    }
    else {
        speed = orspeed
        stuckto = -4
    }
}

#define stickydisc_wall
if !instance_exists(stuckto) sound_play_hit(sndDiscBounce,.2)
move_bounce_solid(true)

#define stickydisc_destroy
with instance_create(x,y,DiscTrail){sprite_index=sprDiscDisappear;}
sound_play_hit(sndDiscDie, 0.2)
//with instance_create(x,y,Smoke){depth = -3}

#define create_megadisc(_x,_y)
var a = instance_create(x,y,CustomProjectile)
with a
{
    typ = 1
    sprite_index = global.sprMegaDisc
    dist = 0
    damage = 2
    image_speed = .4
    lastteam = -1
    maxspeed = speed
    hitid = [sprite_index,"MEGA DISC"]
    on_step    = md_step
    on_wall    = md_wall
    on_hit     = md_hit
    on_destroy = md_destroy
}
return a

#define md_step
dist += current_time_scale
if current_frame_active with instance_create(x,y,DiscTrail){
    sprite_index = global.sprMegaDiscTrail
}
if instance_exists(creator) && team != -1 && !place_meeting(x,y,creator){
    lastteam = team
    team = -1
}

if skill_get(21) and instance_exists{
    var q = instance_nearest_matching_ne(x,y,hitme,"team",lastteam)
    if instance_exists(q) && distance_to_object(q) <= 40{
        motion_add(point_direction(x,y,q.x,q.y),.5*current_time_scale)
        speed = maxspeed
    }
}

#define md_wall
dist += 5
sleep(20)
view_shake_at(x,y,8)
sound_play_pitchvol(sndDiscBounce,random_range(.6,.8),.4)
move_bounce_solid(false)
direction += random_range(-12,12)
with other{instance_create(x,y,FloorExplo);instance_destroy()}
with instance_create(x,y,DiscBounce){
    sprite_index = global.sprMegaDiscBounce
}
if dist >= 200 instance_destroy()

#define md_destroy
sound_play_pitchvol(sndDiscDie,random_range(.6,.8),.4)
with instance_create(x,y,DiscDisappear){
    sprite_index = global.sprMegaDiscDie
}

#define md_hit
if current_frame_active{
    if place_meeting(x,y,creator){
        sound_play(sndDiscHit)
        other.lasthit = hitid
        sleep(3*other.size+4)
    }
    x -= hspeed/2
    y -= vspeed/2
    projectile_hit(other,damage,0,direction)
    sleep(other.size)
    view_shake_at(x,y,8)
    dist++
}

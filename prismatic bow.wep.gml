#define init
global.sprBow      = sprite_add_weapon("sprites/weapons/sprPrismaticBow.png",2,10)

global.sprArrow       = sprite_add("sprites/projectiles/sprPrismaticArrow.png",1,3,4)
global.sprArrowRed    = sprite_add("sprites/projectiles/sprPrismaticFireArrow.png",1,3,4)
global.sprArrowYellow = sprite_add("sprites/projectiles/sprPrismaticBouncerArrow.png",1,3,4)
global.sprArrowGreen  = sprite_add("sprites/projectiles/sprPrismaticPestArrow.png",1,3,4)
global.sprArrowBlue   = sprite_add("sprites/projectiles/sprPrismaticThunderArrow.png",1,3,4)
global.sprArrowPurple = sprite_add("sprites/projectiles/sprPrismaticPsyArrow.png",1,3,4)
global.sprArrowHUD = sprite_add_weapon("sprites/projectiles/sprPrismaticArrow.png",5,3)

#define weapon_name
return "PRISMATIC BOW"

#define weapon_iris
return "x bow"

#define weapon_type
return 3

#define weapon_cost
return 1

#define weapon_area
return 4

#define weapon_chrg
return 1

#define weapon_load
return 5

#define weapon_swap
return sndSwapHammer

#define weapon_auto
return 1

#define weapon_melee
return false

#define weapon_laser_sight
return false

#define weapon_reloaded

#define weapon_sprt
return global.sprBow

#define weapon_sprt_hud
return global.sprArrowHUD

#define weapon_text
return "MAKE LIKE A RAINBOW"

#define weapon_fire
with instance_create(x,y,CustomObject){
	type = irandom(4)
    sound   = sndMeleeFlip
	name    = "prismatic bow charge"
	creator = other
	charge    = 0
    maxcharge = 25
    defcharge = {
        style : 0,
        width : 14,
        charge : 0,
        maxcharge : maxcharge
    }
	charged = 0
	depth = TopCont.depth
	spr_arrow = other.race = "skeleton" ? global.sprArrow2 : global.sprArrow
	index = creator.index
  accuracy = other.accuracy
  
	reload = -1
	btn = other.specfiring ? "spec" : "fire"
	hand = other.specfiring and other.race == "steroids"
	on_step    = bow_step
	on_destroy = bow_destroy
	on_cleanup = bow_cleanup
}


#define bow_step
if !instance_exists(creator){instance_delete(self);exit}
var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
if button_check(index,"swap"){instance_destroy();exit}
if reload = -1{
    reload = hand ? creator.breload : creator.reload
    reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale
}
else{
    if hand creator.breload = max(creator.breload, reload)
    else creator.reload = max(reload, creator.reload)
}
view_pan_factor[index] = 3 - (charge/maxcharge * .5)
defcharge.charge = charge
if button_check(index, btn){
    if charge < maxcharge{
        charge += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale;
        charged = 0
        sound_play_pitchvol(sound,sqr((charge/maxcharge) * 3.5) + 6,1 - charge/maxcharge)
    }
    else{
        if current_frame mod 6 < current_time_scale {
            creator.gunshine = 1
            with defcharge blinked = 1
        }
        charge = maxcharge;
        if charged = 0{
            mod_script_call_self("mod","defpack tools", "weapon_charged", creator, 12)
            charged = 1
        }
    }
}
else{instance_destroy()}

#define bow_cleanup
view_pan_factor[index] = undefined
sound_stop(sound)

bow_cleanup()
var _p = random_range(.8,1.2)
sound_play_pitchvol(sndSwapGuitar,4*_p,.8)
sound_play_pitchvol(sndAssassinAttack,2*_p,.8)
sound_play_pitchvol(sndClusterOpen,2*_p,.2)

#define bow_destroy
if charged = 0
{
  with creator weapon_post(1,-10,0)
}
else
{
    with creator
    {
      weapon_post(1,-30,0)
      repeat(6) with instance_create(x,y,Dust)
      {
        motion_add(random(360),choose(5,6))
      }
    }
    sound_play_pitchvol(sndShovel,2,.8)
    sound_play_pitchvol(sndUltraCrossbow,3,.8)
}
with bolt_create(creator.x, creator.y){
	type = other.type
    creator = other.creator
    team = creator.team
    charged = other.charged
    motion_add(creator.gunangle+random_range(-8,8)*creator.accuracy*(1-(other.charge/other.maxcharge)),16+8*other.charge/other.maxcharge)
	damage = 12 + charged * 8
	image_angle = direction
	switch type{
		case 0: //fire
			trailcolour = c_red;
			sprite_index = global.sprArrowRed;
			break;
		case 1: //bouncer
			trailcolour = c_yellow;
			sprite_index = global.sprArrowYellow;
			break;
		case 2: //pest
			trailcolour = c_green;
			sprite_index = global.sprArrowGreen;
			break;
		case 3: //thunder
			trailcolour = c_blue;
			sprite_index = global.sprArrowBlue;
			break;
		case 4: //psy
			trailcolour = c_fuchsia;
			sprite_index = global.sprArrowPurple;
			break;
	}
}

#define bolt_create(x,y)
with instance_create(x,y,CustomProjectile){
    sprite_index = global.sprArrow
    mask_index = mskBolt
    charged = 0
    damage = 12
    force = 3
    on_step = bolt_step
    on_end_step = bolt_end_step
    on_hit = bolt_hit
    on_wall = bolt_wall
    on_destroy = bolt_destroy
    return id
}

#define bolt_step
if random(100) < (50 + 25*charged)*current_time_scale{
    if charged switch type{
	    case 0:
		    repeat(4 + irandom(4))with instance_create(x + lengthdir_x(random(speed), direction),y + lengthdir_y(random(speed), direction), Flame){
		        team = other.team
		        creator = other.creator
		        motion_set(other.direction + choose(-4,4) -180 + random_range(-8,8), .5)
		    }
		    break;
    }
}

#define bolt_end_step
var hitem = 0
if skill_get(mut_bolt_marrow){
    var q = mod_script_call_nc("mod","defpack tools","instance_nearest_matching_ne",x,y,hitme,"team",team)
    if instance_exists(q) and point_distance(x,y,q.x,q.y) < 24 {
        x = q.x - hspeed_raw
        y = q.y - vspeed_raw
        hitem = 1
    }
}
with instance_create(x,y,BoltTrail){
    image_xscale = point_distance(x,y,other.xprevious,other.yprevious)
    image_angle = point_direction(x,y,other.xprevious,other.yprevious)
    image_blend = other.trailcolour
    if fork(){
        while instance_exists(self){
            image_blend = merge_color(image_blend,c_black,.1*current_time_scale)
            wait(0)
        }
        exit
    }
}
if hitem with q with other bolt_hit()

#define bolt_hit
sleep(10)
var o = other, hp = other.my_health;
projectile_hit(o, damage, direction, force)
if charged switch type 
	repeat(4+random(charged*10)){
    with instance_create(x,y,Flame){
        team = other.team
        creator = other.creator
        motion_set(other.direction + 90 * choose(1, -1), random(2)+ 2)
    }
    break;
}
if hp > damage/2{
    with instance_create(x,y,BoltStick){
        target = o
        sprite_index = other.sprite_index
        image_angle = point_direction(x,y,o.x,o.y)
    }
    instance_destroy()
}

#define bolt_wall
if !charged{
    with instance_create(x+hspeed,y+vspeed,CustomObject){
        sprite_index = other.sprite_index
        image_angle = other.image_angle
        if fork(){
            wait(10)
            if instance_exists(self) instance_destroy()
            exit
        }
    }
}
sound_play_hit(sndBoltHitWall,.1)
instance_destroy()

#define bolt_destroy
if charged{
	switch type{
		case 0:
			sound_play(sndExplosionS);
			instance_create(x, y, SmallExplosion)
			break;
		case 2:
		repeat(32){
			with instance_create(x, y, ToxicGas){
				team = other.team;
				creator = other.creator;
				motion_add(random(360), random_range(5, 8));
				friction *= (40 + irandom (20))
			}			
		}
		break;
	}
}

#define init
global.sprExplosiveBow   = sprite_add_weapon("sprites/sprFireBow.png", 4, 9);
global.sprHotArrow  	   = sprite_add("sprites/projectiles/sprFireArrow.png",0, 9, 4);
global.sprHotArrowHUD  	 = sprite_add_weapon("sprites/projectiles/sprFireArrow.png", 7, 3);

#define weapon_name
return "EXPLOSIVE BOW"

#define weapon_sprt
if instance_is(self,Player) with instances_matching(instances_matching(CustomObject, "name", "explosive bow charge"),"creator", id){
    var yoff = (creator.race = "steroids" and btn = "spec") ? -1 : 2
    with creator draw_sprite_ext(global.sprHotArrow, 0, x - lengthdir_x(other.charge/other.maxcharge * 4 - 3, gunangle), y - lengthdir_y(other.charge/other.maxcharge * 4 - 3, gunangle) + yoff, 1, 1, gunangle, c_white, 1)
}
return global.sprExplosiveBow;

#define weapon_type
return 3;

#define weapon_auto
return 1;

#define weapon_load
return 8;

#define weapon_cost
return 2;

#define weapon_chrg
return 1;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return 6;

#define weapon_text
return choose("CHECK THE ROUTES","HOW DO I HOLD THIS");

#define weapon_laser_sight
return false;

#define weapon_sprt_hud
return global.sprHotArrowHUD;

#define weapon_fire
with instance_create(x,y,CustomObject)
{
    sound = sndMeleeFlip
	name    = "explosive bow charge"
	creator = other
	charge    = 0
    maxcharge = 20
	charged = 0
	holdtime = 5 * 30
	depth = TopCont.depth
	index = creator.index
	undef = view_pan_factor[index]
	on_step 	 = bow_step
	on_destroy = bow_destroy
	on_cleanup = bow_cleanup
	btn = other.specfiring ? "spec" : "fire"
}

#define bow_step
if !instance_exists(creator){instance_delete(self);exit}
var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
with creator weapon_post(0,-(min(other.charge/other.maxcharge*10, point_distance(x,y,mouse_x[index],mouse_y[index]))) * timescale,0)
if button_check(index,"swap"){creator.ammo[3] = min(creator.ammo[3] + weapon_cost(), creator.typ_amax[3]);instance_destroy();exit}
if btn = "fire" creator.reload = weapon_get_load(creator.wep)
if btn = "spec"{
    if creator.race = "steroids"
        creator.breload = weapon_get_load(creator.bwep)
    else
        creator.reload = max(weapon_get_load(creator.wep) * array_length_1d(instances_matching(instances_matching(instances_matching(CustomObject, "name", name),"creator",creator),"btn",btn)), creator.reload)
}
if button_check(index,btn){
    if charge < maxcharge{
        charge += timescale;
        charged = 0
        //if charge < 20{
            sound_play_pitchvol(sound,sqr((charge/maxcharge) * 3.5) + 6,1 - charge/maxcharge)

        //}
    }
    else{
        if current_frame mod 6 < current_time_scale creator.gunshine = 1
        charge = maxcharge;
        if charged = 0{
            sound_play_pitch(sndSnowTankCooldown,8)
            sound_play_pitchvol(sndShielderDeflect,5,.5)
            instance_create(creator.x,creator.y,WepSwap);
            charged = 1
        }
    }
}
else{instance_destroy()}

#define weapon_reloaded
return -4

#define bow_cleanup
sound_set_track_position(sound,0)
sound_stop(sound)

#define bow_destroy
bow_cleanup()
var _p = random_range(.8,1.2)
sound_play_pitchvol(sndSwapGuitar,4*_p,.8)
sound_play_pitchvol(sndAssassinAttack,2*_p,.8)
sound_play_pitchvol(sndClusterOpen,2*_p,.2)
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
    creator = other.creator
    team = creator.team
    charged = other.charged
    motion_add(creator.gunangle+random_range(-8,8)*creator.accuracy*(1-(other.charge/other.maxcharge)),16+8*other.charge/other.maxcharge)
	damage = 12 + charged * 8
	image_angle = direction
}
/*with instance_create(creator.x,creator.y,Bolt)
{
	sprite_index = global.sprHotArrow
	creator = other.creator
	team = creator.team
	check = 0
	charged = other.charged
	motion_add(creator.gunangle+random_range(-8,8)*creator.accuracy*(1-(other.charge/other.maxcharge)),16+8*other.charge/other.maxcharge)
	damage = 12 + charged * 8
	image_angle = direction
	if fork(){
		while(instance_exists(self)){
			image_angle = direction
			if speed <= 0 || place_meeting(x + hspeed,y + vspeed,enemy)
				{
					sprite_index = mskNothing
					if check = 0
					{
						check = 1
						with instance_create(x + hspeed,y + vspeed,Flare)
						{
							team = other.team
							instance_destroy()
						}
						sound_play_pitchvol(sndFlareExplode,1,.4+charged*.6)
						if charged = 1 {instance_create(x+lengthdir_x(10,direction),y+lengthdir_y(10,direction),Explosion);sound_play(sndExplosion)}
					}
				}
				else
				{
					if irandom(1-charged) = 0 repeat(1+charged*5)
					{
						with instance_create(x+random_range(-8,8),y+random_range(-8,8),Flame)
						{
							team = other.team
                            if other.charged = true motion_add(point_direction(other.x,other.y,x,y),choose(1,1,1,3,4))
						}
					}
				}
			wait(1)
		}
		exit
	}
}*/

#define bolt_create(x,y)
with instance_create(x,y,CustomProjectile){
    sprite_index = global.sprHotArrow
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
    repeat(random(3+charged * 4))with instance_create(x,y,Flame){
        team = other.team
        creator = other.creator
        motion_set(other.direction + choose(-30,30) * choose(0,1,1,1) + random_range(-8,8), random(3)+ 3)
    }
}

#define bolt_end_step
var hitem = 0
if skill_get(mut_bolt_marrow){
    var q = mod_script_call_nc("mod","defpack tools","instance_nearest_matching_ne",x,y,hitme,"team",team)
    if instance_exists(q) and distance_to_object(q) < 10 {
        x = q.x - hspeed_raw
        y = q.y - vspeed_raw
        hitem = 1
    }
}
with instance_create(x,y,BoltTrail){
    image_xscale = point_distance(x,y,other.xprevious,other.yprevious)
    image_angle = point_direction(x,y,other.xprevious,other.yprevious)
    image_blend = c_red
    if fork(){
        while instance_exists(self){
            image_blend = merge_color(image_blend,c_yellow,.3*current_time_scale)
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
repeat(4+random(charged*10)){
    with instance_create(x,y,Flame){
        team = other.team
        creator = other.creator
        motion_set(other.direction + random_range(-20,20), random(3)+ 3)
    }
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
    instance_create(x+hspeed,y+vspeed,Explosion)
    sound_play(sndExplosion)
}
else
{
  instance_create(x+hspeed,y+vspeed,SmallExplosion)
  sound_play(sndExplosionS)
}

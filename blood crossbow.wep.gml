#define init
global.sprBloodCrossbow = sprite_add_weapon("sprites/weapons/sprBloodCrossbow.png", 6, 5);
global.sprBloodBolt = sprite_add("sprites/projectiles/sprBloodBolt.png",0, 2, 3);

#define weapon_name
return "BLOOD CROSSBOW"

#define weapon_sprt
return global.sprBloodCrossbow;

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_type
return 3;

#define weapon_auto
return true;

#define weapon_load
return 24;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 10;

#define weapon_text
return "NOTHING GOES TO WASTE";

#define nts_weapon_examine
return{
	"melting": "There is no peace for this creature. ",
    "d": "A crossbow made out of the remains of a Scorpion. #The bones regrow in a fleshy compartment. ",
}
#define step(p)
if ammo[weapon_type()] < weapon_cost(){
    if (p and button_pressed(index, "fire")) or (!p and race = "steroids" and button_pressed(index, "spec")){
        projectile_hit(self, 1)
        lasthit = [global.sprBloodCrossbow,"Blood Crossbow"]
        sound_play(sndBloodHurt);
        ammo[weapon_type()] += weapon_cost()
    }
}

#macro max_ang 10

#define weapon_fire
var _p = random_range(.8,1.2)
sound_play_pitchvol(sndHeavyCrossbow,.8*_p,.6)
sound_play_pitchvol(sndBloodHammer,1.2*_p,.6)
weapon_post(5,-40,0)

var _i = -max_ang;
repeat(3){
	with instance_create(x,y,CustomProjectile){
		team = other.team
		check = 0
		creator = other
		motion_add(other.gunangle + _i * other.accuracy,18)
		if _i = 0 speed += 6;
		image_angle = direction
		sprite_index = global.sprBloodBolt
		mask_index   = mskBolt
		damage = 10
	    bounce = round(skill_get("compoundelbow") * 5)
		with instance_create(x+hspeed*1.5,y+vspeed*1.5,BloodStreak){image_angle = other.direction}
		on_end_step = b_step
		on_wall     = b_wall
		on_hit      = b_hit
		on_destroy  = b_destroy
	}
	_i += max_ang;
}

#define b_hit
var i = other
projectile_hit(other, damage, 4, direction)
if other.my_health > damage {
    with instance_create(x,y,BoltStick){
        target = i
        sprite_index = other.sprite_index
        image_angle = other.image_angle
    }
    with other direction += 180
    instance_destroy()
}

#define b_wall
	if bounce > 0{
		bounce--
		move_bounce_solid(false)
		image_angle = direction
		sound_play_pitch(sndBoltHitWall,random_range(.9, 1.1))
		instance_create(x, y, Dust)
		view_shake_at(x, y, 3)
		sound_play_pitchvol(sndBloodLauncherExplo,random_range(1.3 , 1.5), .4)
		with instance_create(x,y,MeatExplosion) team = other.team
		with instance_create(x + hspeed, y + vspeed, BloodStreak){image_angle = other.direction}
	}
	else {
		
		with instance_create(x + hspeed, y + vspeed, CustomObject){
		sound_play(sndBoltHitWall)
		instance_create(x,y,Dust)
		sprite_index = other.sprite_index
		image_angle = other.image_angle
		life = 30
		on_step = o_step
		}
		instance_destroy()
	}

#define o_step
if life > 0 life -= current_time_scale else instance_destroy()

#define b_destroy
view_shake_at(x, y, 7)
var _offset = random(360)
repeat(3)
{
  with instance_create(x + lengthdir_x(12, direction - 180 + _offset), y + lengthdir_y(12, direction - 180 + _offset), BloodStreak){image_angle = other.direction - 180 + _offset}
  _offset += 120;
}
sleep(10)
sound_play_hit(sndBloodLauncherExplo,.1)
with instance_create(x,y,MeatExplosion) team = other.team

#define b_step
var hitem = 0
if skill_get(mut_bolt_marrow){
    var q = mod_script_call_nc("mod","defpack tools","instance_nearest_matching_ne",x,y,hitme,"team",team)
    if instance_exists(q) and point_distance(q.x,q.y, x, y) < 24 {
        x = q.x - hspeed_raw
        y = q.y - vspeed_raw
        hitem = 1
    }
}
with instance_create(x, y, BoltTrail) {
    image_xscale = point_distance(x, y, other.xprevious, other.yprevious)
    image_angle = point_direction(x, y, other.xprevious, other.yprevious)
    image_blend = c_red
}
if hitem with q with other b_hit()

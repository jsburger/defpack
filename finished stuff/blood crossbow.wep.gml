#define init
global.sprBloodCrossbow = sprite_add_weapon("sprBloodCrossbow.png", 6, 5);
global.sprBloodBolt = sprite_add("sprBloodBolt.png",0, 2, 3);

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
return 21;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 7;

#define weapon_text
return choose("BONE LAUNCHER","THE BONE ZONE");

#define weapon_fire
if infammo = 0{
	if ammo[3] - 1 < 0{
		ammo[3] = 0;
		sprite_index = spr_hurt;
		image_index = 0;
		my_health --;
		sound_play(sndBloodHurt);
		lasthit = [global.sprBloodCrossbow,"Blood Crossbow"]
		sound_play(snd_hurt);
	}
	else
	{
		ammo[3] -= 1
	}
}
var _p = random_range(.8,1.2)
sound_play_pitchvol(sndHeavyCrossbow,.8*_p,.6)
sound_play_pitchvol(sndBloodHammer,1.2*_p,.6)
weapon_post(5,-40,0)
with instance_create(x,y,CustomProjectile)
{
	team = other.team
	check = 0
	creator = other
	motion_add(other.gunangle,20)
	image_angle = direction
	sprite_index = global.sprBloodBolt
	mask_index   = mskBolt
	damage = 17
	with instance_create(x+hspeed*1.5,y+vspeed*1.5,BloodStreak){image_angle = other.direction}
	on_end_step    = b_step
	on_wall    = b_wall
	on_hit     = b_hit
	on_destroy = b_destroy
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
    instance_destroy()
}

#define b_wall
var i = other;
with instance_create(x+hspeed,y+vspeed,CustomObject)
{
	sound_play(sndBoltHitWall)
	instance_create(x,y,Dust)
	sprite_index = other.sprite_index
	image_angle = other.image_angle
	life = 30
	on_step = o_step
}
instance_destroy()

#define o_step
if life > 0 life -= current_time_scale else instance_destroy()

#define b_destroy
sound_play_hit(sndBloodLauncherExplo,.1)
with instance_create(x,y,MeatExplosion) team = other.team

#define b_step
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
}
if hitem with q with other b_hit()

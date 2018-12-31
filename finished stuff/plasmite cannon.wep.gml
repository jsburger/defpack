#define init
global.sprPlasmiteCannon = sprite_add_weapon("sprPlasmiteCannon.png",0,1)
global.sprPlasmiteBig = sprite_add("sprPlasmiteBig.png",0,9,9)

#define weapon_name
return "PLASMITE CANNON"
#define weapon_sprt
return global.sprPlasmiteCannon;
#define weapon_type
return 5
#define weapon_cost
return 4
#define weapon_area
return 8
#define weapon_load
return 43
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return 1
#define weapon_laser_sight
return 0
#define weapon_text
return "HEH";
#define weapon_fire

weapon_post(7,12,32+skill_get(17)*12)
if !skill_get(17)
{
	sound_play_pitch(sndPlasmaHuge,2)
	sound_play_pitch(sndPlasmaMinigun,random_range(1.3,1.45))
}
else
{
	sound_play_pitch(sndPlasmaHugeUpg,2)
	sound_play_pitch(sndPlasmaMinigunUpg,random_range(1.3,1.45))
}
with instance_create(x,y,CustomProjectile)
{
	name = "plasmite cannon"
	move_contact_solid(other.gunangle,12)
	creator = other
	team = other.team
	image_speed = 0
	image_index = 0
	damage = 12+skill_get(17)*6
	sprite_index = global.sprPlasmiteBig
	fric = random_range(1.01,1.012)
	motion_set(other.gunangle+random_range(-6,6)*other.accuracy,3)
	image_angle = direction
	speedset = 0
	ammo = 8
	accuracy = other.accuracy
	on_step 	 = atom_step
	on_wall 	 = mb_wall
	on_destroy   = atom_destroy
	on_draw 	 = atom_draw
	on_square    = script_ref_create(atom_square)
	repeat(6){create_electron()}
}

#define atom_square
    ammo += 5*other.size
    repeat(5*other.size){
        create_electron()
    }
    repeat(3*other.size) with instance_create(x,y,PlasmaTrail){image_index = 0;image_speed = .5;motion_add(other.direction+random_range(-140,140),random_range(9,12))}
    repeat(8*other.size){
        with mod_script_call("mod","defpack tools","create_plasmite",x,y)
        {
            creator = other.creator
            team = other.team
            motion_add(other.direction+random_range(-140,140),random_range(16,20))
            image_angle = direction
        }
    }
    sound_play_pitch(sndPlasmaHit,random_range(.9,1.1))
    with instance_create(x,y,PlasmaImpact){team = other.team;instance_create(x+random_range(-8,8),y+random_range(-8,8),Smoke)}
    with other{
        instance_destroy()
        exit
    }



#define create_electron()
var _a = instance_create(x,y,CustomProjectile)
with _a
{
	creator = other
	team = other.team
	image_speed = 0
	image_index = 0
	damage = 2+skill_get(17)
	sprite_index = sprPlasmaTrail
	fric = random_range(.1,.2)
	motion_set(other.direction+random_range(-30,30),random_range(12,19))
	speedset = 1
	maxspeed = 7
	radius = random_range(.6,1)
	target = other
	on_step 	 = mbs_step
	on_wall 	 = mb_wall
	on_destroy = mb_destroy
}
return _a;

#define atom_step
image_angle = direction
var _scl = random_range(.8,1.2);
image_xscale = _scl
image_yscale = _scl
if irandom(9) = 1
{
	with instance_create(x+random_range(-6,6),y+random_range(-6,6),PlasmaImpact){image_xscale=.5;depth=other.depth;image_yscale=.5;damage-=1;with Smoke if place_meeting(x,y,other) instance_destroy()}
}
if irandom(4-skill_get(17))=1{with instance_create(x+random_range(-12,12),y+random_range(-12,12),GunGun){image_index=2-skill_get(17)}}
speed /= fric
if speed < 1.00005{instance_destroy()}

#define atom_draw

draw_self()
draw_set_blend_mode(bm_add)
draw_sprite_ext(sprite_index, image_index, x, y,  (1.5+skill_get(17))*image_xscale, (1.5+skill_get(17))*image_yscale, image_angle, image_blend, 0.1+skill_get(17)*.025);
draw_set_blend_mode(bm_normal)

#define atom_destroy
sleep(50)
view_shake_at(x,y,12)
sound_play_pitch(sndPlasmaBigExplodeUpg,random_range(1.2,1.4))
instance_create(x,y,PlasmaImpact)
var i = random(360);
repeat(ammo)
{
	with mod_script_call("mod","defpack tools","create_plasmite",x,y)
	{
		fric = random_range(.06,.08) + .08
		motion_set(i+random_range(-12,21)*other.accuracy,16)
		projectile_init(other.team,other.creator)
		image_angle = direction
	}
	i += 360/ammo
}

#define mb_wall
instance_destroy()

#define mb_destroy
sound_play_pitch(sndPlasmaHit,random_range(1.55,1.63))
with instance_create(x,y,PlasmaImpact){image_xscale=.5;image_yscale=.5;damage = round(damage/2);team = other.team}

#define mb_step
image_angle = direction
if irandom(12-skill_get(17)*5) = 1{instance_create(x,y,PlasmaTrail)}
if speedset = 0
{
	speed/= fric
	if speed < 1.00005{speedset = 1}
}
else
{
	if instance_exists(enemy)
	{
		var closeboy = instance_nearest(x,y,enemy)
		if distance_to_object(closeboy) < 70
		motion_add(point_direction(x,y,closeboy.x,closeboy.y),.5+skill_get(17)*.3)
	}
	if speed > maxspeed{speed = maxspeed}
	maxspeed /= fric
	if maxspeed <= fric instance_destroy()
}


#define mbs_step
move_bounce_solid(false)
if irandom(12-skill_get(17)*5) = 1{instance_create(x,y,PlasmaTrail)}
if speedset = 0
{
	move_bounce_solid(false)
	speed/= fric
	if speed < 1.00005{speedset = 1}
}
else
{
	if instance_exists(target)
	{
		motion_add(point_direction(x,y,target.x,target.y),radius)
		if speed > maxspeed{speed = maxspeed}
		image_angle = direction
	}
	else instance_destroy()
}

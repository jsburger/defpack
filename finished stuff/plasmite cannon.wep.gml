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
	timer = 30 * (6 + skill_get(mut_laser_brain) * 2)
	damage = 8
	sprite_index = global.sprPlasmiteBig
	mask_index   = mskBullet1
	fric = 1.02 - skill_get(mut_laser_brain) * .01
	motion_set(other.gunangle+random_range(-2,2)*other.accuracy,3)
	image_angle = direction
	speedset = 0
	ammo = 6
	defbloom = {
        xscale : 1.5+skill_get(mut_laser_brain),
        yscale : 1.5+skill_get(mut_laser_brain),
        alpha : .1 + skill_get(mut_laser_brain) * .025
    }
	accuracy = other.accuracy
	on_step 	 = atom_step
	on_wall 	 = mb_wall
	on_destroy   = atom_destroy
	on_square    = script_ref_create(atom_square)
	repeat(2){with create_electron(){radius = 1.2}}
	repeat(3){with create_electron(){radius = 1.5}}
	repeat(5){with create_electron(){radius = 2}}
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
	name ="electron"
	defbloom = {
        xscale : 2+skill_get(mut_laser_brain),
        yscale : 2+skill_get(mut_laser_brain),
        alpha : .1 + skill_get(mut_laser_brain) * .025
    }
	creator = other
	team = other.team
	image_speed = 0
	image_index = 0
	damage = 3+skill_get(17)
	sprite_index = sprPlasmaTrail
	mask_index   = sprAllyBullet
	fric = random_range(.1,.2)
	motion_set(other.direction+random_range(-40,40),random_range(12,19))
	speedset = 1
	maxspeed = 12
	radius = 3
	target = other
	on_step 	 = mbs_step
	on_hit     = mbs_hit
	on_wall 	 = mbs_wall
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
timer -= current_time_scale
if timer <= 0{instance_destroy()}
//if speed < 1.00005{instance_destroy()}

#define mbs_hit
if projectile_canhit_melee(other) = true
{
	projectile_hit(other,damage,12,direction)
}

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
with instance_create(x, y, PlasmaImpact)
{
	team = other.team;
	creator = other.creator;
}
sound_play_pitch(sndPlasmaHit, random_range(.9, 1.1))
view_shake_at(x, y, 4)
sleep(10)
instance_destroy()
/*move_bounce_solid(false)
speed += 2
fric *= 1.005
*/

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
if irandom(10-skill_get(17)*4) = 1{instance_create(x,y,PlasmaTrail)}
if speedset = 0
{
	//move_bounce_solid(false)
	speed/= fric
	if speed < 1.00005{speedset = 1}
}
else
{
	if instance_exists(target)
	{
		motion_add(point_direction(x,y,target.x,target.y)+random_range(-4,4),radius)
		if speed > maxspeed{speed = maxspeed}
		image_angle = direction
	}
	else instance_destroy()
}

#define mbs_wall
move_bounce_solid(false)

#define init
global.sprVectorRifle   = sprite_add_weapon("sprVectorRifle.png",2,2)
global.sprVectorHead 	  = sprite_add("sprVectorHead.png",0,8,2)
global.sprVector	      = sprite_add("sprVector.png",0,2,3)
global.sprVectorImpact  = sprite_add("sprVectorImpact.png",7,16,16)
global.sprVectorBeamEnd = sprite_add("sprVectorBeamEnd.png",3,5,5);

#define weapon_name
return "VECTOR RIFLE"
#define weapon_type
return 5
#define weapon_cost
return 2
#define weapon_area
return 11
#define weapon_load
return 36
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_reloaded
if !button_check(index,"fire")
{
	sound_play_pitchvol(sndIDPDNadeAlmost,.5,.2)
	sound_play_pitchvol(sndPlasmaReload,1.4,.4)
}
#define weapon_fire
motion_add(gunangle-180,3)
repeat(3)instance_create(x,y,Smoke)
weapon_post(7,0,23)
if skill_get(17) = true
{
	var _pitch = random_range(.85,1.15)
	sound_play_pitchvol(sndDevastatorUpg,3*_pitch,.7)
	sound_play_pitch(sndEnergyHammerUpg,1.2*_pitch)
	sound_play_pitch(sndLaser,.5*_pitch)
}
else
{
	var _pitch = random_range(.85,1.15)
	sound_play_pitchvol(sndDevastator,3*_pitch,.6)
	sound_play_pitch(sndEnergyHammerUpg,1.2*_pitch)
	sound_play_pitch(sndLaser,.7*_pitch)
}
with create_psy_laser(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle)){
	pierce = 25+skill_get(17)*15
	lspeed = 12
	team = other.team
	creator = other
	image_angle = other.gunangle+random_range(-9,9)*creator.accuracy
	langle = image_angle
	image_xscale = lspeed/2
}

#define weapon_sprt
return global.sprVectorRifle
#define weapon_text
return "pointy"

return a

#define create_psy_laser(_x,_y)
var a = instance_create(_x,_y,CustomProjectile)
with a{
	loss = .08-skill_get(17)*.04
	pierce = 1
	damage = 3
    langle = 0
	lspeed = 10-skill_get(17)*4
	sprite_index = global.sprVector
	mask_index = mskLaser
	on_step = script_ref_create(laserstep)
	on_hit = script_ref_create(laserhit)
	on_wall = script_ref_create(nothing)
	on_draw = hyperdraw
	image_yscale = 1.5
	ammo = 1
}
return a

#define nothing
with instance_create(x+lengthdir_x(-12,image_angle),y+lengthdir_y(-12,image_angle),PlasmaImpact){
	sound_play(sndPlasmaHit)
	creator = other.creator
	team = other.team
	sprite_index = global.sprVectorImpact
}
repeat(irandom_range(6,8)){instance_create(x+lengthdir_x(random_range(1,5),image_angle-180),y,Smoke)}
instance_destroy()

#define laserstep
if ammo > 0 {
	var _s = choose(random_range(-10,-4),random_range(4,10))
	var s_ = choose(random_range(-10,-4),random_range(4,10))
	ammo-=current_time_scale
	if ammo<=0{
        if irandom(4-skill_get(17)) < current_time_scale with instance_create(x+s_,y+_s,BulletHit)
        {
            sprite_index = global.sprVectorBeamEnd
            image_angle = other.image_angle
            motion_add(other.image_angle,choose(1,2))
        }
        var ang = langle;
        if instance_exists(enemy){
            var near = instance_nearest(x,y,enemy);
            //consider removing the distance cap, it wasnt in the original, but it helps with the projectile being aimable
            if distance_to_object(near) < 120 && !collision_line(x,y,near.x,near.y,Wall,0,0){
                var dir = angle_difference(ang,point_direction(x,y,near.x,near.y));
                //i also changed this
                if abs(dir) < 45 {
                    var cap = 45;
                    ang -= clamp(dir,-cap,cap)
                }
            }
        }
        var _x = x+lengthdir_x(lspeed,ang), _y = y+lengthdir_y(lspeed,ang);
        with create_psy_laser(_x,_y){
            lspeed = other.lspeed
            image_xscale = lspeed/2
            pierce = other.pierce
            creator = other.creator
            langle = other.langle
            team = other.team
            image_angle = ang
            if place_meeting(x,y,Wall) ammo = 0
        }
        pierce = 0
    }
}
image_yscale-=loss*current_time_scale
if image_yscale <= 0 instance_destroy()


#define hyperdraw
draw_self()
draw_set_blend_mode(bm_add)
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, 2.5*image_yscale, image_angle, image_blend, 0.1+skill_get(17)*.025);
draw_set_blend_mode(bm_normal)
if ammo > 0
{
	draw_sprite_ext(global.sprVectorHead, 0, x, y, 2, 2, image_angle-45, image_blend, 1);
	draw_set_blend_mode(bm_add)
	draw_sprite_ext(global.sprVectorHead, 0, x, y, 3, 3, image_angle-45, image_blend, 0.1+skill_get(17)*.025);
	draw_set_blend_mode(bm_normal)
}

#define laserhit
if projectile_canhit_melee(other){
    pierce -= other.size
    instance_create(other.x,other.y,Smoke)
    projectile_hit(other,damage,lspeed/other.size,image_angle)
}
if pierce<=0 && ammo{
    with instance_create(x,y,PlasmaImpact){
        sound_play(sndPlasmaHit)
        creator = other.creator
        team = other.team
        sprite_index = global.sprVectorImpact
    }
    instance_destroy()
}

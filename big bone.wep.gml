#define init
global.sprBone = sprite_add_weapon("sprites/sprMegaBone.png",8,6)
global.mskBone = sprite_add_weapon("sprites/mskMegaBoneUpg.png",28,6)

#define weapon_name
return "BIG BONE"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return 23;
#define weapon_load
return 15
#define weapon_swap
return sndSwapHammer
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
sound_play_pitch(sndHammer,random_range(1.3,1.6))
sound_play_pitch(sndBloodHammer,random_range(1,1.6))
var length = 14 + 20*skill_get(13)
weapon_post(-length,6,0)
with instance_create(x+lengthdir_x(length,gunangle),y+lengthdir_y(length,gunangle)+2,CustomSlash){
	sprite_index = sprShank
	image_alpha = 0
	damage = 146
	if skill_get(13) = true mask_index = global.mskBone else mask_index = global.sprBone
	image_speed = .4
	creator = other
	team = other.team
	hit = 0
	image_angle = other.gunangle
	direction = image_angle
	canfix = false
	with instance_create(x,y,BloodStreak){
		image_angle = other.image_angle
		image_xscale = 1
	}
	on_grenade = bone_grenade
	on_projectile = bone_projectile
	on_destroy = bone_destroy
	on_hit = bone_hit
	on_wall = bone_wall
	on_anim = bone_anim
}

#define weapon_sprt
return global.sprBone

#define weapon_text
return "UNHOLY"

#define bone_wall
speed = 0

#define bone_destroy
if !hit with creator if instance_is(self,hitme){
    projectile_hit(self,4)
    lasthit = [global.sprBone,"BIG BONE"]
}

#define bone_projectile
with other if typ > 0 instance_destroy()

#define bone_grenade
with other instance_destroy()

#define bone_anim
instance_destroy()

#define bone_hit
hit = 1
sound_play_pitchvol(sndHammerHeadEnd,random_range(1.33,1.43),20)
sound_play_pitch(sndGruntHurtF,.8)
sound_play_pitch(sndBigDogHit,2)
sound_play_pitchvol(sndCursedPickup,2,20)
projectile_hit(other,damage,40,direction)
view_shake_at(x,y,100)
sleep(300)
sound_play_pitch(sndBloodCannon,1.2+random(.1))
repeat(200){
    with instance_create(other.x,other.y,Dust){
        var dir = random_range(-15,15)
        dir = min(sqr(dir),120) * sign(dir)
        motion_set(other.direction + dir,sqr(random_range(2,4)))
    }
}
for (var o = -3; o <= 3; o++){
    for (var i = 2; i <= 6 - abs(o); i++){
        with instance_create(x+lengthdir_x(24*i, direction + 30*o),y+lengthdir_y(24*i, direction + 30*o), MeatExplosion){
            creator = other.creator
            damage*= 2
            team = other.team
            if !place_meeting(x,y,Floor) instance_destroy()
        }
    }
}
instance_destroy()

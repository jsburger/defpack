#define init
global.sword = sprite_add_weapon("bigsword.png",4,10)
global.slash = sprite_add("bigslash.png",4,36,36)
while 1{
    with Player epicstep()
    wait(0)
}
#define weapon_name
return "MEGA HAMMER"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return 11
#define weapon_load
if instance_is(self,Player){
	if "bigsword" in self{
		return max(15 - .8*bigsword,4.5)
	}
}
return 15
#define weapon_swap
return sndSwapSword
#define weapon_auto
return 1
#define weapon_melee
return 1
#define weapon_laser_sight
return 0
#define weapon_reloaded
wepflip *= -1

#define weapon_fire
if "bigsword" not in self{
	bigsword = 1
	bigcooldown = 0
}
bigsword = ++bigsword mod (30 *(1+(skill_get(mut_long_arms)*1)))
bigcooldown = 35
nexthurt = current_frame + 2
sound_play_pitch(sndHammer,1 + bigsword*.008)
with instance_create(x,y,CustomSlash){
	sprite_index = global.slash
	team = other.team
	image_angle = other.wepangle + other.gunangle
	motion_set(other.gunangle,3+other.bigsword/5)
	on_step = coolstep
	on_destroy = cooldie
	on_hit = coolhit
	rotspeed = 2 * other.bigsword
	damage = 8
	force = 8
	image_speed = .6
	creator = other
}
for (var i = 0; i <= bigsword/2; i++){
	with instance_create(x,y,Dust){
		motion_set(other.wepangle + other.gunangle - 40*i + random_range(-20,20),random_range(1,3))
		move_contact_solid(direction,20)
	}
}
if bigsword < 1{
	with instance_create(x,y,ThrownWep){
		team = other.team
		creator = other
		motion_set(other.gunangle, 15)
		sound_play(sndChickenThrow)
		curse = other.curse
		wep = other.wep
		sprite_index = weapon_sprt()
		damage = 20
	}
	wep = bwep
	bwep = 0
	curse = bcurse
	bcurse = 0
}
#define coolhit
if projectile_canhit_melee(other){
	projectile_hit(other,damage,force,direction)
}
#define cooldie
with creator{
    sprite_angle = 0
}
#define coolstep
image_angle -= rotspeed*current_time_scale
with creator{
    nexthurt = current_frame + 2
	wepangle = other.image_angle - 60 - other.direction - 2*other.rotspeed
	sprite_angle = wepangle + 180
	motion_set(other.direction,other.speed_raw)
}
#define epicstep
if "bigcooldown" in self{
    bigcooldown -= current_time_scale
    if bigcooldown <= 0 && bigsword > 0{
        bigsword = max(bigsword - current_time_scale, 0)
        if random(100) < 100*current_time_scale{
            instance_create(x,y,Sweat)
        }
    }
    if bigcooldown < current_time_scale && bigcooldown >= 0{
        wepangle = 120 * sign(wepangle)
        bwepangle = 120 * sign(bwepangle)
        sound_play(sndMeleeFlip)
    }
}

#define weapon_sprt
return global.sword
#define weapon_text
return "A HEFTY SWING"

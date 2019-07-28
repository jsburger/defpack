#define init
global.sprCrystalTorch[0] = sprite_add_weapon("sprites/weapons/sprCrystalTorch1.png",6,10)
global.sprCrystalTorch[1] = sprite_add_weapon("sprites/weapons/sprCrystalTorch2.png",6,10)
global.sprCrystalTorch[2] = sprite_add_weapon("sprites/weapons/sprCrystalTorch3.png",6,10)
global.sprCrystalTorch[3] = sprite_add_weapon("sprites/weapons/sprCrystalTorch4.png",6,10)
global.sprCrystalTorch[4] = sprite_add_weapon("sprites/weapons/sprCrystalTorch5.png",6,10)
global.sprNegaCurse = sprite_add("sprites/other/sprNegaCurse.png",6,4,4);

global.reloads = [16,18,20,22,24]
global.cursed  = [InvCrystal,InvLaserCrystal,InvSpider]
global.uncursed= [CrystalProp,LaserCrystal,Spider]

while 1 {
    with WepPickup if instance_is(self,WepPickup){
        if weapon_find(wep) == mod_current{
            if !is_object(wep){
                wep = {
                    wep : mod_current,
                    cursecharge: 0,
                    torchid: irandom(10000)
                }
            }
            if current_frame_active{
                var q = weapon_get_deepest(wep)
                var radius = 40 + q.cursecharge/2
                for var i = 0; i < 360; i += random_range(20, 40){
                    with instance_create(x+lengthdir_x(radius, i), y + lengthdir_y(radius, i), Curse){
                        image_xscale /= 2
                        image_yscale /= 2
                        sprite_index = global.sprNegaCurse
                    }
                }
                for var i = 0; i < array_length(global.cursed); i++{
                    with global.cursed[i] if point_distance(x,y,other.x,other.y) <= radius{
                        var hp = my_health
                        with instance_create(x,y,global.uncursed[i]) my_health = hp
                        q.cursecharge += 6
                        puff()
                        instance_delete(self)
                    }
                }
                with Player if curse or bcurse{
                    if point_distance(x,y,other.x,other.y) <= radius{
                        if curse{
                            q.cursecharge += 2
                            curse = 0
                        }
                        if bcurse{
                            bcurse = 0
                            q.cursecharge += 2
                        }
                        puff()
                    }
                }
                with instances_matching(Wall, "sprite_index", sprWall104Bot){
                    if distance_to_object(other) <= radius{
                        sprite_index = sprWall4Bot
                        topspr = sprWall4Top
                        outspr = sprWall4Out
                        q.cursecharge += 1
                        break
                    }
                }
                with instances_matching(TopSmall, "sprite_index", sprWall104Trans){
                    if distance_to_object(other) <= radius{
                        sprite_index = sprWall4Trans
                        break
                    }
                }
                with instances_matching(Floor, "sprite_index", sprFloor104, sprFloor104B){
                    if distance_to_object(other) <= radius - 8{
                        sprite_index = sprite_index = sprFloor104 ? sprFloor4 : sprFloor4B
                        break
                    }
                }
            }
        }
    }
    wait(0)
}

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define puff
repeat(irandom_range(2,4)){
    with instance_create(x,y,Curse){
        sprite_index = global.sprNegaCurse
        gravity = -.1
        friction = .1
        motion_set(random(360), random(2))
        depth = -3
    }
}

#define weapon_find(w)
if is_object(w){
    if is_string(w.wep){
        if mod_script_exists("weapon",w.wep,"weapon_wep") return weapon_find(lq_get(w, mod_script_call_nc("weapon", w.wep, "weapon_wep", w)))
    }
    return weapon_find(w.wep)
}
return w

#define weapon_get_deepest(w)
if is_object(w) and !is_object(w.wep) return w
return weapon_get_deepest(w.wep)

#define weapon_mergable
return 0

#define weapon_sprt(w)
if is_object(w){
    return global.sprCrystalTorch[min(floor(w.cursecharge/10),4)]
}
return global.sprCrystalTorch[0];

#define weapon_text
return choose("ILLUMINATE","PURGE")

#define weapon_name
return "CRYSTAL TORCH"

#define weapon_type
return 0

#define weapon_cost
return 0

#define weapon_area
if GameCont.crown = 11
    return 6
return -1

#define weapon_load(w)
if is_object(w){
    return global.reloads[min(floor(w.cursecharge/10),4)]
}
return global.reloads[4];

#define weapon_swap
return sndSwapHammer
#define weapon_auto
return 0
#define weapon_melee
return 1
#define weapon_laser_sight
return 0

#define weapon_fire(w)
if !is_object(w){
    wep = {
        wep: w,
        cursecharge: 0,
        torchid: irandom(10000)
    }
}
else if "cursecharge" not in wep{
    wep.cursecharge = 0
    wep.torchid = irandom(10000)
}
w = wep

sound_play_pitch(sndLaserCrystalHit,random_range(.6,.8))
sound_play_pitch(sndWrench,random_range(.8,1.2))
weapon_post(-7,0,14)
motion_set(gunangle,4)
with instance_create(x,y,CustomSlash)
{
    sprite_index = sprSlash
    mask_index = mskSlash
    torchid = w.torchid
	lv = min(floor(w.cursecharge/10),4) + 1
	damage = lv * 4
	if lv >= 3 sprite_index = sprHeavySlash
	if lv = 5 {
		sprite_index = sprMegaSlash
		mask_index  = mskMegaSlash
	}
	name = "crystal slash"
	motion_add(other.gunangle, 1 + (skill_get(13) * 2))
	image_speed = .4
	walled = 0

	projectile_init(other.team,other)
	image_angle = direction
	on_hit = torchhit
	on_wall = torchwall
	on_projectile = torchproj
	on_grenade = torchproj
}
wepangle *= -1

#define torchproj
with other{
    if typ = 1{
        team = other.team
        direction = other.direction
        image_angle = direction
        with instance_create(x,y,Deflect){
            image_angle = other.direction
        }
    }
    if typ > 1 instance_destroy()
}

#define torchwall
if !walled sound_play(sndMeleeWall)
walled = 1


#define torchhit
if projectile_canhit_melee(other){
	projectile_hit(other,damage,lv*2,direction)
	var cursechange = -.25;

    for var i = 0; i < array_length(global.cursed); i++{
        if instance_is(other,global.cursed[i]){
            with other{
                var hp = my_health
                puff()
                with instance_create(x,y,global.uncursed[i]) my_health = hp
                instance_delete(self)
            }
            cursechange = 6
            break
        }
    }
	with creator{
	    if is_object(wep) && wep.wep = mod_current && wep.torchid = other.torchid{
	        wep.cursecharge = clamp(wep.cursecharge + cursechange, 0, 50)
	    }
	    if is_object(bwep) && bwep.wep = mod_current && bwep.torchid = other.torchid{
	        bwep.cursecharge = clamp(bwep.cursecharge + cursechange, 0, 50)
	    }
	}
}

#define step(w)
if current_frame_active{
    var ang = gunangle + wepangle
    if w and is_object(wep) and !irandom(13 - floor(wep.cursecharge/6)) with instance_create(x + lengthdir_x(15, ang),y + lengthdir_y(15, ang),Curse){
        sprite_index = global.sprNegaCurse
        depth-= 2

    }
}
with instances_matching(CustomSlash,"name","crystal slash"){
	with BigCursedChest{
		if distance_to_object(other) <= 0{
			instance_create(x,y,BigWeaponChest)
			puff()
			instance_delete(self)
			var cursechange = 2
			with other {
			    with creator{
            	    if is_object(wep) && wep.wep = mod_current && wep.torchid = other.torchid{
            	        wep.cursecharge = clamp(wep.cursecharge + cursechange, 0, 50)
            	    }
            	    if is_object(bwep) && bwep.wep = mod_current && bwep.torchid = other.torchid{
            	        bwep.cursecharge = clamp(bwep.cursecharge + cursechange, 0, 50)
            	    }
        	    }
		    }
		}
	}
	with instances_matching_gt(WepPickup,"curse",0){
		if distance_to_object(other) <= 0{
			var cursechange = 2 * curse
			curse = 0
			puff()
			with other {
			    with creator{
            	    if is_object(wep) && wep.wep = mod_current && wep.torchid = other.torchid{
            	        wep.cursecharge = clamp(wep.cursecharge + cursechange, 0, 50)
            	    }
            	    if is_object(bwep) && bwep.wep = mod_current && bwep.torchid = other.torchid{
            	        bwep.cursecharge = clamp(bwep.cursecharge + cursechange, 0, 50)
            	    }
        	    }
		    }

		}
	}
}

#define init
global.sprWonderSword  = sprite_add_weapon("sprites/sprWonderSword.png", -2, 6);
global.sprGoldSlashBig = sprite_add("sprites/projectiles/sprGoldSlashBig.png",3,0,36)
global.sprGoldSlash    = sprite_add("sprites/projectiles/Gunhammer Slash.png",3,0,24)
//global.sprFlarefire   = sprite_add("Flarefire.png",5,10,10)

#define weapon_chrg
return 1;

#define weapon_name
return "WONDERSWORD";

#define weapon_sprt
return global.sprWonderSword;

#define weapon_type
return 0;

#define weapon_auto
return 1;

#define weapon_load
return 12;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
if UberCont.hardmode == 1 return 14
return -1;

#define weapon_text
return "@yWonder @swhat @yis @sthis sword";

#define weapon_gold
if UberCont.hardmode == 1 return 1;
return -1

#define weapon_reloaded
return -1;

#define weapon_fire
with instance_create(x, y, CustomObject){
    name = "WonderCharge"
    creator = other
    team = other.team
    hand = other.race == "steroids" and other.specfiring
    btn = other.specfiring ? "spec" : "fire"
    index = other.index
    tier = 0
    charge = 0
    charged = 0
    maxcharge = 45
    supercharge = maxcharge * 3
    var q = mod_variable_get("mod", "defpack tools", "chargeType")
    var p = {
        style: 1,
        charge: 0,
        maxcharge: maxcharge
    }
    if q == 1 or q == 3{
        defcharge = [p, lq_clone(p), lq_clone(p)]
    }
    else defcharge = p
    
    on_step = charge_step
    on_destroy = charge_destroy
}

#define charge_step
if (instance_exists(creator) and button_check(index, btn)) and !button_pressed(index, "swap"){
    var _reloads = [0, 26, 12, 32];
    if hand creator.breload = max(_reloads[tier] + 12, creator.breload)
    else creator.reload = max(_reloads[tier] + 12, creator.reload)
    if !charged{
        charge += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * current_time_scale
        charge = min(charge, maxcharge)
        var p = is_array(defcharge) ? defcharge[tier] : defcharge
        p.charge = charge
    }
    if charge >= maxcharge and !charged{
        if tier <= 2{
            tier++
            charge = 0
            creator.gunshine = 7
            with defcharge blinked = 1
            sound_play_pitch(sndSwapGold, .6 + tier * .1)
            sound_play_pitchvol(sndGoldPickup, .6 + tier * .1, .2)
            with instance_create(creator.x, creator.y - 27, CustomObject){
                image_alpha = 0
                num = other.tier
                sprite_index = sprGroundFlameBigDisappear
                motion_add(90, 2)
                friction = .2
                bimage_index = image_index
                image_speed = .45 - .05 * (other.tier + 1)
                depth = -8
                on_step = flarefire_step
                on_draw = flarefire_draw
            }
            if tier == 3{
                charged = 1
            }
        }
    }
    if charged{
        if current_frame mod 6 < current_time_scale{
            creator.gunshine = 5
            with defcharge blinked = 1
        }
    }
    creator.wepangle = (120 + 40 * power((charge + maxcharge * tier)/supercharge, 3)) * sign(creator.wepangle)
}
else instance_destroy()

#define charge_destroy
var _shakes = [12, 21, 40, 74],
    _reloads = [0, 26, 12, 32],
    _damages = [20, 28, 34, 40],
    _frames = [4, 10, 20, 70],
    _tier = tier;
with creator{
	sound_play_gun(sndBlackSword,.5,0)
	sound_play_gun(sndGoldWrench,.6,0)
	sound_play_pitch(sndGoldScrewdriver,.6)
	if _tier > 0{
    	sound_play_pitchvol(sndGoldDiscgun,.8,.4)
    	sound_play_pitch(sndEnemySlash,1.4)
    	if _tier > 1{
        	sound_play_pitch(sndIncinerator,.8)
        	if _tier > 2{
            	sound_play_pitch(sndFireShotgun,random_range(.6,.8))
            	sound_play_pitchvol(sndFlameCannonEnd,.7,.5)
        	}
    	}
	}
	
    with instance_create(x + lengthdir_x(20 * skill_get(mut_long_arms), gunangle), y + lengthdir_y(20 * skill_get(mut_long_arms), gunangle), Slash){
        if _tier > 0{
            mask_index = mskMegaSlash
            sprite_index = global.sprGoldSlashBig
        }
        else{
            mask_index = mskSlash
            sprite_index = global.sprGoldSlash
        }
        motion_set(other.gunangle, 2 + 3 * skill_get(mut_long_arms))
        image_angle = direction
        projectile_init(other.team, other)
        if _tier >= 2{
			repeat(7){
			    for var i = -1; i <= 1; i++{
			        with instance_create(x, y, Flame){
			            motion_set(other.direction + 20*i, 4)
			            move_contact_solid(direction, 65 - abs(5*i))
			            direction += random_range(-34,34)
			            projectile_init(other.team, other.creator)
			        }
			    }
			}
        }
        damage = _damages[_tier]
    }
    sleep(_frames[_tier])
    motion_add(gunangle, 4)
    weapon_post(0, 0, _shakes[_tier])
    var n = 12 + _reloads[_tier]
    if button_pressed(index, "swap") other.hand = !other.hand
    if !other.hand{
        reload = max(n, reload)
        wkick = 9
        wepangle = -120 * sign(wepangle)
    }
    else{
        breload = max(n, reload)
        bwkick = 9 * sign(bwepangle)
        bwepangle = -120 * sign(bwepangle)
    }
    
}


#define step(w)
exit
if "wondershit" not in self{
	wondershit = [0,0]
	bwondershit = [0,0]
	//charge,tier
}
if "_reload" not in self{_reload = 0}
if w {
	if _reload > 0{_reload -= current_time_scale;reload = _reload;exit}
	if button_check(index,"fire") && wondershit[1]<5{
		view_shake_max_at(x,y,wondershit[1]*2)
		if wondershit[1] = 0{wondershit[0] = 60}
		wondershit[0]+= current_time_scale*2.6
		if wondershit[1] < 4{wepangle += .75*sign(wepangle)}
		if wondershit[1] = 4{if current_frame % 4 = 0{gunshine = 5};if wondershit[0] > 40{wondershit[0] = 40}}
		if (wondershit[0] >= 45)
		{
			wondershit[0] = 0
			wondershit[1]++
				if wondershit[1] > 4{wondershit[1] = 4}
			if wondershit[1] > 1
			{
				gunshine = 7
				sound_play_pitch(sndSwapGold,.6+wondershit[1]*.1)
				sound_play_pitchvol(sndGoldPickup,.6+wondershit[1]*.1,.2)
				with instance_create(x,y-3-sprite_get_height(sprite_index),CustomObject)
				{
					image_alpha = 0
					num = other.wondershit[1] -1
					sprite_index = sprGroundFlameBigDisappear
					motion_add(90,2)
					friction = .2
					bimage_index = image_index
					image_speed = .45-.05*other.wondershit[1]
					depth = -8
					on_step = flarefire_step
					on_draw = flarefire_draw
				}
			}
		}
	}
	else if wondershit[1] >= 1
	{
		weapon_post(12,0,12)
		sleep(4)
		sound_play_gun(sndBlackSword,.5,0)
		sound_play_gun(sndGoldWrench,.6,0)
		sound_play_pitch(sndGoldScrewdriver,.6)
		_reload += 12
		var tier = wondershit[1]
		var _x = x+lengthdir_x(20*skill_get(13),gunangle);
		var _y = y+lengthdir_y(20*skill_get(13),gunangle);
		var spd = 2+3*skill_get(13);
		if tier = 1
		{
			with instance_create(_x,_y,Slash)
			{
				damage = 20
				sprite_index = global.sprGoldSlash
				mask_index 	 = mskSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
			}
		}
		else if tier = 2
		{
			weapon_post(12,0,21)
			sleep(10)
			sound_play_gun(sndBlackSword,.5,0)
			sound_play_pitchvol(sndGoldDiscgun,.8,.4)
			sound_play_gun(sndGoldWrench,.6,0)
			sound_play_pitch(sndGoldScrewdriver,.6)
			sound_play_pitch(sndEnemySlash,1.4)
			_reload += 26
			with instance_create(_x,_y,Slash){
				damage = 28
				sprite_index = global.sprGoldSlashBig
				mask_index 	 = mskMegaSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
			}
		}
		else if tier = 3
		{
			weapon_post(12,0,40)
			sleep(20)
			sound_play_gun(sndBlackSword,.5,0)
			sound_play_pitchvol(sndGoldDiscgun,.8,.4)
			sound_play_gun(sndGoldWrench,.6,0)
			sound_play_pitch(sndGoldScrewdriver,.6)
			sound_play_pitch(sndEnemySlash,1.4)
			sound_play_pitch(sndIncinerator,.8)
			_reload += 12
			with instance_create(_x,_y,Slash){
				damage = 34
				sprite_index = global.sprGoldSlashBig
				mask_index 	 = mskMegaSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
					repeat(7) with instance_create(x,y,Flame)
					{
						team = other.team
						move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction-20),other.y+lengthdir_y(60,other.direction-20)),60)
						motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
					}
					repeat(7) with instance_create(x,y,Flame)
					{
						move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(65,other.direction),other.y+lengthdir_y(65,other.direction)),65)
						team = other.team
						motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
					}
					repeat(7) with instance_create(x,y,Flame)
					{
							move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction+20),other.y+lengthdir_y(60,other.direction+20)),60)
						team = other.team
						motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
					}
			}
		}
		else if tier = 4
		{
			weapon_post(12,0,74)
			sound_play_gun(sndBlackSword,.5,0)
			sound_play_pitchvol(sndGoldDiscgun,.8,.4)
			sound_play_gun(sndGoldWrench,.6,0)
			sound_play_pitch(sndGoldScrewdriver,.6)
			sound_play_pitch(sndEnemySlash,1.4)
			sound_play_pitch(sndIncinerator,.8)
			sound_play_pitch(sndFireShotgun,random_range(.6,.8))
			sleep(70)
			sound_play_pitchvol(sndFlameCannonEnd,.7,.5)
			_reload += 32
			with instance_create(_x,_y,Slash){
				damage = 40
				sprite_index = global.sprGoldSlashBig
				mask_index 	 = mskMegaSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
				repeat(7) with instance_create(x,y,Flame)
				{
					team = other.team
					move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction-20),other.y+lengthdir_y(60,other.direction-20)),60)
					motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
				}
				repeat(7) with instance_create(x,y,Flame)
				{
					move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(65,other.direction),other.y+lengthdir_y(65,other.direction)),65)
					team = other.team
					motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
				}
				repeat(7) with instance_create(x,y,Flame)
				{
						move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction+20),other.y+lengthdir_y(60,other.direction+20)),60)
					team = other.team
					motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
				}
			}
		}
		/*if tier = 5
		{
				repeat(3){with instance_create(x,y,CustomObject){team = other.team;on_step = flare_step}}
		}*/
		wondershit = [0,0]
		wepangle = -90 * sign(wepangle)
		wkick = 9
		motion_add(gunangle,4)
	}
	else
	{
		wondershit = [0,0]
		wepangle = 90 * sign(wepangle)
	}
}



//fuck steroids
if race = "steroids" && !w{
if "_breload" not in self{_breload = 0}
	if _breload > 0{_breload -= current_time_scale;breload = _breload;exit}
	if button_check(index,"spec") && bwondershit[1]<5{
		view_shake_max_at(x,y,bwondershit[1]*2)
		if bwondershit[1] = 0{bwondershit[0] = 43}
		bwondershit[0]+= current_time_scale*2.6
		if bwondershit[1] < 4{bwepangle += .75*sign(bwepangle)}
		if bwondershit[1] = 4{if current_frame % 4 = 0{gunshine = 5};if bwondershit[0] > 40{bwondershit[0] = 40}}
		if (bwondershit[0] >= 45)
		{
			bwondershit[0] = 0
			bwondershit[1]++
				if bwondershit[1] > 4{bwondershit[1] = 4}
			if bwondershit[1] > 1
			{
				gunshine = 7
				sound_play_pitch(sndSwapGold,.6+bwondershit[1]*.1)
				sound_play_pitchvol(sndGoldPickup,.6+bwondershit[1]*.1,.2)
				with instance_create(x,y-3-sprite_get_height(sprite_index),CustomObject)
				{
					image_alpha = 0
					num = other.bwondershit[1] -1
					sprite_index = sprGroundFlameBigDisappear
					motion_add(90,2)
					friction = .2
					bimage_index = image_index
					image_speed = .45-.05*other.bwondershit[1]
					depth = -8
					on_step = flarefire_step
					on_draw = flarefire_draw
				}
			}
		}
	}
	else if bwondershit[1] >= 1
	{
		weapon_post(12,0,12)
		sleep(4)
		sound_play_gun(sndBlackSword,.5,0)
		sound_play_gun(sndGoldWrench,.6,0)
		sound_play_pitch(sndGoldScrewdriver,.6)
		_breload += 12
		var tier = bwondershit[1]
		var _x = x+lengthdir_x(20*skill_get(13),gunangle);
		var _y = y+lengthdir_y(20*skill_get(13),gunangle);
		var spd = 2+3*skill_get(13);
		if tier = 1
		{
			with instance_create(_x,_y,Slash)
			{
				damage = 20
				sprite_index = global.sprGoldSlash
				mask_index 	 = mskSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
			}
		}
		else if tier = 2
		{
			weapon_post(12,0,21)
			sleep(10)
			sound_play_gun(sndBlackSword,.5,0)
			sound_play_pitchvol(sndGoldDiscgun,.8,.4)
			sound_play_gun(sndGoldWrench,.6,0)
			sound_play_pitch(sndGoldScrewdriver,.6)
			sound_play_pitch(sndEnemySlash,1.4)
			_breload += 26
			with instance_create(_x,_y,Slash){
				damage = 28
				sprite_index = global.sprGoldSlashBig
				mask_index 	 = mskMegaSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
			}
		}
		else if tier = 3
		{
			weapon_post(12,0,40)
			sleep(20)
			sound_play_gun(sndBlackSword,.5,0)
			sound_play_pitchvol(sndGoldDiscgun,.8,.4)
			sound_play_gun(sndGoldWrench,.6,0)
			sound_play_pitch(sndGoldScrewdriver,.6)
			sound_play_pitch(sndEnemySlash,1.4)
			sound_play_pitch(sndIncinerator,.8)
			_breload += 12
			with instance_create(_x,_y,Slash){
				damage = 34
				sprite_index = global.sprGoldSlashBig
				mask_index 	 = mskMegaSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
					repeat(7) with instance_create(x,y,Flame)
					{
						team = other.team
						move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction-20),other.y+lengthdir_y(60,other.direction-20)),60)
						motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
					}
					repeat(7) with instance_create(x,y,Flame)
					{
						move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(65,other.direction),other.y+lengthdir_y(65,other.direction)),65)
						team = other.team
						motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
					}
					repeat(7) with instance_create(x,y,Flame)
					{
							move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction+20),other.y+lengthdir_y(60,other.direction+20)),60)
						team = other.team
						motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
					}
			}
		}
		else if tier = 4
		{
			weapon_post(12,0,74)
			sound_play_gun(sndBlackSword,.5,0)
			sound_play_pitchvol(sndGoldDiscgun,.8,.4)
			sound_play_gun(sndGoldWrench,.6,0)
			sound_play_pitch(sndGoldScrewdriver,.6)
			sound_play_pitch(sndEnemySlash,1.4)
			sound_play_pitch(sndIncinerator,.8)
			sound_play_pitch(sndFireShotgun,random_range(.6,.8))
			sleep(70)
			sound_play_pitchvol(sndFlameCannonEnd,.7,.5)
			_breload += 32
			with instance_create(_x,_y,Slash){
				damage = 40
				sprite_index = global.sprGoldSlashBig
				mask_index 	 = mskMegaSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				creator = other
				repeat(7) with instance_create(x,y,Flame)
				{
					team = other.team
					move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction-20),other.y+lengthdir_y(60,other.direction-20)),60)
					motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
				}
				repeat(7) with instance_create(x,y,Flame)
				{
					move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(65,other.direction),other.y+lengthdir_y(65,other.direction)),65)
					team = other.team
					motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
				}
				repeat(7) with instance_create(x,y,Flame)
				{
						move_contact_solid(point_direction(other.x,other.y,other.x+lengthdir_x(60,other.direction+20),other.y+lengthdir_y(60,other.direction+20)),60)
					team = other.team
					motion_add(point_direction(other.x,other.y,x,y)+random_range(-34,34),4)
				}
			}
		}
		/*if tier = 5
		{
				repeat(3){with instance_create(x,y,CustomObject){team = other.team;on_step = flare_step}}
		}*/
		bwondershit = [0,0]
		bwepangle = -90 * sign(bwepangle)
		bwkick = 9
		motion_add(gunangle,4)
	}
	else
	{
		bwondershit = [0,0]
		bwepangle = 90 * sign(bwepangle)
	}
}


#define flarefire_step
if image_index < bimage_index{instance_destroy();exit}
bimage_index = image_index

#define flarefire_draw
var i = 0;
var j = num/3;
repeat(num)
{
	var _rndm = random_range(-num/6,num/6)
	i++;
	draw_sprite_ext(sprite_index, image_index, x-sprite_get_width(sprite_index)*(j+1)+sprite_get_width(sprite_index)*(i), y, 1.5*image_xscale+_rndm, 1.5*image_yscale+_rndm, image_angle, image_blend, 0.3);
	draw_sprite_ext(sprite_index, image_index, x-sprite_get_width(sprite_index)*(j+1)+sprite_get_width(sprite_index)*(i), y, .8*image_xscale, .8*image_yscale, image_angle, image_blend, 1.0);
	draw_set_blend_mode(bm_add);
	draw_set_blend_mode(bm_normal);
	j -= 1/3
}

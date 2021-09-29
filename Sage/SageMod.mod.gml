#define init
	global.bind_step = noone;
#macro player_firing

	//thanks brokin
    canfire
    && can_shoot == true
    && (ammo[weapon_get_type(wep)] >= weapon_get_cost(wep) || infammo != 0)
    && (
        weapon_get_auto(wep)
        ? button_check(index, "fire")
        : (clicked == true || (button_pressed(index, "fire") && reload < 15))
    )
    && visible
    && !instance_exists(GenCont)
    && !instance_exists(LevCont)
    && !instance_exists(PlayerSit)
    && !array_length(instances_matching(CrystalShield, "creator", self))
#define draw_gui
     // Player HUD Management:
    if(instance_exists(Player) && !instance_exists(PopoScene) && !instance_exists(MenuGen)){
        if(instance_exists(TopCont) || instance_exists(GenCont) || instance_exists(LevCont)){
            var _hudFade  = 0,
                _hudIndex = 0,
                _lastSeed = random_get_seed();

             // Game Win Fade Out:
            if(array_length(instances_matching(TopCont, "fadeout", true))){
                with(TopCont){
                    _hudFade = clamp(fade, 0, 1);
                }
            }
            if(_hudFade > 0){
                 // GMS1 Partial Fix:
                try if(!null){}
                catch(_error){
                    _hudFade = min(_hudFade, round(_hudFade));
                }

                 // Dim Drawing:
                if(_hudFade > 0){
                    draw_set_fog(true, c_black, 0, 16000 / _hudFade);
                }
            }

             // Draw Player HUD:
            for(var _isOnline = 0; _isOnline <= 1; _isOnline++){
                for(var _index = 0; _index < maxp; _index++){
                    if(
                        player_is_active(_index)
                        && (_hudIndex < 2 || !instance_exists(LevCont))
                        && (player_is_local_nonsync(_index) ^^ _isOnline)
                    ){
                        var _hudVisible = false;

                         // HUD Visibility:
                        for(var i = 0; true; i++){
                            var _local = player_find_local_nonsync(i);
                            if(!player_is_active(_local)){
                                break;
                            }
                            if(player_get_show_hud(_index, _local)){
                                _hudVisible = true;
                                break;
                            }
                        }

                         // Draw HUD:
                        if(_hudVisible || _isOnline == 0){
                            if(_hudVisible){
                                var _player = player_find(_index);
                                if(instance_exists(_player)){
                                     // Rad Canister / Co-op Offsets:
                                    var _playerNum = 0;
                                    for(var i = 0; i < maxp; i++){
                                        _playerNum += player_is_active(i);
                                    }
                                    if(_playerNum <= 1){
                                        d3d_set_projection_ortho(
                                            view_xview_nonsync - 17,
                                            view_yview_nonsync,
                                            game_width,
                                            game_height,
                                            0
                                        );
                                    }
                                    else draw_set_projection(2, _index);

                                     // Draw:
                                    if(_player.race == "sage"){
										mod_script_call("race", "sage", "player_hud", _player, _hudIndex, _hudIndex % 2);
									}

                                    draw_reset_projection();
                                }
                            }
                            _hudIndex++;
                        }
                    }
                }
            }
            if(_hudFade > 0){
                draw_set_fog(false, 0, 0, 0);
            }
            random_set_seed(_lastSeed);
        }
    }

#define step
 // Bind Step:
if(!instance_exists(global.bind_step)){
	global.bind_step = script_bind_step(hitbounce_step, 0);
}
with instances_matching(Player, "race", "sage"){
  with instances_matching(projectile,"team",Player.team){
	bounce(self);
  }

  if player_firing{
  	mod_script_call("race", "sage", "fire")
  }
}

#define bounce(_proj)
with(_proj){

	if "sage_no_bounce" in self{
		exit;
	}

	if "sage_bounce" in self
	{
	  if sage_bounce > 0 && place_meeting(x + hspeed, y + vspeed, Wall) && !instance_is(self, Shank) && !instance_is(self, Slash) && !instance_is(self, BloodSlash) && !instance_is(self, EnergySlash) && !instance_is(self, EnergyShank)
	  {
		switch(object_index)
		{
		  case HyperGrenade:
		  {
			with instance_create(x - lengthdir_x(10, direction), y - lengthdir_y(10, direction),CustomProjectile)
			{
			  blessed = true
			  team    = other.team
			  creator = other.creator
			  sprite_index = mskNone
			  mask_index   = sprGrenade
			  motion_set(other.direction, 9)
			  sage_bounce = other.sage_bounce -1
			  on_wall = hypernade_wall
			  sageCheck = true
			}
			sound_play(sndExplosionS)
			instance_create(x, y, SmallExplosion)
			instance_delete(self)
			break;
		  }
		  case HyperSlug:
		  {
			with instance_create(x - lengthdir_x(10, direction), y - lengthdir_y(10, direction),CustomProjectile)
			{
			  blessed = true
			  team    = other.team
			  creator = other.creator
			  sprite_index = mskNone
			  mask_index   = sprGrenade
			  motion_set(other.direction, 9)
			  sage_bounce = other.sage_bounce -1
			  on_wall = hyperslug_wall
			  sageCheck = true
			}
			instance_delete(self)
			break;
		  }
		  case Laser:
		  {
			if "deny_bounce" not in self with instance_create(x - lengthdir_x(10, image_angle), y - lengthdir_y(10, image_angle),CustomProjectile)
			{
			  blessed = true
			  team = other.team
			  creator = other.creator
			  sprite_index = mskNone
			  mask_index   = sprMapDot
			  motion_add(other.image_angle, 9)
			  image_yscale = other.image_yscale
			  sage_bounce = other.sage_bounce -1
			  on_wall = laser_wall
			  sageCheck = true
			}
			deny_bounce = true
			break;
		  }
		  case BloodGrenade:
		  {
			sound_play_pitchvol(sndBloodHammer, random_range(1, 1.4), .6)
			sage_bounce--
			sleep(2)
			move_bounce_solid(false)
			with instance_create(x, y, BloodStreak){image_angle = other.direction}
			speed *= 1.2
			direction += random_range(-15, 15);
			image_angle = direction
			break;
		  }
		  case Grenade: case HeavyNade: case UltraGrenade: case ClusterNade: case ConfettiBall:
		  {
			sound_play_pitch(sndGrenadeHitWall, 1)
			sound_play_pitch(sndBouncerBounce, random_range(.8, 1.2))
			sage_bounce--
			sleep(5)
			view_shake_at(x, y, 2)
			move_bounce_solid(false)
			image_angle = direction
			instance_create(x, y, Dust)
			speed *= 1.2
			friction *= 1.2
			direction += random_range(-7, 7);
			image_angle = direction
			break;
		  }
		  case ConfettiBall:
		  {
			sound_play_pitch(sndBouncerBounce, random_range(.8, 1.2))
			sage_bounce--
			sleep(30)
			move_bounce_solid(false)
			image_angle = direction
			instance_create(x, y, Dust)
			repeat(6) with instance_create(x, y, Confetti){motion_add(random(360), random_range(4, 7))}
			speed *= 1.2
			friction *= 1.2
			direction += random_range(-7, 7);
			image_angle = direction
			break;
		  }
		  case ToxicGrenade:
		  {
			sound_play_pitch(sndGrenadeHitWall, 1)
			sound_play_pitch(sndBouncerBounce, random_range(.8, 1.2))
			sound_play_pitchvol(sndToxicBoltGas, 1.3, .7)
			sage_bounce--
			sleep(5)
			view_shake_at(x, y, 2)
			move_bounce_solid(false)
			image_angle = direction
			with instance_create(x, y, AcidStreak){image_angle = other.direction}
			repeat(3) instance_create(x, y, ToxicGas)
			speed *= 1.2
			friction *= 1.2
			direction += random_range(-7, 7);
			image_angle = direction
			break;
		  }
		  case FlameBall:
		  {
			sage_bounce--
			move_bounce_solid(false)
			sound_play(sndExplosionS)
			instance_create(x, y, SmallExplosion)
			repeat(12)
			{
			  with instance_create(x, y, Flame)
			  {
				team = other.team
				creator = other
				motion_add(random(360), random_range(4,6))
				}
			}
			speed *= 1.5
			sound_play_pitchvol(sndFlareExplode, 1.3, .7)
			sleep(12)
			view_shake_at(x, y, 8)
			break;
		  }
		  case BloodBall:
		  {
			sound_play_pitchvol(sndBloodHammer, random_range(1, 1.4), .8)
			sound_play_pitchvol(sndBloodLauncherExplo, random_range(1.3, 1.6), .8)
			sage_bounce--
			sleep(15)
			view_shake_at(x, y, 10)
			move_bounce_solid(false)
			with instance_create(x, y, MeatExplosion){team = other.team;creator = other.creator}
			with instance_create(x, y, BloodStreak){image_angle = other.direction}
			with instance_nearest(x, y, Wall){instance_create(x, y, FloorExplo); instance_destroy()}
			speed *= 1.2
			direction += random_range(-6, 6);
			image_angle = direction
			break;
		  }
		  case Rocket: case Nuke:
		  {
			sage_bounce--;
			move_bounce_solid(false)
			direction += random_range(-4, 4)
			image_angle = direction
			repeat(6){with instance_create(x, y, Flame){team = other.team; motion_add(other.direction + random_range(-12,12),choose(2,3,2))}}
			sound_play_pitchvol(sndHitWall, 1, 2)
			//sound_play_pitchvol(sndGrenadeHitWall, .7, .7)
			sleep(7)
			view_shake_at(x, y, 4)
			speed = 1.2;
			break;
		  }
		  case MiniNade:
		  {
			sage_bounce--;
			move_bounce_solid(false)
			direction += random_range(-15, 15)
			image_angle = direction
			speed *= .8
			instance_create(x, y, Dust)
			sound_play_pitchvol(sndGrenadeHitWall, 1.2 * random_range(.9, 1.1), .7)
			sleep(2)
			view_shake_at(x, y, 1)
			break;
		  }
		  case Flare:
		  {
			sage_bounce--;
			move_bounce_solid(false)
			direction += random_range(-12, 12)
			image_angle = direction
			speed += 2
			instance_create(x, y, Dust)
			repeat(8)
			{
			  with instance_create(x, y, Flame)
			  {
				team = other.team
				creator = other
				motion_add(random(360), random_range(4,8))
				}
			}
			sound_play_pitchvol(sndFlareExplode, 1.3, .7)
			sleep(3)
			view_shake_at(x, y, 2)
			break;
		  }
		  case EnemyBullet2:
		  {
			sleep(2)
			sage_bounce--;
			move_bounce_solid(false)
			direction += random_range(-12, 12)
			image_angle = direction
			instance_create(x, y, ScorpionBulletHit)
			sound_play_pitchvol(sndHitWall, 1.2, .7)
			break;
		  }
		  case LightningBall:
		  {
			sleep(30)
			view_shake_at(x, y, 22)
			sage_bounce--;
			move_bounce_solid(false)
			direction += random_range(-3, 3)
			repeat(6) with instance_create(x, y, Lightning)
			{
			  with instance_create(x, y, LightningHit){image_angle = random(360)}
			  image_angle = random(360)
			  alarm0 = 1
			  visible = 0
			  team = other.team
			  creator = other.creator
			  ammo = 8 + irandom(6)
			  with instance_create(x,y,LightningSpawn)
			  {
				image_angle = other.image_angle
			  }
			}
			speed += 1
			sound_play_pitchvol(sndLightningShotgun, 1.2, .7)
			image_angle = direction
			break;
		  }
		  case Splinter: case Seeker:
		  {
			round(x)
			round(y)
			sage_bounce--;
			image_index = 0
			image_speed = 1
			move_bounce_solid(false)
			direction += random_range(-4, 4)
			image_angle = direction
			instance_create(x, y, Dust)
			sound_play_pitchvol(sndBoltHitWall, 1.3, .7)
			sleep(2)
			view_shake_at(x, y, 1)
			break;
		  }
		  case Bolt:
		  {
			sage_bounce--;
			image_index = 0
			image_speed = 1
			move_bounce_solid(false)
			direction += random_range(-2, 2)
			image_angle = direction
			instance_create(x, y, Dust)
			sound_play_pitchvol(sndBoltHitWall, 1.3, .7)
			sleep(5)
			view_shake_at(x, y, 3)
			break;
		  }
		  case HeavyBolt:
		  {
			sage_bounce--;
			image_index = 0
			image_speed = 1
			move_bounce_solid(false)
			direction += random_range(-1, 1)
			image_angle = direction
			instance_create(x, y, Dust)
			sound_play_pitchvol(sndBoltHitWall, 1.3, .7)
			sleep(12)
			view_shake_at(x, y, 7)
			break;
		  }
		  case UltraBolt:
		  {
			sage_bounce--;
			image_index = 0
			image_speed = 1
			move_bounce_solid(false)
			with instance_nearest(x, y, Wall){instance_create(x, y, FloorExplo); instance_destroy()}
			direction += random_range(-3, 3)
			image_angle = direction
			instance_create(x, y, Dust)
			sound_play_pitchvol(sndBoltHitWall, 1.3, .7)
			sleep(20)
			view_shake_at(x, y,15)
			break;
		  }
		  case ToxicBolt:
		  {
			sage_bounce--;
			image_index = 0
			image_speed = 1
			move_bounce_solid(false)
			direction += random_range(-3, 3)
			image_angle = direction
			repeat(3) instance_create(x, y, ToxicGas)
			instance_create(x, y, Dust)
			sound_play_pitchvol(sndBoltHitWall, 1.3, .7)
			sound_play_pitchvol(sndToxicBoltGas, 1.3, .7)
			sleep(5)
			view_shake_at(x, y, 2)
			break;
		  }
		  case Bullet1: case HeavyBullet: case UltraBullet: case Bullet2: case FlameShell: case UltraShell: case Slug: case HeavySlug: case CustomProjectile: default:
		  {
			sage_bounce--;
			move_bounce_solid(false)
			direction += random_range(-8, 8)
			image_angle = direction
			instance_create(x, y, Dust)
			sound_play_pitchvol(sndHitWall, 1.3 * random_range(.9, 1.1), .7)
			sleep(1)
			break;
		  }
		  case BouncerBullet:
		  {
			sage_bounce--;
			move_bounce_solid(false)
			direction += random_range(-8, 8)
			image_angle = direction
			instance_create(x, y, Dust)
			sound_play_pitchvol(sndBouncerBounce, random_range(.9, 1.1), .7)
			sleep(1)
			break;
		  }
		  case Devastator:
		  {
			sage_bounce--;
			move_bounce_solid(false)
			direction += random_range(-5, 5)
			image_angle = direction
			sound_play_pitchvol(sndPlasmaBigExplodeUpg, 1.5 * random_range(.9, 1.1), .7)
			with instance_nearest(x, y, Wall){instance_create(x, y, FloorExplo); instance_destroy()}
			speed *= .8
			sleep(15)
			view_shake_at(x, y, 7)
			break;
		  }
		  case FlakBullet:case SuperFlakBullet:
		  {
			sound_play_pitchvol(sndHitWall, random_range(.8, 1.2), 1)
			sound_play_pitchvol(sndFlakExplode, random_range(1.4, 1.6), 1)
			sage_bounce--
			sleep(8)
			view_shake_at(x, y, 10)
			move_bounce_solid(false)
			repeat(3)
			{
			  with instance_create(x, y, Bullet2){blessed = true;team = other.team; creator = other.creator;motion_add(random(360), random_range(4,10))}
			}
			direction += random_range(-6, 6);
			speed *= 1.5
			friction *= 1.25
			if speed > 20 speed = 20
			direction += random_range(-15, 15);
			image_angle = direction
			break;
		  }
		  case PlasmaBall: case PlasmaBig: case PlasmaHuge:
		  {
			with instance_create(x, y, PlasmaImpact){team = other.team; creator = other}
			sage_bounce--;
			move_bounce_solid(false)
			image_angle = direction
			speed *= .9
			sleep(5)
			view_shake_at(x, y, 5)
			direction += random_range(-2, 2);
			sound_play_pitch(skill_get(mut_laser_brain) = 1 ? sndPlasmaBigExplode : sndPlasmaBigExplodeUpg, random_range(1.5, 1.7))
			sound_play_pitchvol(sndPlasmaHit, 1, .6)
			break;
		  }
		}
	  }
	}
}

#define hypernade_wall
move_bounce_solid(false)
move_contact_solid(direction, 6)
instance_create(x, y, Smoke)
with instance_create(x, y, HyperGrenade)
{
  team         = other.team
  creator      = other.creator
  direction    = other.direction
  sage_bounce = other.sage_bounce
  blessed = true
  repeat(6)with instance_create(x, y, Smoke){motion_add(other.direction, random_range(2, 4))}
  blessed = true
  sacred  = true
  sageCheck = true
  with other if "crit" in self with other crit = other.crit
}
sound_play_pitchvol(sndGrenadeHitWall, random_range(1.8, 2.2), .5)
sleep(15)
instance_destroy();

#define hyperslug_wall
move_bounce_solid(false)
move_contact_solid(direction, 6)
instance_create(x, y, Smoke)
with instance_create(x, y, HyperSlug)
{
  team        = other.team
  creator     = other.creator
  direction   = other.direction
  sage_bounce = other.sage_bounce
  sageCheck = true;
}
sound_play_pitchvol(sndHitWall, random_range(.8, 1.2), .7)
sleep(15)
instance_destroy();

#define laser_wall
move_bounce_solid(false)
instance_create(x, y, Smoke)
repeat(3)with instance_create(x, y, PlasmaTrail){motion_add(other.direction, random_range(.5, 2))}
with instance_create(x, y, Laser)
{
  team    = other.team
  creator = other.creator
  image_angle = other.direction + random_range(-4, 4)
  direction   = image_angle
  event_perform(ev_alarm,0)
  sage_bounce = other.sage_bounce;
  image_yscale = other.image_yscale
  blessed = true
  sacred  = true
  sageCheck = true
  with other if "crit" in self with other crit = other.crit
}
instance_delete(self);

#define hitbounce_step
	if(skill_get(mut_throne_butt) && instance_exists(projectile) && instance_exists(hitme)){
		var _inst = instances_matching_gt(projectile, "sage_bounce", 0);
		if(array_length(_inst)){
			var	_searchDis  = 16,
				_bounceList = [];

			with(_inst){
				var _obj = hitbounce(self, _searchDis);
				if(is_array(_obj)){
					array_push(_bounceList, _obj);
				}
			}

			 // Anti-Duplicate Insurance:
			if(array_length(_bounceList)){
				with(instance_create(0, 0, CustomObject)){
					list        = _bounceList;
					on_end_step = hitbounce_check_end_step;
				}
			}
		}
	}

#define hitbounce(_proj, _searchDis)
	var retVal = noone;
	with(_proj){
		if(distance_to_object(hitme) <= _searchDis + max(0, abs(speed_raw) - friction_raw) + abs(gravity_raw)){
			motion_step(1);

			if(distance_to_object(hitme) <= _searchDis){
				var _instMeet = instance_rectangle_bbox(
					bbox_left   - _searchDis,
					bbox_top    - _searchDis,
					bbox_right  + _searchDis,
					bbox_bottom + _searchDis,
					hitme
				);
				if(array_length(_instMeet)){
					var _break = false;
					with(_instMeet){
						motion_step(1);

						if(place_meeting(x, y, other)){
							var	_x = x,
								_y = y;

							_break = true;

							with(other){
								with(instance_copy(false)){
									 // Bounce:
									direction   = point_direction(_x, _y, x, y);
									image_angle = direction;
									if(place_free(x + hspeed_raw, y + vspeed_raw)){
										x += hspeed_raw;
										y += vspeed_raw;
									}
									motion_step(-1);

									 // Temporarily Deactivate:
									retVal = [id, other, mask_index];
									mask_index = mskNone;
								}
							}
						}

						motion_step(-1);

						if(_break) break;
					}
				}
			}

			motion_step(-1);
		}
	}
	return retVal;

#define hitbounce_check_end_step
	 // Delete/Activate Bounced Projectiles:
	with(list){
		if(!is_array(self)){continue;}
		with(self[0]){
			 // Delete:
			if(instance_exists(other[1])){
				instance_delete(id);
			}

			 // Activate:
			else{
				mask_index = other[2];

				 // Sound:
				sound_play_hit(sndShotgunHitWall, 0.2);

				 // Reset Bonus:
				bonus  = true;
				alarm2 = 2;
			}
		}
	}

	instance_destroy();

#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)
	/*
		Returns all given instances with their bounding box touching a given rectangle
		Much better performance than manually performing 'place_meeting()' on every instance
	*/

	return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _x1), "bbox_left", _x2), "bbox_bottom", _y1), "bbox_top", _y2);

#define motion_step(_mult)
	/*
		Performs the calling instance's basic movement code, scaled by a given number
	*/

	if(_mult > 0){
		if(friction_raw != 0 && speed_raw != 0){
			speed_raw -= min(abs(speed_raw), friction_raw * _mult) * sign(speed_raw);
		}
		if(gravity_raw != 0){
			hspeed_raw += lengthdir_x(gravity_raw, gravity_direction) * _mult;
			vspeed_raw += lengthdir_y(gravity_raw, gravity_direction) * _mult;
		}
		if(speed_raw != 0){
			x += hspeed_raw * _mult;
			y += vspeed_raw * _mult;
		}
	}
	else{
		if(speed_raw != 0){
			y += vspeed_raw * _mult;
			x += hspeed_raw * _mult;
		}
		if(gravity_raw != 0){
			vspeed_raw += lengthdir_y(gravity_raw, gravity_direction) * _mult;
			hspeed_raw += lengthdir_x(gravity_raw, gravity_direction) * _mult;
		}
		if(friction_raw != 0 && speed_raw != 0){
			speed_raw -= min(abs(speed_raw), friction_raw * _mult) * sign(speed_raw);
		}
	}

#define cleanup
	 // Destroy Script Bindings:
	with(global.bind_step){
		instance_destroy();
	}

#define init
    global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletBounce.png", 2, 7, 11);
    global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconReflective.png", 2, 5, 5);
    global.sprSonicStreak = sprite_add("../../../sprites/projectiles/sprSonicStreak.png",7, 24, 8);
    
    global.projBouncer = noone
    
    with effect_type_create("projectileBounces", `{} PROJECTILE @(color:${c.bounce})BOUNCES`, scr.describe_whole) {
        on_new_projectiles = script_ref_create(bounce_update)
    }
    
    global.effects = [
        effect_instance_named("projectileBounces", 2, 2),
        simple_stat_effect("accuracy", 1.2, 0)
    ]

#macro c mod_variable_get("race", "sage", "colormap");
#macro scr mod_variable_get("mod", "sageeffects", "scr")

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $00B8FC;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "BOUNCE";

#define bullet_ttip
  return ["@yREFLECT", "::ELECTROSTATIC ENCAPSULATION EX-8804", "::REPULSION SIGNIFICANTLY AFFECTING RELIABILITY"];

#define bullet_area
  return 1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);
  
#define bullet_effects
    return global.effects


//Bullet specific fire script
#define on_fire
	//NONSYNC FUNCTION AHEAD.
	if !audio_is_playing(sndBouncerSmg) {
		sound_play_pitchvol(sndBouncerSmg, .5 * (.8 + random_nonsync(.4)), .5);
	}

#define bounce_update(value, effect, projectiles)
    value = ceil(value);
    with instances_matching_ne(projectiles, "sage_no_bounce", true) {
        if !instance_is_melee(self) {
            if instance_is(self, Laser) {
                sage_bounces = value
                bounce_laser(value)
            }
            else if "bounce" in self && !instance_is(self, BouncerBullet) {
                bounce += value;
            }
            else if "bounces" in self {
                bounces += value;
            }
            else if "wallbounce" in self {
                wallbounce += round(value * 1.7)
                if instance_is(self, HyperSlug) {
                	speed += value
                }
            }
            else if (instance_is(self, CustomProjectile) || instance_is(self, CustomSlash)) && speed > 0 && script_ref_valid(on_wall) {
                sage_bounces = value
                on_wall = script_ref_create(bounce_wall_wrap, on_wall)
            }
            else {
                add_bouncing_projectile(self, value)
            }
        }
    }

#define script_ref_valid(ref)
    return is_array(ref) && array_length(ref) >= 3

//I don't like this as a solution but its at least avoidable and does minor harm.
#define bounce_wall_wrap(originalScript)
    if (sage_bounces > 0) {
        sage_bounces -= 1
        var d = direction;
        move_bounce_solid(false)
        instance_create(x, y, Dust)
        image_angle -= angle_difference(direction, d)
        sound_play_hit(sndBouncerBounce, 1.2)
    }
    else {
        on_wall = originalScript
        //idk whos using return values in on_wall but just in case, ill return here
        return script_ref_call(originalScript)
    }
    
    
#define add_bouncing_projectile(proj, bounces)
    if (!instance_exists(global.projBouncer)) {
        with script_bind_step(bounce_projectiles, 0) {
            global.projBouncer = self
            projectiles = []
        }
    }
    proj.sage_bounces = bounces
    array_push(global.projBouncer.projectiles, proj)
    
#define bounce_projectiles
    if (array_length(projectiles) == 0) {
        instance_destroy()
        exit
    }
    
    //Update projectile list with existing and valid projectiles
    projectiles = instances_matching_gt(projectiles, "sage_bounces", 0);
    
    if (array_length(projectiles) > 0) {
        bounce_these(projectiles)
    }

#define instance_is_melee(inst)
	return (
	    (variable_instance_get(inst, "ammo_type") == 0) ||
	    (instance_is(inst, CustomSlash) && inst.speed < 8) ||
		instance_is(inst, Shank) || instance_is(inst, Slash) ||
		instance_is(inst, BloodSlash) || instance_is(inst, GuitarSlash) ||
		instance_is(inst, EnergySlash) || instance_is(inst, EnergyShank) ||
		instance_is(inst, EnergyHammerSlash) || instance_is(inst, LightningSlash)
	)
	
#define bounce_these(_proj)
	with(_proj){

		if place_meeting(x + hspeed, y + vspeed, Wall) /*|| instance_is(self, Laser)*/ {
		    //I was gonna try to clean this up but its just not worth it. I fixed the indentation though.
			switch(object_index) {

				case HyperGrenade:
				    bounce_hypernade()
				    break;

				// case HyperSlug:
				// 	bounce_hyperslug()
				//     break;

                 case Laser:
                    bounce_laser(sage_bounces)
				    break;

    	    	case BloodGrenade:
                    sound_play_pitchvol(sndBloodHammer, random_range(1, 1.4), .6)
                    sage_bounces--
                    // sleep(2)
                    move_bounce_solid(false)
                    with instance_create(x, y, BloodStreak){image_angle = other.direction}
                    speed *= 1.2
                    direction += random_range(-15, 15);
                    image_angle = direction
                    break;
    				
    			case Grenade: case HeavyNade: case UltraGrenade: case ClusterNade: case ConfettiBall:
    				sound_play_pitch(sndGrenadeHitWall, 1)
    				sound_play_pitch(sndBouncerBounce, random_range(.8, 1.2))
    				sage_bounces--
    				// sleep(5)
    				view_shake_at(x, y, 2)
    				move_bounce_solid(false)
    				image_angle = direction
    				instance_create(x, y, Dust)
    				speed *= 1.2
    				friction *= 1.2
    				direction += random_range(-7, 7);
    				image_angle = direction
    				break;
    				
    			case ConfettiBall:
    				sound_play_pitch(sndBouncerBounce, random_range(.8, 1.2))
    				sage_bounces--
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
    				
    			case ToxicGrenade:
    				sound_play_pitch(sndGrenadeHitWall, 1)
    				sound_play_pitch(sndBouncerBounce, random_range(.8, 1.2))
    				sound_play_pitchvol(sndToxicBoltGas, 1.3, .7)
    				sage_bounces--
    				// sleep(5)
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

			    case FlameBall:
					sage_bounces--
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

			    case BloodBall:
					sound_play_pitchvol(sndBloodHammer, random_range(1, 1.4), .8)
					sound_play_pitchvol(sndBloodLauncherExplo, random_range(1.3, 1.6), .8)
					sage_bounces--
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

			    case Rocket: case Nuke:
					sage_bounces--;
					move_bounce_solid(false)
					direction += random_range(-4, 4)
					image_angle = direction
					repeat(6){with instance_create(x, y, Flame){team = other.team; motion_add(other.direction + random_range(-12,12),choose(2,3,2))}}
					sound_play_pitchvol(sndHitWall, 1, 2)
					//sound_play_pitchvol(sndGrenadeHitWall, .7, .7)
					//sleep(7)
					view_shake_at(x, y, 4)
					speed = 1.2;
					break;

			    case MiniNade:
					sage_bounces--;
					move_bounce_solid(false)
					direction += random_range(-15, 15)
					image_angle = direction
					speed *= .8
					instance_create(x, y, Dust)
					sound_play_pitchvol(sndGrenadeHitWall, 1.2 * random_range(.9, 1.1), .7)
					//sleep(2)
					view_shake_at(x, y, 1)
					break;

			    case Flare:
					sage_bounces--;
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
					//sleep(3)
					view_shake_at(x, y, 2)
					break;

			    case EnemyBullet2:
					sage_bounces--;
					move_bounce_solid(false)
					direction += random_range(-12, 12)
					image_angle = direction
					instance_create(x, y, ScorpionBulletHit)
					sound_play_pitchvol(sndHitWall, 1.2, .7)
					break;

			    case LightningBall:
					sleep(30)
					view_shake_at(x, y, 22)
					sage_bounces--;
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

			    case Splinter: case Seeker:
					round(x)
					round(y)
					sage_bounces--;
					image_index = 0
					image_speed = 1
					move_bounce_solid(false)
					direction += random_range(-4, 4)
					image_angle = direction
					instance_create(x, y, Dust)
					sound_play_pitchvol(sndBoltHitWall, 1.3 * random_range(.8, 1.2), .7)
					//sleep(2)
					view_shake_at(x, y, 1)
					break;

			    case Bolt:
					sage_bounces--;
					image_index = 0
					image_speed = 1
					move_bounce_solid(false)
					direction += random_range(-2, 2)
					image_angle = direction
					instance_create(x, y, Dust)
					sound_play_pitchvol(sndBoltHitWall, 1.3, .7)
					//sleep(5)
					view_shake_at(x, y, 3)
					break;

			    case HeavyBolt:
					sage_bounces--;
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

			    case UltraBolt:
					sage_bounces--;
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

			    case ToxicBolt:
					sage_bounces--;
					image_index = 0
					image_speed = 1
					move_bounce_solid(false)
					direction += random_range(-3, 3)
					image_angle = direction
					repeat(3) instance_create(x, y, ToxicGas)
					instance_create(x, y, Dust)
					sound_play_pitchvol(sndBoltHitWall, 1.3, .7)
					sound_play_pitchvol(sndToxicBoltGas, 1.3, .7)
					//sleep(5)
					view_shake_at(x, y, 2)
					break;

			    case Bullet2: case FlameShell: case UltraShell: case Slug: case HeavySlug:
					break;

                case Bullet1: case HeavyBullet: case UltraBullet: case CustomProjectile: default:
					sage_bounces--;
					move_bounce_solid(false)
					direction += random_range(-8, 8)
					image_angle = direction
					instance_create(x, y, Dust)
					sound_play_pitchvol(sndHitWall, 1.3 * random_range(.9, 1.1), .7)
					//sleep(1)
					break;

                case BouncerBullet:
					sage_bounces--;
					move_bounce_solid(false)
					direction += random_range(-8, 8)
					image_angle = direction
					instance_create(x, y, Dust)
					sound_play_pitchvol(sndBouncerBounce, random_range(.9, 1.1), .7)
					//sleep(1)
					break;

                case Devastator:
					sage_bounces--;
					move_bounce_solid(false)
					direction += random_range(-5, 5)
					image_angle = direction
					sound_play_pitchvol(sndPlasmaBigExplodeUpg, 1.5 * random_range(.9, 1.1), .7)
					with instance_nearest(x, y, Wall){instance_create(x, y, FloorExplo); instance_destroy()}
					speed *= .8
					sleep(15)
					view_shake_at(x, y, 7)
					break;

                case FlakBullet:case SuperFlakBullet:
					sound_play_pitchvol(sndHitWall, random_range(.8, 1.2), 1)
					sound_play_pitchvol(sndFlakExplode, random_range(1.4, 1.6), 1)
					sage_bounces--
					sleep(8)
					view_shake_at(x, y, 10)
					move_bounce_solid(false)
					repeat(3) {

					  with instance_create(x, y, Bullet2){blessed = true;team = other.team; creator = other.creator;motion_add(random(360), random_range(4,10))}
					}
					direction += random_range(-6, 6);
					speed *= 1.5
					friction *= 1.25
					if speed > 20 speed = 20
					direction += random_range(-15, 15);
					image_angle = direction
					break;

			    case PlasmaBall: case PlasmaBig: case PlasmaHuge:
					with instance_create(x, y, PlasmaImpact){team = other.team; creator = other}
					sage_bounces--;
					move_bounce_solid(false)
					image_angle = direction
					speed *= .9
					//sleep(5)
					view_shake_at(x, y, 5)
					direction += random_range(-2, 2);
					sound_play_pitch(skill_get(mut_laser_brain) ? sndPlasmaBigExplode : sndPlasmaBigExplodeUpg, random_range(1.5, 1.7))
					sound_play_pitchvol(sndPlasmaHit, 1, .6)
					break;
			}
		}
	}


#define get_reflect_angle(x, y, dir, backoffset)
    var nearest = instance_nearest(x - 8, y - 8, Wall);
    if point_distance(nearest.x + 8, nearest.y + 8, x, y) > 16 return dir

    //0 top, 1 left, 2 bottom, 3 right
    var deflectFace = (floor((point_direction(nearest.x + 8, nearest.y + 8, x - lengthdir_x(backoffset, dir), y - lengthdir_y(backoffset, dir)) - 45)/90) + 4) mod 4,
        newdir = dir;

    //Horizontal deflection
    if (deflectFace mod 2 == 1) {
        newdir = (newdir * -1 + 180 + 360) mod 360
    }
    //Vertical deflection
    else {
        newdir = (newdir * -1 + 360) mod 360
    }
    
    return newdir


#define bounce_laser(bounces)
    var newAngle = get_reflect_angle(x, y, direction, 2),
        pushAngle = newAngle + angle_difference(direction + 180, newAngle)/2;
    if (newAngle == direction) {
        exit
    }
    //Gold laser is less common than sndLaser so it doesn't clip as often
    var q = sound_play_hit(sndGoldLaser, 1.2);
        sound_volume(q, .2)
        sound_pitch(q, 2 + random(.6))
	with instance_create(x + lengthdir_x(4, pushAngle), y + lengthdir_y(4, pushAngle), Laser) {
        team = other.team
        creator = other.creator
        direction = newAngle
        image_angle = newAngle
        
        // image_yscale = other.image_yscale + .3 * current_time_scale
        image_yscale = other.image_yscale
        move_outside_solid(pushAngle, 6)
    
        repeat(4) with instance_create(x, y, PlasmaTrail) {
            motion_add(other.direction + random_range(-24, 24), random_range(.6, 3));
        }
	    
        sage_no_bounce = true
        sage_bounces = 0
        // add_bouncing_projectile(self, other.sage_bounces - 1)
        
        event_perform(ev_alarm, 0);
        bounces -= 1
        if (bounces > 0) bounce_laser(bounces)
	}
	sage_bounces = 0

#define bounce_hypernade()
    var newAngle = get_reflect_angle(x, y, direction, 2),
        pushAngle = newAngle + angle_difference(direction + 180, newAngle)/2;
    if (newAngle == direction) {
        exit
    }
    var q = sound_play_hit(sndGrenadeHitWall, 1.2);
        sound_volume(q, .5)
        sound_pitch(q, 2 + random(.6))
        
	with instance_create(x - lengthdir_x(30, direction), y - lengthdir_y(30, direction), ImpactWrists) {
    	sprite_index = global.sprSonicStreak
    	image_angle = other.direction
    	motion_set(image_angle, 3)
    	friction = .4
    	image_speed *= 1.5
    	image_index += 1
    }

	with instance_create(x + lengthdir_x(4, pushAngle), y + lengthdir_y(4, pushAngle), HyperGrenade) {
        team = other.team
        creator = other.creator
        direction = newAngle
        image_angle = newAngle
        
        move_outside_solid(pushAngle, 6)
    
        with instance_create(x, y, SmallExplosion) {
        	var q = sound_play_hit(sndExplosionS, .2);
        		sound_pitch(q, 1.5 + random(.2))
        }
        with instance_create(x, y, ImpactWrists) {
        	sprite_index = global.sprSonicStreak
        	image_angle = newAngle
        	motion_set(image_angle, 4)
        	friction = .4
        	image_speed *= 1.5
        }
        sage_no_bounce = true
        add_bouncing_projectile(self, other.sage_bounces - 1)
	}
	sage_bounces = 0
	instance_delete(self)


    
#define simple_stat_effect(variableName, value, scaling) return mod_script_call("mod", "sageeffects", "simple_stat_effect", variableName, value, scaling)
#define effect_instance_named(effectName, value, scaling) return mod_script_call("mod", "sageeffects", "effect_instance_create", value, scaling, effectName)
#define effect_type_create(name, description, describe_script) return mod_script_call("mod", "sageeffects", "effect_type_create", name, description, describe_script)

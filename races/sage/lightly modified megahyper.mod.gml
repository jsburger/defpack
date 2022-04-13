
//PREFACE: this is Yokin's MegaHyper mod, taken with permission, lightly modified to act as a library for Sage's hyper bullet
#define init

#macro hyperProjectiles global.hyperProjectiles
	hyperProjectiles = []

	sound_prepare = sound_prepare_raw;
	
#macro sound_prepare     global.sound_prepare
#macro sound_prepare_raw { snd: -1, pit: 1, vol: 1 }

#macro hyper_field_radius 20 * (1 + skill_get(mut_euphoria)) // No hyper things within this distance of Player

#macro current_frame_active ((current_frame % 1) < current_time_scale)

#define step
	if (array_length(hyperProjectiles) > 0) {
		//Update projectile array
		hyperProjectiles = instances_matching_ne(hyperProjectiles, "id", null);
		if array_length(hyperProjectiles == 0) {
			exit;
		}
		
		var _soundPrepared = lq_clone(sound_prepare);
		sound_prepare = sound_prepare_raw;
		
		 // Hyper Stuff:
		var	_projNormal = instances_matching_ne(hyperProjectiles, "object_index", ToxicGas, Slash, EnemySlash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, LightningSlash, CustomSlash, Shank, EnergyShank),
			_projSlash  = instances_matching(hyperProjectiles, "object_index", Slash, EnemySlash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, LightningSlash, CustomSlash, Shank, EnergyShank);
			
		hyper(instances_matching_le(_projNormal, "friction", 0),                  20,               1); // Projectiles (No Friction)
		hyper(instances_matching_gt(_projNormal, "friction", 0),                  20,               2); // Projectiles (Friction)
		hyper(_projSlash,                                                         20,               8); // Fast Slashes
		hyper(instances_matching(hyperProjectiles, "object_index", ToxicGas),     16,               0); // Toxic Gas
	
		 // Cool Sounds:
		if(_soundPrepared.snd != -1){
			if(sound_prepare.snd == -1){
				with(_soundPrepared){
					sound_play_pitchvol(snd, pit, vol);
				}
			}
		}
	}
	
#define hyper(_inst, _triesMax, _minSpeed)
	with(instances_matching_ge(_inst, "speed", _minSpeed)){
		if(instance_exists(self) && can_hyper()){
			var	_tries = 0,
				//Sage modifier
				_maxTries = min(_triesMax, sage_warp_strength),
				_frame = current_frame,
				_trail = 1;
				
			 // No Trail:
			switch(object_index){
				case Seeker:
				case Rocket:
					_trail = 0;
					break;
			}
			
			 // Hyperify:
			while(_tries < _maxTries && speed >= _minSpeed){
				 // Alarms:
				if((_frame % 1) < current_time_scale){
					for(var i = 0; i < 12; i++){
						var a = alarm_get(i);
						if(a >= 0){
							if(event_exists(object_index, ev_alarm, i)){
								alarm_set(i, --a);
								if(a == 0){
									event_perform(ev_alarm, i);
									if(!instance_exists(self)) break;
								}
							}
						}
					}
				}
				if(!instance_exists(self)) break;
				
				 // Telekinesis:
				var _proj = instance_is(self, projectile);
				if(_proj || instance_is(self, enemy)){
					var _break = false;
					with(instances_matching(Player, "race", "eyes")){
						if((canspec && button_check(index, "spec")) || usespec > 0){
							 // Projectile Style:
							if(_proj && other.creator == id){
								if(ultra_get(race, 1)){
									_break = true;
									break;
								}
							}
							
							 // Normal:
							if(!_proj || team == other.team){
								if(point_seen(other.x, other.y, index)){
									with(other){
										var	_dis = (1 + skill_get(mut_throne_butt)) * current_time_scale,
											_dir = point_direction(other.x, other.y, x, y);
											
										if(instance_is(self, enemy)) _dir += 180;
										
										var	_x = x + lengthdir_x(_dis, _dir),
											_y = y + lengthdir_y(_dis, _dir);
											
										if(place_free(_x, y)) x = _x;
										if(place_free(x, _y)) y = _y;
									}
								}
							}
						}
					}
					if(_break) break;
				}
				
				 // Step:
				event_perform(ev_step, ev_step_normal);
				if(!instance_exists(self)) break;
				
				 // Movement:
				if(friction_raw != 0 && speed_raw != 0){
					speed_raw -= min(abs(speed_raw), friction_raw) * sign(speed_raw);
				}
				if(gravity_raw != 0){
					hspeed_raw += lengthdir_x(gravity_raw, gravity_direction);
					vspeed_raw += lengthdir_y(gravity_raw, gravity_direction);
				}
				if(speed_raw != 0){
					x += hspeed_raw;
					y += vspeed_raw;
				}
				
				 // Collision Checking:
				if(!can_hyper()){
					x = xprevious;
					y = yprevious;
					break;
				}
				
				 // End Step:
				event_perform(ev_step, ev_step_end);
				if(!instance_exists(self)) break;
				
				 // Trail:
				if(_trail > 0 /* && _tries > 0 */){
					if((_frame % 1) < current_time_scale){
						if(visible && sprite_index != mskNone){
							var t = scrTrailLazy(xprevious, yprevious, _trail + 1);
							if((direction == t.image_angle && speed > 0) || instance_is(self, Van)){
								t.image_yscale *= random_range(0.2, 0.4);
							}
							_trail += 0.25;
						}
					}
				}
				
				_frame += current_time_scale;
				
				 // Last Position:
				xprevious = x;
				yprevious = y;
				
				 // Animate:
				image_index += image_speed_raw;
				if(image_index < 0 || image_index >= image_number){
					image_index -= image_number * sign(image_index);
					event_perform(ev_other, ev_animation_end);
					if(!instance_exists(self)) break;
				}
				
				 // Begin Step:
				event_perform(ev_step, ev_step_begin);
				if(!instance_exists(self)) break;
				
				_tries++;
			}
		}
	}
	
#define can_hyper()
	 // Walled:
	if(place_meeting(x, y, Wall) && event_exists(object_index, ev_collision, Wall)){
		return false;
	}
	
	 // Close to Player:
	if(instance_exists(Player)){
		var _radius = 0;
		if(instance_is(self, projectile) || instance_is(self, FiredMaggot) || instance_is(self, LilHunterFly)){
			_radius = hyper_field_radius;
		}
		else if(instance_is(self, ScrapBossMissile)){
			_radius = hyper_field_radius * 2;
		}
		if(_radius > 0){
			with(instances_matching_ne(Player, "team", variable_instance_get(self, "team"))){
				with(other){
					if(point_distance(x + hspeed_raw, y + vspeed_raw, other.x, other.y) < _radius){
						sound_play_pitchvol(sndRoll, 0.4 + random(0.6), 4);
						
						 // Glow:
						if(current_frame_active){
							with(scrTrailLazy(x, y, 2)){
								if((other.direction == image_angle && other.speed > 0) || instance_is(other, Van)){
									image_yscale *= random_range(0.4, 0.6);
								}
							}
						}
						
						return false;
					}
				}
			}
		}
	}
	
	if("team" in self){
		 // Projectile Clearing Shocks:
		if(place_meeting(x, y, PortalShock)){
			return false;
		}
		
		 // Explosions:
		if(place_meeting(x, y, Explosion) || place_meeting(x, y, MeatExplosion)){
			if(array_length(instances_meeting(x, y, instances_matching_ne([Explosion, MeatExplosion], "team", team))) > 0){
				return false;
			}
		}
		
		 // Potential Hit:
		if(place_meeting(x, y, hitme)){
			if(!instance_is(self, enemy) || canmelee){
				if(array_length(instances_matching_gt(instances_meeting(x, y, instances_matching_ne(hitme, "team", team)), "my_health", 0)) > 0){
					return false;
				}
			}
		}
		
		 // Potential Deflection:
		var _meetProj = place_meeting(x, y, projectile);
		if("typ" not in self || typ != 0){
			 // Melee:
			if(_meetProj){
				 // Shank:
				if(array_length(instances_meeting(x, y, instances_matching_ne([Shank, EnergyShank, HorrorBullet], "team", team))) > 0){
					return false;
				}
				
				 // Slash:
				var _inst = instances_meeting(x, y, [Slash, EnemySlash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, LightningSlash, CustomSlash, GuardianDeflect]);
				if(array_length(_inst) > 0){
					 // Charging Up:
					if("typ" in self && typ == 1){
						if(array_length(instances_matching_gt(instances_matching(_inst, "team", team), "speed", 0)) > 0){
							x -= hspeed_raw * 1.2;
							y -= vspeed_raw * 1.2;
							speed += friction_raw;
							
							 // Charge Glow:
							if(current_frame_active){
								with(scrTrailLazy(x, y, 2)){
									image_alpha *= random_range(0.4, 0.6);
								}
							}
							
							 // Sound:
							with(sound_prepare){
								snd = sndUltraCrossbow;
								pit = 1.2 + random(0.8);
								vol = 0.6;
							}
							sound_play_pitch(sndJackHammer, 0.5 + ((current_frame / 50) % 1));
						}
					}
					
					return false;
				}
			}
			
			 // Shields:
			if(instance_is(self, projectile)){
				if(place_meeting(x, y, CrystalShield) || place_meeting(x, y, PopoShield)){
					var _inst = instances_meeting(x, y, [CrystalShield, PopoShield]);
					if(array_length(_inst) > 0){
						 // Charging Up:
						if("typ" in self && typ == 1){
							if(array_length(instances_matching(_inst, "team", team)) > 0){
								x -= hspeed_raw * 1.025;
								y -= vspeed_raw * 1.025;
								speed += friction_raw;
								
								 // Charge Glow:
								if(current_frame_active){
									with(scrTrailLazy(x, y, 2)){
										image_alpha *= random_range(0.4, 0.6);
									}
								}
								
								 // Sound:
								with(sound_prepare){
									snd = sndHyperSlugger;
									var p = max(3 / other.speed, 1);
									if(pit > p || pit == 1) pit = p + random(0.2);
								}
								sound_play_pitchvol(sndLightningHit, 0.5 + ((current_frame / 50) % 1), 1.5);
							}
						}
						
						return false;
					}
				}
			}
		}
		if(_meetProj){
			if(array_find_index([Slash, EnemySlash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, LightningSlash, CustomSlash, Shank, EnergyShank, HorrorBullet, GuardianDeflect], object_index) >= 0){
				if(array_length(instances_meeting(x, y, instances_matching_ne(instances_matching_ne(projectile, "team", team), "typ", 0))) > 0){
					return false;
				}
			}
		}
	}
	
	return true;
	
#define scrTrailLazy(_x, _y, _time)
	with(instance_create(_x, _y, LaserCharge)){
		sprite_index = other.sprite_index;
		image_index  = other.image_index;
		image_xscale = other.image_xscale;
		image_yscale = other.image_yscale;
		image_angle  = other.image_angle;
		image_blend  = other.image_blend;
		image_alpha  = other.image_alpha * 5;
		direction    = other.direction;
		speed        = other.speed / 2;
		friction     = other.friction;
		depth        = other.depth;
		alarm0       = max(1, _time);
		
		 // Flip:
		if("right" in other){
			image_xscale *= other.right;
		}
		
		 // Z-Axis:
		if("z" in other){
			if(other.object_index == RavenFly || other.object_index == LilHunterFly){
				y += other.z;
				depth = object_get_depth(SubTopCont);
			}
			else{
				y -= other.z;
			}
		}
		
		 // Specific:
		switch(other.object_index){
			case BouncerBullet:
			case LHBouncer:
			case FiredMaggot:
				image_angle = other.direction;
				break;
				
			case Player:
				image_angle = other.angle + other.sprite_angle;
				break;
		}
		
		return id;
	}
	
#define instances_meeting(_x, _y, _obj)
	/*
		Returns all given instances that would be touching the calling instance at a given position
		Much better performance than manually performing "place_meeting(x, y, other)" with every instance
	*/
	
	var	_tx = x,
		_ty = y;
		
	x = _x;
	y = _y;
	var _inst = instances_matching_ne(instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", bbox_left), "bbox_left", bbox_right), "bbox_bottom", bbox_top), "bbox_top", bbox_bottom), "id", id);
	x = _tx;
	y = _ty;
	
	return _inst;
	
#define event_exists(_object, _eventType, _eventNum)
	/*
		Returns 'true' if a given object or its parent objects have a given event, 'false' otherwise
		Based on NTT v9944
		
		Ex:
			event_exists(Scorpion, ev_collision, Player)         == true
			event_exists(Player,   ev_step,      ev_step_normal) == true
			event_exists(Bullet1,  ev_draw,      0)              == false
	*/
	
	 // Setup Event Map:
	if(!mod_variable_exists("mod", mod_current, "event_map")){
		global.event_map = ds_map_create();
		
		with([
			[ev_create,    0,                     [Player, GammaBlast, CrystalShield, CrystalShieldDisappear, Crown, MeltDead, TangleSeed, Tangle, MeltGhost, Sapling, Ally, ThrownWep, RogueStrike, RogueBomb, SharpTeeth, DogMissile, Revive, PlayerSit, UberCont, BackCont, GameCont, TopCont, KeyCont, GenCont, MenuGen, MusCont, SpiralCont, Spiral, SpiralDebris, SpiralStar, NothingSpiral, WaterShader, TutCont, Credits, SubTopCont, BanditBoss, Drama, WantBoss, BecomeScrapBoss, ScrapBossMissile, ScrapBoss, BigDogExplo, LilHunterDie, WantLH, LHBouncer, LilHunter, LilHunterFly, Nothing, NothingInactive, Generator, NothingIntroMask, BecomeNothing, NothingDeath, ThroneStatue, GeneratorInactive, ThroneBeam, BigGuardianBullet, Carpet, SitDown, NothingBeam, BecomeNothing2, Nothing2Death, Throne2Ball, Nothing2, FrogQueenBall, FrogEgg, FrogQueenDie, FrogQueen, HyperCrystal, NecroReviveArea, TechnoMancer, LastBall, LastIntro, PopoScene, BigTV, LastCutscene, Last, Messenger, LastFire, LastExecute, LastDie, DramaCamera, BigFish, CanOasis, FloorMaker, NOWALLSHEREPLEASE, Wall, InvisiWall, Floor, SnowFloor, FloorMiddle, PizzaEntrance, FloorExplo, CharredGround, Scorch, ScorchGreen, ScorchTop, Portal, BigPortal, Top, TopSmall, Detail, VenuzCarpet, SpawnWall, ProtoStatue, Barrel, ToxicBarrel, GoldBarrel, WaterMine, MineExplosion, Car, CarVenus, CarVenusFixed, CarVenus2, Campfire, LogMenu, Cactus, PlantPot, Bush, TutorialTarget, BigFlower, IceFlower, WaterPlant, LightBeam, Pipe, OasisBarrel, Chandelier, Pillar, SmallGenerator, Table, Server, Terminal, YungCuz, VenuzTV, VenuzCouch, TV, SodaMachine, Hydrant, StreetLight, BigSkull, BonePile, BonePileNight, Anchor, NightCactus, CrystalProp, InvCrystal, Tube, MutantTube, YVStatue, MoneyPile, Tires, PizzaBox, Torch, Cocoon, SnowMan, Bones, prop, NewCarPlz, TopPot, TopDecalCity, TopDecalPalace, TopDecalSewers, TopDecalPizzaSewers, TopDecalCave, TopDecalInvCave, TopDecalDesert, TopDecalJungle, TopDecalNightDesert, TopDecalScrapyard, BouncerBullet, Bullet1, AllyBullet, UltraBullet, HeavyBullet, Burst, GoldBurst, HeavyBurst, HyperBurst, RogueBurst, SentryGun, Slash, GuitarSlash, BloodSlash, EnergySlash, Shank, EnergyShank, SawBurst, EnergyHammerSlash, LightningSlash, Bolt, Seeker, HeavyBolt, ToxicBolt, Splinter, Disc, UltraBolt, SplinterBurst, LightningBall, PlasmaBall, PlasmaBig, Lightning, IonBurst, LaserCannon, Laser, Devastator, PlasmaImpact, PlasmaHuge, Explosion, GreenExplosion, SmallExplosion, FlameBall, NadeBurst, ToxicDelay, DragonBurst, ToxicGrenade, Grenade, HeavyNade, BloodGrenade, BloodBall, Flare, ClusterNade, ConfettiBall, HyperGrenade, MiniNade, Nuke, UltraGrenade, Rocket, MeatExplosion, Mine, ToxicBurst, DragonSound, FlameBurst, FlameSound, Flame, Bullet2, FlameShell, HeavySlug, UltraShell, SuperFlakBullet, FlakBullet, Slug, HyperSlug, WaveBurst, SlugBurst, PopBurst, projectile, BECOMETARGET, RadMaggot, GoldScorpion, MaggotSpawn, BigMaggot, Maggot, Scorpion, Bandit, EnemyBullet1, FireBall, EnemyBullet2, MaggotExplosion, RadMaggotExplosion, BigMaggotBurrow, Mimic, SuperFrog, Exploder, Gator, BuffGator, Ratking, GatorSmoke, Rat, FastRat, RatkingRage, EFlakBullet, EnemySlash, EnemyBullet3, ToxicGas, MeleeBandit, MeleeFake, SuperMimic, Sniper, Raven, RavenFly, Trap, Salamander, EnemyBullet4, TrapFire, Spider, LaserCrystal, EnemyLightning, LightningCrystal, EnemyLaser, SnowTank, GoldSnowTank, SnowBot, CarThrow, Wolf, SnowBotCar, SnowTankExplode, RhinoFreak, Freak, Turret, ExploFreak, Necromancer, ReviveArea, BecomeTurret, ExploGuardian, DogGuardian, GhostGuardian, Guardian, GuardianBullet, CrownGuardianOld, CrownGuardian, OldGuardianStatue, GuardianStatue, GuardianDeflect, Molefish, FireBaller, JockRocket, SuperFireBaller, Jock, Molesarge, Turtle, Van, WantPopo, WantVan, PopoExplosion, IDPDSpawn, VanSpawn, PopoSlug, PopoPlasmaBall, PopoRocket, PopoNade, PopoFreak, Grunt, EliteGrunt, Shielder, EliteShielder, Inspector, EliteInspector, IDPDBullet, PopoShield, RevivePopoFreak, WantRevivePopoFreak, Crab, OasisBoss, BoneFish, InvLaserCrystal, InvSpider, JungleAssassin, FiredMaggot, JungleFly, JungleAssassinHide, JungleBandit, EnemyHorror, HorrorBullet, becomenemy, enemy, crystaltype, hitme, PotentialYeti, Corpse, ScrapBossCorpse, Nothing2Corpse, PlasmaTrail, EatRad, NothingBeamHit, RobotA, EliteGruntFlame, TangleKill, FrogHeal, CrystTrail, PortalL, BloodGamble, GunGun, ChickenB, FishA, Debris, ChestOpen, RabbitPaw, Scorchmark, MeltSplat, TrapScorchMark, Dust, Bubble, ImpactWrists, ThrowHit, Hammerhead, AssassinNotice, FishBoost, Curse, Wind, BubblePop, ReviveFX, Breath, CaveSparkle, RainSplash, RainDrop, SnowFlake, Drip, WindNight, FireFly, Smoke, LevelUp, StrongSpirit, BloodLust, HorrorTB, SteroidsTB, RecycleGland, AllyDamage, RobotEat, LaserBrain, WepSwap, DiscBounce, Deflect, DiscDisappear, DiscTrail, MeleeHitWall, BulletHit, GroundFlame, BlueFlame, BloodStreak, AcidStreak, EBulletHit, FXChestOpen, SmallChestPickup, HealFX, SmallChestFade, GunWarrantEmpty, ScorpionBulletHit, LightningSpawn, LightningHit, PopupText, Shell, Feather, ExploderExplo, DustOLD, SmokeOLD, BoltStick, PortalShock, PortalClear, LaserCharge, IDPDPortalCharge, Confetti, Sweat, PhantomBolt, BoltTrail, NothingBeamParticle, NothingBeamChargeParticle, Rad, BigRad, AmmoChest, RogueChest, AmmoChestMystery, IDPDChest, HealthChest, WeaponChest, ProtoChest, GoldChest, BigWeaponChest, BigCursedChest, GiantWeaponChest, GiantAmmoChest, RadChest, RadMaggotChest, VenuzWeaponSpawn, VenuzAmmoSpawn, HPPickup, AmmoPickup, RoguePickup, WepPickup, chestprop, CrownPickup, CrownPed, Menu, BackFromCharSelect, CharSelect, GoButton, Loadout, loadbutton, LoadoutCrown, LoadoutWep, LoadoutSkin, CampChar, MainMenu, PlayMenuButton, TutorialButton, MainMenuButton, StatMenu, StatButton, DailyArrow, WeeklyArrow, DailyScores, WeeklyScores, WeeklyProgress, DailyMenuButton, menubutton, BackMainMenu, UnlockAll, IntroLogo, MenuOLDOLD, OptionSelect, BSkinLoadout, CrownLoadout, StatsSelect, CrownSelect, DailyToggle, UpdateSelect, CreditsSelect, LoadoutSelect, MenuOLD, LoadoutOld, Vlambeer, QuitSelect, MakeGame, CrownIcon, SkillIcon, EGSkillIcon, CoopSkillIcon, SkillText, LevCont, mutbutton, PauseButton, button, GameOverButton, UnlockPopup, UnlockScreen, BUnlockScreen, UnlockButton, OptionMenuButton, VisualsMenuButton, AudioMenuButton, GameMenuButton, ControlMenuButton, SetKey, EmoteIndicator, GameObject, Effect, Pickup, CustomObject, CustomHitme, CustomProp, CustomProjectile, CustomSlash, CustomEnemy, CustomScript, CustomBeginStep, CustomStep, CustomEndStep, CustomDraw, FireCont, Dispose, CorpseActive, asset_get_index("GmlMod"), asset_get_index("MiscCont"), asset_get_index("MultiMenu"), asset_get_index("DetectFCS0"), asset_get_index("DetectFCS1"), asset_get_index("DetectFCS2")]],
			[ev_destroy,   0,                     [Player, CrystalShield, Tangle, Sapling, Ally, ThrownWep, RogueStrike, DogMissile, GameCont, GenCont, SpiralCont, BanditBoss, BecomeScrapBoss, ScrapBossMissile, ScrapBoss, LilHunterDie, LHBouncer, LilHunter, Nothing, NothingInactive, Generator, NothingIntroMask, BecomeNothing, ThroneStatue, GeneratorInactive, ThroneBeam, BigGuardianBullet, NothingBeam, Throne2Ball, Nothing2, FrogQueenBall, FrogEgg, FrogQueen, HyperCrystal, TechnoMancer, LastBall, LastIntro, BigTV, LastCutscene, Last, LastExecute, BigFish, Wall, Top, ProtoStatue, Barrel, ToxicBarrel, GoldBarrel, WaterMine, Car, CarVenus, CarVenusFixed, CarVenus2, Campfire, LogMenu, Cactus, PlantPot, Bush, TutorialTarget, BigFlower, IceFlower, WaterPlant, Pipe, OasisBarrel, Chandelier, Pillar, SmallGenerator, Table, Server, Terminal, VenuzTV, VenuzCouch, TV, SodaMachine, Hydrant, StreetLight, BigSkull, BonePile, BonePileNight, Anchor, NightCactus, CrystalProp, InvCrystal, Tube, MutantTube, YVStatue, MoneyPile, Tires, PizzaBox, Torch, Cocoon, SnowMan, prop, TopDecalScrapyard, BouncerBullet, AllyBullet, SentryGun, ToxicBolt, LightningBall, PlasmaBall, PlasmaBig, Devastator, PlasmaHuge, FlameBall, ToxicGrenade, Grenade, HeavyNade, BloodGrenade, BloodBall, Flare, ClusterNade, ConfettiBall, HyperGrenade, MiniNade, Nuke, UltraGrenade, Rocket, Mine, FlameShell, SuperFlakBullet, FlakBullet, RadMaggot, GoldScorpion, MaggotSpawn, BigMaggot, Maggot, Scorpion, Bandit, EnemyBullet1, FireBall, EnemyBullet2, Mimic, SuperFrog, Exploder, Gator, BuffGator, Ratking, GatorSmoke, Rat, FastRat, RatkingRage, EFlakBullet, MeleeBandit, MeleeFake, SuperMimic, Sniper, Raven, Salamander, EnemyBullet4, TrapFire, Spider, LaserCrystal, LightningCrystal, SnowTank, GoldSnowTank, SnowBot, CarThrow, Wolf, SnowBotCar, SnowTankExplode, RhinoFreak, Freak, Turret, ExploFreak, Necromancer, ExploGuardian, DogGuardian, GhostGuardian, Guardian, GuardianBullet, CrownGuardianOld, CrownGuardian, OldGuardianStatue, GuardianStatue, Molefish, FireBaller, JockRocket, SuperFireBaller, Jock, Molesarge, Turtle, Van, PopoPlasmaBall, PopoRocket, PopoNade, PopoFreak, Grunt, EliteGrunt, Shielder, EliteShielder, Inspector, EliteInspector, IDPDBullet, Crab, OasisBoss, BoneFish, InvLaserCrystal, InvSpider, JungleAssassin, FiredMaggot, JungleFly, JungleAssassinHide, JungleBandit, EnemyHorror, enemy, crystaltype, Debris, AmmoChest, RogueChest, AmmoChestMystery, IDPDChest, HealthChest, WeaponChest, GoldChest, BigWeaponChest, BigCursedChest, GiantWeaponChest, GiantAmmoChest, RadChest, RadMaggotChest, CrownPickup, IntroLogo, LoadoutOld, CustomObject, CustomHitme, CustomProp, CustomProjectile, CustomSlash, CustomEnemy, asset_get_index("GmlMod")]],
			[ev_alarm,     0,                     [Crown, Tangle, ThrownWep, RogueBomb, SharpTeeth, Revive, PlayerSit, UberCont, BackCont, GameCont, GenCont, MenuGen, MusCont, Credits, WantBoss, ScrapBoss, BigDogExplo, WantLH, BecomeNothing, NothingDeath, NothingBeam, BecomeNothing2, Nothing2Death, Nothing2, FrogQueenBall, FrogEgg, NecroReviveArea, LastCutscene, Messenger, LastChair, LastExecute, LastDie, DramaCamera, CanOasis, Portal, BigPortal, TopSmall, ProtoStatue, MineExplosion, OasisBarrel, TV, NewCarPlz, Burst, GoldBurst, HeavyBurst, HyperBurst, RogueBurst, SentryGun, SawBurst, Bolt, Seeker, HeavyBolt, ToxicBolt, Splinter, Disc, UltraBolt, SplinterBurst, LightningBall, Lightning, IonBurst, LaserCannon, Laser, Devastator, Explosion, GreenExplosion, SmallExplosion, FlameBall, NadeBurst, ToxicDelay, DragonBurst, ToxicGrenade, Grenade, HeavyNade, BloodGrenade, BloodBall, Flare, ClusterNade, ConfettiBall, HyperGrenade, MiniNade, UltraGrenade, Mine, ToxicBurst, FlameBurst, WaveBurst, SlugBurst, PopBurst, MaggotExplosion, RadMaggotExplosion, BigMaggotBurrow, MeleeBandit, RavenFly, Trap, EnemyLightning, EnemyLaser, SnowTankExplode, ReviveArea, Van, PopoExplosion, IDPDSpawn, VanSpawn, PopoNade, EliteInspector, PopoShield, RevivePopoFreak, WantRevivePopoFreak, JungleAssassin, Corpse, ScrapBossCorpse, Nothing2Corpse, Debris, LevelUp, GroundFlame, BlueFlame, Shell, Feather, LaserCharge, IDPDPortalCharge, Sweat, NothingBeamParticle, Rad, BigRad, VenuzWeaponSpawn, VenuzAmmoSpawn, HPPickup, AmmoPickup, RoguePickup, WepPickup, Menu, CharSelect, GoButton, LoadoutCrown, LoadoutWep, LoadoutSkin, MainMenu, PlayMenuButton, TutorialButton, MainMenuButton, StatButton, DailyArrow, WeeklyArrow, WeeklyProgress, DailyMenuButton, menubutton, IntroLogo, BSkinLoadout, CrownLoadout, CrownSelect, Vlambeer, MakeGame, CrownIcon, SkillIcon, EGSkillIcon, CoopSkillIcon, SkillText, mutbutton, PauseButton, GameOverButton, UnlockPopup, UnlockScreen, BUnlockScreen, UnlockButton, OptionMenuButton, VisualsMenuButton, AudioMenuButton, GameMenuButton, ControlMenuButton, CorpseActive]],
			[ev_alarm,     1,                     [Sapling, Ally, SharpTeeth, DogMissile, Revive, PlayerSit, UberCont, GenCont, MenuGen, MusCont, TutCont, BanditBoss, ScrapBossMissile, ScrapBoss, LilHunterDie, LilHunter, Nothing, BecomeNothing, NothingDeath, NothingBeam, Nothing2Death, Nothing2, FrogEgg, FrogQueen, HyperCrystal, TechnoMancer, LastCutscene, Last, Messenger, BigFish, Bolt, HeavyBolt, ToxicBolt, Splinter, UltraBolt, Devastator, Explosion, GreenExplosion, SmallExplosion, ToxicGrenade, Grenade, HeavyNade, BloodGrenade, BloodBall, Flare, ClusterNade, ConfettiBall, HyperGrenade, MiniNade, Nuke, UltraGrenade, Rocket, HyperSlug, RadMaggot, GoldScorpion, BigMaggot, Maggot, Scorpion, Bandit, BigMaggotBurrow, Mimic, SuperFrog, Exploder, Gator, BuffGator, Ratking, GatorSmoke, Rat, FastRat, RatkingRage, MeleeBandit, SuperMimic, Sniper, Raven, Salamander, Spider, LaserCrystal, LightningCrystal, SnowTank, GoldSnowTank, SnowBot, Wolf, SnowBotCar, RhinoFreak, Freak, Turret, ExploFreak, Necromancer, ExploGuardian, DogGuardian, Guardian, CrownGuardianOld, CrownGuardian, Molefish, FireBaller, JockRocket, SuperFireBaller, Jock, Molesarge, Turtle, Van, PopoExplosion, IDPDSpawn, VanSpawn, PopoRocket, PopoNade, PopoFreak, Grunt, EliteGrunt, Shielder, EliteShielder, Inspector, EliteInspector, Crab, OasisBoss, BoneFish, InvLaserCrystal, InvSpider, JungleAssassin, JungleFly, JungleBandit, EnemyHorror, Debris, PopupText, WepPickup, Menu, CharSelect, GoButton, PlayMenuButton, TutorialButton, MainMenuButton, StatButton, DailyArrow, WeeklyArrow, DailyScores, WeeklyScores, WeeklyProgress, DailyMenuButton, menubutton, MakeGame, CrownIcon, SkillIcon, EGSkillIcon, CoopSkillIcon, mutbutton, PauseButton, GameOverButton, UnlockPopup, UnlockButton, OptionMenuButton, VisualsMenuButton, AudioMenuButton, GameMenuButton, ControlMenuButton]],
			[ev_alarm,     2,                     [Player, Sapling, Ally, DogMissile, Revive, UberCont, BackCont, GenCont, MenuGen, MusCont, BanditBoss, ScrapBossMissile, LilHunterDie, LHBouncer, LilHunter, Nothing, NothingDeath, ThroneBeam, BigGuardianBullet, Throne2Ball, Nothing2, FrogQueenBall, FrogQueen, HyperCrystal, TechnoMancer, LastBall, LastIntro, LastCutscene, Last, Messenger, BigFish, ToxicGrenade, Grenade, HeavyNade, BloodGrenade, BloodBall, Flare, ClusterNade, ConfettiBall, MiniNade, UltraGrenade, Bullet2, FlameShell, HeavySlug, UltraShell, SuperFlakBullet, FlakBullet, Slug, GoldScorpion, Scorpion, EnemyBullet1, FireBall, EnemyBullet2, Mimic, SuperFrog, Gator, BuffGator, Ratking, EnemyBullet3, MeleeBandit, SuperMimic, Sniper, Raven, Salamander, EnemyBullet4, LaserCrystal, LightningCrystal, SnowTank, GoldSnowTank, SnowBot, Wolf, SnowBotCar, Turret, ExploGuardian, DogGuardian, GuardianBullet, CrownGuardianOld, Van, PopoPlasmaBall, PopoNade, PopoFreak, EliteGrunt, Shielder, EliteShielder, EliteInspector, IDPDBullet, Crab, OasisBoss, InvLaserCrystal, JungleAssassin, JungleFly, HorrorBullet, PopupText, DailyScores, WeeklyScores, MakeGame]],
			[ev_alarm,     3,                     [Player, UberCont, MusCont, BanditBoss, ScrapBoss, LilHunter, Nothing, BecomeNothing, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, LastIntro, LastCutscene, Last, Messenger, HyperSlug, BuffGator, FastRat, SnowBotCar, Turret, ExploGuardian, DogGuardian, Van, EliteShielder, InvLaserCrystal, EnemyHorror]],
			[ev_alarm,     4,                     [Ally, UberCont, MusCont, BanditBoss, LilHunter, BecomeNothing, TechnoMancer, Last, LaserCrystal, LightningCrystal, InvLaserCrystal]],
			[ev_alarm,     5,                     [Ally, MusCont, BanditBoss, TechnoMancer, Last]],
			[ev_alarm,     6,                     [MusCont, BanditBoss, BecomeNothing, TechnoMancer, Last]],
			[ev_alarm,     7,                     [MusCont, Last]],
			[ev_alarm,     8,                     [Player]],
			[ev_alarm,     9,                     [Player, UberCont]],
			[ev_alarm,     10,                    [Player, UberCont]],
			[ev_alarm,     11,                    [DogMissile, MusCont, BanditBoss, ScrapBossMissile, ScrapBoss, LilHunter, Nothing, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, Last, BigFish, RadMaggot, GoldScorpion, MaggotSpawn, BigMaggot, Maggot, Scorpion, Bandit, Mimic, SuperFrog, Exploder, Gator, BuffGator, Ratking, Rat, FastRat, RatkingRage, MeleeBandit, SuperMimic, Sniper, Raven, Salamander, Spider, LaserCrystal, LightningCrystal, SnowTank, GoldSnowTank, SnowBot, Wolf, SnowBotCar, RhinoFreak, Freak, Turret, ExploFreak, Necromancer, ExploGuardian, DogGuardian, GhostGuardian, Guardian, CrownGuardianOld, CrownGuardian, Molefish, FireBaller, SuperFireBaller, Jock, Molesarge, Turtle, Van, PopoFreak, Grunt, EliteGrunt, Shielder, EliteShielder, Inspector, EliteInspector, Crab, OasisBoss, BoneFish, InvLaserCrystal, InvSpider, JungleAssassin, FiredMaggot, JungleFly, JungleBandit, EnemyHorror, enemy, crystaltype, CustomEnemy]],
			[ev_step,      ev_step_normal,        [Player, CrystalShield, Crown, MeltDead, Sapling, Ally, ThrownWep, Patience, RogueStrike, DogMissile, Revive, PlayerSit, BackCont, GameCont, TopCont, MusCont, SpiralCont, Spiral, SpiralDebris, SpiralStar, NothingSpiral, TutCont, Credits, BanditBoss, WantBoss, BecomeScrapBoss, ScrapBossMissile, ScrapBoss, BigDogExplo, LilHunterDie, LHBouncer, LilHunter, LilHunterFly, Nothing, BecomeNothing, NothingDeath, ThroneStatue, GeneratorInactive, BigGuardianBullet, NothingBeam, BecomeNothing2, Nothing2Death, Throne2Ball, Nothing2, FrogQueenBall, FrogQueen, HyperCrystal, TechnoMancer, LastBall, LastIntro, PopoScene, LastCutscene, Last, Messenger, BigFish, FloorMaker, Portal, BigPortal, ProtoStatue, LogMenu, YungCuz, TV, BouncerBullet, HyperBurst, SentryGun, SawBurst, Bolt, Seeker, HeavyBolt, ToxicBolt, Splinter, Disc, UltraBolt, SplinterBurst, LightningBall, PlasmaBall, PlasmaBig, IonBurst, LaserCannon, Laser, Devastator, PlasmaImpact, PlasmaHuge, FlameBall, NadeBurst, DragonBurst, ToxicGrenade, Grenade, HeavyNade, BloodGrenade, BloodBall, Flare, ClusterNade, ConfettiBall, MiniNade, Nuke, UltraGrenade, Rocket, ToxicBurst, DragonSound, FlameBurst, FlameSound, Flame, Bullet2, FlameShell, HeavySlug, UltraShell, SuperFlakBullet, FlakBullet, Slug, HyperSlug, WaveBurst, RadMaggot, GoldScorpion, MaggotSpawn, BigMaggot, Maggot, Scorpion, Bandit, BigMaggotBurrow, Mimic, SuperFrog, Exploder, Gator, BuffGator, Ratking, GatorSmoke, Rat, FastRat, RatkingRage, EFlakBullet, EnemyBullet3, ToxicGas, MeleeBandit, MeleeFake, SuperMimic, Sniper, Raven, RavenFly, Trap, Salamander, TrapFire, Spider, LaserCrystal, LightningCrystal, EnemyLaser, SnowTank, GoldSnowTank, SnowBot, Wolf, SnowBotCar, RhinoFreak, Freak, Turret, ExploFreak, Necromancer, BecomeTurret, ExploGuardian, DogGuardian, GhostGuardian, Guardian, CrownGuardianOld, CrownGuardian, Molefish, FireBaller, JockRocket, SuperFireBaller, Jock, Molesarge, Turtle, Van, WantPopo, WantVan, IDPDSpawn, VanSpawn, PopoSlug, PopoPlasmaBall, PopoRocket, PopoNade, PopoFreak, Grunt, EliteGrunt, Shielder, EliteShielder, Inspector, EliteInspector, PopoShield, Crab, OasisBoss, BoneFish, InvLaserCrystal, InvSpider, JungleAssassin, FiredMaggot, JungleFly, JungleAssassinHide, JungleBandit, EnemyHorror, enemy, crystaltype, PotentialYeti, Corpse, ScrapBossCorpse, Nothing2Corpse, Debris, ChestOpen, Dust, RainDrop, SnowFlake, Smoke, Shell, Feather, BoltStick, Confetti, PhantomBolt, BoltTrail, Rad, BigRad, AmmoChest, RogueChest, AmmoChestMystery, IDPDChest, HealthChest, WeaponChest, ProtoChest, GoldChest, BigWeaponChest, BigCursedChest, GiantWeaponChest, GiantAmmoChest, VenuzWeaponSpawn, VenuzAmmoSpawn, HPPickup, AmmoPickup, RoguePickup, WepPickup, chestprop, CrownPed, BackFromCharSelect, Loadout, LoadoutCrown, LoadoutWep, LoadoutSkin, MainMenu, PlayMenuButton, TutorialButton, MainMenuButton, StatMenu, StatButton, DailyArrow, WeeklyArrow, DailyMenuButton, BackMainMenu, UnlockAll, IntroLogo, CrownSelect, MenuCrown, Back, MenuOLD, Vlambeer, QuitSelect, MakeGame, CrownIcon, SkillIcon, EGSkillIcon, CoopSkillIcon, LevCont, SetKey, EmoteIndicator, CustomObject, CustomHitme, CustomProjectile, CustomSlash, CustomEnemy, CustomStep, Dispose, CorpseActive, asset_get_index("MiscCont")]],
			[ev_step,      ev_step_begin,         [Player, KeyCont, BecomeScrapBoss, NothingInactive, Generator, NothingIntroMask, ThroneStatue, GeneratorInactive, FrogEgg, LastIntro, BigTV, LastCutscene, LastExecute, ProtoStatue, Barrel, ToxicBarrel, GoldBarrel, WaterMine, Car, CarVenus, CarVenusFixed, CarVenus2, Campfire, LogMenu, Cactus, PlantPot, Bush, TutorialTarget, BigFlower, IceFlower, WaterPlant, Pipe, OasisBarrel, Chandelier, Pillar, SmallGenerator, Table, Server, Terminal, VenuzTV, VenuzCouch, TV, SodaMachine, Hydrant, StreetLight, BigSkull, BonePile, BonePileNight, Anchor, NightCactus, CrystalProp, InvCrystal, Tube, MutantTube, YVStatue, MoneyPile, Tires, PizzaBox, Torch, Cocoon, SnowMan, prop, GatorSmoke, MeleeFake, CarThrow, OldGuardianStatue, GuardianStatue, JungleAssassinHide, RadChest, RadMaggotChest, CharSelect, GoButton, CampChar, DailyScores, WeeklyScores, MenuOLDOLD, BSkinLoadout, CrownLoadout, MenuOLD, CustomObject, CustomHitme, CustomProp, CustomProjectile, CustomSlash, CustomEnemy, CustomBeginStep, Dispose, asset_get_index("MiscCont")]],
			[ev_step,      ev_step_end,           [Player, SharpTeeth, UberCont, BackCont, Bolt, Seeker, HeavyBolt, ToxicBolt, Splinter, UltraBolt, LevelUp, StrongSpirit, BloodLust, HorrorTB, SteroidsTB, RobotEat, LaserBrain, WepSwap, Menu, CharSelect, GoButton, PlayMenuButton, TutorialButton, MainMenuButton, StatButton, DailyArrow, WeeklyArrow, WeeklyProgress, DailyMenuButton, menubutton, CrownIcon, SkillIcon, EGSkillIcon, CoopSkillIcon, mutbutton, PauseButton, GameOverButton, UnlockButton, OptionMenuButton, VisualsMenuButton, AudioMenuButton, GameMenuButton, ControlMenuButton, CustomObject, CustomHitme, CustomProjectile, CustomSlash, CustomEnemy, CustomEndStep, Dispose, CorpseActive]],
			[ev_collision, Player,                [Player, Sapling, Ally, DogMissile, Revive, BanditBoss, ScrapBossMissile, ScrapBoss, LilHunter, Nothing, NothingIntroMask, NothingDeath, SitDown, Nothing2Death, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, Last, BigFish, Portal, BigPortal, RadMaggot, GoldScorpion, MaggotSpawn, BigMaggot, Maggot, Scorpion, Bandit, Mimic, SuperFrog, Exploder, Gator, BuffGator, Ratking, Rat, FastRat, RatkingRage, MeleeBandit, SuperMimic, Sniper, Raven, Salamander, Spider, LaserCrystal, LightningCrystal, SnowTank, GoldSnowTank, SnowBot, Wolf, SnowBotCar, RhinoFreak, Freak, Turret, ExploFreak, Necromancer, ExploGuardian, DogGuardian, GhostGuardian, Guardian, CrownGuardianOld, CrownGuardian, Molefish, FireBaller, SuperFireBaller, Jock, Molesarge, Turtle, Van, PopoFreak, Grunt, EliteGrunt, Shielder, EliteShielder, Inspector, EliteInspector, Crab, OasisBoss, BoneFish, InvLaserCrystal, InvSpider, JungleAssassin, FiredMaggot, JungleFly, JungleBandit, EnemyHorror, enemy, crystaltype, Rad, BigRad, AmmoChest, RogueChest, AmmoChestMystery, IDPDChest, HealthChest, WeaponChest, ProtoChest, GoldChest, BigWeaponChest, BigCursedChest, GiantWeaponChest, GiantAmmoChest, RadChest, RadMaggotChest, HPPickup, AmmoPickup, RoguePickup, CrownPickup, CustomEnemy]],
			[ev_collision, Tangle,                [ToxicGas, TrapFire]],
			[ev_collision, Nothing,               [ThroneStatue]],
			[ev_collision, NothingDeath,          [Ally]],
			[ev_collision, NecroReviveArea,       [NecroReviveArea]],
			[ev_collision, TechnoMancer,          [TechnoMancer]],
			[ev_collision, Wall,                  [Player, Crown, TangleSeed, Sapling, Ally, ThrownWep, DogMissile, BanditBoss, BecomeScrapBoss, ScrapBossMissile, ScrapBoss, LilHunterDie, LHBouncer, LilHunter, Nothing, NothingInactive, Generator, NothingIntroMask, ThroneStatue, GeneratorInactive, ThroneBeam, BigGuardianBullet, Throne2Ball, Nothing2, FrogQueenBall, FrogEgg, FrogQueen, HyperCrystal, TechnoMancer, LastBall, LastIntro, BigTV, LastCutscene, Last, LastExecute, BigFish, CharredGround, Portal, BigPortal, ProtoStatue, Barrel, ToxicBarrel, GoldBarrel, WaterMine, Car, CarVenus, CarVenusFixed, CarVenus2, Campfire, LogMenu, Cactus, PlantPot, Bush, TutorialTarget, BigFlower, IceFlower, WaterPlant, Pipe, OasisBarrel, Chandelier, Pillar, SmallGenerator, Table, Server, Terminal, VenuzTV, VenuzCouch, TV, SodaMachine, Hydrant, StreetLight, BigSkull, BonePile, BonePileNight, Anchor, NightCactus, CrystalProp, InvCrystal, Tube, MutantTube, YVStatue, MoneyPile, Tires, PizzaBox, Torch, Cocoon, SnowMan, prop, BouncerBullet, Bullet1, AllyBullet, UltraBullet, HeavyBullet, SentryGun, Slash, GuitarSlash, BloodSlash, EnergySlash, Shank, EnergyShank, EnergyHammerSlash, LightningSlash, Bolt, Seeker, HeavyBolt, ToxicBolt, Splinter, Disc, UltraBolt, LightningBall, PlasmaBall, PlasmaBig, Devastator, PlasmaHuge, Explosion, GreenExplosion, SmallExplosion, FlameBall, ToxicGrenade, Grenade, HeavyNade, BloodGrenade, BloodBall, Flare, ClusterNade, ConfettiBall, MiniNade, Nuke, UltraGrenade, Rocket, Mine, Bullet2, FlameShell, HeavySlug, UltraShell, SuperFlakBullet, FlakBullet, Slug, HyperSlug, RadMaggot, GoldScorpion, MaggotSpawn, BigMaggot, Maggot, Scorpion, Bandit, EnemyBullet1, FireBall, EnemyBullet2, Mimic, SuperFrog, Exploder, Gator, BuffGator, Ratking, GatorSmoke, Rat, FastRat, RatkingRage, EFlakBullet, EnemySlash, EnemyBullet3, MeleeBandit, MeleeFake, SuperMimic, Sniper, Raven, Salamander, EnemyBullet4, Spider, LaserCrystal, LightningCrystal, SnowTank, GoldSnowTank, SnowBot, CarThrow, Wolf, SnowBotCar, RhinoFreak, Freak, Turret, ExploFreak, Necromancer, ExploGuardian, DogGuardian, GhostGuardian, Guardian, GuardianBullet, CrownGuardianOld, CrownGuardian, OldGuardianStatue, GuardianStatue, GuardianDeflect, Molefish, FireBaller, JockRocket, SuperFireBaller, Jock, Molesarge, Turtle, Van, PopoExplosion, PopoSlug, PopoPlasmaBall, PopoRocket, PopoNade, PopoFreak, Grunt, EliteGrunt, Shielder, EliteShielder, Inspector, EliteInspector, IDPDBullet, Crab, OasisBoss, BoneFish, InvLaserCrystal, InvSpider, JungleAssassin, FiredMaggot, JungleFly, JungleAssassinHide, JungleBandit, EnemyHorror, HorrorBullet, enemy, crystaltype, ScrapBossCorpse, BloodStreak, AcidStreak, Feather, SmokeOLD, PortalClear, NothingBeamParticle, BigRad, AmmoChest, RogueChest, AmmoChestMystery, IDPDChest, HealthChest, WeaponChest, ProtoChest, GoldChest, BigWeaponChest, BigCursedChest, GiantWeaponChest, GiantAmmoChest, RadChest, RadMaggotChest, HPPickup, AmmoPickup, RoguePickup, WepPickup, chestprop, CrownPed, CampChar, CustomProp, CustomProjectile, CustomSlash, CustomEnemy, CorpseActive]],
			[ev_collision, InvisiWall,            [Player, Crown, Sapling, Ally, PopoFreak, WepPickup, CorpseActive]],
			[ev_collision, Floor,                 [Top]],
			[ev_collision, FloorExplo,            [Bones, TopPot, TopDecalCity, TopDecalPalace, TopDecalSewers, TopDecalPizzaSewers, TopDecalCave, TopDecalInvCave, TopDecalDesert, TopDecalJungle, TopDecalNightDesert, TopDecalScrapyard]],
			[ev_collision, CharredGround,         [CharredGround]],
			[ev_collision, Portal,                [Crown, Revive, Rad, BigRad, HPPickup, AmmoPickup, RoguePickup, WepPickup]],
			[ev_collision, ProtoStatue,           [ProtoStatue, HorrorBullet, Rad, BigRad]],
			[ev_collision, Barrel,                [RadMaggot, BigMaggot]],
			[ev_collision, Car,                   [StreetLight, SnowBot, SnowBotCar]],
			[ev_collision, CarVenusFixed,         [Player]],
			[ev_collision, Campfire,              [TV, CampChar]],
			[ev_collision, IceFlower,             [Player]],
			[ev_collision, StreetLight,           [StreetLight]],
			[ev_collision, NightCactus,           [TV]],
			[ev_collision, Bones,                 [TopPot, TopDecalCity, TopDecalPalace, TopDecalSewers, TopDecalPizzaSewers, TopDecalCave, TopDecalInvCave, TopDecalDesert, TopDecalJungle, TopDecalNightDesert, TopDecalScrapyard]],
			[ev_collision, prop,                  [Player, Sapling, Ally, DogMissile, BanditBoss, ScrapBossMissile, ScrapBoss, LilHunter, Nothing, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, Last, BigFish, Campfire, LogMenu, RadMaggot, GoldScorpion, MaggotSpawn, BigMaggot, Maggot, Scorpion, Bandit, Mimic, SuperFrog, Exploder, Gator, BuffGator, Ratking, Rat, FastRat, RatkingRage, MeleeBandit, SuperMimic, Sniper, Raven, Salamander, Spider, LaserCrystal, LightningCrystal, SnowTank, GoldSnowTank, SnowBot, Wolf, SnowBotCar, RhinoFreak, Freak, Turret, ExploFreak, Necromancer, ExploGuardian, DogGuardian, GhostGuardian, Guardian, CrownGuardianOld, CrownGuardian, Molefish, FireBaller, SuperFireBaller, Jock, Molesarge, Turtle, Van, PopoFreak, Grunt, EliteGrunt, Shielder, EliteShielder, Inspector, EliteInspector, Crab, OasisBoss, BoneFish, InvLaserCrystal, InvSpider, JungleAssassin, FiredMaggot, JungleFly, JungleBandit, EnemyHorror, enemy, crystaltype, PortalShock, CustomEnemy]],
			[ev_collision, TopPot,                [TopPot, TopDecalCity, TopDecalPalace, TopDecalSewers, TopDecalPizzaSewers, TopDecalCave, TopDecalInvCave, TopDecalDesert, TopDecalJungle, TopDecalNightDesert, TopDecalScrapyard]],
			[ev_collision, Shank,                 [CarVenus]],
			[ev_collision, EnergyShank,           [CarVenus]],
			[ev_collision, UltraBolt,             [UltraBolt]],
			[ev_collision, Explosion,             [PizzaEntrance, Explosion, GreenExplosion, SmallExplosion, ToxicGrenade, Grenade, HeavyNade, BloodGrenade, BloodBall, Flare, ClusterNade, ConfettiBall, MiniNade, Nuke, UltraGrenade, Rocket, Mine, SuperFlakBullet, FlakBullet, EFlakBullet, JockRocket, PopoExplosion, PopoRocket, PopoNade, PortalShock]],
			[ev_collision, SmallExplosion,        [Explosion, GreenExplosion, SmallExplosion, PopoExplosion]],
			[ev_collision, Grenade,               [Slash, GuitarSlash, BloodSlash, EnergySlash, Shank, EnergyShank, EnergyHammerSlash, LightningSlash, CustomSlash]],
			[ev_collision, MeatExplosion,         [MeatExplosion]],
			[ev_collision, projectile,            [CrystalShield, Slash, GuitarSlash, BloodSlash, EnergySlash, Shank, EnergyShank, EnergyHammerSlash, LightningSlash, MeatExplosion, EnemySlash, GuardianDeflect, PopoExplosion, PopoShield, HorrorBullet, PortalShock, CustomSlash]],
			[ev_collision, ToxicGas,              [FrogQueen, SuperFrog, Exploder]],
			[ev_collision, Van,                   [Player]],
			[ev_collision, PopoExplosion,         [PopoExplosion]],
			[ev_collision, EnemyHorror,           [Rad, BigRad]],
			[ev_collision, HorrorBullet,          [HorrorBullet]],
			[ev_collision, enemy,                 [Player, Tangle, Sapling, Ally, DogMissile, BanditBoss, ScrapBossMissile, ScrapBoss, LilHunter, Nothing, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, Last, BigFish, RadMaggot, GoldScorpion, MaggotSpawn, BigMaggot, Maggot, Scorpion, Bandit, Mimic, SuperFrog, Exploder, Gator, BuffGator, Ratking, Rat, FastRat, RatkingRage, MeleeBandit, SuperMimic, Sniper, Raven, Salamander, Spider, LaserCrystal, LightningCrystal, SnowTank, GoldSnowTank, SnowBot, Wolf, SnowBotCar, RhinoFreak, Freak, Turret, ExploFreak, Necromancer, ExploGuardian, DogGuardian, GhostGuardian, Guardian, CrownGuardianOld, CrownGuardian, Molefish, FireBaller, SuperFireBaller, Jock, Molesarge, Turtle, Van, PopoFreak, Grunt, EliteGrunt, Shielder, EliteShielder, Inspector, EliteInspector, Crab, OasisBoss, BoneFish, InvLaserCrystal, InvSpider, JungleAssassin, FiredMaggot, JungleFly, JungleBandit, EnemyHorror, enemy, crystaltype, CustomEnemy]],
			[ev_collision, hitme,                 [GammaBlast, CrystalShield, Crown, TangleSeed, ThrownWep, LHBouncer, ThroneBeam, BigGuardianBullet, NothingBeam, Throne2Ball, FrogQueenBall, FrogQueen, LastBall, BouncerBullet, Bullet1, AllyBullet, UltraBullet, HeavyBullet, Slash, GuitarSlash, BloodSlash, EnergySlash, Shank, EnergyShank, EnergyHammerSlash, LightningSlash, Bolt, Seeker, HeavyBolt, ToxicBolt, Splinter, Disc, UltraBolt, LightningBall, PlasmaBall, PlasmaBig, Lightning, LaserCannon, Laser, Devastator, PlasmaImpact, PlasmaHuge, Explosion, GreenExplosion, SmallExplosion, FlameBall, ToxicGrenade, Grenade, HeavyNade, BloodGrenade, BloodBall, Flare, ClusterNade, ConfettiBall, HyperGrenade, MiniNade, Nuke, UltraGrenade, Rocket, MeatExplosion, Mine, Flame, Bullet2, FlameShell, HeavySlug, UltraShell, SuperFlakBullet, FlakBullet, Slug, HyperSlug, EnemyBullet1, FireBall, EnemyBullet2, SuperFrog, Exploder, EFlakBullet, EnemySlash, EnemyBullet3, ToxicGas, MeleeBandit, EnemyBullet4, TrapFire, EnemyLightning, EnemyLaser, CarThrow, GuardianBullet, GuardianDeflect, JockRocket, PopoExplosion, PopoSlug, PopoPlasmaBall, PopoRocket, PopoNade, IDPDBullet, PopoShield, JungleAssassin, FiredMaggot, HorrorBullet, ScrapBossCorpse, Nothing2Corpse, Debris, CustomProjectile, CustomSlash, CorpseActive]],
			[ev_collision, Debris,                [TV]],
			[ev_collision, PopupText,             [PopupText]],
			[ev_collision, PortalShock,           [AmmoChest, RogueChest, AmmoChestMystery, IDPDChest, HealthChest, WeaponChest, GoldChest, BigWeaponChest, BigCursedChest, GiantWeaponChest, GiantAmmoChest, RadChest, RadMaggotChest]],
			[ev_collision, PortalClear,           [ThroneStatue]],
			[ev_collision, AmmoChest,             [BigTV]],
			[ev_collision, WeaponChest,           [BigTV]],
			[ev_collision, HPPickup,              [HPPickup, AmmoPickup, RoguePickup]],
			[ev_collision, AmmoPickup,            [HPPickup, AmmoPickup, RoguePickup]],
			[ev_collision, WepPickup,             [Player, VenuzCouch, ProtoChest, WepPickup]],
			[ev_collision, chestprop,             [Sapling, Ally, DogMissile, BanditBoss, BecomeScrapBoss, ScrapBossMissile, ScrapBoss, LilHunter, Nothing, NothingInactive, Generator, NothingIntroMask, ThroneStatue, GeneratorInactive, Nothing2, FrogEgg, FrogQueen, HyperCrystal, TechnoMancer, LastIntro, BigTV, LastCutscene, Last, LastExecute, BigFish, ProtoStatue, Barrel, ToxicBarrel, GoldBarrel, WaterMine, Car, CarVenus, CarVenusFixed, CarVenus2, Campfire, LogMenu, Cactus, PlantPot, Bush, TutorialTarget, BigFlower, IceFlower, WaterPlant, Pipe, OasisBarrel, Chandelier, Pillar, SmallGenerator, Table, Server, Terminal, VenuzTV, VenuzCouch, TV, SodaMachine, Hydrant, StreetLight, BigSkull, BonePile, BonePileNight, Anchor, NightCactus, CrystalProp, InvCrystal, Tube, MutantTube, YVStatue, MoneyPile, Tires, PizzaBox, Torch, Cocoon, SnowMan, prop, RadMaggot, GoldScorpion, MaggotSpawn, BigMaggot, Maggot, Scorpion, Bandit, Mimic, SuperFrog, Exploder, Gator, BuffGator, Ratking, GatorSmoke, Rat, FastRat, RatkingRage, MeleeBandit, MeleeFake, SuperMimic, Sniper, Raven, Salamander, Spider, LaserCrystal, LightningCrystal, SnowTank, GoldSnowTank, SnowBot, CarThrow, Wolf, SnowBotCar, RhinoFreak, Freak, Turret, ExploFreak, Necromancer, ExploGuardian, DogGuardian, GhostGuardian, Guardian, CrownGuardianOld, CrownGuardian, OldGuardianStatue, GuardianStatue, Molefish, FireBaller, SuperFireBaller, Jock, Molesarge, Turtle, Van, PopoFreak, Grunt, EliteGrunt, Shielder, EliteShielder, Inspector, EliteInspector, Crab, OasisBoss, BoneFish, InvLaserCrystal, InvSpider, JungleAssassin, FiredMaggot, JungleFly, JungleAssassinHide, JungleBandit, EnemyHorror, enemy, crystaltype, AmmoChest, RogueChest, AmmoChestMystery, IDPDChest, HealthChest, WeaponChest, ProtoChest, GoldChest, BigWeaponChest, BigCursedChest, GiantWeaponChest, GiantAmmoChest, RadChest, RadMaggotChest, chestprop, CustomProp, CustomEnemy]],
			[ev_collision, CrownPed,              [ProtoChest]],
			[ev_collision, CampChar,              [TV, NightCactus]],
			[ev_mouse,     ev_mouse_enter,        [DailyArrow, WeeklyArrow]],
			[ev_mouse,     ev_mouse_leave,        [DailyArrow, WeeklyArrow]],
			[ev_mouse,     ev_global_left_press,  [OptionSelect, StatsSelect, DailyToggle, UpdateSelect, CreditsSelect, LoadoutSelect]],
			[ev_mouse,     ev_global_right_press, [StatsSelect, UpdateSelect, CreditsSelect, LoadoutSelect]],
			[ev_other,     ev_game_end,           [BackCont, TopCont, asset_get_index("MiscCont")]],
			[ev_other,     ev_room_start,         [Crown, UberCont, GameCont, KeyCont, MusCont, PopoScene, asset_get_index("MiscCont")]],
			[ev_other,     ev_room_end,           [Player, RogueStrike, Revive, UberCont, BackCont, GameCont, TopCont, MusCont, CarVenusFixed, CarVenus2, YungCuz, ProtoChest, WepPickup, CustomObject, CustomHitme, CustomProjectile, CustomSlash, CustomEnemy, asset_get_index("MiscCont"), asset_get_index("MultiMenu")]],
			[ev_other,     ev_animation_end,      [GammaBlast, CrystalShield, CrystalShieldDisappear, TangleSeed, Tangle, MeltGhost, Sapling, SharpTeeth, PlayerSit, LHBouncer, LilHunterFly, NothingInactive, Generator, BecomeNothing, NothingDeath, ThroneBeam, BigGuardianBullet, BecomeNothing2, Nothing2Death, Throne2Ball, FrogQueenBall, FrogQueenDie, LastBall, Messenger, LastDie, Portal, BigPortal, CarVenusFixed, CarVenus2, YungCuz, BouncerBullet, Bullet1, AllyBullet, UltraBullet, HeavyBullet, SentryGun, Slash, GuitarSlash, BloodSlash, EnergySlash, Shank, EnergyShank, EnergyHammerSlash, LightningSlash, Bolt, Seeker, HeavyBolt, ToxicBolt, Splinter, UltraBolt, PlasmaBall, PlasmaBig, Lightning, PlasmaImpact, PlasmaHuge, Explosion, GreenExplosion, SmallExplosion, MeatExplosion, Flame, Bullet2, FlameShell, HeavySlug, UltraShell, Slug, HyperSlug, EnemyBullet1, EnemyBullet2, MaggotExplosion, RadMaggotExplosion, BigMaggotBurrow, GatorSmoke, EnemySlash, EnemyBullet3, RavenFly, EnemyBullet4, TrapFire, LaserCrystal, EnemyLightning, LightningCrystal, Turret, Guardian, GuardianBullet, CrownGuardian, GuardianDeflect, PopoExplosion, IDPDSpawn, VanSpawn, PopoSlug, PopoPlasmaBall, IDPDBullet, PopoShield, HorrorBullet, PotentialYeti, Corpse, ScrapBossCorpse, Nothing2Corpse, PlasmaTrail, EatRad, NothingBeamHit, RobotA, EliteGruntFlame, TangleKill, FrogHeal, CrystTrail, PortalL, BloodGamble, GunGun, ChickenB, FishA, ChestOpen, RabbitPaw, Bubble, ImpactWrists, ThrowHit, Hammerhead, AssassinNotice, FishBoost, Curse, Wind, BubblePop, ReviveFX, Breath, CaveSparkle, RainSplash, Drip, WindNight, FireFly, LevelUp, StrongSpirit, BloodLust, HorrorTB, SteroidsTB, RecycleGland, AllyDamage, RobotEat, LaserBrain, WepSwap, DiscBounce, Deflect, DiscDisappear, DiscTrail, MeleeHitWall, BulletHit, GroundFlame, BlueFlame, BloodStreak, AcidStreak, EBulletHit, FXChestOpen, SmallChestPickup, HealFX, SmallChestFade, GunWarrantEmpty, ScorpionBulletHit, LightningSpawn, LightningHit, ExploderExplo, DustOLD, SmokeOLD, PortalShock, PortalClear, NothingBeamParticle, NothingBeamChargeParticle, CrownPed, Loadout, CampChar, UnlockPopup, CustomProjectile, CustomSlash, CorpseActive]],
			[ev_other,     ev_user0,              [Floor, FloorExplo, BackFromCharSelect, CharSelect, GoButton, Loadout, loadbutton, LoadoutCrown, LoadoutWep, LoadoutSkin, PlayMenuButton, TutorialButton, MainMenuButton, StatMenu, StatButton, DailyArrow, WeeklyArrow, DailyScores, WeeklyScores, WeeklyProgress, DailyMenuButton, menubutton, BackMainMenu, UnlockAll, CrownIcon, SkillIcon, EGSkillIcon, CoopSkillIcon, mutbutton, PauseButton, button, GameOverButton, UnlockButton, OptionMenuButton, VisualsMenuButton, AudioMenuButton, GameMenuButton, ControlMenuButton]],
			[ev_other,     ev_user1,              [BackFromCharSelect, CharSelect, GoButton, Loadout, loadbutton, LoadoutCrown, LoadoutWep, LoadoutSkin, PlayMenuButton, TutorialButton, MainMenuButton, StatMenu, StatButton, DailyArrow, WeeklyArrow, DailyScores, WeeklyScores, WeeklyProgress, DailyMenuButton, menubutton, BackMainMenu, UnlockAll, CrownIcon, SkillIcon, EGSkillIcon, CoopSkillIcon, mutbutton, PauseButton, button, GameOverButton, UnlockButton, OptionMenuButton, VisualsMenuButton, AudioMenuButton, GameMenuButton, ControlMenuButton]],
			[ev_other,     62,                    [Player, UberCont, BackCont, DailyScores, WeeklyScores, GameMenuButton, asset_get_index("MiscCont")]],
			[ev_other,     75,                    [UberCont, MakeGame]],
			[ev_other,     70,                    [UberCont, DailyScores, WeeklyScores]],
			[ev_other,     69,                    [UberCont, DailyScores, WeeklyScores, asset_get_index("MiscCont")]],
			[ev_other,     63,                    [MakeGame, asset_get_index("MiscCont")]],
			[ev_other,     68,                    [asset_get_index("MiscCont")]],
			[ev_draw,      0,                     [Player, CrystalShield, Sapling, Ally, RogueStrike, DogMissile, PlayerSit, UberCont, BackCont, TopCont, KeyCont, GenCont, NothingSpiral, Credits, SubTopCont, BanditBoss, Drama, ScrapBossMissile, ScrapBoss, LilHunter, LilHunterFly, Nothing, NothingInactive, BecomeNothing, Carpet, NothingBeam, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, LastIntro, LastCutscene, Last, DramaCamera, BigFish, ProtoStatue, Campfire, LightBeam, TV, SentryGun, Disc, PlasmaBall, PlasmaBig, Lightning, IonBurst, Laser, PlasmaHuge, ConfettiBall, Nuke, Rocket, RadMaggot, GoldScorpion, MaggotSpawn, BigMaggot, Maggot, Scorpion, Bandit, BigMaggotBurrow, Mimic, SuperFrog, Exploder, Gator, BuffGator, Ratking, GatorSmoke, Rat, FastRat, RatkingRage, MeleeBandit, SuperMimic, Sniper, Raven, RavenFly, Salamander, Spider, LaserCrystal, EnemyLightning, LightningCrystal, EnemyLaser, SnowTank, GoldSnowTank, SnowBot, CarThrow, Wolf, SnowBotCar, RhinoFreak, Freak, Turret, ExploFreak, Necromancer, ExploGuardian, DogGuardian, GhostGuardian, Guardian, CrownGuardianOld, CrownGuardian, Molefish, FireBaller, JockRocket, SuperFireBaller, Jock, Molesarge, Turtle, Van, PopoPlasmaBall, PopoRocket, PopoFreak, Grunt, EliteGrunt, Shielder, EliteShielder, Inspector, EliteInspector, PopoShield, Crab, OasisBoss, BoneFish, InvLaserCrystal, InvSpider, JungleAssassin, FiredMaggot, JungleFly, JungleBandit, EnemyHorror, RainDrop, SnowFlake, PopupText, Confetti, WepPickup, Menu, BackFromCharSelect, CharSelect, GoButton, Loadout, LoadoutCrown, LoadoutWep, LoadoutSkin, CampChar, MainMenu, PlayMenuButton, TutorialButton, MainMenuButton, StatMenu, StatButton, DailyArrow, WeeklyArrow, DailyScores, WeeklyScores, WeeklyProgress, DailyMenuButton, menubutton, BackMainMenu, UnlockAll, IntroLogo, MenuOLDOLD, OptionSelect, MusVolSlider, SfxVolSlider, AmbVolSlider, FullScreenToggle, FitScreenToggle, GamePadToggle, MouseCPToggle, CoopToggle, QToggle, ScaleUpDown, ShakeUpDown, AutoAimUpDown, BSkinLoadout, CrownLoadout, StatsSelect, CrownSelect, DailyToggle, UpdateSelect, CreditsSelect, LoadoutSelect, MenuOLD, Vlambeer, QuitSelect, CrownIcon, SkillIcon, EGSkillIcon, CoopSkillIcon, SkillText, LevCont, mutbutton, PauseButton, GameOverButton, UnlockPopup, UnlockScreen, BUnlockScreen, UnlockButton, OptionMenuButton, VisualsMenuButton, AudioMenuButton, GameMenuButton, ControlMenuButton, CustomObject, CustomHitme, CustomProjectile, CustomSlash, CustomEnemy, CustomDraw, Dispose, asset_get_index("MultiMenu")]],
			[ev_draw,      ev_draw_end,           [UberCont, WaterShader, Loadout, LoadoutCrown, LoadoutWep, LoadoutSkin, PlayMenuButton, TutorialButton, MainMenuButton, UnlockAll, OptionMenuButton]],
			[ev_draw,      ev_draw_pre,           [UberCont]],
			[ev_draw,      ev_draw_post,          [UberCont, asset_get_index("MiscCont")]],
			[ev_draw,      ev_gui,                [asset_get_index("MiscCont")]],
			[ev_draw,      ev_gui_begin,          [UberCont]],
			[ev_draw,      65,                    [UberCont]]
		]){
			var	_typ = self[0],
				_num = self[1];
				
			if(!ds_map_exists(global.event_map, _typ)){
				global.event_map[? _typ] = ds_map_create();
			}
			
			global.event_map[? _typ][? _num] = self[2];
		}
	}
	
	 // Check for Event:
	if(ds_map_exists(global.event_map, _eventType)){
		if(ds_map_exists(global.event_map[? _eventType], _eventNum)){
			return (array_find_index(global.event_map[? _eventType][? _eventNum], _object) >= 0);
		}
	}
	
	return false;
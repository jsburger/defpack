#define init
global.sprChainsaw = sprite_add_weapon("sprites/sprChainsaw.png",0,3)
global.mskChainsaw = sprite_add_weapon("sprites/mskChainsawUpg.png",20,3)
global.sprMiniAmmo = sprite_add("sprites/sprMiniAmmo.png",7,3,3)
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_name
return "CHAINSAW"
#define weapon_type
return 4
#define weapon_cost
return 1
#define weapon_area
return 6;
#define weapon_load
return 14;
#define weapon_swap
return sndSwapMotorized
#define weapon_auto
return true;
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt
return global.sprChainsaw
#define weapon_text
return choose("RIP AND TEAR","KILLED ENEMIES ALWAYS#DROP SOME @yAMMO")

#define weapon_fire
with instance_create(x,y,CustomObject){
	creator = other
	team    = other.team
	name    = "chainsaw burst"
	ammo    = weapon_get_load(mod_current)
	timer   = current_time_scale
	on_step = chainsaw_step
	bwep    = other.specfiring and other.race == "steroids"
}

#define chainsaw_step
if !instance_exists(creator){instance_destroy();exit}
if ammo > 0 && current_frame_active{
	ammo--
	with creator{
		sound_play_pitch(sndJackHammer,random_range(.4,.6))
		sound_play_pitchvol(sndSwapMotorized,1,.6)
		sound_play_gun(sndClickBack,1,.8)
		sound_stop(sndClickBack)
		weapon_post(0,6,0)
		if other.bwep{
			bwkick = -6 - 6*skill_get(13) + random_range(-1,1)
		    var l = bwkick;
		}
		else{
		    wkick = -6 - 6*skill_get(13) + random_range(-1,1)
		    var l = wkick;
		}
	}
	with instance_create(creator.x+lengthdir_x(-l,creator.gunangle),creator.y+lengthdir_y(-l,creator.gunangle),CustomProjectile){
		if !irandom(2) instance_create(x+lengthdir_x(6+(6*skill_get(13)),other.creator.gunangle),y+lengthdir_y(6+(6*skill_get(13)),other.creator.gunangle),Smoke)
		sprite_index = mskNone
		canfix = false
		force = 0
		damage = irandom_range(1, 2)
		if skill_get(13) = true mask_index = global.mskChainsaw else mask_index = global.sprChainsaw
		image_xscale = 1.33
		image_yscale = 1.25
		creator = other
		team = other.team
		image_angle = other.creator.gunangle
		with instances_matching_gt(instances_matching_ne(projectile,"team",other.team), "typ", 0){
			if place_meeting(x,y,other){instance_destroy()}
		}
		on_hit        = chainsawshank_hit
		on_wall       = nothing
		on_anim       = anim_destroy
	}
	if ammo <= 0{instance_destroy();exit}
}

#define nothing

#define chainsawshank_hit
if current_frame_active{
	view_shake_at(x,y,8)
	sleep(6)
	var _splat = -4;
	_splat = determine_gore(other)
    with instance_create((other.x*other.size+x)/(other.size+1),(other.y*other.size+y)/(other.size+1),_splat){image_angle = random(360)}
	projectile_hit(other,damage,force,direction)
	if other.my_health <= 0{
        sound_play_pitch(sndDiscHit,random_range(.7,.8))
		sound_play_pitch(sndImpWristKill,random_range(1.6,1.8))
		sound_play_pitch(sndDiscBounce,random_range(.5,.6))
		sleep(other.size * 80)
		view_shake_at(x,y,other.size * 80)
		repeat(other.size){
			with instance_create(other.x,other.y,AmmoPickup){num = .5;sprite_index = global.sprMiniAmmo}
		}
	}
}

#define anim_destroy
instance_destroy()

#define determine_gore(_id)
switch (_id.object_index){
	//FEATHER BLEEDERS
	case Raven : return Feather;
	//CURSED BLEEDERS
	case InvSpider  	 : 
	case InvCrystal      : 
	case InvLaserCrystal : return Curse;
	//CRYSTAL BLEEDERS
	case LaserCrystal : 
	case HyperCrystal : 
	case CrystalProp  : 
	case Spider		: 
	case RhinoFreak	: return Hammerhead;
	//WHITE BLEEDERS
	case YVStatue : 
	case BigSkull : 
	case SnowMan  : return MeleeHitWall;
	//ROBOT BLEEDERS
	case SnowBot       : 
	case SnowTank      : 
	case GoldSnowTank  : 
	case Barrel        : 
	case OasisBarrel   : 
	case ToxicBarrel   : 
	case Wolf          : 
	case StreetLight   : 
	case SodaMachine   : 
	case Hydrant	   : 
	case Turret	       : 
	case TechnoMancer  : 
	case Terminal      : 
	case MutantTube    : 
	case DogMissile    : 
	case Sniper        : 
	case Car           : 
	case Pipe          : 
	case Anchor 	   : 
	case WaterMine	   : 
	case VenuzTV       : 
	case CarVenus	   : 
	case CarVenus2	   : 
	case CarVenusFixed : 
	case Van		   : return BulletHit;
	//LIGHTNING BLEEDERS
	case LightningCrystal  : return LightningSpawn;
	// BIG BLEEDERS
	case JungleFly  : 
	case BigMaggot  : 
	case BanditBoss : return BloodGamble;
	//BIG GREEN BLEEDERS
	case Scorpion 	:
	case GoldScorpion :
	case GoldScorpion : return AcidStreak;
	// ULTRA BOYS
	case EnemyHorror      :
	case CrownGuardianOld :
	case CrownGuardian    :
	case Guardian         :
	case GhostGuardian    :
	case ExploGuardian    :
	case DogGuardian      : return ScorpionBulletHit;
	default : return AllyDamage;
}

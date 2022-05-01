#define init
    global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletCursed.png", 2, 7, 11);
    global.sprFairy  = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconCursed.png", 1, 5, 5);
    global.sprFairy2 = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconCurseBlink.png", 1, 5, 5);
    
    global.fairySprites = [
        global.sprFairy,
        sprite_add("../../../sprites/sage/bullet icons/sprFairyIconCursedBubbles.png", 2, 5, 5),
        sprite_add("../../../sprites/sage/bullet icons/sprFairyIconCursedCracked.png", 2, 5, 5),
        sprite_add("../../../sprites/sage/bullet icons/sprFairyIconCursedGhost.png", 2, 5, 5),
        sprite_add("../../../sprites/sage/bullet icons/sprFairyIconCursedNail.png", 2, 5, 5),
        sprite_add("../../../sprites/sage/bullet icons/sprFairyIconCursedShards.png", 2, 5, 5),
        sprite_add("../../../sprites/sage/bullet icons/sprFairyIconCursedStar.png", 2, 5, 5),
    ]
    
    global.sprEmote  = sprite_add("../../../sprites/sage/sprBulletEmoji.png", 1, 6, 0);
    
    //Special, one of a kind bullets:
    global.specialBulletHyperizer = [];
    global.specialBulletChaos = [];
    global.specialBulletMicro = [];
    global.specialBulletTeleporter = [];
    global.Maggot = noone;
    
    effect_types_init()
    effects_init();
    personalities_init();
    names_init();

#macro c mod_variable_get("race", "sage", "colormap");
#macro scr mod_variable_get("mod", "sageeffects", "scr")

#define fairy_sprite(spellPower, bullet)
    if is_object(bullet) {
        var sprite = lq_defget(bullet, "curseSprite", global.sprFairy);
        if (sprite == global.sprFairy && random(59) < current_time_scale) {
            return global.sprFairy2
        }
        return sprite
    }
    return (random(59) < current_time_scale ? global.sprFairy2 :  global.sprFairy);

#define fairy_color
  return $FF3DAE;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name(spellPower, bullet)
    if (bullet != undefined) {
        return bullet.name;
    }
    return "CURSED";
    
#define bullet_ttip
  return `A FOREIGN POWER`;

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  // why is this sound so quiet compared to the others
  sound_play_pitch(sndSwapCursed,  1.2 * _p);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);


#define on_init(bullet)
    
    with bullet {
        
        curseSprite = global.fairySprites[irandom(array_length(global.fairySprites) - 1)]
        
        // Set effects and bullet power:
        var bulletPower = .9 + (.05 * irandom(6));
        effects = [global.positiveEffects[irandom(array_length(global.positiveEffects) - 1)],
                   global.positiveEffects[irandom(array_length(global.positiveEffects) - 1)],
                   global.negativeEffects[irandom(array_length(global.negativeEffects) - 1)]];
        
        // Name the bullet:
        var adjective = irandom(14) == 0 ? global.special_adjectives[irandom(array_length(global.special_adjectives) - 1)] : global.adjectives[irandom(array_length(global.adjectives) - 1)],
            noun = irandom(14) == 0 ? global.special_nouns[irandom(array_length(global.special_nouns) - 1)] : global.nouns[irandom(array_length(global.nouns) - 1)];
		if (irandom(99) <= 2) noun = global.preset_nouns[irandom(array_length(global.preset_nouns) - 1)]

        // Do wacky name effects:
        switch (adjective) {
            
            case "MAGGOT ": // Maggot time:
            	adjective = `@0(${sprMaggotIdle}:-1) `
            	array_push(effects, global.Maggot);
            	break;
            case "GOATED ": // Increase bullet power by 20%:
                bulletPower += .2;
                break;
                
            case "NORMAL ": // Remove random bullet power spread:
                bulletPower = 1;
                break;
                
            case "SOMEONE'S ": // Every version of cursed bullets is personalized
                var player = instance_nearest(1016, 1016, Player),
                    str_name = "SOMEONE";
                if (instance_exists(player)){            
                    str_name = string_upper(player_get_alias(player.index));
                  
                    // Seed setup so you always get the same ups/downs based on your alias:  
                    var seed = 0,
                        i = 0;
                    repeat(string_length(str_name)){
                        
                        seed += ord(string_char_at(str_name, i++));
                    }
                    
                    effects[0] = global.positiveEffects[seed          % (array_length(global.positiveEffects) - 1)]
                    effects[1] = global.positiveEffects[(seed * .43)  % (array_length(global.positiveEffects) - 1)]
                    effects[2] = global.negativeEffects[(seed * 1.78) % (array_length(global.negativeEffects) - 1)]
                    
                    adjective = str_name + "'S ";
                }
                break;
                
            case "MANIFOLD ": // +1 up +1 down
                effects[2] = global.positiveEffects[irandom(array_length(global.positiveEffects) - 1)];
                effects[3] = global.negativeEffects[irandom(array_length(global.negativeEffects) - 1)];
                effects[4] = global.negativeEffects[irandom(array_length(global.negativeEffects) - 1)];
                break;
                
            case "HORRENDOUS ": // Add 3 downsides:
                repeat(3) {
                    
                    array_push(effects, global.negativeEffects[irandom(array_length(global.negativeEffects) - 1)]);
                }
                break;
                
            case "THE WORST ": // Make this bullet contain all possible downsides and nothing else, then increase bullet power by 100%:
                for(var i = 0; i < array_length(global.negativeEffects); i++) {
                    
                    effects[i] = global.negativeEffects[i];
                }
                bulletPower += 1;
                break;
                
            case "SACRIFICIAL ": //Always has an hp down, alongside boosted power
                array_push(effects, global.sacrificialHPDown)
                bulletPower += 1
                break
                
            case "TEST ": // For testing
                effects[0] = global.positiveEffects[1];
                effects[1] = global.positiveEffects[1];
                effects[2] = global.positiveEffects[2];
                effects[3] = global.positiveEffects[1];
                effects[4] = global.positiveEffects[1];
                effects[5] = global.negativeEffects[2];
                break;
        }
        switch noun{
        	
        	case "HYPERIZER": // Fake old chicken active
        		effects = global.specialBulletHyperizer;
        		break;
        	case "CHAOS": // SPAM gun active
        		effects = global.specialBulletChaos;
        		break;
        	case "MICROBULLET": // Bullet swarm
        		effects = global.specialBulletMicro;
        		break;
        	case "TELEPORTER": // Bullet swarm
        		effects = global.specialBulletTeleporter;
        		break;
        }
        
        name = adjective + noun; 
        var endchar = string_char_at(name, string_length(name));
        if ( endchar == " " || endchar == "-"){
            
                name = string_delete(name, string_length(name), 1);
        }
        
        if (name == "") {
            
            bulletPower += 3;
            name = "idk";
        }
        
        var temp = []
        unpack(temp, effects)
        effects = temp
        
        bullet_power = bulletPower;
        based = true;
    }
    
#define bullet_effects(bullet)
    return bullet.effects

#define post_init(bullet)
    with bullet.effects {
        value *= bullet.bullet_power
        spellpower_scaling *= bullet.bullet_power
    }

#define on_fire
    var _p = random_range(.9, 1.1);
    var _s = sound_play_pitchvol(sndCursedPickup, 1 * _p, 1);
    audio_sound_set_track_position(_s, .25);

#define on_step
    if (random(6) < current_time_scale) {

        with instance_create(fairy.x + random_range(-sprite_get_width(fairy.sprite_back), sprite_get_width(fairy.sprite_back)) / 16 + fairy.creator.hspeed, fairy.y - sprite_get_height(fairy.sprite_back) / 32 * random_range(.8, 1), Curse) {depth = -12}
    }
    
#define personalities_init
    enum personality {
        aggressive, // All caps, replace . with !
        chill,      // All lowercase, remove punctuation
        normal      // Keep string unformatted
    }
    
    global.quip_positive_pickup = [
        "Hi.",
        "Hiiii.",
        "Hi hello hiii.",
        "What's up?",
        "Hello.",
        "Nice to see you.",
        "Well hello there.",
        "Hi Friend :)",
        "Let's go.",
        "A new friend."
    ];
    global.quip_positive_hurt = [
        "Don't give up!",
        "Just a scratch."
    ];
    global.quip_positive_idle = [
        "You got this.",
        "You look nice today.",
        "What a nice smile you have.",
        "I like you.",
        "We got this.",
        "This is awesome.",
        "I could stay with you here forever.",
        "It's nice being around you.",
        "You wanna hang later?",
        "We make a great team."
    ];
    global.quip_positive_drop = [
        "I'll miss you.",
        "Bye.",
        "Byeee~",
        "Goodbye.",
        "It was nice knowing you",
        "Do well, my friend.",
        "See you later.",
        "Go chase your dreams.",
        "Bye :("
    ];
    
    global.quip_negative_pickup = [
        "Oh.",
        "Ugh...",
        "Erm...",
        "No.",
        "Not this guy",
        "Huh??",
        "Hello i guess.",
        "Do i have to?",
        "Please leave me alone."
    ];
    global.quip_negative_hurt = [
        "Wow, you suck.",
        "Another one.",
        "It can't be that hard",
        "Skill issue.",
        "Lmao.",
        "Lol.",
        "Wow amazing job.",
        "How hard can it be?",
        "Again?",
        "You really like taking damage.",
        "You suck.",
        "Watch it buddy.",
        "Are you blind?",
        "What the hell are you doing?"
    ];
    global.quip_negative_idle = [
        "Hey. Screw you.",
        "God you're ugly.",
        "I Can't stand you.",
        "I don't like you.",
        "Please leave me alone.",
        "You smell awful.",
        "Why me?",
        "You're unbearable.",
        "Please die faster.",
        "How are you still alive?"
    ];
    global.quip_negative_drop = [
        "God, finally.",
        "And don't come back!",
        "See you in hell.",
        "Some people man.",
        "Eugh.",
        "I won't miss you."
    ];
    
#define names_init
    global.adjectives = [
        "DUBIOUS ",
        "CHANNELED ",
        "MASTER'S ",
        "VOLATILE ",
        "QUIRKY ",
        "POWERFUL ",
        "ENIGMATIC ",
        "HIGH ",
        "ENCHANTED ",
        "ENERGETIC ",
        "MYSTERIOUS ",
        "HOLLOW POINT ",
        "FULL METAL ",
        "STEEL ",
        "BRASS ",
        "LEAD ",
        "TERMINAL ",
        "CRYSTAL ",
        "CURSED ",
        "SUPER ",
        "MEGA-",
        "POWER-"
        ];
    global.special_adjectives = [ // Rarely used adjectives
        "THE ",
        "HUMOROUS ",
        "", // this is intentional
        "GOATED ",
        "NORMAL ",
        "MANIFOLD ",
        "HORRENDOUS ",
        "THE WORST ",
        "MAGGOT ",
        "SOMEONE'S ",
        "SACRIFICIAL "
        ];
    global.nouns = [
        "ROUND",
        "EVOCATION",
        "CALIBER",
        "SPELL",
        "SHELL",
        "SLUG",
        "FUEL",
        "POWDER",
        "BLANK",
        "CAP",
        "CARTRIDGE",
        "PROJECTILE",
        "BULLET",
        "INCANTATION",
        "HEX",
        "BLESSING"
        ];
    global.special_nouns = [ // Rarely used nouns
        "ROCK",
        "BUSTER",
        `@0(${global.sprEmote}:0)`,
        "" // also intentional
        ];
    global.preset_nouns = [ // Very rarely used nouns
    		"MICROBULLET",
    		"CHAOS",
    		"HYPERIZER",
    		"TELEPORTER"
    	];

#define effects_init
    global.positiveEffects = [];
    global.negativeEffects = [];
    
    add_positive(simple_stat_effect("maxhealth", 3, 2))
    add_negative(simple_stat_effect("maxhealth", -3, 0))
    //Used by sacrificial adjective, bullet power is always increased so its a low number
    global.sacrificialHPDown = simple_stat_effect("maxhealth", -2, 0)
    
    add_positive(simple_stat_effect("maxspeed", 1, 1))
    add_negative(simple_stat_effect("maxspeed", -1, 0))
    
    add_positive(effect_instance_named("size", .6, 1))
    add_negative(effect_instance_named("size", 1.5, 0))
    
    add_positive(simple_stat_effect("accuracy", .5, 0))
    add_negative(simple_stat_effect("accuracy", 1.8, 0))
    
    add_positive(simple_stat_effect("reloadspeed", .15, .15))
    add_negative(simple_stat_effect("reloadspeed", -.25, 0))

    add_positive(effect_instance_named("projectileSpeed", .25, .25))
    add_negative(effect_instance_named("projectileSpeed", -.25, 0))
    //Fuck it. 50% projectile speed boost
    add_positive(effect_instance_named("projectileSpeed", .5, 0))

    //Small damage down to weed out the pansies
    add_negative(effect_instance_named("projectileDamage", -.15, 0))
    
    add_positive(effect_instance_named("sustainChance", .20, .1))
    add_positive(effect_instance_named("autoFire", 1, 0))
    add_positive(effect_instance_named("projectileBounces", 1, 1))
    
    //Uses an array to bundle the effects
    add_positive([
        effect_instance_named("splitShot", 1, 1),
        //Reduced scaling, I want curse effects to be generally weaker than normal ones
        simple_stat_effect("reloadspeed", .6, .6)
    ])
    //Lets get creative with this one; split shot with no reload speed boost.
    add_negative(effect_instance_named("splitShot", .8, 0))
    
    //Weaker version of Burst, can have +1 or +2 shots
    add_positive([
        effect_instance_named("burstCount", 1, 1),
        simple_stat_effect("reloadspeed", -.6, 0)
    ])
    
    //I'm stupid
    //Huge damage, -80% projectile speed
    add_negative([
        effect_instance_named("projectileDamage", .8, 0),
        effect_instance_named("projectileSpeed", -.8, 0)
    ])
    
    //No scaling on this one. Don't feel like it.
    add_positive(effect_instance_named("projectileHyperSpeed", 1, 0))
    
    //Unique effects, not found on other bullets
      //HP change over time
    with effect_instance_named("hpRegen", 8, -1) {
        is_unique = true
        add_positive(self)
    }
    with effect_instance_named("hpLoss", 6, 0) {
        is_unique = true
        add_negative(self)
    }
      //Player will always fire if they can
    add_negative(effect_instance_named("forcedFiring", 1.2, 0))
      //Player will be knocked back when shooting
      add_negative([
    	effect_instance_named("knockbackOnShoot", 6, 0),
    	simple_stat_effect("maxspeed", 1, 0)
    ])
      //Enemy projectile speed changes
    add_negative(effect_instance_named("enemyProjectileSpeed", .35, 0))
    add_positive(effect_instance_named("enemyProjectileSpeed", -.2, 0))
      //Bullet talks nicely to you
    add_positive(effect_instance_named("pepTalk", 1, 0))
      //Bullet tries to hurt your feelings
    add_negative(effect_instance_named("smackTalk", 1, 0))
      //Toxic gas immunity
    add_positive(simple_stat_effect("notoxic", 1, 0))
      //Explosion immunity
    add_positive(effect_instance_named("noexplo", 1, 0));
      //Maggot
    global.Maggot = effect_instance_named("Maggot", 1, 0);
      //Shells on hurt
    add_positive(effect_instance_named("hurtToShell", 8, 4));
      //Disc on hurt
    add_negative(effect_instance_named("hurtToDisc", 3, 2));
    
    global.specialBulletHyperizer = [
    	effect_instance_named("projectileHyperSpeed", 10, 10),
    	effect_instance_named("projectileSpeed", .5, 0),
    	effect_instance_named("projectileDamage", 1, 0),
    	simple_stat_effect("reloadspeed", -.5, 0)
    ];
    global.specialBulletChaos = [
    	simple_stat_effect("accuracy", 90, 0),
    	simple_stat_effect("reloadspeed", 6, .5),
    	effect_instance_named("splitShot", 2, 0),
    	effect_instance_named("autoFire", 1, 0),
    	effect_instance_named("projectileSpeed", -.5, 0)
    ];
    global.specialBulletMicro = [
    	effect_instance_named("sustainChance", .75, 0),
    	simple_stat_effect("reloadspeed", .2, .2),
    	effect_instance_named("projectileDamage", -.75, 0)
    	
    ];
    global.specialBulletTeleporter = [
	    effect_instance_named("hurtToTeleport", 1, 0),
	    effect_instance_named("hurtToShell", 18, 6)
    ];
    
    //These aren't inlined so that changes can easily be made later
#define add_positive(effectInstances)
    array_push(global.positiveEffects, effectInstances)    

#define add_negative(effectInstances)
    array_push(global.negativeEffects, effectInstances)

#define get_random_positive
    return global.positiveEffects[irandom(array_length(global.positiveEffects) - 1)]

#define get_random_negative
    return global.negativeEffects[irandom(array_length(global.negativeEffects) - 1)]


#define get_effects(positiveCount, negativeCount)
    var effects = [];
    if (positiveCount > 0) {
        repeat(positiveCount) {
            //Uses unpack so that effects can be in 'sets' which are unpacked into the final array
            unpack(effects, get_random_positive())
        }
    }
    if (negativeCount > 0) {
        repeat(negativeCount) {
            unpack(effects, get_random_negative())
        }
    }
    return effects;

//'Flattens' stuff (an array), taking any content (even in subarrays) and adding it to the 'box'
#define unpack(box, stuff)
	for (var i = 0; i < array_length(stuff); i++) {
	    if is_array(stuff[i]){
	        unpack(box, stuff[i])
	    }
	    else{
	        array_push(box, stuff[i])
	    }
	}

//Effect types for curse bullet effects, unused elsewhere
#define effect_types_init
	/*with effect_type_create("noexplo", `@(color:${c.neutral})+@rEXPLOSION @(color:${c.neutral})IMMUNITY`, scr.describe_pass) {
		self.on_activate = script_ref_create(explo_activate)
		self.on_deactivate = script_ref_create(explo_deactivate)
		scr_positivity = scr.positivity_always_positive
	}*/
	with effect_type_create("hurtToTeleport", `@(color:${c.neutral})+@(color:${merge_color(c.speed, c.projectile_speed, .5)})TELEPORT @(color:${c.neutral})WHEN @wHIT`, scr.describe_pass) {
		self.on_hurt = script_ref_create(tp_hurt)
		scr_positivity = scr.positivity_always_positive
	}
	with effect_type_create("hurtToShell", `@(color:${c.neutral})+FIRE {} @(color:${c.ammo})SHELLS @(color:${c.neutral})WHEN @wHIT`, scr.describe_ceil) {
		self.on_hurt = script_ref_create(shells_hurt)
		scr_positivity = scr.positivity_always_positive
	}
	with effect_type_create("hurtToDisc", `@(color:${c.negative})+FIRE {} @(color:${c.ammo})DISCS @(color:${c.negative})WHEN @wHIT`, scr.describe_ceil) {
		self.on_hurt = script_ref_create(disc_hurt)
		scr_positivity = scr.positivity_always_negative
	}
	with effect_type_create("Maggot", `@(color:${c.neutral})+@wMAGGOT AVATAR`, scr.describe_whole) {
		self.on_activate = script_ref_create(maggot_activate, 1)
		self.on_deactivate = script_ref_create(maggot_deactivate, 1)
		scr_positivity = scr.positivity_always_positive
	}
	with effect_type_create("pepTalk", `@(color:${c.neutral})+@wPEP TALK`, scr.describe_whole) {
        self.on_step = script_ref_create(talk_step, 1)
        self.on_activate = script_ref_create(talk_activate, 1)
        self.on_deactivate = script_ref_create(talk_deactivate, 1)
        self.on_hurt = script_ref_create(talk_hurt, 1)
        scr_positivity = scr.positivity_always_positive
    }
    with effect_type_create("smackTalk", `@(color:${c.negative})+SMACK TALK`, scr.describe_whole) {
        self.on_step = script_ref_create(talk_step, 0)
        self.on_activate = script_ref_create(talk_activate, 0)
        self.on_deactivate = script_ref_create(talk_deactivate, 0)
        self.on_hurt = script_ref_create(talk_hurt, 0)
        scr_positivity = scr.positivity_always_negative
    }
    with effect_type_create("hpRegen", `@(color:${c.neutral})+@rHEAL @wEVERY {} @wSECONDS`, scr.describe_2a) {
        self.on_step = script_ref_create(bleed_step, 1)
        scr_positivity = scr.positivity_always_positive
    }
    with effect_type_create("hpLoss", `@(color:${c.negative})+@rBLEED @wEVERY {} @wSECONDS`, scr.describe_2a) {
        self.on_step = script_ref_create(bleed_step, -1)
        scr_positivity = scr.positivity_always_negative
    }
    with effect_type_create("forcedFiring", `@(color:${c.negative})+FORCED TO SHOOT`, scr.describe_pass) {
        self.on_step = script_ref_create(forced_firing_step)
        scr_positivity = scr.positivity_always_negative
    }
    with effect_type_create("knockbackOnShoot", `@(color:${c.negative})+EXTREME WEAPON KICK`, scr.describe_pass) {
        on_post_shoot = script_ref_create(knockback_shoot)
        scr_positivity = scr.positivity_always_negative
    }
    with effect_type_create("enemyProjectileSpeed", `{} @rENEMY @(color:${c.projectile_speed})PROJECTILE SPEED`, scr.describe_percentage) {
        on_enemy_projectiles = scr.projectile_speed_update
        scr_positivity = ["mod", "sageeffects", "positivity_compare_inverted", 0]
    }
#define tp_hurt(value, effect)
	if my_health > 0 {
		
		var _dist = 0,
		    _mdis = 48 + 16 * (6),
		    _dir = random(360)
		while(!place_meeting(x, y, Wall) && _dist < _mdis){
			x += lengthdir_x(sign(1), _dir);
			y += lengthdir_y(sign(1), _dir);
			_dist++;
		}
	}
#define explo_activate(value, effect)
	boilcap += 999999;
#define explo_deactivate(value, effect)
	boilcap -= 999999;
#define shells_hurt(value, effect)
	for(var i = 0, d = random(360); i < ceil(value); i++){
		
		with instance_create(x, y, Bullet2){
			
			creator = other;
			team = other.team;
			motion_add(d + random_range(4, 4) * other.accuracy, 16);
			image_angle = direction;
			
			d += 360/value;
		}
	}
#define disc_hurt(value, effect)
	for(var i = 0, d = random(360); i < ceil(value); i++){
		
		with instance_create(x, y, Disc){
			
			creator = other;
			team = other.team;
			motion_add(d + random_range(7, 7) * other.accuracy, 5);
			image_angle = direction;
			
			d += 360/value;
		}
	}
#define maggot_activate(value, effect)
	spr_idle = sprMaggotIdle;
	spr_sit1 = sprMaggotIdle;
	spr_sit2 = sprMaggotIdle;
	spr_walk = sprMaggotIdle;
	spr_hurt = sprMaggotHurt;
	spr_dead = sprMaggotDead;
	
	snd_wrld = sndBigMaggotUnburrow;
	snd_hurt = 350;
	snd_dead = 343;
	snd_lowa = sndBigMaggotBite;
	snd_lowh = 394;
	snd_chst = sndBigMaggotDie;
	snd_valt = sndBigMaggotBurrow;
	snd_crwn = sndBigMaggotHit;
	snd_spch = sndBigMaggotHit;
	snd_idpd = sndBigMaggotHit;
	snd_cptn = sndBigMaggotHit;
	
	spr_shadow_y -= 5;

#define maggot_deactivate(value, effect)
	mod_script_call("race", "sage", "assign_sprites");
	mod_script_call("race", "sage", "assign_sounds");
	spr_shadow_y += 5;
#define talk_activate(value, effect)
	with instances_matching(instances_matching(CustomObject, "creator", self), "name", "bullet_speechbubble") instance_destroy();
	with create_speechbubble(x, y){
				
		timer = 50;
		creator = other;
		text = value ? global.quip_positive_pickup[irandom_range(0, array_length(global.quip_positive_pickup) - 1)] : global.quip_negative_pickup[irandom_range(0, array_length(global.quip_negative_pickup) - 1)];
		text = talk_process_string(text, choose(personality.aggressive, personality.chill, personality.normal));
			
	}
#define talk_deactivate(value, effect)
	with instances_matching(instances_matching(CustomObject, "creator", self), "name", "bullet_speechbubble") instance_destroy();
	with create_speechbubble(x, y){
		
		timer = 50;
		creator = other;
		text = value ? global.quip_positive_drop[irandom_range(0, array_length(global.quip_positive_drop) - 1)] : global.quip_negative_drop[irandom_range(0, array_length(global.quip_negative_drop) - 1)];
		text = talk_process_string(text, choose(personality.aggressive, personality.chill, personality.normal));
			
	}
#define talk_hurt(value, effect)
	if (!irandom(3)){
		
		with instances_matching(instances_matching(CustomObject, "creator", self), "name", "bullet_speechbubble") instance_destroy();
		with create_speechbubble(x, y){
					
			timer = 50;
			creator = other;
			text = value ? global.quip_positive_hurt[irandom_range(0, array_length(global.quip_positive_hurt) - 1)] : global.quip_negative_hurt[irandom_range(0, array_length(global.quip_negative_hurt) - 1)];
			if !value && irandom(99) <= 4{
				
				text = "Wow look at me i'm" + player_get_alias(creator.index) + "# and all i do is take damage!"
			}
			
			text = talk_process_string(text, choose(personality.aggressive, personality.chill, personality.normal));
				
		}
	}
#define talk_step(value, effect)
	var _cantalk  = true;
	with instances_matching(instances_matching(CustomObject, "creator", self), "name", "bullet_speechbubble") _cantalk = false;
	if (!instance_exists(enemy) || instance_exists(SpiralCont)) _cantalk = false;
	
	if (_cantalk){
		
		if (irandom(room_speed * 8) <= current_time_scale){
			
			with create_speechbubble(x, y){
				
				creator = other;
				text = value ? global.quip_positive_idle[irandom_range(0, array_length(global.quip_positive_idle) - 1)] : global.quip_negative_idle[irandom_range(0, array_length(global.quip_positive_idle) - 1)];
				text = talk_process_string(text, choose(personality.aggressive, personality.chill, personality.normal));
			
			}
		}
	}
#define create_speechbubble(xx, yy)
	with instance_create(xx, yy, CustomObject){
	
		depth   = -300;
		creator = noone;
		timer   = 100;
		text    = "EMPTY";
		name    = "bullet_speechbubble"
		alpha   = 1;
	
		on_draw = speechbubble_draw;
		return self;
	}

#define talk_process_string(str, psn)
// Personality based string processing:
    var _str = str;
    switch(psn) {
        case personality.aggressive:
            _str = string_replace_all(_str, ".", choose("!", "!", "!", "!", "!!", "!!", "!!!")); // Swap dots with exlamation marks
            _str = string_upper(_str); // Turn string all uppercase
            break;
        case personality.chill:
        	_str = string_replace_all(_str, ".", "");
        	_str = string_replace_all(_str, ",", "");
        	_str = string_replace_all(_str, "!", "");
        	_str = string_replace_all(_str, "?", "");
        	_str = string_replace_all(_str, "'", "");
            _str = string_lower(_str); // Remove punctuation and turn it to all lowercase
            break;
        case personality.normal:
            break; // Nothing to do here
    }
    return _str;

#define speechbubble_draw
	if (instance_exists(creator)){
		if "fairy" in creator{
			
			x = creator.fairy.x;
			y = creator.fairy.y - 5;
		}else{
			
			x = creator.x;
			y = creator.y - 3;
		}
	}
	
	draw_set_font(fntChat);
	draw_set_alpha(alpha);
	
	draw_tooltip(x, y, text);
	draw_set_alpha(1);
	
	timer -= current_time_scale;
	if timer <= 0{
		
		alpha -= .45 / current_time_scale;
		if (alpha <= -50) instance_destroy();
		
	}
	
#define bleed_step(hpChange, value, effect)
    if (effect.is_unique) {
        var time = lq_defget(effect, "bleed_time", value * 30);
        time -= current_time_scale
        if time <= 0 {
            if (hpChange > 0) {
                my_health += hpChange
                instance_create(x, y, HealFX)
                sound_play_pitchvol(sndHPPickup, 1.5, .6)
                my_health = min(maxhealth, my_health)
            }
            else {
                projectile_hit(self, -hpChange, 0, 0)
                instance_create(x, y, HealFX).image_blend = c_black
                sound_play_pitchvol(sndAllyDead, 1.5, .6)
                lasthit = [sprAllyDamage, "BLEED OUT"]
            }
            time = 30 * value
        }
        effect.bleed_time = time
    }
    
#define forced_firing_step(value, effect)
    if (player_canshoot) {
        mod_script_call_self("race", "sage", "sage_fire_default")
    }
    
#macro player_canshoot
    canfire
    && can_shoot == true
    && (ammo[weapon_get_type(wep)] >= weapon_get_cost(wep) || infammo != 0)
    && (GameCont.rad >= weapon_get_rads(wep) || infammo != 0)
    && visible
    && !instance_exists(GenCont)
    && !instance_exists(LevCont)
    && !instance_exists(PlayerSit)
    && !array_length(instances_matching(CrystalShield, "creator", self))
    
#define knockback_shoot(value, effect, shootEvent)
    var speedCap = max(speed, maxspeed),
        angle = gunangle + lq_defget(shootEvent, "angle_offset", 0) + 180;
    motion_add(angle, value)
    if (speed > speedCap) {
        speed = speedCap
    }

#define simple_stat_effect(variableName, value, scaling) return mod_script_call("mod", "sageeffects", "simple_stat_effect", variableName, value, scaling)
#define effect_instance_named(effectName, value, scaling) return mod_script_call("mod", "sageeffects", "effect_instance_create", value, scaling, effectName)
#define effect_type_create(name, description, describe_script) return mod_script_call("mod", "sageeffects", "effect_type_create", name, description, describe_script)
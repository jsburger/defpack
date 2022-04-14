#define init

    #macro effectTypes global.effectTypes
    effectTypes = ds_map_create();
    
    global.projSpeedTracker = noone;
    
    #macro scr global.scr
    scr = {}
    for(var i = 1; true; i++) {
        var _name = script_get_name(i);
        if(is_undefined(_name)) {
            break;
        }
        lq_set(scr, _name, script_ref_create(i));
    }
    
    effects_init()


#macro c mod_variable_get("race", "sage", "colormap");

enum operators {
        add,
        multiply
    }

#define cleanup
	with global.projSpeedTracker instance_destroy()

//So other mods can use the enum
#define operator_get(operator_string)
    switch (operator_string) {
        case "add" : return operators.add;
        case "multiply" : return operators.multiply;
    }


#define effects_init

    //Common stats
    //Reload speed
    stat_effect_type_create("reloadspeed", operators.add, `{} @(color:${c.reload})RELOAD SPEED`, describe_percentage)
    //Max speed
    stat_effect_type_create("maxspeed", operators.add, `{} @(color:${c.speed})SPEED`, describe_2a)
    //Accuracy
    with stat_effect_type_create("accuracy", operators.multiply, `{} @(color:${c.accuracy})ACCURACY`, script_ref_create(describe_rounded_inverse_multiplicative_precentage, 5)) {
        //If value is greater than 1, effect is negative, etc.
        scr_positivity = script_ref_create(positivity_compare_inverted, 1)
    }
    //Max health
    //Special case for maxhealth because it has the additional effect of changing sage's current health. Uses statEffect_ prefix to get picked up by simple_stat_effect()
    with effect_type_create("statEffect_maxhealth", `{} @rMAX HP`, describe_whole) {
        on_activate = script_ref_create(max_health_activate)
        on_deactivate = script_ref_create(max_health_deactivate)
    }
    //Toxic Immunity
    stat_effect_type_create("notoxic", operators.add, `@gTOXIC IMMUNITY`, describe_pass)
    
    //Other common effects
    //Projectile Speed
    with effect_type_create("projectileSpeed", `{} @(color:${c.projectile_speed})PROJECTILE SPEED`, describe_percentage) {
        on_new_projectiles = script_ref_create(projectile_speed_update)
    }
    //Damage multiplier, also increases size
    with effect_type_create("projectileDamage", `{} @rDAMAGE`, describe_percentage) {
        on_new_projectiles = script_ref_create(projectile_damage_update)
    }
    
    //Uncommon effects
    //Size
    with effect_type_create("size", `{} @wSIZE`, describe_size) {
        effect_type_make_multiplicative(self)
        on_activate = script_ref_create(size_activate)
        on_deactivate = script_ref_create(size_deactivate)
        scr_positivity = script_ref_create(positivity_compare, 1)
    }
    
    //Auto fire
    with effect_type_create("autoFire", `@(color:${c.neutral})+@wAUTOMATIC WEAPONS`, describe_nothing) {
		on_step = script_ref_create(auto_step)
    }
    

    
//Effects Core below

//Call this and then set further, optional, script hooks using the returned LWO.
//Calling this from another mod file will require both scripts be given as script refs (ala script_ref_create)
#define effect_type_create
var name = argument[0];
var description = argument_count > 1 ? argument[1] : "{} "+ name;
var describe_script = argument_count > 2 ? argument[2] : describe_pass;

    var typ = {
        //Used to compare two types to see if they are the same. Keys into global map to get new copies
        "name" : name,
        //Called to calculate the 'value' of an effect, is given the effect instance and spellpower
        scr_calculate_value : get_script_ref(calculate_additive),
        //Called with an array of effect instances of the same type being combined. Returns the final value of all their values combined.
        scr_combine_values : get_script_ref(combine_additive),
        //Used to display the effect via text on tooltips, {} is replaced with value run through scr_value_descriptor
        descriptor : description,
        //Called with value to turn things like .25 into 25%.
        scr_value_descriptor : get_script_ref(describe_script),
        //Called with value to see if an effect is positive or not. Returns 1 for positive, 0 neutral, -1 negative. Controls coloring in descriptions
        //Feel free to overwrite this.
        scr_positivity : script_ref_create(positivity_compare, 0)
    };
    
    global.effectTypes[? name] = typ
    return typ;

#define get_script_ref(script)
    return is_array(script) ? script : script_ref_create(script);
    
    
//These are what bullets will use to declare their effects.
//They are cloned after being returned in a bullet.
#define effect_instance_create(base_value, scaling, typeNameOrObject)
	if is_string(typeNameOrObject) {
		var type = effectTypes[? typeNameOrObject],
			effectInstance = effect_instance_create_typed(base_value, scaling, {});
		if fork() {
			var i = 0;
			//Try to let other mods initialize types
			while (type == undefined && i <= 15) {
				i++
				wait(1)
				type = effectTypes[? typeNameOrObject]
			}
			//If no mod has made the type, report that
			if (type == undefined) {
				trace_color(`ERROR: Effect Type '${typeNameOrObject}' does not exist.`, c_red)
			}
			//Update the returned instance's type
			effectInstance.type = type
			exit
		}
		return effectInstance;
	}
    return effect_instance_create_typed(base_value, scaling, typeNameOrObject);

#define effect_instance_create_typed(base_value, scaling, effectType)
    return {
        type : effectType,
        value : base_value,
        spellpower_scaling : scaling,
        //Determines if effect shouldn't be composed.
        //Prevents stacking and allows storing information in effect instances.
        is_unique : false
    }
    
//The combination of two or more effect instances. Only intended to be used for its value field.
//Has value and unique fields for parity, they are not used.
//Theoretically could be composed again. This is not supported and may have side effects.
#define composite_effect_create(calculated_value, effectType)
    return {
        type : effectType,
        //working_value is directly fed to functions.
        working_value : calculated_value,
        //Everything below this line is for parity sake and does affect default functionality.
        value : calculated_value,
        spellpower_scaling : 0,
        is_unique : false
    }

//Whenever an effect instance is cloned, so is it's type.
#define effect_instance_clone(effect_instance)
    var clone = lq_clone(effect_instance);
    clone.type = effect_type_get_fresh(clone.type);
    return clone


//Tries to get a fresh copy of the effect type. If no such thing exists, just return a clone.
//Allows for modifying types dynamically, but only if you change the name to something unique,
//thus enforcing the stacking scheme.
#define effect_type_get_fresh(effectType)
    var typeInMap = effectTypes[? effectType.name];
    if (typeInMap == undefined) {
        return lq_clone(effectType);
    }
    return lq_clone(typeInMap);


//Returns a composite effect of the given effects
#define effects_compose(effectList, spellPower)
    //Since effect types are already going to be the same, just use the one from the first element
    var effectType = effect_type_get_fresh(effectList[0].type);

    with effectList {
        //Pass the effect instance in directly, instead of composing
        if (is_unique) {
            working_value = effect_calculate_value(self, spellPower)
            return self;
        }
    }
    
    var combinedValue = script_ref_call(effectType.scr_combine_values, effectList, spellPower)
    
    return composite_effect_create(combinedValue, effectType);

//Returns an array of composite effects for each unique effect type in the input
#define effects_compose_all(effectList, spellPower)
	var composed = [],
		types = sorting_map_create();
		
	//Build list of duplicates for stacking
	with effectList {
		//Unique effect instances don't get composed, but are treated as if they are.
		//This allows for effects to store info in themselves, as normal composite effects are disposable and cannot do so reliably.
		if (is_unique) {
			//In this case, use the pointer of the instance as its key, so that it won't stack with anything
			sorting_map_add(types, self, self)
		}
		else {
			//Add effect instances to arrays in map, based on the name of their type
			sorting_map_add(types, self.type.name, self)
		}
	}
	
	//Iterate through the now sorted values, combining any duplicate effects
	for (var sorted = sorting_map_values(types), i = 0, l = array_length(sorted); i < l; i++) {
		//Composes all effects in the list, returning one effect
		array_push(composed, effects_compose(sorted[i], spellPower))
	}
	
	sorting_map_destroy(types)
	return composed;
	
//Gets the working value for effect scripts of composite effects. Calculated once per composite effect.
#define effect_calculate_value(effect, spellPower)
    return script_ref_call(effect.type.scr_calculate_value, effect, spellPower);
    

//Calls any script references in list of effects, passing standardized arguments.
#define effects_call(effectList, script, args1, args2)
    for(var i = 0; i < array_length(effectList); i++) {
        var ref = lq_get(effectList[i].type, script);
        
        if (ref != undefined) {
            script_ref_call(ref, effectList[i].working_value, effectList[i], args1, args2);
        }
    }
    
//Calls scripts in reverse. Specifically used for processes that are being reversed, ie: deactivation.
#define effects_call_reverse(effectList, script, args1, args2)
    for(var i = array_length(effectList) - 1; i >= 0 ; i--) {
        var ref = lq_get(effectList[i].type, script);
        
        if (ref != undefined) {
            script_ref_call(ref, effectList[i].working_value, effectList[i], args1, args2);
        }
    }
    
//Fetches effects from bullets and clones them.
#define bullet_get_effects(bullet)
    var effects = mod_script_call("mod", bullet.type, "bullet_effects", bullet);
    if (effects == undefined) {
        trace_color(`Bullet '${bullet.type}' has no effects`, c_yellow)
        return []
    }
    if !is_array(effects) {
        return [effect_instance_clone(effects)]
    }
    else {
        var ret = [];
        for (var i = 0, l = array_length(effects); i < l; i++) {
            array_push(ret, effect_instance_clone(effects[i]))
        }
        return ret;
    }
    
//Gets the positivity of an effect.
#define effect_positivity(effect, spellPower)
	var value;
    //Check for being a composite effect and use its precalculated value.
    if (lq_exists(effect, "working_value") && !effect.is_unique) {
        value = effect.working_value
    }
    else {
        value = effect_calculate_value(effect, spellPower)
    }
    return script_ref_call(effect.type.scr_positivity, value);

    
//Generates the description for a single effect
#define effect_get_description(effect, spellPower)
    var value;
    //Check for being a composite effect and use its precalculated value.
    if (lq_exists(effect, "working_value") && !effect.is_unique) {
        value = effect.working_value
    }
    else {
        value = effect_calculate_value(effect, spellPower)
    }
    var template = effect.type.descriptor,
        described = script_ref_call(effect.type.scr_value_descriptor, value);
    
    if (string_count("{}", template) == 0) {
        return template
    }
    
    var positivity = script_ref_call(effect.type.scr_positivity, value);
    switch(positivity) {
        //Add +. No break so it also gets the neutral color
        case 1:
        case 0: 
        	described = "+" + described
        	described = `@(color:${c.neutral})${described}`; break
        //Add negative color
        case -1: described = `@(color:${c.negative})${described}`; break
        //Yell at people who did it wrong
        default: trace("Effect type", effect.type.name, "has an improper output range on its positivity script. Should be [-1, 0, 1]. Got", positivity)
    }
    //Add color to back for consistency
    described = `${described}@(color:${c.neutral})`
    
    return string_replace(template, "{}", described);

//Gets effect descriptions and stitches them together
#define effects_descriptions(effectList, spellPower)
    var description = "",
    	positive = [],
    	neutral = [],
    	negative = [];
    for (var i = 0; i < array_length(effectList); i++) {
    	var positivity = effect_positivity(effectList[i], spellPower),
    		effectDescription = effect_get_description(effectList[i], spellPower);
    	switch(positivity) {
    		case 1: array_push(positive, effectDescription) break
    		case 0: array_push(neutral, effectDescription) break
    		case -1: array_push(negative, effectDescription) break
    	}
    }
    if array_length(positive) > 0 {
    	description += array_join(positive, "#")
    }
    // if array_length(neutral) > 0 {
    // 	description += "#"
    // 	description += array_join(neutral, "#")
    // }
    if array_length(negative) > 0 {
    	description += "#"
    	description += array_join(negative, "#")
    }
    description += "#"

    return description;

//Gets the description of every effect in a bullet and combines them for drawing
#define bullet_get_description(bullet, spellPower)
    return effects_descriptions(effects_compose_all(bullet.effects, spellPower), spellPower)

//Specific purpose stuff below

//Makes an effect type multiplicative. Meant for convenience
#define effect_type_make_multiplicative(effectType)
    effectType.scr_calculate_value = get_script_ref(calculate_multiplicative)
    effectType.scr_combine_values = get_script_ref(combine_multiplicative)

//Script for easily creating simple stat effects. Is not the end-all be-all for stat modifiers, just streamlines the process.
#define stat_effect_type_create
var variableName = argument[0], operator = argument[1], description = argument[2];
var describe_script = argument_count > 3 ? argument[3] : describe_pass;
    
    var effectName = `statEffect_${variableName}`,
        effectType = effectTypes[? effectName];

    //Convert "add" to operators.add, for convenience
    if is_string(operator) {
        operator = operator_get(operator)
    }

    //If type for this variable doesn't exist, make one
    if (effectType == undefined) {
        effectType = effect_type_create(effectName, description, describe_script)
        effectType.on_activate = script_ref_create(stat_effect_activate, variableName, operator)
        effectType.on_deactivate = script_ref_create(stat_effect_deactivate, variableName, operator)
        if (operator == operators.multiply) {
            effect_type_make_multiplicative(effectType)
        }
    }
    
    return effectType;
    
#define stat_effect_activate(variableName, operator, value, effect)
    var currentValue = variable_instance_get(self, variableName, 0);
        
    if (operator == operators.add) {
        currentValue += value;
    }
    else if (operator == operators.multiply) {
        currentValue *= value;
    }
    
    variable_instance_set(self, variableName, currentValue);
    
#define stat_effect_deactivate(variableName, operator, value, effect)
    var currentValue = variable_instance_get(self, variableName, 0);
        
    if (operator == operators.add) {
        currentValue -= value;
    }
    else if (operator == operators.multiply) {
        currentValue /= value;
    }
    
    variable_instance_set(self, variableName, currentValue);
    

//Quickly make effects that modify a single stat, checking automatically for effect types that handle the variable
#define simple_stat_effect(variableName, base_value, scaling)
    var effectType = effectTypes[? "statEffect_" + variableName];
    
    if (effectType == undefined) {
        trace_color(`ERROR: No effect type for variable '${variableName}' exists. Make one before calling simple_stat_effect()`, c_red)
        return undefined
    }
    
    return effect_instance_create_typed(base_value, scaling, effectType);
    

//Scripts for individual effects

#define max_health_activate(value, effect)
	value = ceil(abs(value)) * sign(value);
    maxhealth += value
    if (value > 0) {
        my_health += value
    }
    my_health = min(my_health, maxhealth)
    
    if (maxhealth <= 0) {
        lasthit = [sprHealFX, "SPELL BULLET"]
    }

#define max_health_deactivate(value, effect)
	value = ceil(abs(value)) * sign(value);
    maxhealth -= value
    if (value > 0) {
        my_health = max(my_health - value, 1)
    }
    my_health = min(my_health, maxhealth)


#macro speed_boost_perma [Rocket, Nuke, PlasmaBall, PlasmaBig, PlasmaHuge, Seeker]

#define projectile_speed_update(value, effect, newProjectiles)
    with newProjectiles {
        //Requires a permanent speed tracker
        if array_find_index(speed_boost_perma, object_index) >= 0 {
            track_speed_down(self, instance_is(self, Seeker) ? value / 1.5 : value)
        }
        //Normal Projectiles
        else {
    		// Modify speed and maxspeed
    		speed *= 1 + value

    		if "maxspeed" in self {
    			maxspeed *= 1 + value;
    		}
    		if "max_speed" in self {
    			max_speed *= 1 + value;
    		}
    		//im sure this is used somewhere
    		if "maxspd" in self {
    		    maxspd *= 1 + value
    		}
    
    		// this makes shells not godawful with low projectile speed
    		if friction > 0 {
    		    //karm i changed this so that shells felt more like they benefitted from proj speed
    			friction *= power(1 + value, value > 0 ? 1 : 1.25);
    		}
        }
    }

#define track_speed_down(proj, modifier)
	if !instance_exists(global.projSpeedTracker) {
		with script_bind_step(apply_permanent_speed, 0) {
			projectiles = []
			global.projSpeedTracker = self
		}
	}
	proj.sage_projectile_speed_modifier = modifier
	array_push(global.projSpeedTracker.projectiles, proj)

#define apply_permanent_speed
	var proj = instances_matching_ne(projectiles, "id");
	if array_length(proj) == 0 {
		instance_destroy()
		exit
	}
	else projectiles = proj
	with proj {
		x += lengthdir_x(speed_raw * sage_projectile_speed_modifier, direction)
		y += lengthdir_y(speed_raw * sage_projectile_speed_modifier, direction)
	}



#define projectile_damage_update(value, effect, newProjectiles)
	with newProjectiles {
		
		damage = ceil(damage * (1 + value));
		if !instance_is(self, Lightning) && !instance_is(self, Laser) {
			image_xscale *= 1 + clamp(value, -.5, .5);
		}
		image_yscale *= 1 +clamp(value, -.5, .5);
	}


#define size_activate(value, effect)
    image_xscale *= value
    image_yscale *= value

#define size_deactivate(value, effect)
    image_xscale /= value
    image_yscale /= value


#define auto_step(value, effect)
	if (value > 0) {
		//We do a little trolling
		if (weapon_get_auto(wep) == 0 || wep == "infinipistol") {
			clicked = button_check(index, "fire")
		}
	}


//Utility scripts
#define calculate_additive(effect, spellPower)
    return (effect.value + effect.spellpower_scaling * spellPower)

#define combine_additive(effectList, spellPower)
    var ret = 0;
    with effectList {
        ret += effect_calculate_value(self, spellPower)
    }
    return ret;
    
//Used for things like accuracy, which require multiplication to stack properly.
#define calculate_multiplicative(effect, spellPower)
    return (power(effect.value, 1 + effect.spellpower_scaling * spellPower))

#define combine_multiplicative(effectList, spellPower)
    var ret = 1;
    with effectList {
        ret *= effect_calculate_value(self, spellPower)
    }
    return ret;

//Note: comparison is provided through the script_ref_create. The script_ref_call ONLY provides value.
#define positivity_compare(comparison, value)
    if (value > comparison) return 1
    if (value < comparison) return -1
    return 0
    
#define positivity_compare_inverted(comparison, value)
    return -1 * positivity_compare(comparison, value);
    
#define positivity_always_positive(value)
	return 1

#define positivity_always_negative(value)
	return -1


    //.25 -> .25
#define describe_pass(_var)
    return string(_var);
    
    //.25 -> 1, -.25 -> -1, 1 -> 1
#define describe_whole(_var)
    var v = ceil(abs(_var)) * sign(_var);
    return string(v);
    
    //.25 -> 0, -.25 -> 0
#define describe_floor(_var)
    var v = floor(abs(_var)) * sign(_var);
    return string(v);
    
    //.25 -> 25%
#define describe_percentage(_var)
    var v = (round(abs(_var * 100)) * sign(_var));
    return string(v) + "%";
    
    
#define describe_rounded_percentage(roundedTo, _var)
    var v = (round(abs(_var * 100)) * sign(_var));
    v -= v mod roundedTo;
    return string(v) + "%"

    //Hard to convey because it applies to another multiplier where the larger it is the worse it is (ex: player accuracy)
    //x <= 1: Just describes the actual percent reduction. Listed as positive because this is inverted.
    //x > 1: Describes the proportion of the total that the change in value has occupied. Approaches -100% as x approaches infinity
    //(ex: -60% (x = 2.5) means that 60% of the total value is occupied by the increase, and the base value occupies 40%)
#define describe_inverse_multiplicative_precentage(_var)
    if (_var <= 1) {
        return describe_percentage(1 - _var);
    }
    return describe_percentage(-(1 - 1/_var));

#define describe_rounded_inverse_multiplicative_precentage(roundedTo, _var)
    if (_var <= 1) {
        return describe_rounded_percentage(roundedTo, 1 - _var);
    }
    return describe_rounded_percentage(roundedTo, -(1 - 1/_var));

#define describe_size(_var)
    return describe_percentage(_var - 1)


    //.25 -> 0.25, .025 -> 0.03
#define describe_2a(_var) // 2a = accuracy of 2, 2 digits after the comma (1,xx)
	return string_format(_var, 0, 2)

    var v = string(round(_var * 100) / 100);
    
    for(var i = string_length(v); i < (sign(_var) == -1 ? 5 : 4); i++){
        
        if (i == 1) {
            
            v += ".";
        }
        else {
            
            v += "0";
        }
    }

    return(v);
    
    //.25 -> 
#define describe_nothing
    return "";
    

//Data structure that allows multiple values occupy the same key and returns its values in the order they were added
//Make sure to destroy it when you're done. It still uses a ds_map
#define sorting_map_create()
	return {
		map: ds_map_create(),
		list: []
	}
	
#define sorting_map_add(map, key, value)
	var index = map.map[? key];
	if (index == undefined) {
		index = array_length(map.list)
		array_push(map.list, [])
	}
	map.map[? key] = index
	array_push(map.list[index], value)

//Returns an array
#define sorting_map_get(map, key)
	var index = map.map[? key];
	if (index == undefined) {
		return undefined
	}
	return map.list[index]

//Returns an array of arrays
#define sorting_map_values(map)
	return map.list

#define sorting_map_destroy(map)
	ds_map_destroy(map.map)
	
#define weapon_get(wep)
	if is_object(wep) {
		var innerWep = lq_defget(wep, "wep", wep_none);
		if (is_real(innerWep)) return innerWep;
		if (is_string(innerWep)) {
			var rawCheck = mod_script_call("weapon", innerWep, "weapon_raw", wep);
			if (rawCheck != undefined) {
				return weapon_get(rawCheck)
			}
		}
		return weapon_get(innerWep)
	}
	if is_string(wep) return string_lower(wep)
	return wep


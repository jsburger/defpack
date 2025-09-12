#define burst(_rounds, _delay, _creator, _script)
	return burst_create(_rounds, _delay, _creator, _script);
	
#define burst_create(_rounds, _delay, _creator, _script)
	with instance_create(0, 0, CustomObject) {
		ammo = _rounds
		delay = _delay
		creator = _creator
		fire_script = _script
		
		reload = 0
		shots_fired = 0
		on_step = script_ref_create(burst_step)
		
		burst_step()
		
		return self;
	}

#define burst_step
	if instance_exists(creator) {
		if reload > 0 {
			reload -= current_time_scale
		}
		else while reload <= 0 {
			reload += delay
			ammo -= 1;
			with creator {
				mod_script_call(other.fire_script[0], other.fire_script[1], other.fire_script[2], other)
			}
			shots_fired += 1
			if ammo <= 0 {
				instance_destroy()
				exit
			}
		}
	}
	else {
		instance_destroy()
	}

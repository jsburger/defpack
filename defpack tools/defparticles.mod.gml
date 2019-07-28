#define init
    global.bonusparticles = 0
    mod_script_call("mod","defpermissions","permission_register","mod",mod_current,"bonusparticles","Extra Particles")
    global.particlelimit = 0
    mod_script_call("mod","defpermissions","permission_register_range","mod",mod_current,"particlelimit","Particle Limit",[0, 200],["No Limit", "200"])

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define create_spark(_x,_y)
with instance_create(_x,_y,CustomObject){
    gravity = .25
    motion_add(random_range(180,0),random_range(1,5))
    friction = .1
    color = c_orange
    fadecolor = c_yellow
    fadespeed = .1
    age = 15
    depth = -3
    name = "spark"
    
    on_step = sparkstep
    on_draw = sparkdraw
    
    return id
}

#define sparkstep
    color = merge_color(color,fadecolor,fadespeed*current_time_scale)
    age -= current_time_scale
    if age <= 0 instance_destroy()

#define sparkdraw
    draw_line_width_color(x,y,lerp(x,xprevious,1/current_time_scale),lerp(y,yprevious,1/current_time_scale),1,color,color)
    
//thanks gunlocker, heheheh
#define create_waver(_x,_y)
with instance_create(_x,_y,PlasmaTrail){
    name = "waver"
    friction = -.1
	image_speed /= 1 + random(3);
    direction = random(360)
    image_angle = random(360)
    turn = random_range(-50,50)
    
    if(fork()){
    	wait 0;
    	if(instance_exists(self)){
    		var _wave = random(360);
    		var _odir = direction;
    		var _oang = image_angle;
    	
    		while(instance_exists(self)){
    			_wave += 0.25*current_time_scale;
    			turn += random_range(-1,1)*current_time_scale
    			direction = _odir + sin(_wave) * turn;
    			image_angle = _oang + sin(_wave) * turn;
    			wait 0;
    		}
    	}
    	exit;
    }
    
    return id
}



#define step
    if global.particlelimit{
        var sparks = instances_matching(CustomObject,"name","spark")
        var num = array_length_1d(sparks)
        while num > global.particlelimit
            with sparks[irandom(array_length_1d(sparks)-1)]
                if instance_exists(self) {num--; instance_destroy();}
    }
    if global.bonusparticles{
        /*with PlasmaBall{
            if !irandom(3) with create_waver(x,y){
                speed = random(1)
                direction = other.direction + random_range(-90,90)
            }
        }*/
        with instances_matching(Explosion,"sparked",null){
            sparked = 1
            var colors = [c_red,c_yellow]
            if instance_is(self,GreenExplosion) colors = [c_green,c_yellow]
            if instance_is(self,PopoExplosion) colors = [c_blue,c_aqua]
            if array_length_1d(instances_matching(CustomObject,"name","spark")) < 40 repeat(random(2*damage)) with create_spark(x+random_range(-5,5),y+random_range(-5,5)){
                vspeed -= 5
                gravity = .4
                color = colors[0]
                fadecolor = colors[1]
                age = 20
                depth = other.depth+1
            }
        }
        with instances_matching(RainSplash,"sparked",null){
            sparked = 1
            repeat(random(4)) with create_spark(x,y){
                color = c_white
                fadecolor = c_white
            }
        }
        with SawBurst{
            repeat(random(10/current_time_scale)) with create_spark(x,y){
                direction = other.direction + random_range(-50,50)
                speed = random(10)
                gravity = 0
                age = max(2*speed,5)
                color = c_white
                fadespeed = .4
                fadecolor = c_white
                friction = 1
                depth++
            }
        }
        with instances_matching(CustomProjectile,"name","mega lightning bullet"){
            repeat(random(6)) with create_spark(x,y){
                color = c_blue
                fadecolor = c_aqua
            }
        }
    }
    //if button_check(0,"nort") create_spark(mouse_x,mouse_y)
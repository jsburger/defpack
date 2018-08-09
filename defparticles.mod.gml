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
    
    on_step = sparkstep
    on_draw = sparkdraw
    
    return id
}

#define sparkstep
    color = merge_color(color,fadecolor,fadespeed*current_time_scale)
    age -= current_time_scale
    if age <= 0 instance_destroy()

#define sparkdraw
    draw_line_width_color(x,y,xprevious,yprevious,1,color,color)
    
#define step
    with instances_matching(instances_matching(CustomProjectile,"name","Psy Bullet"),"sparked",null){
        sparked = 1
        repeat(random(6)) with create_spark(x,y){
            direction = other.direction + random_range(-40,40)
            speed = random(10)
            gravity = 0
            age = max(2*speed,5)
            color = c_purple
            fadecolor = c_fuchsia
            friction = 1
        }
    }
    with instances_matching(Explosion,"sparked",null){
        sparked = 1
        repeat(random(2*damage)) with create_spark(x+random_range(-5,5),y+random_range(-5,5)){
            vspeed -= 5
            gravity = .4
            color = c_red
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
        repeat(random(10)) with create_spark(x,y){
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
    //if button_check(0,"nort") create_spark(mouse_x,mouse_y)
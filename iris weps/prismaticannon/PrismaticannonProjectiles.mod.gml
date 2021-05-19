#define init

//No iris Effect
global.sprNormalBullet = sprite_add("sprites/sprNormalBullet.png", 3, 26, 6);

//Pest
global.sprPestBullet = sprite_add("sprites/sprPestBullet.png", 3, 26, 6);
global.sprPestBubbleTrail = sprite_add("sprites/sprPestBubbleTrail.png",3,4,4)
global.sprPestPlasma = sprite_add("sprites/sprPestPlasmaBall.png", 2, 12, 12);
global.sprPestPlasmaImpact = sprite_add("sprites/sprPestPlasmaImpact.png", 7, 16, 16);
global.sprPestPlasmaTrail = sprite_add("sprites/sprPestPlasmaTrail.png", 3, 4, 4);

//Flame
global.sprFlameBullet = sprite_add("sprites/sprFlameBullet.png", 3, 26, 6);
global.sprFlamePlasma = sprite_add("sprites/sprFlamePlasmaBall.png", 2, 12, 12);
global.sprFlamePlasmaImpact = sprite_add("sprites/sprFlamePlasmaImpact.png", 7, 16, 16);
global.sprFlamePlasmaTrail = sprite_add("sprites/sprFlamePlasmaTrail.png", 3, 4, 4);

//Psy
global.sprPsyBullet = sprite_add("sprites/sprPsyBullet.png", 3, 26, 6);
global.sprPsyPlasma = sprite_add("sprites/sprPsyPlasmaBall.png", 2, 12, 12);
global.sprPsyPlasmaImpact = sprite_add("sprites/sprPsyPlasmaImpact.png", 7, 16, 16);
global.sprPsyPlasmaTrail = sprite_add("sprites/sprPsyPlasmaTrail.png", 3, 4, 4);

//Bouncy
global.sprBouncyBullet = sprite_add("sprites/sprBouncyBullet.png", 3, 26, 6);
global.sprBouncyPlasma = sprite_add("sprites/sprBouncyPlasmaBall.png", 2, 12, 12);
global.sprBouncyPlasmaImpact = sprite_add("sprites/sprBouncyPlasmaImpact.png", 7, 16, 16);
global.sprBouncyPlasmaTrail = sprite_add("sprites/sprBouncyPlasmaTrail.png", 3, 4, 4);

//Lightning
global.sprLightningBullet = sprite_add("sprites/sprLightningBullet.png", 3, 26, 6);
global.sprLightningPlasma = sprite_add("sprites/sprLightningPlasmaBall.png", 2, 12, 12);
global.sprLightningPlasmaImpact = sprite_add("sprites/sprLightningPlasmaImpact.png", 7, 16, 16);
global.sprLightningPlasmaTrail = sprite_add("sprites/sprLightningPlasmaTrail.png", 3, 4, 4);

//Gamma
global.sprGammaBullet = sprite_add("sprites/sprGammaBullet.png", 3, 26, 6);
global.sprGammaPlasma = sprite_add("sprites/sprGammaPlasmaBall.png", 2, 12, 12);
global.sprGammaPlasmaImpact = sprite_add("sprites/sprGammaPlasmaImpact.png", 7, 16, 16);
global.sprGammaPlasmaTrail = sprite_add("sprites/sprGammaPlasmaTrail.png", 3, 4, 4);

//psy stuff that I dont understand
#define instance_nearest_matching_ne(_x,_y,obj,varname,value)
var num = instance_number(obj),
    man = instance_nearest(_x,_y,obj),
    mans = [],
    n = 0,
    found = -4;
if instance_exists(obj){
    while ++n <= num && variable_instance_get(man,varname) = value || (instance_is(man,prop) && !instance_is(man,Generator)){
        man.x += 10000
        array_push(mans,man)
        man = instance_nearest(_x,_y,obj)
    }
    if variable_instance_get(man,varname) != value && (!instance_is(man,prop) || instance_is(man,Generator)) found = man
    with mans x-= 10000
}
return found

//zap zap stuff
#define quick_lightning(a)
with instance_create(x,y,Lightning){
  	image_angle = random(360)
  	team = other.team
	creator = other.creator
  	ammo = a
	alarm0 = 1
	visible = 0
  	/*with instance_create(x,y,LightningSpawn){
  	   image_angle = other.image_angle
    }*/
}
//more stuff to get zap zap to work
#define chance(percentage)
return random(100) <= percentage * current_time_scale

//Pest
#define PestBullet_Create(_x,_y)
  with instance_create(_x, _y, CustomProjectile)
    {
      sprite_index = global.sprPestBullet
      direction = other.gunangle + (random_range(4, -4) * other.accuracy);
        speed = 14 + irandom(2);
        damage = 9;
      image_speed = 0.4;
      image_angle = direction;
      typ = 0;

	 on_hit = Bullet_Hit;
	 on_wall = Bullet_Wall;
	 on_draw = Bloom;
	 on_step = PestBullet_Step;
	 on_destroy = PestBullet_Die;
	  team = other.team;
      creator = other;
    }

#define PestBullet_Step
//Bolt Trail
with(instance_create(x, y, BoltTrail)) {
     image_blend = make_color_rgb(0,255,0);
     image_angle = other.direction;
     image_xscale = other.speed;
     image_yscale = 2;
}
//Bubble Trail
    with instance_create(x+random_range(-8,8),y+random_range(-8,8),PlasmaTrail)
{
  sprite_index = global.sprPestBubbleTrail;
  image_angle = random_range(0,360);
}

#define PestBullet_Die

if skill_get(17){
	//sounds if have LB
  sound_play_pitchvol(sndLaserUpg,0.7,1);
  sound_play_pitchvol(sndToxicBoltGas,random_range(0.75,0.85),0.6);
  sound_play_pitchvol(sndOasisExplosionSmall,random_range(0.75,0.85),0.6);
}else{
	//sounds when no LB
  sound_play_pitchvol(sndLaser,0.7,1);
  sound_play_pitchvol(sndToxicBoltGas,random_range(0.75,0.85),0.6);
  sound_play_pitchvol(sndOasisExplosionSmall,random_range(0.75,0.85),0.6);
}
//Plasma Impact
    with instance_create(x,y,PlasmaImpact)
   {sprite_index = global.sprPestPlasmaImpact;};
//Plasma
for (i = 0; i < 360; i += 180)
    with instance_create(x,y,CustomProjectile)
    {
  		sprite_index = global.sprPestPlasma;
  		mask_index = mskPlasma;
      team = other.team;
   		damage = 4;
  		force = 6;
  		image_xscale = 1 + (skill_get(17) * 0.1);
  		image_yscale = image_xscale;
  		image_index = 1;
  		image_speed = 0;
    direction = other.direction + other.i + random_range(-360,360);
      speed = 7;
      typ = 1;
      creator = other;
      image_angle = direction;

      on_hit = PestPlasma_Hit;
      on_wall = plasma_wall;
      on_draw = plasma_draw;
      on_step = PestPlasma_Step;
      on_destroy = PestPlasma_Die;
    }
//Gas
repeat(5){
	with instance_create(x,y,ToxicGas){friction *= 10; growspeed /= 8}
}

//Pest Plasma
#define PestPlasma_Step
  with instance_create(x+random_range(-3,3),y+random_range(-3,3),PlasmaTrail){
  	sprite_index = global.sprPestPlasmaTrail
  }
if image_xscale < 0.5 instance_destroy();

#define PestPlasma_Die
sound_play_pitchvol(sndPlasmaHit,1,1);
    with instance_create(x,y,PlasmaImpact)
   {sprite_index = global.sprPestPlasmaImpact;};
repeat(2){
	with instance_create(x,y,ToxicGas){friction *= 10; growspeed /= 8}
}

#define PestPlasma_Hit
//makes plasma get smaller and slows down as it hits enemies + spawns Gas
projectile_hit(other,damage);
image_xscale -= 0.15;
image_yscale -= 0.15;
x -= lengthdir_x(speed * 1,direction);
y -= lengthdir_y(speed * 1,direction);
repeat(1){
	with instance_create(x,y,ToxicGas){friction *= 10; growspeed /= 8}
}


//Flame
#define FlameBullet_Create(_x,_y)
  with instance_create(_x, _y, CustomProjectile)
    {
      sprite_index = global.sprFlameBullet
      direction = other.gunangle + (random_range(12, -12) * other.accuracy);
        speed = 14 + irandom(2);
        damage = 9;
      image_speed = 0.4;
      image_angle = direction;
      typ = 0;

	 on_hit = Bullet_Hit;
	 on_wall = Bullet_Wall;
	 on_draw = Bloom;
	 on_step = FlameBullet_Step;
	 on_destroy = FlameBullet_Die;
	  team = other.team;
      creator = other;
    }

#define FlameBullet_Step
//Bolt Trail
with(instance_create(x, y, BoltTrail)) {
     image_blend = make_color_rgb(252,56,0);
     image_angle = other.direction;
     image_xscale = other.speed;
     image_yscale = 2;
}
//Trail
    with instance_create(x+random_range(-3,3),y+random_range(-3,3),PlasmaTrail)
{
  sprite_index = global.sprFlamePlasmaTrail;
  image_angle = random_range(0,360);
}


#define FlameBullet_Die

if skill_get(17){
	//sounds if have LB
  sound_play_pitchvol(sndLaserUpg,0.7,1);
  sound_play_pitchvol(sndIncinerator,random_range(0.75,0.85),0.6);
  sound_play_pitchvol(sndOasisExplosionSmall,random_range(0.75,0.85),0.6);
}else{
	//sounds when no LB
  sound_play_pitchvol(sndLaser,0.7,1);
  sound_play_pitchvol(sndIncinerator,random_range(0.75,0.85),0.6);
  sound_play_pitchvol(sndOasisExplosionSmall,random_range(0.75,0.85),0.6);
}
//Plasma Impact
    with instance_create(x,y,PlasmaImpact)
   {sprite_index = global.sprFlamePlasmaImpact;};
//Plasma
for (i = 0; i < 360; i += 180)
    with instance_create(x,y,CustomProjectile)
    {
  		sprite_index = global.sprFlamePlasma;
  		mask_index = mskPlasma;
      team = other.team;
   		damage = 4;
  		force = 6;
  		image_xscale = 1 + (skill_get(17) * 0.1);
  		image_yscale = image_xscale;
  		image_index = 1;
  		image_speed = 0;
    direction = other.direction + other.i + random_range(-360,360);
      speed = 7;
      typ = 1;
      creator = other;
      image_angle = direction;

      on_hit = plasma_hit;
      on_wall = plasma_wall;
      on_draw = plasma_draw;
      on_step = FlamePlasma_Step;
      on_destroy = FlamePlasma_Die;
    }
for (i = 0; i < 360; i += 30) //fire go fwoosh
{
 with instance_create(x,y,Flame)
  {
    team = other.team;
    creator = other.creator;
    direction = other.direction + other.i + random_range(-65,65);
    speed = 3;
  }
}

//Flame Plasma
#define FlamePlasma_Step
  with instance_create(x+random_range(-3,3),y+random_range(-3,3),Flame){
  	  team = other.team;
      creator = other;
}
  with instance_create(x+random_range(-3,3),y+random_range(-3,3),Smoke){
  	image_xscale = 0.4;
  	image_yscale = image_xscale;
  }
if image_xscale < 0.5 instance_destroy();

#define FlamePlasma_Die
sound_play_pitchvol(sndPlasmaHit,1,1);
    with instance_create(x,y,PlasmaImpact)
   {sprite_index = global.sprFlamePlasmaImpact;};

for (i = 0; i < 360; i += 45) //fire go fwoosh
{
 with instance_create(x,y,Flame)
  {
    team = other.team;
    creator = other.creator;
    direction = other.direction + other.i + random_range(-65,65);
    speed = 3;
  }
}




//Psy
#define PsyBullet_Create(_x,_y)
  with instance_create(_x, _y, CustomProjectile)
    {
      sprite_index = global.sprPsyBullet
      direction = other.gunangle + (random_range(9, -9) * other.accuracy);
        speed = 14 + irandom(2);
        damage = 9;
      image_speed = 0.4;
      image_angle = direction;
      typ = 0;
      turnspeed = .3

	 on_hit = Bullet_Hit;
	 on_wall = Bullet_Wall;
	 on_draw = Bloom;
	 on_step = PsyBullet_Step;
	 on_destroy = PsyBullet_Die;
	  team = other.team;
      creator = other;
    }

#define PsyBullet_Step

//scary psy stuff
	var closeboy = instance_nearest_matching_ne(x,y,hitme,"team",team)
	if instance_exists(closeboy) && distance_to_object(closeboy) < 200 && collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0{
		motion_add(point_direction(x,y,closeboy.x,closeboy.y),current_time_scale * (1))
		motion_add(direction,-.03  * (1))
		image_angle = direction
}

//Bolt Trail
with(instance_create(x, y, BoltTrail)) {
     image_blend = make_color_rgb(255,58,215);
     image_angle = other.direction;
     image_xscale = other.speed;
     image_yscale = 2;
}
    with instance_create(x+random_range(-3,3),y+random_range(-3,3),PlasmaTrail)
{
  sprite_index = global.sprPsyPlasmaTrail;
}

#define PsyBullet_Die

if skill_get(17){
	//sounds if have LB
  sound_play_pitchvol(sndLaserUpg,0.7,1);
  sound_play_pitchvol(sndOasisExplosionSmall,random_range(0.75,0.85),0.6);
}else{
	//sounds when no LB
  sound_play_pitchvol(sndLaser,0.7,1);
  sound_play_pitchvol(sndOasisExplosionSmall,random_range(0.75,0.85),0.6);
}
//Plasma Impact
    with instance_create(x,y,PlasmaImpact)
   {sprite_index = global.sprPsyPlasmaImpact;};
//Plasma
for (i = 0; i < 360; i += 180)
    with instance_create(x,y,CustomProjectile)
    {
  		sprite_index = global.sprPsyPlasma;
  		mask_index = mskPlasma;
      team = other.team;
   		damage = 4;
  		force = 6;
  		image_xscale = 1 + (skill_get(17) * 0.1);
  		image_yscale = image_xscale;
  		image_index = 1;
  		image_speed = 0;
    direction = other.direction + other.i + random_range(-360,360);
      speed = 3;
      typ = 1;
      creator = other;
      image_angle = direction;
       turnspeed = .3

      on_hit = plasma_hit;
      on_wall = plasma_wall;
      on_draw = plasma_draw;
      on_step = PsyPlasma_Step;
      on_destroy = PsyPlasma_Die;
    }
for (i = 0; i < 360; i += 30) //fire go fwoosh
{
 with instance_create(x,y,Smoke)
  {
  	image_blend = make_color_rgb(173,20,204);
    team = other.team;
    creator = other.creator;
    direction = other.direction + other.i + random_range(-65,65);
    speed = 2;
  }
}

//Psy Plasma
#define PsyPlasma_Step


	var closeboy = instance_nearest_matching_ne(x,y,hitme,"team",team)
	if instance_exists(closeboy) && distance_to_object(closeboy) < 200 && collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0{
		motion_add(point_direction(x,y,closeboy.x,closeboy.y),current_time_scale * (0.7))
		motion_add(direction,-.15  * (1))
		image_angle = direction
}



  with instance_create(x+random_range(-3,3),y+random_range(-3,3),PlasmaTrail){
  sprite_index = global.sprPsyPlasmaTrail;
}
if image_xscale < 0.5 instance_destroy();

#define PsyPlasma_Die
sound_play_pitchvol(sndPlasmaHit,1,1);
    with instance_create(x,y,PlasmaImpact)
   {sprite_index = global.sprPsyPlasmaImpact;};

for (i = 0; i < 360; i += 45) //fire go fwoosh
{
 with instance_create(x,y,Smoke)
  {
  	image_blend = make_color_rgb(173,20,204);
    direction = other.direction + other.i + random_range(-65,65);
    speed = 2;
  }
}


//Bouncy
#define BouncyBullet_Create(_x,_y)
  with instance_create(_x, _y, CustomProjectile)
    {
      sprite_index = global.sprBouncyBullet
      direction = other.gunangle + (random_range(6, -6) * other.accuracy);
        speed = 14 + irandom(2);
        damage = 9;
      image_speed = 0.4;
      image_angle = direction;
      typ = 0;

	 on_hit = Bullet_Hit;
	 on_wall = Bullet_Wall;
	 on_draw = Bloom;
	 on_step = BouncyBullet_Step;
	 on_destroy = BouncyBullet_Die;
	  team = other.team;
      creator = other;
    }

#define BouncyBullet_Step
//Bolt Trail
with(instance_create(x, y, BoltTrail)) {
     image_blend = make_color_rgb(255,255,0);
     image_angle = other.direction;
     image_xscale = other.speed;
     image_yscale = 2;
}
//Trail
    with instance_create(x+random_range(-3,3),y+random_range(-3,3),PlasmaTrail)
{
  sprite_index = global.sprBouncyPlasmaTrail;
  image_angle = random_range(0,360);
}


#define BouncyBullet_Die

if skill_get(17){
	//sounds if have LB
  sound_play_pitchvol(sndLaserUpg,0.7,1);
  sound_play_pitchvol(sndIncinerator,random_range(0.75,0.85),0.6);
  sound_play_pitchvol(sndOasisExplosionSmall,random_range(0.75,0.85),0.6);
}else{
	//sounds when no LB
  sound_play_pitchvol(sndLaser,0.7,1);
  sound_play_pitchvol(sndIncinerator,random_range(0.75,0.85),0.6);
  sound_play_pitchvol(sndOasisExplosionSmall,random_range(0.75,0.85),0.6);
}
//Plasma Impact
    with instance_create(x,y,PlasmaImpact)
   {sprite_index = global.sprBouncyPlasmaImpact;};
//Plasma
for (i = 0; i < 360; i += 180)
    with instance_create(x,y,CustomProjectile)
    {
  		sprite_index = global.sprBouncyPlasma;
  		mask_index = mskPlasma;
      team = other.team;
   		damage = 4;
  		force = 6;
  		image_xscale = 1 + (skill_get(17) * 0.1);
  		image_yscale = image_xscale;
  		image_index = 1;
  		image_speed = 0;
    direction = other.direction + other.i + random_range(-360,360);
      speed = 7;
      typ = 1;
      creator = other;
      image_angle = direction;

      on_hit = plasma_hit;
      on_wall = BouncyPlasma_Wall;
      on_draw = plasma_draw;
      on_step = BouncyPlasma_Step;
      on_destroy = BouncyPlasma_Die;
    }
for (i = 0; i < 360; i += 90) //boolet
{
 with instance_create(x,y,BouncerBullet)
  {
    team = other.team;
    creator = other.creator;
    direction = other.direction + other.i + random_range(-65,65);
    speed = 6;
  }
}

//Bouncy Plasma
#define BouncyPlasma_Step
//Trail
    with instance_create(x+random_range(-3,3),y+random_range(-3,3),PlasmaTrail)
{
  sprite_index = global.sprBouncyPlasmaTrail;
  image_angle = random_range(0,360);
}

if image_xscale < 0.5 instance_destroy();

#define BouncyPlasma_Die
sound_play_pitchvol(sndPlasmaHit,1,1);
    with instance_create(x,y,PlasmaImpact)
   {sprite_index = global.sprBouncyPlasmaImpact;};

for (i = 0; i < 360; i += 180) //boolet
{
 with instance_create(x,y,BouncerBullet)
  {
    team = other.team;
    creator = other.creator;
    direction = other.direction + other.i + random_range(-65,65);
    speed = 6;
  }
}

#define BouncyPlasma_Wall
//makes the plasma get smaller and bounce off walls


    sound_play_pitchvol(sndBouncerBounce,1,1);
	move_bounce_solid(true);

	image_xscale -= 0.05
	image_yscale = image_xscale;
	if image_xscale <= 0.6{
		instance_destroy();
		exit;
	}



//Lightning
#define LightningBullet_Create(_x,_y)
  with instance_create(_x, _y, CustomProjectile)
    {
      sprite_index = global.sprLightningBullet
      direction = other.gunangle + (random_range(11, -11) * other.accuracy);
        speed = 14 + irandom(2);
        damage = 9;
      image_speed = 0.4;
      image_angle = direction;
      typ = 0;

	 on_hit = Bullet_Hit;
	 on_wall = Bullet_Wall;
	 on_draw = Bloom;
	 on_step = LightningBullet_Step;
	 on_destroy = LightningBullet_Die;
	  team = other.team;
      creator = other;
    }

#define LightningBullet_Step
//Bolt Trail
with(instance_create(x, y, BoltTrail)) {
     image_blend = make_color_rgb(50,214,255);
     image_angle = other.direction;
     image_xscale = other.speed;
     image_yscale = 2;
}
//Trail
    with instance_create(x+random_range(-3,3),y+random_range(-3,3),PlasmaTrail)
{
  sprite_index = global.sprLightningPlasmaTrail;
  image_angle = random_range(0,360);
}

if chance(5){
    quick_lightning(choose(1,2))
}


#define LightningBullet_Die

if skill_get(17){
	//sounds if have LB
  sound_play_pitchvol(sndLightningShotgunUpg,random_range(0.8,0.9),0.6);
  sound_play_pitchvol(sndIncinerator,random_range(0.75,0.85),0.6);
  sound_play_pitchvol(sndOasisExplosionSmall,random_range(0.75,0.85),0.6);
}else{
	//sounds when no LB
  sound_play_pitchvol(sndLightningShotgun,random_range(0.8,0.9),0.6);
  sound_play_pitchvol(sndIncinerator,random_range(0.75,0.85),0.6);
  sound_play_pitchvol(sndOasisExplosionSmall,random_range(0.75,0.85),0.6);
}
//Plasma Impact
    with instance_create(x,y,PlasmaImpact)
   {sprite_index = global.sprLightningPlasmaImpact;};
//Plasma
for (i = 0; i < 360; i += 180)
    with instance_create(x,y,CustomProjectile)
    {
  		sprite_index = global.sprLightningPlasma;
  		mask_index = mskPlasma;
      team = other.team;
   		damage = 4;
  		force = 6;
  		image_xscale = 1 + (skill_get(17) * 0.1);
  		image_yscale = image_xscale;
  		image_index = 1;
  		image_speed = 0;
    direction = other.direction + other.i + random_range(-360,360);
      speed = 7;
      typ = 1;
      creator = other;
      image_angle = direction;

      on_hit = plasma_hit;
      on_wall = plasma_wall;
      on_draw = plasma_draw;
      on_step = LightningPlasma_Step;
      on_destroy = LightningPlasma_Die;
    }

quick_lightning(6)

//Lightning Plasma
#define LightningPlasma_Step
    with instance_create(x+random_range(-3,3),y+random_range(-3,3),PlasmaTrail)
{
  sprite_index = global.sprLightningPlasmaTrail;
}

if chance(10){
    quick_lightning(choose(1,2))
}

if image_xscale < 0.5 instance_destroy();

#define LightningPlasma_Die
sound_play_pitchvol(sndPlasmaHit,1,1);
    with instance_create(x,y,PlasmaImpact)
   {sprite_index = global.sprLightningPlasmaImpact;};

quick_lightning(4)



//Gamma
#define GammaBullet_Create(_x,_y)
  with instance_create(_x, _y, CustomProjectile)
    {
      sprite_index = global.sprGammaBullet
      direction = other.gunangle + (random_range(6, -6) * other.accuracy);
        speed = 14 + irandom(2);
        damage = 9;
      image_speed = 0.4;
      image_angle = direction;
      typ = 0;

	 on_hit = Bullet_Hit;
	 on_wall = Bullet_Wall;
	 on_draw = Bloom;
	 on_step = GammaBullet_Step;
	 on_destroy = GammaBullet_Die;
	  team = other.team;
      creator = other;
    }

#define GammaBullet_Step
//Bolt Trail
with(instance_create(x, y, BoltTrail)) {
     image_blend = make_color_rgb(190,253,8);
     image_angle = other.direction;
     image_xscale = other.speed;
     image_yscale = 2;
}
with instances_matching_ne(projectile, "team", other.team){
	if distance_to_object(other) <= 0{
		instance_destroy()
		with other {
			sleep(4)
		}
	}
}


#define GammaBullet_Die

if skill_get(17){
	//sounds if have LB
  sound_play_pitchvol(sndLaserUpg,0.7,1);
  sound_play_pitchvol(sndOasisExplosionSmall,random_range(0.75,0.85),0.6);
}else{
	//sounds when no LB
  sound_play_pitchvol(sndLaser,0.7,1);
  sound_play_pitchvol(sndOasisExplosionSmall,random_range(0.75,0.85),0.6);
}
//Plasma Impact
    with instance_create(x,y,PlasmaImpact)
   {sprite_index = global.sprGammaPlasmaImpact;};
//Plasma
for (i = 0; i < 360; i += 90)
    with instance_create(x,y,CustomProjectile)
    {
  		sprite_index = global.sprGammaPlasma;
  		mask_index = mskPlasma;
      team = other.team;
   		damage = 2;
  		force = 6;
  		image_xscale = 1 + (skill_get(17) * 0.1);
  		image_yscale = image_xscale;
  		image_index = 1;
  		image_speed = 0;
    direction = other.direction + other.i + random_range(-360,360);
      speed = 7;
      typ = 1;
      creator = other;
      image_angle = direction;

      on_hit = GammaPlasma_Hit;
      on_wall = plasma_wall;
      on_draw = plasma_draw;
      on_step = GammaPlasma_Step;
      on_destroy = GammaPlasma_Die;
    }


//Gamma Plasma
#define GammaPlasma_Step
  with instance_create(x+random_range(-3,3),y+random_range(-3,3),PlasmaTrail){
  	sprite_index = global.sprGammaPlasmaTrail
  }
  with instances_matching_ne(projectile, "team", other.team){
	if distance_to_object(other) <= 0{
		instance_destroy()}}
if image_xscale < 0.5 instance_destroy();

#define GammaPlasma_Die
sound_play_pitchvol(sndPlasmaHit,1,1);
    with instance_create(x,y,PlasmaImpact)
   {sprite_index = global.sprGammaPlasmaImpact;};


#define GammaPlasma_Hit
//makes plasma get smaller and slows down as it hits enemies + spawns Gas
projectile_hit(other,damage);
image_xscale -= 0.15;
image_yscale -= 0.15;
x -= lengthdir_x(speed * 1,direction);
y -= lengthdir_y(speed * 1,direction);


//No Iris affects
//Normal
#define NormalBullet_Create(_x,_y)
  with instance_create(_x, _y, CustomProjectile)
    {
      sprite_index = global.sprNormalBullet
      direction = other.gunangle + (random_range(6, -6) * other.accuracy);
        speed = 14 + irandom(2);
        damage = 9;
      image_speed = 0.4;
      image_angle = direction;
      typ = 0;

	 on_hit = Bullet_Hit;
	 on_wall = Bullet_Wall;
	 on_draw = Bloom;
	 on_step = NormalBullet_Step;
	 on_destroy = NormalBullet_Die;
	  team = other.team;
      creator = other;
    }

#define NormalBullet_Step
//Bolt Trail
with(instance_create(x, y, BoltTrail)) {
     image_blend = make_color_rgb(0,255,0);
     image_angle = other.direction;
     image_xscale = other.speed;
     image_yscale = 2;
}


#define NormalBullet_Die

if skill_get(17){
	//sounds if have LB
  sound_play_pitchvol(sndLaserUpg,0.7,1);
  sound_play_pitchvol(sndOasisExplosionSmall,random_range(0.75,0.85),0.6);
}else{
	//sounds when no LB
  sound_play_pitchvol(sndLaser,0.7,1);
  sound_play_pitchvol(sndOasisExplosionSmall,random_range(0.75,0.85),0.6);
}
//Plasma Impact
    instance_create(x,y,PlasmaImpact)

//Plasma
for (i = 0; i < 360; i += 180)
    with instance_create(x,y,PlasmaBall){
      direction = other.direction + other.i + random_range(-360,360);
      team = other.team;
      creator = other;
      image_angle = direction;
    }


//General Plasma Scripts
#define plasma_hit
//makes plasma get smaller and slows down as it hits enemies
projectile_hit(other,damage);
image_xscale -= 0.15;
image_yscale -= 0.15;
x -= lengthdir_x(speed * 1,direction);
y -= lengthdir_y(speed * 1,direction);

#define plasma_wall
//makes the plasma get smaller and destroy itself on walls
	image_xscale -= 0.05
	image_yscale = image_xscale;
	if image_xscale <= 0.75{
		instance_destroy();
		exit;
	}
#define plasma_draw
//bloom and such
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);



//General Bullet Scripts
#define Bullet_Hit
projectile_hit(other, damage)
instance_destroy();

#define Bullet_Wall
instance_destroy();

#define Bloom
//bloom and such
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.2);
draw_set_blend_mode(bm_normal);

#define init
global.sprLuckyMachinegun = sprite_add_weapon("sprites/sprLuckyMachinegun.png", 3, 1);
global.sprLuckyBullet 	  = sprHeavyBullet

#define weapon_name
return "LUCKY MACHINEGUN";

#define weapon_sprt
return global.sprLuckyMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_gold
return 1;

#define weapon_load
return 3;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
if GameCont.loops >= 1 return 7;
return -1

#define weapon_text
return choose("GET LUCKY","THE RICH GET RICHER");

#define weapon_fire

with instance_create(x,y,Shell){
	motion_add(other.gunangle+other.right*100+random(50)-25,2+random(5))
}
weapon_post(5,-6,6)
sound_play_pitch(sndGoldMachinegun,random_range(0.9,1.1))
sound_play_pitch(sndSnowTankShoot,random_range(1.2,1.3))

with instance_create(x,y,CustomProjectile){
    name = "Lucky Bullet"
    lucky = !irandom(9)
    sprite_index = lucky ? global.sprLuckyBullet : sprBullet1
    mask_index = mskBullet1
    damage = 3
    force = 8
    motion_set(other.gunangle + random_range(-6,6)*other.accuracy, 20)
    projectile_init(other.team,other)
    image_angle = direction
    on_hit = bullet_hit
    on_destroy = bullet_destroy
    on_wall = bullet_wall
    on_draw = bullet_draw
    on_anim = bullet_anim
    if lucky on_step = luck_step
}

#define bullet_anim
image_index = 1
image_speed = 0

#define bullet_draw
draw_self()
draw_set_blend_mode(bm_add)
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale*2,image_yscale*2,image_angle,image_blend,.1)
draw_set_blend_mode(bm_normal)

#define bullet_hit
if lucky{
    with creator{
        sound_play(sndLuckyShotProc)
        with instance_create(x,y,SteroidsTB) sprite_index = sprLuckyShot
        var t = irandom_range(1,5), am = ceil(typ_ammo[t]/2);
        ammo[t] = min(ammo[t] + am, typ_amax[t])
        with instance_create(x,y,PopupText){
            target = other.index
            text = other.ammo[t] == other.typ_amax[t] ? `MAX ${other.typ_name[t]}` : `+${am} ${other.typ_name[t]}`
        }
    }
}
projectile_hit(other,damage,force,direction)
if skill_get(mut_recycle_gland) && random(5) < 2{
    instance_create(x,y,RecycleGland)
    sound_play(sndRecGlandProc)
    with creator{
        ammo[1] = min(ammo[1] + weapon_cost(wep),typ_amax[1])
    }
}
instance_destroy()

#define bullet_destroy
instance_create(x,y,BulletHit)

#define bullet_wall
instance_create(x,y,Dust)
sound_play_hit(sndHitWall,.2)
instance_destroy()

#define luck_step
if random(100) < 50*current_time_scale with instance_create(x,y,CaveSparkle) image_angle = random(360)

/*with instance_create(x,y,Bullet1)
{
	if !irandom(14){lucky = 1;sprite_index = global.sprLuckyBullet}else{lucky = 0}
	team = other.team
	creator = other
	motion_add(other.gunangle + (random_range(-6,6) * other.accuracy),20)
	image_angle = direction
	if fork(){
		while(instance_exists(self)){

			if lucky = 1 {if irandom(1) = 0{with instance_create(x,y,CaveSparkle){image_angle = random(359)}}}
			if place_meeting(x+ hspeed,y+ vspeed,enemy) && instance_exists(creator) && lucky = 1
			{
				with creator
				{
					sound_play(sndLuckyShotProc)
					instance_create(x,y,SteroidsTB)
					var type = choose(1,2,3,4,5)
					ammo[type] += round(typ_ammo[type]/2)
					if ammo[type] > typ_amax[type]
					{
						ammo[type] = typ_amax[type]
					}
					var dir = instance_create(x,y,PopupText)
					dir.mytext = "+"+string(round(typ_ammo[type]/2))+" "+string(typ_name[type])
					dir.target = index
					if ammo[type] = typ_amax[type]
					{
						dir.mytext = "MAX "+string(typ_name[type])
					}
				}
			}
			wait(1)
		}
		exit
	}
}
*/

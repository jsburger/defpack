#define init
global.sprRecordDealer    = sprite_add_weapon("sprites/weapons/sprRecordDealer.png",6,4)
global.sprRecordDealerHUD = sprite_add_weapon("sprites/weapons/sprRecordDealer.png",10,3)
global.sprVinyl           = sprite_add("sprites/projectiles/sprVinyl.png",2,7,7)
global.sprGoldVinyl       = sprite_add("sprites/projectiles/sprGoldVinyl.png",2,7,7)
global.sprStickyVinyl     = sprite_add("sprites/projectiles/sprStickyVinyl.png",2,7,7)
global.sprBouncerVinyl    = sprite_add("sprites/projectiles/sprBouncerVinyl.png",2,7,7)
global.sprMegaVinyl       = sprite_add("sprites/projectiles/sprMegaVinyl.png",2,12,12)
global.sprNTVinyl         = sprite_add("sprites/projectiles/sprNTVinyl.png",2,12,12)
global.sprToxicVinyl      = sprite_add("sprites/projectiles/sprToxicVinyl.png",2,7,7)
global.sprLightningVinyl  = sprite_add("sprites/projectiles/sprLightningVinyl.png",2,7,7)
global.sprFireVinyl       = sprite_add("sprites/projectiles/sprFireVinyl.png",2,7,7)
global.sprSmartVinyl      = sprite_add("sprites/projectiles/sprSmartVinyl.png",2,7,7)
global.sprBloodVinyl      = sprite_add("sprites/projectiles/sprBloodVinyl.png",2,7,7)
global.sprSeekerVinyl     = sprite_add("sprites/projectiles/sprSeekerVinyl.png",2,7,7)
global.sprHyperVinyl      = global.sprBouncerVinyl;
global.sprHyperVinylGlow  = sprite_add("sprites/projectiles/sprHyperVinylGlow.png",2,7,7)

#define weapon_name
return "RECORD DEALER";

#define weapon_type
return 3;

#define weapon_cost
return 2;

#define weapon_area
return 12;

#define weapon_load
return 32;

#define weapon_swap
return sndSwapBow;

#define weapon_auto
return false;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_sprt
return global.sprRecordDealer;

#define weapon_sprt_hud
return global.sprRecordDealerHUD;

#define nts_weapon_examine
return{
    "d": "The various symphonies of neverending pain. ",
}

#define weapon_text
return "WRITE A LOVE SONG";

#define weapon_fire
var _da = ["normal","golden","sticky","bouncer","mega"];
if mod_exists("mod", "Disc Tools"){
    array_push(_da, "toxic");
    array_push(_da, "fire");
    array_push(_da, "lightning");
    array_push(_da, "seeker");
}

var _disc = _da[irandom(array_length_1d(_da) - 1)];
sound_play_slowdown(sndSuperDiscGun, .8)
repeat(4)
{
  sound_play_pitchvol(sndDiscgun, 1.2, .7);
  weapon_post(6, -18, 4)
  var angle = gunangle + random_range(-6,6)*accuracy
  with get_disc(_disc){
      direction = angle
      projectile_init(other.team, other)
      move_contact_solid(other.gunangle, min(sprite_width, 14))
      image_angle = direction
  }
  wait(3)
  if !instance_exists(self) exit
}

#define get_disc(disc)
switch disc{
    case "normal":
        with instance_create(x, y, Disc){
            sprite_index = global.sprVinyl
            hitid = [sprite_index, "VINYL"]
            speed = 5
            return id
        }
    case "golden":
        with instance_create(x, y, Disc){
            sprite_index = global.sprGoldVinyl
            hitid = [sprite_index, "GOLDEN VINYL"]
            speed = 8
            return id
        }
    case "sticky":
        with mod_script_call_nc("mod", "defpack tools", "create_stickydisc", x, y){
            sprite_index = global.sprStickyVinyl
            hitid = [sprite_index, "STICKY VINYL"]
            speed = 4
            orspeed = speed
            return id
        }
    case "bouncer":
        with mod_script_call_self("mod", "defpack tools", "create_bouncerdisc", x, y){
            sprite_index = global.sprBouncerVinyl
            hitid = [sprite_index, "BOUNCER VINYL"]
            speed = 4
            return id
        }
    case "mega":
        with mod_script_call_nc("mod", "defpack tools", "create_megadisc", x, y){
            sprite_index = (irandom(99) == 0) ? global.sprNTVinyl : global.sprMegaVinyl
            hitid[0] = sprite_index
            hitid[1] = sprite_index = global.sprMegaVinyl ? "MEGA VINYL" : "THE NUCLEAR THRONE#SOUNDTRACK"
            speed = 4
            maxspeed = speed
            cansplat = false;
            hitid = [sprite_index, name];
            turn = 0;
            return id
        }
    case "toxic":
        with (mod_script_call("mod", "Disc Tools", "disc_fire", 2, 5, 3)) {
            sprite_index = global.sprToxicVinyl
            hitid = [sprite_index, "TOXIC VINYL"]
            timer = 0
        	if fork()do {
        		if ++timer > 10 && irandom(1) instance_create(x, y, ToxicGas);
        		wait 1;
        	} while (instance_exists(self));
        if !instance_exists(self) exit
        return id
        }
    case "lightning":
        with (mod_script_call("mod", "Disc Tools", "disc_fire", 2, 5, 5)) {
            sprite_index = global.sprLightningVinyl
            hitid = [sprite_index, "LIGHTNING VINYL"]
            var t = 0;
            timer = 0;
            if fork()do {
            	if ++timer >= 10 && (random(4) < 1) with (instance_create(x, y, Lightning)) {
            		image_angle = random(360);
            		team = other.team;
            		hitid = other.hitid;
            		ammo = round(lerp(3, min(3 + t / 5, 7), power(random(1), 2)));
            		alarm0 = 1;
            		visible = false;
            		with (instance_create(x, y, LightningSpawn)) image_angle = other.image_angle;
            	}
            	t += 1;
            	wait 1;
            } while (instance_exists(self));
            if !instance_exists(self) exit
        return id
        }
    case "fire":
        with (mod_script_call("mod", "Disc Tools", "disc_fire", 2, 8, 5)) {
            sprite_index = global.sprFireVinyl
            hitid = [sprite_index, "FLAME VINYL"]
            timer = 0;
            if fork()while (instance_exists(self)) {
            	if ++timer >= 7 with (instance_create(x, y, Flame)) motion_add(random(360), random_range(0.4, 1.1));
            	wait 1;
            }
            if !instance_exists(self) exit
            return id
        }
    case "smart":
        with (mod_script_call("mod", "Disc Tools", "disc_fire", 0, 5, 8)) {
            sprite_index = global.sprSmartVinyl
            hitid = [sprite_index, "SMART VINYL"]
            on_post_hit = script_ref_create_ext("wep", "Smart Disc Gun", "disc_post_hit");
            on_bounce = script_ref_create_ext("wep", "Smart Disc Gun", "disc_bounce");
            guide = noone;
            return id
        }
    case "hyper":
        with (mod_script_call("mod", "Disc Tools", "disc_fire", 2, 14, 7)) {
            sprite_index = global.sprHyperVinyl
            glow_sprite  = global.sprHyperVinylGlow
            hitid = [sprite_index, "HYPER VINYL"]
        	_team = other.team;
        	trail = false;
        	on_move = script_ref_create_ext("wep", "Hyper Disc Gun", "disc_trail_make");
        	on_bounce = script_ref_create_ext("wep", "Hyper Disc Gun", "disc_trail_bounce");
        	on_draw = script_ref_create_ext("wep", "Hyper Disc Gun", "disc_draw");
        	frame = current_frame;
        	image_blend = make_color_hsv(frame * 16 % 256, 240, 255);
        	name = "Hyper Disc";
            return id
        }
    case "seeker":
        with (mod_script_call("mod", "Disc Tools", "disc_fire", 2, 5, 6)) {
            sprite_index = global.sprSeekerVinyl
            hitid = [sprite_index, "SEEKER VINYL"]
        	_team = other.team;
        	if fork()do {
        		var t = instance_nearest(x, y, hitme);
        		if (t && (t.team == _team || instance_is(t, prop) && t.object_index != Generator)) {
        			t = instance_nearest(x, y, enemy);
        			if (t && t.team == _team) t = noone;
        		}
        		if (t) {
        			var tx = t.x, ty = t.y;
        			if (!collision_line(x, y, tx, ty, Wall, 0, 0)) {
        				var dir = point_direction(x, y, tx, ty);
        				motion_add(point_direction(x, y, tx, ty),
        					0.5 + (point_distance(x, y, tx, ty) < 48 + skill_get(21) * 48) * 4);
        			}
        			image_angle = direction;
        		}
        		direction += random(4) - 2;
        		speed = 4 + random(4);
        		wait 1;
        	} while (instance_exists(self));
            if !instance_exists(self) exit
             return id
        }
}

#define sound_play_slowdown(_snd,_vol)
with instance_create(x,y,CustomObject){
  with instances_matching(CustomObject, "name", "record dealer sound"){
    instance_delete(self);
  }
  name = "record dealer sound";
  pitch = 1.7
  decel = random_range(.06,.08)
  p = random_range(.8,1.2)
  lifetime = pitch/decel + 1
  vol = _vol
  snd = _snd
  on_step = sound_step
  persistent = 1
}

#define sound_step
if frac(current_frame) < current_time_scale{
    pitch -= decel
    sound_play_pitchvol(snd, pitch*p, vol)
    lifetime -= 1
    if lifetime <= 0 instance_destroy()
}

#define init
global.sprRockletChest     = sprite_add_weapon("../sprites/chests/sprRockletChest.png", 8, 7);
global.sprRockletChestOpen = sprite_add("../sprites/chests/sprRockletChestOpen.png", 1, 8, 7);

global.sprVectorChest     = sprite_add_weapon("../sprites/chests/sprVectorChest.png", 9, 7);
global.sprVectorChestOpen = sprite_add("../sprites/chests/sprVectorChestOpen.png", 1, 9, 7);

global.sprZenithChest     = sprite_add_weapon("../sprites/chests/sprZenithChest.png", 8, 7);
global.sprZenithChestOpen = sprite_add("../sprites/chests/sprZenithChestOpen.png", 1, 8, 7);

global.sprQuartzChest     = sprite_add_weapon("../sprites/chests/sprQuartzChest.png", 8, 7);
global.sprQuartzChestOpen = sprite_add("../sprites/chests/sprQuartzChestOpen.png", 1, 8, 7);

global.sprRegalChest     = sprite_add_weapon("../sprites/chests/sprRegalChest.png", 8, 7);
global.sprRegalChestOpen = sprite_add("../sprites/chests/sprRegalChestOpen.png", 1, 8, 7);

global.sprUltraChest     = sprite_add_weapon("../sprites/chests/sprUltraChest.png", 8, 7);
global.sprUltraChestOpen = sprite_add("../sprites/chests/sprUltraChestOpen.png", 1, 8, 7);

global.sprToxicChest     = sprite_add_weapon("../sprites/chests/sprToxicChest.png", 8, 6);
global.sprToxicChestOpen = sprite_add("../sprites/chests/sprToxicChestOpen.png", 1, 8, 6);

global.sprComboChest     = sprite_add_weapon("../sprites/chests/sprComboChest.png", 8, 7);
global.sprComboChestOpen = sprite_add("../sprites/chests/sprComboChestOpen.png", 1, 8, 7);

global.sprSmartChest     = sprite_add_weapon("../sprites/chests/sprSmartChest.png", 8, 7);
global.sprSmartChestOpen = sprite_add("../sprites/chests/sprSmartChestOpen.png", 1, 8, 7);

global.sprFlameChest     = sprite_add_weapon("../sprites/chests/sprFlameChest.png", 8, 7);
global.sprFlameChestOpen = sprite_add("../sprites/chests/sprFlameChestOpen.png", 1, 8, 7);

global.sprBloodChest     = sprite_add_weapon("../sprites/chests/sprBloodChest.png", 8, 7);
global.sprBloodChestOpen = sprite_add("../sprites/chests/sprBloodChestOpen.png", 1, 8, 7);

global.sprHyperChest     = sprite_add_weapon("../sprites/chests/sprHyperChest.png", 8, 7);
global.sprHyperChestOpen = sprite_add("../sprites/chests/sprHyperChestOpen.png", 1, 8, 7);

global.sprAutoChest     = sprite_add_weapon("../sprites/chests/sprAutoChest.png", 8, 7);
global.sprAutoChestOpen = sprite_add("../sprites/chests/sprAutoChestOpen.png", 1, 8, 7);

global.sprToolChest     = sprite_add_weapon("../sprites/chests/sprToolChest.png", 10, 7);
global.sprToolChestOpen = sprite_add("../sprites/chests/sprToolChestOpen.png", 1, 10, 7);

global.sprAoEChest     = sprite_add_weapon("../sprites/chests/sprAoEChest.png", 9, 7);
global.sprAoEChestOpen = sprite_add("../sprites/chests/sprAoEChestOpen.png", 1, 9, 7);

global.sprMeleeChest     = sprite_add_weapon("../sprites/chests/sprWepMutChestMelee.png"    , 11, 8);
global.sprBulletChest    = sprite_add_weapon("../sprites/chests/sprWepMutChestBullet.png"   , 11, 8);
global.sprShellChest     = sprite_add_weapon("../sprites/chests/sprWepMutChestShell.png"    , 11, 8);
global.sprBoltChest      = sprite_add_weapon("../sprites/chests/sprWepMutChestBolt.png"     , 11, 8);
global.sprEnergyChest    = sprite_add_weapon("../sprites/chests/sprWepMutChestEnergy.png"   , 11, 8);
global.sprExplosiveChest = sprite_add_weapon("../sprites/chests/sprWepMutChestExplosive.png", 11, 8);
global.sprMeleeChestOpen     = sprite_add("../sprites/chests/sprWepMutChestOpen.png", 1, 11, 8);
global.sprBulletChestOpen    = global.sprMeleeChestOpen;
global.sprShellChestOpen     = global.sprMeleeChestOpen;
global.sprBoltChestOpen      = global.sprMeleeChestOpen;
global.sprExplosiveChestOpen = global.sprMeleeChestOpen;
global.sprEnergyChestOpen    = global.sprMeleeChestOpen;

global.chests = ds_map_create()
chest_add("Ultra",   14, [wep_ultra_shovel,wep_ultra_shotgun,wep_ultra_laser_pistol,wep_ultra_revolver,wep_ultra_crossbow,wep_ultra_grenade_launcher,"ultra spam gun","ultra hand","defender","ultra gunhammer"])
chest_add("AoE",     6,  ["buster","blaster","puncher"])
chest_add("Rocklet", 9,  ["rocklet pistol","rocklet rifle","rocklet cannon","super rocklet cannon","rocklet minigun"])
chest_add("Toxic",   3,  ["toxicthrower","cobra","toxic carronader",wep_toxic_bow,"heavy toxic crossbow",wep_toxic_launcher,"toxic cannon"])
chest_add("Tool",    3,  [wep_wrench,wep_screwdriver,wep_jackhammer,"chainsaw","nail gun","rivet gun"])
chest_add("Combo",   6,  ["rapier","rebounce axe","mega hammer"])
chest_add("Vector",  6,  ["vector shotgun","vector rifle","vector cannon"])
chest_add("Regal",   5,  ["chris knife","apergig tanat","kemosabe"])
chest_add("Smart",   7,  [wep_smart_gun,"heavy smart gun", "smarter gun", "smart nuke launcher"])
chest_add("Auto",    6,  [wep_auto_shotgun,wep_auto_crossbow,wep_auto_grenade_shotgun,wep_heavy_auto_crossbow,"auto abris launcher","auto screwdriver","auto grenade launcher","auto knife thrower"])
chest_add("Quartz",  10, ["quartz machinegun","quartz shotgun","quartz crossbow","quartz laser","quartz launcher"])
chest_add("Flame",   8,  [wep_flare_gun,wep_dragon,wep_flamethrower,wep_flame_cannon,"firestorm"])
chest_add("Blood",   9,  [wep_blood_hammer,"bone","big bone",wep_blood_launcher,wep_blood_cannon,"blood abris launcher","blood crossbow"])
chest_add("Hyper",   9,  [wep_hyper_rifle,wep_hyper_slugger,wep_hyper_launcher,"hyper crossbow"])
chest_add("Zenith",  13, ["herald","andromeda launcher","stopwatch","sak",/*"antiprism",*/"defender","flex","punisher","rapier"])
var _l = ds_list_create();
weapon_get_list(_l, clamp(GameCont.hard, 0, 6), GameCont.hard + 2 * array_length(instances_matching(Player,"race","robot")) + 3);
var _a = ds_list_to_array(_l),
   _c0 = [],
   _c1 = [],
   _c2 = [],
   _c3 = [],
   _c4 = [],
   _c5 = [];
for (var _i = 0; _i < array_length(_a) - 1; _i++){
  switch weapon_get_type(_a[_i]){
    case 0: array_push(_c0, _a[_i]); break;
    case 1: array_push(_c1, _a[_i]); break;
    case 2: array_push(_c2, _a[_i]); break;
    case 3: array_push(_c3, _a[_i]); break;
    case 4: array_push(_c4, _a[_i]); break;
    case 5: array_push(_c5, _a[_i]); break;
  }
}
chest_add("Melee",     -1, 0)
chest_add("Bullet",    -1, 1)
chest_add("Shell",     -1, 2)
chest_add("Bolt",      -1, 3)
chest_add("Explosive", -1, 4)
chest_add("Energy",    -1, 5)

#define step
     // replacing chests
    if !instance_exists(GenCont){
        with instances_matching(instances_matching(WeaponChest, "object_index", 458), "defcustomchestcheck", null){
            defcustomchestcheck = 1
            var _chance = min(GameCont.wepmuts * 12, 45);
            if skill_get(mut_heavy_heart) > 0 _chance = 100 * skill_get(mut_heavy_heart)
            var _mwr = (irandom(99) + 1) <= (_chance)
            if _mwr = true{
              var _a = [];
                  if skill_get(mut_long_arms)         > 0 array_push(_a, 2);
                  if skill_get("longarmsx10")         > 0 array_push(_a, 2);
                  if skill_get("dividedelbows")       > 0 array_push(_a, 2);
                  if skill_get("vote1")               > 0 array_push(_a, 2);
                  if skill_get("srewdriver mastery")  > 0 array_push(_a, 2);
                  if skill_get(mut_recycle_gland)     > 0 array_push(_a, 3);
                  if skill_get("recycleglandx10")     > 0 array_push(_a, 3);
                  if skill_get("prismatic iris")      > 0 array_push(_a, 3);
                  if skill_get("excitedneurons")      > 0 array_push(_a, 3);
                  if skill_get("vote2")               > 0 array_push(_a, 2);
                  if skill_get("Rocket Casings")      > 0 array_push(_a, 2);
                  if skill_get(mut_shotgun_shoulders) > 0 array_push(_a, 0);
                  if skill_get("shotgunshouldersx10") > 0 array_push(_a, 0);
                  if skill_get("powderedgums")        > 0 array_push(_a, 0);
                  if skill_get("vote3")               > 0 array_push(_a, 0);
                  if skill_get("Shattered Skull")     > 0 array_push(_a, 0);
                  if skill_get("shells to shots")     > 0 array_push(_a, 0);
                  if skill_get(mut_bolt_marrow)       > 0 array_push(_a, 4);
                  if skill_get("boltmarrowx10")       > 0 array_push(_a, 4);
                  if skill_get("compoundelbow")       > 0 array_push(_a, 4);
                  if skill_get("vote4")               > 0 array_push(_a, 4);
                  if skill_get("Staked Chest")        > 0 array_push(_a, 4);
                  if skill_get("Energized Intestines")> 0 array_push(_a, 4);
                  if skill_get(mut_boiling_veins)     > 0 array_push(_a, 5);
                  if skill_get("boilingveinsx10")     > 0 array_push(_a, 5);
                  if skill_get("pyromania")           > 0 array_push(_a, 5);
                  if skill_get("vote5")               > 0 array_push(_a, 5);
                  if skill_get("Waste Gland")         > 0 array_push(_a, 5);
                  if skill_get("Toxic Thoughts")      > 0 array_push(_a, 5);
                  if skill_get("Fractured Fingers")   > 0 array_push(_a, 5);
                  if skill_get("Pressurized Lungs")   > 0 array_push(_a, 5);
                  // why does this break if skill_get("flamingplams")        > 0 array_push(_a, 5);
                  if skill_get(mut_laser_brain)       > 0 array_push(_a, 1);
                  if skill_get("laserbrainx10")       > 0 array_push(_a, 1);
                  if skill_get("concentration")       > 0 array_push(_a, 1);
                  if skill_get("vote6")               > 0 array_push(_a, 1);
                  if skill_get("Shocked Skin")        > 0 array_push(_a, 1);
                  if skill_get("Saline Breath")       > 0 array_push(_a, 1);
                  if skill_get("Burning Eyes")        > 0 array_push(_a, 1);
                  if skill_get("conductivity")        > 0 array_push(_a, 1);
              var q = get_chests(-1, -1)
              if array_length(q){
                  with customchest_create(x, y, q[_a[irandom(array_length(_a) - 1)]]) {
                    var _l = ds_list_create();
                    weapon_get_list(_l, clamp(GameCont.hard, 0, 6), GameCont.hard + 2 * array_length(instances_matching(Player,"race","robot")) + 3);
                    var _weparray = ds_list_to_array(_l),
                        _weapons  = [];
                    with _weparray {
                      if weapon_get_type(self) = other.weps {
                        array_push(_weapons, self);
                      }
                    }
                    weps = _weapons;
                  }
                  instance_delete(self)
              }
            }else if random(100) <= 8 and !instance_is(self, BigWeaponChest) and !instance_is(self, BigCursedChest) and !instance_is(self, GiantWeaponChest) && skill_get(mut_open_mind) > 0{
                var q = get_chests(0, GameCont.hard)
                if array_length(q){
                    customchest_create(x, y, q[irandom(array_length(q) - 7)])
                    instance_delete(self)
                }
            }
        }
    }

     // chest step
    with instances_matching(chestprop, "name", "DefCustomChest"){
        if place_meeting(x, y, Player) sound_play(instance_nearest(x, y, Player).snd_chst)
        if place_meeting(x, y, Player) || place_meeting(x, y, PortalShock) || instance_exists(BigPortal){
             // run open code
            script_execute(on_open)

            for(var _i = 0; _i < 4; _i++){
              with Wall{
                if distance_to_object(other) <= 16{
                  instance_create(x, y, FloorExplo);
                  instance_destroy()
                }
              }
            }

             // fx
            instance_create(x, y, FXChestOpen);
            with instance_create(x, y, ChestOpen)
                sprite_index = other.spr_open;

            instance_delete(id);
        }
    }
  if button_pressed(0, "horn") == true and string_lower(player_get_alias(0)) == "karmelyth"{
      with ds_map_keys(global.chests){
          customchest_create(mouse_x[0], mouse_y[0], self)
      }
  }

#define chest_add(Name, Hard, Weapons)
  global.chests[? Name] = {
      name : Name,
      spr_idle : mod_variable_get("mod", mod_current, "spr"+Name+"Chest"),
      spr_open : mod_variable_get("mod", mod_current, "spr"+Name+"ChestOpen"),
      weps : Weapons,
      difficulty : Hard
  }

#define get_chests(areamin, areamax)
  var q = ds_map_values(global.chests), a = [];
  with q{
      if difficulty >= areamin and difficulty <= areamax array_push(a, name)
  }
  return a

  #define customchest_create(xx, yy, Type)
      var o = instance_create(xx, yy, chestprop);
      with(o){
          name = "DefCustomChest";
          type = Type// specifc chest type
          var q = global.chests[? Type]
          spr_open = q.spr_open
          sprite_index = q.spr_idle
          weps = q.weps
          on_open = customchest_open;
      }
      return o;

  #define customchest_open
  repeat(2){
    var _w = wep_screwdriver
    sound_play(sndAmmoChest);
    var _i = 0;
    do{
        _w = weps[irandom(array_length(weps)-1)]
        if weapon_get_area(_w) <= max(0, GameCont.hard + 3){
          with instance_create(x,y,WepPickup){
            wep = _w
            if weapon_get_type(wep) != 0 ammo = 1
            _i = 100;
          }
        }
        _i++;
      } while _i < 100
    }

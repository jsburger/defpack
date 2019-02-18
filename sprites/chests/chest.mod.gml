#define init
global.sprRockletChest     = sprite_add_weapon("sprRockletChest.png", 8, 7);
global.sprRockletChestOpen = sprite_add("sprRockletChestOpen.png", 1, 8, 7);

global.sprVectorChest     = sprite_add_weapon("sprVectorChest.png", 8, 7);
global.sprVectorChestOpen = sprite_add("sprVectorChestOpen.png", 1, 8, 7);

global.sprQuartzChest     = sprite_add_weapon("sprQuartzChest.png", 8, 7);
global.sprQuartzChestOpen = sprite_add("sprQuartzChestOpen.png", 1, 8, 7);

global.sprRegalChest     = sprite_add_weapon("sprRegalChest.png", 8, 7);
global.sprRegalChestOpen = sprite_add("sprRegalChestOpen.png", 1, 8, 7);

global.sprUltraChest     = sprite_add_weapon("sprUltraChest.png", 8, 7);
global.sprUltraChestOpen = sprite_add("sprUltraChestOpen.png", 1, 8, 7);

global.sprToxicChest     = sprite_add_weapon("sprToxicChest.png", 8, 7);
global.sprToxicChestOpen = sprite_add("sprToxicChestOpen.png", 1, 8, 7);

global.sprComboChest     = sprite_add_weapon("sprComboChest.png", 8, 7);
global.sprComboChestOpen = sprite_add("sprComboChestOpen.png", 1, 8, 7);

global.sprFlameChest     = sprite_add_weapon("sprFlameChest.png", 8, 7);
global.sprFlameChestOpen = sprite_add("sprFlameChestOpen.png", 1, 8, 7);

global.sprBloodChest     = sprite_add_weapon("sprBloodChest.png", 8, 7);
global.sprBloodChestOpen = sprite_add("sprBloodChestOpen.png", 1, 8, 7);

global.sprHyperChest     = sprite_add_weapon("sprHyperChest.png", 8, 7);
global.sprHyperChestOpen = sprite_add("sprHyperChestOpen.png", 1, 8, 7);

global.sprAutoChest     = sprite_add_weapon("sprAutoChest.png", 8, 7);
global.sprAutoChestOpen = sprite_add("sprAutoChestOpen.png", 1, 8, 7);

global.sprToolChest     = sprite_add_weapon("sprToolChest.png", 8, 7);
global.sprToolChestOpen = sprite_add("sprToolChestOpen.png", 1, 8, 7);

global.sprAoEChest     = sprite_add_weapon("sprAoEChest.png", 8, 7);
global.sprAoEChestOpen = sprite_add("sprAoEChestOpen.png", 1, 8, 7);

#define step
/*
     // replace wep chests
    if !instance_exists(GenCont)
        with(WeaponChest){
            customchest_create(x, y,choose("vector","ultra","aoe","rocklet","toxic","tool","combo","regal","quartz","flame","blood","hyper"));
            instance_delete(id);
        }
*/
     // debug
    with(Player) if button_pressed(index, "horn")
        customchest_create(mouse_x, mouse_y,choose("vector","ultra","aoe","rocklet","toxic","tool","combo","regal","quartz","flame","blood","hyper"));

     // chest step
    with instances_matching(chestprop, "name", "CustomChest"){
        if place_meeting(x, y, Player) || place_meeting(x, y, PortalShock){
             // run open code
            script_execute(on_open)

             // fx
            instance_create(x, y, FXChestOpen);
            with instance_create(x, y, ChestOpen)
                sprite_index = other.spr_open;

            instance_delete(id);
        }
    }

#define customchest_create(xx, yy, Type)
     // use chest
    var o = instance_create(xx, yy, chestprop);
    with(o){
        name = "CustomChest";
        t = Type// specifc chest type

        switch t
        {
          case "ultra":
          {
            sprite_index = global.sprUltraChest;
            spr_open = global.sprUltraChestOpen;
            break
          }
          case "aoe":
          {
            sprite_index = global.sprAoEChest;
            spr_open = global.sprAoEChestOpen;
            break
          }
          case "rocklet":
          {
            sprite_index = global.sprRockletChest;
            spr_open = global.sprRockletChestOpen;
            break
          }
          case "toxic":
          {
            sprite_index = global.sprToxicChest;
            spr_open = global.sprToxicChestOpen;
            break
          }
          case "tool":
          {
            sprite_index = global.sprToolChest;
            spr_open = global.sprToolChestOpen;
            break
          }
          case "combo":
          {
            sprite_index = global.sprComboChest;
            spr_open = global.sprComboChestOpen;
            break
          }
          case "vector":
          {
            sprite_index = global.sprVectorChest;
            spr_open = global.sprVectorChestOpen;
            break
          }
          case "regal":
          {
            sprite_index = global.sprRegalChest;
            spr_open = global.sprRegalChestOpen;
            break
          }
          case "auto":
          {
            sprite_index = global.sprAutoChest;
            spr_open = global.sprAutoChestOpen;
            break
          }
          case "quartz":
          {
            sprite_index = global.sprQuartzChest;
            spr_open = global.sprQuartzChestOpen;
            break
          }
          case "flame":
          {
            sprite_index = global.sprFlameChest;
            spr_open = global.sprFlameChestOpen;
            break
          }
          case "blood":
          {
            sprite_index = global.sprBloodChest;
            spr_open = global.sprBloodChestOpen;
            break
          }
          case "hyper":
          {
            sprite_index = global.sprHyperChest;
            spr_open = global.sprHyperChestOpen;
            break
          }
        }
        on_open = customchest_open;
    }
    return o;

#define customchest_open
var _w = 1
sound_play(sndAmmoChest);
switch t
{
  case "ultra":
  {
    _w = choose(wep_ultra_shovel,wep_ultra_shotgun,wep_ultra_laser_pistol,wep_ultra_revolver,wep_ultra_crossbow,wep_ultra_grenade_launcher,"ultra spam gun","ultra hand","defender","ultra gunhammer")
    break
  }
  case "aoe":
  {
    _w = choose("buster","blaster","puncher")
    break
  }
  case "rocklet":
  {
    _w = choose("rocklet pistol","rocklet rifle","rocklet cannon","super rocklet cannon","rocklet minigun")
    break
  }
  case "toxic":
  {
    _w = choose("toxicthrower","cobra","toxic carronader",wep_toxic_bow,"heavy toxic crossbow",wep_toxic_launcher,"toxic cannon")
    break
  }
  case "tool":
  {
    _w = choose(wep_wrench,wep_screwdriver,"chainsaw","nail gun")
    break
  }
  case "combo":
  {
    _w = choose("rapier","other axe","bigsword")
    break
  }
  case "vector":
  {
    _w = choose("vector shotgun","vector rifle","vector cannon")
    break
  }
  case "regal":
  {
    _w = choose("chris knife","apergig tanat","kemosabe")
    break
  }
  case "auto":
  {
    _w = choose(wep_auto_shotgun,wep_auto_crossbow,wep_auto_grenade_shotgun,wep_heavy_auto_crossbow,"auto abris launcher","auto screwdriver","auto grenade launcher")
    break
  }
  case "quartz":
  {
    _w = choose("quartz machinegun","quartz shotgun","quartz crossbow","quartz laser","quartz launcher")
    break
  }
  case "flame":
  {
    _w = choose(wep_flare_gun,wep_dragon,wep_flamethrower,wep_flame_cannon,"firestorm")
    break
  }
  case "blood":
  {
    _w = choose(wep_blood_hammer,"bone","big bone",wep_blood_launcher,wep_blood_cannon,"blood abris launcher","blood crossbow")
    break
  }
  case "hyper":
  {
    _w = choose(wep_hyper_rifle,wep_hyper_slugger,wep_hyper_launcher,"hyper crossbow")
    break
  }
}
with instance_create(x,y,WepPickup){wep = _w}

#define init
global.sprIDPDWeaponChest = sprite_add("IDPD Weapon Chest.png",7,8,8)
global.sprIDPDWeaponChestOpen = sprite_add("IDPD Weapon Chest Open.png",1,8,8)
global.PopoChestSpawn = 0
#define step
if instance_exists(Player)
{
  if(instance_exists(GenCont)) && is_string(GameCont.area)
    {
      if (GameCont.area > 3 && GameCont.area != 7) || GameCont.area = 106{
          if global.PopoChestSpawn = 0{
            global.PopoChestSpawn = 1
          with instance_create(0,0,CustomObject){
          sprite_index = global.sprIDPDWeaponChest
          spr_shadow = shd24
          opened = 0
          gol = 0
          image_speed = 0
          on_step = idpdwepchest_step
          prestep = 0
          name = "IDPDWC"
          if place_meeting(x,y,Wall){with other{instance_destroy()}}
          if irandom(14) != 0{instance_destroy()}
        }
      }
    }
  }
}
if!(instance_exists(GenCont))
{
  global.PopoChestSpawn = 0
}

#define idpdwepchest_step
if prestep = 0
{
  if instance_exists(Wall)
  {
  prestep = 1
  spawnfloor = instance_furthest(Wall.x,Wall.y,Floor)
  x = spawnfloor.x+16
  y = spawnfloor.y+16
  }
}
if image_index < 1
image_index += random(0.04)
else
image_index += 0.4
if GameCont.area = 106
{
  if instance_exists(WeaponChest)
  {
    with instance_nearest(x,y,WeaponChest)
    {
      instance_destroy()
    }
  }
}
if speed > 0{speed = 0}
if instance_exists(Player)
{
  with Player
  {
    if race = "eyes"
    {
      if button_check(index,"spec")
      {
        with other
        {
          if point_seen(x,y,other.index)
          {
            if sprite_index != global.sprIDPDWeaponChestOpen
            {
              motion_set(point_direction(x,y,other.x,other.y),1+skill_get(5))//we gon build a pyramid
            }
          }
        }
      }
    }
  }
}
if opened = 0
{
  if place_meeting(x,y,Player) || place_meeting(x,y,PortalShock)
  {
    repeat(3)
    {
      instance_create(x,y,IDPDSpawn)
    }
    sound_play(sndWeaponChest)
    instance_create(x,y,FXChestOpen)
    sprite_index = global.sprIDPDWeaponChestOpen
    with instance_create(x,y,WepPickup)
    {
      ammo = 50
      wep = choose("idpd slugger","idpd minigun","idpd energy sword","idpd grenade launcher","idpd bazooka","idpd plasma minigun","idpd shotgun")
    }
  opened = 1
  }
}
if place_meeting(x,y,chestprop){motion_add(point_direction(other.x,other.y,x,y),1)}
if place_meeting(x+hspeed,y,Wall){hspeed = 0}
if place_meeting(x,y+vspeed,Wall){vspeed = 0}

#define draw_shadows
with(CustomObject)
{
	if("name" in self && name = "IDPDWC")
	{
    if sprite_index = global.sprIDPDWeaponChest
		draw_sprite(shd24, 0, x, y-1);
	}
}

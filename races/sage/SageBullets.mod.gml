#define init
  _init();
  bullets_setup();

#define _init()
  global.BulletDirectory = ds_map_create();
  global.defaultitem = {
      name        : "NO BULLET",
      description : "THIS SHOULDNT APPEAR",
  }

#macro bullet global.BulletDirectory;

#define bullets_setup()
  bullet[? "none"] = {
      name        : "NO BULLET",
    	description : "@s-",
      ttip        : "NO LOADING SCREEN TIP",
      spr_index   : 0,
    	key         : "none",
      area        : true
    };

  while(!mod_sideload()){wait(0)}
  var arr = [];
  wait file_find_all("bullets", arr);
  with(arr){

    mod_load(self.path);

    wait(0);
    var _i = string_replace(self.name, ".mod.gml", "");
    bullet[? _i] = {
      name:        mod_script_call("mod", _i, "bullet_name"),
      description: mod_script_call("mod", _i, "bullet_description", 0),
      ttip:        mod_script_call("mod", _i, "bullet_ttip"),
      spr_index:   mod_script_call("mod", _i, "bullet_sprite"),
      area:        mod_script_call("mod", _i, "bullet_area")
    }
  }

  bullets_finalize();


#define bullets_finalize()
  var keys = ds_map_keys(global.BulletDirectory),
      len  = array_length(keys),
      _item,
      _defkeys = [],
      _defvalues = [],
      _defn = 0;
  for var o = 0; o < lq_size(global.defaultitem); o++{
      array_push(_defkeys, lq_get_key(global.defaultitem, o))
      array_push(_defvalues, lq_get_value(global.defaultitem, o))
  }
  for var i = 0; i < len; i++ {
      _item = global.BulletDirectory[? keys[i]];
      _item.key = keys[i]
      _defn = 0
      with _defkeys {
          lq_set(_item, self, lq_defget(_item, self, _defvalues[_defn++]))
      }
  }

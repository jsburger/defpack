#define init
  _init();
  bullets_setup();

#define _init()
  global.BulletDirectory = ds_map_create();
  global.defaultitem = {
      name        : "THIS BULLET IS MISSING A NAME",
      description : "THIS BULLET IS MISSING ITS DESCRIPTION",
      ttip        : "THIS BULLET IS MISSING A TIP",
      spr_index   : mskNone,
      area        : 1
  }

#macro bullet global.BulletDirectory;

#define bullets_setup()
  while(!mod_sideload()){wait(0)}
  var arr = [];
  wait file_find_all("bullets", arr);
  with(arr){
    
    //TEMPORARY DEBUG CODE
    var allowed = ["Default", "Melee", "Gold", "Prec", "Infammo", "Turret", "Gadget", "Ultra", "Reflect", "Warp", "Split", "Burst", "Echo", "Cursed"], passed = false;
    with (allowed) {
        if string_count(self, other.path) {
            passed = true
            break
        }
    }
    if !passed continue

    wait(mod_load(self.path));

    //wait(0);
    var _i = string_replace(self.name, ".mod.gml", "");
    bullet[? _i] = {
      name:        mod_script_call_nc("mod", _i, "bullet_name", undefined, undefined),
      description: mod_script_call_nc("mod", _i, "bullet_description", 0, undefined),
      ttip:        mod_script_call_nc("mod", _i, "bullet_ttip"),
      area:        mod_script_call_nc("mod", _i, "bullet_area")
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
  for (var o = 0; o < lq_size(global.defaultitem); o++) {
      array_push(_defkeys, lq_get_key(global.defaultitem, o))
      array_push(_defvalues, lq_get_value(global.defaultitem, o))
  }
  for (var i = 0; i < len; i++) {
      _item = global.BulletDirectory[? keys[i]];
      _item.key = keys[i]
      _defn = 0
      with _defkeys {
          lq_set(_item, self, lq_defget(_item, self, _defvalues[_defn++]))
      }
  }

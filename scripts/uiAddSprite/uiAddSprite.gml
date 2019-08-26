/// @arg spr
/// @arg index
/// @arg [flags]
/// @arg [ext0]
ds_list_add(uiCreationTrace, [uiType.SPRITE, argument[0], argument[1], 
                              (argument_count > 2) ? argument[2] : uiFlags.Null, 
                              (argument_count > 3) ? argument[3] : noone]);
return [uiCreationTrace, ds_list_size(uiCreationTrace) - 1];

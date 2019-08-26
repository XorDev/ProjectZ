/// @arg title
/// @arg [flags]
ds_list_add(uiCreationTrace, [uiType.COLORSELECTOR, argument[0], 
                              (argument_count > 1) ? argument[1] : uiFlags.Null, 
                              noone]);
return [uiCreationTrace, ds_list_size(uiCreationTrace) - 1];

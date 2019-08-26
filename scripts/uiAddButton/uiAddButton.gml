/// @arg title
/// @arg [func]
/// @arg [flags]
ds_list_add(uiCreationTrace, [uiType.BUTTON, argument[0], 
                              (argument_count > 1) ? argument[1] : noone, 
                              (argument_count > 2) ? argument[2] : uiFlags.Null]);
return [uiCreationTrace, ds_list_size(uiCreationTrace) - 1];

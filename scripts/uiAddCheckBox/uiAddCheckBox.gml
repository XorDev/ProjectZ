/// @arg title
/// @arg [checked]
/// @arg [flags]
/// @arg [callback]
ds_list_add(uiCreationTrace, [uiType.CHECKBOX, argument[0], 
                              (argument_count > 1) ? argument[1] : false, 
                              (argument_count > 2) ? argument[2] : uiFlags.Null, 
                              (argument_count > 3) ? argument[3] : noone]);
return [uiCreationTrace, ds_list_size(uiCreationTrace) - 1];

/// @arg text
/// @arg value
/// @arg min
/// @arg max
/// @arg [flags]
/// @arg [callback]
ds_list_add(uiCreationTrace, [uiType.FLOAT, argument[0], argument[1], argument[2], argument[3], 
                              (argument_count > 4) ? argument[4] : uiFlags.Null, 
                              (argument_count > 5) ? argument[5] : noone]);
return [uiCreationTrace, ds_list_size(uiCreationTrace) - 1];

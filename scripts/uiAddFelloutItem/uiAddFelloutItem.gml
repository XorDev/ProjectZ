/// @arg title
/// @arg [ext0]
ds_list_add(uiCreationTrace, [uiType.FITEM, argument[0], 
                              (argument_count > 1) ? argument[1] : noone, ]);
return [uiCreationTrace, ds_list_size(uiCreationTrace) - 1];

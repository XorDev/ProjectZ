/// @arg name
/// @arg width
/// @arg height
/// @arg x
/// @arg y
/// @arg [flags]
var list = ds_list_create();
var t = uiCreationTrace;
ds_stack_push(uiCreationStack, uiCreationTrace);
ds_list_add(uiCreationTrace, [uiType.PANEL, argument[0], argument[1], argument[2], 
                              argument[3], argument[4], 
                              (argument_count > 5) ? argument[5] : (uiFlags.Fixed | uiFlags.Ver), 
                              list]);
uiCreationTrace = list;
return [t, ds_list_size(t) - 1];
